# Архитектура — Sport Manager Mobile

> Стек: Flutter · Dart · Material 3 · BLoC/Cubit · GoRouter · GetIt · Dio

---

## Структура монорепо

```
sport_manager_mobile/
├── pubspec.yaml              ← Melos workspace + общие зависимости
├── app/                      ← Flutter-приложение
│   └── lib/
│       ├── main.dart
│       ├── env.dart          ← BASE_URL через --dart-define
│       ├── app/              ← Корневой виджет + GoRouter
│       ├── core/             ← DI-модули, DataState, ErrorHandlers
│       ├── features/         ← Фичи (screen / cubit / state / widgets)
│       ├── ui/               ← Дизайн-система (theme, components)
│       └── l10n/             ← ARB-файлы + сгенерированные локализации
└── packages/
    ├── core/                 ← Базовые абстракции (exception, DI, analytics)
    ├── api_client/           ← HTTP-клиент на Dio
    └── storage_client/       ← Обёртка над SharedPreferences
```

---

## Диаграмма слоёв

```
┌──────────────────────────────────────────┐
│               app/lib/                   │
│  features/ ──► core/ ──► packages/*      │
└──────────────────────────────────────────┘
         │              │
  packages/        packages/        packages/
  api_client    storage_client         core
```

**Правило:** `features` зависит от `app/core`, `app/core` — от `packages/*`. Пакеты между собой не зависят, кроме `api_client` и `storage_client`, которые используют `packages/core`.

---

## Пакеты

### `packages/core`

Базовые абстракции без привязки к фреймворку.

| Модуль                               | Назначение                                   |
| ------------------------------------ | -------------------------------------------- |
| `di/di_module.dart`                  | `DIModule<T>` — контракт для DI-модулей      |
| `exception/model/app_exception.dart` | `AppException<T>` — базовый класс исключений |
| `exception/model/error_model.dart`   | `ErrorModel` + `BaseMessage` (en/ru/ky)      |
| `exception/handle/error_handle.dart` | `ErrorHandler` — абстрактный обработчик      |
| `request_status/request_status.dart` | `RequestStatus<T>` — sealed-класс состояний  |
| `analytics/`                         | Интерфейсы аналитики                         |
| `crashlytics/`                       | Интерфейсы крешлитики                        |
| `remote_config/`                     | Интерфейс RemoteConfig                       |

### `packages/api_client`

HTTP-клиент на Dio с типизированными методами.

| Файл                                   | Назначение                                                      |
| -------------------------------------- | --------------------------------------------------------------- |
| `clients/api_client.dart`              | Типизированные методы GET/POST/PUT/PATCH/DELETE                 |
| `request_executor/`                    | `RequestExecutor` (интерфейс) + `DioRequestExecutor`            |
| `interceptors/base_interceptor.dart`   | Добавляет `Accept-Language`, `versionBuild`, `os`               |
| `interceptors/bearer_interceptor.dart` | `Authorization: Bearer <token>`                                 |
| `interceptors/auth_interceptor.dart`   | `QueuedInterceptor` — refresh-token flow при 401                |
| `connectivity/`                        | `ConnectionService` + `ConnectivityBasedConnectionChecker`      |
| `exceptions/`                          | `ApiClientException`, `ConnectionException`, `ConvertException` |

### `packages/storage_client`

Обёртка над `SharedPreferences`.

| Файл                                             | Назначение                                        |
| ------------------------------------------------ | ------------------------------------------------- |
| `src/interface/storage_sync_read_interface.dart` | Синхронное чтение / асинхронная запись            |
| `src/preferences_storage.dart`                   | Реализация через `SharedPreferences`              |
| `src/secure_storage.dart`                        | Заготовка под `FlutterSecureStorage` (не активна) |

---

## Dependency Injection

GetIt + модульная регистрация через `BaseDiModule`.

