# Manager Reports REST API — Backend Contract

Manager'ın **kendi performansını** gördüğü ekranı besleyen uçlar. Owner'ın iş zekâsı raporundan ([reports-api.md](reports-api.md)) **farklı bir modüldür**:

- Owner reports = "**işletmemde** ne oluyor" — venue/spot/manager kırılımları, forecast, KPI delta.
- Manager reports = "**ben** bu gün/hafta/ay/yıl ne kadar çalıştım ve ne kadar kazandırdım" — drilldown bazlı bir history view.

Manager rolü `/api/v1/reports/**` uçlarına `403 FORBIDDEN` almaya devam eder; **bu yeni modül** owner ve manager için açıktır (her ikisi de yalnızca _kendi_ verisini görür).

**Base URL:** `<BASE_URL>`
**Content-Type:** `application/json; charset=utf-8`
**Auth:** Tüm uçlar `Authorization: Bearer <accessToken>` ister.

---

## 1. Kavramsal model

Endpoint'lerin tamamı **`currentUser.id`** üzerinden scope edilir — yani user her ne çağırırsa çağırsın yalnızca **`Session.managerId = currentUser.id`** olan kayıtlar gelir.

```
                ┌───────────────────────────┐
                │  Tab seçimi (mobile)      │
                │  Today / Week / Month /   │
                │  Year                     │
                └────────────┬──────────────┘
                             ▼
                ┌──────────────────────────────────┐
                │ GET /api/v1/manager-reports      │
                │     ?period=TODAY                │
                │     ?period=WEEK                 │
                │     ?period=MONTH                │
                │     ?period=YEAR                 │
                └─────┬───────────────┬────────────┘
                      │               │
              Week→Day│       Month→Day│      Year→Month
                      ▼               ▼            ▼
   ┌────────────────────────────┐   ┌────────────────────────────┐
   │ GET /manager-reports/days/ │   │ GET /manager-reports/      │
   │     {YYYY-MM-DD}           │   │     months/{YYYY-MM}       │
   └────────────────────────────┘   └────────────────────────────┘
```

Drilldown ekranları (`day detail`, `month detail`) tab ekranlarıyla **aynı response şemasını** kullanır. Mobile aynı widget'ı her iki yerde de çizebilir.

---

## 2. Authorization Rolleri

| Endpoint                                         | OWNER | MANAGER |
| ------------------------------------------------ | :---: | :-----: |
| GET `/api/v1/manager-reports?period=TODAY`       |  ✅   |   ✅    |
| GET `/api/v1/manager-reports?period=WEEK`        |  ✅   |   ✅    |
| GET `/api/v1/manager-reports?period=MONTH`       |  ✅   |   ✅    |
| GET `/api/v1/manager-reports?period=YEAR`        |  ✅   |   ✅    |
| GET `/api/v1/manager-reports/days/{date}`        |  ✅   |   ✅    |
| GET `/api/v1/manager-reports/months/{yearMonth}` |  ✅   |   ✅    |

> Owner bu uçlara erişebilir çünkü owner de bazı session'ları kendisi başlatıp bitirmiş olabilir; bu durumda "kendi performansını" buradan görür. Owner'ın **işletme genel raporu** ayrı bir modül ([reports-api.md](reports-api.md)).

**Subscription gate uygulanmaz.** Read-only endpoint'ler `EXPIRED` owner'da da çalışmaya devam eder.

---

## 3. Genel kurallar

### 3.1 Tek doğruluk kaynağı: server time + IANA timezone

Mobile **yalnızca** `period` + `timezone` gönderir; pencereyi (`from` / `to`) backend hesaplar. Bu sayede:

- Manager telefon saatini değiştirip "dünün" verisini "bugün" gibi göstermez.
- Client/server window drift olmaz.
- Bishkek'te gece 02:30'da bitirilen session "bugünün" değil "dünün" sayılmaz — local takvim gününe doğru düşer.

```
?period=TODAY  &timezone=Asia/Bishkek
?period=WEEK   &timezone=Asia/Bishkek
?period=MONTH  &timezone=Asia/Bishkek
?period=YEAR   &timezone=Asia/Bishkek
```

| `period` | Backend'in açtığı pencere (`timezone` local)                                          |
| -------- | ------------------------------------------------------------------------------------- |
| `TODAY`  | `[today 00:00, today+1 00:00)`                                                        |
| `WEEK`   | `[monday 00:00, today+1 00:00)` (ISO 8601 Pzt başı; hafta yarısındaysak bugüne kadar) |
| `MONTH`  | `[1st of month 00:00, today+1 00:00)`                                                 |
| `YEAR`   | `[Jan 1 00:00, today+1 00:00)`                                                        |

`timezone` query parametresi opsiyonel; verilmezse default `Asia/Bishkek`. Geçersiz IANA değeri → `400 BAD_REQUEST` + `INVALID_TIMEZONE`.

### 3.2 Hangi session'lar sayılır

