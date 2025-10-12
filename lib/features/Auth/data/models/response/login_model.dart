import 'package:json_annotation/json_annotation.dart';
import 'package:stock_up/features/Auth/domain/entities/login_entity.dart';

part 'login_model.g.dart';

@JsonSerializable()
class LoginModel {
  @JsonKey(name: "status")
  final String? status;
  @JsonKey(name: "message")
  final String? message;
  @JsonKey(name: "user")
  final User? user;

  LoginModel({this.status, this.user, this.message});

  factory LoginModel.fromJson(Map<String, dynamic> json) {
    return _$LoginModelFromJson(json);
  }

  Map<String, dynamic> toJson() {
    return _$LoginModelToJson(this);
  }

  LoginEntity toEntity() {
    return LoginEntity(
      status: status,
      user: user?.toEntity(),
      message: message,
    );
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
  @JsonKey(name: "profile_image")
  final String? profileImage;

  User({
    this.id,
    this.firstName,
    this.lastName,
    this.role,
    this.profileImage,
    this.phoneNumber,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return _$UserFromJson(json);
  }

  Map<String, dynamic> toJson() {
    return _$UserToJson(this);
  }

  UserEntity toEntity() {
    return UserEntity(
      id: id,
      firstName: firstName,
      lastName: lastName,
      role: role,
      profileImage: profileImage,
      phoneNumber: phoneNumber,
    );
  }
}
