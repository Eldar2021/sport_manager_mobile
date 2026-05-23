import 'dart:io';
import 'package:meta/meta.dart';
import 'package:product/product.dart';

@immutable
final class ProductRepository {
  const ProductRepository(
    ProductRemoteSource remoteSource,
    ProductLocalSource localSource,
  ) : _remote = remoteSource,
      _local = localSource;

  final ProductRemoteSource _remote;
  final ProductLocalSource _local;

  Map<ProductCategory, List<String>> getEmojisByCategory() {
    return _local.getEmojisByCategory();
  }

  Future<List<ProductModel>> getAll({
    ProductCategory? category,
    String? search,
  }) {
    return _remote.getAll(category: category, search: search);
  }

  Future<ProductModel> getById(String id) {
    return _remote.getById(id);
  }

  Future<ProductModel> create(ProductCreateParam param) {
    return _remote.create(param);
  }

  Future<ProductModel> update(String id, ProductCreateParam param) {
    return _remote.update(id, param);
  }

  Future<void> delete(String id) {
    return _remote.delete(id);
  }

  Future<ProductPhotoResponse> uploadPhoto(File file) {
    return _remote.uploadPhoto(file);
  }

  Future<ProductReportSummaryModel> getProductsReport(
    String venueId,
    ProductReportFilter filter,
  ) {
    return _remote.getProductsReport(venueId, filter);
  }

  Future<ProductSalesSummaryModel> getProductSalesReport(
    String venueId,
    String productId,
    ProductReportFilter filter,
  ) {
    return _remote.getProductSalesReport(venueId, productId, filter);
  }
}
