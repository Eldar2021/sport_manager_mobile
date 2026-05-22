# Mobile için Değişiklik Notları — Venue Type & Tables→Spot Rename

> **Durum:** Backend tarafı uygulandı, merge edildi. **Test edildi: 387/387 geçiyor.**
> Mobile koordinasyonu için bu doc. Aksiyon listesi ve breaking change'ler aşağıda.

## TL;DR — Mobile için 3 kritik nokta

1. **Venue oluştururken artık `type` alanı ZORUNLU** (7 enum değerinden biri). Eski mobile sürümü 422 alır.
2. **Hata kodları `TABLE_*` → `SPOT_*` rename edildi.** Mobile error mapping'i güncellenmeli — eski kodlar artık backend'den dönmüyor.
3. **Diğer her şey backward-compatible** — eski path'ler, eski JSON field adları (`tableId`, `tableCount`, …) hâlâ çalışıyor (deprecated alias). Mobile yavaş yavaş yeni isimlere geçebilir, panik yok.

---

## 1. Yeni alan: `VenueType` (BREAKING — create)

Venue oluştururken `type` zorunlu oldu. **Update'te `type` gönderebilirsin ama backend yok sayar** — tip immutable.

### Enum değerleri

| Değer          | UI'da gösterilecek "spot" adı (öneri) |
| -------------- | ------------------------------------- |
| `TABLE_TENNIS` | Masa / Table / Стол                   |
| `BILLIARDS`    | Masa / Table / Стол                   |
| `PLAY_STATION` | Konsol / Console / Консоль            |
| `VOLLEYBALL`   | Saha / Court / Корт                   |
| `BASKETBALL`   | Saha / Court / Корт                   |
| `CHESS`        | Tahta / Board / Доска                 |
| `FOOTBALL`     | Saha / Pitch / Поле                   |

> Mobile bu mapping'i kendi i18n katmanında tutar; backend type'ı string olarak döndürür, label compose etmez.

### Endpoint diff

```diff
 POST /api/v1/venue/create
 {
   "name": "Merkez Şube",
   "number": 1,
+  "type": "BILLIARDS",
   "address": "Chui Avenue 132"
 }
```

Response'a `type` alanı eklendi:

```diff
 {
   "id": "...",
   "name": "...",
   "number": 1,
   "address": "...",
   "selected": true,
+  "type": "BILLIARDS",
   "spotCount": 3,
   "tableCount": 3,  // alias — birebir spotCount değeri
   "createdAt": "...",
   "updatedAt": "..."
 }
```

### Hata kodları (yeni)

| HTTP | Code                              | Ne zaman                                                            |
| ---- | --------------------------------- | ------------------------------------------------------------------- |
| 422  | `VALIDATION_ERROR`                | `type` body'de yok veya null                                        |
| 400  | `BAD_REQUEST`                     | Geçersiz enum değeri (örn. `"type": "TENNIS"`) — Jackson reddediyor |
| —    | `VENUE_TYPE_IMMUTABLE` _(rezerv)_ | Şu an silent ignore; ileride explicit hata atılabilir               |
| —    | `INVALID_VENUE_TYPE` _(rezerv)_   | Aynısı, defansif kullanım için ayrıldı                              |

---

## 2. Hata kodları rename (BREAKING — error handling)

Backend artık **yeni `SPOT_*` kodlarını emit ediyor**. Eski `TABLE_*` kodları artık dönmüyor.

| Eski (artık dönmez)        | Yeni                      |
| -------------------------- | ------------------------- |
| `TABLE_NOT_FOUND`          | `SPOT_NOT_FOUND`          |
| `TABLE_NUMBER_TAKEN`       | `SPOT_NUMBER_TAKEN`       |
| `TABLE_HAS_ACTIVE_SESSION` | `SPOT_HAS_ACTIVE_SESSION` |
| `VENUE_HAS_TABLES`         | `VENUE_HAS_SPOTS`         |
| `NO_TABLES`                | `NO_SPOTS`                |

> **Mobile aksiyon:** Error code → user-facing message mapping'inde her iki kodu da aynı UI string'e bağla. Aşağıdaki gibi:
>
> ```dart
> // örnek
> case "SPOT_NOT_FOUND":
> case "TABLE_NOT_FOUND":   // legacy, eski backend versiyonu kalmışsa
>   showError("spotNotFound");
> ```
>
> Yeni mobile sürümleri sadece `SPOT_*`'a bakabilir; eski kodlar için case opsiyonel.

---

## 3. JSON field rename (backward-compatible)

Aşağıdaki field adları yeni canonical. **Eski adlar da response'da yine duruyor** (deprecated getter ile), o yüzden eski mobile bozulmaz. Yeni mobile yeni adlara geçer.

### VenueResponse

