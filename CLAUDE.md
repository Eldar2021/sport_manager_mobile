# Sport Manager Mobile

Flutter monorepo. Dart ^3.11.5 · Flutter 3.41.7 (FVM) · Material 3.

## Structure

```
app/lib/
  features/   # screen / cubit / state / widgets
  core/       # DI modules, DataState, error handling
  ui/         # AppTheme, AppColors, AppTypography, AppSpacing
  l10n/       # ARB files + generated localizations
packages/
  api_client/     # Dio HTTP client
  storage_client/ # SharedPreferences wrapper
  core/           # AppException, RequestStatus, DIModule contract
```

## Commands

```bash
melos bootstrap       # install + link packages
make build-runner     # code generation (.g.dart)
flutter gen-l10n      # regenerate localization (after editing arb/)
make pod-install      # iOS pods
melos run format      # dart format --line-length 120
melos run analyze     # flutter analyze
melos run unit-test   # all tests
```

Run app: `cd app && flutter run --dart-define=BASE_URL=https://...`

## Conventions

**Features** — `features/<name>/cubits/`, `view/`, `widgets/`, `<name>.dart` (barrel export).

**State** — Cubit + `DataState<T>` sealed class (`DataInitial / DataLoading / DataSuccess / DataFailure`). States extend `Equatable`, are `@immutable`, have `copyWith`.

**Models** — `@JsonSerializable()` + `@immutable` + `Equatable`. After changes: `make build-runner`.

**DI** — GetIt + `BaseDiModule`. New modules registered in `app/lib/core/di/`. Two Dio instances: `ApiClient.bearerInstance` (auth) and `ApiClient.noneAuthInstance` (public).

**Navigation** — GoRouter. Routes as constants in `AppRoutes`. New routes added in `app_router.dart`.

**Localization** — ARB files in `app/lib/l10n/arb/` (en/ru/ky). Access via `context.l10n.<key>`. After changes: `flutter gen-l10n`.

**Theme** — Warm dark: primary `#D97706` amber, success `#65A30D` olive, danger `#DC2626`. Use `AppColors.*`, `AppSpacing.*`, `AppTypography.*`. Never hardcode colors or sizes.

**Error handling** — throw `AppException<T>`. In widgets: `context.handleError(error)`.

**Line length** — 120 characters.

**No comments** unless the reason is non-obvious.
