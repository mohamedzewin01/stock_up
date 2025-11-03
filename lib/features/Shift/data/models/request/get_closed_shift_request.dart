import 'package:json_annotation/json_annotation.dart';

part 'get_closed_shift_request.g.dart';

@JsonSerializable()
class GetClosedShiftRequest {
  @JsonKey(name: "store_id")
  final int? storeId;
  @JsonKey(name: "user_id")
  final int? userId;

  GetClosedShiftRequest ({
    this.storeId,
    this.userId,
  });

  factory GetClosedShiftRequest.fromJson(Map<String, dynamic> json) {
    return _$GetClosedShiftRequestFromJson(json);
  }

  Map<String, dynamic> toJson() {
    return _$GetClosedShiftRequestToJson(this);
  }
}


