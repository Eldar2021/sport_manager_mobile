# Subscription — Mobile Implementation Plan

> Sport Manager Mobile için subscription özelliğinin Flutter tarafında nasıl yapılacağı.
>
> **Kaynak dokümanlar:**
>
> - Akış: [backend_doc/subscription-flow.md](../backend_doc/subscription-flow.md)
> - Backend kontratı: [backend_doc/subscription-api.md](../backend_doc/subscription-api.md)
>
> **Audience:** Mobile dev (Claude / insan). Onaylanırsa implementasyon bu plana göre yapılacak.
> **Status:** Draft v1 · 2026-04-30.

---

## 1. Mimarinin özeti

Subscription, mevcut **package + feature** kalıbına oturur:

- **`packages/subscription/`** — yeni veri katmanı (managers paketi şablonu).
- **`features/subscription/`** — yeni feature (managers feature şablonu): cubits, view, widgets.
- **Global `SubscriptionCubit`** — `AuthCubit` gibi app-root `BlocProvider` ile yayınlanır. Login sonrası `loadSummary()` çağrılır; soft-block ve profile/subscription tile bu cubit'in state'inden çizilir.
- **Page-level cubit'ler** (`SubscriptionDetailCubit`, `SubscriptionCheckoutCubit`, `SubscriptionPaymentCubit`) — single-page kuralı: `BlocProvider` YOK, `late final` field + `bloc:` ile geçilir, `dispose`'da `close()`.
- **Soft-block** — Home'da masa kartı ve diğer yazma aksiyonlarında `SubscriptionGate` enforces. Backend `403 SUBSCRIPTION_REQUIRED` ikinci savunma hattı; global error handler bunu dialog'a çevirir.
- **ContactSupportSheet** — bugün auth/forgot_password altında. Subscription da kullanacağı için **`ui/components/sheet/`'e taşınacak**, l10n key prefix'i `contactSupport*` olarak nötrleştirilecek.

---

## 2. `packages/subscription/`

`packages/managers/` ile birebir aynı şablon. Workspace'e ekleme: root `pubspec.yaml`'da `workspace:` listesine `packages/subscription` satırı.

```
packages/subscription/
├── pubspec.yaml
└── lib/
    ├── subscription.dart                ← public barrel
    ├── exceptions/
    │   └── subscription_exception.dart
    ├── models/
    │   ├── subscription_model.dart           + .g.dart
    │   ├── subscription_status.dart          (enum)
    │   ├── subscription_source.dart          (enum)
    │   ├── subscription_summary_model.dart   + .g.dart   ← profile içine embed olan hafif obje
    │   ├── subscription_pricing_model.dart   + .g.dart
    │   ├── subscription_detail_model.dart    + .g.dart   ← { subscription, payments }
    │   ├── payment_model.dart                + .g.dart
    │   ├── payment_status.dart               (enum)
    │   ├── payment_outcome.dart              (enum) — mock confirm body için
    │   └── checkout_param.dart                          ← `{ months: int }`
    ├── repository/
    │   └── subscription_repository.dart      ← tek concrete final class
    └── source/
        └── remote/
            ├── subscription_remote_source.dart       ← abstract interface (no `I` prefix)
            ├── subscription_remote_source_impl.dart  ← real
            └── subscription_remote_source_mock.dart  ← Env.isMock için
```

`pubspec.yaml` (managers paketinden kopya, sadece `name` farklı):

```yaml
name: subscription
description: Subscription data layer — models, source, repository for owner subscriptions
version: 0.1.0+1
resolution: workspace
publish_to: none
environment: { sdk: ^3.11.5 }
dependencies:
  flutter: { sdk: flutter }
  core:
  equatable:
  json_annotation:
  meta:
  api_client:
dev_dependencies:
  build_runner:
  json_serializable:
flutter: { uses-material-design: true }
```

### 2.1 Modeller (alanlar API doc'a birebir uyar)

```dart
// subscription_status.dart
@JsonEnum()
enum SubscriptionStatus {
  @JsonValue('ACTIVE') active,
  @JsonValue('GRACE') grace,
  @JsonValue('EXPIRED') expired,
}

// subscription_source.dart
@JsonEnum()
enum SubscriptionSource {
  @JsonValue('TRIAL') trial,
  @JsonValue('PAID') paid,
}

// payment_status.dart
@JsonEnum()
enum PaymentStatus {
  @JsonValue('PENDING') pending,
  @JsonValue('PAID') paid,
  @JsonValue('FAILED') failed,
}

// payment_outcome.dart  (mock confirm body)
@JsonEnum()
enum PaymentOutcome {
  @JsonValue('PAID') paid,
  @JsonValue('FAILED') failed,
}
```

