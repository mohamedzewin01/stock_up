import 'package:json_annotation/json_annotation.dart';
import 'package:stock_up/features/Shift/domain/entities/shift_entity.dart';

part 'get_closed_shift_model.g.dart';

@JsonSerializable()
class GetClosedShiftModel {
  @JsonKey(name: "status")
  final String? status;
  @JsonKey(name: "shifts")
  final List<ShiftsClosed>? shifts;

  GetClosedShiftModel({this.status, this.shifts});

  factory GetClosedShiftModel.fromJson(Map<String, dynamic> json) {
    return _$GetClosedShiftModelFromJson(json);
  }

  Map<String, dynamic> toJson() {
    return _$GetClosedShiftModelToJson(this);
  }

  GetClosedShiftEntity toEntity() {
    return GetClosedShiftEntity(status: status, shifts: shifts);
  }
}

@JsonSerializable()
class ShiftsClosed {
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
  @JsonKey(name: "duration_minutes")
  final int? durationMinutes;

  ShiftsClosed({
    this.shiftId,
    this.userId,
    this.storeId,
    this.startTime,
    this.endTime,
    this.openingBalance,
    this.closingBalance,
    this.status,
    this.durationMinutes,
  });

  factory ShiftsClosed.fromJson(Map<String, dynamic> json) {
    return _$ShiftsClosedFromJson(json);
  }

  Map<String, dynamic> toJson() {
    return _$ShiftsClosedToJson(this);
  }
}
