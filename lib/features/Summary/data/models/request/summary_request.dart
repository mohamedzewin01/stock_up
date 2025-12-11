import 'package:json_annotation/json_annotation.dart';

part 'summary_request.g.dart';

@JsonSerializable()
class SummaryRequest {
  @JsonKey(name: "store_id")
  final int? storeId;

  @JsonKey(name: "operation_date")
  final String? operationDate; //2025-12-10

  SummaryRequest({this.storeId, this.operationDate});

  factory SummaryRequest.fromJson(Map<String, dynamic> json) {
    return _$SummaryRequestFromJson(json);
  }

  Map<String, dynamic> toJson() {
    return _$SummaryRequestToJson(this);
  }
}
