// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'get_open_shift_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

GetOpenShiftModel _$GetOpenShiftModelFromJson(Map<String, dynamic> json) =>
    GetOpenShiftModel(
      status: json['status'] as String?,
      user: json['user'] == null
          ? null
          : UserShift.fromJson(json['user'] as Map<String, dynamic>),
      shift: json['shift'] == null
          ? null
          : ShiftInfo.fromJson(json['shift'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$GetOpenShiftModelToJson(GetOpenShiftModel instance) =>
    <String, dynamic>{
      'status': instance.status,
      'user': instance.user,
      'shift': instance.shift,
    };

UserShift _$UserShiftFromJson(Map<String, dynamic> json) => UserShift(
  id: (json['id'] as num?)?.toInt(),
  firstName: json['first_name'] as String?,
  lastName: json['last_name'] as String?,
  phoneNumber: json['phone_number'] as String?,
  role: json['role'] as String?,
  profileImage: json['profile_image'],
);

Map<String, dynamic> _$UserShiftToJson(UserShift instance) => <String, dynamic>{
  'id': instance.id,
  'first_name': instance.firstName,
  'last_name': instance.lastName,
  'phone_number': instance.phoneNumber,
  'role': instance.role,
  'profile_image': instance.profileImage,
};

ShiftInfo _$ShiftInfoFromJson(Map<String, dynamic> json) => ShiftInfo(
  shiftId: (json['shift_id'] as num?)?.toInt(),
  storeId: (json['store_id'] as num?)?.toInt(),
  startTime: json['start_time'] as String?,
  endTime: json['end_time'],
  openingBalance: json['opening_balance'] as String?,
  closingBalance: json['closing_balance'] as String?,
  status: json['status'] as String?,
  durationMinutes: json['duration_minutes'],
);

Map<String, dynamic> _$ShiftInfoToJson(ShiftInfo instance) => <String, dynamic>{
  'shift_id': instance.shiftId,
  'store_id': instance.storeId,
  'start_time': instance.startTime,
  'end_time': instance.endTime,
  'opening_balance': instance.openingBalance,
  'closing_balance': instance.closingBalance,
  'status': instance.status,
  'duration_minutes': instance.durationMinutes,
};
