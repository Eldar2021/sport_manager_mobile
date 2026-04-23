# Code Rules

Правила и стандарты кода для проекта Sport Manager Mobile.

## Общие правила

- **Линтер:** `very_good_analysis` v10.2.0
- **Длина строки:** 120 символов
- **Форматтер:** `dart format . --line-length 120`
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

## Именование

### Файлы

- Формат: `snake_case.dart`
- Примеры: `venues_cubit.dart`, `session_model.dart`, `table_card.dart`

### Классы

| Тип | Формат | Пример |
|---|---|---|
| Интерфейс | `abstract interface class` + `I` префикс | `IVenueRemoteSource` |
| Реализация | суффикс `Impl` | `VenueRemoteSourceImpl` |
| Модель | суффикс `Model` | `SessionModel`, `VenueModel` |
| Параметр/DTO | суффикс `Param` или `Body` | `StartSessionParam` |
| Cubit | суффикс `Cubit` | `VenuesCubit`, `SettingsCubit` |
| State | суффикс `State` | `VenuesState`, `SettingsState` |
| Repository | суффикс `Repository` | `SessionRepository` |
| DI-модуль | суффикс `Module` | `VenuesModule`, `NetworkModule` |

### Ключевые слова классов

```dart
// Неизменяемые data-классы
final class SessionModel extends Equatable { ... }

// Интерфейсы
abstract interface class IVenueRemoteSource { ... }

// Абстрактные базы
abstract class BaseDiModule extends DIModule<GetIt> { ... }

// Sealed-состояния
sealed class AuthState extends Equatable { ... }
final class AuthSuccess extends AuthState { ... }
```

### Переменные и методы

- `camelCase` — `accessToken`, `sessionModel`
- Приватные члены — `_` префикс: `_storage`, `_client`
- Константы — `camelCase`, не `SCREAMING_SNAKE`: `static const bearerInstance`
- Методы — `camelCase`: `loadVenues()`, `startSession()`

---

## Порядок импортов

```dart
// 1. Dart SDK
import 'dart:async';
import 'dart:io';

// 2. Flutter SDK
import 'package:flutter/material.dart';

// 3. Внешние пакеты
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';

// 4. Внутренние пакеты монорепо
import 'package:core/core.dart';
import 'package:api_client/api_client.dart';
import 'package:storage_client/storage_client.dart';

// 5. Относительные импорты
import '../widgets/table_card.dart';
```

---

## State Management

### Cubit vs Bloc

- **Cubit** — предпочтителен: простые переходы состояний, формы, toggles
- **Bloc** — для сложной event-based логики

### Состояния: два подхода

**Sealed-класс** — для взаимоисключающих состояний:

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

**Single state + copyWith** — для нескольких независимых полей:

```dart
final class VenuesState extends Equatable {
  const VenuesState({
    this.venues = const RequestInitial(),
    this.tables = const RequestInitial(),
  });

  final RequestStatus<List<VenueModel>> venues;
  final RequestStatus<List<TableModel>> tables;

  VenuesState copyWith({
    RequestStatus<List<VenueModel>>? venues,
    RequestStatus<List<TableModel>>? tables,
  }) => VenuesState(
    venues: venues ?? this.venues,
    tables: tables ?? this.tables,
  );

  @override
  List<Object?> get props => [venues, tables];
}
```

### Асинхронные операции

Всегда используем паттерн `RequestStatus` или `DataState`:

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

## Модели

- Аннотация `@JsonSerializable()` + `@immutable`
- Расширяют `Equatable`
- Обязательно: `fromJson`, `toJson`
- `copyWith` — по необходимости

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

### Enum-сериализация

```dart
@JsonEnum()
enum SessionStatus {
  @JsonValue('ACTIVE') active,
  @JsonValue('CLOSED') closed,
}
```

---

## Repository

### Слои

```
Cubit → Repository → Remote Source / Local Source
```

