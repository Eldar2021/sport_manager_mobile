# Product — Mobile Implementation Plan

> Sport Manager Mobile için product (ürün katalogu + session'a satış) özelliğinin Flutter tarafında nasıl yapılacağı.
>
> **Kaynak dokümanlar:**
>
> - Backend kontratı: [product-api.md](product-api.md)
> - Mimari + paket konvansiyonu: [../docs/architecture.md](../docs/architecture.md)
> - UI tokens: [../docs/theme-system.md](../docs/theme-system.md)
> - Hata pipeline'i: [../docs/error-handling.md](../docs/error-handling.md)
>
> **Audience:** Mobile dev (Claude / insan). Onaylanırsa implementasyon bu plana göre yapılacak.
> **Status:** Draft v1 · 2026-05-21.

---

## 1. Mimarinin özeti

Product mevcut **package + feature** kalıbına oturur — `subscription` ile birebir aynı şablon:

- **`packages/product/`** — yeni veri katmanı (managers/subscription paketi şablonu). Models, sources, repository, `ProductExc`.
- **`features/product/`** — Owner profil altından açılan ürün yönetimi feature'ı. Sub-screen'ler: `list/`, `form/` (create+update aynı sayfa).
- **Session entegrasyonu** — mevcut `features/facility/` (session/table) akışına iki ek widget: `AddProductSheet` (bottom sheet) + `SessionProductsList` (aktif session ekranında). Repository çağrıları `FacilityRepository` üzerinden değil, yeni `ProductRepository` üzerinden.
- **Reports entegrasyonu** — mevcut `features/reports/` içine yeni sub-screen `products/` (kategori breakdown listesi) + `product_detail/` (tek ürünün satış geçmişi).
- **Page-level cubit'ler** (`ProductFormCubit`, `AddProductSheetCubit`, `ProductReportCubit`) — single-page kuralı: `BlocProvider` YOK, `late final` field + `bloc:` ile geçilir, `dispose`'da `close()`.
- **Owner-only sayfaların görünürlüğü** mevcut `AuthCubit.user.role` üzerinden kontrol edilir; Manager profil ekranında "Ürünler" satırı gözükmez.

---

## 2. `packages/product/`

`packages/subscription/` ile birebir aynı şablon. Workspace'e ekleme: root `pubspec.yaml`'da `workspace:` listesine `packages/product` satırı.

```
packages/product/
├── pubspec.yaml
└── lib/
    ├── product.dart                          ← public barrel
    ├── exceptions/
    │   └── product_exception.dart            ← ProductExc + ProductErrorCode
    ├── models/
    │   ├── product_model.dart                + .g.dart
    │   ├── product_unit.dart                 (enum)
    │   ├── product_category.dart             (enum)
    │   ├── product_create_param.dart         + .g.dart   ← create/update ortak body
    │   ├── product_photo_response.dart       + .g.dart   ← { url }
    │   ├── session_product_item_model.dart   + .g.dart   ← session içinde gözüken satır
    │   ├── product_report_item_model.dart    + .g.dart   ← reports breakdown satırı
    │   ├── product_report_summary_model.dart + .g.dart   ← /reports/.../products response
    │   ├── product_sale_model.dart           + .g.dart   ← satış geçmişi tek satır
    │   └── product_sales_summary_model.dart  + .g.dart   ← /reports/.../product/{id} response
    ├── repository/
    │   └── product_repository.dart           ← tek concrete final class
    └── source/
        └── remote/
            ├── product_remote_source.dart        ← abstract interface (no `I` prefix)
            ├── product_remote_source_impl.dart   ← real
            └── product_remote_source_mock.dart   ← Env.isMock için
```

`pubspec.yaml` `subscription` paketinden kopya, sadece `name: product` farklı.

### 2.1 Enum'lar

```dart
// product_unit.dart
@JsonEnum()
enum ProductUnit {
  @JsonValue('PIECE')   piece,
  @JsonValue('KG')      kg,
  @JsonValue('LITRE')   litre,
  @JsonValue('PORTION') portion,
  @JsonValue('HOUR')    hour,
}

// product_category.dart
@JsonEnum()
enum ProductCategory {
  @JsonValue('DRINK')     drink,
  @JsonValue('FOOD')      food,
  @JsonValue('EQUIPMENT') equipment,
  @JsonValue('OTHER')     other,
}
```

Her iki enum için bir extension dosyası — l10n key + icon mapping merkezi:

```dart
// product_category.dart (aynı dosya)
extension ProductCategoryX on ProductCategory {
  IconData get icon => switch (this) {
    ProductCategory.drink     => Icons.local_drink_outlined,
    ProductCategory.food      => Icons.restaurant_outlined,
    ProductCategory.equipment => Icons.sports_tennis_outlined,
    ProductCategory.other     => Icons.shopping_bag_outlined,
  };
}
```

(`l10n` çağrısı paket içinde olmaz — `context.l10n` view tarafında uygulanır. Sadece icon merkezde.)

### 2.2 Modeller (API doc'a birebir uyar)

```dart
@JsonSerializable() @immutable
final class ProductModel extends Equatable {
  const ProductModel({
    required this.id,
    required this.ownerId,
    required this.name,
    required this.price,
    required this.unit,
    required this.category,
    required this.createdAt,
    required this.updatedAt,
    this.description,
    this.photoUrl,
  });

  factory ProductModel.fromJson(Map<String, dynamic> json) => _$ProductModelFromJson(json);

  final String id;
  final String ownerId;
  final String name;
  final int price;
  final ProductUnit unit;
  final ProductCategory category;
  final String? description;
  final String? photoUrl;
  final DateTime createdAt;
  final DateTime updatedAt;

  Map<String, dynamic> toJson() => _$ProductModelToJson(this);

  @override
  List<Object?> get props => [id, name, price, unit, category, description, photoUrl, updatedAt];
}
```

`ProductCreateParam` — create ve update aynı şekli kullanır:

```dart
@JsonSerializable() @immutable
final class ProductCreateParam extends Equatable {
  const ProductCreateParam({
    required this.name,
    required this.price,
    required this.unit,
    required this.category,
    this.description,
    this.photoUrl,
  });

  Map<String, dynamic> toJson() => _$ProductCreateParamToJson(this);
  // alanlar + props
}
```

`SessionProductItemModel` — session response'una embed olur, `nameSnapshot` / `priceSnapshot` / `unitSnapshot` / `categorySnapshot` alanlarını taşır. Reports modelleri API'deki şekle birebir uyar.

### 2.3 Exception (paket başına bir tane — error-handling.md kuralı)

```dart
enum ProductErrorCode {
  nameRequired,
  nameTooLong,
  nameTaken,
  priceInvalid,
  unitInvalid,
  categoryInvalid,
  notFound,
  forbidden,
  photoRequired,
  photoTooLarge,
  photoTypeInvalid,
  sessionNotActive,
  sessionItemNotFound,
  unknown;

  factory ProductErrorCode.fromString(String? code) => switch (code) {
    'PRODUCT_NAME_REQUIRED'    => .nameRequired,
    'PRODUCT_NAME_TOO_LONG'    => .nameTooLong,
    'PRODUCT_NAME_TAKEN'       => .nameTaken,
    'PRODUCT_PRICE_INVALID'    => .priceInvalid,
    'PRODUCT_UNIT_INVALID'     => .unitInvalid,
    'PRODUCT_CATEGORY_INVALID' => .categoryInvalid,
    'PRODUCT_NOT_FOUND'        => .notFound,
    'PRODUCT_FORBIDDEN'        => .forbidden,
    'PHOTO_FILE_REQUIRED'      => .photoRequired,
    'PHOTO_TOO_LARGE'          => .photoTooLarge,
    'PHOTO_TYPE_INVALID'       => .photoTypeInvalid,
    'SESSION_NOT_ACTIVE'       => .sessionNotActive,
    'SESSION_ITEM_NOT_FOUND'   => .sessionItemNotFound,
    _                          => .unknown,
  };
}

final class ProductExc extends AppException<ProductErrorCode> { ... }
```

Tüm remote source method'ları `.mapTo(ProductExc.fromApiClientExc)` ile bitirir — try/catch yok. Şablon: [error-handling.md](../docs/error-handling.md).

### 2.4 Remote source — tipik method

```dart
@override
Future<List<ProductModel>> getAll({ProductCategory? category, String? search}) {
  return _client.getList<ProductModel>(
    '/api/v1/product',
    queryParameters: {
      if (category != null) 'category': category.toJson(),
      if (search != null && search.isNotEmpty) 'search': search,
    },
    fromJson: ProductModel.fromJson,
  ).mapTo(ProductExc.fromApiClientExc);
}

@override
Future<ProductPhotoResponse> uploadPhoto(File file) {
  return _client.postMultipart<ProductPhotoResponse>(
    '/api/v1/product/photo',
    files: {'file': file},
    fromJson: ProductPhotoResponse.fromJson,
  ).mapTo(ProductExc.fromApiClientExc);
}
```

> Not: `api_client` mevcut `postMultipart` helper'a sahip değilse paketin minor uzantısı olarak eklenir (Dio `FormData` wrapper). Bu, scope dışında ufak bir alt-task.

### 2.5 Mock

`AuthRemoteSourceMock` örneği gibi: in-memory `List<ProductModel>` üzerinde işlem yapar, yapay 300ms gecikme, hata path'leri için `throw const ProductExc(ProductErrorCode.nameTaken)`. Test kataloğu: 3 ürün (su, çay, top kiralama) seed olarak yüklü gelir.

### 2.6 DI modülü (mobile tarafı)

`app/lib/core/di/product_module.dart`:

```dart
final class ProductModule extends BaseDiModule {
  @override
  Future<void> register(GetIt sl) async {
    sl.registerLazySingleton<ProductRemoteSource>(
      () => Env.isMock
          ? ProductRemoteSourceMock()
          : ProductRemoteSourceImpl(sl(instanceName: ApiClient.bearerInstance)),
    );
    sl.registerLazySingleton(() => ProductRepository(remote: sl()));
  }
}
```

`app/lib/core/di/di.dart` içinde modül listesine eklenir.

---

## 3. `features/product/` (Owner CRUD)

```
app/lib/features/product/
├── product.dart                              ← barrel
├── list/
│   ├── cubit/
│   │   ├── products_list_cubit.dart
│   │   └── products_list_state.dart
│   ├── view/
│   │   └── products_list_view.dart
│   ├── widgets/
│   │   ├── product_tile.dart                 ← liste satırı (foto + isim + fiyat + edit/delete)
│   │   ├── products_empty_view.dart          ← "henüz ürün yok"
│   │   └── delete_product_sheet.dart         ← confirm bottom sheet
│   └── list.dart
└── form/
    ├── cubit/
    │   ├── product_form_cubit.dart
    │   └── product_form_state.dart
    ├── view/
    │   └── product_form_view.dart            ← create + update — mode param ile
    ├── widgets/
    │   ├── product_photo_picker.dart
    │   ├── product_unit_selector.dart
    │   └── product_category_selector.dart
    └── form.dart
```

### 3.1 State şekilleri

```dart
// products_list_state.dart
final class ProductsListState extends Equatable {
  const ProductsListState({
    this.items = const RequestInitial(),
    this.deleting = const RequestInitial<void>(),
  });

  final RequestStatus<List<ProductModel>> items;
  final RequestStatus<void> deleting;     // delete sırasında loading + result

  ProductsListState copyWith({...}) => ...;
  @override List<Object?> get props => [items, deleting];
}
```

```dart
// product_form_state.dart — create + update ortak
final class ProductFormState extends Equatable {
  const ProductFormState({
    required this.mode,                   // create | update
    this.name = '',
    this.price = '',
    this.unit = ProductUnit.piece,
    this.category = ProductCategory.drink,
    this.description = '',
    this.photoUrl,
    this.uploading = const RequestInitial<String>(),  // foto upload state
    this.submit = const RequestInitial<ProductModel>(),
  });
  // copyWith + props
  bool get isFormValid => name.trim().isNotEmpty && (int.tryParse(price) ?? 0) > 0;
}
```

### 3.2 Sayfa akışları

**ProductsListView** — owner profil ekranında "Ürünler" satırına `context.push(AppRoutes.products)` ile gelinir. `initState` cubit'i kurar, `load()` çağırır. State'e göre:

- `RequestLoading` → `MyLoadingView` (mevcut komponent).
- `RequestSuccess(items: [])` → `ProductsEmptyView` ("İlk ürününüzü ekleyin" + CTA).
- `RequestSuccess(items)` → `ListView.builder` + `ProductTile`. Sağ üstte `+` icon → `context.push(AppRoutes.productCreate)`.
- `RequestFailure(e)` → `ErrorBodyWidget`.

Pull-to-refresh + scroll'lu liste. `Scaffold` / `RefreshIndicator` / `ListView` builder'ın dışında kalır — sadece `ListTile` listesi narrow `BlocBuilder` içinde rebuild olur (code-rules § BlocBuilder rebuild scope).

**ProductTile** — `Dismissible`'a girmiyoruz; sağ tarafta iki ikon: `IconButton(Icons.edit_outlined)` → `context.push(AppRoutes.productUpdate, extra: product)`, `IconButton(Icons.delete_outline)` → `DeleteProductSheet.show(context, product)`.

**DeleteProductSheet** — modal bottom sheet. "Bu ürünü silmek istediğinize emin misiniz? Eski raporlar etkilenmez." + iki buton (`AppButton.outline` "Vazgeç" / `AppButton.primary` "Sil"). Onay → `cubit.delete(id)` → list cubit `items` listesinden çıkarır (optimistic) → backend 204 sonrası bir şey yapmaz, 4xx ise re-insert + `context.handleError(e)`.

**ProductFormView** — create ve update aynı view. `extra: product` ile gelen update modunda `initState`'te form state'i ürünle doldurur. `AppButtonScope` ile sarılır; submit `AppButton(collapseOnScroll: true)`. Alanlar:

- İsim → `AppTextField`, max 80 char.
- Fiyat → `AppTextField`, `TextInputType.number`, validator: `> 0`.
- Unit → segment / dropdown (`ProductUnitSelector` — chip listesi).
- Kategori → chip listesi (`ProductCategorySelector`).
- Açıklama → `AppTextField`, max 200 char, opsiyonel.
- Foto → `ProductPhotoPicker` (image_picker + `repository.uploadPhoto()` → state.photoUrl). Yoksa kategori icon'u placeholder.

Submit butonu cubit'e `submit()` çağırır; mode'a göre create veya update. Başarılı → `Navigator.pop(result)`; list view `then` ile cubit'i refresh eder.

### 3.3 Routes

`app/lib/app/router/app_routes.dart`:

```dart
static const products       = '/products';
static const productCreate  = '/products/create';
static const productUpdate  = '/products/update';        // extra: ProductModel
```

Manager bu route'lara erişemez — router seviyesinde redirect gerekmez (UI'da hiç linklenmez), ama defensive olarak `AuthCubit.user.role != owner` ise `home` yönlendirmesi yazılır.

