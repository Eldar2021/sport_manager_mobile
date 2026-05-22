# Venue Type + "Table" → "Spot" Rename — Implementation Notes

> Projeyi tek-spor "table"-merkezli yapısından çoklu-spor (bilardo, masa
> tenisi, PlayStation, voleybol, basketbol, satranç, futbol) bir platforma
> çevirme **uygulandı**.
>
> **Statü:** Uygulandı · 2026-05-23 · backend + mobile koordineli.
> **Mobile-side analyze:** `No issues found!`.

---

## 1. Sonuç özet

- Domain entity adı: `Table*` → **`Spot*`** (kod tarafı). Backend de aynı isimde rename etti
  ([mobile-migration-notes.md](mobile-migration-notes.md)).
- `Venue` artık zorunlu `VenueType` taşıyor. Form'da picker eklendi; edit'te
  read-only.
- UI label'ları dinamik — `VenueType` üzerinden seçilen kelime gösteriliyor
  (Table / Console / Court / Board / Pitch + locale çevirileri).
- 80+ ARB anahtarı yenilendi; üç dilde (EN / RU / KY).
- API path'leri `/api/v1/table/*` → `/api/v1/spot/*`; session body
  `tableId` → `spotId`. Eski endpoint'ler hâlâ alias olarak çalışıyor
  (90 gün geçiş penceresi).
- `FacilityErrorCode.table*` → `spot*`. Kod parser hem yeni `SPOT_*` hem
  legacy `TABLE_*` koddan eşliyor (defansif fallback).

---

## 2. `VenueType` enum

[`packages/facility/lib/models/venue_type.dart`](../packages/facility/lib/models/venue_type.dart):

```dart
@JsonEnum()
enum VenueType {
  @JsonValue('TABLE_TENNIS') tableTennis,
  @JsonValue('BILLIARDS')    billiards,
  @JsonValue('PLAY_STATION') playStation,   // backend'le birebir: PLAY_STATION (underscore'lu)
  @JsonValue('VOLLEYBALL')   volleyball,
  @JsonValue('BASKETBALL')   basketball,
  @JsonValue('CHESS')        chess,
  @JsonValue('FOOTBALL')     football,
}
```

### Label mapping ([utils/venue_type_label.dart](../app/lib/features/venues/utils/venue_type_label.dart))

| `VenueType`   | EN      | RU       | KY        | Icon                    |
| ------------- | ------- | -------- | --------- | ----------------------- |
| `billiards`   | Table   | Стол     | Үстөл     | `sports_bar`            |
| `tableTennis` | Table   | Стол     | Үстөл     | `sports_tennis`         |
| `playStation` | Console | Консоль  | Консоль   | `sports_esports`        |
| `volleyball`  | Court   | Корт     | Аянтча    | `sports_volleyball`     |
| `basketball`  | Court   | Корт     | Аянтча    | `sports_basketball`     |
| `chess`       | Board   | Доска    | Тактай    | `grid_4x4`              |
| `football`    | Pitch   | Поле     | Талаа     | `sports_soccer`         |

Extension API:
```dart
type.spotLabel(context)       // singular ("Console")
type.spotLabelPlural(context) // plural   ("Consoles")
type.typeName(context)        // "PlayStation" — picker'da görünür ad
type.icon                     // IconData
```

---

## 3. Dosya değişikliği envanteri

### 3.1 `packages/facility/`

| Dosya | Değişiklik |
| --- | --- |
| `models/venue_type.dart` (yeni) | `VenueType` enum |
| `models/venue_model.dart` | `tableCount` → `spotCount`; `type: VenueType` eklendi (required) |
| `models/venue_form_param.dart` | `type: VenueType` eklendi (required) |
| `models/spot_model.dart` (yeni; eski `table_model.dart` silindi) | `TableModel` → `SpotModel` |
| `models/spot_form_param.dart` (yeni; eski `table_form_param.dart` silindi) | `TableFormParam` → `SpotFormParam` |
| `models/selected_venue_model.dart` | `tables: List<TableModel>` → `spots: List<SpotModel>` |
| `models/session_model.dart` | `tableId` → `spotId` |
| `source/remote/facility_remote_source.dart` | `getVenueTables` → `getVenueSpots`, `createTable/updateTable/deleteTable` → `createSpot/updateSpot/deleteSpot` |
| `source/remote/facility_remote_source_impl.dart` | API path'leri `/api/v1/table/*` → `/api/v1/spot/*`, `/venue/{id}/tables` → `/venue/{id}/spots` |
| `source/remote/facility_remote_source_mock.dart` | Method ve veri rename'leri |
| `source/remote/session_remote_source_impl.dart` | `data: {'tableId': …}` → `data: {'spotId': …}` |
| `source/remote/mock_data.dart` | `tables` → `spots`, mock id'ler `table-001` → `spot-001` |
| `repository/facility_repository.dart` | Method rename'leri |
| `exceptions/facility_exception.dart` | `table*` → `spot*` enum case'leri, `venueHasTables` → `venueHasSpots`. `fromString()` hem `SPOT_*` hem legacy `TABLE_*` kodları aynı case'e map ediyor |
| `facility.dart` | Barrel export'ları |

