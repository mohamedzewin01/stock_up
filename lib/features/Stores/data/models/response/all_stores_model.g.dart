// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'all_stores_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AllStoresModel _$AllStoresModelFromJson(Map<String, dynamic> json) =>
    AllStoresModel(
      status: json['status'] as String?,
      results: (json['results'] as List<dynamic>?)
          ?.map((e) => Results.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$AllStoresModelToJson(AllStoresModel instance) =>
    <String, dynamic>{'status': instance.status, 'results': instance.results};

Results _$ResultsFromJson(Map<String, dynamic> json) => Results(
  id: (json['id'] as num?)?.toInt(),
  storeName: json['store_name'] as String?,
  storeLocation: json['store_location'] as String?,
  createdAt: json['created_at'] as String?,
);

Map<String, dynamic> _$ResultsToJson(Results instance) => <String, dynamic>{
  'id': instance.id,
  'store_name': instance.storeName,
  'store_location': instance.storeLocation,
  'created_at': instance.createdAt,
};
