import 'package:json_annotation/json_annotation.dart';

part 'add_inventory_audit_items_request.g.dart';

@JsonSerializable()
class AddInventoryAuditItemsRequest {
  @JsonKey(name: "audit_id")
  final int? auditId;
  @JsonKey(name: "product_id")
  final int? productId;
  @JsonKey(name: "user_id")
  final int? userId;
  @JsonKey(name: "quantity")
  final int? quantity;
  @JsonKey(name: "notes")
  final String? notes;

  AddInventoryAuditItemsRequest ({
    this.auditId,
    this.productId,
    this.userId,
    this.quantity,
    this.notes,
  });

  factory AddInventoryAuditItemsRequest.fromJson(Map<String, dynamic> json) {
    return _$AddInventoryAuditItemsRequestFromJson(json);
  }

  Map<String, dynamic> toJson() {
    return _$AddInventoryAuditItemsRequestToJson(this);
  }
}


