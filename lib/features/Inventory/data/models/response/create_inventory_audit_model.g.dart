// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'create_inventory_audit_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CreateInventoryAuditModel _$CreateInventoryAuditModelFromJson(
  Map<String, dynamic> json,
) => CreateInventoryAuditModel(
  status: json['status'] as String?,
  message: json['message'] as String?,
  audit: json['audit'] == null
      ? null
      : Audit.fromJson(json['audit'] as Map<String, dynamic>),
);

Map<String, dynamic> _$CreateInventoryAuditModelToJson(
  CreateInventoryAuditModel instance,
) => <String, dynamic>{
  'status': instance.status,
  'message': instance.message,
  'audit': instance.audit,
};

Audit _$AuditFromJson(Map<String, dynamic> json) => Audit(
  id: (json['id'] as num?)?.toInt(),
  storeId: (json['store_id'] as num?)?.toInt(),
  storeName: json['store_name'] as String?,
  creatorUserId: (json['creator_user_id'] as num?)?.toInt(),
  firstName: json['first_name'] as String?,
  lastName: json['last_name'] as String?,
  status: json['status'] as String?,
  auditDate: json['audit_date'] as String?,
  notes: json['notes'] as String?,
);

Map<String, dynamic> _$AuditToJson(Audit instance) => <String, dynamic>{
  'id': instance.id,
  'store_id': instance.storeId,
  'store_name': instance.storeName,
  'creator_user_id': instance.creatorUserId,
  'first_name': instance.firstName,
  'last_name': instance.lastName,
  'status': instance.status,
  'audit_date': instance.auditDate,
  'notes': instance.notes,
};
