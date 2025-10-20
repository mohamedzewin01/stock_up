// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'get_all_products_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

GetAllProductsModel _$GetAllProductsModelFromJson(Map<String, dynamic> json) =>
    GetAllProductsModel(
      status: json['status'] as String?,
      store: json['store'] == null
          ? null
          : Store.fromJson(json['store'] as Map<String, dynamic>),
      totalItems: (json['total_items'] as num?)?.toInt(),
      results: (json['results'] as List<dynamic>?)
          ?.map((e) => Results.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$GetAllProductsModelToJson(
  GetAllProductsModel instance,
) => <String, dynamic>{
  'status': instance.status,
  'store': instance.store,
  'total_items': instance.totalItems,
  'results': instance.results,
};

Store _$StoreFromJson(Map<String, dynamic> json) =>
    Store(id: json['id'] as String?, name: json['name'] as String?);

Map<String, dynamic> _$StoreToJson(Store instance) => <String, dynamic>{
  'id': instance.id,
  'name': instance.name,
};

Results _$ResultsFromJson(Map<String, dynamic> json) => Results(
  productId: json['product_id'] as String?,
  productNumber: json['product_number'] as String?,
  productName: json['product_name'] as String?,
  totalQuantity: json['total_quantity'] as String?,
  unit: json['unit'] as String?,
  sellingPrice: json['selling_price'] as String?,
  averagePurchasePrice: json['average_purchase_price'] as String?,
  lastPurchasePrice: json['last_purchase_price'] as String?,
  categoryId: json['category_id'] as String?,
  categoryName: json['category_name'] as String?,
  taxable: json['taxable'] as String?,
  taxRate: json['tax_rate'] as String?,
  barcodes: (json['barcodes'] as List<dynamic>?)
      ?.map((e) => e as String)
      .toList(),
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