### 3.2 `packages/reports/`

| Dosya | Değişiklik |
| --- | --- |
| `models/spot_report_row_model.dart` (yeni; eski `table_report_row_model.dart` silindi) | `TableReportRowModel` → `SpotReportRowModel`; `tableId/Name/Number` → `spotId/Name/Number` |
| `models/spot_report_detail_model.dart` (yeni; eski silindi) | `TableReportDetailModel` → `SpotReportDetailModel` |
| `models/manager_session_log_entry.dart` | `tableId/Name/Number` → `spotId/Name/Number` |
| `source/remote/reports_remote_source.dart` | `getTables` → `getSpots`, `getTableDetail` → `getSpotDetail` |
| `source/remote/reports_remote_source_impl.dart` | API path'leri `/reports/tables` → `/reports/spots` |
| `source/remote/reports_remote_source_mock.dart` | Internal `_MockTable` → `_MockSpot`, vs |
| `repository/reports_repository.dart` | Method rename'leri |
| `reports.dart` | Barrel export'ları |

### 3.3 `packages/core/`

| Dosya | Değişiklik |
| --- | --- |
| `exception/model/error_model.dart` | `BaseMessage.tableError` → `BaseMessage.spotError` (`"Spot Error" / "Ошибка позиции" / "Позиция катасы"`) |

### 3.4 `app/lib/`

| Path | Değişiklik |
| --- | --- |
| `features/tables/` → `features/spots/` | Tüm klasör + dosya + sınıf rename'leri (`TableModel` → `SpotModel`, vs) |
| `features/spots/spot_detail/` (eski `table_detail/`) | `TableDetailCubit/State/View` → `SpotDetailCubit/State/View`, `Free/OccupiedTableView` → `Free/OccupiedSpotView`, `TableInfoRow` → `SpotInfoRow`, body/footer'lar dahil |
| `features/spots/spot_form/` (eski `table_form/`) | `TableFormCubit/View/Mixin/Extra` → `SpotFormCubit/View/Mixin/Extra` |
| `features/home/cubits/home_state.dart` | `HomeLoaded.tables` → `spots`, `HomeNoTables` → `HomeNoSpots` |
| `features/home/widgets/table_card*.dart` | `spot_card.dart`, `spot_card_title.dart`, `spot_card_footer.dart`. `SpotCard` `venueType` parametresi alıyor |
| `features/home/widgets/spots_empty.dart` (eski `tables_empty.dart`) | Type-aware icon + label |
| `features/home/view/home_view.dart` | `HomeNoSpots`, `SpotCard`, `SpotDetail` route'u kullanıyor |
| `features/venues/utils/venue_type_label.dart` (yeni) | `VenueTypeX` extension (label + icon) |
| `features/venues/vanue_form/cubit/*` | `selectedType` state field, `selectType()` action |
| `features/venues/vanue_form/widgets/venue_type_picker.dart` (yeni) | ChoiceChip-tabanlı tip picker |
| `features/venues/vanue_form/view/venue_form_view.dart` | Form'a tip picker entegre; edit'te disabled; required validation |
| `features/venues/venue_detail/widgets/*` | `tables_*` → `spots_*` rename (`VenueSpotsSection`, `SpotsList`, `SpotsEmptyView`, `VenueSpotTile`, `VenueSpotTileSkeleton`) |
| `features/venues/venue_detail/view/venue_detail_view.dart` | `spotCount`, `venue.type`, header dynamic spot label |
| `features/venues/widgets/venue_item.dart`, `venues_list/widgets/venue_card.dart` | `venue.type.icon`, dynamic spot label |
| `features/report/spot_detail/` (eski `table_detail/`) | `SpotReportDetailCubit/State/View`, `SpotReportBody`, `SpotReportDetailSkeleton`; `venueType` HomeCubit state'inden alınıyor |
| `features/report/overview/widgets/spots_*.dart` (eski `tables_*.dart`) | `SpotsRow`, `SpotsSection`, `SpotsSkeleton`. `SpotsSection` venueType + spotLabel alıyor |
| `features/report/overview/cubit/report_overview_state.dart` | `tables` → `spots` field |
| `features/report/manager_detail/widgets/manager_session_log.dart` | `entry.tableX` → `entry.spotX`, `reportsTableLabel` → `reportsSpotLabel` |
| `app/router/app_routes.dart` | `tableForm` → `spotForm`, `tableDetail` → `spotDetail`, `reportTable` → `reportSpot` |
| `app/router/app_router.dart` | Import'lar + route extra'lar (`TableFormExtra` → `SpotFormExtra`, `TableModel` → `SpotModel`) |
| `l10n/arb/app_en.arb`, `app_ru.arb`, `app_ky.arb` | 80+ anahtar yenilendi; `spotLabel*`, `venueType*`, `venueFormType*` eklendi |
| `l10n/generated/*.dart` | `flutter gen-l10n` ile yeniden üretildi |

