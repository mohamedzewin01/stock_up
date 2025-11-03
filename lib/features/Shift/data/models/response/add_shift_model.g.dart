// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'add_shift_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AddShiftModel _$AddShiftModelFromJson(Map<String, dynamic> json) =>
    AddShiftModel(
      status: json['status'] as String?,
      shift: json['shift'] == null
          ? null
          : Shift.fromJson(json['shift'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$AddShiftModelToJson(AddShiftModel instance) =>
    <String, dynamic>{'status': instance.status, 'shift': instance.shift};

Shift _$ShiftFromJson(Map<String, dynamic> json) => Shift(
  shiftId: (json['shift_id'] as num?)?.toInt(),
  userId: (json['user_id'] as num?)?.toInt(),
  storeId: (json['store_id'] as num?)?.toInt(),
  startTime: json['start_time'] as String?,
  endTime: json['end_time'] as String?,
  openingBalance: json['opening_balance'] as String?,
  closingBalance: json['closing_balance'] as String?,
  status: json['status'] as String?,
);

Map<String, dynamic> _$ShiftToJson(Shift instance) => <String, dynamic>{
  'shift_id': instance.shiftId,
  'user_id': instance.userId,
  'store_id': instance.storeId,
  'start_time': instance.startTime,
  'end_time': instance.endTime,
  'opening_balance': instance.openingBalance,
  'closing_balance': instance.closingBalance,
  'status': instance.status,
};
