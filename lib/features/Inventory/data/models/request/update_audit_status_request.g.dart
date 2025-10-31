// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'update_audit_status_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UpdateAuditStatusRequest _$UpdateAuditStatusRequestFromJson(
  Map<String, dynamic> json,
) => UpdateAuditStatusRequest(
  auditId: (json['audit_id'] as num?)?.toInt(),
  creatorUserId: (json['creator_user_id'] as num?)?.toInt(),
);

Map<String, dynamic> _$UpdateAuditStatusRequestToJson(
  UpdateAuditStatusRequest instance,
) => <String, dynamic>{
  'audit_id': instance.auditId,
  'creator_user_id': instance.creatorUserId,
};