- Yalnızca **`status = COMPLETED`** session'lar revenue/sessions/shift hesabına girer.
- `CANCELLED` session'lar manager reports'ta **dönmez** (gizli; fraud sinyali owner-side rapor konusu, manager'ın kendi ekranında "iptal ettim" listesi göstermek anlamsız).
- Filtre: `session.startedAt` window içinde olacak. Periyot kesintisinde bitmiş session'lar `startedAt`'in düştüğü periyoda sayılır (tutarlılık için; rapor periyot başı/sonu gri alanını minimize eder).
- Soft-delete edilmiş venue/spot/manager kayıtları **görünmeye devam eder** (audit). Sadece session'ın kendisi soft-delete olamaz.

### 3.3 Revenue tanımı

```
session.totalAmount = subtotal (zaman ücreti, indirim sonrası) + productsAmount (snapshot toplamı)
revenue            = SUM(session.totalAmount) over the window
```

`productsAmount` = `SUM(session_products.price_snapshot)` — ürün satışları zaten `Session.totalAmount`'a dahil değildir (Session entity'sinde ayrı kolon yok; runtime'da `SUM` ile gelir, [product-api.md](product-api.md) §"Session response uzantısı"). Manager reports için backend bu iki kalemi her satırda **birleştirir** ve session card'da `subtotal` / `productsAmount` / `totalAmount` üçünü birden döner.

### 3.4 "На смене" / "On shift" tanımı

```
shiftSeconds = SUM(session.durationSeconds) over COMPLETED sessions in window
```

`durationSeconds` zaten `(endedAt - startedAt) - totalPausedSeconds` formülünden geliyor — yani pause'lar düşülmüş net billable süre. Manager'ın gerçekten masaba bakıp para kazandırdığı toplam saat.

**Neden clock-time değil?** Eğer iki session paralel çalışsaydı (mümkün; bir manager iki spot'u aynı anda yönetebilir) clock-time çift sayardı. `durationSeconds` toplamı ek bir join gerektirmez ve manager'ın "ne kadar çalıştı" sorusuna en doğru cevabı verir.

### 3.5 Para birimi

Manager genelde tek owner altında çalışır → o owner'ın spot'larındaki tüm currency'ler tipik olarak aynıdır. Bu varsayım altında:

- Tüm response'larda **tek bir `currency`** alanı döner.
- Hesap: window'daki session'ların en sık görülen `currency`'si (mode). Bağ koparmak için owner'ın seçili venue'sunun currency'si fallback.
- Mixed currency uyarısı: window içinde >1 farklı currency varsa response header'a `X-Mixed-Currency: true` eklenir; revenue alanı yalnızca dominant currency cinsinden toplanır, diğer currency'ler **dışarıda bırakılır**. Mobile bu durumda ufak bir info çipi gösterebilir.
- v1'de bu nadir bir kenar durum; daha kompleks bir multi-currency breakdown ileride eklenebilir.

### 3.6 "Выходной" / Rest day kuralı

Week ve Month list'leri **periyot boyunca her gün için bir kart** döner — session olmasa bile. Boş günlerde:

```json
{ "revenue": 0, "sessions": 0, "shiftSeconds": 0, "isDayOff": true }
```

Mobile bu kartı "Выходной / Off day" olarak çizer; tıklanmaz veya boş day-detail'e götürür (UI kararı, backend her iki durumda aynı response'u döner).

### 3.7 Year view — progress bar ve "СЕЙЧАС" badge

Year list'inde her ayın `progressRatio` alanı vardır:

```
progressRatio = revenue / max(revenue across the 12 months in this year)
```

- Tüm aylar 0 ise tüm `progressRatio = 0`.
- Henüz başlamamış (gelecekteki) aylar `isFuture = true` döner; mobile bu kartları **gri/disabled** çizer.
- İçinde bulunulan ay `isCurrent = true` döner; mobile **"СЕЙЧАС"** chip'i çizer.

### 3.8 Pagination yok (v1)

- Today / day-detail: tipik gün 5-30 session — pagination yok. Eğer ileride >100 sessions olursa ayrı `?cursor=` eklenir.
- Week: 7 gün — sabit.
- Month: 28-31 gün — sabit.
- Year: 12 ay — sabit.

### 3.9 Cache stratejisi

| Endpoint | Cache TTL | Gerekçe                                                            |
| -------- | :-------: | ------------------------------------------------------------------ |
| TODAY    |    30s    | Manager session'ı yeni bitirdi → biraz sonra refresh'te göstermeli |
| WEEK     |    2dk    | Bugün hâlâ değişebilir, geçmiş günler değişmez                     |
| MONTH    |    5dk    | Aynı                                                               |
| YEAR     |   15dk    | Bu ay değişebilir, geçmiş aylar sabit                              |
| day/{}   |  varies   | Tarih bugünse 30s, geçmişse 1 saat (geçmiş zaten immutable)        |
| month/{} |  varies   | Aynı: ay bu ay ise 5 dk, geçmiş ay ise 1 saat                      |

Cache key: `(userId, period, timezone, todayLocal)`. `todayLocal` key'e dahil çünkü gece yarısı geçince TODAY/WEEK/MONTH/YEAR window'ları kaymalı.

---

## 4. Domain modelleri

### 4.1 `ReportSummary` — turuncu özet kartının kaynağı

```ts
{
  revenue: integer,            // window içindeki COMPLETED session totalAmount toplamı
  currency: "KGS" | "USD" | "RUB" | "KZT" | "TRY",
  sessions: integer,           // COMPLETED session sayısı
  shiftSeconds: integer        // SUM(durationSeconds), pause'lar dışlanmış
}
```

### 4.2 `SessionCard` — today/day-detail listesinin satırı

```ts
{
  id: string (uuid),                   // session id
  spotId: string (uuid),
  spotName: string | null,             // null ise mobile "Стол {spotNumber}" çiziyor
  spotNumber: integer,
  venueId: string (uuid),
  venueName: string,                   // "Стол 3 «Основной»" alt-başlığı için
  venueType: VenueType,                // ikon seçimi için
  customerName: string | null,         // session start'ta yazıldıysa
  startedAt: string (ISO 8601),
  endedAt: string (ISO 8601),
  durationSeconds: integer,
  currency: enum,
  subtotal: integer,                   // zaman ücreti (indirim sonrası)
  productsAmount: integer,             // 0 olabilir
  totalAmount: integer                 // subtotal + productsAmount
}
```

> Mobile'ın "646 сом + товары 129" tarzı gösterimi için `subtotal` ve `productsAmount` ayrı tutulur; mobile birleşik veya iki satır olarak çizebilir.

### 4.3 `DayCard` — week ve month listelerinin satırı

```ts
{
  date: string (YYYY-MM-DD),           // local timezone'da gün
  dayOfWeek: "MONDAY" | "TUESDAY" | … | "SUNDAY",
  dayOfMonth: integer,                 // 1-31 — UI sol köşedeki büyük rakam ("18")
  shortDayOfWeek: "MON" | "TUE" | …,   // backend Turkish/Russian değil İngilizce enum döner; mobile i18n
  revenue: integer,
  currency: enum,
  sessions: integer,
  shiftSeconds: integer,
  isToday: boolean,                    // mobile "bugün" highlight'ı için
  isFuture: boolean,                   // mobile gri kart çizmek için (month tab'da gelecek günler)
  isDayOff: boolean                    // sessions == 0 iken true; "Выходной" kartı
}
```

### 4.4 `MonthCard` — year listesinin satırı

```ts
{
  year: integer,                       // 2026
  month: integer,                      // 1-12
  monthShort: "JAN" | "FEB" | …,       // backend enum; mobile i18n
  revenue: integer,
  currency: enum,
  sessions: integer,
  shiftSeconds: integer,
  isCurrent: boolean,                  // "СЕЙЧАС" badge
  isFuture: boolean,                   // grayed-out
  progressRatio: number                // 0.0 - 1.0 (en yüksek aya göre normalleştirilmiş)
}
```

### 4.5 Wrapper response'lar

#### `TodayReport`

```ts
{
  date: string (YYYY-MM-DD),
  dayOfWeek: enum,
  summary: ReportSummary,
  sessions: SessionCard[]              // startedAt ASC
}
```

#### `WeekReport`

```ts
{
  weekStart: string (YYYY-MM-DD),      // ISO 8601 Pazartesi
  weekEnd:   string (YYYY-MM-DD),      // ISO 8601 Pazar (inclusive)
  summary: ReportSummary,              // tüm hafta toplamı
  days: DayCard[]                      // her zaman 7 satır, tarih ASC
}
```

#### `MonthReport`

```ts
{
  year: integer,
  month: integer,                      // 1-12
  monthShort: enum,
  summary: ReportSummary,
  days: DayCard[]                      // ayın gün sayısı kadar (28/29/30/31), tarih ASC
}
```

#### `YearReport`

```ts
{
  year: integer,
  summary: ReportSummary,
  months: MonthCard[]                  // her zaman 12 satır, Ocak→Aralık
}
```

#### `DayDetail` = `TodayReport` (aynı şema)

#### `MonthDetail` = `MonthReport` (aynı şema)

---

## 5. Endpoint'ler

### 5.1 GET `/api/v1/manager-reports?period=TODAY`

Today tab'ı açıldığında çağrılır.

**Query:**

| Param      | Type | Required | Notes                                  |
| ---------- | ---- | :------: | -------------------------------------- |
| `period`   | enum |    ✅    | `TODAY` \| `WEEK` \| `MONTH` \| `YEAR` |
| `timezone` | IANA |    ❌    | Default `Asia/Bishkek`                 |

**Response 200 (period=TODAY) — `TodayReport`:**

```json
{
  "date": "2026-05-24",
  "dayOfWeek": "SUNDAY",
  "summary": {
    "revenue": 1380,
    "currency": "KGS",
    "sessions": 3,
    "shiftSeconds": 16560
  },
  "sessions": [
    {
      "id": "770e8400-…-a",
      "spotId": "660e8400-…-a",
      "spotName": "Стол 3",
      "spotNumber": 3,
      "venueId": "550e8400-…-a",
      "venueName": "Основной",
      "venueType": "BILLIARDS",
      "customerName": null,
      "startedAt": "2026-05-24T05:02:00Z",
      "endedAt": "2026-05-24T07:24:00Z",
      "durationSeconds": 8520,
      "currency": "KGS",
      "subtotal": 473,
      "productsAmount": 0,
      "totalAmount": 473
    },
    {
      "id": "770e8400-…-b",
      "spotId": "660e8400-…-b",
      "spotName": "Стол 4",
      "spotNumber": 4,
      "venueId": "550e8400-…-a",
      "venueName": "У окна",
      "venueType": "BILLIARDS",
      "customerName": "Asan",
      "startedAt": "2026-05-24T07:41:00Z",
      "endedAt": "2026-05-24T10:16:00Z",
      "durationSeconds": 9300,
      "currency": "KGS",
      "subtotal": 517,
      "productsAmount": 129,
      "totalAmount": 646
    }
  ]
}
```

> Sessions `startedAt ASC` döner — mobile listeyi olduğu gibi çizer (kronolojik).

---

### 5.2 GET `/api/v1/manager-reports?period=WEEK`

**Response 200 — `WeekReport`:**

```json
{
  "weekStart": "2026-05-18",
  "weekEnd": "2026-05-24",
  "summary": {
    "revenue": 6949,
    "currency": "KGS",
    "sessions": 17,
    "shiftSeconds": 85680
  },
  "days": [
    {
      "date": "2026-05-18",
      "dayOfWeek": "MONDAY",
      "dayOfMonth": 18,
      "shortDayOfWeek": "MON",
      "revenue": 633,
      "currency": "KGS",
      "sessions": 2,
      "shiftSeconds": 9120,
      "isToday": false,
      "isFuture": false,
      "isDayOff": false
    },
    {
      "date": "2026-05-19",
      "dayOfWeek": "TUESDAY",
      "dayOfMonth": 19,
      "shortDayOfWeek": "TUE",
      "revenue": 633,
      "currency": "KGS",
      "sessions": 2,
      "shiftSeconds": 9120,
      "isToday": false,
      "isFuture": false,
      "isDayOff": false
    },
    {
      "date": "2026-05-20",
      "dayOfWeek": "WEDNESDAY",
      "dayOfMonth": 20,
      "shortDayOfWeek": "WED",
      "revenue": 1260,
      "currency": "KGS",
      "sessions": 2,
      "shiftSeconds": 12960,
      "isToday": false,
      "isFuture": false,
      "isDayOff": false
    },
    {
      "date": "2026-05-21",
      "dayOfWeek": "THURSDAY",
      "dayOfMonth": 21,
      "shortDayOfWeek": "THU",
      "revenue": 853,
      "currency": "KGS",
      "sessions": 2,
      "shiftSeconds": 7680,
      "isToday": false,
      "isFuture": false,
      "isDayOff": false
    },
    {
      "date": "2026-05-22",
      "dayOfWeek": "FRIDAY",
      "dayOfMonth": 22,
      "shortDayOfWeek": "FRI",
      "revenue": 1190,
      "currency": "KGS",
      "sessions": 3,
      "shiftSeconds": 12240,
      "isToday": false,
      "isFuture": false,
      "isDayOff": false
    },
    {
      "date": "2026-05-23",
      "dayOfWeek": "SATURDAY",
      "dayOfMonth": 23,
      "shortDayOfWeek": "SAT",
      "revenue": 1000,
      "currency": "KGS",
      "sessions": 3,
      "shiftSeconds": 18000,
      "isToday": false,
      "isFuture": false,
      "isDayOff": false
    },
    {
      "date": "2026-05-24",
      "dayOfWeek": "SUNDAY",
      "dayOfMonth": 24,
      "shortDayOfWeek": "SUN",
      "revenue": 1380,
      "currency": "KGS",
      "sessions": 3,
      "shiftSeconds": 16560,
      "isToday": true,
      "isFuture": false,
      "isDayOff": false
    }
  ]
}
```

> 7 günlük döner, **her zaman 7 satır** — boş günler `isDayOff: true` ile yer alır.

---

### 5.3 GET `/api/v1/manager-reports?period=MONTH`

**Response 200 — `MonthReport`:**

```json
{
  "year": 2026,
  "month": 5,
  "monthShort": "MAY",
  "summary": {
    "revenue": 28218,
    "currency": "KGS",
    "sessions": 63,
    "shiftSeconds": 326640
  },
  "days": [
    {
      "date": "2026-05-01",
      "dayOfWeek": "FRIDAY",
      "dayOfMonth": 1,
      "shortDayOfWeek": "FRI",
      "revenue": 600,
      "currency": "KGS",
      "sessions": 3,
      "shiftSeconds": 10800,
      "isToday": false,
      "isFuture": false,
      "isDayOff": false
    },
    {
      "date": "2026-05-02",
      "dayOfWeek": "SATURDAY",
      "dayOfMonth": 2,
      "shortDayOfWeek": "SAT",
      "revenue": 1280,
      "currency": "KGS",
      "sessions": 3,
      "shiftSeconds": 11520,
      "isToday": false,
      "isFuture": false,
      "isDayOff": false
    }
    // ... 31 satıra kadar
  ]
}
```

> Her zaman ayın gün sayısı kadar satır döner; gelecek günler için `isFuture: true`, sıfır-session günler için `isDayOff: true`.

---

### 5.4 GET `/api/v1/manager-reports?period=YEAR`

**Response 200 — `YearReport`:**

```json
{
  "year": 2026,
  "summary": {
    "revenue": 144989,
    "currency": "KGS",
    "sessions": 330,
    "shiftSeconds": 1728480
  },
  "months": [
    {
      "year": 2026,
      "month": 1,
      "monthShort": "JAN",
      "revenue": 30364,
      "currency": "KGS",
      "sessions": 69,
      "shiftSeconds": 355680,
      "isCurrent": false,
      "isFuture": false,
      "progressRatio": 1.0
    },
    {
      "year": 2026,
      "month": 2,
      "monthShort": "FEB",
      "revenue": 29433,
      "currency": "KGS",
      "sessions": 68,
      "shiftSeconds": 352560,
      "isCurrent": false,
      "isFuture": false,
      "progressRatio": 0.97
    },
    {
      "year": 2026,
      "month": 3,
      "monthShort": "MAR",
      "revenue": 27586,
      "currency": "KGS",
      "sessions": 64,
      "shiftSeconds": 341280,
      "isCurrent": false,
      "isFuture": false,
      "progressRatio": 0.91
    },
    {
      "year": 2026,
      "month": 4,
      "monthShort": "APR",
      "revenue": 29388,
      "currency": "KGS",
      "sessions": 66,
      "shiftSeconds": 352320,
      "isCurrent": false,
      "isFuture": false,
      "progressRatio": 0.97
    },
    {
      "year": 2026,
      "month": 5,
      "monthShort": "MAY",
      "revenue": 28218,
      "currency": "KGS",
      "sessions": 63,
      "shiftSeconds": 326640,
      "isCurrent": true,
      "isFuture": false,
      "progressRatio": 0.93
    },
    {
      "year": 2026,
      "month": 6,
      "monthShort": "JUN",
      "revenue": 0,
      "currency": "KGS",
      "sessions": 0,
      "shiftSeconds": 0,
      "isCurrent": false,
      "isFuture": true,
      "progressRatio": 0.0
    },
    {
      "year": 2026,
      "month": 7,
      "monthShort": "JUL",
      "revenue": 0,
      "currency": "KGS",
      "sessions": 0,
      "shiftSeconds": 0,
      "isCurrent": false,
      "isFuture": true,
      "progressRatio": 0.0
    },
    {
      "year": 2026,
      "month": 8,
      "monthShort": "AUG",
      "revenue": 0,
      "currency": "KGS",
      "sessions": 0,
      "shiftSeconds": 0,
      "isCurrent": false,
      "isFuture": true,
      "progressRatio": 0.0
    },
    {
      "year": 2026,
      "month": 9,
      "monthShort": "SEP",
      "revenue": 0,
      "currency": "KGS",
      "sessions": 0,
      "shiftSeconds": 0,
      "isCurrent": false,
      "isFuture": true,
      "progressRatio": 0.0
    },
    {
      "year": 2026,
      "month": 10,
      "monthShort": "OCT",
      "revenue": 0,
      "currency": "KGS",
      "sessions": 0,
      "shiftSeconds": 0,
      "isCurrent": false,
      "isFuture": true,
      "progressRatio": 0.0
    },
    {
      "year": 2026,
      "month": 11,
      "monthShort": "NOV",
      "revenue": 0,
      "currency": "KGS",
      "sessions": 0,
      "shiftSeconds": 0,
      "isCurrent": false,
      "isFuture": true,
      "progressRatio": 0.0
    },
    {
      "year": 2026,
      "month": 12,
      "monthShort": "DEC",
      "revenue": 0,
      "currency": "KGS",
      "sessions": 0,
      "shiftSeconds": 0,
      "isCurrent": false,
      "isFuture": true,
      "progressRatio": 0.0
    }
  ]
}
```

> 12 ay her zaman döner. `progressRatio` o yıl içindeki **en yüksek revenue**'ya göre normalize edilmiş. Tüm aylar 0 ise hepsi 0.

---

### 5.5 GET `/api/v1/manager-reports/days/{date}`

Week veya Month listesinden bir güne tıklandığında.

**Path Params:**

- `date` — `YYYY-MM-DD` (örn. `2026-05-18`).

**Query:**

| Param      | Type | Required | Notes                  |
| ---------- | ---- | :------: | ---------------------- |
| `timezone` | IANA |    ❌    | Default `Asia/Bishkek` |

**Response 200 — `DayDetail` (= `TodayReport` şeması):**

```json
{
  "date": "2026-05-18",
  "dayOfWeek": "MONDAY",
  "summary": {
    "revenue": 633,
    "currency": "KGS",
    "sessions": 2,
    "shiftSeconds": 9120
  },
  "sessions": [
    {
      "id": "770e8400-…-x",
      "spotId": "660e8400-…-x",
      "spotName": "Стол 5",
      "spotNumber": 5,
      "venueId": "550e8400-…-a",
      "venueName": "Снукер",
      "venueType": "BILLIARDS",
      "customerName": null,
      "startedAt": "2026-05-18T05:16:00Z",
      "endedAt": "2026-05-18T06:02:00Z",
      "durationSeconds": 2760,
      "currency": "KGS",
      "subtotal": 307,
      "productsAmount": 0,
      "totalAmount": 307
    },
    {
      "id": "770e8400-…-y",
      "spotId": "660e8400-…-y",
      "spotName": "Стол 6",
      "spotNumber": 6,
      "venueId": "550e8400-…-a",
      "venueName": "Основной",
      "venueType": "BILLIARDS",
      "customerName": null,
      "startedAt": "2026-05-18T06:33:00Z",
      "endedAt": "2026-05-18T07:32:00Z",
      "durationSeconds": 3540,
      "currency": "KGS",
      "subtotal": 197,
      "productsAmount": 0,
      "totalAmount": 197
    }
  ]
}
```

> Boş gün (`Выходной`): `sessions: []` ve summary 0/0/0. Mobile bu durumda da kullanıcıyı bu ekrana göndermek isteyebilir; backend uyumlu boş response döner — `404` dönmez.

---

### 5.6 GET `/api/v1/manager-reports/months/{yearMonth}`

Year listesinden bir aya tıklandığında.

**Path Params:**

- `yearMonth` — `YYYY-MM` (örn. `2026-01`).

**Query:**

| Param      | Type | Required | Notes                  |
| ---------- | ---- | :------: | ---------------------- |
| `timezone` | IANA |    ❌    | Default `Asia/Bishkek` |

**Response 200 — `MonthDetail` (= `MonthReport` şeması):**

```json
{
  "year": 2026,
  "month": 1,
  "monthShort": "JAN",
  "summary": {
    "revenue": 30364,
    "currency": "KGS",
    "sessions": 69,
    "shiftSeconds": 355680
  },
  "days": [
    {
      "date": "2026-01-01",
      "dayOfWeek": "THURSDAY",
      "dayOfMonth": 1,
      "shortDayOfWeek": "THU",
      "revenue": 1120,
      "currency": "KGS",
      "sessions": 2,
      "shiftSeconds": 13440,
      "isToday": false,
      "isFuture": false,
      "isDayOff": false
    },
    {
      "date": "2026-01-02",
      "dayOfWeek": "FRIDAY",
      "dayOfMonth": 2,
      "shortDayOfWeek": "FRI",
      "revenue": 0,
      "currency": "KGS",
      "sessions": 0,
      "shiftSeconds": 0,
      "isToday": false,
      "isFuture": false,
      "isDayOff": true
    },
    {
      "date": "2026-01-03",
      "dayOfWeek": "SATURDAY",
      "dayOfMonth": 3,
      "shortDayOfWeek": "SAT",
      "revenue": 1000,
      "currency": "KGS",
      "sessions": 3,
      "shiftSeconds": 18000,
      "isToday": false,
      "isFuture": false,
      "isDayOff": false
    }
    // ... ayın tamamı
  ]
}
```

---

## 6. Hata kodları

`AppException` + `GlobalExceptionHandler` zarfı kullanılır (proje konvansiyonu — bkz. [CLAUDE.md](../CLAUDE.md#error-model--single-source-of-truth)):

```json
{
  "code": "INVALID_TIMEZONE",
  "message": {
    "en": "Invalid timezone identifier",
    "ru": "Некорректный часовой пояс",
    "ky": "Жараксыз убакыт алкагы"
  },
  "details": null
}
```

| Code                 | HTTP | Trigger                                                                       |
| -------------------- | :--: | ----------------------------------------------------------------------------- |
| `BAD_REQUEST`        | 400  | `period` eksik / enum dışı                                                    |
| `INVALID_TIMEZONE`   | 400  | `timezone` IANA değil ya da `ZoneId.of()` reddediyor                          |
| `INVALID_DATE`       | 400  | Path `date` `YYYY-MM-DD` formatında değil veya geçersiz takvim günü           |
| `INVALID_YEAR_MONTH` | 400  | Path `yearMonth` `YYYY-MM` formatında değil                                   |
| `UNAUTHORIZED`       | 400  | Bearer yok / token bozuk                                                      |
| `SESSION_EXPIRED`    | 401  | Access token expired                                                          |
| `FORBIDDEN`          | 403  | (şu an tetiklenmez; ileride OWNER-only veya MANAGER-only ayrımı için reserve) |

> Yeni eklenen kodlar (`INVALID_TIMEZONE`, `INVALID_DATE`, `INVALID_YEAR_MONTH`) `messages.properties`, `messages_ru.properties`, `messages_ky.properties` üçüne birden eklenmelidir.

---

## 7. Backend implementasyon notları (senior engineer'a brief)

### 7.1 Yeni dosyalar

```
kg.sportmanager/
├── controller/
│   └── ManagerReportsController.java       # /api/v1/manager-reports + drilldown'lar
├── service/
│   ├── ManagerReportsService.java          # interface
│   └── impl/
│       └── ManagerReportsServiceImpl.java  # pencere hesabı + aggregation orkestrasyonu
├── dto/response/
│   ├── ManagerReportSummary.java
│   ├── ManagerSessionCard.java
│   ├── ManagerDayCard.java
│   ├── ManagerMonthCard.java
│   ├── ManagerTodayReport.java   # = DayDetail
│   ├── ManagerWeekReport.java
│   ├── ManagerMonthReport.java   # = MonthDetail
│   └── ManagerYearReport.java
└── enums/
    └── ManagerReportPeriod.java            # TODAY | WEEK | MONTH | YEAR
```

`util/ManagerReportMapper.java` (veya mevcut `SessionMapper`'a yeni metotlar) — `Session` → `ManagerSessionCard`, `(LocalDate, AggRow)` → `ManagerDayCard` dönüşümlerini barındırır.

### 7.2 Repository sorguları

Yeni metotlar `SessionRepository`'ye eklenir (yeni repository açmaya gerek yok):

```java
// SessionRepository.java
@Query("""
    select s
      from Session s
      where s.managerId = :managerId
        and s.status = COMPLETED
        and s.startedAt >= :fromUtc
        and s.startedAt <  :toUtc
      order by s.startedAt asc
    """)
List<Session> findCompletedByManagerInRange(UUID managerId,
                                            Instant fromUtc,
                                            Instant toUtc);
```

Aggregate sorgular bucket bazında native SQL ile daha verimli. Postgres'in `date_trunc('day', s.started_at AT TIME ZONE :tz)` yapısı tek sorguda gün/ay bucket'larını döndürebilir:

```sql
-- Day buckets in user's timezone for [from, to)
select
    (date_trunc('day', s.started_at AT TIME ZONE :tz))::date     as day_local,
    count(*)                                                     as sessions,
    coalesce(sum(s.total_amount), 0)                             as revenue,
    coalesce(sum(s.duration_seconds), 0)                         as shift_seconds
from sessions s
where s.manager_id = :managerId
  and s.status = 'COMPLETED'
  and s.started_at >= :fromUtc
  and s.started_at <  :toUtc
group by day_local
order by day_local;
```

Aynı şablon `date_trunc('month', …)` ile yıl tab'ında kullanılır. Boş gün/ay'lar (rest day, future month) **kodda** doldurulur: SQL'den dönen bucket map'ini `from`→`to` aralığındaki her güne karşı `Map.getOrDefault(day, zero)` ile zenginleştir.

### 7.3 Indeksleme (yeni Flyway migration)

`V8__manager_reports_index.sql`:

```sql
-- Manager reports için critical access pattern: (manager_id, status, started_at)
-- Mevcut index'ler kontrol edilmeli; yoksa eklenmelidir.

CREATE INDEX IF NOT EXISTS idx_sessions_manager_status_started
  ON sessions (manager_id, status, started_at)
  WHERE status = 'COMPLETED';
```

Partial index → tablo büyüdükçe daha küçük; rapor sorgusu zaten `status = 'COMPLETED'` filtrelediği için ideal.

Migration eklemeden önce mevcut migration'lar (`V1..V7`) ile çakışma olmadığı doğrulanmalı; prod'da `ddl-auto=validate` olduğu için yeni index sadece migration üzerinden gelir.

### 7.4 Timezone yardımcısı

`ManagerReportsServiceImpl` içinde:

```java
private static final ZoneId DEFAULT_TZ = ZoneId.of("Asia/Bishkek");

private static ZoneId resolveZone(String raw) {
    if (raw == null || raw.isBlank()) return DEFAULT_TZ;
    try {
        return ZoneId.of(raw);
    } catch (DateTimeException ex) {
        throw new AppException("INVALID_TIMEZONE", HttpStatus.BAD_REQUEST);
    }
}

private static Window windowFor(ManagerReportPeriod period, ZoneId zone, Clock clock) {
    LocalDate today    = LocalDate.now(clock.withZone(zone));
    LocalDate startDay = switch (period) {
        case TODAY -> today;
        case WEEK  -> today.with(DayOfWeek.MONDAY);              // ISO 8601 başı
        case MONTH -> today.withDayOfMonth(1);
        case YEAR  -> today.withDayOfYear(1);
    };
    LocalDate endDayExcl = today.plusDays(1);
    Instant from = startDay.atStartOfDay(zone).toInstant();
    Instant to   = endDayExcl.atStartOfDay(zone).toInstant();
    return new Window(from, to, zone, today);
}
```

`Clock` field'ı testlerde sabit zaman enjekte edebilmek için bean olarak constructor-inject edilmeli (mevcut projedeki diğer service'lerde de yararlı olur — `Instant.now()` direct kullanımları yerine).

### 7.5 Security

Yeni endpoint pattern'i `SecurityConfiguration`'a açıkça eklemeye gerek yok — default olarak `/api/v1/**` zaten authenticated. Service tarafında ek role check'i de yok (OWNER + MANAGER ikisi de çağırabilir).

`@AuthenticationPrincipal User currentUser` → `currentUser.getId()` her sorguda `managerId` olarak verilir. **Hiçbir yerde kullanıcı id'sini query'den/path'ten almayın** — sahte id ile başkasının raporu çekilebilir.

### 7.6 Subscription gate

`@RequiresActiveSubscription` **eklenmez**. Manager reports read-only; expired owner altındaki manager bile kendi geçmişini görebilmeli. Ödeme paywall'ı yalnızca write akışlarında ([subscription-api.md §Subscription gate](subscription-api.md#subscription-gate--diğer-endpointlere-etkisi)).

### 7.7 i18n

Endpoint **enum'ları İngilizce** döner (`MONDAY`, `JAN`, vb.) ve mobile i18n yapar. Error mesajları proje konvansiyonuna göre üç dilde döner (mevcut `messages_*.properties` üçüne yeni kod eklenir).

### 7.8 Test stratejisi

1. **Unit test** — `windowFor()` her periyot + timezone kombosu için doğru `[from, to)` üretiyor mu?
2. **Integration test** (Testcontainers Postgres) — seed:
   - 1 owner + 1 manager + 2 venues + 3 spots + ~30 session (farklı tarihlerde, bazıları CANCELLED, bazıları başka manager'a ait)
   - Her endpoint için: sadece bu manager'ın session'ları geliyor mu, CANCELLED görünmüyor mu, `Выходной` (zero-session) günleri var mı, `isFuture` doğru mu, `progressRatio` normalize mi.
3. **Timezone edge** — `2026-05-24T23:59:00+06:00` (Bishkek 23:59) ile `2026-05-25T00:01:00+06:00` (yeni gün); TODAY'in pencerelerinin doğru ayrıştığı.
4. **Empty manager** — hiç session başlatmamış manager → tüm response'lar 200, summary sıfır, `days[]`/`months[]` dolu (rest day kartları).
5. **Mixed currency** — 2 venue farklı currency → response dominant currency'yi seçiyor + `X-Mixed-Currency: true` header.

### 7.9 Cache (opsiyonel v1.1)

İlk sürümde cache koymadan da kabul edilebilir performans alınır (rapor sorguları COMPLETED-only partial index üzerinden). Trafik artarsa Spring Cache + `@Cacheable("managerReports")` ile §3.9 tablosundaki TTL'leri Caffeine cache provider üzerinden uygulanabilir.

### 7.10 OpenAPI/Swagger

Mevcut `springdoc-openapi` her controller'ı otomatik tarayacak. `@Operation`/`@Schema` ile model isimlerini Swagger UI'da netleştirmek mobile entegrasyonunu kolaylaştırır (özellikle `oneOf` benzeri durumlar olmadığı için ekstra config'e gerek yok).

---

## 8. Endpoint özeti

| Method | Path                                         | Auth          | Cache   |
| ------ | -------------------------------------------- | ------------- | ------- |
| GET    | `/api/v1/manager-reports?period=TODAY`       | OWNER/MANAGER | 30s     |
| GET    | `/api/v1/manager-reports?period=WEEK`        | OWNER/MANAGER | 2dk     |
| GET    | `/api/v1/manager-reports?period=MONTH`       | OWNER/MANAGER | 5dk     |
| GET    | `/api/v1/manager-reports?period=YEAR`        | OWNER/MANAGER | 15dk    |
| GET    | `/api/v1/manager-reports/days/{date}`        | OWNER/MANAGER | 30s/1sa |
| GET    | `/api/v1/manager-reports/months/{yearMonth}` | OWNER/MANAGER | 5dk/1sa |

---

## 9. CLAUDE.md güncellemeleri (öneri)

Yeni modül eklendikten sonra root `CLAUDE.md` dosyasındaki controller listesine:

```
- [ManagerReportsController](src/main/java/kg/sportmanager/controller/ManagerReportsController.java)
  — `/api/v1/manager-reports/**` (manager'ın kendi günlük/haftalık/aylık/yıllık performansı)
```

ve "Auth rules" altına şunu eklemek:

> Manager reports endpoint'leri (`/api/v1/manager-reports/**`) OWNER + MANAGER ikisine de açıktır; data her zaman `currentUser.id` ile scope edilir.

---

## 10. Mobile için notlar (kısaca)

- Tab değişiminde mobile yeni endpoint'i çağırır; ara cache'te tutabilir ama TODAY için TTL kısa olmalı.
- Week/Month listede tıklanan gün → `/days/{YYYY-MM-DD}` çağrısı; mobile back stack'i yönetir.
- Year listede tıklanan ay → `/months/{YYYY-MM}` çağrısı.
- `isFuture: true` kartlar tıklanmamalı (UI gri gösterir).
- `isDayOff: true` (rest day) kartlar — UX kararı: tıklanmasın veya boş day-detail'e götürsün, backend ikisini de destekler.
- `progressRatio` `0..1` arası float; mobile bar genişliğini `width × progressRatio` ile çizer.
- "СЕЙЧАС" / "TODAY" badge: backend `isCurrent` / `isToday` döner; mobile i18n.
