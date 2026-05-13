# App Store Yayın Planı — Dula

**Uygulama:** Dula (Sport Manager Mobile)
**Bundle ID:** `com.sport.manager.mobile`
**Apple Team ID:** `K9JN47N96M`
**Sürüm:** `1.0.0` (build `1`)
**Destekli diller:** İngilizce, Rusça, Kırgızca
**Hedef platform:** iPhone + iPad (Portrait + Landscape, `LSRequiresIPhoneOS=true`)
**Kategori önerisi:** Business (birincil) / Productivity (ikincil)
**Yaş sınıfı önerisi:** 4+

---

## 0. Ön koşullar (yayına başlamadan)

- [ ] Apple Developer Program üyeliği aktif (yıllık 99 USD, Team `K9JN47N96M`)
- [ ] App Store Connect erişimi (Admin veya App Manager rolü)
- [ ] Production backend URL'i hazır ve ayakta (`BASE_URL`)
- [ ] Backend, App Store inceleyicisi için **demo hesap** sağlıyor (owner + manager)
- [ ] Gizlilik politikası URL'i (HTTPS, herkese açık) — App Privacy zorunlu
- [ ] Destek (support) URL'i (HTTPS, e-posta dahil)
- [ ] Pazarlama URL'i (opsiyonel ama önerilir)
- [ ] Üretim için ayrı bir Firebase projesi (varsa `GoogleService-Info.plist` prod sürümü)

---

## 1. Yayın aşamaları (özet)

| Faz   | Adım                       | Çıktı                                          |
| ----- | -------------------------- | ---------------------------------------------- |
| **A** | Proje hazırlığı            | Sürüm yükseltme, prod env, ikon, splash        |
| **B** | App Store Connect kurulumu | App record, bundle ID, sertifikalar, profiller |
| **C** | Görsel & metin materyali   | İkon, ekran görüntüleri, açıklamalar           |
| **D** | Build & yükleme            | Archive → TestFlight → İç test                 |
| **E** | İnceleme (Review)          | App Privacy, Export Compliance, submit         |
| **F** | Yayın sonrası              | İzleme, hotfix planı, Play Store'a geçiş       |

---

## 2. Faz A — Proje hazırlığı

### 2.1 Sürüm numarası

[app/pubspec.yaml](../../app/pubspec.yaml) → `version: 1.0.0+1` ilk yayın için doğru.
Sonraki sürümlerde:

- Hata düzeltme → `1.0.1+2`
- Küçük özellik → `1.1.0+3`
- Büyük güncelleme → `2.0.0+...`

`CFBundleVersion` (build number) her yüklemede artmalı, App Store Connect aynı build numarasını ikinci kez kabul etmez.

### 2.2 Bundle Display Name

[app/ios/Runner/Info.plist](../../app/ios/Runner/Info.plist) → `CFBundleDisplayName = "Dula"`. **App Store Connect'teki "App Name" alanı ile bire bir aynı olmalı** (max 30 karakter).

### 2.3 Ortam değişkenleri

- `dev.env` / `dev_mock.env` / `prod.env` mevcut. Prod release komutu:
  ```bash
  cd app && flutter build ipa \
    --release \
    --dart-define-from-file=prod.env \
    --export-options-plist=ios/ExportOptions.plist
  ```
- `prod.env` içeriği `BASE_URL=https://api.production.example.com` formatında olmalı, **commit edilmez** (gerekirse `.gitignore` kontrolü).

### 2.4 Bayraklar

- `Env.isMock` prod build'inde **false** olmalı. Mock auth kaynağının prod'a sızmadığını manuel doğrula.
- Talker / Dio logger'ları release modunda kapalı olduğundan emin ol (kişisel veri sızdırmasın).

### 2.5 İkon ve splash

- App icon kaynağı: [app/assets/images/app_icon.png](../../app/assets/images/app_icon.png)
- Üretimi: `flutter pub run flutter_launcher_icons` (zaten yapılmış)
- **App Store icon (1024×1024)** ayrı bir dosya olarak [icons/](icons/) altına eklenmeli (alpha YOK, rounded corner YOK — App Store kendisi yuvarlar)
- Splash: `make gen-splash` ile güncel

### 2.6 İzinler (Info.plist)

Şu an Info.plist'te kullanıcı izin açıklaması (`NS*UsageDescription`) yok. Kod tabanında kamera/galeri/konum/bluetooth/mikrofon kullanılmıyor (`flutter_secure_storage` dışında). Eğer ileride eklenirse her izin için Türkçe yerine **EN/RU/KY** localized açıklama gerekir.

