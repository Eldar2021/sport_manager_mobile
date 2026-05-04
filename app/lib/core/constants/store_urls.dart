import 'dart:io';

abstract final class StoreUrls {
  static const iosStoreUrl = 'https://apps.apple.com/app/id6739230204';
  static const androidStoreUrl = 'https://play.google.com/store/apps/details?id=com.sport.manager.app';

  static String get current => Platform.isAndroid ? androidStoreUrl : iosStoreUrl;
}
