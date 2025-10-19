import 'package:json_annotation/json_annotation.dart';

part 'create_inventory_audit_request.g.dart';

@JsonSerializable()
class CreateInventoryAuditRequest {
  @JsonKey(name: "store_id")
  final int? storeId;
  @JsonKey(name: "creator_user_id")
  final int? creatorUserId;
  @JsonKey(name: "notes")
  final String? notes;

  CreateInventoryAuditRequest ({
    this.storeId,
    this.creatorUserId,
    this.notes,
  });

  factory CreateInventoryAuditRequest.fromJson(Map<String, dynamic> json) {
    return _$CreateInventoryAuditRequestFromJson(json);
  }

  Map<String, dynamic> toJson() {
    return _$CreateInventoryAuditRequestToJson(this);
  }
}