| Yeni        | Eski (alias)   |
| ----------- | -------------- |
| `spotCount` | `tableCount`   |
| `type`      | _(yeni — yok)_ |

### SelectedVenueResponse

| Yeni      | Eski (alias) |
| --------- | ------------ |
| `spots[]` | `tables[]`   |

### SessionResponse / SessionLiteResponse / SessionResultResponse

| Yeni     | Eski (alias) |
| -------- | ------------ |
| `spotId` | `tableId`    |

`tarifAmountSnapshot` ve `tarifTypeSnapshot` **DEĞİŞMEDİ** — bunlar generic fiyat snapshot'u.

### Reports

| Endpoint                         | Yeni                                        | Eski (alias)                        |
| -------------------------------- | ------------------------------------------- | ----------------------------------- |
| `GET /api/v1/reports/spots`      | `spotId`/`spotName`/`spotNumber`            | `tableId`/`tableName`/`tableNumber` |
| `GET /api/v1/reports/spots/{id}` | `summary.spotId` / `summary.spotName` / ... | `summary.tableId` / ...             |
| `SessionLogEntry`                | `spotId`/`spotName`/`spotNumber`            | `tableId`/`tableName`/`tableNumber` |

### Subscription

| Yeni                   | Eski (alias)            |
| ---------------------- | ----------------------- |
| `pricePerSpot`         | `pricePerTable`         |
| `spotCount`            | `tableCount`            |
| `spotCountSnapshot`    | `tableCountSnapshot`    |
| `pricePerSpotSnapshot` | `pricePerTableSnapshot` |

Hem `Payment` hem `SubscriptionPricing` response'unda her iki ad da çıkıyor.

---

## 4. Path alias (backward-compatible)

Tüm path'ler eski hâliyle de **aynı handler'a** mapleniyor:

| Yeni (canonical)                  | Eski (deprecated alias)            |
| --------------------------------- | ---------------------------------- |
| `GET  /api/v1/venue/{id}/spots`   | `GET  /api/v1/venue/{id}/tables`   |
| `POST /api/v1/spot/create`        | `POST /api/v1/table/create`        |
| `PUT  /api/v1/spot/{id}`          | `PUT  /api/v1/table/{id}`          |
| `DELETE /api/v1/spot/{id}`        | `DELETE /api/v1/table/{id}`        |
| `GET  /api/v1/reports/spots`      | `GET  /api/v1/reports/tables`      |
| `GET  /api/v1/reports/spots/{id}` | `GET  /api/v1/reports/tables/{id}` |

> Mobile fonksiyonel olarak hangisini çağırırsa çağırsın aynı sonucu alır. Ama uzun vadede yeni path'e geçmek gerek — alias'lar **T0 + 90 gün** sonra Faz 6 cleanup PR'ında kaldırılacak.

---

## 5. Request body alias

`POST /api/v1/session/start` body'sinde:

```json
{ "spotId": "uuid", "customerName": "Asan" }
```

Yeni canonical. Eski mobile'lar `tableId` gönderirse backend **Jackson `@JsonAlias` ile kabul eder** — yine çalışır.

Mobile yeni sürümü `spotId` gönderir; eski sürümler `tableId` ile çalışmaya devam eder.

---

## 6. UI: Spot label seçimi

Backend her venue response'unda `type` döndürdüğü için mobile UI'da label'ı şöyle compose edebilir:

```dart
const spotLabels = <VenueType, Map<String, String>>{
  VenueType.TABLE_TENNIS: { 'tr': 'Masa',   'en': 'Table',   'ru': 'Стол',    'ky': 'Стол'   },
  VenueType.BILLIARDS:    { 'tr': 'Masa',   'en': 'Table',   'ru': 'Стол',    'ky': 'Стол'   },
  VenueType.PLAY_STATION: { 'tr': 'Konsol', 'en': 'Console', 'ru': 'Консоль', 'ky': 'Консоль'},
  VenueType.VOLLEYBALL:   { 'tr': 'Saha',   'en': 'Court',   'ru': 'Корт',    'ky': 'Корт'   },
  VenueType.BASKETBALL:   { 'tr': 'Saha',   'en': 'Court',   'ru': 'Корт',    'ky': 'Корт'   },
  VenueType.CHESS:        { 'tr': 'Tahta',  'en': 'Board',   'ru': 'Доска',   'ky': 'Тактай' },
  VenueType.FOOTBALL:     { 'tr': 'Saha',   'en': 'Pitch',   'ru': 'Поле',    'ky': 'Талаа'  },
};

String spotLabel(VenueType type, String locale) =>
    spotLabels[type]?[locale] ?? 'Spot';
```

Home ekranında masa/saha/konsol kartlarında bu label kullanılır:

