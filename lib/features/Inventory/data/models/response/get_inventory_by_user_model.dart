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
  final Data? data;

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
  @JsonKey(name: "workers")
  final List<Workers>? workers;

  Data({
    this.id,
    this.storeId,
    this.creatorUserId,
    this.auditDate,
    this.status,
    this.notes,
    this.workers,
  });

  factory Data.fromJson(Map<String, dynamic> json) {
    return _$DataFromJson(json);
  }

  Map<String, dynamic> toJson() {
    return _$DataToJson(this);
  }
}

@JsonSerializable()
class Workers {
  @JsonKey(name: "id")
  final int? id;
  @JsonKey(name: "first_name")
  final String? firstName;
  @JsonKey(name: "last_name")
  final String? lastName;
  @JsonKey(name: "phone_number")
  final String? phoneNumber;
  @JsonKey(name: "role")
  final String? role;
  @JsonKey(name: "profile_image")
  final dynamic? profileImage;
  @JsonKey(name: "is_active")
  final int? isActive;
  @JsonKey(name: "created_at")
  final String? createdAt;

  Workers({
    this.id,
    this.firstName,
    this.lastName,
    this.phoneNumber,
    this.role,
    this.profileImage,
    this.isActive,
    this.createdAt,
  });

  factory Workers.fromJson(Map<String, dynamic> json) {
    return _$WorkersFromJson(json);
  }

  Map<String, dynamic> toJson() {
    return _$WorkersToJson(this);
  }
}