### 3.4 ARB key prefix'leri

`app/lib/l10n/arb/`:

```
productsTitle, productsEmpty, productsEmptyCta,
productCreateTitle, productUpdateTitle,
productFieldName, productFieldPrice, productFieldUnit, productFieldCategory,
productFieldDescription, productFieldPhoto,
productUnitPiece, productUnitKg, productUnitLitre, productUnitPortion, productUnitHour,
productCategoryDrink, productCategoryFood, productCategoryEquipment, productCategoryOther,
productDeleteConfirmTitle, productDeleteConfirmMessage,
productCreated, productUpdated, productDeleted,
productPhotoPickFromCamera, productPhotoPickFromGallery, productPhotoRemove,
```

Üç dil için ARB'lara eklenir, `flutter gen-l10n` çalıştırılır.

---

## 4. Session entegrasyonu (`features/facility/` uzantısı)

Mevcut session detail view'una iki yeni parça eklenir. Session paketi modeli (`SessionLite` / `SessionFull`) backend ile birlikte `products: SessionProductItemModel[]` + `productsAmount: int` alanlarını döndürmeye başlar — `packages/facility/lib/models/session_lite_model.dart` ve detail modeli güncellenir.

### 4.1 SessionProductsList (yeni widget)

`features/facility/session/widgets/session_products_list.dart`:

