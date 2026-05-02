# Reports & Analytics — Mobile Design Plan

> Sport Manager Mobile için Owner'a yönelik **Rapor / İş Analizi** özelliği.
> Bu doküman feature'ın **mevcut MVP scope'unu**, user/business flow'unu,
> ekran haritasını, KPI tanımlarını, backend kontratını ve mobile
> mimarisini açıklar — ek olarak **bilinçli olarak ertelenen** (fraud
> sinyalleri, manager risk skoru, insights motoru, çok-mekan agregasyonu)
> özellikleri liste eder.
>
> **Audience:** Product owner + mobile dev (Claude / insan).
> **Status:** v2 — MVP canlıda · 2026-05-03.
> **Referans tasarım:** [`work/report.png`](../work/report.png) — Reports
> Overview ekranının başlangıç hali; mevcut implementation buradan
> evrilmiş, MVP-trim sonrası fraud/insights bandı olmadan canlıda.

---

## 0. v1 → v2 değişikliklerinin özeti

İlk taslak (v1, 2026-05-01) Owner'a fraud-tespit motoru ve insight kartları
sunmayı planlıyordu. Saha datası olmadan synthetic ile canlıya çıkmak yanlış
yönlendirici sonuçlar üretebileceği için **MVP'ye fraud-style hiçbir sinyal
girmiyor** — sadece nötr veri (gelir, oturum sayısı, süre, occupancy).

**v2'de çıkan / değişen:**

- ❌ `InsightsStrip` — otomatik insight kartları (silindi: front + back)
- ❌ Fraud sinyali motoru — `FraudFlagModel`, `RiskScorePanel`,
  `ManagerRiskBadge`, risk skoru / band'i (silindi: front + back)
- ❌ "Tüm şubeler" agregasyonu — picker artık tek mekan seçer; agregasyon
  hesabı false-positive insight üretmesin diye scope'tan çıkarıldı
- ❌ `ManagerSessionLog` filtreleri `discounted` ve `short` (kaldı: `all`,
  `cancelled`)
- ❌ "Top tables" → **tüm tablo'lar** (seçili mekanın). Top-N kavramı fraud
  feature'a bağlıydı; MVP'de owner her şeyi görmek istiyor.
- ✅ `ForecastSummaryCard` — projeksiyon algoritması düzeltildi (takvim
  periyoduna hizalı, real-so-far dahil, doğru previous-period karşılaştırması)
- ✅ `RevenueBarChart` — Syncfusion `SfCartesianChart` + `ColumnSeries`
  (custom `Container`-bar yerine)
- ✅ `ManagerReportDetailView` — sadece KPI bandı + session log (risk
  paneli, fraud flag listesi yok)
- ✅ Material widget tercihi — `ListTile`, `ChoiceChip`, vs. el yapımı
  yapılar yerine

Aşağıdaki bölümler güncel canlı durumu tarif eder. **§9** "Bilinçli olarak
ertelenen" özellikleri listeler — buradakilere geri dönmek için saha
testi + threshold kalibrasyonu + legal review şart.

---

## 1. Neden bu feature kritik

Owner uygulamayı **yönetim aracı** olarak değil **iş zekası aracı** olarak
satın alıyor. Masa açıp kapama zaten manager'ın işi; owner için asıl değer
şu sorulara **net cevap görmek**:

1. **Para hangi mekandan, hangi masadan geliyor?** Hangi masa kâr
   getirmiyor, tarifesi değişmeli?
2. **Hangi manager o mekanda ne kadar gelir üretti?** Düz performans —
   "kovalım/kovmayalım" kararını veren signaller MVP'de yok.
3. **Bu tempoda devam edersek bu ay/yıl ne olacak? Geçen aydan iyi mi
   kötü mü gidiyoruz?**

Bu üç sorudan biri bile cevapsız kalırsa Owner abonelik yenilemeyecek.

> **Etik/legal not:** v1'in "Manager X muhtemelen para çalıyor" gibi sezgisel
> sinyalleri vardı. Synthetic data üzerinde çalışsa da **canlıda** Owner'ın
> yanlış pozitiften manager'ı işten çıkarması ciddi sonuç doğurur. MVP bu
> tür sinyalleri sergilemez; saha datası + threshold kalibrasyonu + legal
> review tamamlanana kadar §9'da bekler.