```dart
@JsonSerializable() @immutable
final class SubscriptionModel extends Equatable {
  const SubscriptionModel({
    required this.id,
    required this.ownerId,
    required this.status,
    required this.source,
    required this.startDate,
    required this.endDate,
    required this.daysUntilExpiry,
    required this.graceDaysRemaining,
    required this.createdAt,
    required this.updatedAt,
    this.gracePeriodEndsAt,
  });
  factory SubscriptionModel.fromJson(Map<String, dynamic> json) => _$SubscriptionModelFromJson(json);

  final String id;
  final String ownerId;
  final SubscriptionStatus status;
  final SubscriptionSource source;
  final DateTime startDate;
  final DateTime endDate;
  final DateTime? gracePeriodEndsAt;
  final int daysUntilExpiry;
  final int graceDaysRemaining;
  final DateTime createdAt;
  final DateTime updatedAt;

  Map<String, dynamic> toJson() => _$SubscriptionModelToJson(this);

  @override
  List<Object?> get props => [
    id, ownerId, status, source, startDate, endDate,
    gracePeriodEndsAt, daysUntilExpiry, graceDaysRemaining,
    createdAt, updatedAt,
  ];
}
```

`PaymentModel`, `SubscriptionPricingModel`, `SubscriptionDetailModel` aynı kalıp.

`SubscriptionSummaryModel` — profile response'una embed olan hafif obje:

```dart
@JsonSerializable() @immutable
final class SubscriptionSummaryModel extends Equatable {
  const SubscriptionSummaryModel({
    required this.status,
    required this.endDate,
    required this.daysUntilExpiry,
    required this.graceDaysRemaining,
  });
  // ...
}
```

> **Profile tarafı:** `packages/auth/lib/models/profile_model.dart` güncellenir → `subscriptionEndDate` deprecate edilir (geri uyumluluk için `@deprecated` annotation), yerine `SubscriptionSummaryModel? subscription` field'ı eklenir. Mobile yeni alanı okur; backend her ikisini de bir süre doldurur.

### 2.2 Exception

```dart
// subscription_exception.dart
enum SubscriptionErrorCode {
  subscriptionRequired,    // 403 SUBSCRIPTION_REQUIRED → expired/grace@0
  noTables,                // 422 NO_TABLES
  invalidDuration,         // 422 INVALID_DURATION
  paymentNotFound,         // 404 PAYMENT_NOT_FOUND
  paymentAlreadyProcessed, // 409 PAYMENT_ALREADY_PROCESSED
  paymentProviderError,    // 502 PAYMENT_PROVIDER_ERROR
  pricingMismatch,         // 409 PRICING_MISMATCH
  forbidden,               // 403 FORBIDDEN (manager)
  unknown,
}

final class SubscriptionException extends AppException<SubscriptionErrorCode> {
  const SubscriptionException(super.error, {super.message, super.handleType});

  @override
  ErrorModel getModel() => ErrorModel(
    title: BaseMessage.defaultUiMessage,
    message: getUiMessage(),
  );

  @override
  BaseMessage getUiMessage() => switch (error) {
    SubscriptionErrorCode.subscriptionRequired => const BaseMessage(
      en: 'Subscription expired. Renew to continue using core features.',
      ru: 'Подписка истекла. Продлите её, чтобы продолжить пользоваться основными функциями.',
      ky: 'Жазылуу бүттү. Негизги функцияларды колдонуу үчүн узартыңыз.',
    ),
    SubscriptionErrorCode.noTables => const BaseMessage(...),
    // ...
  };
}
```

`subscriptionRequired` → `handleType: dialog` (kullanıcının görmemesi mümkün değil).
Diğerleri → `handleType: snackbar` (varsayılan).

### 2.3 Source & Repository

Sources `abstract interface class` (no `I` prefix), implementations `Impl` / `Mock` suffix. Repository tek concrete `final class`.

```dart
// subscription_remote_source.dart
abstract interface class SubscriptionRemoteSource {
  Future<SubscriptionDetailModel> getSubscription();
  Future<SubscriptionPricingModel> getPricing();
  Future<PaymentModel> createCheckout(CheckoutParam param);
  Future<PaymentModel> getPayment(String id);
  Future<PaymentModel> confirmMockPayment(String id, PaymentOutcome outcome);
}
```

```dart
// subscription_remote_source_impl.dart
@immutable
final class SubscriptionRemoteSourceImpl implements SubscriptionRemoteSource {
  const SubscriptionRemoteSourceImpl(this._client);
  final ApiClient _client;

  @override
  Future<SubscriptionDetailModel> getSubscription() => _client.getType(
    '/subscription',
    fromJson: SubscriptionDetailModel.fromJson,
  );

  @override
  Future<SubscriptionPricingModel> getPricing() => _client.getType(
    '/subscription/pricing',
    fromJson: SubscriptionPricingModel.fromJson,
  );

  @override
  Future<PaymentModel> createCheckout(CheckoutParam param) => _client.postType(
    '/subscription/checkout',
    body: param.toJson(),
    fromJson: PaymentModel.fromJson,
  );

  @override
  Future<PaymentModel> getPayment(String id) => _client.getType(
    '/subscription/payment/$id',
    fromJson: PaymentModel.fromJson,
  );

  @override
  Future<PaymentModel> confirmMockPayment(String id, PaymentOutcome outcome) =>
      _client.postType(
        '/subscription/payment/$id/confirm',
        body: { 'outcome': outcome.toJson() },  // veya enum -> string
        fromJson: PaymentModel.fromJson,
      );
}
```

