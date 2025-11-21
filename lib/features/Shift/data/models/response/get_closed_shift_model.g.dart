// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'get_closed_shift_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

GetClosedShiftModel _$GetClosedShiftModelFromJson(Map<String, dynamic> json) =>
    GetClosedShiftModel(
      status: json['status'] as String?,
      shifts: (json['shifts'] as List<dynamic>?)
          ?.map((e) => ShiftsClosed.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$GetClosedShiftModelToJson(
  GetClosedShiftModel instance,
) => <String, dynamic>{'status': instance.status, 'shifts': instance.shifts};

ShiftsClosed _$ShiftsClosedFromJson(Map<String, dynamic> json) => ShiftsClosed(
  shiftId: (json['shift_id'] as num?)?.toInt(),
  userId: (json['user_id'] as num?)?.toInt(),
  storeId: (json['store_id'] as num?)?.toInt(),
  startTime: json['start_time'] as String?,
  endTime: json['end_time'] as String?,
  openingBalance: json['opening_balance'] as String?,
  closingBalance: json['closing_balance'] as String?,
  status: json['status'] as String?,
  durationMinutes: (json['duration_minutes'] as num?)?.toInt(),
);

Map<String, dynamic> _$ShiftsClosedToJson(ShiftsClosed instance) =>
    <String, dynamic>{
      'shift_id': instance.shiftId,
      'user_id': instance.userId,
      'store_id': instance.storeId,
      'start_time': instance.startTime,
      'end_time': instance.endTime,
      'opening_balance': instance.openingBalance,
      'closing_balance': instance.closingBalance,
      'status': instance.status,
      'duration_minutes': instance.durationMinutes,
    };
