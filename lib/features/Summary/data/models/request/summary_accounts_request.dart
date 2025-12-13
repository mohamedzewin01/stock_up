import 'package:json_annotation/json_annotation.dart';

part 'summary_accounts_request.g.dart';

@JsonSerializable()
class SummaryAccountsRequest {
  @JsonKey(name: "store_id")
  final int? storeId;
  @JsonKey(name: "account_type") // اخرى - مورد - عميل
  final String? accountType;
  @JsonKey(name: "q")
  final String? q;
  @JsonKey(name: "page")
  final int? page;
  @JsonKey(name: "limit")
  final int? limit;
  @JsonKey(name: "hide_zero")
  final bool? hideZero;

  SummaryAccountsRequest({
    this.storeId,
    this.accountType,
    this.q,
    this.page,
    this.limit,
    this.hideZero,
  });

  factory SummaryAccountsRequest.fromJson(Map<String, dynamic> json) {
    return _$SummaryAccountsRequestFromJson(json);
  }

  Map<String, dynamic> toJson() {
    return _$SummaryAccountsRequestToJson(this);
  }
}
