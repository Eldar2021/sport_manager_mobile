# Code Rules

Code conventions and standards for the Sport Manager Mobile project.

## General

- **Linter:** `very_good_analysis` v10.2.0
- **Line length:** 120 characters
- **Formatter:** `dart format . --line-length 120`
- **Trailing commas:** preserve

### `analysis_options.yaml`

```yaml
linter:
  rules:
    public_member_api_docs: false
    lines_longer_than_80_chars: false
    sort_pub_dependencies: false
    avoid_positional_boolean_parameters: false
    one_member_abstracts: false
    discarded_futures: false

analyzer:
  exclude:
    - "**/*.g.dart"
  errors:
    todo: ignore
```

---

## Naming

### Files

- Format: `snake_case.dart`
- Examples: `venues_cubit.dart`, `session_model.dart`, `table_card.dart`

### Classes

| Type             | Format                     | Example                         |
| ---------------- | -------------------------- | ------------------------------- |
| Interface        | `abstract interface class` | `VenueRemoteSource`             |
| Implementation   | `Impl` suffix              | `VenueRemoteSourceImpl`         |
| Mock             | `Mock` suffix              | `AuthRemoteSourceMock`          |
| Model            | `Model` suffix             | `SessionModel`, `VenueModel`    |
| Param / DTO      | `Param` or `Body` suffix   | `StartSessionParam`             |
| Cubit            | `Cubit` suffix             | `VenuesCubit`, `SettingsCubit`  |
| State            | `State` suffix             | `VenuesState`, `SettingsState`  |
| Repository       | `Repository` suffix        | `AuthRepository`                |
| DI module        | `Module` suffix            | `VenuesModule`, `NetworkModule` |
| Domain exception | `Exc` suffix               | `FacilityExc`, `AuthExc`        |

> **Don't add `I` prefix to interfaces.** The `Impl` suffix on the
> implementation already conveys the interface/impl relationship; `I`
> in front of the abstract class is redundant. Interfaces stay with
> their bare name (`AuthRemoteSource`, `VenueRemoteSource`).

### Class keywords

```dart
// Immutable data classes
final class SessionModel extends Equatable { ... }

// Interfaces (no `I` prefix)
abstract interface class VenueRemoteSource { ... }

// Abstract bases
abstract class BaseDiModule extends DIModule<GetIt> { ... }

// Sealed states
sealed class AuthState extends Equatable { ... }
final class AuthSuccess extends AuthState { ... }
```

### Variables and methods

- `camelCase` — `accessToken`, `sessionModel`
- Private members use `_` prefix: `_storage`, `_client`
- Constants use `camelCase`, not `SCREAMING_SNAKE`: `static const bearerInstance`
- Methods use `camelCase`: `loadVenues()`, `startSession()`

### Constructor parameter style

If a class has **exactly one** domain parameter, use a **positional**
parameter — not a single-element named bag.

```dart
// Bad — noisy named API for one field
const FraudFlagList({required this.flags, super.key});

// Good — positional reads naturally at the call site
const FraudFlagList(this.flags, {super.key});

// Call sites:
FraudFlagList(state.flags)            // not FraudFlagList(flags: state.flags)
```

`super.key` doesn't count toward the "one parameter" tally — it's a
framework concern, not domain. Multi-domain-param widgets stay named
(`{required this.row, required this.maxRevenue}`) so call sites self-document.

### Trailing commas & multi-line formatting

[`analysis_options.yaml`](../analysis_options.yaml) has `trailing_commas: preserve` — the formatter
respects whatever shape you write. Use that lever:

- **Single arg** → keep it on one line.
- **2+ args** → put each on its own line **with a trailing comma**, even
  if it would fit on one line. The diff stays narrow when arguments are
  added or reordered, and the call reads top-to-bottom instead of
  scanning a long horizontal line.

```dart
// Bad — fits, but next add/edit thrashes the whole line
Icon(Icons.verified_outlined, color: context.appColors.success),

// Good — each arg owns a line, trailing comma keeps shape stable
Icon(
  Icons.verified_outlined,
  color: context.appColors.success,
),
```

---

## Import order

```dart
// 1. Dart SDK
import 'dart:async';
import 'dart:io';

// 2. Flutter SDK
import 'package:flutter/material.dart';

// 3. External packages
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';

// 4. Internal monorepo packages
import 'package:core/core.dart';
import 'package:api_client/api_client.dart';
import 'package:storage_client/storage_client.dart';

// 5. Relative imports
import '../widgets/table_card.dart';
```

---

## State management

### Cubit vs Bloc

