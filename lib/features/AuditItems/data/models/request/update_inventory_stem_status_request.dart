import 'package:json_annotation/json_annotation.dart';

part 'update_inventory_stem_status_request.g.dart';

@JsonSerializable()
class UpdateInventoryStatusRequest {
  @JsonKey(name: "audit_id")
  final int? auditId;
  @JsonKey(name: "item_id")
  final int? itemId;
  @JsonKey(name: "status")
  final String? status;

  UpdateInventoryStatusRequest({this.auditId, this.itemId, this.status});

  factory UpdateInventoryStatusRequest.fromJson(Map<String, dynamic> json) {
    return _$UpdateInventoryStatusRequestFromJson(json);
  }

  Map<String, dynamic> toJson() {
    return _$UpdateInventoryStatusRequestToJson(this);
  }
}
