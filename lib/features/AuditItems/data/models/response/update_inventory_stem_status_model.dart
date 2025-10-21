import 'package:json_annotation/json_annotation.dart';
import 'package:stock_up/features/AuditItems/domain/entities/audit_items_entities.dart';

part 'update_inventory_stem_status_model.g.dart';

@JsonSerializable()
class UpdateInventoryStatusModel {
  @JsonKey(name: "status")
  final String? status;
  @JsonKey(name: "message")
  final String? message;
  @JsonKey(name: "audit_id")
  final int? auditId;
  @JsonKey(name: "item_id")
  final int? itemId;
  @JsonKey(name: "new_status")
  final String? newStatus;

  UpdateInventoryStatusModel({
    this.status,
    this.message,
    this.auditId,
    this.itemId,
    this.newStatus,
  });

  factory UpdateInventoryStatusModel.fromJson(Map<String, dynamic> json) {
    return _$UpdateInventoryStatusModelFromJson(json);
  }

  Map<String, dynamic> toJson() {
    return _$UpdateInventoryStatusModelToJson(this);
  }

  UpdateInventoryStatusEntity toEntity() {
    return UpdateInventoryStatusEntity(
      status: status,
      message: message,
      auditId: auditId,
      itemId: itemId,
      newStatus: newStatus,
    );
  }
}
