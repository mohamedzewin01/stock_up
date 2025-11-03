// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'add_shift_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AddShiftRequest _$AddShiftRequestFromJson(Map<String, dynamic> json) =>
    AddShiftRequest(
      userId: (json['user_id'] as num?)?.toInt(),
      storeId: (json['store_id'] as num?)?.toInt(),
      openingBalance: (json['opening_balance'] as num?)?.toDouble(),
    );

Map<String, dynamic> _$AddShiftRequestToJson(AddShiftRequest instance) =>
    <String, dynamic>{
      'user_id': instance.userId,
      'store_id': instance.storeId,
      'opening_balance': instance.openingBalance,
    };
