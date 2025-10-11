import 'package:json_annotation/json_annotation.dart';
import 'package:stock_up/features/Stores/domain/entities/stores_entities.dart';

part 'all_stores_model.g.dart';

@JsonSerializable()
class AllStoresModel {
  @JsonKey(name: "status")
  final String? status;
  @JsonKey(name: "results")
  final List<Results>? results;

  AllStoresModel ({
    this.status,
    this.results,
  });

  factory AllStoresModel.fromJson(Map<String, dynamic> json) {
    return _$AllStoresModelFromJson(json);
  }

  Map<String, dynamic> toJson() {
    return _$AllStoresModelToJson(this);
  }
  AllStoresEntity toEntity() {
    return AllStoresEntity(
      status: status,
      results: results,
    );
  }
}

@JsonSerializable()
class Results {
  @JsonKey(name: "id")
  final int? id;
  @JsonKey(name: "store_name")
  final String? storeName;
  @JsonKey(name: "store_location")
  final String? storeLocation;
  @JsonKey(name: "created_at")
  final String? createdAt;

  Results ({
    this.id,
    this.storeName,
    this.storeLocation,
    this.createdAt,
  });

  factory Results.fromJson(Map<String, dynamic> json) {
    return _$ResultsFromJson(json);
  }

  Map<String, dynamic> toJson() {
    return _$ResultsToJson(this);
  }
}


