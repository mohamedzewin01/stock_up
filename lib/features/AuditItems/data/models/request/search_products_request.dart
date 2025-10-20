import 'package:json_annotation/json_annotation.dart';

part 'search_products_request.g.dart';

@JsonSerializable()
class SearchProductsRequest {
  @JsonKey(name: "store_id")
  final String? storeId;
  @JsonKey(name: "q")
  final String? q;
  @JsonKey(name: "page")
  final int? page;
  @JsonKey(name: "limit")
  final int? limit;

  SearchProductsRequest({this.storeId, this.q, this.page, this.limit});

  factory SearchProductsRequest.fromJson(Map<String, dynamic> json) {
    return _$SearchProductsRequestFromJson(json);
  }

  Map<String, dynamic> toJson() {
    return _$SearchProductsRequestToJson(this);
  }
}