> **Yol prefix'i:** `auth-api.md` ve `managers-api.md`'de mobile şu an `/auth/...` ve `/managers` kullanıyor (versiyon prefix'siz); `home_page_api.md` ve `subscription-api.md` `/api/v1/...` istiyor. Mobile tarafında **mevcut convention korunur** — `ApiClient` baseUrl'a göre append etmiyor; backend tutarlılığı kendisi sağlar veya nginx rewrite. Bu task'te biz `/subscription/...` kısa form üzerinden gideriz, son URL prefix kararı backend'in.

Mock — `Env.isMock` için. `AuthRemoteSourceMock` kalıbı:

```dart
final class SubscriptionRemoteSourceMock implements SubscriptionRemoteSource {
  // İç state: tek SubscriptionModel + List<PaymentModel> (in-memory).
  // - getSubscription: state'i döner; expiry hesabını anlık yapar.
  // - getPricing: const config — pricePerTable=200, currency=KGS, tableCount=10 (mock owner için).
  // - createCheckout: yeni Payment(PENDING) ekler, paymentUrl=null döner.
  // - confirmMockPayment(PAID): subscription'ı uzatır, payment'ı PAID yapar.
  // Test kolaylığı: dev menüsünden state'i sıfırlamak / GRACE simüle etmek.
}
```

Test senaryoları için mock'a 4 sabit "scenario" expose edilir: `ACTIVE_FAR`, `ACTIVE_WARNING_3D`, `GRACE_3D`, `EXPIRED`. Geliştirici dev menüsünden anlık geçer.

### 2.4 Public barrel

```dart
// subscription.dart
library;

export 'exceptions/subscription_exception.dart';
export 'models/checkout_param.dart';
export 'models/payment_model.dart';
export 'models/payment_outcome.dart';
export 'models/payment_status.dart';
export 'models/subscription_detail_model.dart';
export 'models/subscription_model.dart';
export 'models/subscription_pricing_model.dart';
export 'models/subscription_source.dart';
export 'models/subscription_status.dart';
export 'models/subscription_summary_model.dart';
export 'repository/subscription_repository.dart';
export 'source/remote/subscription_remote_source.dart';
// _impl.dart ve _mock.dart export edilmez — DI doğrudan import eder
```

---

## 3. DI

Yeni modul: `app/lib/core/di/modules/subscription_module.dart`. `ManagersModule` kalıbı.

```dart
final class SubscriptionModule extends BaseDiModule {
  const SubscriptionModule({super.scope});

  @override
  FutureOr<void> register(GetIt sl) async {
    super.register(sl);

    sl
      ..registerLazySingleton<SubscriptionRemoteSource>(
        () => Env.isMock
            ? SubscriptionRemoteSourceMock()
            : SubscriptionRemoteSourceImpl(
                sl<ApiClient>(instanceName: ApiClient.bearerInstance),
              ),
      )
      ..registerLazySingleton<SubscriptionRepository>(
        () => SubscriptionRepository(sl<SubscriptionRemoteSource>()),
      );
  }
}
```

`app/lib/core/di/di.dart`'da export ekle. Modül listesi (genellikle `main.dart` veya app bootstrap'inde) `SubscriptionModule()` ile genişletilir. `ManagerRepository` registration'dan **sonra** registerlanması gerekmiyor — bağımsız.

> **Cubit registration yok.** `code-rules.md`'ye uygun; cubit'ler ya StatefulWidget içinde ya da app root'unda doğrudan `BlocProvider(create: ...)` ile.

---

## 4. Global `SubscriptionCubit`

`AuthCubit` ile aynı seviyede yaşar. Login başarılı olduğunda `loadSummary()` çağrılır; logout'ta state sıfırlanır.

`features/subscription/cubit/subscription_cubit.dart`:

```dart
final class SubscriptionCubit extends Cubit<SubscriptionState> {
  SubscriptionCubit(this._repository) : super(const SubscriptionState());
  final SubscriptionRepository _repository;

  Future<void> loadSummary() async {
    emit(state.copyWith(summary: const RequestLoading()));
    try {
      // Hızlı: profile'dan gelen embed'i kullanırsak fetch'e gerek yok.
      // Standalone fetch için /subscription'dan SubscriptionSummary'ye projection.
      final detail = await _repository.getSubscription();
      emit(state.copyWith(summary: RequestSuccess(detail.subscription.toSummary())));
    } on Object catch (e) {
      emit(state.copyWith(summary: RequestFailure(e)));
    }
  }

  /// Diğer cubit'ler ödeme sonrası "haber ver" için çağırır.
  Future<void> refresh() => loadSummary();

  void clear() => emit(const SubscriptionState());
}
```

`subscription_state.dart`:

