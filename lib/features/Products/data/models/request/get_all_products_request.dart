import 'package:json_annotation/json_annotation.dart';

part 'get_all_products_request.g.dart';

@JsonSerializable()
class GetAllProductsRequest {
  @JsonKey(name: "store_id")
  final String? storeId;

  GetAllProductsRequest ({
    this.storeId,
  });

  factory GetAllProductsRequest.fromJson(Map<String, dynamic> json) {
    return _$GetAllProductsRequestFromJson(json);
  }

  Map<String, dynamic> toJson() {
    return _$GetAllProductsRequestToJson(this);
  }
}


