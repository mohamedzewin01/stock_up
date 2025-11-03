import 'package:json_annotation/json_annotation.dart';
import 'package:stock_up/features/Shift/domain/entities/shift_entity.dart';

part 'get_open_shift_model.g.dart';

@JsonSerializable()
class GetOpenShiftModel {
  @JsonKey(name: "status")
  final String? status;
  @JsonKey(name: "user")
  final UserShift? user;
  @JsonKey(name: "shift")
  final ShiftInfo? shift;

  GetOpenShiftModel({this.status, this.user, this.shift});

  factory GetOpenShiftModel.fromJson(Map<String, dynamic> json) {
    return _$GetOpenShiftModelFromJson(json);
  }

  Map<String, dynamic> toJson() {
    return _$GetOpenShiftModelToJson(this);
  }

  GetOpenShiftEntity toEntity() {
    return GetOpenShiftEntity(status: status, user: user, shift: shift);
  }
}

@JsonSerializable()
class UserShift {
  @JsonKey(name: "id")
  final int? id;
  @JsonKey(name: "first_name")
  final String? firstName;
  @JsonKey(name: "last_name")
  final String? lastName;
  @JsonKey(name: "phone_number")
  final String? phoneNumber;
  @JsonKey(name: "role")
  final String? role;
  @JsonKey(name: "profile_image")
  final dynamic? profileImage;

  UserShift({
    this.id,
    this.firstName,
    this.lastName,
    this.phoneNumber,
    this.role,
    this.profileImage,
  });

  factory UserShift.fromJson(Map<String, dynamic> json) {
    return _$UserShiftFromJson(json);
  }

  Map<String, dynamic> toJson() {
    return _$UserShiftToJson(this);
  }
}

@JsonSerializable()
class ShiftInfo {
  @JsonKey(name: "shift_id")
  final int? shiftId;
  @JsonKey(name: "store_id")
  final int? storeId;
  @JsonKey(name: "start_time")
  final String? startTime;
  @JsonKey(name: "end_time")
  final dynamic? endTime;
  @JsonKey(name: "opening_balance")
  final String? openingBalance;
  @JsonKey(name: "closing_balance")
  final String? closingBalance;
  @JsonKey(name: "status")
  final String? status;
  @JsonKey(name: "duration_minutes")
  final dynamic? durationMinutes;

  ShiftInfo({
    this.shiftId,
    this.storeId,
    this.startTime,
    this.endTime,
    this.openingBalance,
    this.closingBalance,
    this.status,
    this.durationMinutes,
  });

  factory ShiftInfo.fromJson(Map<String, dynamic> json) {
    return _$ShiftInfoFromJson(json);
  }

  Map<String, dynamic> toJson() {
    return _$ShiftInfoToJson(this);
  }
}
