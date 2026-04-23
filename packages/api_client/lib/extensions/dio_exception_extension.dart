import 'dart:convert';

import 'package:core/core.dart';
import 'package:dio/dio.dart';

const _badResponsePatterns = [
  'XMLHttpRequest error',
  'SocketException',
  'Connection closed',
  'HandshakeException',
  'FormatException',
  'Unexpected character',
];

extension DioExceptionX on DioException {
  String? get getReadableMessage {
    final msg = message?.trim() ?? '';
    if (msg.isEmpty) return null;
    for (final p in _badResponsePatterns) {
      if (msg.contains(p)) return null;
    }
    return msg;
  }

  BaseMessage? get errorMessage {
    final data = response?.data;

    if (data is String) {
      if (data.contains('<html>')) {
        return BaseMessage.serviceUnavailable;
      }
      try {
        if (data.contains('Bad Gateway')) {
          return BaseMessage.serviceUnavailable;
        }

        final decoded = jsonDecode(data) as Map<String, dynamic>?;
        if (decoded != null) {
          return BaseMessage.serviceUnavailable;
        }
      } on Object catch (_) {
        return BaseMessage.serviceUnavailable;
      }
      return BaseMessage.serviceUnavailable;
    }

    if (data is Map) {
      return _extractErrorMessage(data);
    }

    return null;
  }

  BaseMessage? _extractErrorMessage(Map<dynamic, dynamic> data) {
    if (data.containsKey('message')) {
      final message = data['message'];
      if (message is String && message.isNotEmpty) {
        return BaseMessage(
          en: message,
          ru: message,
          ky: message,
        );
      }
    }
    if (data.containsKey('code') && data['code'] is String) {
      final error = data['code'];
      if (error is String && error.isNotEmpty) {
        return BaseMessage(
          en: error,
          ru: error,
          ky: error,
        );
      }
    }

    return null;
  }
}
