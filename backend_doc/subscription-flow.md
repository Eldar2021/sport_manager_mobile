# Subscription — Ürün Akışı (Flow Spec)

> Bu dokümanın amacı: Sport Manager Mobile'da owner'ın **uyelik** (subscription) sisteminin **nasıl çalışacağını** uçtan uca anlatmak. Bu doküman onaylandıktan sonra `subscription-api.md` (backend kontratı) ve daha sonra `subscription-mobile.md` (Flutter implementasyon planı) yazılacak.
>
> **Status:** Draft v1 · 2026-04-30 · iterasyona açık.
> **Audience:** Ürün + Backend + Mobile.

---

## 1. Genel mantık

Sport Manager Mobile bir **Owner-paid SaaS**. Manager hesapları ücretsizdir; ücretler her zaman owner üzerinden alınır. Manager, owner'ının abonelik durumundan etkilenir (owner blocked → manager da blocked).

### 1.1 Fiyat modeli — masa başına aylık

Eski plan ("mekan başına 1000 som / ay") **adil değildi**: 2 masalı bir owner ile 20 masalı bir owner aynı parayı ödüyordu.

Yeni plan: **`pricePerTable × tableCount × months`**.

- `pricePerTable` — config değeri. MVP'de **200 KGS / masa / ay**. **Hardcode YOK** — backend `GET /subscription/pricing` ile gönderir, mobile bu değeri her hesaplamada anlık çeker. Backend `pricePerTable`'ı değiştirdiğinde uygulamayı redeploy etmeden fiyat değişebilmeli.
- `tableCount` — owner'a bağlı, soft-delete edilmemiş **tüm mekanların toplam masa sayısı** (anlık, hesaplama yapıldığı andaki snapshot). Sadece bir mekanın değil, hepsinin toplamı.
- `months` — kullanıcı seçer. **Min 1 ay**. Üst sınır config değeri (öneri: 12). Sadece tam ay (yarım ay yok).
- `currency` — şimdilik **KGS** sabit. İleride owner'ın bölgesine göre değişebilir → backend pricing endpoint'i `currency` field'ı da döner.

**Formül:**

```
totalAmount = pricePerTable × tableCount × months
```

**Örnek:** Owner A — 2 mekan, 7 + 3 = 10 masa, 1 ay → `200 × 10 × 1 = 2 000 KGS`.
**Örnek:** Owner B — 1 mekan, 2 masa, 3 ay → `200 × 2 × 3 = 1 200 KGS`.

### 1.2 Snapshot kuralı — fiyat ve masa sayısı

Ödeme yapıldığı anda hem `pricePerTable` hem `tableCount` **snapshot edilir** ve `Payment` kaydına yazılır. Sonradan owner masa eklerse:

- Eklenen masa **mevcut subscription periyodunu etkilemez** — sonraki ödeme döneminde yeni sayı kullanılır.
- Owner masa silerse iade yapılmaz (MVP).

Bu, session snapshot kuralı (`tarifAmountSnapshot`) ile aynı felsefe: ödeme anındaki değerle hesap kapanır.

> **Açık soru:** Owner periyot ortasında masa eklerse "pro-rata" upgrade alıp aradaki farkı tahsil etmek istiyor muyuz? **MVP'de hayır**, v2'de düşünülebilir.

---

## 2. Subscription yaşam döngüsü

Her owner'ın tek bir **active subscription** kaydı vardır (`status: ACTIVE | GRACE | EXPIRED`). Bunlar arasındaki geçişler **backend tarafından** yapılır — istemci sadece okur ve UI'ı buna göre çizer.

