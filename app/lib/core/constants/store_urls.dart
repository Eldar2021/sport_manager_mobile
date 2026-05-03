import 'dart:io';
import 'package:package_info_plus/package_info_plus.dart';

abstract final class StoreUrls {
  static const _iosStoreUrl = 'https://apps.apple.com/app/id<APP_ID>';
  static const _androidStoreUrl = 'https://play.google.com/store/apps/details?id=';

  static String resolve(PackageInfo info) {
    if (Platform.isAndroid) {
      return _androidStoreUrl;
    }
    return _iosStoreUrl;
  }
}
