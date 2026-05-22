import 'dart:io';
import 'package:meta/meta.dart';
import 'package:product/product.dart';

@immutable
final class ProductRepository {
  const ProductRepository(
    ProductRemoteSource remoteSource,
  ) : _remote = remoteSource;

  final ProductRemoteSource _remote;

  Future<List<ProductModel>> getAll({
    ProductCategory? category,
    String? search,
  }) {
    return _remote.getAll(category: category, search: search);
  }

  Future<ProductModel> getById(String id) => _remote.getById(id);

  Future<ProductModel> create(ProductCreateParam param) => _remote.create(param);

  Future<ProductModel> update(String id, ProductCreateParam param) => _remote.update(id, param);

  Future<void> delete(String id) => _remote.delete(id);

  Future<ProductPhotoResponse> uploadPhoto(File file) => _remote.uploadPhoto(file);

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
