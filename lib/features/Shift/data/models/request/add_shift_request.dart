import 'package:json_annotation/json_annotation.dart';

part 'add_shift_request.g.dart';

@JsonSerializable()
class AddShiftRequest {
  @JsonKey(name: "user_id")
  final int? userId;
  @JsonKey(name: "store_id")
  final int? storeId;
  @JsonKey(name: "opening_balance")
  final double? openingBalance;

  AddShiftRequest({this.userId, this.storeId, this.openingBalance});

  factory AddShiftRequest.fromJson(Map<String, dynamic> json) {
    return _$AddShiftRequestFromJson(json);
  }

  Map<String, dynamic> toJson() {
    return _$AddShiftRequestToJson(this);
  }
}