```
                       ┌──────────────────────────┐
   register/free trial │  ACTIVE                  │
   ───────────────────►│  endDate > today + 3d    │
                       └──┬───────────────────────┘
                          │  endDate - today ≤ 3
                          │  (her gün 24:00'te recompute)
                          ▼
                       ┌──────────────────────────┐
                       │  ACTIVE (warning state)  │
                       │  3 / 2 / 1 gün kaldı     │
                       │  → "Continue" butonu     │
                       └──┬───────────────────────┘
                          │  endDate ≤ today
                          ▼
                       ┌──────────────────────────┐
                       │  GRACE (5 gün)           │
                       │  graceRemaining: 5..0    │
                       │  → NOTE banner           │
                       │  → "Continue" butonu     │
                       │  features: çalışıyor     │
                       └──┬───────────────────────┘
                          │  graceRemaining = 0
                          ▼
                       ┌──────────────────────────┐
                       │  EXPIRED                 │
                       │  → core features BLOKE   │
                       │  → "Continue" butonu     │
                       └──────────────────────────┘
                          │  ödeme başarılı
                          ▼
                       (yeni periyot başlar → ACTIVE)
```

**Status değerleri (kontrat):**

| Status    | Backend ne döner       | UI nasıl çizer                            | Ana özellikler |
| --------- | ---------------------- | ----------------------------------------- | -------------- |
| `ACTIVE`  | `daysUntilExpiry > 3`  | Yeşil rozet, buton **YOK**                | Açık           |
| `ACTIVE`  | `daysUntilExpiry ≤ 3`  | Sarı/turuncu rozet, **Continue** butonu   | Açık           |
| `GRACE`   | `graceDaysRemaining ≥ 1` | Üstte sarı NOTE banner, **Continue** butonu | Açık |
| `GRACE`   | `graceDaysRemaining = 0` | Üstte kırmızı NOTE banner, **Continue** butonu | **Bloke** |
| `EXPIRED` | always                 | Kırmızı banner, **Continue** butonu       | **Bloke**       |

> Backend "warning" diye ayrı bir status üretmez — `ACTIVE` döner ve mobile `daysUntilExpiry ≤ 3` ise warning UI'ı gösterir. Tek source of truth: `endDate` ve `graceDaysRemaining`.

> **Not:** `GRACE` ile `daysRemaining = 0` durumu, kullanıcı için "ödeme yapmadan ana özellikleri kullanamazsınız" durumudur. Backend `EXPIRED`'a günün sonunda (cron) geçirebilir; mobile her iki durumu (GRACE@0, EXPIRED) aynı UI ile çizer. Backend için pratik öneri: günün sonunda otomatik `EXPIRED`'a düşür.

### 2.1 İlk subscription — free trial

Yeni owner kayıt olduğunda hemen ödeme istemek kötü UX. Çözüm: **N günlük ücretsiz deneme**.

- `freeTrialDays` config değeri (öneri: **14 gün**).
- Register başarılı olduğunda backend otomatik `Subscription { status: ACTIVE, startDate: now, endDate: now + 14d, source: "TRIAL" }` oluşturur.
- Trial döneminde uyelik sayfasında "Free Trial" rozeti gösterilir; geri sayım 3 güne düştüğünde "Continue" butonu çıkar.
- Trial bittiğinde GRACE/EXPIRED akışı normal işler.

> **Karar gereken:** Free trial sonunda 5 gün grace yine olsun mu, yoksa trial expire olur olmaz block mu? **Öneri:** olsun — kullanıcıya nazik olmak için ve kuralı tek tutmak için.

### 2.2 Manager — abonelik kapsamı

Manager subscription'ı **owner'ından devralır** — bağımsız bir abonesi yoktur.

- Owner `EXPIRED` ise, manager girişte aynı blocked-screen'i görür.
- Manager profilinde "uyelik" tile'ı **gösterilmez** (sadece owner görür).

---

## 3. Hangi özellikler "BLOKE" oluyor?

EXPIRED veya GRACE@0 durumunda — uygulama tamamen kapanmaz, ancak **para üreten / state değiştiren** aksiyonlar engellenir. Read-only erişim açık kalır ki owner verilerine bakabilsin.