### 3.5 Backend kontratı

[mobile-migration-notes.md](mobile-migration-notes.md)'e göre backend hem yeni
hem eski path/field'leri destekliyor — eski mobile sürümleri 90 gün
boyunca çalışmaya devam eder. Yeni mobile sürümü:

- `POST /api/v1/venue/create` body'sinde `type: "BILLIARDS"` gönderiyor
  (zorunlu).
- `/api/v1/spot/*` path'lerini kullanıyor.
- `POST /api/v1/session/start` body'sinde `spotId` gönderiyor.
- Response'lardan `spotCount` / `spots[]` / `spotId` field'larını okuyor.
- Hata kodlarını `SPOT_*` + legacy `TABLE_*` olarak parse ediyor.

---

## 4. Subscription paketi — özel durum

`packages/subscription/` paketi **dokunulmadı**:

- `SubscriptionPricingModel.tableCount` / `pricePerTable` field'ları aynı
  kaldı. Backend bunları hem `tableCount`/`pricePerTable` hem
  `spotCount`/`pricePerSpot` olarak döndürdüğü için (alias mode) eski Dart
  field adlarıyla okumak yine çalışıyor.
- Subscription ARB string'lerinde "tables" → "spots" (RU: "позиции", KY:
  "позиция") olarak değişti, ama ARB placeholder ismi `{tableCount}`
  olarak kaldı (Dart model değişmediği için).
- Bu pakette tam Spot rename'i T0 + 90 gün cleanup'ında yapılacak (backend
  alias'ları kaldıracak — o zamanki PR'da subscription Dart modeli de güncel
  isimlere taşınacak).

---

## 5. Hibrit ARB stratejisi (uygulandı)

Karar §7 (eski plan): kısa string'lerde generic + placeholder, plural'larda
type-aware label dictionary.

**Uygulanan kalıp:**

```dart
// Singular getter — type-aware her yerde
context.l10n.homeAddSpot(venue.type.spotLabel(context))
// → "Add table" | "Add console" | "Add court" …

// Plural getter
context.l10n.homeSpotsSection(venue.type.spotLabelPlural(context), spots.length)
// → "TABLES · 3" | "CONSOLES · 3" …

// Title — spotLabel + number
context.l10n.homeSpotTitle(venue.type.spotLabel(context), spot.number)
// → "Table 3" | "Console 3" …

// Plural count
context.l10n.venueSpotsCount(count, spotLabel, spotPlural)
// → "no consoles" | "1 console" | "12 consoles"
```

Type-bağımsız yerler (`spotDetailStart`, `spotDetailStop`, `spotDetailToPay`
…) plain getter — placeholder yok, hepsi spot terminolojisinde.

---

## 6. Doğrulama

```bash
$ make build-runner      # ✓ tüm .g.dart regen edildi
$ fvm flutter gen-l10n   # ✓ AppLocalizations regen edildi
$ fvm flutter analyze    # ✓ No issues found! (ran in 3.5s)
```

Manuel test (sonraki adım):
- [ ] Mock modda venue create → tip picker görünüyor ve zorunlu
- [ ] Mock modda venue edit → tip read-only ve hint görünüyor
- [ ] Home → her tip için doğru kelime ("Add console" vs "Add table")
- [ ] Spot detail → "{spotLabel} {number}" doğru render ediyor
- [ ] Reports → spots tablosu yükleniyor

---

## 7. Backend force-update notu

Migration notes'tan: backend `VENUE_TYPE` zorunlu hale geldi. **Eski mobile
sürümü venue create yaparken 422 alır.** Mobile force-update versiyonu bu
release ile beraber çıkmalı.

---

## 8. Kapsam dışı (bu PR değil)

- Subscription package'ında `tableCount`/`pricePerTable` field rename'i.
- Karışık-tip venue desteği (bir venue'de hem PS hem bilardo).
- Spor tipine göre özel field'lar (PS model, court size, …).
- Designer'dan resmi ikon set'i — şu an Material Icons placeholder.
- Onboarding banner: eski venue'lar otomatik `TABLE_TENNIS` set edildiği için
  PS/bilardo işleten owner'lara "Mekanınızın tipi otomatik olarak Masa Tenisi
  seçildi. Yanlışsa mekanı silip tekrar oluşturabilirsiniz." mesajı.

---

## 9. Açık sorular (proje sahibine)

1. **PlayStation label** "Console" mu "Setup" mı? Şu an `Console` /
   `Консоль` / `Консоль`. Karar verilirse extension'da bir satır değişir.
2. **Chess default tarifType** — HOUR mı per-game mı? Şu an form'da
   kullanıcının seçimine bırakılıyor.
3. **Banner** (otomatik `TABLE_TENNIS` set edilmiş owner'lar için
   uyarı) yapılsın mı? — Ürün kararı.