- Session detail view'unda timer'ın altında, "Eklenen ürünler" başlığı + liste.
- Her satır: foto/icon + isim + fiyat + sağ tarafta `IconButton(Icons.close)` (sadece session ACTIVE/PAUSED iken).
- Boş liste için "Henüz ürün eklenmedi" placeholder.
- Liste altında "Ürün ekle" `AppButton.secondary` → `AddProductSheet.show(context, session)`.

Bu widget kendi `BlocBuilder<SessionCubit, SessionState>` ile `state.session.products` üzerinden çalışır; `buildWhen: (a,b) => a.session?.products != b.session?.products`.

Satırdaki `X` butonu → `confirmRemove(context)` (küçük dialog) → `cubit.removeProductItem(itemId)` → optimistic remove + backend çağrısı. Hata olursa state restore + `context.handleError`.

### 4.2 AddProductSheet (yeni bottom sheet)

`features/facility/session/widgets/add_product_sheet.dart` — modal bottom sheet, kendi içinde `AddProductSheetCubit` (single-page kuralı, `late final` field). Tek sorumluluk: ürün listesi çek + tıklananı `addProductToSession(sessionId, productId)` ile ekle.

Akış:

1. Sheet açılır, cubit `loadProducts()` çağırır → `ProductRepository.getAll()`.
2. Liste gözükür (foto + isim + fiyat + kategori chip'i). Üstte kategori filtre chip bar.
3. Kullanıcı bir ürüne tıklar → küçük confirm dialog ("Su 0.5L · 50 KGS — eklensin mi?") → onay → cubit `add()` çağırır.
4. Backend `SessionProductItemModel` döner → cubit `Navigator.pop(result)` ile geri verir.
5. Session view bu satırı kendi state'ine ekler (`session.copyWith(products: [...products, result], productsAmount: productsAmount + result.priceSnapshot)`).

Sheet boş katalog için: "Henüz ürün eklenmemiş. Owner'ın ürün eklemesi gerekiyor" — Manager için CTA yok, Owner için "Ürün ekle" CTA → sheet kapanır, `context.push(AppRoutes.productCreate)`.

### 4.3 Finish ekranı

`features/facility/session/finish/view/session_finish_view.dart` (veya mevcut session detail'in finish bottom sheet'i) iki ek satır gösterir:

```
Süre ücreti        : 250 KGS
Ürünler (3 adet)   : 350 KGS
─────────────────────────────
Toplam             : 600 KGS
```

Backend `finish` response'undaki `durationAmount` / `productsAmount` / `totalAmount` üçlüsünü ayrı ayrı render eder. "Ürünler" satırına tıklayınca `SessionProductsList` (read-only mode) açılır.

---

## 5. Reports entegrasyonu (`features/reports/` uzantısı)

Mevcut `features/reports/<venue>` ekranına iki yeni sub-screen eklenir.

```
app/lib/features/reports/
├── (mevcut)
├── products/
│   ├── cubit/
│   │   ├── products_report_cubit.dart
│   │   └── products_report_state.dart
│   ├── view/
│   │   └── products_report_view.dart
│   ├── widgets/
│   │   └── product_report_tile.dart
│   └── products.dart
└── product_detail/
    ├── cubit/
    │   ├── product_report_detail_cubit.dart
    │   └── product_report_detail_state.dart
    ├── view/
    │   └── product_report_detail_view.dart
    ├── widgets/
    │   └── product_sale_tile.dart            ← tek satış satırı (tarih + fiyat)
    └── product_detail.dart
```

### 5.1 Yerleştirme

Venue report ekranında managers breakdown'ından sonra "Ürünler" bölümü:

```
Yöneticiler
─────────
[managers list]

Ürünler
─────────
[products list — totalAmount DESC]    [Tümünü gör →]
```

İlk 3 ürün inline; "Tümünü gör" `ProductsReportView`'a götürür (aynı venueId + period). Tıklanan ürün satırı `ProductReportDetailView`'a götürür (satış geçmişi).

### 5.2 ProductReportDetailView

- Üstte özet: güncel isim + güncel fiyat + bu periyotta toplam adet + toplam tutar.
- Altında satış listesi: `ListView.builder` + `ProductSaleTile` (tarih `dd MMM yyyy HH:mm` + fiyat snapshot + farklıysa şu uyarı: "O zamanki fiyat: 50 KGS · şu anki: 55 KGS"). Sıralama backend tarafından yapılır.
- Silinmiş ürünse üst banner: `AppBanner(context.l10n.productDeletedBadge, variant: info)`.

### 5.3 Period filtre

Mevcut reports `PeriodChips` widget'ını yeniden kullanır. Filtre değişimi her iki cubit'i ayrı ayrı `load(period)` ile yeniler — state mevcut reports pattern'ine uyar.

### 5.4 Route'lar

```dart
static const reportsVenueProducts       = '/reports/venue/:venueId/products';
static const reportsVenueProductDetail  = '/reports/venue/:venueId/product/:productId';
```

---

## 6. Owner profil sayfasına "Ürünler" satırı

`features/profile/widgets/profile_menu.dart` (veya muadili):

```dart
if (user.role == UserRole.owner)
  ProfileItemTile(
    icon: Icons.inventory_2_outlined,
    title: context.l10n.profileProductsItem,
    onTap: () => context.push(AppRoutes.products),
  ),
```

Manager için bu satır hiç render edilmez. Owner profil zaten role'e göre dallanıyor (subscription tile vs.) — pattern'i izle.

---

## 7. Akış diyagramı (E2E)

```
Owner profili
    │
    ▼
ProductsListView (boş)
    │ tıkla "+"
    ▼
ProductFormView (create) ──submit──► POST /api/v1/product
    │                                 │
    │◄────── pop(result) ◄────────────┘
    ▼
ProductsListView (1 ürün)


Manager / Owner masaya tıklar
    │
    ▼
Session detail (ACTIVE)
    │ tıkla "Ürün ekle"
    ▼
AddProductSheet ──tıkla ürün──► confirm ──POST /api/v1/session/{id}/products──┐
    │                                                                          │
    │◄────────────────────── pop(SessionProductItem) ◄─────────────────────────┘
    ▼
SessionProductsList satır eklenir, productsAmount güncellenir
    │
    │ tıkla "X" (yanlışlık)
    ▼
DELETE /api/v1/session/{id}/products/{itemId} → satır kaldırılır


Session bitir
    │
    ▼
Finish summary: süre + ürünler + toplam
    │ confirm
    ▼
POST /api/v1/session/{id}/finish → Report'a snapshot olarak yazılır


Owner reports açar
    │
    ▼
ReportsVenueView → "Ürünler" bölümü → "Tümünü gör"
    │
    ▼
ProductsReportView → tıkla bir ürün
    │
    ▼
ProductReportDetailView → satış listesi + fiyat tarihçesi
```

---

## 8. Yapılacaklar listesi (implementasyon sırası)

1. **Backend hazır olmadan başlatılabilir kısım:** `packages/product/` paketini boş `ProductRemoteSourceMock` ile kur. Mock ile feature uçtan uca çalışır.
2. `features/product/list/` + `features/product/form/` view + cubit + l10n + route.
3. Owner profil satırını ekle.
4. `packages/facility/` modellerini `products[]` + `productsAmount` ile genişlet (backend henüz dönmüyorsa default boş array).
5. `features/facility/session/widgets/session_products_list.dart` + `add_product_sheet.dart` ekle. AddProductSheet `AddProductSheetCubit` ile çalışır.
6. Session finish view'unu üç-satırlı amount breakdown'a güncelle.
7. `features/reports/products/` + `features/reports/product_detail/` ekle.
8. Mock'tan gerçek API'ye geçiş — `Env.isMock = false` testleri.
9. CI'ye `melos run analyze-check` + `flutter test packages/product` (mock üzerinden cubit testleri).

---

## 9. Açık sorular (mobile ekibine)

- **Foto picker:** `image_picker` mı, native `file_picker` mı kullanılacak? Mevcut projede image_picker yok — paket eklenmesi onay gerektirir.
- **AddProductSheet sıralama:** Default sıralama "kategori sonra isim" mi olmalı, yoksa "en çok satan üstte" (backend `popularity` query'si gerekir)? İlk versiyon: alfabetik.
- **Optimistic delete:** Liste'den silme optimistic mi olsun, yoksa loading spinner mı? İlk versiyon: optimistic + rollback (UX hızlı, hata path test edilmeli).
- **Manager session'a ürün ekleme:** Backend izin veriyor ama owner audit log'unu UI'da göstermek istiyor muyuz? (İleride v2.)
- **Reports breakdown'da silinmiş ürünler:** Gri/üstü-çizgili göstermek ARB key + tasarım kararı gerektirir; mevcut report pattern'ine sığacak şekilde küçük badge ile yeterli.
