// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'get_all_users_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

GetAllUsersModel _$GetAllUsersModelFromJson(Map<String, dynamic> json) =>
    GetAllUsersModel(
      status: json['status'] as String?,
      results: (json['results'] as List<dynamic>?)
          ?.map((e) => User.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$GetAllUsersModelToJson(GetAllUsersModel instance) =>
    <String, dynamic>{'status': instance.status, 'results': instance.results};

User _$UserFromJson(Map<String, dynamic> json) => User(
  id: (json['id'] as num?)?.toInt(),
  firstName: json['first_name'] as String?,
  lastName: json['last_name'] as String?,
  phoneNumber: json['phone_number'] as String?,
  role: json['role'] as String?,
  isActive: (json['is_active'] as num?)?.toInt(),
  profileImage: json['profile_image'] as String?,
  createdAt: json['created_at'] as String?,
  updatedAt: json['updated_at'] as String?,
);

Map<String, dynamic> _$UserToJson(User instance) => <String, dynamic>{
  'id': instance.id,
  'first_name': instance.firstName,
  'last_name': instance.lastName,
  'phone_number': instance.phoneNumber,
  'role': instance.role,
  'is_active': instance.isActive,
  'profile_image': instance.profileImage,
  'created_at': instance.createdAt,
  'updated_at': instance.updatedAt,
};
