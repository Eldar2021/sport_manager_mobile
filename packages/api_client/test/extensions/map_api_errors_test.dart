import 'package:api_client/api_client.dart';
import 'package:core/core.dart';
import 'package:test/test.dart';

final class _FakeExc extends AppException<String> {
  const _FakeExc(super.error, {super.message});

  factory _FakeExc.fromApiClientExc(ApiClientException e) {
    return _FakeExc(e.code ?? 'unknown', message: e.message);
  }

  @override
  ErrorModel getModel() => ErrorModel(
    title: BaseMessage.base,
    message: getUiMessage(),
  );

  @override
  BaseMessage getUiMessage() => message ?? BaseMessage.base;
}

DioException _dioErr() => DioException(
  requestOptions: RequestOptions(path: '/x'),
);

void main() {
  group('Future.mapTo', () {
    test('returns the value unchanged on success', () async {
      final result = await Future.value(42).mapTo(_FakeExc.fromApiClientExc);
      expect(result, 42);
    });

    test('lifts ApiClientException into the target type via the builder', () async {
      final source = Future<int>.error(
        ApiClientException(_dioErr(), code: 'VENUE_NOT_FOUND'),
      );
      await expectLater(
        source.mapTo(_FakeExc.fromApiClientExc),
        throwsA(
          isA<_FakeExc>().having((e) => e.error, 'error', 'VENUE_NOT_FOUND'),
        ),
      );
    });

    test('passes ConnectionException through unchanged', () async {
      final source = Future<int>.error(const ConnectionException('offline'));
      await expectLater(
        source.mapTo(_FakeExc.fromApiClientExc),
        throwsA(isA<ConnectionException>()),
      );
    });

    test('passes ApiClientUnknownException through unchanged', () async {
      final source = Future<int>.error(const ApiClientUnknownException('boom'));
      await expectLater(
        source.mapTo(_FakeExc.fromApiClientExc),
        throwsA(isA<ApiClientUnknownException>()),
      );
    });
  });
}