- Eskiden: `"Masa 1"`, `"Masa 2"` (hardcoded)
- Yeni: `"${spotLabel(venue.type, locale)} ${spot.number}"` → `"Saha 1"`, `"Konsol 2"`, …

Backend hata gövdesinde her zaman jenerik "Spot" diyor — type-aware label tamamen mobile tarafı.

---

## 7. Backfill ve mevcut prod verisi

V5 migration'ı tüm mevcut `venues` satırlarına `type = 'TABLE_TENNIS'` yazdı (en güvenli varsayım — eski "table-only" durumla uyumlu).

> Eğer mevcut owner aslında bilardo/voleybol/PS işletiyorsa: bu venue'yu silip yeniden açması gerek (tip immutable). Mobile bunu kullanıcıya açıklamak isteyebilir — örn. profil ekranında bir banner: "Mekanınızın tipi otomatik olarak Masa Tenisi seçildi. Yanlışsa mekanı silip tekrar oluşturabilirsiniz."

---

## 8. Aksiyon Checklist

### Şimdi yapılması gerekenler (BREAKING)

- [ ] Venue create form'una **Type Picker** eklensin (7 seçenek + ikon). Form submit'inden önce zorunlu doğrulama.
- [ ] Error code mapping'inde **`SPOT_*` kodları eklensin**. Eski `TABLE_*` kodları yeni sürümde dönmeyecek; legacy fallback opsiyonel.
- [ ] Venue update form'unda type seçici **gösterilmesin** (veya read-only) — değiştirilemez.

### Geçiş süresince (3 ay opsiyonel)

- [ ] Mobile model'lerde `spotId`/`spotName`/`spotNumber`/`spotCount`/`pricePerSpot` field'larına geçilsin (eskiler hâlâ JSON'da var, switch yapması kolay).
- [ ] API çağrılarında yeni path'lere geçilsin (`/spot/*`, `/venue/{id}/spots`, `/reports/spots`).
- [ ] `StartSessionRequest`'te `tableId` yerine `spotId` gönderilsin.
- [ ] Home ekranı `spotLabel(venue.type, locale)` ile dinamik label'ı uygulasın.

### İleride (Faz 6 cleanup — T0 + 90 gün)

- [ ] Backend alias'ları kaldıracak. O tarihten önce mobile minimum versiyon zorunlu — eski client'lar artık çalışmaz.
- [ ] `pricePerTable`, `tableCount`, `tableId`, `/table/*` path'leri bitecek.

---

## 9. Test edebileceğin local sanity check'ler

```bash
# 1. Venue oluştur (yeni alan)
curl -X POST $BASE/api/v1/venue/create -H "Authorization: Bearer ..." \
  -H "Content-Type: application/json" \
  -d '{"name":"V1","number":1,"type":"VOLLEYBALL","address":"Test"}'

# Response: 201, body içinde "type":"VOLLEYBALL" gelir
# Eski mobile sürümü body'de type yollamazsa → 422 VALIDATION_ERROR

# 2. Yeni spot path
curl -X POST $BASE/api/v1/spot/create -H "Authorization: Bearer ..." \
  -d '{"venueId":"...","number":1,"tarifAmount":250,"currency":"KGS","tarifType":"HOUR"}'

# 3. Eski path da hala çalışır (alias)
curl -X POST $BASE/api/v1/table/create -H "Authorization: Bearer ..." \
  -d '{"venueId":"...","number":2,"tarifAmount":250,"currency":"KGS","tarifType":"HOUR"}'

# 4. Session start hem eski hem yeni body field'ı kabul eder
curl -X POST $BASE/api/v1/session/start -H "Authorization: Bearer ..." \
  -d '{"spotId":"..."}'         # yeni
curl -X POST $BASE/api/v1/session/start -H "Authorization: Bearer ..." \
  -d '{"tableId":"..."}'        # eski — hala çalışıyor

# 5. Hata kodu görmek için
curl -X POST $BASE/api/v1/spot/create -H "Authorization: Bearer ..." \
  -d '{"venueId":"...","number":1,...}'  # mevcut number ile

# Response: 409 { "code": "SPOT_NUMBER_TAKEN", ... }  ← yeni kod
```

---

## 10. Sorular / Belirsizlikler

- **PlayStation için label "Console" mu "Setup" mı?** Doc'ta `Console` öneriyoruz, ürün ekibi karar verirse mobile config'i değiştirilir (backend etkilenmez).
- **Chess default tarifType — HOUR mı MINUTE mı?** Şu an mobile'da kullanıcının seçimine bırakılıyor; backend default'u HOUR önerir ama zorlamıyor.
- **Onboarding banner'ı (`type=TABLE_TENNIS` yanlış olabilir owner'lar için)** gösterilsin mi? Ürün kararı.

Sorular için: backend yan tarafında ben varım, mesaj at.
