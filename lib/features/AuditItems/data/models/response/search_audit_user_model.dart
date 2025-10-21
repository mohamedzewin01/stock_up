import 'package:json_annotation/json_annotation.dart';
import 'package:stock_up/features/AuditItems/domain/entities/audit_items_entities.dart';

part 'search_audit_user_model.g.dart';

@JsonSerializable()
class SearchAuditUserModel {
  @JsonKey(name: "status")
  final String? status;
  @JsonKey(name: "message")
  final String? message;
  @JsonKey(name: "data")
  final List<Data>? data;

  SearchAuditUserModel({this.status, this.message, this.data});

  factory SearchAuditUserModel.fromJson(Map<String, dynamic> json) {
    return _$SearchAuditUserModelFromJson(json);
  }

  Map<String, dynamic> toJson() {
    return _$SearchAuditUserModelToJson(this);
  }

  SearchAuditUserEntity toEntity() {
    return SearchAuditUserEntity(status: status, message: message, data: data);
  }
}

@JsonSerializable()
class Data {
  @JsonKey(name: "id")
  final int? id;
  @JsonKey(name: "audit_id")
  final int? auditId;
  @JsonKey(name: "user_id")
  final int? userId;

  Data({this.id, this.auditId, this.userId});

  factory Data.fromJson(Map<String, dynamic> json) {
    return _$DataFromJson(json);
  }

  Map<String, dynamic> toJson() {
    return _$DataToJson(this);
  }
}
