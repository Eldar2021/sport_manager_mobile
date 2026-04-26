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

| Type           | Format                                  | Example                         |
| -------------- | --------------------------------------- | ------------------------------- |
| Interface      | `abstract interface class` + `I` prefix | `IVenueRemoteSource`            |
| Implementation | `Impl` suffix                           | `VenueRemoteSourceImpl`         |
| Model          | `Model` suffix                          | `SessionModel`, `VenueModel`    |
| Param / DTO    | `Param` or `Body` suffix                | `StartSessionParam`             |
| Cubit          | `Cubit` suffix                          | `VenuesCubit`, `SettingsCubit`  |
| State          | `State` suffix                          | `VenuesState`, `SettingsState`  |
| Repository     | `Repository` suffix                     | `SessionRepository`             |
| DI module      | `Module` suffix                         | `VenuesModule`, `NetworkModule` |

### Class keywords

```dart
// Immutable data classes
final class SessionModel extends Equatable { ... }

// Interfaces
abstract interface class IVenueRemoteSource { ... }

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
- Remote source — API calls via `ApiClient`
- Local source — persistence via `StorageInterfaceSyncRead`
- Interfaces declared as `abstract interface class`
- Implementations declared as `final class`

```dart
abstract interface class SessionRepository {
  Future<SessionModel> startSession(StartSessionParam param);
  Future<SessionModel> endSession(String sessionId);
}

final class SessionRepositoryImpl implements SessionRepository {
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
- Prefer `registerLazySingleton` for services
- `registerFactory` for Cubits (new instance per screen)
- For multiple instances of the same type, use `instanceName`
- Order matters: dependencies must be registered before their dependents

---

## Widgets and UI

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
Widget _buildTableCard() { return ...; }

// Good — separate class in its own file
class TableCard extends StatelessWidget { ... }
```

### View file size

Keep screen files under ~180 lines. When they grow:

1. Extract selection / handling logic into a mixin
2. Extract form fields into reusable widgets
3. The view should hold only the widget tree and minimal glue

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
