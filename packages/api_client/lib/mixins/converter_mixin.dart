import 'dart:developer';

import 'package:api_client/api_client.dart';

mixin ConverterMixin {
  T convertType<T>(
    Map<String, dynamic> jsonData,
    FromJson<T> fromJson,
  ) {
    try {
      return fromJson(jsonData);
    } catch (e, s) {
      log('Type conversion error', error: e, stackTrace: s);
      throw ConvertException(e, stackTrace: s);
    }
  }

  List<T> convertListOfType<T>(
    List<dynamic> jsonData,
    FromJson<T> fromJson,
  ) {
    try {
      return jsonData.map((e) => fromJson(e as Map<String, dynamic>)).toList();
    } catch (e, s) {
      log('List conversion error', error: e, stackTrace: s);
      throw ConvertException(e, stackTrace: s);
    }
  }
}
