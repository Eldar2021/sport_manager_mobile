# Reports & Analytics — Mobile Design Plan

> Sport Manager Mobile için Owner'a yönelik **Rapor / İş Analizi** özelliğinin
> tasarımı. Bu doküman feature'ın **vizyonunu, user/business flow'unu, ekran
> haritasını, fraud (şüpheli aktivite) tespit mantığını, KPI tanımlarını,
> önerilen backend kontratını** ve mobile mimarisini kapsar.
>
> **Audience:** Product owner + mobile dev (Claude / insan). Onaylanırsa
> `packages/reports/` ve `features/reports/` bu plana göre kurulur.
> **Status:** Draft v1 · 2026-05-01.
> **Referans tasarım:** [`work/report.png`](../work/report.png) — bu dokümanda
> "Reports Overview" ekranının başlangıç hali olarak alınıyor; üzerine fraud
> sekmesi, manager karşılaştırması, insights ve forecast eklenecek.

---

## 1. Neden bu feature kritik

Owner uygulamayı **yönetim aracı** olarak değil **iş zekası aracı** olarak
satın alıyor. Masa açıp kapama (session) zaten manager'ın işi; owner için
asıl değer şu sorulara **net cevap görmek**:

1. **Para hangi şubeden, hangi masadan geliyor?** Hangi masa kâr getirmiyor,
   kapatılmalı veya tarifesi değişmeli?
2. **Hangi manager iyi çalışıyor, hangisi kötü, hangisinin para çalma
   ihtimali var?** İşletmecinin manager'a güveni sınırsız değil — uygulama
   "objektif kanıt" sunmalı.
3. **Bu tempoda devam edersek ay sonunda ne olacak? Geçen aydan iyi mi
   kötü mü gidiyoruz?**
4. **Şu an ne yapmalıyım?** (Bir masa kapatmak, bir manager'la konuşmak,
   bir şubenin tarifesini artırmak, vs.) Owner rakam okuyacak vakti yok —
   uygulama sonuca dönük öneri vermeli.

Bu dört sorudan biri bile cevapsız kalırsa Owner abonelik yenilemeyecek.
Reports feature'ı bu yüzden **subscription'ın asıl value prop'u**.

---

## 2. Kullanıcı (Owner) profili & "jobs to be done"

| Anlık ihtiyaç                                | Yaptığı şey                                                       |
| -------------------------------------------- | ----------------------------------------------------------------- |
| Sabah hızlıca dünkü hasılat                  | Reports → Bugün/Dün — tek bakışta toplam, ortalama, anomali.      |
| Ay başı muhasebe / vergi                     | Reports → Ay → Export (PDF/CSV) — tüm session listesi.            |
| Yeni şube açma kararı                        | Reports → Yıl → şube karşılaştırması.                             |
| Şüphe ("kasa eksik geliyor")                 | Reports → Manager → fraud risk paneli + cancel/discount listesi.  |
| Bir masayı kapatma kararı                    | Reports → Masa → 30/90 günlük gelir + occupancy.                  |
| Ay sonu tahmini ("kira yetişir mi?")         | Reports → Forecast — bu tempo + öngörü.                           |
| "Bana sadece önemli olanı söyle"             | Reports overview üstündeki Insights kartları.                     |

> Reports feature'ı manager'a kapalı (`OWNER` only). Mobile'da bottom-nav'da
> "Otçet" sekmesi sadece role=OWNER olduğunda görünür.

---

## 3. Bilgi mimarisi (information architecture)

```
Reports (bottom nav: 2. tab)
│
├── Overview (varsayılan)
│   ├── Insights strip       ← otomatik üretilen 0-3 kart (alert/warning/info)
│   ├── Period chips         ← Bugün · Hafta · Ay · Yıl · Custom
│   ├── Venue picker         ← "Tüm şubeler" veya tek şube
│   ├── KPI grid (2×2)       ← gelir / session / ortalama süre / occupancy
│   ├── Revenue chart        ← günlük bar + "vs geçen dönem" hayalet hat
│   ├── Top tables           ← gelire göre sıralı, % bar
│   ├── Top/risk managers    ← isim · gelir · cancel% · risk rozeti
│   └── Forecast özeti       ← "Bu tempoda ay sonu ~165 000 сом (+12%)"
│
├── Venue Detail            ← Top tables / Top managers / Venue stats
│
├── Table Detail            ← Saat-gün heatmap, gelir trendi, occupancy
│
├── Manager Detail          ← KPI + fraud paneli + session log
│
├── Insights Inbox          ← Tüm geçmiş insight'lar (overview'da sadece son 3)
│
└── Forecast (full)         ← 30/90 günlük tahmin grafiği + senaryolar
```

Drill-down kuralı: **hep yukarıdan aşağıya, asla yatay**. Manager → Table'a
gitmek yok; Owner mantığında "şube → masa → manager" hiyerarşisi var.

---

## 4. User flow (Owner perspektifinden)

### 4.1 Günlük rutin — "iş nasıl gidiyor?"

```
Owner login
  ↓
Home (kendi mekanları) — opsiyonel
  ↓ bottom nav → Reports
Reports Overview açılır
  · period: "Hafta" (cihaz hatırlar — son seçim)
  · venue: "Tüm şubeler" (default)
  · top'ta 0-3 insight: ör. "Стол 3 son 14 günde hiç açılmadı"
  · KPI grid + revenue chart + top tables + top managers
  ↓
Owner insight kartına dokunur → ilgili drill-down açılır
  veya
Owner "Tüm şubeler" yerine bir şubeyi seçer → aynı ekran o şubeyle filtrelenir
  veya
Owner alttaki bir masaya dokunur → Table Detail açılır
```

