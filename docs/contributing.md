# Contributing Guide

This document is a step-by-step guide for developers and AI agents who want to contribute to the project.

## Prerequisites

- **Dart SDK:** ^3.11.5
- **Flutter:** 3.41.7 (managed via [FVM](https://fvm.app/))
- **Melos:** `dart pub global activate melos`
- **Xcode:** >=16.3 (for iOS development)
- **CocoaPods:** For iOS dependencies

## Initial Setup

```bash
# 1. Set the Flutter version with FVM
fvm use 3.41.7

# 2. Install dependencies and link packages
melos bootstrap

# 3. Run code generation
make build-runner

# 4. (iOS) Install pods
make pod-install
```

## Development Workflow

### 1. Create a Branch

```bash
# Ticket-based branch
git checkout -b TICKET-XXX

# Or descriptive name
git checkout -b el/feature-description
```

### 2. Run the App

```bash
cd app && flutter run --dart-define=BASE_URL=https://api.example.com
```

If you use VS Code, pre-configured launch configurations are available in `.vscode/launch.json`.

### 3. Write Code

#### Adding a New Feature

Create a new directory under `app/lib/features/`:

```
features/my_feature/
├── cubits/
│   ├── my_feature_cubit.dart
│   └── my_feature_state.dart
├── screens/
│   └── my_feature_screen.dart
├── widgets/
│   └── my_feature_widget.dart
└── my_feature.dart           # Export file
```

If needed, create a new package under `packages/`:

```
packages/my_package/
├── lib/
│   ├── src/
│   │   ├── models/
│   │   ├── source/
│   │   └── repositories/
│   └── my_package.dart       # Public export
├── test/
└── pubspec.yaml
```

Then add the new package to the root `pubspec.yaml` workspace:

```yaml
workspace:
  - packages/my_package
```

#### Adding a New Model

```dart
import 'package:json_annotation/json_annotation.dart';
import 'package:equatable/equatable.dart';

part 'my_model.g.dart';

@JsonSerializable()
@immutable
class MyModel extends Equatable {
  const MyModel({required this.id, this.name});

  factory MyModel.fromJson(Map<String, dynamic> json) => _$MyModelFromJson(json);

  final String id;
  final String? name;

  Map<String, dynamic> toJson() => _$MyModelToJson(this);

  @override
  List<Object?> get props => [id, name];
}
```

After adding a model: `make build-runner`

#### Adding a New API Endpoint

1. Define the method in the remote source:

   ```dart
   abstract interface class MyRemoteSource {
     Future<MyModel> fetchData(String id);
   }

   final class MyRemoteSourceImpl implements MyRemoteSource {
     const MyRemoteSourceImpl(this._client);
     final ApiClient _client;

     @override
     Future<MyModel> fetchData(String id) => _client.getType<MyModel>(
       '/my-service/api/v1/data/$id',
       fromJson: MyModel.fromJson,
     );
   }
   ```

2. Orchestrate in the repository:

   ```dart
   final class MyRepository {
     const MyRepository({required this.remote});
     final IMyRemoteSource remote;

     Future<MyModel> fetchData(String id) => remote.fetchData(id);
   }
   ```

3. Register in the DI module:
   ```dart
   final class MyModule extends BaseDiModule {
     @override
     Future<void> register(GetIt sl) async {
       sl.registerLazySingleton<IMyRemoteSource>(
         () => MyRemoteSourceImpl(sl(instanceName: ApiClient.bearerInstance)),
       );
       sl.registerLazySingleton(() => MyRepository(remote: sl()));
     }
   }
   ```

#### Adding a New Route

1. Define the constant in `AppRoutes`:

   ```dart
   static const myFeature = '/my-feature';
   ```

2. Add the route in `app_router.dart`:
   ```dart
   GoRoute(
     path: AppRoutes.myFeature,
     builder: (_, __) => const MyFeatureScreen(),
   ),
   ```

#### Adding a New Translation

1. Add the key to ARB files under `app/lib/l10n/arb/`:

   ```arb
   // app_en.arb
   { "myNewKey": "My new text" }
   // app_ru.arb
   { "myNewKey": "Мой новый текст" }
   // app_ky.arb
   { "myNewKey": "Менин жаңы текстим" }
   ```

2. Generate the files: `flutter gen-l10n`

3. Use in code: `context.l10n.myNewKey`

### 4. Code Generation

If you made changes to models:

```bash
make build-runner
```

### 5. Write Tests

Tests are located in the `test/` directory of each package. The `mocktail` library is used for mocking.

```dart
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:my_package/my_package.dart';

class MockMyRemoteSource extends Mock implements IMyRemoteSource {}

void main() {
  late MockMyRemoteSource mockRemote;
  late MyRepository repository;

  setUp(() {
    mockRemote = MockMyRemoteSource();
    repository = MyRepository(remote: mockRemote);
  });

  group('MyRepository', () {
    test('fetchData returns model on success', () async {
      final expected = MyModel(id: '1', name: 'Test');
      when(() => mockRemote.fetchData('1')).thenAnswer((_) async => expected);

      final result = await repository.fetchData('1');

      expect(result, equals(expected));
      verify(() => mockRemote.fetchData('1')).called(1);
    });
  });
}
```

### 6. Quality Checks

Run the following checks before committing:

```bash
# Formatting
melos run format

# Static analysis
melos run analyze

# Unit tests
melos run unit-test
```

### 7. Commit and Push

```bash
git add <files>
git commit -m "feat: Short description"
git push origin your-branch-name
```

Commit message format: `type: description` where type is one of `feat`, `fix`, `refactor`, `chore`, `docs`, `test`.

### 8. Pull Request

Open a pull request to the `main` branch on GitHub.

## Makefile Commands

| Command             | Description                    |
| ------------------- | ------------------------------ |
| `make build-runner` | Code generation (all packages) |
| `make clean`        | Clean build cache              |
| `make pod-install`  | Clean and reinstall iOS pods   |
| `make git-update`   | Update git, clean old branches |
| `make fvm-check`    | Verify FVM Flutter version     |

## Melos Commands

| Command                      | Description                         |
| ---------------------------- | ----------------------------------- |
| `melos bootstrap`            | Link packages, install dependencies |
| `melos run format`           | Code formatting                     |
| `melos run format-check`     | Format check (CI)                   |
| `melos run analyze`          | Static analysis                     |
| `melos run analyze-check`    | Analysis + fatal warnings           |
| `melos run unit-test`        | All unit tests                      |
| `melos run test`             | Tests for selected package          |
| `melos run run-build-runner` | Code generation (via melos)         |
| `melos run build-apk`        | Android APK                         |
| `melos run build-ios`        | iOS unsigned release                |
