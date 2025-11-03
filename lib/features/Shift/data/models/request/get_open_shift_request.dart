import 'package:json_annotation/json_annotation.dart';

part 'get_open_shift_request.g.dart';

@JsonSerializable()
class GetOpenShiftRequest {
  @JsonKey(name: "user_id")
  final int? userId;

  GetOpenShiftRequest ({
    this.userId,
  });

  factory GetOpenShiftRequest.fromJson(Map<String, dynamic> json) {
    return _$GetOpenShiftRequestFromJson(json);
  }

  Map<String, dynamic> toJson() {
    return _$GetOpenShiftRequestToJson(this);
  }
}


