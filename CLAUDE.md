# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

# Sport Manager Mobile

Flutter monorepo. Dart ^3.11.5 · Flutter 3.41.7 (FVM) · Material 3 · Melos workspace.

Deep references: [docs/architecture.md](docs/architecture.md), [docs/code-rules.md](docs/code-rules.md), [docs/theme-system.md](docs/theme-system.md), [docs/contributing.md](docs/contributing.md). Read `theme-system.md` before writing any UI — it explains how to pick the right color / text / spacing token so the result adapts to light/dark.

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

**Features** — `features/<name>/cubits/`, `view/`, `widgets/`, `<name>.dart` (barrel export).

**State** — Cubit + sealed `DataState<T>` (`DataInitial / DataLoading / DataSuccess / DataFailure`) for single-field async, or `RequestStatus<T>` from `packages/core` inside a `copyWith`-style state class for multiple independent fields. States extend `Equatable`, are `@immutable`.

**Layers** — `Cubit → Repository → Remote / Local Source`. Sources declared as `abstract interface class` (no `I` prefix — `Impl` suffix on implementations is sufficient); implementations as `final class` with `Impl` suffix (or `Mock` for dev mocks). Repository is a single concrete `final class` — do NOT split it into interface + `Impl`; the variation point lives in the data sources.

**Models** — `@JsonSerializable() @immutable final class` extending `Equatable`. Suffixes: `Model` for entities, `Param` / `Body` for request DTOs.

**DI** — GetIt + `BaseDiModule`. Register modules in `app/lib/core/di/`. `registerLazySingleton` for services (repositories, sources, clients). Cubits are NOT registered in DI: single-page cubits (e.g. `LoginCubit`, `RegisterCubit`) live as `late final` fields in the page's `StatefulWidget`, instantiated in `initState` via `GetIt.I<XRepository>()`, passed to `BlocConsumer` via `bloc:`, and `close()`'d in `dispose()` — don't wrap in `BlocProvider`. App-/feature-level cubits (`AuthCubit`, `SettingsCubit`) use `BlocProvider` at the app root. Two Dio instances: `ApiClient.bearerInstance` (auth + refresh-token flow) and `ApiClient.noneAuthInstance` (public). When multiple instances of the same type are registered, use `instanceName` (e.g. `'snackbar'`, `'dialog'`, `'unauthenticated'` for `ErrorHandler`).

**Navigation** — GoRouter. Routes as `static const` on `AppRoutes`. Configure in `app_router.dart`.

**Localization** — ARB files in `app/lib/l10n/arb/` (`en`, `ru`, `ky`). Access via `context.l10n.<key>`. After changes: `flutter gen-l10n`. Keys are `camelCase`.

**Theme** — Warm dark: primary `#D97706` amber, success `#65A30D` olive, danger `#DC2626`. Use `AppColors.*`, `AppSpacing.*`, `AppTypography.*` — never hardcode colors or sizes.

**Widgets** — Prefer `ColoredBox` / `SizedBox` / `DecoratedBox` / `Padding` / `Align` over `Container`. No `_buildX()` private widget methods — extract to a `StatelessWidget` class in its own file. Keep view files ≤ ~180 lines; if larger, extract widgets or move logic to a mixin.

**Error handling** — throw `AppException<T>` (with `handleType: dialog | snackbar`). Localized messages via `BaseMessage(en, ru, ky)`. From widgets: `context.handleError(error)`. 401/423 are routed through `UnauthenticatedExceptionHandle` (registered with `instanceName: 'unauthenticated'`).

**Storage** — `StorageInterfaceSyncRead` (sync read, async write). All operations wrap failures in `StorageException`.

**Lints** — `very_good_analysis` v10.2.0; line length 120; `trailing_commas: preserve`; `**/*.g.dart` excluded from analysis.

**No comments** unless the reason is non-obvious.
