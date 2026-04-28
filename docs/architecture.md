# Architecture — Sport Manager Mobile

> Stack: Flutter · Dart · Material 3 · BLoC/Cubit · GoRouter · GetIt · Dio

---

## Monorepo layout

```
sport_manager_mobile/
├── pubspec.yaml              ← Melos workspace + shared dependencies
├── app/                      ← Flutter application
│   └── lib/
│       ├── main.dart
│       ├── env.dart          ← BASE_URL via --dart-define
│       ├── app/              ← Root widget + GoRouter
│       ├── core/             ← DI modules, DataState, ErrorHandlers
│       ├── features/         ← Features (views / cubits / widgets)
│          auth/
│          home/
│
│       ├── ui/               ← Design system (theme, components)
│       └── l10n/             ← ARB files + generated localizations
└── packages/
    ├── core/                 ← Base abstractions (exception, DI, analytics)
    ├── api_client/           ← Dio HTTP client
    ├── storage_client/       ← SharedPreferences wrapper
    ├── auth/                 ← Auth data layer (models, sources, repository)
    └── facility/             ← Facility data layer — venues, tables, sessions (models, sources, repositories)

```

---

## Layering

```
┌──────────────────────────────────────────┐
│               app/lib/                   │
│  features/ ──► core/ ──► packages/*      │
└──────────────────────────────────────────┘
         │              │
  packages/        packages/        packages/
  api_client    storage_client         core
```

**Rule:** `features` depends on `app/core`; `app/core` depends on `packages/*`. Packages don't depend on each other, with two exceptions:

- `api_client` and `storage_client` depend on `packages/core`
- `auth` depends on `packages/core`, `packages/api_client`, and `packages/storage_client`

---

## Packages

### `packages/core`

Framework-agnostic base abstractions.

| Module                               | Purpose                                  |
| ------------------------------------ | ---------------------------------------- |
| `di/di_module.dart`                  | `DIModule<T>` — contract for DI modules  |
| `exception/model/app_exception.dart` | `AppException<T>` — base exception class |
| `exception/model/error_model.dart`   | `ErrorModel` + `BaseMessage` (en/ru/ky)  |
| `exception/handle/error_handle.dart` | `ErrorHandler` — abstract handler        |
| `request_status/request_status.dart` | `RequestStatus<T>` — sealed state class  |
| `analytics/`                         | Analytics interfaces                     |
| `crashlytics/`                       | Crashlytics interfaces                   |
| `remote_config/`                     | RemoteConfig interface                   |

### `packages/api_client`

Dio HTTP client with typed methods.

| File                                   | Purpose                                                         |
| -------------------------------------- | --------------------------------------------------------------- |
| `clients/api_client.dart`              | Typed GET/POST/PUT/PATCH/DELETE methods                         |
| `request_executor/`                    | `RequestExecutor` interface + `DioRequestExecutor`              |
| `interceptors/base_interceptor.dart`   | Adds `Accept-Language`, `versionBuild`, `os`                    |
| `interceptors/bearer_interceptor.dart` | `Authorization: Bearer <token>`                                 |
| `interceptors/auth_interceptor.dart`   | `QueuedInterceptor` — refresh-token flow on 401                 |
| `connectivity/`                        | `ConnectionService` + `ConnectivityBasedConnectionChecker`      |
| `exceptions/`                          | `ApiClientException`, `ConnectionException`, `ConvertException` |

### `packages/storage_client`

Wrapper around `SharedPreferences`.

| File                                             | Purpose                                            |
| ------------------------------------------------ | -------------------------------------------------- |
| `src/interface/storage_sync_read_interface.dart` | Sync read / async write                            |
| `src/preferences_storage.dart`                   | `SharedPreferences` implementation                 |
| `src/secure_storage.dart`                        | `FlutterSecureStorage` placeholder (not yet wired) |

### `packages/auth`

Auth data layer — owns everything between the auth API and the rest of the app.

**When to look here:**

- Adding/changing an auth endpoint (login, register, refresh, forgot-password, invite-code)
- Touching auth tokens (access/refresh) — storage, refresh flow, sync access from interceptors
- Changing the cached user (`UserModel`) shape, role enum, or invite-code model
- Adding a new role / changing what `RegisterParam` carries
- Tweaking the dev mock (`AuthRemoteSourceMock`) — test credentials, invite code, fake users

**What it contains:**

| Path                                        | Purpose                                                    |
| ------------------------------------------- | ---------------------------------------------------------- |
| `lib/auth.dart`                             | Public barrel — only interfaces + DTOs, no impls           |
| `exception/auth_error_code.dart`            | `AuthErrorCode` enum (invalidCredentials, sessionExpired…) |
| `exception/auth_exception.dart`             | `AuthException extends AppException<AuthErrorCode>`        |
| `models/user_model.dart` + `user_role.dart` | Cached user + `UserRole.{owner,manager}` enum              |
| `models/auth_tokens_model.dart`             | Access + refresh token pair                                |
| `models/auth_result_model.dart`             | Login/register response (user + tokens)                    |
| `models/invite_code_model.dart`             | Manager invite code + expiry                               |
| `models/register_param.dart`                | Sealed `RegisterParam` (Owner / Manager subclasses)        |
| `repository/auth_repository.dart`           | Concrete `final class AuthRepository` — single class       |
| `source/local/`                             | `AuthLocalSource` interface + `Impl` (secure + prefs)      |
| `source/remote/`                            | `AuthRemoteSource` interface + `Impl` + `Mock`             |

**Key contracts:**

