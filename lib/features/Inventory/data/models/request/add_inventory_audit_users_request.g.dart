// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'add_inventory_audit_users_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AddInventoryAuditUsersRequest _$AddInventoryAuditUsersRequestFromJson(
  Map<String, dynamic> json,
) => AddInventoryAuditUsersRequest(
  auditId: (json['audit_id'] as num?)?.toInt(),
  userIds: (json['user_ids'] as List<dynamic>?)
      ?.map((e) => (e as num).toInt())
      .toList(),
);

Map<String, dynamic> _$AddInventoryAuditUsersRequestToJson(
  AddInventoryAuditUsersRequest instance,
) => <String, dynamic>{
  'audit_id': instance.auditId,
  'user_ids': instance.userIds,
};
