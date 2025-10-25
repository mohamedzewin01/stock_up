import 'package:json_annotation/json_annotation.dart';

part 'get_inventory_by_user_request.g.dart';

@JsonSerializable()
class GetInventoryByUserRequest {
  @JsonKey(name: "creator_user_id")
  final int? creatorUserId;
  @JsonKey(name: "store_id")
  final int? storeId;

  GetInventoryByUserRequest({this.creatorUserId, this.storeId});

  factory GetInventoryByUserRequest.fromJson(Map<String, dynamic> json) {
    return _$GetInventoryByUserRequestFromJson(json);
  }

  Map<String, dynamic> toJson() {
    return _$GetInventoryByUserRequestToJson(this);
  }
}
