// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'create_inventory_audit_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CreateInventoryAuditRequest _$CreateInventoryAuditRequestFromJson(
  Map<String, dynamic> json,
) => CreateInventoryAuditRequest(
  storeId: (json['store_id'] as num?)?.toInt(),
  creatorUserId: (json['creator_user_id'] as num?)?.toInt(),
  notes: json['notes'] as String?,
);

Map<String, dynamic> _$CreateInventoryAuditRequestToJson(
  CreateInventoryAuditRequest instance,
) => <String, dynamic>{
  'store_id': instance.storeId,
  'creator_user_id': instance.creatorUserId,
  'notes': instance.notes,
};
