import 'package:json_annotation/json_annotation.dart';
import 'package:stock_up/features/Inventory/domain/entities/inventory_entities.dart';

part 'create_inventory_audit_model.g.dart';

@JsonSerializable()
class CreateInventoryAuditModel {
  @JsonKey(name: "status")
  final String? status;
  @JsonKey(name: "message")
  final String? message;
  @JsonKey(name: "audit")
  final Audit? audit;

  CreateInventoryAuditModel({this.status, this.message, this.audit});

  factory CreateInventoryAuditModel.fromJson(Map<String, dynamic> json) {
    return _$CreateInventoryAuditModelFromJson(json);
  }

  Map<String, dynamic> toJson() {
    return _$CreateInventoryAuditModelToJson(this);
  }

  CreateInventoryAuditEntity toEntity() {
    return CreateInventoryAuditEntity(
      status: status,
      message: message,
      audit: audit,
    );
  }
}

@JsonSerializable()
class Audit {
  @JsonKey(name: "id")
  final int? id;
  @JsonKey(name: "store_id")
  final int? storeId;
  @JsonKey(name: "store_name")
  final String? storeName;
  @JsonKey(name: "creator_user_id")
  final int? creatorUserId;
  @JsonKey(name: "first_name")
  final String? firstName;
  @JsonKey(name: "last_name")
  final String? lastName;
  @JsonKey(name: "status")
  final String? status;
  @JsonKey(name: "audit_date")
  final String? auditDate;
  @JsonKey(name: "notes")
  final String? notes;

  Audit({
    this.id,
    this.storeId,
    this.storeName,
    this.creatorUserId,
    this.firstName,
    this.lastName,
    this.status,
    this.auditDate,
    this.notes,
  });

  factory Audit.fromJson(Map<String, dynamic> json) {
    return _$AuditFromJson(json);
  }

  Map<String, dynamic> toJson() {
    return _$AuditToJson(this);
  }
}
