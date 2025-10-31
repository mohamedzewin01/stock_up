// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'update_inventory_stem_status_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UpdateInventoryStatusRequest _$UpdateInventoryStatusRequestFromJson(
  Map<String, dynamic> json,
) => UpdateInventoryStatusRequest(
  auditId: (json['audit_id'] as num?)?.toInt(),
  itemId: (json['item_id'] as num?)?.toInt(),
  status: json['status'] as String?,
);

Map<String, dynamic> _$UpdateInventoryStatusRequestToJson(
  UpdateInventoryStatusRequest instance,
) => <String, dynamic>{
  'audit_id': instance.auditId,
  'item_id': instance.itemId,
  'status': instance.status,
};
