# Error Handling

> How API errors flow from the backend to the UI in this monorepo.
> Read this before adding a new endpoint, a new package, or a new error code.

---

## The three layers

```
backend JSON ─► ApiClientException(code: String?)  ◄── api_client knows nothing about domains
                       │
                       │  .mapTo(XxxExc.fromApiClientExc)
                       ▼
                  XxxExc(XxxErrorCode)              ◄── one per package (bounded context)
                       │
                       │  thrown out of repository
                       ▼
                  cubit / view                       ◄── context.handleError(e)
```

1. **`api_client`** parses `data['code']` into a raw `String?` and wraps the failure in `ApiClientException`. It never imports a domain enum. See [api_client_exception.dart](../packages/api_client/lib/exceptions/api_client_exception.dart) + [dio_request_executor.dart](../packages/api_client/lib/request_executor/dio_request_executor.dart).

2. **Each domain package** defines exactly one exception (`XxxExc`) and one error-code enum (`XxxErrorCode`). The enum carries every code the backend can send for endpoints in that package. The exception ships a `fromApiClientExc` factory that lifts an `ApiClientException` into the typed one.

3. **Every remote-source method** wraps its call in `.mapTo(XxxExc.fromApiClientExc)`. No try/catch in source bodies.

---

## One exception per bounded context

The exception lives at the **package boundary**, not the domain-noun boundary.

```dart
// Bad — three sibling exceptions for one package
class VenueException   extends AppException<VenueErrorCode> { ... }
class SpotException   extends AppException<SpotErrorCode> { ... }
class SessionException extends AppException<SessionErrorCode> { ... }
```

The split is a lie: `/api/v1/venue/selected` can return a `TABLE_NOT_FOUND`, so we never knew which type to throw. We collapsed all three into one:

```dart
// Good — one FacilityExc with one FacilityErrorCode covering every code the facility API can return
final class FacilityExc extends AppException<FacilityErrorCode> { ... }
```

**Rule:** if two exceptions can be thrown from the same endpoint, they must be the same class. In practice that means **one exception per package**. Apply this when you add `auth`, `subscription`, `reports`, etc.

> **Migration status.** `facility` is the canonical reference. `auth`, `managers`, `subscription`, `reports` still use the older `…Exception` suffix and per-method try/catch — they are scheduled to migrate to `…Exc` + `.mapTo` when next touched. New packages always start with the `Exc` convention below; do not introduce another `…Exception` class.

---

## File shape

A complete exception file looks like this — copy this template when adding a new package.

```dart
// packages/<feature>/lib/exceptions/<feature>_exception.dart
import 'package:api_client/api_client.dart';
import 'package:core/core.dart';

enum FacilityErrorCode {
  venueNotFound,
  venueNumberTaken,
  // ... grouped by sub-domain
  tableNotFound,
  tableHasActiveSession,
  // ...
  sessionNotFound,
  // ...
  unknown
  ;

  factory FacilityErrorCode.fromString(String? code) {
    return switch (code) {
      'VENUE_NOT_FOUND' => .venueNotFound,
      'TABLE_NOT_FOUND' => .tableNotFound,
      // ... one line per code
      _                 => .unknown,
    };
  }
}

final class FacilityExc extends AppException<FacilityErrorCode> {
  const FacilityExc(
    super.error, {
    super.message,
    super.handleType,
  });

  factory FacilityExc.fromApiClientExc(ApiClientException e) {
    return FacilityExc(
      FacilityErrorCode.fromString(e.code),
      message: e.message,
    );
  }

  @override
  ErrorModel getModel() => ErrorModel(title: _title, message: getUiMessage());

  BaseMessage get _title => switch (error) {
    .venueNotFound || .venueNumberTaken => BaseMessage.venueError,
    .tableNotFound || .tableHasActiveSession => BaseMessage.tableError,
    .sessionNotFound => BaseMessage.sessionError,
    .unknown => BaseMessage.base,
  };

  @override
  BaseMessage getUiMessage() => switch (error) {
    .venueNotFound => const BaseMessage(en: '...', ru: '...', ky: '...'),
    // ...
    .unknown => message ?? BaseMessage.defaultUiMessage,
  };
}
```

### Conventions baked into the template

| Element                | Rule                                                                                                                                                                                                    |
| ---------------------- | ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| Exception class suffix | **`Exc`** (not `Exception`) — `FacilityExc`, `AuthExc`. Short, reads at the call site.                                                                                                                  |
| Enum name              | `<Feature>ErrorCode`                                                                                                                                                                                    |
| Backend → enum parser  | Top-level `factory <Enum>.fromString(String?)` on the enum                                                                                                                                              |
| API → domain mapper    | Named `factory <Exc>.fromApiClientExc(ApiClientException e)` on the exception (matches `.mapTo(...)` signature)                                                                                         |
| switch style           | **Switch expression** + **dot-shorthand** (`.venueNotFound`) — Dart 3.11 supports it and it keeps the enum prefix from drowning the code                                                                |
| Unknown fallback       | Always include an `unknown` enum case; `getUiMessage()` for it returns `message ?? BaseMessage.defaultUiMessage` so the raw `ApiClientException.message` survives if present                            |
| `_title` getter        | Private. Groups codes into existing `BaseMessage.X` titles (venueError / tableError / sessionError / base for unknown). Use OR-patterns (`a &#124;&#124; b`), don't repeat the same `BaseMessage` body. |

