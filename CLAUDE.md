# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

# Sport Manager Mobile

Flutter monorepo. Dart ^3.11.5 · Flutter 3.41.7 (FVM) · Material 3 · Melos workspace.

Deep references: [docs/architecture.md](docs/architecture.md), [docs/code-rules.md](docs/code-rules.md), [docs/error-handling.md](docs/error-handling.md), [docs/theme-system.md](docs/theme-system.md), [docs/ui-components.md](docs/ui-components.md), [docs/contributing.md](docs/contributing.md). Read `theme-system.md` before writing any UI — it explains how to pick the right color / text / spacing token so the result adapts to light/dark. Read `ui-components.md` before adding a new widget — most "obvious" widgets (text field, password field, banner, submit button, spinner, checkbox, logo) already exist; reuse before re-implementing. Read `error-handling.md` before touching exceptions, error codes, or a remote source — it's the canonical reference for the `ApiClientException → XxxExc` pipeline, the `.mapTo` extension, and the one-exception-per-package rule.

## Structure

```
app/lib/
  app/        # root widget + GoRouter
  core/       # DI modules, DataState, error handling
  features/   # <name>/cubits, view, widgets, <name>.dart (barrel)
  ui/         # AppTheme, AppColors, AppTypography, AppSpacing
  l10n/       # ARB files + generated localizations
  env.dart    # BASE_URL via --dart-define
packages/
  core/           # AppException, RequestStatus, DIModule contract, analytics/crashlytics/remote_config interfaces
  api_client/     # Dio HTTP client, interceptors, ConnectionService
  storage_client/ # SharedPreferences wrapper (sync read / async write)
  auth/           # auth data layer — models, sources, AuthRepository (see docs/architecture.md)
```

Layering: `features → app/core → packages/*`. Packages do not depend on each other except: `api_client`/`storage_client` depend on `packages/core`; `auth` depends on `core`, `api_client`, and `storage_client`.

## Commands

```bash
melos bootstrap              # install + link packages
make build-runner            # melos run run-build-runner (regenerates .g.dart, formats)
make gen-splash              # melos run gen-splash (regenerates native splash from app/flutter_native_splash.yaml)
flutter gen-l10n             # regenerate localization (after editing arb/)
make pod-install             # iOS pods (clean reinstall)
melos run format             # dart format --line-length 120
melos run analyze            # flutter analyze
melos run analyze-check      # analyze --fatal-warnings (CI parity)
melos run format-check       # format --set-exit-if-changed
melos run unit-test          # all tests
melos run test               # tests for one package (interactive picker)
```

Run app: `cd app && flutter run --dart-define=BASE_URL=https://...` (required — `Env.baseUrl` reads it).

`.g.dart` files are committed to the repo. After editing any `@JsonSerializable()` model run `make build-runner` and commit the regenerated files; CI fails otherwise.

## Conventions

**Features** — `features/<name>/cubit/`, `view/`, `widgets/`, `<name>.dart` (barrel export). When a feature has multiple sub-screens, **each gets its own nested folder** with `cubit/view/widgets/<sub>.dart` (see `features/auth/` for the canonical layout). Don't dump every cubit in one `cubit/` folder. Cross-sub-screen widgets live at `features/<name>/widgets/`; truly cross-feature widgets in `ui/components/`. Full convention: [docs/code-rules.md § Feature folder structure](docs/code-rules.md#feature-folder-structure).

