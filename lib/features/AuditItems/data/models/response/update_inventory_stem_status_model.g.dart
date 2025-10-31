// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'update_inventory_stem_status_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UpdateInventoryStatusModel _$UpdateInventoryStatusModelFromJson(
  Map<String, dynamic> json,
) => UpdateInventoryStatusModel(
  status: json['status'] as String?,
  message: json['message'] as String?,
  auditId: (json['audit_id'] as num?)?.toInt(),
  itemId: (json['item_id'] as num?)?.toInt(),
  newStatus: json['new_status'] as String?,
);

Map<String, dynamic> _$UpdateInventoryStatusModelToJson(
  UpdateInventoryStatusModel instance,
) => <String, dynamic>{
  'status': instance.status,
  'message': instance.message,
  'audit_id': instance.auditId,
  'item_id': instance.itemId,
  'new_status': instance.newStatus,
};