---

## 2. Kullanıcı (Owner) profili & "jobs to be done"

| Anlık ihtiyaç                                | Yaptığı şey                                                       |
| -------------------------------------------- | ----------------------------------------------------------------- |
| Sabah hızlıca dünkü hasılat                  | Reports → Bugün — toplam, ortalama, masa/manager listesi.         |
| Ay başı muhasebe / vergi                     | Reports → Ay (üretilen rakamlar; CSV export v2).                  |
| Yeni mekan ekleyip eklemeyeceği kararı       | Reports → Yıl — gelir trendi.                                     |
| Bir masayı kapatma kararı                    | Reports → Masa → 30/90 günlük gelir + occupancy + saat-gün heatmap. |
| Bir manager'ın özel performansı              | Reports → Manager kartı → KPI + son 40 oturum.                    |
| Ay sonu tahmini ("kira yetişir mi?")         | Reports overview → Forecast özet kartı.                           |

> Reports feature'ı manager'a kapalı (`role=OWNER`). Mobile'da bottom-nav'da
> "Otçet" sekmesi tüm rollere görünür ama içerik OWNER bekler — manager
> rolüyle giren biri tüm bölümleri "boş" görür (backend henüz role-gate
> yapmadığı için bu UX nazikçe boş kalır).

---

## 3. Bilgi mimarisi

```
Reports (bottom nav: 2. tab)
│
├── Overview (varsayılan)
│   ├── Period chips           ← Bugün · Hafta · Ay · Yıl
│   ├── Venue picker chip      ← Tek mekan zorunlu (MVP)
│   ├── KPI grid (2×2)         ← gelir / session / ortalama süre / occupancy
│   ├── Revenue bar chart      ← Syncfusion SfCartesianChart, peak day vurgu
│   ├── Forecast özet kartı    ← "Bu tempoda Mayıs ~165 000 сом (+12%)"
│   ├── Tables                 ← seçili mekanın tüm masaları, gelir desc
│   └── Managers               ← seçili mekanda çalışan manager listesi
│
├── Table Detail              ← KPI + 30/90 günlük gelir trendi + 7×24 heatmap
│
└── Manager Detail            ← Header + KPI bandı + session log (40 satır)
```

`ReportOverviewView` ilk yüklemede mekan listesini çeker, **ilk mekanı
otomatik seçer**, tüm bölümleri o mekana göre yükler. Picker üzerinden başka
mekana geçince `_refreshAll` tetiklenir.

---

## 4. User flow (Owner perspektifinden)

### 4.1 Günlük rutin — "iş nasıl gidiyor?"

```
Owner login
  ↓
Home (kendi mekanları)
  ↓ bottom nav → Reports
Reports Overview açılır
  · period: "Ay" (cihaz hatırlamıyor, default — local-prefs persistence v2)
  · venue: ilk mekan otomatik seçili
  · KPI grid + revenue chart + forecast özeti + tablolar + manager'lar
  ↓
Owner mekan chip'inden başka şubeye geçer → tüm bölümler yeniden yüklenir
  veya
Owner alttaki bir masaya dokunur → Table Detail açılır
  veya
Owner manager kartına dokunur → Manager Detail açılır (KPI + session log)
```

### 4.2 Karar akışı — "bu masayı kapatayım mı?"

```
Reports Overview → "Tables" listesi
  ↓ alttaki masa
Table Detail
  ├── KPI: gelir + delta, sessions, ortalama süre, occupancy
  ├── 30 günlük gelir trendi (revenue bar chart)
  └── Saat × gün heatmap (7×24)
```

Owner bu ekranda "occupancy %8, ortalama süre düşük, saat heatmap'i karanlık"
deyip tarife düşürme veya kapatma kararını ham veriyle veriyor — uygulama
yorumlamıyor.

### 4.3 Tahmin akışı — "ay sonunda ne olacak?"

