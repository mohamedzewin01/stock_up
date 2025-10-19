import 'package:json_annotation/json_annotation.dart';
import 'package:stock_up/features/Inventory/domain/entities/inventory_entities.dart';

part 'get_all_users_model.g.dart';

@JsonSerializable()
class GetAllUsersModel {
  @JsonKey(name: "status")
  final String? status;
  @JsonKey(name: "results")
  final List<User>? results;

  GetAllUsersModel({this.status, this.results});

  factory GetAllUsersModel.fromJson(Map<String, dynamic> json) {
    return _$GetAllUsersModelFromJson(json);
  }

  Map<String, dynamic> toJson() {
    return _$GetAllUsersModelToJson(this);
  }

  GetAllUsersEntity toEntity() {
    return GetAllUsersEntity(status: status, users: results);
  }
}

@JsonSerializable()
class User {
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
  @JsonKey(name: "is_active")
  final int? isActive;
  @JsonKey(name: "profile_image")
  final String? profileImage;
  @JsonKey(name: "created_at")
  final String? createdAt;
  @JsonKey(name: "updated_at")
  final String? updatedAt;

  User({
    this.id,
    this.firstName,
    this.lastName,
    this.phoneNumber,
    this.role,
    this.isActive,
    this.profileImage,
    this.createdAt,
    this.updatedAt,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return _$UserFromJson(json);
  }

  Map<String, dynamic> toJson() {
    return _$UserToJson(this);
  }
}