- **Cubit** — preferred: simple state transitions, forms, toggles
- **Bloc** — for complex event-based logic

### Two state shapes

**Sealed class** — for mutually exclusive states:

```dart
sealed class AuthState extends Equatable {
  const AuthState();
}

final class AuthInitial extends AuthState { const AuthInitial(); }
final class AuthLoading extends AuthState { const AuthLoading(); }
final class AuthSuccess extends AuthState {
  const AuthSuccess(this.token);
  final String token;
  @override
  List<Object?> get props => [token];
}
```

**Single state + copyWith** — for several independent fields:

```dart
final class VenuesState extends Equatable {
  const VenuesState({
    this.venues = const RequestInitial(),
    this.tables = const RequestInitial(),
  });

  final RequestStatus<List<VenueModel>> venues;
  final RequestStatus<List<SpotModel>> tables;

  VenuesState copyWith({
    RequestStatus<List<VenueModel>>? venues,
    RequestStatus<List<SpotModel>>? tables,
  }) => VenuesState(
    venues: venues ?? this.venues,
    tables: tables ?? this.tables,
  );

  @override
  List<Object?> get props => [venues, tables];
}
```

### Async operations

Always use `RequestStatus` or `DataState`:

```dart
Future<void> loadVenues() async {
  emit(state.copyWith(venues: const RequestLoading()));
  try {
    final result = await _repository.getVenues();
    emit(state.copyWith(venues: RequestSuccess(result)));
  } on Object catch (e) {
    emit(state.copyWith(venues: RequestFailure(e)));
  }
}
```

---

## Models

- Annotate with `@JsonSerializable()` + `@immutable`
- Extend `Equatable`
- Required: `fromJson`, `toJson`
- `copyWith` — when needed

```dart
@JsonSerializable()
@immutable
final class SessionModel extends Equatable {
  const SessionModel({required this.id, required this.tableId, this.endedAt});

  factory SessionModel.fromJson(Map<String, dynamic> json) =>
      _$SessionModelFromJson(json);

  final String id;
  final String tableId;
  final DateTime? endedAt;

  Map<String, dynamic> toJson() => _$SessionModelToJson(this);

  @override
  List<Object?> get props => [id, tableId, endedAt];
}
```

### Enum serialization

```dart
@JsonEnum()
enum SessionStatus {
  @JsonValue('ACTIVE') active,
  @JsonValue('CLOSED') closed,
}
```

---

## Repositories

### Layers

```
Cubit → Repository → Remote Source / Local Source
```

- Repositories own business logic and orchestrate sources
- Remote source — API calls via `ApiClient`, declared as `abstract interface class` + `Impl`/`Mock`
- Local source — persistence via `StorageInterfaceSyncRead`, declared as `abstract interface class` + `Impl`
- **Repository is a single concrete `final class` — do NOT split it into interface + `Impl`.**
  The variation point lives in the data sources, which are already abstract. Adding a
  second interface layer on the repository is redundant.

```dart
@immutable
final class AuthRepository {
  const AuthRepository({
    required AuthRemoteSource remote,
    required AuthLocalSource local,
  }) : _remote = remote, _local = local;

  final AuthRemoteSource _remote;
  final AuthLocalSource _local;

  Future<AuthResultModel> login({required String username, required String password}) async {
    final result = await _remote.login(username: username, password: password);
    await Future.wait([_local.saveTokens(result.tokens), _local.saveUser(result.user)]);
    return result;
  }

  Future<void> logout() async {
    await _local.clearAll();
    try {
      await _remote.logout();
    } on Object catch (e) {
      log('remote logout failed (ignored): $e');
    }
  }
}
```

The sources, by contrast, ARE split:

```dart
abstract interface class AuthRemoteSource {
  Future<AuthResultModel> login({required String username, required String password});
  Future<void> logout();
}

final class AuthRemoteSourceImpl implements AuthRemoteSource { ... }   // real
final class AuthRemoteSourceMock implements AuthRemoteSource { ... }   // dev mode
```

---

## Navigation

- Routes are `static const` on `AppRoutes`
- Navigate with GoRouter: `context.push()`, `context.go()`, `context.pop()`
- Pass arguments via GoRouter `extra` or `queryParameters`

```dart
abstract final class AppRoutes {
  static const home = '/';
  static const settings = '/settings';
  static const venues = '/venues';
}
```

---

## DI

- Every module extends `BaseDiModule`
- Prefer `registerLazySingleton` for services (repositories, sources, clients)
- For multiple instances of the same type, use `instanceName` (e.g. `'snackbar'`, `'dialog'`, `'unauthenticated'`)
- Order matters: dependencies must be registered before their dependents
- Cubits are NOT registered in DI modules — see "Cubit ownership" below

