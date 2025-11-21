// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'get_closed_shift_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

GetClosedShiftRequest _$GetClosedShiftRequestFromJson(
  Map<String, dynamic> json,
) => GetClosedShiftRequest(
  storeId: (json['store_id'] as num?)?.toInt(),
  userId: (json['user_id'] as num?)?.toInt(),
);

Map<String, dynamic> _$GetClosedShiftRequestToJson(
  GetClosedShiftRequest instance,
) => <String, dynamic>{
  'store_id': instance.storeId,
  'user_id': instance.userId,
};