```
DIModule<T>            ← packages/core
    └── BaseDiModule   ← app/core/di (поддержка GetIt scope)
            ├── CoreModule      → PreferencesStorage (lazySingleton)
            ├── ErrorModule     → ErrorHandler × 3 + UnauthenticatedHandle
            └── NetworkModule   → Dio × 2 + ConnectionService
```

**Два Dio-инстанса:**

| Имя                          | Интерсепторы         | Когда использовать        |
| ---------------------------- | -------------------- | ------------------------- |
| `ApiClient.bearerInstance`   | Base + Bearer + Auth | Авторизованные запросы    |
| `ApiClient.noneAuthInstance` | Base                 | Публичные запросы (логин) |

**Зарегистрированные зависимости:**

| Тип                              | instanceName                 | Режим                        |
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

## Навигация

GoRouter. Маршруты объявлены в `AppRoutes` как константы, конфигурация в `app_router.dart`.

---

## State Management

Cubit + sealed-классы для состояний.

**Структура фичи:**

```
features/<name>/
├── cubits/
│   ├── <name>_cubit.dart   ← логика, emit()
│   └── <name>_state.dart   ← Equatable, immutable, copyWith()
├── view/
│   └── <name>_screen.dart
└── widgets/
```

**`DataState<T>`** — sealed-класс для асинхронных данных в `app/core/state/`:

```
DataInitial<T>             ← до первого запроса
DataLoading<T>             ← идёт загрузка
DataSuccess<T>(data)       ← данные получены
DataFailure<T>(exception)  ← ошибка
```

**`RequestStatus<T>`** — аналог в `packages/core/request_status/`, дополнительно имеет `dataOrNull` через pattern matching.

---

## Обработка ошибок

```
AppException<T>                  ← packages/core (abstract)
    │  handleType: dialog | snackbar
    │
BaseErrorHandler                 ← app/core (диспетчер)
    ├── ErrorHandleSnackBar       → Snackbar с локализованным сообщением
    ├── ErrorHandleDialog         → showAdaptiveDialog
    └── UnauthenticatedExceptionHandle
            ├── 401 → "Сессия истекла" → навигация на логин
            └── 423 → "Аккаунт заблокирован"
```

`BaseMessage(en, ru, ky)` — i18n-контейнер для текстов ошибок. Используется как в `AppException`, так и в предустановленных константах (`BaseMessage.sessionExpired`, `BaseMessage.technical`, и др.).

Вызов из виджетов — через extension: `context.handleError(error)`.

---

## Хранилище

`StorageInterfaceSyncRead` — синхронное чтение, асинхронная запись. `PreferencesStorage` — реализация через `SharedPreferences`, все операции оборачиваются в `StorageException`.

**Ключи:**

| Ключ                  | Тип      | Назначение         |
| --------------------- | -------- | ------------------ |
| `settings_theme_mode` | `int`    | Индекс `ThemeMode` |
| `settings_locale`     | `String` | Код языка          |

---

## Дизайн-система

```
app/lib/ui/theme/
├── app_colors.dart      ← AppColors (константы)
├── app_spacing.dart     ← AppSpacing (x1–x16), AppRadius, AppShadow
├── app_typography.dart  ← AppTypography (Inter + tabular-nums)
├── app_theme.dart       ← AppTheme.dark / AppTheme.light (Material 3)
└── theme.dart           ← barrel export
```

Текущая тема — **Warm Dark**: primary `#D97706` (amber), success `#65A30D` (olive), danger `#DC2626` (red), нейтралы Stone, фон `#0F0D0B`.

---

## Локализация

ARB-файлы в `app/lib/l10n/arb/` → авто-генерация через `flutter gen-l10n`. Три языка: `en`, `ru`, `ky`. Доступ в виджетах: `context.l10n.<key>`.

---

## Конфигурация окружения

`BASE_URL` передаётся через `--dart-define=BASE_URL=...` при сборке. Читается через `Env.baseUrl`.
