// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'summary_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SummaryRequest _$SummaryRequestFromJson(Map<String, dynamic> json) =>
    SummaryRequest(
      storeId: (json['store_id'] as num?)?.toInt(),
      operationDate: json['operation_date'] as String?,
    );

Map<String, dynamic> _$SummaryRequestToJson(SummaryRequest instance) =>
    <String, dynamic>{
      'store_id': instance.storeId,
      'operation_date': instance.operationDate,
    };
