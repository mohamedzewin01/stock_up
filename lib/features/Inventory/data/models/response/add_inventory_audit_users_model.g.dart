// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'add_inventory_audit_users_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AddInventoryAuditUsersModel _$AddInventoryAuditUsersModelFromJson(
  Map<String, dynamic> json,
) => AddInventoryAuditUsersModel(
  status: json['status'] as String?,
  message: json['message'] as String?,
  addedUsers: (json['added_users'] as num?)?.toInt(),
);

Map<String, dynamic> _$AddInventoryAuditUsersModelToJson(
  AddInventoryAuditUsersModel instance,
) => <String, dynamic>{
  'status': instance.status,
  'message': instance.message,
  'added_users': instance.addedUsers,
};
