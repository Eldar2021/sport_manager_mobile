import 'package:api_client/api_client.dart';
import 'package:core/core.dart';

enum ProductErrorCode {
  nameRequired,
  nameTooLong,
  nameTaken,
  priceInvalid,
  unitInvalid,
  categoryInvalid,
  notFound,
  forbidden,
  photoRequired,
  photoTooLarge,
  photoTypeInvalid,
  sessionNotActive,
  sessionItemNotFound,
  unknown
  ;

  factory ProductErrorCode.fromString(String? code) {
    return switch (code) {
      'PRODUCT_NAME_REQUIRED' => .nameRequired,
      'PRODUCT_NAME_TOO_LONG' => .nameTooLong,
      'PRODUCT_NAME_TAKEN' => .nameTaken,
      'PRODUCT_PRICE_INVALID' => .priceInvalid,
      'PRODUCT_UNIT_INVALID' => .unitInvalid,
      'PRODUCT_CATEGORY_INVALID' => .categoryInvalid,
      'PRODUCT_NOT_FOUND' => .notFound,
      'PRODUCT_FORBIDDEN' => .forbidden,
      'PHOTO_FILE_REQUIRED' => .photoRequired,
      'PHOTO_TOO_LARGE' => .photoTooLarge,
      'PHOTO_TYPE_INVALID' => .photoTypeInvalid,
      'SESSION_NOT_ACTIVE' => .sessionNotActive,
      'SESSION_ITEM_NOT_FOUND' => .sessionItemNotFound,
      _ => .unknown,
    };
  }
}

final class ProductExc extends AppException<ProductErrorCode> {
  const ProductExc(
    super.error, {
    super.message,
    super.handleType,
  });

  factory ProductExc.fromApiClientExc(ApiClientException e) {
    return ProductExc(
      ProductErrorCode.fromString(e.code),
      message: e.message,
    );
  }

  @override
  ErrorModel getModel() {
    return ErrorModel(
      title: _title,
      message: getUiMessage(),
    );
  }

  BaseMessage get _title {
    return switch (error) {
      .nameRequired ||
      .nameTooLong ||
      .nameTaken ||
      .priceInvalid ||
      .unitInvalid ||
      .categoryInvalid ||
      .notFound ||
      .forbidden => const BaseMessage(
        en: 'Product Error',
        ru: 'Ошибка товара',
        ky: 'Товар катасы',
      ),
      .photoRequired || .photoTooLarge || .photoTypeInvalid => const BaseMessage(
        en: 'Photo Error',
        ru: 'Ошибка фото',
        ky: 'Сүрөт катасы',
      ),
      .sessionNotActive || .sessionItemNotFound => BaseMessage.sessionError,
      .unknown => BaseMessage.base,
    };
  }

  @override
  BaseMessage getUiMessage() {
    return switch (error) {
      .nameRequired => const BaseMessage(
        en: 'Product name is required',
        ru: 'Название товара обязательно',
        ky: 'Товардын аталышы талап кылынат',
      ),
      .nameTooLong => const BaseMessage(
        en: 'Product name must be 80 characters or less',
        ru: 'Название товара не должно превышать 80 символов',
        ky: 'Товардын аталышы 80 белгиден ашпашы керек',
      ),
      .nameTaken => const BaseMessage(
        en: 'A product with this name already exists',
        ru: 'Товар с таким названием уже существует',
        ky: 'Бул атоо менен товар буга чейин бар',
      ),
      .priceInvalid => const BaseMessage(
        en: 'Price must be a positive integer',
        ru: 'Цена должна быть положительным целым числом',
        ky: 'Баа оң бүтүн сан болушу керек',
      ),
      .unitInvalid => const BaseMessage(
        en: 'Invalid unit type',
        ru: 'Недопустимый тип единицы измерения',
        ky: 'Жараксыз өлчөм бирдиги түрү',
      ),
      .categoryInvalid => const BaseMessage(
        en: 'Invalid product category',
        ru: 'Недопустимая категория товара',
        ky: 'Жараксыз товар категориясы',
      ),
      .notFound => const BaseMessage(
        en: 'Product not found',
        ru: 'Товар не найден',
        ky: 'Товар табылган жок',
      ),
      .forbidden => const BaseMessage(
        en: 'You do not have permission to perform this action',
        ru: 'У вас нет прав для выполнения этого действия',
        ky: 'Сизде бул аракетти аткаруу укугу жок',
      ),
      .photoRequired => const BaseMessage(
        en: 'Photo file is required',
        ru: 'Файл фото обязателен',
        ky: 'Сүрөт файлы талап кылынат',
      ),
      .photoTooLarge => const BaseMessage(
        en: 'Photo must be 5 MB or less',
        ru: 'Фото не должно превышать 5 МБ',
        ky: 'Сүрөт 5 МБ же азыраак болушу керек',
      ),
      .photoTypeInvalid => const BaseMessage(
        en: 'Only JPEG, PNG and WebP formats are allowed',
        ru: 'Разрешены только форматы JPEG, PNG и WebP',
        ky: 'Уруксат берилген форматтар: JPEG, PNG жана WebP',
      ),
      .sessionNotActive => const BaseMessage(
        en: 'Session is not active',
        ru: 'Сессия не является активной',
        ky: 'Сессия активдүү эмес',
      ),
      .sessionItemNotFound => const BaseMessage(
        en: 'Product item not found in this session',
        ru: 'Товар не найден в этой сессии',
        ky: 'Бул сессияда товар табылган жок',
      ),
      .unknown => message ?? BaseMessage.defaultUiMessage,
    };
  }
}
