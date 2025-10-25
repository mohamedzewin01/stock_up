import 'package:json_annotation/json_annotation.dart';

part 'search_audit_user_request.g.dart';

@JsonSerializable()
class SearchAuditUserRequest {
  @JsonKey(name: "user_id")
  final int? userId;
  @JsonKey(name: "store_id")
  final int? storeId;

  SearchAuditUserRequest({this.userId, this.storeId});

  factory SearchAuditUserRequest.fromJson(Map<String, dynamic> json) {
    return _$SearchAuditUserRequestFromJson(json);
  }

  Map<String, dynamic> toJson() {
    return _$SearchAuditUserRequestToJson(this);
  }
}
