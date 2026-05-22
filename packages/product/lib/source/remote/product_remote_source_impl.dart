import 'dart:io';
import 'package:api_client/api_client.dart';
import 'package:meta/meta.dart';
import 'package:product/product.dart';

@immutable
final class ProductRemoteSourceImpl implements ProductRemoteSource {
  const ProductRemoteSourceImpl(ApiClient client) : _client = client;

  final ApiClient _client;

  static const _baseUrl = '/api/v1/product';
  static const _reportsBase = '/api/v1/reports';

  @override
  Future<List<ProductModel>> getAll({
    ProductCategory? category,
    String? search,
  }) {
    return _client
        .getListOfType<ProductModel>(
          _baseUrl,
          fromJson: ProductModel.fromJson,
          params: GetApiParams(
            queryParameters: {
              if (category != null) 'category': category.toJson(),
              if (search != null && search.isNotEmpty) 'search': search,
            },
          ),
        )
        .mapTo(ProductExc.fromApiClientExc);
  }

  @override
  Future<ProductModel> getById(String id) {
    return _client
        .getType<ProductModel>(
          '$_baseUrl/$id',
          fromJson: ProductModel.fromJson,
        )
        .mapTo(ProductExc.fromApiClientExc);
  }

  @override
  Future<ProductModel> create(ProductCreateParam param) {
    return _client
        .postType<ProductModel>(
          _baseUrl,
          data: param.toJson(),
          fromJson: ProductModel.fromJson,
        )
        .mapTo(ProductExc.fromApiClientExc);
  }

  @override
  Future<ProductModel> update(
    String id,
    ProductCreateParam param,
  ) {
    return _client
        .putType<ProductModel>(
          '$_baseUrl/$id',
          data: param.toJson(),
          fromJson: ProductModel.fromJson,
        )
        .mapTo(ProductExc.fromApiClientExc);
  }

  @override
  Future<void> delete(String id) {
    return _client
        .delete<void>('$_baseUrl/$id')
        .mapTo(
          ProductExc.fromApiClientExc,
        );
  }

  @override
  Future<ProductPhotoResponse> uploadPhoto(File file) {
    return _client
        .postMultipart<ProductPhotoResponse>(
          '$_baseUrl/photo',
          fromJson: ProductPhotoResponse.fromJson,
          files: {'file': file},
        )
        .mapTo(ProductExc.fromApiClientExc);
  }

  @override
  Future<ProductReportSummaryModel> getProductsReport(
    String venueId,
    ProductReportFilter filter,
  ) {
    return _client
        .getType<ProductReportSummaryModel>(
          '$_reportsBase/venue/$venueId/products',
          fromJson: ProductReportSummaryModel.fromJson,
          params: GetApiParams(
            queryParameters: {
              'period': ?filter.period,
              'from': ?filter.from,
              'to': ?filter.to,
            },
          ),
        )
        .mapTo(ProductExc.fromApiClientExc);
  }

  @override
  Future<ProductSalesSummaryModel> getProductSalesReport(
    String venueId,
    String productId,
    ProductReportFilter filter,
  ) {
    return _client
        .getType<ProductSalesSummaryModel>(
          '$_reportsBase/venue/$venueId/product/$productId',
          fromJson: ProductSalesSummaryModel.fromJson,
          params: GetApiParams(
            queryParameters: {
              'period': ?filter.period,
              'from': ?filter.from,
              'to': ?filter.to,
            },
          ),
        )
        .mapTo(ProductExc.fromApiClientExc);
  }
}
