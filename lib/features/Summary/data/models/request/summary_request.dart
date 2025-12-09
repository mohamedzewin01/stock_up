import 'package:json_annotation/json_annotation.dart';

part 'summary_request.g.dart';

@JsonSerializable()
class SummaryRequest {
  @JsonKey(name: "store_id")
  final int? storeId;
  @JsonKey(name: "start_date")
  final String? startDate;
  @JsonKey(name: "end_date")
  final String? endDate;

  SummaryRequest({this.storeId, this.startDate, this.endDate});

  factory SummaryRequest.fromJson(Map<String, dynamic> json) {
    return _$SummaryRequestFromJson(json);
  }

  Map<String, dynamic> toJson() {
    return _$SummaryRequestToJson(this);
  }
}