### 4.2 Şüphe akışı — "manager para mı çalıyor?"

```
Reports Overview
  ↓ "Risk" rozeti olan manager'a dokun
Manager Detail
  ├── KPI: bu manager'ın gelir, session sayısı, ortalama session değeri
  ├── Fraud panel:
  │     · Cancel oranı: 12% (ortalama: 3%)        [yüksek riskli]
  │     · İndirim oranı: 18% (ortalama: 4%)       [yüksek riskli]
  │     · 60sn altı session: 14 adet              [şüpheli]
  │     · Mesai dışı session: 3 adet              [şüpheli]
  │     · Ortalama pause süresi: 47 dk            [şüpheli]
  ├── Session log (filtrelenebilir: cancel'ler, indirimliler)
  └── CTA: "Tüm cancel'lerini gör" / "Tüm indirimlerini gör"
```

### 4.3 Karar akışı — "bu masayı kapatayım mı?"

```
Reports Overview
  ↓ "Top tables" listesinin altındaki "Tüm masalar" → Tables tab
Tables tab — gelir/occupancy'e göre sırala
  ↓ alttaki masa
Table Detail
  ├── 30 günlük gelir trendi (düşüş varsa kırmızı)
  ├── Occupancy: 8% (en düşük)
  ├── Saat heatmap: hiçbir saatte yoğunluk yok
  └── CTA: "Tarifesini düşür" / "Açılış saatini değiştir" / "Sil"
```

### 4.4 Tahmin akışı — "ay sonunda ne olacak?"

```
Reports Overview → "Forecast özeti" kartı
  ↓
Forecast (full)
  ├── Şu anki tempoda kalan günler için projeksiyon
  ├── "Geçen ay aynı tarihte" overlay
  ├── Senaryolar: "Eğer cumartesi 100k yaparsanız..."
  └── Cumulative çizgi: ay sonu beklenen toplam
```

---

## 5. Ekranlar — detay

### 5.1 Reports Overview

> Mevcut [work/report.png](../work/report.png) tasarımının evrimi. Sıralı:

1. **Insights strip (üst, opsiyonel).** 0-3 kart, yatay scroll. Backend
   kritere uyan bulgu varsa kart üretir; yoksa hiçbir şey gösterilmez (gürültü
   yapma).
   - Kart örneği: `severity=warning · "Manager Айбек bu hafta 8 cancel yaptı
     (ortalama 4 katı) — incele →"`. Tıklanırsa Manager Detail.
2. **Period chips** — `Bugün · Hafta · Ay · Yıl · Custom`. Custom seçilirse
   date-range picker bottom sheet. Son seçim local prefs'e yazılır.
3. **Venue picker** (sağ üstte chip). Bottom sheet: `Tüm şubeler · şube 1 ·
   şube 2 ...`. "Tüm şubeler" agregasyon istediğinde özel API parametre
   (`venueId` boş).
4. **KPI grid 2×2.** Her kart: ana sayı + delta (vs önceki dönem):
   - **Toplam gelir** — `142 500 сом · +8% vs geçen ay`
   - **Toplam session** — `384 · -2% vs geçen ay`
   - **Ortalama süre** — `1ç 23dk`
   - **Occupancy** — `34% · 4/6 masa şu an aktif` (başlık çift satır:
     "Aktiflik" ve altında x/y format).
   - Delta yoksa (önceki dönem datası yok) sadece ana sayı.
5. **Revenue by day** — günlük bar chart (son N gün; period'a göre N: bugün=24
   saat, hafta=7 gün, ay=30 gün, yıl=12 ay).
   - "vs geçen dönem" toggle (varsayılan kapalı, açıldığında ghost line).
   - Bar tıklanınca bottom sheet: o günün toplamı, session sayısı, top masa,
     top manager.
6. **Top tables** — gelire göre 3-5 satır. Her satır: masa adı, şube adı
   (eğer "Tüm şubeler" filtredeyse), gelir, % bar (kendi içinde 0-100%
   normalize), trend ok'u (▲/▼ son periyoda göre).
   - Tıklanınca Table Detail.
   - Listenin altında `Tüm masalar →` (Tables tabı/list sayfası).
7. **Top / risk managers** — gelire göre sıralı manager listesi; ek olarak
   her satırda **risk rozeti** (yeşil/sarı/kırmızı). Risk rozeti yüksekse
   kart kendiliğinden Insights strip'e de eklenir (duplicate olmaz çünkü
   Insights backend tarafında üretilir).
8. **Forecast özeti kartı** (alta yakın). "Bu tempoda Mayıs ayı: 165 000 сом
   (+12% vs Nisan)". Tıklanırsa Forecast full.
9. **Export butonu** (overflow menu / app-bar action).
   - PDF rapor (period + filtre)
   - CSV (session-level export — muhasebe için)

