# Product & Session Items API

Owner'ın sattığı ek ürünleri (su, çay, atıştırmalık, top vb.) yönetir ve aktif session'a satış olarak ekler. Mevcut session/reports akışına eklenti olarak çalışır — session süresi ücreti + ürün ücretleri = toplam.

**Base URL:** `<BASE_URL>`
**Content-Type:** `application/json; charset=utf-8` (foto yüklemesi hariç — `multipart/form-data`)
**Authorization:** Tüm endpoint'ler `Bearer <accessToken>` gerektirir.

> **Status:** Draft v1 · 2026-05-21. Henüz implement edilmedi.
> Mobile karşılığı: [product-mobile.md](product-mobile.md).

---

## Genel Mantık ve Kurallar

### Kavramsal model

```
Owner ─owns─► Product           (Owner'a bağlı, tüm venue'lerde ortak liste)
                │
                │ snapshot @ sale-time
                ▼
            SessionProductItem  (session içine kopyalanır; product silinse de korunur)
                ▲
                │ many
            Session
```

- **Product** Owner'a bağlıdır, **venue'den bağımsız** — Owner kendi kataloğunu bir kere kurar, tüm venue'lerinde aynı liste gözükür.
- **SessionProductItem** session'a eklendiği an `name`, `price`, `unit`, `category` alanlarını ürünün o anki değerinden **snapshot** olarak kopyalar. Fiyat sonradan değişse veya ürün silinse bile bu kayıt aynı kalır — eski raporlar bozulmaz.

### Kritik kurallar

1. **Soft delete.** `DELETE /api/v1/product/{id}` ürünü silmez, sadece `deletedAt` damgalar. Liste endpoint'leri `deletedAt = NULL` olanları döner; eski session/report kayıtları snapshot üzerinden çalışmaya devam eder.

2. **Backend price snapshot.** `POST /api/v1/session/{sessionId}/products` çağrısı sadece `productId` alır — fiyat / isim / unit body'de gönderilmez. Backend ürünü okur, snapshot'ı kendi yazar. **Manager'ın fiyat manipüle etmesini engelleyen savunma katmanı** (session timestamp kuralı ile aynı mantık).

3. **Quantity yok, satır var.** Aynı ürün session'a 3 kez eklendiyse `session_products` tablosunda 3 ayrı satır olur. Bu kararın gerekçesi: hızlı tıklama UX'i + reports'ta sayım kolaylığı. Tek bir satıra "+1" ekleme yok.

4. **Sadece aktif session'a ekleme/çıkarma.** `status = ACTIVE` veya `status = PAUSED` olan session'lara işlem yapılabilir. `COMPLETED` / `CANCELLED` session'a ürün eklenemez, çıkarılamaz → `409 SESSION_NOT_ACTIVE`.