### Cubit ownership

There are two patterns depending on cubit scope. Pick the one that matches.

**Single-page cubit** (only one screen uses it — e.g. `LoginCubit`, `RegisterCubit`,
`ForgotPasswordCubit`):

- Declare as `late final` field inside the page's `StatefulWidget` state
- Init in `initState` with `GetIt.I<XRepository>()`
- Pass explicitly via `bloc:` to `BlocConsumer` / `BlocBuilder`
- `close()` it in `dispose()`
- **Do NOT wrap the page in a `BlocProvider`.** Keeping it local makes ownership
  obvious and avoids putting the cubit in the inherited-widget tree where nothing
  else can reach it anyway.

```dart
class _LoginViewState extends State<LoginView> {
  late final LoginCubit _loginCubit;

  @override
  void initState() {
    super.initState();
    _loginCubit = LoginCubit(GetIt.I<AuthRepository>());
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<LoginCubit, DataState<AuthResultModel>>(
      bloc: _loginCubit,
      listener: ...,
      builder: ...,
    );
  }

  @override
  void dispose() {
    _loginCubit.close();
    super.dispose();
  }
}
```

**App- or feature-level cubit** (shared across multiple widgets — e.g. `AuthCubit`,
`SettingsCubit`):

- Wrap the relevant subtree in `BlocProvider(create: ...)` (typically at the app root)
- Consume via `context.read<X>()` / `context.watch<X>()` / `BlocBuilder`

---

## Feature folder structure

Top-level features live under `app/lib/features/<feature>/`. When a feature has
**multiple sub-screens** that share a domain (e.g. auth has login, register,
forgot_password, update_password, welcome), each sub-screen gets its **own
nested folder** with `cubit/`, `view/`, `widgets/`, and a barrel `<sub>.dart`.
Don't dump all cubits in one `cubit/` and all views in one `view/` — that
gets unreadable as the feature grows.

**Reference shape — `features/auth/`:**

```
features/auth/
├── auth.dart                  ← top-level barrel
├── cubit/                     ← feature-wide AuthCubit (shared across sub-screens)
│   ├── auth_cubit.dart
│   └── auth_state.dart
├── login/
│   ├── cubit/
│   ├── view/
│   ├── widgets/               ← optional, only if widgets are login-specific
│   └── login.dart             ← sub-feature barrel
├── register/
│   ├── cubit/
│   ├── view/
│   ├── widgets/
│   └── register.dart
├── forgot_password/
│   ├── cubit/
│   ├── view/
│   ├── widgets/
│   └── forgot_password.dart
└── welcome/
    ├── view/
    └── welcome.dart
```

Apply the same shape to any new feature with multiple screens (e.g.
`features/subscription/` has detail + checkout + payment sub-folders, each
with its own `cubit/view/widgets/<sub>.dart`).

A widget that **multiple sub-screens share** lives at the feature root in
`features/<feature>/widgets/`, not inside any one sub-screen's folder.

A widget that's **truly cross-feature** (e.g. `ContactSupportSheet`,
`ProfileItemTile`) belongs in `app/lib/ui/components/`, not under any
feature.

### Barrels are exhaustive

A feature barrel (`features/<feature>/<feature>.dart`) and each
sub-feature barrel (`<sub>/<sub>.dart`) re-export **every** public file
in their tree — cubits, views, widgets, utils, sub-feature barrels.
Consumers should never need a deep import path to reach an internal
file.

```dart
// features/report/report.dart
export 'manager_detail/manager_detail.dart';
export 'overview/overview.dart';
export 'table_detail/table_detail.dart';
export 'utils/report_format.dart';
export 'widgets/manager_risk_badge.dart';
export 'widgets/report_kpi_card.dart';
// ...etc — every public file
```

**Bad — many lines of deep imports at the top of one widget:**

```dart
import 'package:sport_manager_mobile/features/report/manager_detail/cubit/manager_report_detail_cubit.dart';
import 'package:sport_manager_mobile/features/report/utils/report_format.dart';
import 'package:sport_manager_mobile/features/report/widgets/report_kpi_card.dart';
```

**Good — single import via the feature barrel:**

```dart
import 'package:sport_manager_mobile/features/report/report.dart';
```

Within the same sub-feature folder direct imports are fine; reach for
the feature barrel when crossing sub-folders inside a feature.

---

## BlocBuilder rebuild scope