```dart
@immutable
final class SubscriptionState extends Equatable {
  const SubscriptionState({this.summary = const RequestInitial()});
  final RequestStatus<SubscriptionSummaryModel> summary;

  bool get isBlocked {
    final s = summary.dataOrNull;
    if (s == null) return false;
    return s.status == SubscriptionStatus.expired ||
           (s.status == SubscriptionStatus.grace && s.graceDaysRemaining == 0);
  }

  bool get hasWarning {
    final s = summary.dataOrNull;
    if (s == null) return false;
    return s.status == SubscriptionStatus.grace ||
           (s.status == SubscriptionStatus.active && s.daysUntilExpiry <= 3);
  }

  SubscriptionState copyWith({RequestStatus<SubscriptionSummaryModel>? summary}) =>
      SubscriptionState(summary: summary ?? this.summary);

  @override
  List<Object?> get props => [summary];
}
```

**App root entegrasyonu** (`app/lib/app/view/app_view.dart`'a paralel):

```dart
MultiBlocProvider(
  providers: [
    BlocProvider(create: (_) => AuthCubit(...)..checkAuthStatus()),
    BlocProvider(create: (_) => SubscriptionCubit(GetIt.I<SubscriptionRepository>())),
  ],
  child: BlocListener<AuthCubit, AuthState>(
    listenWhen: (prev, next) => prev.runtimeType != next.runtimeType,
    listener: (context, authState) {
      final sub = context.read<SubscriptionCubit>();
      if (authState is AuthAuthenticated && authState.role == UserRole.owner) {
        sub.loadSummary();
      } else {
        sub.clear();
      }
    },
    child: ...,
  ),
)
```

> Manager için `SubscriptionCubit` boş kalır; soft-block manager'a uygulanmaz (manager zaten yazma endpoint'lerini çağırırken backend kontrolü ile karşılaşır; mobile soft-block sadece owner UX'i için).

---

## 5. Routes

`app/lib/app/router/app_routes.dart`:

```dart
abstract final class AppRoutes {
  // ...
  static const subscription = '/subscription';
  static const subscriptionCheckout = '/subscription/checkout';
  static const subscriptionPayment = '/subscription/payment';
}
```

`app/lib/app/router/app_router.dart` — yeni 3 GoRoute (managers route'u kalıbı):

```dart
GoRoute(
  path: AppRoutes.subscription,
  builder: (_, _) => const SubscriptionView(),
),
GoRoute(
  path: AppRoutes.subscriptionCheckout,
  builder: (_, _) => const SubscriptionCheckoutView(),
),
GoRoute(
  path: AppRoutes.subscriptionPayment,
  redirect: (_, state) => state.extra is PaymentModel ? null : AppRoutes.subscription,
  builder: (_, state) => SubscriptionPaymentView(payment: state.extra! as PaymentModel),
),
```

> Auth-gated. Subscription route'ları `_authRoutes`'a girmez — authenticated user'lar erişir.

---

## 6. Feature klasörü

```
app/lib/features/subscription/
├── subscription.dart                  ← barrel export
├── cubit/
│   ├── subscription_cubit.dart        ← global; app root'ta BlocProvider
│   ├── subscription_state.dart
│   ├── subscription_detail_cubit.dart ← page-level (/subscription)
│   ├── subscription_checkout_cubit.dart
│   └── subscription_payment_cubit.dart
├── view/
│   ├── subscription_view.dart
│   ├── subscription_checkout_view.dart
│   └── subscription_payment_view.dart
└── widgets/
    ├── subscription_status_banner.dart        ← warning/grace/expired
    ├── subscription_plan_card.dart            ← turuncu gradient (work/subscription.png referansı)
    ├── subscription_detail_rows.dart          ← Next/Last payment, Status
    ├── subscription_payment_history.dart      ← liste
    ├── subscription_payment_history_item.dart
    ├── subscription_skeleton.dart
    ├── subscription_error_view.dart
    ├── subscription_empty_no_tables.dart      ← tableCount=0 empty state
    ├── subscription_continue_fab.dart         ← collapseOnScroll button wrapper
    ├── subscription_duration_picker.dart      ← chip group + custom stepper
    ├── subscription_total_card.dart
    ├── subscription_blocked_dialog.dart       ← soft-block dialog
    └── subscription_gate.dart                 ← onPressed wrapper helper
```

> View dosyaları ≤ ~180 satır kuralı: çoğu satırı widget composition. Form alanı yok, durum başına 1 widget.

### 6.1 `SubscriptionView` (`/subscription`)

- `StatefulWidget`. `late final SubscriptionDetailCubit _cubit;` initState'te `GetIt`'ten repo alarak instantiate; `dispose`'da close.
- `BlocConsumer<SubscriptionDetailCubit, DataState<SubscriptionDetailModel>>` — `DataState<T>` (sealed) kullanılır çünkü tek alan async.
- AppBar: `Subscription` title + back.
- `RefreshIndicator.adaptive`.
- Body sırası: warning/grace/expired banner (varsa) → plan card → detail rows → payment history.
- FAB: `SubscriptionContinueFab` (sadece `state.hasWarning`'da görünür).
- Action menu (`AppBar` actions) — `Icons.help_outline` → `ContactSupportSheet.show(context)`. Sayfanın her durumunda erişilebilir (yardım için).
- Skeleton ve `SubscriptionErrorView` (retry'lı) kullanılır.

### 6.2 `SubscriptionCheckoutView` (`/subscription/checkout`)

- `StatefulWidget` + `SubscriptionCheckoutCubit`.
- `loadPricing()` → state: `RequestStatus<SubscriptionPricingModel>` + `int months` (1'den başlar).
- `tableCount = 0` → `SubscriptionEmptyNoTables` (Add table CTA).
- Yapı: pricing özet kartı → `SubscriptionDurationPicker` (chips: 1/3/6/12 + numeric stepper) → `SubscriptionTotalCard` (animated total + new endDate preview) → `AppButton(isLoading)` "Pay".
- "Pay" → `cubit.checkout()` → success'te `context.push(AppRoutes.subscriptionPayment, extra: payment)` ve sayfayı `pushReplacement` etmek yerine push (kullanıcı geri gelirse pricing yine geçerli).
- AppBar action: `ContactSupportSheet`.
- `AppButtonScope` ile sarılır; `collapseOnScroll: true` Pay butonu için.

### 6.3 `SubscriptionPaymentView` (`/subscription/payment`)

- `StatefulWidget` + `SubscriptionPaymentCubit`. Constructor'a `PaymentModel` payment alır (extra'dan).
- **Mock mode** (`payment.paymentUrl == null` veya `payment.provider == MOCK`):
  - Gövde: "Mock payment" header, ödeme tutarı, "Simulate success" / "Simulate failure" iki AppButton.
  - Buton → `cubit.confirmMock(outcome)` → `PaymentModel` döner. `PAID` ise success state, `FAILED` ise error.
- **Real mode** (`paymentUrl != null`):
  - WebView (yeni dependency: `webview_flutter` — bu task'te eklenir). `paymentUrl` yüklenir.
  - Yan tarafta "I've paid" ve "Cancel" butonları.
  - Kullanıcı geri döndüğünde `cubit.startPolling(payment.id)` → 5sn aralıkla `getPayment`, max 12 attempt (= 60sn), her attempt `state.attemptCount` günceller.
- Polling sonucu `PAID`:
  - `context.read<SubscriptionCubit>().refresh()` (global özet güncellenir).
  - `AppSuccessSheet` veya success bottom sheet ile "Subscription extended until {date}" mesajı.
  - `context.go(AppRoutes.profile)` (stack'i temizle).
- `FAILED`:
  - Error dialog → "Try again" (geri checkout'a) / "Contact support" (`ContactSupportSheet`).
- Polling timeout (`PENDING > 60s`):
  - "Still processing" empty-state, "Refresh" butonu.

### 6.4 `SubscriptionContinueFab`

`AppButtonScope` + `AppButton(collapseOnScroll: true, ...)`. Profil zaten StatefulShell içinde; subscription view shell dışında, kendi Scaffold'una sarılır.

### 6.5 `SubscriptionGate` (soft-block)

Yardımcı yöntem (widget değil; sadece bir helper):

```dart
// widgets/subscription_gate.dart
abstract final class SubscriptionGate {
  /// Action'ı çalıştırmadan önce subscription kontrol eder.
  /// Bloke ise dialog gösterir, action'ı çağırmaz.
  static Future<void> guard(
    BuildContext context, {
    required Future<void> Function() action,
  }) async {
    final state = context.read<SubscriptionCubit>().state;
    if (state.isBlocked) {
      await SubscriptionBlockedDialog.show(context);
      return;
    }
    await action();
  }
}
```

**Kullanım yerleri** (Home'daki yazma aksiyonları):

- `home_view.dart`'ta masa kartı tap → `SubscriptionGate.guard(context, action: () => _startSession(...))`.
- Venue/table form'larında "Save" → aynı.
- Manager invite section → aynı.

> Manager için: `SubscriptionGate.guard` AuthCubit role'üne bakar; manager ise direkt action çalıştırır (sunucu zaten kontrol ediyor; mobile soft-block sadece owner için).

`SubscriptionBlockedDialog`:

- `AdaptiveDialog` veya bottom sheet.
- İkon: `Icons.lock_outline`. Başlık: `subscriptionBlockedTitle`. Açıklama: `subscriptionBlockedSubtitle`.
- 2 buton: `Cancel` + `Renew now` → `context.push(AppRoutes.subscription)`.

### 6.6 Backend fallback — `SUBSCRIPTION_REQUIRED` interceptor

`packages/api_client/lib/interceptors/`'a yeni bir interceptor eklemek **gerekmez** — mevcut `BaseErrorHandler` mekanizmasında sadece kod eşleştirmesi var. Mobile genelinde:

- Yazma endpoint'leri zaten `SubscriptionGate` ile filtrelendiği için `SUBSCRIPTION_REQUIRED` cevabı **beklenmedik durum** (yarış: kullanıcı tam o anda expire oldu).
- Yine de yakalamak için: yeni `SubscriptionExpirationHandler` (`UnauthenticatedExceptionHandle` kalıbı). DI'da `ErrorHandler` `instanceName: 'subscription'` ile registerlanır. Global `BaseErrorHandler` dispatcher 403 + `SUBSCRIPTION_REQUIRED` code'unu bu handler'a yönlendirir.
- Handler: `SubscriptionBlockedDialog.show(context)` + `SubscriptionCubit.refresh()` (state'i senkronla).

---

## 7. Profile entegrasyonu

[user_profile_extra_data.dart:33-44](../app/lib/features/profile/widgets/user_profile_extra_data.dart#L33-L44):

- `if (subscriptionEndDate != null)` — değişir: `SubscriptionCubit` summary'sinden çekilir. Tile sadece **OWNER**'a gösterilir (bugün her user'a gösteriyor — düzeltilecek).
- `onTap: () {}` → `context.push(AppRoutes.subscription)`.
- Subtitle status'a göre lokalize:
  - ACTIVE & far: `profileSubscriptionActiveUntil(date)` (mevcut).
  - ACTIVE & ≤3d: `profileSubscriptionExpiresIn(n)`.
  - GRACE: `profileSubscriptionGrace(n)`.
  - EXPIRED: `profileSubscriptionExpired`.
- Renk: hasWarning ise `appColors.warning`'la altına küçük rozet; expired ise `colors.error`.

`profile_model.dart` (`packages/auth/`):

- `subscriptionEndDate` field'ı kaldırılır (deprecated yerine direkt sil — `code-rules.md`: backwards-compat hack yok). Yerine `final SubscriptionSummaryModel? subscription;`.
- `auth` paketi `subscription` paketine **depend etmez** — döngü olur. Çözüm: `SubscriptionSummaryModel`'ın bir kopyası `auth` içine `ProfileSubscriptionSummary` olarak konur (sadece 4 field), `subscription` paketi `auth`'tan **import etmez**, mobile uygulaması kendi mapper'ı ile çevirir. Alternatif: `core` paketine ortak bir `SubscriptionSummary` taşıyıp ikisi de oradan kullansın. **Tercih:** yeni `core/subscription/subscription_summary.dart` — `core`'a hafif bir model eklemek yeterince ucuz ve duplikasyonu önler.

---

## 8. Auth entegrasyonu

### 8.1 Register sonrası TRIAL — backend yapar, mobile yapmaz

Mobile register başarılı olduğunda zaten home'a gider. Backend response'unda subscription artık dolu gelir; profile/subscription tile o veriyi okur. Mobile tarafında ekstra iş yok.

### 8.2 Login sonrası

`AuthCubit` `AuthAuthenticated` emit ettiğinde `BlocListener` `SubscriptionCubit.loadSummary()` çağırır (bkz. § 4).

### 8.3 Logout

`AuthCubit.logout()` çağrıldığında listener `SubscriptionCubit.clear()` çağırır.

---

## 9. ContactSupportSheet — taşıma

Bugün: [features/auth/forgot_password/widgets/contact_support_sheet.dart](../app/lib/features/auth/forgot_password/widgets/contact_support_sheet.dart).
Subscription da kullanacak → **shared component**. Plan:

1. Dosyayı `app/lib/ui/components/sheet/contact_support_sheet.dart`'a taşı.
2. `app/lib/ui/components/components.dart` barrel'ine ekle.
3. L10n key'leri rename: `authContactSupportTitle` → `contactSupportTitle`, `authContactSupportSubtitle` → `contactSupportSubtitle`, `authContactCallLabel` → `contactCallLabel`. Türetilmiş metin değişmez; sadece prefix nötrleşir.
4. ARB dosyaları (`en` / `ru` / `ky`) — eski 3 key silinir, yeni 3 key eklenir. `flutter gen-l10n`.
5. `forgot_password_view.dart`'ta import güncellenir, çağrı `ContactSupportSheet.show(context)` aynı kalır.
6. `subscription_view.dart`, `subscription_checkout_view.dart`, `subscription_payment_view.dart` action olarak ekler.

> `SupportContacts` zaten `core/constants/`'ta, paylaşıma uygun.

---

## 10. L10n anahtarları (yeni)

`app/lib/l10n/arb/app_{en,ru,ky}.arb` dosyalarına aşağıdaki key'ler eklenir. (`flutter gen-l10n` sonrası `context.l10n.<key>` ile erişilir.)

| Key                                  | EN örneği                                                           |
| ------------------------------------ | ------------------------------------------------------------------- |
| `subscriptionTitle`                  | Subscription                                                        |
| `subscriptionStatusActive`           | Active                                                              |
| `subscriptionStatusGrace`            | Grace period                                                        |
| `subscriptionStatusExpired`          | Expired                                                             |
| `subscriptionSourceTrial`            | Free trial                                                          |
| `subscriptionSourcePaid`             | Paid                                                                |
| `subscriptionWarningBanner`          | Your subscription expires in {n} days. Renew to avoid interruption. |
| `subscriptionGraceBanner`            | Subscription expired. {n} day(s) of grace period left.              |
| `subscriptionExpiredBanner`          | Subscription expired. Renew to use core features.                   |
| `subscriptionPlanCardPerTable`       | {price} {currency} / table / month                                  |
| `subscriptionPlanCardMonthly`        | × {tableCount} tables = {monthly} {currency} / month                |
| `subscriptionDetailNextPayment`      | Next payment                                                        |
| `subscriptionDetailLastPayment`      | Last payment                                                        |
| `subscriptionDetailStatus`           | Status                                                              |
| `subscriptionPaymentHistoryTitle`    | Payment history                                                     |
| `subscriptionPaymentHistoryEmpty`    | No payments yet                                                     |
| `subscriptionPaymentItemSummary`     | {months} months × {tableCount} tables                               |
| `subscriptionContinueCta`            | Continue subscription                                               |
| `subscriptionCheckoutTitle`          | Checkout                                                            |
| `subscriptionCheckoutDuration`       | Duration                                                            |
| `subscriptionCheckoutTotal`          | Total                                                               |
| `subscriptionCheckoutNewEndDate`     | New end date: {date}                                                |
| `subscriptionCheckoutPay`            | Pay                                                                 |
| `subscriptionCheckoutNoTables`       | Add at least one table to subscribe                                 |
| `subscriptionCheckoutGoToVenues`     | Go to venues                                                        |
| `subscriptionPaymentMockTitle`       | Mock payment                                                        |
| `subscriptionPaymentSimulateSuccess` | Simulate success                                                    |
| `subscriptionPaymentSimulateFailure` | Simulate failure                                                    |
| `subscriptionPaymentSuccessTitle`    | Payment successful                                                  |
| `subscriptionPaymentSuccessBody`     | Subscription extended until {date}.                                 |
| `subscriptionPaymentFailedTitle`     | Payment failed                                                      |
| `subscriptionPaymentPending`         | Still processing… please check back later.                          |
| `subscriptionBlockedTitle`           | Subscription required                                               |
| `subscriptionBlockedSubtitle`        | Renew your subscription to use core features.                       |
| `subscriptionBlockedRenew`           | Renew now                                                           |
| `subscriptionBlockedCancel`          | Not now                                                             |
| `profileSubscriptionExpiresIn`       | Expires in {n} days                                                 |
| `profileSubscriptionGrace`           | Grace · {n} day(s) left                                             |
| `profileSubscriptionExpired`         | Expired                                                             |
| `contactSupportTitle`                | (mevcut `authContactSupportTitle`'ın yeni adı)                      |
| `contactSupportSubtitle`             | (mevcut `authContactSupportSubtitle`'ın yeni adı)                   |
| `contactCallLabel`                   | (mevcut `authContactCallLabel`'ın yeni adı)                         |

ARB placeholder tanımı şart olan key'ler (`{n}`, `{date}`, `{price}` gibi):

```json
"subscriptionWarningBanner": "Your subscription expires in {n} days. Renew to avoid interruption.",
"@subscriptionWarningBanner": {
  "placeholders": { "n": { "type": "int" } }
}
```

Para formatı: helper `core/extension/currency_extension.dart`'a `String formatAmount(int amount, String currency)` eklenir veya yerinde `'$amount $currency'` (basit). MVP için basit string yeterli.

---

## 11. Ödeme tarihi formatlaması & timezone

- Tüm tarihler ISO-8601 UTC. Mobile'da `DateTime.toLocal()` ile gösterilir.
- `intl` zaten dependency. Format: `DateFormat('d MMMM yyyy', languageCode)`.
- `daysUntilExpiry` ve `graceDaysRemaining` **backend'den geldiği gibi** gösterilir; mobile yeniden hesaplamaz.

---

## 12. Yeni dependency'ler

- **`webview_flutter`** — gerçek payment provider redirect için. **MVP'de eklenmez** (mock kullanıyoruz). Real Finik entegrasyonunda eklenir; MVP scope dışı.

MVP için **yeni dependency yok**.

---

## 13. Implementation sırası (PR planı)

Önerilen 3 PR:

### PR 1 — Veri katmanı (`packages/subscription/`)

1. `packages/subscription/` klasörünü oluştur, `pubspec.yaml` yaz, root workspace'a ekle.
2. Modeller + enum'lar + exception.
3. Source interface + impl + mock.
4. Repository.
5. `melos bootstrap` → `make build-runner`.
6. (İsteğe bağlı) `packages/subscription/test/repository_test.dart` — `mocktail` ile basit happy-path testleri.
7. `packages/auth`'taki `ProfileModel`'i güncelle (yeni `subscription` field'ı). `core`'a `SubscriptionSummary` ekle.
8. `make build-runner`.

### PR 2 — Feature + global cubit + UI

1. `app/lib/core/di/modules/subscription_module.dart` ekle, `di.dart` ve bootstrap'a register et.
2. `features/subscription/cubit/subscription_cubit.dart` (global) + state.
3. App root'unda `BlocProvider<SubscriptionCubit>` ekle, `BlocListener<AuthCubit>` ile `loadSummary` / `clear` bağla.
4. Routes (`AppRoutes` + `app_router.dart` 3 yeni route).
5. `SubscriptionView` + skeleton + error view + payment history.
6. `SubscriptionCheckoutView` + duration picker + total card + empty-no-tables.
7. `SubscriptionPaymentView` (sadece mock akış).
8. L10n (yeni key'ler + ARB güncelleme + `flutter gen-l10n`).
9. Profile tile bağlantısı (`onTap`, role check, dynamic subtitle).
10. ContactSupportSheet'i `ui/components/sheet/`'e taşı + l10n rename + 2 import güncellemesi.

### PR 3 — Soft-block

1. `SubscriptionGate` helper.
2. Home masa kartı tap'ında `SubscriptionGate.guard`.
3. Venue/table form save'lerinde guard.
4. Manager invite section'da guard.
5. `SubscriptionBlockedDialog`.
6. `SubscriptionExpirationHandler` (interceptor değil, `ErrorHandler` registration; backend yarış için).
7. `melos run analyze-check` + `melos run unit-test`.

> PR 2 ve PR 3 paralel gidebilir; PR 1 her ikisinin önkoşulu.

---

## 14. Test senaryoları (acceptance)

Bu listeyi mock'ta dev menüsü ile elle test edeceğiz:

1. **TRIAL @ day 14** — profile'da "Active · until {date}", subscription page'de plan card, payment history boş, FAB yok.
2. **ACTIVE @ day 5** — aynı, FAB yok.
3. **ACTIVE @ day 3** — profile'da "Expires in 3 days", subscription page'de turuncu warning banner + FAB var.
4. **ACTIVE @ day 1** — aynı, "Expires in 1 day".
5. **GRACE @ day 4 left** — profile'da "Grace · 4 days left", sarı banner üstte, FAB var, masa kartı çalışır.
6. **GRACE @ day 0** — kırmızı banner, FAB var, masa kartı tap → `SubscriptionBlockedDialog` (action engellenir).
7. **EXPIRED** — kırmızı banner, FAB var, tüm yazma aksiyonları bloke.
8. **Checkout flow:** ACTIVE @ day 3 → "Continue" → `SubscriptionCheckoutView` → 1/3/6/12 ay seç → total doğru hesaplanıyor → Pay → mock payment → "Simulate success" → success sheet → profile'da yeni endDate.
9. **`tableCount = 0`:** mock sample owner'ı 0 masaya çek → checkout açıldığında empty state.
10. **Manager hesap:** profile'da "Subscription" tile'ı YOK; soft-block uygulanmaz; backend `SUBSCRIPTION_REQUIRED` dönerse global handler dialog gösterir.
11. **ContactSupportSheet** subscription view + checkout + payment view AppBar action'larından açılıyor; auth/forgot_password sayfasında hâlâ çalışıyor.

---

## 15. Açık sorular (mobile-spesifik)

- [ ] **`SubscriptionSummary`'nin yeri** — `core`'a mı yoksa `auth`'a mı? Önerim `core`. Kabul ediyorsanız öyle ilerleyelim.
- [ ] **Dev menüsü** — mock'taki 4 senaryoyu manuel test için `Settings`'e gizli bir "Dev tools" şortkat'ı koyalım mı? Faydalı ama scope dışı; istenirse PR 2'ye eklenebilir.
- [ ] **`SubscriptionExpirationHandler`** — yarış senaryosu çok nadir; "global handler ekleyip ileride kullanırız" mı, "MVP'de yazmayalım" mı? Önerim: yazalım, kod 30 satır.
- [ ] **Animation** — durum değişiminde banner'ın `AnimatedSwitcher` ile fade-in olması güzel olur. Yapalım mı? Önerim: evet, ek 10 satır.
- [ ] **Currency formatting** — `intl`'in `NumberFormat.currency`'sine geçelim mi (`200 сом` yerine `200 KGS` veya `200 ₽`)? MVP'de basit string; v2'de iyileştirilebilir.
- [ ] **Real Finik entegrasyonu** — bu task'in kapsamı dışı; PR 4 olarak ayrı bir iterasyonda yapılır.

---

## 16. Onay sonrası implementasyon başlangıcı

Bu plan onaylandığında:

1. Önce **PR 1**'in dosyalarını yazarım (veri katmanı; build-runner generate dahil).
2. Çalıştığını doğrularım (`melos run analyze-check`).
3. Sonra **PR 2** (feature + UI + l10n + profile tile + ContactSupportSheet taşıma).
4. Son olarak **PR 3** (soft-block + dialog + global error handler).

Her PR'da `make build-runner` + `melos run format` + `melos run analyze-check` çalışır; CI parite olur.
