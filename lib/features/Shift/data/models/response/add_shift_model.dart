import 'package:json_annotation/json_annotation.dart';
import 'package:stock_up/features/Shift/domain/entities/shift_entity.dart';

part 'add_shift_model.g.dart';

@JsonSerializable()
class AddShiftModel {
  @JsonKey(name: "status")
  final String? status;
  @JsonKey(name: "shift")
  final Shift? shift;

  AddShiftModel({this.status, this.shift});

  factory AddShiftModel.fromJson(Map<String, dynamic> json) {
    return _$AddShiftModelFromJson(json);
  }

  Map<String, dynamic> toJson() {
    return _$AddShiftModelToJson(this);
  }

  AddShiftEntity toEntity() {
    return AddShiftEntity(status: status, shift: shift);
  }
}

@JsonSerializable()
class Shift {
  @JsonKey(name: "shift_id")
  final int? shiftId;
  @JsonKey(name: "user_id")
  final int? userId;
  @JsonKey(name: "store_id")
  final int? storeId;
  @JsonKey(name: "start_time")
  final String? startTime;
  @JsonKey(name: "end_time")
  final String? endTime;
  @JsonKey(name: "opening_balance")
  final String? openingBalance;
  @JsonKey(name: "closing_balance")
  final String? closingBalance;
  @JsonKey(name: "status")
  final String? status;

  Shift({
    this.shiftId,
    this.userId,
    this.storeId,
    this.startTime,
    this.endTime,
    this.openingBalance,
    this.closingBalance,
    this.status,
  });

  factory Shift.fromJson(Map<String, dynamic> json) {
    return _$ShiftFromJson(json);
  }

  Map<String, dynamic> toJson() {
    return _$ShiftToJson(this);
  }
}