| Özellik                              | Active | Grace (≥1) | Grace@0 / Expired |
| ------------------------------------ | :----: | :--------: | :---------------: |
| Login / logout                       |   ✅   |     ✅     |        ✅         |
| Profile / subscription görme         |   ✅   |     ✅     |        ✅         |
| Subscription ödeme yapma             |   ✅   |     ✅     |        ✅         |
| Mekan listesi görme                  |   ✅   |     ✅     |        ✅         |
| Masa listesi görme                   |   ✅   |     ✅     |        ✅         |
| **Session start / pause / resume / finish** |   ✅   |     ✅     |        ❌         |
| **Mekan / masa create / update / delete** |   ✅   |     ✅     |        ❌         |
| **Manager invite (POST `/auth/invite-code`)** |   ✅   |     ✅     |        ❌         |
| Manager listesini görme              |   ✅   |     ✅     |        ✅         |
| Şifre değiştirme                     |   ✅   |     ✅     |        ✅         |
| Hesap silme                          |   ✅   |     ✅     |        ✅         |

> Reports / analytics ekranı: read-only, açık.

**Backend tarafında uygulama:** EXPIRED owner'ın `POST /api/v1/session/start` gibi yazma endpoint'lerine `403 SUBSCRIPTION_REQUIRED` döner. Mobile bu kodu yakalayıp dialog gösterir + Continue butonu sunar.

**Mobile tarafında soft-block:** UI seviyesinde, EXPIRED durumunda Home ekranındaki "boş masa kartına basıldığında start" akışı **basılınca dialog açar** ("Devam etmek için aboneliği yenileyin"). Yani kullanıcı network'e yazma isteği bile atmaz. Backend kontrolü ikinci savunma hattı.

---

## 4. Profile entry point

Profile sayfasında zaten **Subscription** tile'ı var ([app/lib/features/profile/widgets/user_profile_extra_data.dart:34-43](../app/lib/features/profile/widgets/user_profile_extra_data.dart#L34-L43)) ama `onTap: () {}` boş. Bu task kapsamında:

- Tile sadece **OWNER** için gösterilir (mevcut davranış zaten böyle değil — düzelteceğiz; manager'a bu tile gözükmemeli).
- Subtitle, status'a göre lokalize:
  - ACTIVE (warning değil): `"Active · until {date}"` (mevcut metin korunur)
  - ACTIVE (≤3 gün): `"Expires in {n} days"` — sarı vurgu
  - GRACE: `"Grace period · {n} days left"` — sarı/kırmızı
  - EXPIRED: `"Expired"` — kırmızı
- Tap → `AppRoutes.subscription` ekranına push.
- Profile fetch'i artık subscription'ın hafif özetini de getiriyor (status + endDate). Ayrı bir fetch yok, profile içine **embed** edilir → ekstra round-trip yok. Ama subscription detay ekranında full liste için ayrı endpoint (`GET /subscription`) çağrılır.

---

## 5. Subscription detay ekranı — `AppRoutes.subscription`

`features/subscription/view/subscription_view.dart`. Profile'dan push, geri ok ile dön. `AppButtonScope` sarmalı, `Continue` butonu varsa `collapseOnScroll`.

### 5.1 Sayfa yapısı (yukarıdan aşağı)

1. **AppBar** — `Subscription` başlığı, geri ok.
2. **Status banner** (sadece warning/grace/expired'da) — üstte; renk ve metin status'a göre:
   - **Warning (ACTIVE, ≤3 gün)** — turuncu hint banner: `"Your subscription expires in {n} days. Renew to avoid interruption."`
   - **Grace (≥1)** — sarı info banner: `"Subscription expired. {n} day(s) of grace period left."`
   - **Grace@0 / EXPIRED** — kırmızı filled banner: `"Subscription expired. Renew to use core features."`
3. **Plan kartı** — primary gradient (work/subscription.png'deki turuncu kart, ama metin değişiyor):
   - Üstte rozet: ACTIVE / GRACE / EXPIRED + ikon
   - "Current plan"
   - **Büyük metin:** `"{pricePerTable} {currency} / table / month"` (örn `200 сом / масса / месяц`)
   - Altta: `"× {tableCount} tables = {monthly} {currency} / month"`
4. **Detay listesi** — `Card` içinde row'lar:
   - `Next payment` → endDate veya "—" (EXPIRED ise "—")
   - `Last payment` → son `Payment` tarih + tutar
   - `Status` → lokalize status
5. **Payment history** — başlık + scroll'lu liste:
   - Her item: tarih (sol), tutar (sağ), küçük "✓" iconu, alt satırda `"{months} months × {tableCount} tables"` özet.
   - Boşsa `"No payments yet"` placeholder + free trial banner'ı (varsa).
6. **FAB / collapseOnScroll button** (status warning/grace/expired ise):
   - `Continue subscription` → calculate ekranına push.

Design referansı [work/subscription.png](subscription.png) bu yapıyı verir, sadece kart başlığı "1000 сом / зал" yerine "200 сом / масса" olur ve `× 3 zal` yerine `× N table` olur.

### 5.2 Skeleton / loading / error

- İlk açılışta `DataLoading` → `SubscriptionSkeleton` (üç gri shimmer kart).
- Hata → `SubscriptionErrorView` (mevcut `ProfileErrorView` örneği gibi, retry'lı).
- Pull-to-refresh açık.

---

## 6. Continue subscription akışı

Continue butonuna basınca → **calculate ekranı** açılır.

### 6.1 Calculate ekranı — `AppRoutes.subscriptionCheckout`

`features/subscription/view/subscription_checkout_view.dart`.

**Açılırken** mobile şunları biliyor olmalı (ya entry'den parametre, ya bu ekranda fetch):

- `pricePerTable`, `currency`, `minDurationMonths`, `maxDurationMonths` — `GET /subscription/pricing`'den.
- `tableCount` — owner'ın anlık toplam masası. Profile/subscription endpoint'inden ya da `GET /subscription/pricing` response'una embed edilebilir (öneri: embed → tek istek).

**Yapı:**

1. Üstte özet kartı:
   - "{tableCount} masa × {pricePerTable} {currency} = {monthly} {currency} / month"
2. **Süre seçici** — counter widget veya pill row (`1 month`, `3 months`, `6 months`, `12 months`) + custom input. Min `minDurationMonths` (1), max `maxDurationMonths` (12). Slider yerine **stepper +/-** veya **chip group** öneririz — daha az hata.
3. **Total amount** kartı — büyük yazı:
   - `{months} months × {monthly} {currency} = {totalAmount} {currency}`
   - Alt satır: ödeme sonrası yeni `endDate` preview (`"New end date: 30 May 2026"`).
4. **Pay** butonu — primary, `AppButton(isLoading: ...)`. Ödeme ekranına push.

`tableCount = 0` (owner hiç masa eklememiş) durumu: total `0` olur, ödeme yaptırmıyoruz. Bunun yerine "Add at least one table to subscribe" empty state + "Go to venues" butonu. (Kullanıcı edge case bu — önce masa açar, sonra ödeme.)

### 6.2 Ödeme ekranı — `AppRoutes.subscriptionPayment`

**MVP'de mock** — Finik (3rd-party) sonradan entegre edilecek. Mobile:

1. `POST /subscription/checkout { months }` — backend `Payment` kaydı oluşturur (`status: PENDING`), 3rd-party redirect URL döner.
2. **Mock mode:** `payment_url` boş gelirse mobile mock ekranı açar — fake "Pay with card" formu, "Simulate success" / "Simulate failure" butonu.
3. **Real mode (v2):** `payment_url` ile `WebView` veya external browser açılır. Finik callback yaptıktan sonra mobile pollar:
   - `GET /subscription/payment/{paymentId}` 5sn aralıkla, max 60sn → `PAID` / `FAILED` / `PENDING`.
   - Webhook server-side (`Finik → backend`) zaten subscription'ı uzatmış olur; mobile sadece okuyup ekranı günceller.

**Sonuç:**

- `PAID` → success bottom sheet ("Subscription extended until {newEndDate}"), profile'a geri (popUntil), profile fetch refresh.
- `FAILED` → error dialog, "Try again" / "Cancel".
- `PENDING > 60s` → "We're still processing… check back later" empty-state.

> **Karar gereken:** MVP'de webhook yok, mobile direkt `POST /subscription/checkout` mock-PAY edip backend hemen `endDate += months` yapacak mı? **Öneri:** evet, MVP için en hızlı yol; v2'de gerçek Finik entegre edilince webhook devreye girer.

---

## 7. Tarih hesapları — net kurallar

`endDate` her zaman backend tarafından hesaplanır. Mobile **sadece gösterir**.

- **Yeni periyot başlangıcı (renewal):**
  - Eğer mevcut endDate hala gelecekteyse (early renew): `newEndDate = oldEndDate + months × 30 days`. **30 gün = 1 ay** kabulü; takvim ay'ı değil. Daha basit, daha az corner case (28/29/31 gün dramı yok).
  - Eğer mevcut endDate geçmişteyse (GRACE / EXPIRED): `newEndDate = today + months × 30 days`.
- **`daysUntilExpiry`** = `floor((endDate - now) / 24h)`. Negatif olabilir (mobile'a gönderilirken `0`'a clamp edilir; ayrıca status gönderilir).
- **`graceDaysRemaining`** = sadece `status = GRACE` iken; `floor((endDate + graceDays - now) / 24h)`.
- **Server time** kullanılır (login sırasında hesaplanan `server_time_offset`). Manager'ın telefon saatini değiştirip "uyeliği uzatması" engellenir.

> 30-day-month yaklaşımı bilinçli — kullanıcı "1 ay uzattım" diyince 30 gün gelir. Backend takvim ayı kullanmak isterse alternative açık ama önerimiz 30 gün.

---

## 8. Localization gereksinimi

Tüm metinler `app_en/ru/ky.arb`'a girilecek. Anahtar prefix'i: `subscription...` (örn `subscriptionTitle`, `subscriptionStatusActive`, `subscriptionContinueCta`, `subscriptionGraceNote`). Status / banner / kart metni / ödeme akışı / hata mesajları — hepsi.

Para formatı: `intl` `NumberFormat.currency(locale, symbol: 'KGS')` kullanılır; veya basit format: `"$amount $currency"`.
Tarih formatı: mevcut profil ekranındaki `DateFormat('d MMMM yyyy', languageCode)` aynısı.

---

## 9. Backend sorumlulukları (özet)

Detay `subscription-api.md`'ye gidecek; burada akış için kritik olanlar:

1. **Daily cron (00:00 UTC)** — her aktif subscription için:
   - `endDate < today` ise → `status = GRACE`, `gracePeriodEndsAt = endDate + graceDays`.
   - `gracePeriodEndsAt < today` ise → `status = EXPIRED`.
   - Her transition için (opsiyonel) push notification: "Aboneliğinin 3 günü kaldı", "Aboneliğin bugün bitti", "Grace süresi doldu".
2. **Yetki middleware** — tüm yazma endpoint'lerinde owner subscription kontrolü:
   - `EXPIRED` → `403 SUBSCRIPTION_REQUIRED`. Manager isteğinde owner subscription'ına bakılır.
3. **`GET /subscription/pricing`** — mobile her hesaplamada anlık çeker, **cache yok**.
4. **`GET /subscription`** — owner'ın aktif subscription'ı + payment history.
5. **`POST /subscription/checkout`** — fiyat doğrulama (mobile'dan gelene güvenilmez, anlık `pricePerTable × tableCount × months`'tan hesaplar), `Payment` kaydı oluşturur, `payment_url` döner.
6. **`POST /subscription/payment/{id}/confirm`** (mock için) — gerçek Finik'te webhook olacak, MVP'de mobile bu mock-confirm'ı çağırır.

---

## 10. Mobile sorumlulukları (özet)

Detay `subscription-mobile.md`'ye gidecek; burada akış için kritik olanlar:

- **`packages/subscription/`** — yeni package. `models/`, `source/remote/`, `repository/SubscriptionRepository`. `core` + `api_client`'a depend eder. (managers paketi şablonu).
- **`features/subscription/`** — `cubits/`, `view/` (subscription, checkout, payment), `widgets/`. Single-page cubit pattern (ownership kuralı: bir sayfaya bağlı cubit `BlocProvider`'a sarılmaz).
- **Pricing değeri ve currency** — config, env'de değil, **runtime fetch**.
- **EXPIRED soft-block** — Home'da masa kartına basışta `SubscriptionGate` kontrolü → dialog. AuthCubit'e benzer `SubscriptionCubit` global state taşır (BlocProvider app root).
- **Push notification entegrasyonu** — bu task kapsamında DEĞİL (Firebase henüz bağlı değil, `pubspec.yaml`'da yorum satırı).

---

## 11. Açık sorular / karar gerekenler

1. **Free trial süresi** — 14 gün öneriyorum, sen söyle.
2. **Trial sonu grace** — trial bitince de 5 gün grace olsun mu? Öneri: evet.
3. **Pro-rata upgrade** — periyot ortasında masa eklenirse fark alınsın mı? Öneri: hayır (MVP).
4. **30-day month vs takvim ayı** — endDate hesaplamasında 30 gün öneriyorum; takvim ayı isterseniz "1 ay = +1 calendar month" kullanırız.
5. **Push notifications** — abone bitiyor uyarısı için push lazım mı? MVP'de no, app içi banner ile çözüyoruz.
6. **Payment provider** — MVP'de mock; Finik için spesifik integration sözleşmesi var mı? Yoksa generic `payment_url` redirect kalıbı kullanırız.
7. **Currency** — KGS sabit mi, yoksa owner-region'a göre mi? MVP'de KGS sabit, backend yine de `currency` field'ı dönsün ki future-proof.
8. **Refund** — owner abonelikten cayarsa iade var mı? MVP'de **hayır**; doküman silmeden buraya yazıyorum.
9. **Multiple owners aynı şirketten** — şu an her owner bağımsız. Birden fazla owner aynı abonelikte birleşsin gibi bir senaryo MVP dışı.

---

## 12. Görsel referans

[work/subscription.png](subscription.png) — eski (mekan-başına) tasarımın görüntüsü. Yeni tasarımda:

- Plan kartında "1000 сом / зал / месяц" → "200 сом / масса / месяц"
- "× 3 залов = 3000 сом" → "× {tableCount} masa = {totalMonthly} сом"
- Üstte status (warning / grace / expired) banner'ı eklenir
- Altta "Continue subscription" FAB (status warning/grace/expired ise)

Tasarım finali değil — implementasyon sırasında `theme-system.md` token'ları ile (`AppColors`, `AppSpacing`, `AppRadius`) çizilecek.

---

## 13. Hazır olunca sıradaki adım

Bu dokümanı **onaylar onaylamaz**:

1. `backend_doc/subscription-api.md` yazılacak (auth-api.md / managers-api.md kalıbı, Türkçe + JSON şemalar).
2. Onun onayından sonra `docs/subscription-mobile.md` yazılacak (architecture.md / code-rules.md kalıbı, Flutter implementasyon planı: yeni package, feature klasörü, route'lar, cubit'ler, soft-block stratejisi, l10n key listesi).
3. Onun da onayından sonra implementasyon başlar.
