# Session — `customerName` Eklentisi (Backend)

> **Amaç.** Session başlatılırken **opsiyonel** bir müşteri adı kaydedilebilsin. Müşteri oyunu bitirip masayı kapatmaya geldiğinde manager / owner doğru session'ı masa numarası yerine isimden de bulabilsin. Tamamlanmış (COMPLETED / CANCELLED) session'larda da bu ad korunur — rapor tarafı ileride "en sık gelen müşteriler" gibi analizleri buradan üretebilir.
>
> **Bağlam.** Bu dosya [session_api.md](session_api.md)'in **delta**'sıdır — yalnızca değişen / eklenen alanlar listelenir. Diğer her şey (lifecycle, snapshot kuralı, `managerId` audit, error code'ları, abonelik gate) aynen kalır.

---

## 1. Veri modeli

### DB

`sessions` tablosuna yeni kolon:

| Kolon           | Tip           | Null | Default | Notlar                                                   |
| --------------- | ------------- | :--: | :-----: | -------------------------------------------------------- |
| `customer_name` | `VARCHAR(80)` |  ✅  | `NULL`  | Trim'lenmiş, boş string saklanmaz; boşsa `NULL` yazılır. |

- **Index gerekmez** (v1'de). İleride "en sık gelen müşteri" analizi açılırsa `(venue_id, customer_name)` üzerine non-unique partial index düşünülür — ayrı bir karar olarak gelecek sürüme bırakıldı.
- **Unique değildir.** Aynı isim aynı venue'da defalarca geçebilir; isim sadece görsel/arama amaçlı bir etikettir, müşteri kayıt sistemi değildir.

### JSON sözleşmesi

Her iki response tipine (`SessionLite` ve `SessionResult`) tek yeni alan eklenir:

```diff
 {
   "id": "...",
   "tableId": "...",
   "managerId": "...",
+  "customerName": "Asan" | null,
   ...
 }
```

- Alan **her zaman döner** (mevcutsa string, yoksa `null`). Mobile tarafı varlığını kontrol etmek için ek bir alan beklemez.
- `SessionLite` (start / pause / resume response'ları ve `venue/selected` / `home` içine gömülü session) ve `SessionResult` (finish / cancel response'ları, reports listeleri) — **hepsi** `customerName` taşır.

### Snapshot kuralı

`customerName` start anında yazılır ve **session boyunca değişmez**. Pause / resume / finish / cancel sırasında değiştirilemez — gönderilse bile yok sayılır. (Eğer ileride "ismi düzelt" ihtiyacı çıkarsa ayrı bir endpoint açılır; v1'de yoktur.)

---

## 2. Endpoint değişiklikleri

### `POST /api/v1/session/start`

**Request body — yeni opsiyonel alan:**

```diff
 {
   "tableId": "660e8400-e29b-41d4-a716-446655440001",
+  "customerName": "Asan"
 }
```

**Validation:**

| Field          | Type   | Required | Rules                                                                                                               |
| -------------- | ------ | :------: | ------------------------------------------------------------------------------------------------------------------- |
| `tableId`      | uuid   |    ✅    | Mevcut kural                                                                                                        |
| `customerName` | string |    ❌    | Trim sonrası **1-80 karakter**. Trim sonrası boşsa `NULL` olarak saklanır (400 dönülmez — istemci için gürültüsüz). |

- Body'de **yoksa** veya `null` ise → DB'ye `NULL` yazılır.
- 80 karakterden uzunsa → **`422 INVALID_CUSTOMER_NAME`**.
- Çok satırlı / kontrol karakteri (`\n`, `\t`) içeriyorsa → trim sırasında tek boşluğa indirgenir; reject etmez.

**Response (201) — `SessionLite`:**

```diff
 {
   "id": "770e8400-...",
   "tableId": "660e8400-...",
   "managerId": "user-101",
+  "customerName": "Asan",
   "status": "ACTIVE",
   ...
 }
```

### Diğer endpoint'ler

`pause` / `resume` / `finish` / `cancel`:

- **Request body değişmez.** İstemci bu endpoint'lere `customerName` göndermez; gönderse bile **yok sayılır** (silent ignore). Bu, manager'ın isim değiştirip raporu manipüle etmesini engeller.
- **Response'larda `customerName` döner** (start'ta yazılmış değer). PAUSED / ACTIVE / COMPLETED / CANCELLED — fark etmez.

### Diğer dönüşler (embedded session)

`customerName` taşıyan başka noktalar:

- `GET /api/v1/venue/selected` → her `table.session` içinde.
- `GET /api/v1/home/...` → her aktif session'ın embed'inde.
- Reports endpoint'lerinde session listesi dönen tüm yerler ([reports-api.md](reports-api.md)).

**Reports etkisi (v1):** alan dönmeye başlar; **filtreleme / grup­lama yapılmaz**. "En sık gelen müşteri" sıralaması açıkça **gelecek sürümlere bırakıldı**, v1 scope dışındadır.

---

## 3. Error code'ları

Mevcut error code listesine **bir tane** eklenir:

| Code                    | HTTP | Anlamı                                             |
| ----------------------- | :--: | -------------------------------------------------- |
| `INVALID_CUSTOMER_NAME` | 422  | `customerName` 80 karakteri aşıyor (trim sonrası). |

Hata mesajı 3 dilde (`ru`, `en`, `ky`) hazırlanır — diğer 4xx hataları gibi `BaseMessage` formatında. Trim sonrası boş string için **error dönülmez**, `NULL`'a düşürülür (UX gürültüsünü azaltır).

Diğer hiçbir error code değişmez.

---

## 4. Authorization

- `customerName` için ek yetki yoktur. `POST /session/start` zaten OWNER ve MANAGER'a açık; aynı kalır.
- Subscription gate (`SUBSCRIPTION_REQUIRED`) aynen geçerli — yeni alan bu davranışı değiştirmez.

---

## 5. Migration

```sql
ALTER TABLE sessions
  ADD COLUMN customer_name VARCHAR(80) NULL;
```

- Geriye dönük: mevcut tüm satırlar `NULL` ile başlar. Eski session'lar için kimlik yoktur, beklenen budur.
- **Geri alınabilir** (drop column güvenli, çünkü v1'de aktif okuyan rapor sorgusu yoktur).

---

## 6. Logging / Audit

- Backend access log'larında `customerName` PII sayılır mı? — **Hayır**, isim girilmesi opsiyonel ve müşteri rızasına bağlı. Yine de access log'a body **dump edilmez**; sadece status + path. (Mevcut davranış zaten böyle.)
- Cancel/finish webhook veya audit kuyruğu varsa, `customerName` field'i payload'a eklenir; PII filtresi yoktur.

---

## 7. Test kontrolü (backend QA)

- [ ] `start` body'de `customerName` yoksa → `customer_name = NULL`, response'ta `null`.
- [ ] `start` body'de `customerName = "  Asan  "` → DB'de `"Asan"`, response'ta `"Asan"`.
- [ ] `start` body'de `customerName = ""` veya `"   "` → DB'ye `NULL`, **400/422 dönmez**.
- [ ] `start` body'de 81+ karakter → `422 INVALID_CUSTOMER_NAME`.
- [ ] `pause` / `resume` / `finish` / `cancel` body'sinde `customerName` gönderilirse → DB değişmez, response'taki değer start'taki değerdir.
- [ ] `venue/selected` ve `home` embed'lerinde `customerName` her session için döner.
- [ ] Reports session listeleri `customerName` döner; filtreleme parametresi henüz yok.

---

## 8. Açık kalanlar (v1'de yapılmaz)

- [ ] `customerName` üzerinde unique constraint **yok** — homonyms (aynı isimli iki müşteri) kabul edilir.
- [ ] "En sık gelen müşteri" raporu — v2'ye bırakıldı; v1'de sadece veri toplanır.
- [ ] Telefon / kart numarası gibi ek müşteri alanları — scope dışı; istenirse ayrı bir `customers` tablosu açılır.