### 2.7 Network güvenliği

`api_client` HTTPS kullanıyor (üretim URL'i mutlaka HTTPS olmalı). ATS (App Transport Security) varsayılan ile uyumlu — Info.plist'te ATS istisnası **eklenmemeli**.

### 2.8 Build & analiz

```bash
melos run analyze-check    # warning bile çıkmamalı
melos run format-check     # CI parity
melos run unit-test
make build-runner          # .g.dart güncel
```

---

## 3. Faz B — App Store Connect kurulumu

### 3.1 App record oluşturma

App Store Connect → My Apps → "+" → New App

- **Platform:** iOS
- **Name:** `Dula`
- **Primary Language:** English (U.S.)
- **Bundle ID:** `com.sport.manager.mobile` (Developer Portal'da önceden register edilmiş olmalı)
- **SKU:** `dula-ios-001` (iç ID, değiştirilemez)
- **User Access:** Full Access

### 3.2 Bundle ID & yetenekler

Developer Portal → Identifiers → `com.sport.manager.mobile`:

- [x] Push Notifications — şu an kullanılmıyor, ileride remote config + bildirim için açılabilir
- [x] Sign in with Apple — gerekirse (auth flow'a göre)
- [x] In-App Purchase — `packages/subscription` varsa abonelik için
- [ ] Background Modes — şu an gerek yok

> **Önemli:** `packages/subscription` paketi var. Eğer abonelikler **uygulama içi alışveriş (IAP)** olarak satılacaksa Apple zorunlu kılıyor — harici ödeme entegrasyonu reddedilir (Guideline 3.1.1). Subscription model App Store Connect → Features → Subscriptions altında ayrıca yapılandırılmalı.

### 3.3 Sertifika & profil

- Distribution Certificate (App Store) — Xcode otomatik yönetebilir
- App Store provisioning profile — Xcode "Automatically manage signing"
- Manuel olarak Match/Fastlane kullanılmıyorsa Xcode > Settings > Accounts altında Apple ID girili olmalı

### 3.4 App Privacy

App Store Connect → App Privacy bölümünde her veri tipi için "topluyor mu, kim toplar, nasıl kullanır" cevaplanır. Dula için **muhtemel** veri tipleri:

- **Contact Info → Name, Email/Phone** (auth için, hesaba bağlı)
- **Identifiers → User ID** (auth tokenı, hesaba bağlı)
- **Usage Data → Product Interaction** (Firebase Analytics aktifse, hesaba bağlı değil → Analytics)
- **Diagnostics → Crash Data, Performance Data** (Crashlytics aktifse)

Detay [metadata/privacy.md](metadata/privacy.md) içine yazılacak.

### 3.5 Vergi & banka bilgileri

Uygulama ücretsiz olsa bile **Paid Apps Agreement** abonelik için imzalanmalı. App Store Connect → Agreements, Tax, and Banking.

---

## 4. Faz C — Görsel & metin materyali

### 4.1 İkon — [icons/](icons/)

- `app_store_icon_1024.png` — 1024×1024, PNG, **alpha kanalı YOK**, RGB, sRGB color profile

### 4.2 Ekran görüntüleri — [screenshots/](screenshots/)

Apple zorunlu boyutlar (en az birini hazırlamak yeterli, ama 6.7" + 6.5" + 12.9" iPad önerilir):

| Cihaz                                        | Boyut                    | Min sayı | Max sayı |
| -------------------------------------------- | ------------------------ | -------- | -------- |
| **6.9" iPhone (Pro Max, iPhone 16 Pro Max)** | 1320×2868                | 3        | 10       |
| **6.7" iPhone (older Pro Max)**              | 1290×2796                | 3        | 10       |
| **6.5" iPhone (XS Max / 11 Pro Max)**        | 1284×2778 veya 1242×2688 | 3        | 10       |
| **5.5" iPhone (8 Plus)**                     | 1242×2208                | 3        | 10       |
| **12.9" iPad Pro (3rd-6th gen)**             | 2048×2732                | 3        | 10       |
| **iPad Pro M4 13"**                          | 2064×2752                | 3        | 10       |

> Apple, 6.9"/6.7"'i otomatik küçük cihazlara ölçekler — 6.5" ve 5.5" tek başına yetmez, **en yeni boyutu mutlaka ver**.

Her dil (en, ru, ky) için ayrı set. Önerilen senaryo (5 görüntü):

1. **Login / Welcome** — "Tek yerden tüm tesisini yönet"
2. **Venues list** — tesis seçim ekranı
3. **Tables / Live sessions** — aktif masa, oturum başlat/bitir
4. **Reports / KPI** — gelir, manager performansı
5. **Subscription** — plan detayı

### 4.3 App Preview videoları (opsiyonel)

- 15-30 sn, sessiz veya müzikli, cihaz framesiz, gerçek uygulama içi kayıt
- İlk sürümde atlanabilir, v1.1 için planlanabilir

### 4.4 Açıklamalar — [descriptions/](descriptions/)

Her dil için ayrı:

- **App Name** (max 30): `Dula`
- **Subtitle** (max 30): `Spor tesisi yönetimi` (loc karşılığı)
- **Promotional Text** (max 170, yayın sonrası değişebilir — re-review gerekmez)
- **Description** (max 4000): uzun açıklama
- **Keywords** (max 100, virgülle ayrılmış)
- **What's New** (max 4000, her sürümde değişir)

### 4.5 URL'ler

- **Support URL** (zorunlu): örn. `https://dula.app/support`
- **Marketing URL** (opsiyonel)
- **Privacy Policy URL** (zorunlu): örn. `https://dula.app/privacy`

### 4.6 Yaş derecelendirmesi

4+ — şiddet, müstehcen içerik, kumar (saymıyoruz), korkutucu tema, sınırsız web erişimi yok.

### 4.7 Kategori

- **Primary:** Business
- **Secondary:** Productivity

---

## 5. Faz D — Build & yükleme

### 5.1 Pre-flight

```bash
make pod-install                           # temiz pod kurulumu
melos run analyze-check
melos run unit-test
make build-runner
```

### 5.2 Sürüm artır

[app/pubspec.yaml](../../app/pubspec.yaml) içinde `version: 1.0.0+1` — ilk submit için bu doğru. Her TestFlight yükleme için build (`+N`) artır.

### 5.3 Archive (Xcode)

1. `cd app && open ios/Runner.xcworkspace`
2. Top bar → **Any iOS Device (arm64)**
3. Product → Archive
4. Archive bitince Organizer açılır → Distribute App → **App Store Connect** → Upload → Automatically manage signing

### 5.4 Alternatif: CLI

```bash
cd app
flutter build ipa \
  --release \
  --dart-define-from-file=prod.env \
  --export-options-plist=ios/ExportOptions.plist
xcrun altool --upload-app -f build/ios/ipa/*.ipa \
  -t ios -u "<apple-id>" -p "<app-specific-password>"
```

(`ExportOptions.plist` oluşturulmalı: `method=app-store`, `teamID=K9JN47N96M`, `signingStyle=automatic`)

### 5.5 TestFlight

- Yüklenen build App Store Connect → TestFlight altında çıkar (10-30 dk işleme)
- **Internal Testing:** Team üyeleri için anında — geliştirici test eder
- **External Testing:** dış davetliler için Beta App Review gerekir (~24 saat)
- En az 1 turda dış kullanıcı testi önerilir

### 5.6 Export Compliance

Build yüklenince App Store Connect "Does your app use encryption?" sorar. Dula HTTPS dışında kripto kullanmıyor → **"Standart kripto, exemption"** seçilir. Tek seferlik plist anahtarı:

```xml
<key>ITSAppUsesNonExemptEncryption</key>
<false/>
```

bunu [app/ios/Runner/Info.plist](../../app/ios/Runner/Info.plist) içine eklemek sorunun her sürümde tekrar sorulmasını engeller.

---

## 6. Faz E — App Review

### 6.1 Submission paketi

Version → "Prepare for Submission" altında doldurulacak:

- [ ] Açıklamalar (3 dil)
- [ ] Ekran görüntüleri (3 dil × en az 6.9"+6.7"+12.9" iPad)
- [ ] 1024 icon
- [ ] Support / Marketing / Privacy URL
- [ ] App Review demo hesabı (username + password) — backend'in stable test hesabı sağlaması şart, aksi halde **Guideline 2.1 ile reddedilir**
- [ ] App Review notes — kısa: "Login: owner / Test1234. Manager invite code: INVITE-001."
- [ ] App Privacy answers
- [ ] Content rights
- [ ] Advertising identifier (IDFA): kullanmıyoruz

### 6.2 Sık karşılaşılan red sebepleri & önlemler

| Guideline                 | Risk                          | Önlem                                                       |
| ------------------------- | ----------------------------- | ----------------------------------------------------------- |
| 2.1 Minimal Functionality | App içi boş ekran/placeholder | Tüm feature'lar fonksiyonel olmalı, mock değil              |
| 2.1 Demo Account          | İnceleyici giremiyor          | Stabil demo hesap + uygulama notunda kimlik bilgisi         |
| 3.1.1 Payments            | Harici ödeme                  | Abonelik IAP olarak girilmeli, web link ile yönlendirme YOK |
| 4.0 Design                | Düşük kalite ekran görüntüsü  | Gerçek ekran, framesiz, doğru çözünürlük                    |
| 5.1.1 Data Collection     | Eksik App Privacy             | Topladığın her veri için cevap                              |
| 5.1.2 Account Deletion    | Hesap silme yok               | Uygulamada **hesap silme** akışı zorunlu (2022'den beri)    |
| 5.1.5 Location            | NS\*UsageDescription eksik    | İzin metinleri 3 dilde                                      |

> **Aksiyon:** Hesap silme akışı uygulamada var mı kontrol et. Yoksa submit öncesi mutlaka ekle (Settings → "Hesabımı sil" → onay → backend `/account/delete`).

### 6.3 Submit

"Submit for Review" → tipik 24-48 saat içinde cevap. "In Review" durumu 1-12 saat sürer.

### 6.4 Onay sonrası yayın

- **Automatically release:** onay sonrası anında store'da
- **Manually release:** sen butona basana kadar bekler — **ilk sürüm için manuel önerilir** (son anda backend hazır olmazsa)
- **Phased release:** 7 gün boyunca %1 → %100 — ilk yayın için aktive et

---

## 7. Faz F — Yayın sonrası

### 7.1 İzleme

- App Store Connect → App Analytics: indirme, çökme, retention
- Firebase Crashlytics aktifleştir (kod tabanında interface var, henüz wire değil)
- Firebase Analytics: temel funnel (signup, login, sessionStart)
- Apple Sandbox vs Production subscription event'leri ayrı

### 7.2 Hotfix planı

- Kritik bug: yeni sürüm + "Expedited App Review" talebi (gerekçeli, yılda sınırlı hak)
- TestFlight'a önce yükle, 30 dk içinde duman testi, sonra submit

### 7.3 Play Store'a geçiş

App Store onayı alındıktan sonra `deploy/play_store/` klasörünü açıp şu farkları planla:

- Android adaptive icon (foreground/background katmanları)
- Feature graphic (1024×500) — App Store'da karşılığı yok
- Data Safety formu (App Privacy'ye paralel)
- App Bundle (`.aab`) imzalama — `key.properties` + upload key

---

## 8. Süre tahmini

| Faz                           | Süre                         |
| ----------------------------- | ---------------------------- |
| A — Proje hazırlığı           | 1-2 gün                      |
| B — App Store Connect kurulum | 0.5 gün                      |
| C — Görsel & metin            | 2-3 gün (en kritik darboğaz) |
| D — Build & TestFlight        | 0.5 gün + iç test 1-3 gün    |
| E — Review                    | 1-3 gün                      |
| **Toplam (ilk sürüm)**        | **~7-10 iş günü**            |

---

## 9. Kalan açık sorular (yayın öncesi karara bağlanmalı)

- [ ] **App Name kesin mi?** `Dula` → marka çakışması var mı (Apple isim kontrolü yapar)?
- [ ] **Abonelik IAP mu, harici mi?** Eğer IAP zorunluysa `packages/subscription` mevcut REST akışı `StoreKit` ile değiştirilmeli veya hibrit yaklaşım belirlenmeli.
- [ ] **Hesap silme akışı uygulamada var mı?** Yoksa zorunlu — `features/profile/` veya `features/settings/` altına eklenmeli (Apple 5.1.1(v) — 30 Haziran 2022).
- [ ] **Production backend URL'i ve demo hesap** Apple inceleyicisinin erişebileceği şekilde hazır mı?
- [ ] **Privacy Policy ve Support URL'leri** yayınlanmış mı?
- [ ] **Firebase prod ortamı** kurulmuş mu (Crashlytics + Analytics + Remote Config)?
- [ ] **TR dilini eklemek mi gerekir?** Uygulama içi TR yok ama Türkiye pazarı hedefse en azından App Store metadata'sında TR localized version planlanabilir.

---

## Kontrol listesi

Submission öncesi tek tek doğrula: [checklist.md](checklist.md)
