import 'package:json_annotation/json_annotation.dart';

part 'update_audit_status_request.g.dart';

@JsonSerializable()
class UpdateAuditStatusRequest {
  @JsonKey(name: "audit_id")
  final int? auditId;
  @JsonKey(name: "creator_user_id")
  final int? creatorUserId;

  UpdateAuditStatusRequest({this.auditId, this.creatorUserId});

  factory UpdateAuditStatusRequest.fromJson(Map<String, dynamic> json) {
    return _$UpdateAuditStatusRequestFromJson(json);
  }

  Map<String, dynamic> toJson() {
    return _$UpdateAuditStatusRequestToJson(this);
  }
}
