// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'search_products_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SearchProductsModel _$SearchProductsModelFromJson(Map<String, dynamic> json) =>
    SearchProductsModel(
      status: json['status'] as String?,
      store: json['store'] == null
          ? null
          : Store.fromJson(json['store'] as Map<String, dynamic>),
      page: (json['page'] as num?)?.toInt(),
      limit: (json['limit'] as num?)?.toInt(),
      totalItems: (json['total_items'] as num?)?.toInt(),
      totalPages: (json['total_pages'] as num?)?.toInt(),
      results: (json['results'] as List<dynamic>?)
          ?.map((e) => Results.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$SearchProductsModelToJson(
  SearchProductsModel instance,
) => <String, dynamic>{
  'status': instance.status,
  'store': instance.store,
  'page': instance.page,
  'limit': instance.limit,
  'total_items': instance.totalItems,
  'total_pages': instance.totalPages,
  'results': instance.results,
};

Store _$StoreFromJson(Map<String, dynamic> json) =>
    Store(id: json['id'] as String?, name: json['name'] as String?);

Map<String, dynamic> _$StoreToJson(Store instance) => <String, dynamic>{
  'id': instance.id,
  'name': instance.name,
};

Results _$ResultsFromJson(Map<String, dynamic> json) => Results(
  productId: (json['product_id'] as num?)?.toInt(),
  productNumber: (json['product_number'] as num?)?.toInt(),
  productName: json['product_name'] as String?,
  totalQuantity: json['total_quantity'] as String?,
  unit: json['unit'] as String?,
  sellingPrice: json['selling_price'] as String?,
  averagePurchasePrice: json['average_purchase_price'] as String?,
  lastPurchasePrice: json['last_purchase_price'] as String?,
  categoryId: json['category_id'],
  categoryName: json['category_name'],
  taxable: (json['taxable'] as num?)?.toInt(),
  taxRate: json['tax_rate'] as String?,
  barcodes: json['barcodes'] as List<dynamic>?,
);

Map<String, dynamic> _$ResultsToJson(Results instance) => <String, dynamic>{
  'product_id': instance.productId,
  'product_number': instance.productNumber,
  'product_name': instance.productName,
  'total_quantity': instance.totalQuantity,
  'unit': instance.unit,
  'selling_price': instance.sellingPrice,
  'average_purchase_price': instance.averagePurchasePrice,
  'last_purchase_price': instance.lastPurchasePrice,
  'category_id': instance.categoryId,
  'category_name': instance.categoryName,
  'taxable': instance.taxable,
  'tax_rate': instance.taxRate,
  'barcodes': instance.barcodes,
};
