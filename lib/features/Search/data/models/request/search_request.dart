import 'package:json_annotation/json_annotation.dart';

part 'search_request.g.dart';

@JsonSerializable()
class SearchRequest {
  @JsonKey(name: "store_id")
  final String? storeId;
  @JsonKey(name: "q")
  final String? q;
  @JsonKey(name: "page")
  final int? page;
  @JsonKey(name: "limit")
  final int? limit;

  SearchRequest ({
    this.storeId,
    this.q,
    this.page,
    this.limit,
  });

  factory SearchRequest.fromJson(Map<String, dynamic> json) {
    return _$SearchRequestFromJson(json);
  }

  Map<String, dynamic> toJson() {
    return _$SearchRequestToJson(this);
  }
}


