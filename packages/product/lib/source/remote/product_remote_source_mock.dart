import 'dart:io';
import 'package:product/product.dart';

final class ProductRemoteSourceMock implements ProductRemoteSource {
  ProductRemoteSourceMock() {
    _products = List.of(_seed);
  }

  static const _delay = Duration(milliseconds: 300);
  static const _ownerId = 'owner-001';

  late List<ProductModel> _products;
  int _idSeq = 100;

  static final List<ProductModel> _seed = [
    ProductModel(
      id: 'prod-1',
      ownerId: _ownerId,
      name: 'Вода 0.5л',
      price: 50,
      unit: ProductUnit.piece,
      category: ProductCategory.drink,
      description: 'Холодная питьевая вода',
      createdAt: DateTime(2025),
      updatedAt: DateTime(2025),
    ),
    ProductModel(
      id: 'prod-2',
      ownerId: _ownerId,
      name: 'Чай',
      price: 30,
      unit: ProductUnit.piece,
      category: ProductCategory.drink,
      createdAt: DateTime(2025),
      updatedAt: DateTime(2025),
    ),
    ProductModel(
      id: 'prod-3',
      ownerId: _ownerId,
      name: 'Аренда шара',
      price: 200,
      unit: ProductUnit.hour,
      category: ProductCategory.equipment,
      description: 'Бильярдный шар',
      createdAt: DateTime(2025),
      updatedAt: DateTime(2025),
    ),
  ];

  @override
  Future<List<ProductModel>> getAll({
    ProductCategory? category,
    String? search,
  }) async {
    await Future<void>.delayed(_delay);
    var result = List.of(_products);
    if (category != null) {
      result = result.where((p) => p.category == category).toList();
    }
    if (search != null && search.isNotEmpty) {
      final q = search.toLowerCase();
      result = result.where((p) => p.name.toLowerCase().contains(q)).toList();
    }
    return result;
  }

  @override
  Future<ProductModel> getById(String id) async {
    await Future<void>.delayed(_delay);
    final product = _products.where((p) => p.id == id).firstOrNull;
    if (product == null) throw const ProductExc(ProductErrorCode.notFound);
    return product;
  }

  @override
  Future<ProductModel> create(ProductCreateParam param) async {
    await Future<void>.delayed(_delay);
    final exists = _products.any(
      (p) => p.name.toLowerCase() == param.name.trim().toLowerCase(),
    );
    if (exists) throw const ProductExc(ProductErrorCode.nameTaken);
    final now = DateTime.now();
    final product = ProductModel(
      id: 'prod-${_idSeq++}',
      ownerId: _ownerId,
      name: param.name.trim(),
      price: param.price,
      unit: param.unit,
      category: param.category,
      description: param.description,
      photoUrl: param.photoUrl,
      createdAt: now,
      updatedAt: now,
    );
    _products.insert(0, product);
    return product;
  }

  @override
  Future<ProductModel> update(String id, ProductCreateParam param) async {
    await Future<void>.delayed(_delay);
    final index = _products.indexWhere((p) => p.id == id);
    if (index == -1) throw const ProductExc(ProductErrorCode.notFound);
    final nameTaken = _products.any(
      (p) => p.id != id && p.name.toLowerCase() == param.name.trim().toLowerCase(),
    );
    if (nameTaken) throw const ProductExc(ProductErrorCode.nameTaken);
    final updated = ProductModel(
      id: id,
      ownerId: _products[index].ownerId,
      name: param.name.trim(),
      price: param.price,
      unit: param.unit,
      category: param.category,
      description: param.description,
      photoUrl: param.photoUrl,
      createdAt: _products[index].createdAt,
      updatedAt: DateTime.now(),
    );
    _products[index] = updated;
    return updated;
  }

  @override
  Future<void> delete(String id) async {
    await Future<void>.delayed(_delay);
    final index = _products.indexWhere((p) => p.id == id);
    if (index == -1) throw const ProductExc(ProductErrorCode.notFound);
    _products.removeAt(index);
  }

  @override
  Future<ProductPhotoResponse> uploadPhoto(File file) async {
    await Future<void>.delayed(const Duration(milliseconds: 500));
    return const ProductPhotoResponse(
      'https://cdn.example.com/products/mock-photo.jpg',
    );
  }

  @override
  Future<ProductReportSummaryModel> getProductsReport(
    String venueId,
    ProductReportFilter filter,
  ) async {
    await Future<void>.delayed(_delay);
    final now = DateTime.now();
    return ProductReportSummaryModel(
      venueId: venueId,
      period: filter.period ?? 'day',
      from: now.subtract(const Duration(days: 1)),
      to: now,
      items: const [
        ProductReportItemModel(
          productId: 'prod-1',
          name: 'Вода 0.5л',
          category: ProductCategory.drink,
          totalCount: 12,
          totalAmount: 600,
          deleted: false,
        ),
        ProductReportItemModel(
          productId: 'prod-3',
          name: 'Аренда шара',
          category: ProductCategory.equipment,
          totalCount: 3,
          totalAmount: 600,
          deleted: false,
        ),
      ],
      totalAmount: 1200,
    );
  }

  @override
  Future<ProductSalesSummaryModel> getProductSalesReport(
    String venueId,
    String productId,
    ProductReportFilter filter,
  ) async {
    await Future<void>.delayed(_delay);
    final product = _products.where((p) => p.id == productId).firstOrNull;
    if (product == null) throw const ProductExc(ProductErrorCode.notFound);
    final now = DateTime.now();
    return ProductSalesSummaryModel(
      venueId: venueId,
      productId: productId,
      currentName: product.name,
      currentPrice: product.price,
      deleted: false,
      period: filter.period ?? 'day',
      from: now.subtract(const Duration(days: 1)),
      to: now,
      sales: [
        ProductSaleModel(
          sessionId: 'session-001',
          itemId: 'item-001',
          priceSnapshot: product.price,
          nameSnapshot: product.name,
          soldAt: now.subtract(const Duration(hours: 2)),
          sessionEndedAt: now.subtract(const Duration(hours: 1)),
        ),
      ],
      totalCount: 1,
      totalAmount: product.price,
    );
  }
}