---

## Calling sites — `.mapTo` on every method

The extension lives in `api_client`:

```dart
// packages/api_client/lib/extensions/map_api_errors_extension.dart
extension MapApiErrors<T> on Future<T> {
  Future<T> mapTo<E extends Object>(
    AppException<E> Function(ApiClientException src) build,
  ) async {
    try {
      return await this;
    } on ApiClientException catch (e) {
      throw build(e);
    }
  }
}
```

Every remote-source method ends with one line — no try/catch:

```dart
// Bad — manual try/catch in every method
Future<SelectedVenueModel> getSelected() async {
  try {
    return await _client.getType<SelectedVenueModel>(...);
  } catch (e) {
    if (e is ApiClientException) {
      throw FacilityExc(FacilityErrorCode.fromString(e.code), message: e.message);
    }
    rethrow;
  }
}

// Good — single expression, mapper passed as tear-off
Future<SelectedVenueModel> getSelected() {
  return _client
      .getType<SelectedVenueModel>(
        '/api/v1/venue/selected',
        fromJson: SelectedVenueModel.fromJson,
      )
      .mapTo(FacilityExc.fromApiClientExc);
}
```

### Pitfalls

- **`delete` needs an explicit type argument.** `mapTo`'s generic blocks inference, so write `_client.delete<void>(...)` not `_client.delete(...)`.
- **`ConnectionException` and `ApiClientUnknownException` pass through `mapTo` unchanged** — that's intentional. Only `ApiClientException` (the one carrying a parseable backend `code`) gets lifted to a typed domain exception.
- **Don't try/catch around the call site to "narrow" the error.** If you need to distinguish venue-not-found from table-not-found, do it in the cubit by switching on `e.error` (the enum), not by catching different exception classes.

---

## Mock sources throw the same exception

A `XxxRemoteSourceMock` simulates the same failure surface as the real impl — it throws `FacilityExc` directly, never `ApiClientException`.

```dart
// facility_remote_source_mock.dart
if (index == -1) throw const FacilityExc(FacilityErrorCode.venueNotFound);
```

This keeps the cubit / repository code identical between mock and prod modes. If you add a new mock failure path, pick the right `FacilityErrorCode` and throw the unified exception with `const`.

---

## Consuming in cubits

Cubits switch on `e.error` (the enum), never on exception subtype:

```dart
try {
  final response = await action();
  emit(HomeLoaded(...));
} on FacilityExc catch (e) {
  if (e.error == FacilityErrorCode.venueNotFound) {
    emit(const HomeNoVenue());
  } else {
    emit(HomeFailure(e));
  }
} on Object catch (e) {
  emit(HomeFailure(e));
}
```

For UI rendering of unhandled errors, `context.handleError(e)` dispatches to the right `ErrorHandler` (snackbar / dialog) based on `e.handleType` and uses `e.getModel()` for the title + body.

---

## Adding a new package — checklist

1. Create `packages/<feature>/lib/exceptions/<feature>_exception.dart` from the template above.
2. Add every backend code you know to `<Feature>ErrorCode.fromString` and `getUiMessage`.
3. Add a title-group for unknown sub-domains in `_title` (reuse an existing `BaseMessage.X` title; only add a new one to [error_model.dart](../packages/core/lib/exception/model/error_model.dart) if no existing title fits).
4. In every method of `<Feature>RemoteSourceImpl`, end the expression with `.mapTo(<Feature>Exc.fromApiClientExc)`. No try/catch.
5. In the mock, throw `const <Feature>Exc(<Feature>ErrorCode.X)` for each simulated failure.
6. In cubits, branch on `e.error` against the enum, not on subtypes.

---

## What lives where

| Layer       | File                                                                                                 | What it owns                                                         |
| ----------- | ---------------------------------------------------------------------------------------------------- | -------------------------------------------------------------------- |
| Transport   | [api_client_exception.dart](../packages/api_client/lib/exceptions/api_client_exception.dart)         | `ApiClientException(code: String?)` — raw backend code, no enums     |
| Plumbing    | [map_api_errors_extension.dart](../packages/api_client/lib/extensions/map_api_errors_extension.dart) | `Future<T>.mapTo(build)` — one place, generic over `AppException<E>` |
| Domain      | `packages/<feature>/lib/exceptions/<feature>_exception.dart`                                         | One enum + one `Exc` class + two factories                           |
| 401/423     | `UnauthenticatedExceptionHandle` (registered with `instanceName: 'unauthenticated'`)                 | Session-expired routing — bypasses the per-feature path              |
| UI dispatch | `BaseErrorHandler` + snackbar / dialog handlers                                                      | Reads `handleType` and `getModel()`                                  |
