import 'package:product/product.dart';

abstract interface class ProductLocalSource {
  Map<ProductCategory, List<String>> getEmojisByCategory();
}
