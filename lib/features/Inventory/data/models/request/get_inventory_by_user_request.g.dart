// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'get_inventory_by_user_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

GetInventoryByUserRequest _$GetInventoryByUserRequestFromJson(
  Map<String, dynamic> json,
) => GetInventoryByUserRequest(
  creatorUserId: (json['creator_user_id'] as num?)?.toInt(),
  storeId: (json['store_id'] as num?)?.toInt(),
);

Map<String, dynamic> _$GetInventoryByUserRequestToJson(
  GetInventoryByUserRequest instance,
) => <String, dynamic>{
  'creator_user_id': instance.creatorUserId,
  'store_id': instance.storeId,
};
