import 'dart:io';
import 'package:product/product.dart';

abstract interface class ProductRemoteSource {
  Future<List<ProductModel>> getAll({
    ProductCategory? category,
    String? search,
  });

  Future<ProductModel> getById(String id);

  Future<ProductModel> create(ProductCreateParam param);

  Future<ProductModel> update(String id, ProductCreateParam param);

  Future<void> delete(String id);

  Future<ProductPhotoResponse> uploadPhoto(File file);

  Future<ProductReportSummaryModel> getProductsReport(
    String venueId,
    ProductReportFilter filter,
  );

  Future<ProductSalesSummaryModel> getProductSalesReport(
    String venueId,
    String productId,
    ProductReportFilter filter,
  );
}
