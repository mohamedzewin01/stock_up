// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'smart_search_Model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SmartSearchModel _$SmartSearchModelFromJson(Map<String, dynamic> json) =>
    SmartSearchModel(
      status: json['status'] as String?,
      store: json['store'] == null
          ? null
          : Store.fromJson(json['store'] as Map<String, dynamic>),
      results: (json['results'] as List<dynamic>?)
          ?.map((e) => Results.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$SmartSearchModelToJson(SmartSearchModel instance) =>
    <String, dynamic>{
      'status': instance.status,
      'store': instance.store,
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
  categoryId: (json['category_id'] as num?)?.toInt(),
  taxable: (json['taxable'] as num?)?.toInt(),
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
  'taxable': instance.taxable,
  'tax_rate': instance.taxRate,
  'barcodes': instance.barcodes,
};
