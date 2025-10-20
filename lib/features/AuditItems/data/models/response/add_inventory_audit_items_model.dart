import 'package:json_annotation/json_annotation.dart';
import 'package:stock_up/features/AuditItems/domain/entities/audit_items_entities.dart';

part 'add_inventory_audit_items_model.g.dart';

@JsonSerializable()
class AddInventoryAuditItemsModel {
  @JsonKey(name: "status")
  final String? status;
  @JsonKey(name: "message")
  final String? message;
  @JsonKey(name: "version")
  final int? version;
  @JsonKey(name: "created_at")
  final String? createdAt;

  AddInventoryAuditItemsModel({
    this.status,
    this.message,
    this.version,
    this.createdAt,
  });

  factory AddInventoryAuditItemsModel.fromJson(Map<String, dynamic> json) {
    return _$AddInventoryAuditItemsModelFromJson(json);
  }

  Map<String, dynamic> toJson() {
    return _$AddInventoryAuditItemsModelToJson(this);
  }

  AddInventoryAuditItemsEntity toEntity() {
    return AddInventoryAuditItemsEntity(
      status: status,
      message: message,
      version: version,
      createdAt: createdAt,
    );
  }
}