```
Reports Overview → Forecast özet kartı
  · "Bu tempoda Mayıs sonu ~165 000 сом (+12% vs Nisan)"
  · Pozitif delta → yeşil, negatif → kırmızı, yetersiz tarih → "Geçmiş yetersiz"
```

Forecast detayı ayrı sayfada değil — overview kartında özet yeterli (full
forecast page ertelenen kapsamda).

---

## 5. Ekranlar — detay

### 5.1 Reports Overview

> Bkz. mevcut implementation:
> [`features/report/overview/view/report_overview_view.dart`](../app/lib/features/report/overview/view/report_overview_view.dart)
> ve sub-widget'ları.

Sırayla, listView içinde:

1. **Period chips** — `Bugün · Hafta · Ay · Yıl`. `ChoiceChip` kullanır;
   period değişince range yeniden hesaplanır + `_refreshAll`.
2. **Venue picker** (AppBar action) — `ActionChip` + bottom sheet
   `ListTile` listesi. Her zaman bir mekan seçili (silver bullet "Tüm
   mekanlar" yok).
3. **KPI grid 2×2** — her hücre `ReportKpiCard` (title + büyük değer +
   delta vs previous period):
   - Toplam gelir
   - Sessions
   - Ortalama süre (`ReportFormat.duration`)
   - Occupancy `%` + alt satırda `activeNow/activeMax`
   - Delta yoksa (önceki dönem 0) "—"; pozitif yeşil, negatif kırmızı.
4. **Revenue bar chart** — `RevenueBarChart` (Syncfusion). Locale-aware
   tarih ekseni (`DateFormat.MMMd`), compact y-axis (`NumberFormat.compact`).
   Peak gün primary renkte, diğerleri `appColors.brandAmberSoft`.
   Currency-aware tooltip builder bara dokunulduğunda
   `"2 May · 142 500 сом"` formatında gösterir.
5. **Forecast özet kartı** — Card primary container'da, gelecek
   projeksiyon + delta. Yetersiz tarih varsa kart kendisini göstermez.
6. **Tables** — `TablesSection` → mekanın **tüm** masaları gelir desc
   sıralı. Her satır `ListTile` tabanlı: title (label + delta + money),
   subtitle = `LinearProgressIndicator` (max revenue'ya göre normalize).
   Tap → `/report/tables/:id`.
7. **Managers** — `TopManagersSection` → mekanda gelir üreten manager'lar
   gelir desc sıralı. `ListTile` (`leading=avatar`, `title=ad`,
   `subtitle="142 500 сом · 12 sessions"`, `trailing=chevron`). Tap →
   `/report/managers/:id`.

`Scaffold` + `RefreshIndicator` + `ListView` builder dışında, her dinamik
leaf kendi dar `BlocBuilder`'ı + `buildWhen` ile sadece o slice'a tepki
verir (bkz. [code-rules.md § BlocBuilder rebuild scope](../docs/code-rules.md#blocbuilder-rebuild-scope)).

### 5.2 Table Detail

> [`features/report/table_detail/view/table_report_detail_view.dart`](../app/lib/features/report/table_detail/view/table_report_detail_view.dart)

- Period chips (manager-detail'inkiyle aynı kontrat)
- KPI: revenue (delta), sessions, ortalama süre, occupancy %
- Revenue trend (Syncfusion bar chart, period boyunca günlük)
- Saat × gün heatmap — 7×24 grid, custom widget (`HourDayHeatmap`).
  Syncfusion charts paketinde heatmap widget'ı yok; basit `Container`
  grid'i ile renderlanıyor. Renk yoğunluğu `colorScheme.primary` üzerinde
  alpha gradient.

### 5.3 Manager Detail

> [`features/report/manager_detail/view/manager_report_detail_view.dart`](../app/lib/features/report/manager_detail/view/manager_report_detail_view.dart)

- Period chips
- **Header card** — `Card` içinde `ListTile`: avatar (initials), isim,
  `@username`.
- **KPI bandı** — 2 hücre: `revenue` (gelir) + `sessions` (alt satırda
  `cancelCount > 0` ise "X cancels"). **Risk skoru, fraud flag listesi
  yok.**
- **Session log** — `ManagerSessionLog`:
  - Filtre chip'leri: **`All` · `Cancelled`** (`discounted`/`short`
    filtreleri kasıtlı yok)
  - Maksimum 40 satır (en son'lar). Her `_LogRow`:
    - Leading: `check_circle_outline` veya `cancel_outlined`
    - Title: tablo etiketi
    - Subtitle: `"03.05 18:42 · 1ç 23m"` (cancel ise sadece tarih)
    - Trailing: tutar (completed) veya `Icons.block` (cancelled)
  - Discount % gösterimi yok (model field'ı bile yok)

> §9'a referans: Risk paneli ve fraud listesi v1'de bu sayfanın merkez
> özelliğiydi; saha datasıyla validate edilmeden geri eklenmemeli.

---

## 6. KPI tanımları & formüller

Hep aynı period (`from`, `to`) için. **Tüm hesap backend'de.**

| KPI                  | Tanım                                                                   |
| -------------------- | ----------------------------------------------------------------------- |
| `totalRevenue`       | sum(`totalAmount`) where status=COMPLETED, endedAt ∈ [from,to]          |
| `totalSessions`      | count(*) where status=COMPLETED, endedAt ∈ [from,to]                    |
| `cancelledSessions`  | count(*) where status=CANCELLED, endedAt ∈ [from,to]                    |
| `avgDurationSeconds` | avg(`durationSeconds`) — sadece COMPLETED                               |
| `occupancyPercent`   | sum(durationSeconds) / (tableCount × periodSeconds × workingFraction)   |
| `activeNow`          | count(table) where session != null AND session.status ∈ {ACTIVE,PAUSED} |
| `cancelCount`        | (manager) cancelled session count for that manager                      |

`workingFraction`: MVP `0.5` (12 saat/gün varsayım). v2'de owner mekan
ayarlarına working hours ekler, gerçek değer kullanılır.

**Comparison delta:**

```
delta = (current - previous) / previous × 100
previous = aynı uzunlukta önceki periyot (filter.range.previous)
```

`previous = 0` ise delta gösterilmez (∞ değil "—").

**Forecast (overview kartı için):**

```
1. revenueSeries(filter)  → günlük gelir geçmişi
2. linear regression slope + intercept (p günlük slope)
3. projectionEnd = takvim periyodunun bitimi (ay sonu / hafta sonu / yıl sonu)
4. projectedTotal = realSoFar + Σ projection(today+1 → projectionEnd)
5. previousPeriodTotal = aynı isimli takvim periyodunun bir önceki örneği
   (Mayıs için tam Nisan, bu hafta için tam geçen hafta, 2026 için tam 2025)
6. delta = (projectedTotal - previousPeriodTotal) / previousPeriodTotal × 100
```

> v1'de `projectedTotal` sadece 14 günlük future'ı topluyordu, gerçeği
> dahil etmiyordu — verdict yanlış geliyordu. v2'de düzeltildi.

---

## 7. Filtre & state modeli

```dart
enum ReportPeriod { today, week, month, year, custom }

@immutable
final class ReportRange extends Equatable {
  const ReportRange({required this.from, required this.to});
  factory ReportRange.fromPeriod(ReportPeriod p, DateTime now) { /* ... */ }

  final DateTime from;  // inclusive
  final DateTime to;    // exclusive
  Duration get length => to.difference(from);
  ReportRange get previous => ReportRange(from: from.subtract(length), to: from);
}

@immutable
final class ReportFilter extends Equatable {
  const ReportFilter({
    required this.period,
    required this.range,
    this.venueId,            // MVP: ilk yüklemede otomatik set edilir
    this.compareToPrevious = true,
  });

  factory ReportFilter.initial(DateTime now) {
    return ReportFilter(
      period: ReportPeriod.month,
      range: ReportRange.fromPeriod(ReportPeriod.month, now),
    );
  }

  final ReportPeriod period;
  final ReportRange range;
  final String? venueId;
  final bool compareToPrevious;
}
```

`venueId` modelde nullable kalıyor — overview cubit'i ilk venue load'da
otomatik set eder, sonra hiçbir akış null'a geri çekmez. v2'de veri tipinde
güçlendirilebilir (custom date range desteği eklendiğinde tekrar
değerlendirilir).

---

## 8. Frontend data modelleri

> Tam liste:
> [`packages/reports/lib/models/`](../packages/reports/lib/models/)
>
> Hepsi `@JsonSerializable() @immutable final class extends Equatable`.

```dart
ReportsSummaryModel       totalRevenue, totalSessions, cancelledSessions,
                          avgDurationSeconds, occupancyPercent, activeNow,
                          activeMax, currency, previous

RevenuePointModel         bucket (DateTime), revenue, sessions

TableReportRowModel       tableId, tableName, tableNumber, venueId,
                          venueName, revenue, sessions, avgDurationSeconds,
                          occupancyPercent, currency, deltaPercent

TableReportDetailModel    summary (TableReportRowModel),
                          revenueByDay (List<RevenuePointModel>),
                          hourHeatmap (List<List<int>>, 7×24)

ManagerReportRowModel     managerId, name, username, revenue, sessions,
                          cancelCount, currency
                          // riskScore/riskBand/flags YOK

ManagerReportDetailModel  summary (ManagerReportRowModel),
                          sessionLog (List<ManagerSessionLogEntry>)

ManagerSessionLogEntry    sessionId, tableId, tableNumber/Name, venueName,
                          startedAt, endedAt, status (completed/cancelled),
                          durationSeconds?, totalAmount?, cancelReason?,
                          currency
                          // discountPercent YOK

ForecastModel             points, projectedTotal, previousPeriodTotal,
                          currency; deltaPercent getter

ForecastPointModel        bucket, expected, lower, upper, isProjection

ReportVenueModel          id, name, number     // hafif venue picker payload'ı
```

`InsightModel`, `FraudFlagModel`, `ManagerRiskBand` — **silindi**.

---

## 9. Bilinçli olarak ertelenen — geri gelmesi için ne lazım

| Özellik                                           | Geri gelmek için ön-koşul                                                                          |
| ------------------------------------------------- | -------------------------------------------------------------------------------------------------- |
| Manager risk skoru + `ManagerRiskBadge`           | Saha datası (3-6 ay) + 2-3 gerçek owner ile kalibrasyon + legal review (yanlış pozitif maliyeti)   |
| Fraud sinyali listesi (`FraudFlagModel` ailesi)   | Risk skoru ile birlikte; sinyal başına owner-spesifik threshold ayarı                              |
| `RiskScorePanel` + `FraudFlagList`                | Yukarıdakiler. UI hazır şablonu git history'de mevcut                                              |
| `InsightsStrip` (otomatik insight kartları)       | Risk skoru + actionable threshold'lar; UI'da owner "yoksay" + "haklıydı" feedback loop'u           |
| Çok-mekan ("All venues") agregasyonu              | Multi-currency düzgün handling; currency mix fallback davranışı                                     |
| Manager log filtreleri `discounted` / `short`     | Risk skoruyla birlikte (tek başına bilgi-değil-suçlama dengesi belirsiz)                            |
| Insights Inbox (geçmiş insight history)           | Risk skoruyla birlikte                                                                              |
| Forecast full sayfası (senaryolar dahil)          | Currency normalization, en az 60 gün veri threshold'u                                              |
| PDF / CSV export                                  | Backend tarafı; saha owner'ından gerçek talep                                                       |

> Bu özelliklerin önceki implementation şablonları **git history**'de. Geri
> gelirken sıfırdan yazmaya gerek yok — `el/reports` branch'inde PR #25
> öncesi commit'lere bakılabilir.

---

## 10. Backend kontratı

Tüm endpoint'ler `Authorization: Bearer <accessToken>` + `role=OWNER`.
Manager `403 FORBIDDEN`. Hesaplar backend'de — mobile aggregation yok.

| Method | Path                                       | Amaç                                                   |
| ------ | ------------------------------------------ | ------------------------------------------------------ |
| GET    | `/api/v1/reports/venues`                   | Owner'ın mekan listesi (picker)                        |
| GET    | `/api/v1/reports/overview`                 | KPI özeti + comparison previous                        |
| GET    | `/api/v1/reports/revenue-series`           | Bar chart için aggregated time series                  |
| GET    | `/api/v1/reports/tables`                   | Seçili mekanın tüm masaları (top-N parametresi yok)    |
| GET    | `/api/v1/reports/tables/{id}`              | Table detail (heatmap dahil)                           |
| GET    | `/api/v1/reports/managers`                 | Seçili mekanda gelir üreten manager listesi            |
| GET    | `/api/v1/reports/managers/{id}`            | Manager detail — summary + sessionLog                  |
| GET    | `/api/v1/reports/forecast`                 | Tahmin (overview kartı için)                           |

Ortak query parametreleri:

| Param      | Type    | Notes                                                                  |
| ---------- | ------- | ---------------------------------------------------------------------- |
| `from`     | ISO8601 | inclusive UTC                                                          |
| `to`       | ISO8601 | exclusive UTC                                                          |
| `venueId`  | uuid    | MVP'de **her zaman set** (mobile null göndermez)                       |
| `compare`  | bool    | `true` ise overview response'una `previous` bloğu eklenir              |

> **Önceki kontrattan çıkarılanlar:** `/reports/insights`,
> `/reports/insights/{id}/dismiss`, fraud flag alanları
> (`riskScore/riskBand/flags`), `discountPercent`/`discountedCount`
> alanları, `?limit` parametresi (top-N), `venueId` opsiyonelliği.

> **Önemli backend gereksinimleri:**
>
> - `Session` kaydına `managerId` (kim başlattı / kim bitirdi) eklenmeli —
>   şu anki API'de yok. Manager scoping bunsuz çalışmaz.
> - Tüm hesaplar backend'de cache'li (5 dk TTL yeter — owner reports
>   ekranını sürekli açıp kapamayacak).
> - Forecast hesabı backend'de; mobile sadece çıktıyı render eder.

---

## 11. Mobile mimarisi

> [docs/code-rules.md](../docs/code-rules.md) ve [CLAUDE.md](../CLAUDE.md)
> kurallarına uygun.

### 11.1 `packages/reports/`

```
packages/reports/
├── pubspec.yaml
└── lib/
    ├── reports.dart                          ← public barrel (exhaustive)
    ├── exceptions/
    │   └── reports_exception.dart
    ├── models/
    │   ├── forecast_model.dart                + .g.dart
    │   ├── manager_report_detail_model.dart   + .g.dart
    │   ├── manager_report_row_model.dart      + .g.dart
    │   ├── manager_session_log_entry.dart     + .g.dart
    │   ├── report_filter.dart
    │   ├── report_period.dart
    │   ├── report_range.dart
    │   ├── report_venue_model.dart            + .g.dart
    │   ├── reports_summary_model.dart         + .g.dart
    │   ├── revenue_point_model.dart           + .g.dart
    │   ├── table_report_detail_model.dart     + .g.dart
    │   └── table_report_row_model.dart        + .g.dart
    ├── repository/
    │   └── reports_repository.dart            ← tek concrete final class
    └── source/
        ├── source.dart                        ← sub-barrel
        └── remote/
            ├── reports_remote_source.dart        ← abstract interface
            ├── reports_remote_source_impl.dart   ← real (ApiClient.bearerInstance)
            └── reports_remote_source_mock.dart   ← Env.isMock için sentetik veri
```

### 11.2 `app/lib/features/report/`

> Klasör adı **tekil** (`report`) — proje genelinde feature folder'larıyla
> tutarlı. v1 doc'unda `reports` (çoğul) yazıyordu, gerçek tekildir.

```
features/report/
├── report.dart                          ← top-level barrel (exhaustive)
├── utils/
│   └── report_format.dart               ← money/duration/delta helpers
├── widgets/                             ← feature-wide shared
│   ├── report_kpi_card.dart
│   ├── report_period_chips.dart
│   ├── report_venue_picker.dart
│   └── revenue_bar_chart.dart           ← Syncfusion sarmalayıcı
├── overview/
│   ├── overview.dart
│   ├── cubit/
│   │   ├── report_overview_cubit.dart
│   │   └── report_overview_state.dart
│   ├── view/
│   │   └── report_overview_view.dart
│   └── widgets/
│       ├── forecast_summary_card.dart
│       ├── kpi_grid.dart
│       ├── revenue_chart_section.dart
│       ├── tables_row.dart
│       ├── tables_section.dart
│       ├── tables_skeleton.dart
│       └── top_managers_section.dart
├── manager_detail/
│   ├── manager_detail.dart
│   ├── cubit/
│   │   ├── manager_report_detail_cubit.dart
│   │   └── manager_report_detail_state.dart
│   ├── view/
│   │   └── manager_report_detail_view.dart
│   └── widgets/
│       ├── manager_report_body.dart           ← header + KPI + log
│       ├── manager_report_detail_skeleton.dart
│       └── manager_session_log.dart
└── table_detail/
    ├── table_detail.dart
    ├── cubit/  view/
    └── widgets/
        ├── hour_day_heatmap.dart
        ├── table_report_body.dart
        └── table_report_detail_skeleton.dart
```

### 11.3 State management

Tüm sub-screen cubit'leri **single-page cubit** kuralına uyar — `late
final` field, `initState`'de `GetIt.I<ReportsRepository>()`, `bloc:`
parametresi, `dispose`'da `close()`. `BlocProvider` yok.

`ReportOverviewState` örneği — multi-field state, `RequestStatus<T>` ile
her bölüm bağımsız:

```dart
final class ReportOverviewState extends Equatable {
  final ReportFilter filter;
  final RequestStatus<List<ReportVenueModel>>      venues;
  final RequestStatus<ReportsSummaryModel>          summary;
  final RequestStatus<List<RevenuePointModel>>      revenue;
  final RequestStatus<List<TableReportRowModel>>    tables;
  final RequestStatus<List<ManagerReportRowModel>>  managers;
  final RequestStatus<ForecastModel>                forecast;
  // …
}
```

Her bölüm için ayrı `BlocBuilder` + `buildWhen` (KPI grid `summary`
değiştiğinde, chart `revenue` değiştiğinde, vs).

### 11.4 Routing

```dart
// AppRoutes
static const report          = '/report';
static const reportManager   = '/report/managers/:id';
static const reportTable     = '/report/tables/:id';
```

Reports `/report` bottom-nav'in 2. branch'ı (`StatefulShellRoute` içinde).
`/report/managers/:id` ve `/report/tables/:id` nested route — parent shell
yerine `rootNavigatorKey` üzerinden push edilir (full-screen detail).

### 11.5 DI

`ReportsModule extends BaseDiModule` — `ReportsRemoteSource` (`Env.isMock`
ile mock vs `Impl`) + `ReportsRepository` lazySingleton. `main.dart`'taki
modül listesine eklenmiş.

### 11.6 Tema / komponent kullanımı

- Renkler: `context.appColors.*` ve `context.colors`
- Para/süre/delta formatlama: [`ReportFormat`](../app/lib/features/report/utils/report_format.dart)
- Material primitives tercih: `ListTile`, `ChoiceChip`, `Card`,
  `LinearProgressIndicator`, `RefreshIndicator.adaptive`
- Charts: **Syncfusion** (`syncfusion_flutter_charts: ^33.2.4`) — bar chart
  için. Heatmap paketi yok, custom widget.

---

## 12. Empty / loading / error states

- **Empty (yeni owner, hiç session yok):** Her bölüm kendi `_MessageCard`'ı
  ile "data yok" göstergesi. Top-level placeholder yok.
- **Loading:** Skeleton — KPI shimmer, chart `ShimmerBox(height: 160)`,
  table/manager listesi 3 shimmer satır.
- **Error (network):** `ErrorBodyWidget` (manager-detail / table-detail);
  overview'da `_MessageCard(l10n.reportsErrorTitle)`. Pull-to-refresh ile
  retry.
- **Bölüm bazlı:** chart yüklenirken KPI grid yüklenmiş olabilir — her
  bölüm bağımsız `RequestStatus`.

---

## 13. Localization

ARB dosyaları: [app/lib/l10n/arb/](../app/lib/l10n/arb/) (`en`, `ru`, `ky`).
MVP'de canlı key'ler:

```
reportsOverviewTitle, reportsManagerDetailTitle, reportsTableDetailTitle,
reportsPeriodToday/Week/Month/Year/Custom,
reportsVenuePickerTitle,
reportsKpiRevenue/Sessions/AvgDuration/Occupancy/Active,
reportsRevenueChartTitle, reportsRevenueChartCompareToggle,
reportsTablesTitle, reportsTopManagersTitle, reportsTableLabel,
reportsSessionsShort, reportsCancelledShort,
reportsSessionLogTitle, reportsLogFilterAll, reportsLogFilterCancelled,
reportsLogEmpty,
reportsForecastSummaryTitle, reportsForecastVsPrevious,
reportsForecastNoComparison,
reportsTableTrendTitle, reportsTableHeatmapTitle,
reportsErrorTitle, reportsEmptyTitle, reportsEmptySubtitle
```

Silinmiş key'ler: `reportsAllVenues`, `reportsTopTablesTitle`,
`reportsTopTablesSeeAll`, `reportsTopManagersSeeAll`, tüm
`reportsManagerRisk*`, tüm `reportsRiskScore*`, tüm `reportsFraud*`,
`reportsLogFilterDiscounted/Short`.

---

## 14. Test kapsamı

Mevcut: **`RevenueBarChart` widget testi** —
[`app/test/features/report/widgets/revenue_bar_chart_test.dart`](../app/test/features/report/widgets/revenue_bar_chart_test.dart).
4 case: empty data, normal data, all-zero peak-tied, single point.

Eklenecek (M2+):
- `ReportFormat` unit test'leri (money/duration/delta edge case'leri)
- `_MockStore.forecast` test'leri (period boundary, real-so-far)
- Cubit testleri (overview load + venue change flow)
- Manager session log filter testi

---

## 15. Riskler & açık sorular

- [ ] Backend `Session.managerId` eklemesi — manager scoping bunsuz
      anlamlı değil. Backend sprint'i ne zaman?
- [ ] Custom date range desteği — period chip'lere "Custom" eklemek için
      date-range picker UI ve `ReportRange.fromPeriod(ReportPeriod.custom)`
      iskeleti hazır ama UI yok. M2.
- [ ] Multi-currency: bir owner'ın iki şubesi farklı currency'deyse
      MVP'de "tek mekan" zaten currency'yi seçtirdiği için sorun değil; ama
      Forecast/Comparison hesaplamalarında karışım olabilir mi?
- [ ] Forecast confidence: az datalı yeni owner için tahmin yanıltıcı
      olabilir. MVP'de sadece kart gizlenir, daha akıllı eşik (örn. < 14
      gün → kart gösterme) gerekli mi?
- [ ] Reports tab'ının role gating'i mobile-only — manager rolüyle giren
      tab'a basabiliyor, içerik boş geliyor. Backend role-based 403 verince
      tab kendisini gizleyecek mi yoksa tab her zaman görünecek ama içerik
      "bu sekme owner içindir" mi diyecek? UX kararı.

---

## 16. Sıradaki gerçek-dünya adımları

1. `Session.managerId` backend eklemesi → mock'tan canlıya geçiş için
   prerequisite.
2. Reports'u alpha owner ile saha test — mevcut MVP yeterli mi, yoksa
   §9'daki ertelenenlerden biri kritik mi?
3. Saha datasına bakarak `ForecastSummaryCard`'ın doğruluğunu validate et
   (synthetic'te +12% deltası gerçekçi mi?).
4. `_MockStore.forecast` algoritmasını Prophet/ETS gibi daha sağlam bir
   modele taşı (M2). MVP linear regression yeterli ama 60+ gün tarihli
   owner'larda zayıflıyor.
5. Owner'lar fraud sinyaline ihtiyaç duyduklarını saha araştırmasıyla
   teyit ederse, §9'un şartlarını yerine getirip sırayla geri ekle.
