// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'update_audit_status_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UpdateAuditStatusModel _$UpdateAuditStatusModelFromJson(
  Map<String, dynamic> json,
) => UpdateAuditStatusModel(
  status: json['status'] as String?,
  message: json['message'] as String?,
  auditId: (json['audit_id'] as num?)?.toInt(),
  newStatus: json['new_status'] as String?,
  pendingItemsCount: (json['pending_items_count'] as num?)?.toInt(),
);

Map<String, dynamic> _$UpdateAuditStatusModelToJson(
  UpdateAuditStatusModel instance,
) => <String, dynamic>{
  'status': instance.status,
  'message': instance.message,
  'audit_id': instance.auditId,
  'new_status': instance.newStatus,
  'pending_items_count': instance.pendingItemsCount,
};
