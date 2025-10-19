import 'package:json_annotation/json_annotation.dart';

part 'add_inventory_audit_users_request.g.dart';

@JsonSerializable()
class AddInventoryAuditUsersRequest {
  @JsonKey(name: "audit_id")
  final int? auditId;
  @JsonKey(name: "user_ids")
  final List<int>? userIds;

  AddInventoryAuditUsersRequest ({
    this.auditId,
    this.userIds,
  });

  factory AddInventoryAuditUsersRequest.fromJson(Map<String, dynamic> json) {
    return _$AddInventoryAuditUsersRequestFromJson(json);
  }

  Map<String, dynamic> toJson() {
    return _$AddInventoryAuditUsersRequestToJson(this);
  }
}


