import 'dart:convert';
import 'dart:typed_data';

import 'package:api_client/api_client.dart';

class MockHttpClientAdapter implements HttpClientAdapter {
  final _responses = <String, _MockResponse>{};

  void register(String url, Object body, {int statusCode = 200}) {
    _responses[url] = _MockResponse(body: json.encode(body), statusCode: statusCode);
  }

  @override
  Future<ResponseBody> fetch(
    RequestOptions options,
    Stream<Uint8List>? requestStream,
    Future<void>? cancelFuture,
  ) async {
    final url = options.uri.toString();
    final mock = _responses[url];
    if (mock != null) {
      return ResponseBody.fromString(
        mock.body,
        mock.statusCode,
        headers: {
          Headers.contentTypeHeader: [Headers.jsonContentType],
        },
      );
    }

    throw DioException(
      requestOptions: options,
      error: 'No mock response registered for $url',
    );
  }

  @override
  void close({bool force = false}) {}
}

class _MockResponse {
  const _MockResponse({
    required this.body,
    required this.statusCode,
  });

  final String body;
  final int statusCode;
}