**Barrels are exhaustive** — feature and sub-feature barrels re-export **every** public file in their tree (cubits, views, widgets, utils). Consumers import the feature barrel, not deep paths: `import 'package:sport_manager_mobile/features/report/report.dart'` — never a 5-line stack of inner imports. Full guide: [docs/code-rules.md § Barrels are exhaustive](docs/code-rules.md#barrels-are-exhaustive).

**State** — Cubit + sealed `DataState<T>` (`DataInitial / DataLoading / DataSuccess / DataFailure`) for single-field async, or `RequestStatus<T>` from `packages/core` inside a `copyWith`-style state class for multiple independent fields. States extend `Equatable`, are `@immutable`.

**Layers** — `Cubit → Repository → Remote / Local Source`. Sources declared as `abstract interface class` (no `I` prefix — `Impl` suffix on implementations is sufficient); implementations as `final class` with `Impl` suffix (or `Mock` for dev mocks). Repository is a single concrete `final class` — do NOT split it into interface + `Impl`; the variation point lives in the data sources.

**Models** — `@JsonSerializable() @immutable final class` extending `Equatable`. Suffixes: `Model` for entities, `Param` / `Body` for request DTOs.

**DI** — GetIt + `BaseDiModule`. Register modules in `app/lib/core/di/`. `registerLazySingleton` for services (repositories, sources, clients). Cubits are NOT registered in DI: single-page cubits (e.g. `LoginCubit`, `RegisterCubit`) live as `late final` fields in the page's `StatefulWidget`, instantiated in `initState` via `GetIt.I<XRepository>()`, passed to `BlocConsumer` via `bloc:`, and `close()`'d in `dispose()` — don't wrap in `BlocProvider`. App-/feature-level cubits (`AuthCubit`, `SettingsCubit`) use `BlocProvider` at the app root. Two Dio instances: `ApiClient.bearerInstance` (auth + refresh-token flow) and `ApiClient.noneAuthInstance` (public). When multiple instances of the same type are registered, use `instanceName` (e.g. `'snackbar'`, `'dialog'`, `'unauthenticated'` for `ErrorHandler`).

**Navigation** — GoRouter. Routes as `static const` on `AppRoutes`. Configure in `app_router.dart`.

**Localization** — ARB files in `app/lib/l10n/arb/` (`en`, `ru`, `ky`). Access via `context.l10n.<key>`. After changes: `flutter gen-l10n`. Keys are `camelCase`.

**Theme** — Warm dark: primary `#D97706` amber, success `#65A30D` olive, danger `#DC2626`. Use `AppColors.*`, `AppSpacing.*`, `AppTypography.*` — never hardcode colors or sizes.

**Widgets** — Prefer `ColoredBox` / `SizedBox` / `DecoratedBox` / `Padding` / `Align` over `Container`. No `_buildX()` private widget methods — extract to a `StatelessWidget` class in its own file. Keep view files ≤ **160 lines**; if larger, extract `_Body`/`_Skeleton`/etc into their own widget files under `widgets/`. Prefer Material widgets (`ListTile`, `Chip`, `Card`, …) over hand-rolled equivalents.

**BlocBuilder rebuild scope** — wrap the **smallest** widget that depends on the state, not the whole `Scaffold` / `ListView` / `RefreshIndicator`. Structural scaffolding stays outside the builder; each dynamic leaf gets its own narrow `BlocBuilder` with `buildWhen`. Don't duplicate scaffolding across switch branches (one `ListView` per state branch is a smell — share the structure, push scrollables into the leaf widget). Full guide: [docs/code-rules.md § BlocBuilder rebuild scope](docs/code-rules.md#blocbuilder-rebuild-scope).

**Constructor & formatting micro-rules** — Single-domain-param widgets use a **positional** parameter (`const FraudFlagList(this.flags, {super.key})`), not a single-element named bag. With 2+ args, place each on its own line **with a trailing comma** so diffs stay narrow when args are added or reordered. Full guide: [docs/code-rules.md § Constructor parameter style](docs/code-rules.md#constructor-parameter-style).

**Logic in widgets** — `build()` should read declaratively. Don't compute flags, switch on enums, or compose multi-line strings inside `builder:` callbacks. Lift to: a getter on the model (`subscription.needsRenewal`), a computed property on the state, or a small dedicated widget. Rule of thumb: if a `builder:` has more than one local variable or one `if`, refactor. Full guide: [docs/code-rules.md § Don't put complex logic inline in widget trees](docs/code-rules.md#dont-put-complex-logic-inline-in-widget-trees).

**Error handling** — every package defines **one** `XxxExc extends AppException<XxxErrorCode>` (suffix `Exc`, not `Exception`) covering every backend code its endpoints can return. Remote-source methods end each call with `.mapTo(XxxExc.fromApiClientExc)` — no try/catch in source bodies. Cubits switch on `e.error` (the enum), never on subtype. `handleType: dialog | snackbar` on the exception, localized messages via `BaseMessage(en, ru, ky)`, `context.handleError(error)` from widgets, 401/423 via `UnauthenticatedExceptionHandle` (`instanceName: 'unauthenticated'`). Full pipeline + template in [docs/error-handling.md](docs/error-handling.md).

**Storage** — `StorageInterfaceSyncRead` (sync read, async write). All operations wrap failures in `StorageException`.

**Lints** — `very_good_analysis` v10.2.0; line length 120; `trailing_commas: preserve`; `**/*.g.dart` excluded from analysis.

**No comments** unless the reason is non-obvious.