- `AuthLocalSource.init()` is awaited during DI bootstrap to warm the sync token
  cache before any authenticated request fires (the bearer interceptor reads sync).
- `AuthRepository` only orchestrates; it has no interface (sources are abstract).
- `AuthRepository.logout()` clears local state first, then attempts remote logout
  best-effort (failure is logged and swallowed).
- The bearer/auth interceptors in `NetworkModule` consume `AuthLocalSource`
  directly for sync token reads; they only call the repository for `logout()`.
- The barrel does NOT export `*_impl.dart` / `*_mock.dart` — the DI module
  imports those via direct paths.

**Mock dev mode:** when `Env.isMock` is true, `AuthRemoteSourceMock` is wired in.
See the file's header comment for test credentials (owner: `test/Test1234`,
manager: `manager/Test1234`, invite code `INVITE-001`).

---

## Dependency injection

GetIt + modular registration via `BaseDiModule`.

```
DIModule<T>            ← packages/core
    └── BaseDiModule   ← app/core/di (GetIt scope support)
            ├── CoreModule      → PreferencesStorage (lazySingleton)
            ├── ErrorModule     → ErrorHandler × 3 + UnauthenticatedHandle
            └── NetworkModule   → Dio × 2 + ConnectionService
```

**Two Dio instances:**

| Name                         | Interceptors         | When to use             |
| ---------------------------- | -------------------- | ----------------------- |
| `ApiClient.bearerInstance`   | Base + Bearer + Auth | Authenticated requests  |
| `ApiClient.noneAuthInstance` | Base                 | Public requests (login) |

**Registered dependencies:**

| Type                             | instanceName                 | Mode                         |
| -------------------------------- | ---------------------------- | ---------------------------- |
| `PreferencesStorage`             | —                            | lazySingleton                |
| `ErrorHandler`                   | —                            | singleton (BaseErrorHandler) |
| `ErrorHandler`                   | `'snackbar'`                 | singleton                    |
| `ErrorHandler`                   | `'dialog'`                   | singleton                    |
| `UnauthenticatedExceptionHandle` | `'unauthenticated'`          | singleton                    |
| `Dio`                            | `ApiClient.noneAuthInstance` | singleton                    |
| `Dio`                            | `ApiClient.bearerInstance`   | singleton                    |
| `ConnectionService`              | —                            | singleton                    |

---

## Navigation

GoRouter. Routes are declared as constants on `AppRoutes`; configuration lives in `app_router.dart`.

---

## State management

Cubit + sealed state classes.

**Feature layout:**

```
features/<name>/
├── cubits/
│   ├── <name>_cubit.dart   ← logic, emit()
│   └── <name>_state.dart   ← Equatable, immutable, copyWith()
├── view/
│   └── <name>_screen.dart
└── widgets/
```

**`DataState<T>`** — sealed class for async data, in `app/core/state/`:

```
DataInitial<T>             ← before first request
DataLoading<T>             ← in flight
DataSuccess<T>(data)       ← loaded
DataFailure<T>(exception)  ← failed
```

**`RequestStatus<T>`** — analogue in `packages/core/request_status/`. Adds `dataOrNull` via pattern matching.

---

## Error handling

```
AppException<T>                  ← packages/core (abstract)
    │  handleType: dialog | snackbar
    │
BaseErrorHandler                 ← app/core (dispatcher)
    ├── ErrorHandleSnackBar       → Snackbar with localized message
    ├── ErrorHandleDialog         → showAdaptiveDialog
    └── UnauthenticatedExceptionHandle
            ├── 401 → "Session expired" → navigate to login
            └── 423 → "Account locked"
```

`BaseMessage(en, ru, ky)` — i18n container for error copy. Used in `AppException` and in pre-built constants (`BaseMessage.sessionExpired`, `BaseMessage.technical`, etc).

From widgets: `context.handleError(error)`.

---

## Storage

`StorageInterfaceSyncRead` — sync read, async write. `PreferencesStorage` is the `SharedPreferences` implementation; every operation wraps failures in `StorageException`.

**Keys:**

| Key                   | Type     | Purpose           |
| --------------------- | -------- | ----------------- |
| `settings_theme_mode` | `int`    | `ThemeMode` index |
| `settings_locale`     | `String` | Language code     |

---

## Design system

```
app/lib/ui/theme/
├── app_theme.dart                ← AppTheme.light / AppTheme.dark assembly
├── theme.dart                    ← barrel export
├── colors/                       ← AppColors / AppColorSchemes / AppColorsExt
├── components/                   ← per-widget theme builders
├── extension/                    ← BuildContext extensions
├── foundations/                  ← AppSpacing / AppRadius / AppShadow
└── typography/                   ← AppTextTheme / AppTextThemeExt
```

Current theme — **Warm Dark**: primary `#D97706` (amber), success `#65A30D` (olive), danger `#DC2626` (red), Stone neutrals, dark background `#0F0D0B`.

For the full theme contract (which token to use where, when to reach for `AppColorsExt` vs `ColorScheme`, how to extend it), read [theme-system.md](theme-system.md). For the catalog of pre-built widgets that consume those tokens (text fields, banners, submit buttons, spinners, …), read [ui-components.md](ui-components.md) — check it before introducing a new widget.

---

## Localization

ARB files in `app/lib/l10n/arb/` → auto-generated via `flutter gen-l10n`. Three languages: `en`, `ru`, `ky`. Read via `context.l10n.<key>`.

---

## Environment configuration

`BASE_URL` is passed via `--dart-define=BASE_URL=...` at build time and read through `Env.baseUrl`.
