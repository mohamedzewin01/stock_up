import 'package:json_annotation/json_annotation.dart';
import 'package:stock_up/features/Inventory/domain/entities/inventory_entities.dart';

part 'get_inventory_by_user_model.g.dart';

@JsonSerializable()
class GetInventoryByUserModel {
  @JsonKey(name: "status")
  final String? status;
  @JsonKey(name: "message")
  final String? message;
  @JsonKey(name: "data")
  final List<Data>? data;

  GetInventoryByUserModel({this.status, this.message, this.data});

  factory GetInventoryByUserModel.fromJson(Map<String, dynamic> json) {
    return _$GetInventoryByUserModelFromJson(json);
  }

  Map<String, dynamic> toJson() {
    return _$GetInventoryByUserModelToJson(this);
  }

  GetInventoryByUserEntity toEntity() {
    return GetInventoryByUserEntity(
      status: status,
      message: message,
      data: data,
    );
  }
}

@JsonSerializable()
class Data {
  @JsonKey(name: "id")
  final int? id;
  @JsonKey(name: "store_id")
  final int? storeId;
  @JsonKey(name: "creator_user_id")
  final int? creatorUserId;
  @JsonKey(name: "audit_date")
  final String? auditDate;
  @JsonKey(name: "status")
  final String? status;
  @JsonKey(name: "notes")
  final String? notes;

  Data({
    this.id,
    this.storeId,
    this.creatorUserId,
    this.auditDate,
    this.status,
    this.notes,
  });

  factory Data.fromJson(Map<String, dynamic> json) {
    return _$DataFromJson(json);
  }

  Map<String, dynamic> toJson() {
    return _$DataToJson(this);
  }
}
