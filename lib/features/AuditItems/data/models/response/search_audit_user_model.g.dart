// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'search_audit_user_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SearchAuditUserModel _$SearchAuditUserModelFromJson(
  Map<String, dynamic> json,
) => SearchAuditUserModel(
  status: json['status'] as String?,
  message: json['message'] as String?,
  data: (json['data'] as List<dynamic>?)
      ?.map((e) => Data.fromJson(e as Map<String, dynamic>))
      .toList(),
);

Map<String, dynamic> _$SearchAuditUserModelToJson(
  SearchAuditUserModel instance,
) => <String, dynamic>{
  'status': instance.status,
  'message': instance.message,
  'data': instance.data,
};

Data _$DataFromJson(Map<String, dynamic> json) => Data(
  id: (json['id'] as num?)?.toInt(),
  auditId: (json['audit_id'] as num?)?.toInt(),
  userId: (json['user_id'] as num?)?.toInt(),
);

Map<String, dynamic> _$DataToJson(Data instance) => <String, dynamic>{
  'id': instance.id,
  'audit_id': instance.auditId,
  'user_id': instance.userId,
};
