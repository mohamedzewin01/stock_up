// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'get_inventory_by_user_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

GetInventoryByUserModel _$GetInventoryByUserModelFromJson(
  Map<String, dynamic> json,
) => GetInventoryByUserModel(
  status: json['status'] as String?,
  message: json['message'] as String?,
  data: json['data'] == null
      ? null
      : Data.fromJson(json['data'] as Map<String, dynamic>),
);

Map<String, dynamic> _$GetInventoryByUserModelToJson(
  GetInventoryByUserModel instance,
) => <String, dynamic>{
  'status': instance.status,
  'message': instance.message,
  'data': instance.data,
};

Data _$DataFromJson(Map<String, dynamic> json) => Data(
  id: (json['id'] as num?)?.toInt(),
  storeId: (json['store_id'] as num?)?.toInt(),
  creatorUserId: (json['creator_user_id'] as num?)?.toInt(),
  auditDate: json['audit_date'] as String?,
  status: json['status'] as String?,
  notes: json['notes'] as String?,
  workers: (json['workers'] as List<dynamic>?)
      ?.map((e) => Workers.fromJson(e as Map<String, dynamic>))
      .toList(),
);

Map<String, dynamic> _$DataToJson(Data instance) => <String, dynamic>{
  'id': instance.id,
  'store_id': instance.storeId,
  'creator_user_id': instance.creatorUserId,
  'audit_date': instance.auditDate,
  'status': instance.status,
  'notes': instance.notes,
  'workers': instance.workers,
};

Workers _$WorkersFromJson(Map<String, dynamic> json) => Workers(
  id: (json['id'] as num?)?.toInt(),
  firstName: json['first_name'] as String?,
  lastName: json['last_name'] as String?,
  phoneNumber: json['phone_number'] as String?,
  role: json['role'] as String?,
  profileImage: json['profile_image'],
  isActive: (json['is_active'] as num?)?.toInt(),
  createdAt: json['created_at'] as String?,
);

Map<String, dynamic> _$WorkersToJson(Workers instance) => <String, dynamic>{
  'id': instance.id,
  'first_name': instance.firstName,
  'last_name': instance.lastName,
  'phone_number': instance.phoneNumber,
  'role': instance.role,
  'profile_image': instance.profileImage,
  'is_active': instance.isActive,
  'created_at': instance.createdAt,
};