Wrap the **smallest** widget that depends on the state, not the whole
screen. `BlocBuilder` rebuilds its `builder` on every state change — if the
builder returns a full `Scaffold` or `ListView`, the entire tree gets rebuilt
even though only a label or a button needed to refresh.

**Bad — whole screen rebuilds on every state change:**

```dart
body: BlocBuilder<MyCubit, MyState>(
  builder: (_, state) => switch (state) {
    Loading => ListView(physics: ..., padding: ..., children: [Skeleton()]),
    Failure => ListView(physics: ..., padding: ..., children: [ErrorView(...)]),
    Success(:final data) => ListView(physics: ..., padding: ..., children: [_Content(data)]),
  },
),
```

Three almost-identical `ListView`s, three padding constants, three physics —
all duplicated. The whole list rebuilds when only the inner widget changes.

**Good — share the structure, scope the rebuild:**

```dart
body: BlocBuilder<MyCubit, MyState>(
  bloc: _cubit,
  builder: (_, state) => switch (state) {
    Loading() || Initial() => const MyLoadingView(),   // owns its own scrollable
    Failure() => MyErrorView(onRetry: _cubit.load),    // owns its own scrollable
    Success(:final data) => MyContent(data),           // owns its own scrollable
  },
),
```

Each leaf widget is responsible for its own `ListView` / `physics` /
`padding`. The view file stays declarative.

**For independent fields in a multi-field state**, use multiple narrow
`BlocBuilder`s with `buildWhen`:

```dart
// Independent rebuilds — only the part that changed re-renders.
BlocBuilder<CheckoutCubit, CheckoutState>(
  buildWhen: (a, b) => a.months != b.months,
  builder: (_, state) => Text('${state.months} months'),
)
```

Or `context.select<Cubit, T>(picker)` for one-off reads inside a deep tree.

### `Scaffold` / `ListView` / `RefreshIndicator` belong **outside** the builder

A view's structural scaffolding doesn't depend on cubit state — only its
leaves do. Keep the structure stable and wrap each dynamic leaf in its
own narrow `BlocBuilder`.

**Bad — `RefreshIndicator` and `ListView` rebuild on every emit:**

```dart
body: RefreshIndicator.adaptive(
  onRefresh: _cubit.load,
  child: BlocBuilder<MyCubit, MyState>(
    bloc: _cubit,
    builder: (_, state) {
      return ListView(
        children: [
          PeriodChips(value: state.filter.period, onChanged: ...),
          Padding(
            padding: ...,
            child: switch (state.detail) {
              Loading() => const _Skeleton(),
              Failure(:final e) => ErrorBodyWidget(e, onRetryPressed: _cubit.load),
              Success(:final data) => _Body(detail: data),
            },
          ),
        ],
      );
    },
  ),
),
```

Every emit reconstructs the whole `ListView` and its sliver geometry.
The chips' state didn't change but they still rebuild.

**Good — structure stays put, two narrow builders:**

```dart
body: RefreshIndicator.adaptive(
  onRefresh: _cubit.load,
  child: ListView(
    children: [
      BlocBuilder<MyCubit, MyState>(
        bloc: _cubit,
        buildWhen: (a, b) => a.filter.period != b.filter.period,
        builder: (_, state) => PeriodChips(
          value: state.filter.period,
          onChanged: _cubit.changePeriod,
        ),
      ),
      Padding(
        padding: ...,
        child: BlocBuilder<MyCubit, MyState>(
          bloc: _cubit,
          buildWhen: (a, b) => a.detail != b.detail,
          builder: (_, state) => switch (state.detail) {
            Loading() => const _Skeleton(),
            Failure(:final e) => ErrorBodyWidget(e, onRetryPressed: _cubit.load),
            Success(:final data) => _Body(detail: data),
          },
        ),
      ),
    ],
  ),
),
```

`buildWhen` makes each section opt-in to the state slice it depends on.

---

## Don't put complex logic inline in widget trees

A widget's `build()` method should be **declarative** — read like a tree, not
like an algorithm. If you find yourself computing flags, switching on enums,
or composing strings inside `builder:` callbacks, lift that work into:

- **A getter on the model** (`subscription.needsRenewal`,
  `subscription.alert`),
- **A computed property on the state class** (`state.totalAmount`,
  `state.isFormValid`),
- **A separate widget** that owns the conditional rendering.

**Bad — multi-step logic inline in a `builder:`:**

