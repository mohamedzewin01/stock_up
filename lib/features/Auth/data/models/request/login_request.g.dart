// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'login_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

LoginRequest _$LoginRequestFromJson(Map<String, dynamic> json) => LoginRequest(
  mobileNumber: json['mobile_number'] as String?,
  password: json['password'] as String?,
  storeId: (json['store_id'] as num?)?.toInt(),
);

Map<String, dynamic> _$LoginRequestToJson(LoginRequest instance) =>
    <String, dynamic>{
      'mobile_number': instance.mobileNumber,
      'password': instance.password,
      'store_id': instance.storeId,
    };
