import 'package:json_annotation/json_annotation.dart';
import 'package:stock_up/features/Inventory/domain/entities/inventory_entities.dart';

part 'add_inventory_audit_users_model.g.dart';

@JsonSerializable()
class AddInventoryAuditUsersModel {
  @JsonKey(name: "status")
  final String? status;
  @JsonKey(name: "message")
  final String? message;
  @JsonKey(name: "added_users")
  final int? addedUsers;

  AddInventoryAuditUsersModel({this.status, this.message, this.addedUsers});

  factory AddInventoryAuditUsersModel.fromJson(Map<String, dynamic> json) {
    return _$AddInventoryAuditUsersModelFromJson(json);
  }

  Map<String, dynamic> toJson() {
    return _$AddInventoryAuditUsersModelToJson(this);
  }

  AddInventoryAuditUsersEntity toEntity() {
    return AddInventoryAuditUsersEntity(
      status: status,
      message: message,
      addedUsers: addedUsers,
    );
  }
}