```dart
floatingActionButton: BlocBuilder<DetailCubit, DataState<Detail>>(
  builder: (_, state) {
    final detail = state.dataValue;
    if (detail == null) return const SizedBox.shrink();
    final s = detail.subscription;
    final showFab =
        s.status == SubscriptionStatus.expired ||
        s.status == SubscriptionStatus.grace ||
        (s.status == SubscriptionStatus.active && s.daysUntilExpiry <= 3);
    if (!showFab) return const SizedBox.shrink();
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.x4),
      child: AppButton(
        collapseOnScroll: true,
        onPressed: () => context.push(AppRoutes.subscriptionCheckout),
        child: Text(context.l10n.subscriptionContinueCta),
      ),
    );
  },
),
```

**Good — extract a widget, push the predicate onto the model:**

```dart
// On SubscriptionModel:
bool get needsRenewal =>
    status == SubscriptionStatus.expired ||
    status == SubscriptionStatus.grace ||
    (status == SubscriptionStatus.active && daysUntilExpiry <= 3);

// In view:
floatingActionButton: SubscriptionContinueFab(cubit: _cubit),

// SubscriptionContinueFab handles its own visibility + tap.
```

Apply the same rule to multi-branch `if/else` ladders that pick an icon, a
color, and a label: they belong in a small widget per variant or behind a
domain enum (`enum SubscriptionAlert { none, warning, grace, expired }`),
not inline in the parent's `build()`.

**Rule of thumb:** if a `builder:` has more than one local variable or one
`if`, refactor.

---

## Widgets and UI

### Reuse pre-built components

Before writing a new widget, check [ui-components.md](ui-components.md). Text
fields, password fields, banners, submit buttons, checkboxes, spinners, the
brand logo — these already exist and are themed. Reuse or extend them rather
than introducing parallel widgets that drift from the design system.

If a component is **feature-specific** (uses feature l10n keys, hardcodes
business data, or only one screen consumes it), put it in
`features/<name>/widgets/`, not `ui/components/`.

### Avoid `Container`

Prefer the lighter alternatives:

| Need            | Use            |
| --------------- | -------------- |
| Color only      | `ColoredBox`   |
| Size only       | `SizedBox`     |
| Decoration only | `DecoratedBox` |
| Padding only    | `Padding`      |
| Alignment only  | `Align`        |

```dart
// Bad
Container(height: 24, color: Colors.white)

// Good
ColoredBox(color: AppColors.darkBgSecondary, child: const SizedBox(height: 24))
```

### Theme system

The theme system is the single source of truth for colors, typography,
spacing, radii, and shadows. Read [theme-system.md](theme-system.md) before
adding new UI — it explains how to pick the right token, when to use
`context.colors` vs `context.appColors`, and how to add new ones.

The short rule: never inline a hex color or magic font size in a widget.
Always go through the theme.

```dart
// Bad
color: Colors.grey[300]
color: Color(0xFFD97706)
style: TextStyle(fontSize: 16, color: Colors.red)

// Good
color: context.colors.outline                 // ColorScheme token
color: context.appColors.success              // AppColorsExt token
style: context.textTheme.bodyMedium           // Material text role
style: context.appTextStyles.error.bodyMedium // pre-baked variant
```

### Extracting widgets

Don't use private methods to build widgets:

```dart
// Bad
Widget _buildSpotCard() { return ...; }

// Good — separate class in its own file
class SpotCard extends StatelessWidget { ... }
```

### View file size

Aim for **≤ 160 lines** in a screen file (`<name>_view.dart`). When they
grow past that, refactor before adding more:

1. Extract `_Body` / `_Skeleton` / `_ErrorView` private classes into
   their own files under `widgets/` (and re-export from the
   sub-feature barrel).
2. Move selection / event-handling logic into a mixin.
3. Promote inline computations to getters on the model or state.
4. The view should hold only the `Scaffold` + `AppBar` + the
   top-level body composition. No multi-branch `switch`es, no
   private classes longer than 30 lines.

### Shared typedefs

If a `typedef` is used across multiple files, hoist it into its own file:

```dart
// types.dart
typedef FromJson<T> = T Function(Map<String, dynamic>);
```

---

## Localization

- Keys are `camelCase`
- Parameterized strings use ARB placeholders: `{count}`, `{name}`
- Three languages: `en`, `ru`, `ky`
- After editing ARB files, run `flutter gen-l10n`
- Read keys via `context.l10n.keyName`

```dart
// app_en.arb
{
  "tableActive": "Active: {count} tables",
  "@tableActive": {
    "placeholders": { "count": { "type": "int" } }
  }
}

// In code
context.l10n.tableActive(activeCount)
```

---

## Code generation

- `.g.dart` files are committed
- After editing models run: `melos run run-build-runner`
- Generated files are excluded from analysis in `analysis_options.yaml`
- CI fails if `.g.dart` files are not committed
