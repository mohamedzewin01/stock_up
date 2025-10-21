import 'package:json_annotation/json_annotation.dart';
import 'package:stock_up/features/Inventory/domain/entities/inventory_entities.dart';

part 'update_audit_status_model.g.dart';

@JsonSerializable()
class UpdateAuditStatusModel {
  @JsonKey(name: "status")
  final String? status;
  @JsonKey(name: "message")
  final String? message;
  @JsonKey(name: "audit_id")
  final int? auditId;
  @JsonKey(name: "new_status")
  final String? newStatus;
  @JsonKey(name: "pending_items_count")
  final int? pendingItemsCount;

  UpdateAuditStatusModel({
    this.status,
    this.message,
    this.auditId,
    this.newStatus,
    this.pendingItemsCount,
  });

  factory UpdateAuditStatusModel.fromJson(Map<String, dynamic> json) {
    return _$UpdateAuditStatusModelFromJson(json);
  }

  Map<String, dynamic> toJson() {
    return _$UpdateAuditStatusModelToJson(this);
  }

  UpdateAuditStatusEntity toEntity() {
    return UpdateAuditStatusEntity(
      status: status,
      message: message,
      auditId: auditId,

      newStatus: newStatus,
      pendingItemsCount: pendingItemsCount,
    );
  }
}
