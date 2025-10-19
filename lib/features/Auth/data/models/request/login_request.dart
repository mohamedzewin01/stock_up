import 'package:json_annotation/json_annotation.dart';

part 'login_request.g.dart';

@JsonSerializable()
class LoginRequest {
  @JsonKey(name: "mobile_number")
  final String? mobileNumber;
  @JsonKey(name: "password")
  final String? password;
  @JsonKey(name: "store_id")
  final int? storeId;

  LoginRequest({this.mobileNumber, this.password, this.storeId});

  factory LoginRequest.fromJson(Map<String, dynamic> json) {
    return _$LoginRequestFromJson(json);
  }

  Map<String, dynamic> toJson() {
    return _$LoginRequestToJson(this);
  }
}
