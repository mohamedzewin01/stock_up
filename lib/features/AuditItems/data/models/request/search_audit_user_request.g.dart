// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'search_audit_user_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SearchAuditUserRequest _$SearchAuditUserRequestFromJson(
  Map<String, dynamic> json,
) => SearchAuditUserRequest(
  userId: (json['user_id'] as num?)?.toInt(),
  storeId: (json['store_id'] as num?)?.toInt(),
);

Map<String, dynamic> _$SearchAuditUserRequestToJson(
  SearchAuditUserRequest instance,
) => <String, dynamic>{
  'user_id': instance.userId,
  'store_id': instance.storeId,
};
