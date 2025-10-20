// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'add_inventory_audit_items_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AddInventoryAuditItemsRequest _$AddInventoryAuditItemsRequestFromJson(
  Map<String, dynamic> json,
) => AddInventoryAuditItemsRequest(
  auditId: (json['audit_id'] as num?)?.toInt(),
  productId: (json['product_id'] as num?)?.toInt(),
  userId: (json['user_id'] as num?)?.toInt(),
  quantity: (json['quantity'] as num?)?.toInt(),
  notes: json['notes'] as String?,
);

Map<String, dynamic> _$AddInventoryAuditItemsRequestToJson(
  AddInventoryAuditItemsRequest instance,
) => <String, dynamic>{
  'audit_id': instance.auditId,
  'product_id': instance.productId,
  'user_id': instance.userId,
  'quantity': instance.quantity,
  'notes': instance.notes,
};
