// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'add_inventory_audit_items_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AddInventoryAuditItemsModel _$AddInventoryAuditItemsModelFromJson(
  Map<String, dynamic> json,
) => AddInventoryAuditItemsModel(
  status: json['status'] as String?,
  message: json['message'] as String?,
  version: (json['version'] as num?)?.toInt(),
  createdAt: json['created_at'] as String?,
);

Map<String, dynamic> _$AddInventoryAuditItemsModelToJson(
  AddInventoryAuditItemsModel instance,
) => <String, dynamic>{
  'status': instance.status,
  'message': instance.message,
  'version': instance.version,
  'created_at': instance.createdAt,
};