- Repository содержит бизнес-логику и оркестрирует источники данных
- Remote source — вызовы API через `ApiClient`
- Local source — работа с `StorageInterfaceSyncRead`
- Интерфейсы через `abstract interface class`
- Реализации через `final class`

```dart
abstract interface class ISessionRepository {
  Future<SessionModel> startSession(StartSessionParam param);
  Future<SessionModel> endSession(String sessionId);
}

final class SessionRepositoryImpl implements ISessionRepository {
  const SessionRepositoryImpl(this._remote);
  final ISessionRemoteSource _remote;

  @override
  Future<SessionModel> startSession(StartSessionParam param) =>
      _remote.startSession(param);

  @override
  Future<SessionModel> endSession(String sessionId) =>
      _remote.endSession(sessionId);
}
```

---

## Навигация

- Маршруты — `static const` в `AppRoutes`
- Навигация через GoRouter: `context.push()`, `context.go()`, `context.pop()`
- Передача аргументов через `extra` параметр GoRouter или `queryParameters`

```dart
abstract final class AppRoutes {
  static const home = '/';
  static const settings = '/settings';
  static const venues = '/venues';
}
```

---

## DI

- Каждый модуль расширяет `BaseDiModule`
- Предпочтительно `registerLazySingleton` для сервисов
- `registerFactory` для Cubit-ов (новый инстанс на каждый экран)
- При нескольких инстансах одного типа — `instanceName`
- Порядок регистрации важен: зависимости регистрируются раньше того, что от них зависит

---

## Виджеты и UI

### Вместо `Container`

Используй более лёгкие альтернативы:

| Нужно | Использовать |
|---|---|
| Только цвет | `ColoredBox` |
| Только размер | `SizedBox` |
| Только декорация | `DecoratedBox` |
| Только отступ | `Padding` |
| Только выравнивание | `Align` |

```dart
// Плохо
Container(height: 24, color: Colors.white)

// Хорошо
ColoredBox(color: AppColors.darkBgSecondary, child: const SizedBox(height: 24))
```

### Цвета

Никогда не хардкодить цвета. Всегда использовать дизайн-систему:

```dart
// Плохо
color: Colors.grey[300]
color: Color(0xFFD97706)

// Хорошо
color: AppColors.brandAmber
color: AppColors.ink300
color: Theme.of(context).colorScheme.primary
```

### Извлечение виджетов

Не использовать приватные методы для построения виджетов:

```dart
// Плохо
Widget _buildTableCard() { return ...; }

// Хорошо — отдельный класс в своём файле
class TableCard extends StatelessWidget { ... }
```

### Размер view-файлов

Держать файлы экранов до ~180 строк. При росте:

1. Извлечь логику выбора/обработки в mixin
2. Извлечь поля формы в переиспользуемые виджеты
3. View должен содержать только дерево виджетов и минимальный glue-код

### Типизированные typedef

Если `typedef` используется в нескольких файлах — выносить в отдельный файл:

```dart
// types.dart
typedef FromJson<T> = T Function(Map<String, dynamic>);
```

---

## Локализация

- Ключи в `camelCase`
- Параметризованные строки используют плейсхолдеры ARB-формата: `{count}`, `{name}`
- 3 языка: `en`, `ru`, `ky`
- После изменения ARB-файлов запустить `flutter gen-l10n`
- Использование: `context.l10n.keyName`

```dart
// app_en.arb
{
  "tableActive": "Active: {count} tables",
  "@tableActive": {
    "placeholders": { "count": { "type": "int" } }
  }
}

// В коде
context.l10n.tableActive(activeCount)
```

---

## Кодогенерация

- `.g.dart` файлы коммитятся в репозиторий
- После изменений запускать: `melos run run-build-runner`
- Сгенерированные файлы исключены из анализа в `analysis_options.yaml`
- CI падает, если `.g.dart` файлы не закоммичены