5. **Product fotoğrafı opsiyonel.** Foto yüklenmediyse `photoUrl = null` — mobile placeholder (kategori icon'u) gösterir. Foto upload'ı ayrı endpoint'tedir (`POST /api/v1/product/photo`) → URL döner → ürün create/update body'sinde kullanılır.

6. **Total amount session bitişinde tek sefer hesaplanır.** Finish response'unda `durationAmount`, `productsAmount`, `totalAmount` üç alan birden döner; mobile bunları ayrı ayrı gösterir.

7. **Reports per-venue.** Product breakdown'u her zaman bir venue context'inde döner. "All venues" toplamı için ayrı endpoint yok (frontend gerekirse client-side toplar).

---

## Authorization Rolleri

| Endpoint                                               | OWNER | MANAGER |
| ------------------------------------------------------ | :---: | :-----: |
| POST `/api/v1/product`                                 |  ✅   |   ❌    |
| GET `/api/v1/product`                                  |  ✅   |   ✅    |
| GET `/api/v1/product/{id}`                             |  ✅   |   ✅    |
| PUT `/api/v1/product/{id}`                             |  ✅   |   ❌    |
| DELETE `/api/v1/product/{id}`                          |  ✅   |   ❌    |
| POST `/api/v1/product/photo`                           |  ✅   |   ❌    |
| POST `/api/v1/session/{sessionId}/products`            |  ✅   |   ✅    |
| DELETE `/api/v1/session/{sessionId}/products/{itemId}` |  ✅   |   ✅    |
| GET `/api/v1/reports/venue/{venueId}/products`         |  ✅   |   ✅    |
| GET `/api/v1/reports/venue/{venueId}/product/{id}`     |  ✅   |   ✅    |

Manager ürün CRUD yapamaz; sadece okur ve session'a ekler/çıkarır.

---

## Enum'lar

```ts
type ProductUnit =
  | "PIECE" // tane (varsayılan)
  | "KG"
  | "LITRE"
  | "PORTION" // porsiyon / tabak
  | "HOUR"; // saatlik kiralama (top, raket vb.)

type ProductCategory = "DRINK" | "FOOD" | "EQUIPMENT" | "OTHER";
```

Yeni unit/category eklenmesi gerekirse backend + mobile enum + ARB key + report ikonu birlikte güncellenir.

---

## Response Modelleri

### Product

```ts
{
  id: string (uuid),
  ownerId: string (uuid),
  name: string,                          // 1..80 char
  price: integer,                        // KGS, en küçük birim (kuruş yok)
  unit: ProductUnit,
  category: ProductCategory,
  description: string | null,            // 0..200 char
  photoUrl: string | null,
  createdAt: string (ISO 8601),
  updatedAt: string (ISO 8601),
}
```

`deletedAt` alanı response'larda dönmez — silinmiş ürünler liste/detail endpoint'lerinden dışarı çıkmaz.

### SessionProductItem

Aktif session içine eklenen tek bir satış satırı. Session response'larında ve reports detail'inde gözükür.

```ts
{
  id: string (uuid),                     // session_products tablosundaki satır id'si
  sessionId: string (uuid),
  productId: string (uuid),              // ürün silinse de id korunur (foreign key opsiyonel)
  nameSnapshot: string,                  // eklendiği andaki isim
  priceSnapshot: integer,                // eklendiği andaki fiyat
  unitSnapshot: ProductUnit,
  categorySnapshot: ProductCategory,
  addedBy: string (uuid),                // session'a ekleyen owner/manager id
  addedAt: string (ISO 8601),
}
```

### Session response uzantısı (mevcut SessionLite + SessionFull)

Mevcut `SessionLite` ve `SessionFull` modellerine iki yeni alan eklenir:

```ts
{
  ...,                                   // mevcut tüm alanlar değişmez
  products: SessionProductItem[],        // boş array dönebilir
  productsAmount: integer,               // products[].priceSnapshot toplamı
}
```

`finish` response'una ek olarak `totalAmount` döner: `durationAmount + productsAmount`. Mevcut Session API doc'unda `finalAmount` alanı varsa onun yerine `durationAmount + productsAmount + totalAmount` üçlüsü dönmelidir — mobile bu üçünü ayrı ayrı gösterir.

---

## Endpoint'ler

### 1. POST `/api/v1/product`

Yeni ürün oluşturur. Owner-only.

**Request body:**

```json
{
  "name": "Su 0.5L",
  "price": 50,
  "unit": "PIECE",
  "category": "DRINK",
  "description": "Soğuk içecek dolabı",
  "photoUrl": "https://cdn.../products/abc.jpg"
}
```

`description` ve `photoUrl` opsiyonel.

**Response 201:** `Product`

**Hata kodları:**

| Code                       | HTTP | Anlam                                                   |
| -------------------------- | :--: | ------------------------------------------------------- |
| `PRODUCT_NAME_REQUIRED`    | 400  | İsim boş veya whitespace                                |
| `PRODUCT_NAME_TOO_LONG`    | 400  | İsim 80 karakteri aşıyor                                |
| `PRODUCT_PRICE_INVALID`    | 400  | Fiyat ≤ 0 veya tam sayı değil                           |
| `PRODUCT_UNIT_INVALID`     | 400  | Bilinmeyen unit                                         |
| `PRODUCT_CATEGORY_INVALID` | 400  | Bilinmeyen category                                     |
| `PRODUCT_NAME_TAKEN`       | 409  | Aynı owner'da silinmemiş aynı isimde bir ürün zaten var |

---

### 2. GET `/api/v1/product`

Owner'ın silinmemiş ürünlerini döner. Manager kendi venue sahibinin listesini görür.

**Query parametreleri:**

| Param      | Tip                | Açıklama                                 |
| ---------- | ------------------ | ---------------------------------------- |
| `category` | `ProductCategory?` | Belirli kategoriyi filtreler. Opsiyonel. |
| `search`   | `string?`          | İsim üzerinde case-insensitive contains. |

**Response 200:** `Product[]` — son eklenen üstte (`createdAt DESC`).

Boş liste boş array döner. **Bu liste hiçbir zaman silinmiş ürünleri içermez** — eski session referansları için backend yine de tutar.

---

### 3. GET `/api/v1/product/{id}`

Tek ürün detayı. Owner kendi ürünü, manager venue sahibinin ürünü.

**Response 200:** `Product`

**Hata kodları:**

| Code                | HTTP | Anlam                                 |
| ------------------- | :--: | ------------------------------------- |
| `PRODUCT_NOT_FOUND` | 404  | Yok veya silinmiş                     |
| `PRODUCT_FORBIDDEN` | 403  | Başka bir owner'ın ürünü (impossible) |

---

### 4. PUT `/api/v1/product/{id}`

Ürün günceller. Owner-only.

**Request body:** Create body ile aynı şekil. Tüm alanlar zorunlu (PATCH değil, PUT — mobile form tüm alanları gönderir).

**Önemli:** Fiyat değişikliği **mevcut session'lardaki ürün satırlarını etkilemez** (snapshot kuralı). Sadece bundan sonra eklenecek satırlar yeni fiyatı görür.

**Response 200:** `Product`

**Hata kodları:** Create ile aynı + `PRODUCT_NOT_FOUND` (404).

---

### 5. DELETE `/api/v1/product/{id}`

Soft delete — `deletedAt = NOW()` yazar, satıra dokunmaz. Owner-only.

**Response 204:** Body yok.

**Hata kodları:**

| Code                | HTTP | Anlam                   |
| ------------------- | :--: | ----------------------- |
| `PRODUCT_NOT_FOUND` | 404  | Yok veya zaten silinmiş |

> Geri dönüş yok. Aynı isimde yeni ürün yaratılabilir — soft-deleted satır unique check'i bloklamaz çünkü unique constraint `(owner_id, name) WHERE deleted_at IS NULL` üzerinedir.

---

### 6. POST `/api/v1/product/photo`

Fotoğraf yükler. Multipart form-data, owner-only.

**Request:** `multipart/form-data` ile `file` alanında JPEG/PNG/WebP. Max 5 MB.

**Response 201:**

```json
{ "url": "https://cdn.../products/abc.jpg" }
```

Mobile dönen URL'i form state'inde tutar; create/update body'sinde `photoUrl` olarak gönderir. Backend yetimlik (orphan) temizliği bir cron işidir — mobile'ın endişesi değildir.

**Hata kodları:**

| Code                  | HTTP | Anlam              |
| --------------------- | :--: | ------------------ |
| `PHOTO_FILE_REQUIRED` | 400  | `file` alanı boş   |
| `PHOTO_TOO_LARGE`     | 413  | 5 MB üzeri         |
| `PHOTO_TYPE_INVALID`  | 400  | JPEG/PNG/WebP dışı |

---

### 7. POST `/api/v1/session/{sessionId}/products`

Aktif session'a 1 ürün ekler. Owner veya Manager.

**Request body:**

```json
{ "productId": "uuid-of-product" }
```

**Response 201:** `SessionProductItem` (yeni eklenen satır).

Backend:

1. Session var mı + status ACTIVE/PAUSED mi?
2. Manager ise session'ın venue'sunda yetkili mi?
3. Product var mı + silinmemiş mi + aynı owner'a mı ait?
4. Snapshot kopyala, `addedBy = currentUserId`, `addedAt = NOW()` ile yaz.
5. Yeni satırı dön.

**Hata kodları:**

| Code                 | HTTP | Anlam                               |
| -------------------- | :--: | ----------------------------------- |
| `SESSION_NOT_FOUND`  | 404  | Session id yok                      |
| `SESSION_NOT_ACTIVE` | 409  | Session COMPLETED veya CANCELLED    |
| `PRODUCT_NOT_FOUND`  | 404  | Product yok veya silinmiş           |
| `PRODUCT_FORBIDDEN`  | 403  | Product başka owner'ın (impossible) |

---

### 8. DELETE `/api/v1/session/{sessionId}/products/{itemId}`

Yanlışlıkla eklenmiş bir satırı session açıkken siler. Owner veya Manager.

**Response 204:** Body yok.

Backend:

1. Session ACTIVE/PAUSED mi? COMPLETED ise `409 SESSION_NOT_ACTIVE`.
2. `itemId` bu session'a mı ait? Değilse `404 SESSION_ITEM_NOT_FOUND`.
3. Satırı sil (hard delete bu tabloda — session açık olduğu için reports'a girmemiştir).

**Hata kodları:**

| Code                     | HTTP | Anlam                   |
| ------------------------ | :--: | ----------------------- |
| `SESSION_NOT_FOUND`      | 404  | Session yok             |
| `SESSION_NOT_ACTIVE`     | 409  | COMPLETED / CANCELLED   |
| `SESSION_ITEM_NOT_FOUND` | 404  | Satır bu session'da yok |

> Manager'ın "ekledi → sildi" şeklinde manipülasyon yapmasını izlemek için backend audit log'u tutar (silinen satır + `removedBy` + `removedAt`). Bu log mobile'a dönmez ama disputelarda owner'a gösterilebilir.

---

### 9. GET `/api/v1/reports/venue/{venueId}/products`

Reports breakdown'ına ek — bir venue'de seçili periyotta hangi ürün ne kadar satıldı. Owner kendi venue'sü, Manager atandığı venue.

**Query:**

| Param    | Tip                                    | Açıklama                                                            |
| -------- | -------------------------------------- | ------------------------------------------------------------------- |
| `period` | `"day" \| "week" \| "month" \| "year"` | Mevcut reports konvansiyonuyla aynı. Default: `day`.                |
| `from`   | ISO date?                              | Custom range başlangıcı (opsiyonel — `period=custom` ile birlikte). |
| `to`     | ISO date?                              | Custom range bitişi.                                                |

**Response 200:**

```json
{
  "venueId": "uuid",
  "period": "month",
  "from": "2026-05-01T00:00:00Z",
  "to": "2026-05-31T23:59:59Z",
  "items": [
    {
      "productId": "uuid",
      "name": "Su 0.5L", // güncel isim; ürün silindiyse son snapshot
      "category": "DRINK",
      "totalCount": 47, // bu periyotta kaç satır eklenmiş
      "totalAmount": 2350, // satılan satırların priceSnapshot toplamı
      "deleted": false // ürün silinmişse true (UI gri/üstü çizgili)
    }
  ],
  "totalAmount": 12450 // tüm items.totalAmount toplamı
}
```

Sıralama: `totalAmount DESC` (en çok satan üstte).

---

### 10. GET `/api/v1/reports/venue/{venueId}/product/{productId}`

Tek bir ürünün venue'deki satış geçmişi — kullanıcı `products` listesindeki bir satıra tıklayınca açılır.

**Query:** `period`, `from`, `to` — aynı.

**Response 200:**

```json
{
  "venueId": "uuid",
  "productId": "uuid",
  "currentName": "Su 0.5L", // güncel kataloğdaki isim
  "currentPrice": 55, // güncel fiyat (referans)
  "deleted": false,
  "period": "month",
  "from": "...",
  "to": "...",
  "sales": [
    {
      "sessionId": "uuid",
      "itemId": "uuid",
      "priceSnapshot": 50,
      "nameSnapshot": "Su 0.5L",
      "soldAt": "2026-05-14T18:42:00Z",
      "sessionEndedAt": "2026-05-14T20:10:00Z"
    }
  ],
  "totalCount": 47,
  "totalAmount": 2350
}
```

Sıralama: `soldAt DESC`.

> Mobile bu listede fiyatın zaman içinde değiştiğini göstermek isteyebilir (price chart) — backend ham veri verir, görselleştirme mobile tarafı.

---

## Hata Kodları (özet)

| Code                       | HTTP | Nereden gelir                          |
| -------------------------- | :--: | -------------------------------------- |
| `PRODUCT_NAME_REQUIRED`    | 400  | create / update                        |
| `PRODUCT_NAME_TOO_LONG`    | 400  | create / update                        |
| `PRODUCT_NAME_TAKEN`       | 409  | create / update (aynı owner aynı isim) |
| `PRODUCT_PRICE_INVALID`    | 400  | create / update                        |
| `PRODUCT_UNIT_INVALID`     | 400  | create / update                        |
| `PRODUCT_CATEGORY_INVALID` | 400  | create / update                        |
| `PRODUCT_NOT_FOUND`        | 404  | get / update / delete / add-to-session |
| `PRODUCT_FORBIDDEN`        | 403  | başka owner'ın ürünü                   |
| `PHOTO_FILE_REQUIRED`      | 400  | photo upload                           |
| `PHOTO_TOO_LARGE`          | 413  | photo upload                           |
| `PHOTO_TYPE_INVALID`       | 400  | photo upload                           |
| `SESSION_NOT_ACTIVE`       | 409  | add/remove product (session COMPLETED) |
| `SESSION_ITEM_NOT_FOUND`   | 404  | remove product                         |

Tüm `PRODUCT_*` ve `SESSION_ITEM_*` kodları mobile tarafında tek bir `ProductExc` (yeni paket) altında toplanır. `SESSION_NOT_ACTIVE` mevcut `FacilityExc` enum'unda zaten vardır veya oraya eklenir (bu kod hem product hem timer akışı için geçerli).

---

## Migration Notları

1. `products` tablosu: `(id, owner_id, name, price, unit, category, description, photo_url, created_at, updated_at, deleted_at)`. Unique partial index: `(owner_id, name) WHERE deleted_at IS NULL`.
2. `session_products` tablosu: `(id, session_id, product_id, name_snapshot, price_snapshot, unit_snapshot, category_snapshot, added_by, added_at)`. `product_id` foreign key olabilir ama `ON DELETE NO ACTION` — soft delete olduğu için referans bozulmaz.
3. Mevcut `sessions` tablosuna kolon eklemiyoruz — `productsAmount` çalışma zamanında `SUM(price_snapshot)` ile hesaplanır. Eğer performans gerekirse cache kolonu eklenebilir.
4. `cancel` endpoint'i session'ı iptal ederken `session_products` satırlarını da silmelidir (raporlara girmemiş gibi).

---

## Açık sorular (backend ekibine)

- Foto storage: S3 / DO Spaces / yerel? URL'in cdn ardı mı yoksa imzalı mı?
- Audit log şu an reports'tan ayrı mı tutulacak? "Manager X şu satırı sildi" görünür mü olacak?
- Reports'ta silinmiş ürünleri gizlemeli miyiz, yoksa "deleted" badge ile mi göstermeliyiz? (Doc'ta gösteriyoruz — onaylanırsa kalır.)
