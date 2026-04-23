import 'package:api_client/api_client.dart';
import 'package:test/test.dart';

import 'helpers/mock_http_client_adapter.dart';
import 'helpers/mocks.dart';
import 'helpers/test_model.dart';

void main() {
  late ApiClient client;
  late MockHttpClientAdapter mockAdapter;

  const singlePostData = {
    'userId': 1,
    'id': 1,
    'title': 'test title',
    'body': 'test body',
  };

  const postListData = [
    {'userId': 1, 'id': 1, 'title': 'title 1', 'body': 'body 1'},
    {'userId': 2, 'id': 2, 'title': 'title 2', 'body': 'body 2'},
  ];

  const getPostUrl = 'https://example.com/post.json';
  const getPostListUrl = 'https://example.com/posts.json';
  const emptyListUrl = 'https://example.com/empty_list.json';
  const postUrl = 'https://example.com/posts';
  const postDetailUrl = 'https://example.com/posts/1';

  final requestData = {'title': 'foo', 'body': 'bar', 'userId': 1};
  final mutationResponse = {'userId': 1, 'id': 101, 'title': 'foo', 'body': 'bar'};

  setUp(() {
    mockAdapter = MockHttpClientAdapter()
      ..register(getPostUrl, singlePostData)
      ..register(getPostListUrl, postListData)
      ..register(emptyListUrl, <dynamic>[]);

    final dio = Dio()..httpClientAdapter = mockAdapter;

    client = ApiClient.fromDio(
      dio: dio,
      connection: ConnectivityBasedConnectionChecker(MockConnectivity()),
    );
  });

  group('RemoteClient `get`, `getType`, `getListOfType`', () {
    test('Get', () async {
      final mapValue = await client.get<Map<String, dynamic>>(getPostUrl);

      expect(mapValue, isNotNull);
      expect(mapValue, isMap);
      expect(mapValue, isA<Map<String, dynamic>>());

      final listValue = await client.get<List<dynamic>>(getPostListUrl);
      expect(listValue, isNotNull);
      expect(listValue, isList);
      expect(listValue.isNotEmpty, true);
      expect(listValue, isA<List<dynamic>>());
    });

    test('Get Type', () async {
      final testModel = await client.getType<TestModel>(
        getPostUrl,
        fromJson: TestModel.fromJson,
      );
      expect(testModel, isNotNull);
      expect(testModel, isA<TestModel>());
    });

    test('Get List Of Type', () async {
      final testModelList = await client.getListOfType<TestModel>(
        getPostListUrl,
        fromJson: TestModel.fromJson,
      );
      expect(testModelList, isNotNull);
      expect(testModelList, isList);
      expect(testModelList, isA<List<TestModel>>());
      expect(testModelList[0], isA<TestModel>());
    });

    test('Get empty List', () async {
      final testModelList = await client.getListOfType<TestModel>(
        emptyListUrl,
        fromJson: TestModel.fromJson,
      );
      expect(testModelList, isNotNull);
      expect(testModelList, isList);
      expect(testModelList, isA<List<TestModel>>());
      expect(testModelList.isEmpty, true);
    });
  });

  group('RemoteClient `post`, `postType`, `postListOfType`', () {
    test('Post', () async {
      mockAdapter.register(postUrl, mutationResponse, statusCode: 201);

      final mapValue = await client.post<Map<String, dynamic>>(
        postUrl,
        data: requestData,
      );

      expect(mapValue, isNotNull);
      expect(mapValue, isA<Map<String, dynamic>>());
    });

    test('Post Type', () async {
      mockAdapter.register(postUrl, mutationResponse, statusCode: 201);

      final testModel = await client.postType<TestModel>(
        postUrl,
        data: requestData,
        fromJson: TestModel.fromJson,
      );

      expect(testModel, isA<TestModel>());
    });
  });

  group('RemoteClient `put`, `putType`, `putListOfType`', () {
    test('Put', () async {
      mockAdapter.register(postDetailUrl, {...requestData, 'id': 1});

      final mapValue = await client.put<Map<String, dynamic>>(
        postDetailUrl,
        data: requestData,
      );
      expect(mapValue, isNotNull);

      expect(mapValue, isA<Map<String, dynamic>>());
    });

    test('Put Type', () async {
      mockAdapter.register(postDetailUrl, mutationResponse);

      final testModel = await client.putType<TestModel>(
        postDetailUrl,
        data: requestData,
        fromJson: TestModel.fromJson,
      );

      expect(testModel, isA<TestModel>());
    });
  });

  group('RemoteClient `patch`, `patchType`, `patchListOfType`', () {
    test('Patch', () async {
      mockAdapter.register(postDetailUrl, {...requestData, 'id': 1});

      final mapValue = await client.patch<Map<String, dynamic>>(
        postDetailUrl,
        data: requestData,
      );

      expect(mapValue, isNotNull);
      expect(mapValue, isA<Map<String, dynamic>>());
    });

    test('Patch Type', () async {
      mockAdapter.register(postDetailUrl, mutationResponse);

      final testModel = await client.patchType<TestModel>(
        postDetailUrl,
        data: requestData,
        fromJson: TestModel.fromJson,
      );

      expect(testModel, isA<TestModel>());
    });
  });
}