**Dikkat:**
- Tüm rakamlar **aynı para biriminde** gösterilmeli. Multi-currency için: her
  KPI kartı baskın currency'de gösterilir; tek bir kart "diğer paralar"
  detayını sheet ile açar. (MVP'de tek currency varsayımı kabul edilebilir,
  v2'de currency mix.)

### 5.2 Venue Detail

Tek şube seçildiğinde Overview'ın aynısı + ekstra:
- "Bu şubedeki manager'lar" mini liste.
- "Bu şubenin diğer şubelerdeki sırası" (yıl raporunda).
- CTA: `Şubeyi düzenle` (Venue settings'e gider).

### 5.3 Table Detail

Tek bir masanın 30/90/365 günlük performansı:

- KPI: gelir, session sayısı, ortalama süre, occupancy %, ort. ticket
- **Saat × gün heatmap** (7×24 grid) — masanın yoğunluk haritası. Sol üst
  pazartesi 00:00, sağ alt pazar 23:00. Renk: gelir yoğunluğu. Pazar 16-22
  arası koyu olmalı normal bir bilardo masasında; eğer "her saat eşit ve
  düşük" ise → masa kullanılmıyor.
- Gelir trendi: günlük bar (period boyunca).
- Trend yorumu: "+15% son 30 günde" / "düşüşte" (otomatik metin).
- CTA'lar:
  - `Tarifesini değiştir` → Home'daki edit table'a deeplink
  - `Sil` (yalnızca soft remove öneren bir confirm)

### 5.4 Manager Detail — fraud paneli (en kritik ekran)

Bu ekran **uygulamanın asıl ayrıştırıcı özelliği**. Ekranda olması gerekenler:

1. **Header.** İsim, username (`@aibek`), katılım tarihi, son aktiflik.
2. **KPI bandı (3-4 kart).**
   - Bu dönemde işlediği gelir
   - Session sayısı
   - Ortalama session değeri
   - Toplam çalışma saati (= session açık-kalma toplamı, manager'ın o anki
     aktif olduğu session sayısı × süre)
3. **Risk skoru** — 0-100. Tek sayı + kategori (`Düşük / Orta / Yüksek`). Skor
   altında "Bu skor şu sinyallerden hesaplandı" açıklaması (transparent —
   kara kutu olmasın, owner inanmalı). Detay → 5.5.
4. **Fraud sinyalleri listesi** (her biri için: değer, ortalama, threshold,
   severity).
5. **Session log** — bu manager'ın son N session'ı. Filtreler: `Tümü`,
   `İptal edilenler`, `İndirimli`, `60sn altı`, `Mesai dışı`. Her satır:
   masa, başlangıç-bitiş, süre, indirim, total, status. Tıklanınca session
   detail bottom sheet.
6. **CTA'lar.**
   - `Bu manager'ı kaldır` → Managers feature'a deeplink (DELETE manager).
   - `Mesajla` (v2 — chat / push).

### 5.5 Insights Inbox

Geçmişteki tüm insight kartları (zaman damgalı), filter: `Aktif / Çözüldü /
Yoksayıldı`. Tıklanınca aynı drill-down. Owner bir insight'ı "Yoksay" diye
işaretleyebilir; aynı sinyal 7 gün boyunca yeniden basılmaz.

### 5.6 Forecast (full)

- Period: kalan ay / 30 gün / 90 gün (chip seçici)
- Geçmiş datadan basit lineer regresyon + seasonality (haftanın günü efekti).
  Detayı 7. bölümde.
- Çıktı:
  - Cumulative çizgi (gerçek + tahmin overlay)
  - Aralık (lower/upper bound — confidence band)
  - Karşılaştırma: "Geçen ay aynı tarihte" overlay
  - Verdict cümlesi: "Bu tempoda ay sonu ~165 000 сом (önceki ay 147 000
    сом)".
- Senaryolar (v2): "Cumartesi gelirini %20 artırırsak..." slider.

---

## 6. Fraud / şüphe tespit motoru — sinyal sözlüğü

> Bu motor **backend'de** çalışır (mobile sadece sonucu görür) — çünkü
> ortalamaları/percentile'ları hesaplamak için tüm owner'ın history'sine
> erişim gerek. Mobile sadece sinyalleri ve risk skorunu render eder.

### 6.1 Sinyaller

Her sinyalin **kendi metriği + kendi threshold'u + kendi severity'si**
var. Threshold'lar **owner'ın tüm manager'larına göre relative** çalışır
(global sabit threshold yanıltıcı olur — küçük salonda 5 cancel "normal",
büyük zincirde 50 cancel "normal").

| Sinyal               | Metrik                                                                  | Trigger                                              | Severity                |
| -------------------- | ----------------------------------------------------------------------- | ---------------------------------------------------- | ----------------------- |
| HIGH_CANCEL_RATE     | manager.cancelCount / manager.sessionCount                              | > 2× owner ortalaması VE > 5%                        | high                    |
| HIGH_CANCEL_60S      | 60sn altında bitirilen cancel sayısı                                    | > 2× owner ortalaması (manager 60sn iptal hakkını kullanıyor) | high                    |
| HIGH_DISCOUNT_RATE   | indirimli session / toplam session                                      | > 2× ortalama VE > 10%                               | high                    |
| HIGH_AVG_DISCOUNT    | indirimli session'larda ort. indirim %                                  | > 15% (default) — owner ayarlayabilir                | medium                  |
| LONG_PAUSE_AVG       | ort. totalPausedSeconds                                                 | > 30 dk                                              | medium                  |
| MANY_PAUSE_PER_SESS  | session başına pause adedi (backend pause history'den)                  | > 3                                                  | low                     |
| OFF_HOURS_ACTIVITY   | mesai dışı (00:00-08:00 arası) session sayısı                           | > 0 (her sinyal değerli)                             | medium                  |
| SHORT_SESSION_CLUSTER| < 5 dk biten session oranı                                              | > 10% VE > 5 adet                                    | medium                  |
| TARIFF_OVERRIDE      | session sırasında masa tarifesi değiştirilmiş (snapshot ≠ current)      | > 0                                                  | info — sadece flag      |
| LOW_SHIFT_REVENUE    | manager'ın shift'lerinde aynı masaların ortalama geliri                 | aynı masalar diğer manager'lardayken %30+ düşük      | high                    |

> **Manager'ı suçlamadan önce dur:** her sinyal "kanıt" değil "şüphe". UX'te
> "Hırsızlık var" yazma — `Yüksek riskli pattern · incele` de.
> Owner ayrı bir karar veriyor.

### 6.2 Risk skoru hesabı

```
score = 0
for each triggered signal:
    score += weight[signal] × severityMultiplier[severity]
score = min(score, 100)
band:
  0-29   → green  ("Düşük risk")
  30-59  → yellow ("Orta — incele")
  60-100 → red    ("Yüksek — acil incele")
```

Weight'ler ürün ekibinin kalibre edeceği config (backend `remote_config` ile
ayarlanabilir olmalı — saha datası geldikçe revize edilir).

### 6.3 Veri kaynağı (mevcut API'lerden ne çıkar)

Backend `session_api.md` dokümanına göre **tüm timestamp'ler server'da**,
yani sahteleştirilemez (manager telefonunu geri alamaz). Bu fraud feature'ın
**çalışabilmesi için kritik kural**.

Hesap için backend'de aşağıdaki kayıtların session başına tutulması gerek
(bazı şu anki API'de yok — backend ekibi ile teyit edilecek):

| Alan                  | Var mı?                  | Notlar                                          |
| --------------------- | ------------------------ | ----------------------------------------------- |
| `managerId`           | (kullanıcı id'sinden)    | session'ı kim başlattı / bitirdi                |
| `cancelReason`        | ✅ var                   | log için                                        |
| `discountPercent`     | ✅ var                   | finish'ten geliyor                              |
| `pauseHistory`        | DB'de var (`session_api` notu), API'de yok | manager detail'de "kaç pause" göstermek için detail endpoint gerek |
| `tarifAmountSnapshot` | ✅ var                   |                                                 |
| `startedAt/endedAt`   | ✅ var                   | süre, mesai dışı tespiti                        |

> Backend'in **session'a managerId** kaydetmesi şart. Şu an ana session
> response'unda bu alan yok. Reports için endpoint extend edilmeli.

---

## 7. Forecast (tahmin) modeli

MVP için karmaşık ML değil — basit, açıklanabilir, owner'ın güvendiği bir
formül. Backend'de hesaplanır.

```
input: son 90 günün günlük gelir verisi
1. seasonal decomposition: haftanın günü efekti = ortalama(her pazartesi) / overall_mean
2. trend = linear regression (gelir, gün indeksi) → m, b
3. forecast(d):
     trendPart   = m × d + b
     seasonal    = dayOfWeek factor for d
     return round(trendPart × seasonal)
4. confidence band: ±1 standard error of regression
```

UX:
- Verdict cümlesi tek satır.
- Tüm grafikte tahmin **kesik çizgi** + gri band.
- "Geçen ay aynı tarihte" referans çizgisi (solid soluk renk).

> v2'de Prophet/STL/manager-trained model. MVP'de yukarıdaki yeterli — owner
> "matematik bahanesi" değil, "yön" istiyor.

---

## 8. KPI tanımları & formüller

Hep aynı period (`from`, `to`) için. **Bütün hesap backend'de.**

| KPI                  | Tanım                                                                   |
| -------------------- | ----------------------------------------------------------------------- |
| `totalRevenue`       | sum(`totalAmount`) where status=COMPLETED, endedAt ∈ [from,to]          |
| `totalSessions`      | count(*) where status=COMPLETED, endedAt ∈ [from,to]                    |
| `cancelledSessions`  | count(*) where status=CANCELLED, endedAt ∈ [from,to]                    |
| `avgDurationSeconds` | avg(`durationSeconds`) — sadece COMPLETED                               |
| `avgTicket`          | totalRevenue / totalSessions                                            |
| `occupancyPercent`   | sum(durationSeconds) / (tableCount × periodSeconds × workingFraction)   |
| `activeNow`          | count(table) where session != null AND session.status ∈ {ACTIVE,PAUSED} |
| `discountRate`       | count(session where discountPercent>0) / totalSessions                  |
| `avgDiscountPercent` | avg(discountPercent) — sadece indirimliler                              |

`workingFraction` (occupancy için): owner şubelerinin "açık olduğu" saat
oranı. MVP: 12 saat/gün varsayım (`0.5`). v2: owner mekan ayarlarına
working hours ekler, gerçek değer kullanılır.

**Comparison delta:**

```
delta = (current - previous) / previous × 100
previous = aynı uzunlukta önceki periyot
  (Bugün → Dün; Hafta → Geçen hafta; Ay → Geçen ay; Yıl → Geçen yıl;
   Custom → aynı uzunluk öncesi)
```

`previous = 0` ise delta gösterilmez (∞ değil "—").

---

## 9. Filtre & state modeli

```dart
enum ReportPeriod { today, week, month, year, custom }

@immutable
final class ReportRange extends Equatable {
  const ReportRange(this.from, this.to);
  factory ReportRange.fromPeriod(ReportPeriod p, DateTime now) { /* ... */ }

  final DateTime from; // inclusive
  final DateTime to;   // exclusive

  ReportRange get previous { /* same length, immediately before */ }

  @override
  List<Object?> get props => [from, to];
}

@immutable
final class ReportFilter extends Equatable {
  const ReportFilter({
    required this.period,
    required this.range,
    this.venueId,        // null = "Tüm şubeler"
    this.compareToPrevious = false,
  });

  final ReportPeriod period;
  final ReportRange range;
  final String? venueId;
  final bool compareToPrevious;

  ReportFilter copyWith({...}) { ... }

  @override
  List<Object?> get props => [period, range, venueId, compareToPrevious];
}
```

`ReportFilter` cubit state'inin parçası — değişince ilgili section'lar
yeniden yüklenir. Filter local prefs'e kaydedilir (period + venueId);
açılışta restore edilir.

---

## 10. Frontend data modelleri

```dart
// reports_summary_model.dart
@JsonSerializable() @immutable
final class ReportsSummaryModel extends Equatable {
  const ReportsSummaryModel({
    required this.totalRevenue,
    required this.totalSessions,
    required this.cancelledSessions,
    required this.avgDurationSeconds,
    required this.occupancyPercent,
    required this.activeNow,
    required this.activeMax,
    required this.currency,
    this.previous, // null ise compare yok
  });

  factory ReportsSummaryModel.fromJson(Map<String, dynamic> j) =>
      _$ReportsSummaryModelFromJson(j);

  final int totalRevenue;
  final int totalSessions;
  final int cancelledSessions;
  final int avgDurationSeconds;
  final int occupancyPercent;
  final int activeNow;
  final int activeMax;
  final String currency;
  final ReportsSummaryModel? previous; // delta için

  Map<String, dynamic> toJson() => _$ReportsSummaryModelToJson(this);
  // ... props
}

// revenue_point_model.dart
@JsonSerializable() @immutable
final class RevenuePointModel extends Equatable {
  const RevenuePointModel({required this.bucket, required this.revenue, required this.sessions});
  factory RevenuePointModel.fromJson(Map<String, dynamic> j) => ...;
  final DateTime bucket; // gün başı / saat başı / ay başı, period'a göre
  final int revenue;
  final int sessions;
  // ...
}

// table_report_row_model.dart
@JsonSerializable() @immutable
final class TableReportRowModel extends Equatable {
  const TableReportRowModel({...});
  final String tableId;
  final String tableName;
  final int tableNumber;
  final String venueId;
  final String venueName;
  final int revenue;
  final int sessions;
  final int avgDurationSeconds;
  final int occupancyPercent;
  final int? deltaPercent; // önceki periyoda göre, hesaplanamadıysa null
  // ...
}

// manager_report_row_model.dart
@JsonSerializable() @immutable
final class ManagerReportRowModel extends Equatable {
  const ManagerReportRowModel({...});
  final String managerId;
  final String name;
  final String username;
  final int revenue;
  final int sessions;
  final int cancelCount;
  final int avgDiscountPercent;
  final int riskScore;             // 0-100
  final ManagerRiskBand riskBand;  // green / yellow / red
  final List<FraudFlagModel> flags;
  // ...
}

enum ManagerRiskBand { green, yellow, red }

@JsonSerializable() @immutable
final class FraudFlagModel extends Equatable {
  const FraudFlagModel({
    required this.code,           // HIGH_CANCEL_RATE etc.
    required this.severity,       // info | warning | critical
    required this.value,          // ölçülen değer (raw)
    required this.benchmark,      // owner ortalaması
    required this.message,        // BaseMessage{en,ru,ky}
  });
  // ...
}

// insight_model.dart
@JsonSerializable() @immutable
final class InsightModel extends Equatable {
  const InsightModel({...});
  final String id;
  final InsightSeverity severity; // info | warning | critical
  final BaseMessage title;
  final BaseMessage body;
  final InsightAction? action;    // ör: navigate(managerDetail, id)
  final DateTime createdAt;
  final bool acknowledged;
  // ...
}

// forecast_model.dart
@JsonSerializable() @immutable
final class ForecastModel extends Equatable {
  const ForecastModel({...});
  final List<ForecastPointModel> points; // gün gün
  final int projectedTotal;             // verdict cümlesi için
  final int previousPeriodTotal;
  final BaseMessage verdict;            // backend'den gelen hazır cümle
  // ...
}
```

---

## 11. Backend kontratı (öneri)

> Tüm endpoint'ler `Authorization: Bearer <accessToken>` + `role=OWNER`.
> Manager `403 FORBIDDEN`. Tüm hesaplar backend'de — mobile aggregation
> yapmaz. Pagination tablar ve manager listeleri için (`limit/offset`).

| Method | Path                                       | Amaç                                                   |
| ------ | ------------------------------------------ | ------------------------------------------------------ |
| GET    | `/api/v1/reports/overview`                 | KPI özeti + comparison previous                        |
| GET    | `/api/v1/reports/revenue-series`           | Bar/line chart için aggregated time series             |
| GET    | `/api/v1/reports/tables`                   | Top-table veya tüm masalar (sort + pagination)         |
| GET    | `/api/v1/reports/tables/{id}`              | Table detail (saatlik heatmap dahil)                   |
| GET    | `/api/v1/reports/managers`                 | Manager karşılaştırma listesi                          |
| GET    | `/api/v1/reports/managers/{id}`            | Manager detail + fraud sinyalleri + session log        |
| GET    | `/api/v1/reports/insights`                 | Otomatik üretilen insight kartları (open/all)          |
| POST   | `/api/v1/reports/insights/{id}/dismiss`    | Insight'ı yoksay (7 gün suppress)                      |
| GET    | `/api/v1/reports/forecast`                 | Tahmin grafiği                                         |
| GET    | `/api/v1/reports/export.pdf`               | PDF rapor (period query'si ile)                        |
| GET    | `/api/v1/reports/export.csv`               | Session-level CSV                                      |

Ortak query parametreleri:

| Param      | Type    | Notes                                                       |
| ---------- | ------- | ----------------------------------------------------------- |
| `from`     | ISO8601 | inclusive UTC                                               |
| `to`       | ISO8601 | exclusive UTC                                               |
| `venueId`  | uuid?   | null/missing → tüm owner mekanları                          |
| `compare`  | bool    | `true` ise response içine `previous` blokları eklenir       |
| `currency` | enum?   | multi-currency mekanlarda; yoksa response'da grouping       |

Response örnekleri (özet):

```json
// GET /reports/overview
{
  "summary": {
    "totalRevenue": 142500,
    "totalSessions": 384,
    "cancelledSessions": 12,
    "avgDurationSeconds": 4980,
    "occupancyPercent": 34,
    "activeNow": 4,
    "activeMax": 6,
    "currency": "KGS"
  },
  "previous": { /* aynı yapı, önceki dönem; compare=true ise */ }
}
```

```json
// GET /reports/managers
{
  "items": [
    {
      "managerId": "user-101",
      "name": "Айбек Асанов",
      "username": "aibek",
      "revenue": 78400,
      "sessions": 142,
      "cancelCount": 12,
      "avgDiscountPercent": 18,
      "riskScore": 72,
      "riskBand": "RED",
      "flags": [
        {
          "code": "HIGH_CANCEL_RATE",
          "severity": "CRITICAL",
          "value": "0.0845",            // 8.45%
          "benchmark": "0.030",          // 3.0%
          "message": {
            "en": "Cancel rate is 2.8× the team average",
            "ru": "Частота отмен в 2.8 раза выше средней",
            "ky": "Жокко чыгаруу мааниси орточодон 2.8 эсе көп"
          }
        }
      ]
    }
  ],
  "total": 3
}
```

```json
// GET /reports/insights
{
  "items": [
    {
      "id": "insight-2026-04-30-aibek-cancel",
      "severity": "WARNING",
      "title": { "en": "Айбек: high cancel rate", "ru": "...", "ky": "..." },
      "body":  { "en": "12 cancels this week (4× team avg)", "ru": "...", "ky": "..." },
      "action": { "type": "MANAGER_DETAIL", "targetId": "user-101" },
      "createdAt": "2026-04-30T08:00:00Z",
      "acknowledged": false
    }
  ]
}
```

> **Önemli backend gereksinimleri:**
>
> - `Session` kaydına `managerId` (kim başlattı / kim bitirdi) eklenmeli — şu
>   an API'de yok. Reports olmazsa olmaz.
> - Cancel reason audit'i (kim, ne zaman, hangi metin) korunmalı.
> - Pause history audit-only kalsın, ama özet (`pauseCount`,
>   `avgPauseSeconds`) reports endpoint'lerinden dönsün.
> - Insights üretimi **periyodik bir cron**: günlük / saatlik. Mobile sadece
>   tüketir.
> - Tüm hesaplar backend'de cache'li olmalı (5 dk TTL yeter — owner reports
>   ekranını sürekli açıp kapamayacak).

---

## 12. Mobile mimarisi

> CLAUDE.md ve [docs/code-rules.md](code-rules.md) kurallarına uygun. Subscription paketinin
> şablonunu birebir takip eder.

### 12.1 `packages/reports/`

```
packages/reports/
├── pubspec.yaml
└── lib/
    ├── reports.dart                          ← public barrel (interface + DTO)
    ├── exceptions/
    │   └── reports_exception.dart            ← AppException<ReportsErrorCode>
    ├── models/
    │   ├── reports_summary_model.dart        + .g.dart
    │   ├── revenue_point_model.dart          + .g.dart
    │   ├── table_report_row_model.dart       + .g.dart
    │   ├── table_report_detail_model.dart    + .g.dart   (heatmap dahil)
    │   ├── manager_report_row_model.dart     + .g.dart
    │   ├── manager_report_detail_model.dart  + .g.dart   (session log dahil)
    │   ├── fraud_flag_model.dart             + .g.dart
    │   ├── insight_model.dart                + .g.dart
    │   ├── forecast_model.dart               + .g.dart
    │   ├── report_filter.dart                            (entity, json yok)
    │   └── enums/
    │       ├── report_period.dart
    │       ├── manager_risk_band.dart
    │       ├── insight_severity.dart
    │       └── fraud_flag_code.dart
    ├── repository/
    │   └── reports_repository.dart           ← tek concrete final class
    └── source/
        └── remote/
            ├── reports_remote_source.dart        ← abstract interface
            ├── reports_remote_source_impl.dart   ← real (ApiClient.bearerInstance)
            └── reports_remote_source_mock.dart   ← Env.isMock için sentetik veri
```

`pubspec.yaml` — subscription şablonu kopya, sadece `name: reports`. Workspace'e
ekle: root `pubspec.yaml`'da `workspace:` listesine `packages/reports`.

### 12.2 `features/reports/`

[code-rules.md § Feature folder structure](code-rules.md#feature-folder-structure)
kuralı: çok-ekranlı feature → her sub-screen kendi `cubit/view/widgets/<sub>.dart`
klasörü.

```
app/lib/features/reports/
├── reports.dart                          ← top-level barrel
├── widgets/                              ← feature içi paylaşılan widget'lar
│   ├── period_chips.dart
│   ├── venue_picker_chip.dart
│   ├── kpi_card.dart
│   ├── kpi_grid.dart
│   ├── revenue_bar_chart.dart
│   ├── manager_risk_badge.dart
│   ├── insight_card.dart
│   └── empty_reports_view.dart
├── overview/
│   ├── cubit/
│   │   ├── reports_overview_cubit.dart
│   │   └── reports_overview_state.dart
│   ├── view/
│   │   └── reports_overview_view.dart
│   ├── widgets/
│   │   ├── insights_strip.dart
│   │   ├── top_tables_section.dart
│   │   └── top_managers_section.dart
│   └── overview.dart
├── venue_detail/
│   ├── cubit/  view/  widgets/
│   └── venue_detail.dart
├── table_detail/
│   ├── cubit/  view/  widgets/
│   │   └── widgets/hour_day_heatmap.dart
│   └── table_detail.dart
├── manager_detail/
│   ├── cubit/  view/  widgets/
│   │   ├── widgets/risk_score_panel.dart
│   │   ├── widgets/fraud_flag_list.dart
│   │   └── widgets/session_log_list.dart
│   └── manager_detail.dart
├── insights_inbox/
│   ├── cubit/  view/  widgets/
│   └── insights_inbox.dart
└── forecast/
    ├── cubit/  view/  widgets/
    └── forecast.dart
```

### 12.3 State management

Tüm sub-screen cubit'leri **single-page cubit** kuralına uyar (single-page
cubit memory'siyle uyumlu — `BlocProvider` yok, `late final` field +
`bloc:`).

`ReportsOverviewState` örnek (multi-field state, `RequestStatus<T>` kalıbı):

```dart
final class ReportsOverviewState extends Equatable {
  const ReportsOverviewState({
    required this.filter,
    this.summary  = const RequestInitial(),
    this.revenue  = const RequestInitial(),
    this.tables   = const RequestInitial(),
    this.managers = const RequestInitial(),
    this.insights = const RequestInitial(),
    this.forecast = const RequestInitial(),
  });

  final ReportFilter filter;
  final RequestStatus<ReportsSummaryModel>            summary;
  final RequestStatus<List<RevenuePointModel>>         revenue;
  final RequestStatus<List<TableReportRowModel>>       tables;
  final RequestStatus<List<ManagerReportRowModel>>     managers;
  final RequestStatus<List<InsightModel>>              insights;
  final RequestStatus<ForecastModel>                   forecast;

  ReportsOverviewState copyWith({...}) { ... }
  @override List<Object?> get props => [filter, summary, revenue, tables, managers, insights, forecast];
}
```

Her bölüm için ayrı `BlocBuilder` + `buildWhen` (KPI grid `summary`
değiştiğinde, chart `revenue` değiştiğinde rebuild olur — aynı state
değişiminde tüm ekran rebuild olmaz, [code-rules.md § BlocBuilder rebuild
scope](code-rules.md#blocbuilder-rebuild-scope) kuralına uygun).

### 12.4 Routing

`AppRoutes`'a yeni sabitler:

```dart
static const reports             = '/reports';
static const reportsVenue        = '/reports/venues/:id';
static const reportsTable        = '/reports/tables/:id';
static const reportsManager      = '/reports/managers/:id';
static const reportsInsights     = '/reports/insights';
static const reportsForecast     = '/reports/forecast';
```

`/reports` bottom-nav 2. tab; sadece role=OWNER'da görünür (manager için
bottom nav 2 sekme: Home + Profile).

### 12.5 DI

Yeni `ReportsModule extends BaseDiModule`:

```dart
final class ReportsModule extends BaseDiModule {
  @override
  Future<void> register(GetIt sl) async {
    sl.registerLazySingleton<ReportsRemoteSource>(
      () => Env.isMock
          ? ReportsRemoteSourceMock()
          : ReportsRemoteSourceImpl(sl(instanceName: ApiClient.bearerInstance)),
    );
    sl.registerLazySingleton(() => ReportsRepository(remote: sl()));
  }
}
```

Cubit'ler DI'a kaydedilmez ([single-page cubit memory] — page'in
`StatefulWidget`'ında `late final`, `initState`'de
`GetIt.I<ReportsRepository>()`).

### 12.6 Error handling

Reports'a özel error code'lar minimum — backend genelde `200 + summary` ya
da boş döner. Network/timeout hataları normal `AppException` üzerinden
snackbar'a düşer. Insight `dismiss` çağrısı başarısızsa session boyunca
local olarak gizle, retry queue'ya at (silent).

### 12.7 Localization

`app/lib/l10n/arb/app_*.arb` içine yeni grup. **Key prefix: `reports*`**.

İlk MVP listesi:

```
reportsTabTitle, reportsOverviewTitle,
reportsPeriodToday, reportsPeriodWeek, reportsPeriodMonth,
reportsPeriodYear, reportsPeriodCustom,
reportsAllVenues, reportsVenuePickerTitle,
reportsKpiRevenue, reportsKpiSessions, reportsKpiAvgDuration,
reportsKpiOccupancy, reportsKpiActive,
reportsRevenueChartTitle, reportsRevenueChartCompareToggle,
reportsTopTablesTitle, reportsTopTablesSeeAll,
reportsTopManagersTitle, reportsTopManagersSeeAll,
reportsForecastSummaryTitle, reportsForecastVerdict (placeholders: amount, currency, deltaPercent),
reportsInsightsEmpty, reportsInsightsAcknowledge,
reportsManagerRiskLow, reportsManagerRiskMedium, reportsManagerRiskHigh,
reportsManagerRiskExplain (uzun açıklama),
reportsFraudFlagHighCancelRate, reportsFraudFlagHighDiscount,
reportsFraudFlagOffHours, reportsFraudFlagShortSessionCluster,
reportsFraudFlagLongPause, reportsFraudFlagLowShiftRevenue,
reportsTableHeatmapTitle, reportsTableTrendTitle,
reportsExportPdf, reportsExportCsv,
reportsEmptyTitle, reportsEmptySubtitle,
```

Risk skoru tartışmalı bir kelime — `risk` yerine `dikkat / inceleme
gerekli` gibi yumuşak kelime kullanmak yargılayıcı havayı azaltır. Owner
karar veriyor, uygulama yargılamıyor.

### 12.8 Empty / loading / error states

- **Empty (yeni owner, hiç session yok):** İlüstrasyon + "Henüz raporlanacak
  veri yok. İlk session'ı başlatınca burası canlanır."
- **Loading:** skeleton — KPI kartlar boş, chart placeholder, list
  shimmer satırları. Hep aynı layout (CLS yok).
- **Error (network):** snackbar + reload butonu olan kart.
- **Bölüm bazlı:** chart yüklenirken KPI grid yüklenmiş olabilir — her
  bölüm bağımsız RequestStatus.

### 12.9 Tema / komponent kullanımı

[ui-components.md](ui-components.md) ve [theme-system.md](theme-system.md):
- Renkler: `context.appColors.*`. Risk band:
  - green → `appColors.success`
  - yellow → `appColors.warning` (yoksa eklenmeli)
  - red   → `appColors.danger`
- Yeni component'ler `app/lib/ui/components/` içine değil
  `features/reports/widgets/` altına (feature-specific). İstisna: bir başka
  feature de aynı widget'ı kullanmaya başlarsa taşınır.
- Chart için: `fl_chart` veya `syncfusion_flutter_charts`. MVP basit
  yeterli — `fl_chart` (open source) tercih.

---

## 13. MVP scope & milestone'lar

> Doğru zamanlama için: subscription feature canlıya çıktıktan sonra. Çünkü
> Reports'un para getirebilmesi için ödeme sistemi hazır olmalı.

### M1 — Reports MVP (4-6 hafta backend + 3 hafta mobile)

- Overview ekranı (insights strip hariç)
- Period filter + venue picker
- KPI grid + comparison delta
- Revenue bar chart
- Top tables list (3-5 satır + see all)
- Top managers list (basit — risk skorsuz, sadece gelir/sessions/cancel
  count)
- Table Detail: KPI + 30-gün trend (heatmap'siz)
- Manager Detail: KPI + session log (fraud panel'siz)
- Backend: session'a `managerId` ekleme (zorunlu prerequisite)

### M2 — Fraud panel + Insights (3-4 hafta)

- Fraud flag motoru backend'de (bütün sinyaller)
- Risk skoru
- Manager Detail fraud paneli
- Insights endpoint + Insights strip + Insights Inbox
- Insight dismiss

### M3 — Forecast + Heatmap + Export (3 hafta)

- Forecast endpoint + Forecast özeti kartı + Forecast full sayfası
- Table Detail saat-gün heatmap
- PDF / CSV export
- Custom date range

### v2+ (post-launch)

- Multi-currency düzgün handling
- Manager mesajlaşma (insight'tan tek tıkla "uyarı gönder")
- Working hours tabanlı occupancy
- Threshold customization (owner kendi risk threshold'larını ayarlasın)
- Push notification: kritik insight gerçek zamanlı bildirim

---

## 14. Riskler & açık sorular

- [ ] Backend `Session.managerId` eklemesi — bu olmadan fraud feature
      anlamsız. Backend sprint'i ne zaman?
- [ ] Owner'ın "şüphe" kelimesinin lokalizasyonundan rahatsız olma riski.
      Hukuki açıdan "fraud" kelimesi kullanılmamalı — "yüksek inceleme
      gerekli" gibi yumuşak dil. Legal review gerekli mi?
- [ ] `OFF_HOURS_ACTIVITY` sinyali için "mesai" tanımı: owner per-venue
      working hours setlemeli. MVP'de bu yoksa sinyal devre dışı kalmalı.
- [ ] Cache stratejisi: backend 5 dk cache yeterli mi yoksa real-time mi?
      Owner reports'u "şu an" görmeli mi yoksa "son hesaplanan" yeterli mi?
      Önerimiz: 5 dk cache + manuel refresh.
- [ ] Multi-currency: bir owner'ın iki şubesi farklı currency'deyse
      "Tüm şubeler" gerçekten anlamlı mı? Önerimiz: KPI grid currency
      grouped olur, "Tüm şubeler" varsayılan olarak en yüksek hacimli
      currency'i gösterir + chip ile değiştirilir.
- [ ] Forecast confidence: az datalı yeni owner için tahmin yanıltıcı
      olabilir. Önerimiz: < 14 gün datada forecast bölümü kapalı.
- [ ] PDF export rendering: backend mi mobile mı? Backend daha doğru
      (markup ortak). Mobile'da `printing` paketi alternatif.
- [ ] "Manager para çalıyor" iddiasının yanlış pozitif maliyeti yüksek —
      MVP'de threshold'ları konservatif tut, alpha test'te iki gerçek
      owner'la kalibre et.
- [ ] Insight dismiss: 7 gün suppress yeterli mi yoksa "bir daha asla"
      seçeneği de olsun mu?

---

## 15. Onay sonrası ilk adımlar

1. Backend ekibiyle **Session.managerId** ekleme task'ı için anlaş.
2. `packages/reports/` boilerplate (managers/subscription şablonu kopya).
3. `ReportsRemoteSourceMock` — sentetik 90 günlük data + 3 manager + 6
   masa. Mobile UI tarafı backend'siz tam çalışır halde geliştirilir.
4. Overview ekranı — KPI grid + revenue chart + top tables. Mock üstünde
   son halini al.
5. Insights strip + Manager Detail iskeletini mock üstünde geliştir;
   backend gelene kadar bekle.
6. Backend gelir gelmez Mock yerine Impl, alpha test owner'a aç.
