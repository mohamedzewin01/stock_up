import 'package:json_annotation/json_annotation.dart';
import 'package:stock_up/features/Summary/domain/entities/summary_entities.dart';

part 'summary_model.g.dart';

@JsonSerializable()
class SummaryModel {
  @JsonKey(name: "status")
  final String? status;
  @JsonKey(name: "summary")
  final Summary? summary;

  SummaryModel({this.status, this.summary});

  factory SummaryModel.fromJson(Map<String, dynamic> json) {
    return _$SummaryModelFromJson(json);
  }

  Map<String, dynamic> toJson() {
    return _$SummaryModelToJson(this);
  }

  SummaryEntity toEntity() {
    return SummaryEntity(status: status, summary: summary);
  }
}

@JsonSerializable()
class Summary {
  @JsonKey(name: "treasury")
  final Treasury? treasury;
  @JsonKey(name: "bank")
  final Bank? bank;
  @JsonKey(name: "products_count")
  final int? productsCount;

  Summary({this.treasury, this.bank, this.productsCount});

  factory Summary.fromJson(Map<String, dynamic> json) {
    return _$SummaryFromJson(json);
  }

  Map<String, dynamic> toJson() {
    return _$SummaryToJson(this);
  }
}

@JsonSerializable()
class Treasury {
  @JsonKey(name: "final_balance")
  final String? finalBalance;
  @JsonKey(name: "movements")
  final List<Movements>? movements;

  Treasury({this.finalBalance, this.movements});

  factory Treasury.fromJson(Map<String, dynamic> json) {
    return _$TreasuryFromJson(json);
  }

  Map<String, dynamic> toJson() {
    return _$TreasuryToJson(this);
  }
}

@JsonSerializable()
class Movements {
  @JsonKey(name: "movement_type")
  final String? movementType;
  @JsonKey(name: "total_incoming")
  final String? totalIncoming;
  @JsonKey(name: "total_outgoing")
  final String? totalOutgoing;

  Movements({this.movementType, this.totalIncoming, this.totalOutgoing});

  factory Movements.fromJson(Map<String, dynamic> json) {
    return _$MovementsFromJson(json);
  }

  Map<String, dynamic> toJson() {
    return _$MovementsToJson(this);
  }
}

@JsonSerializable()
class Bank {
  @JsonKey(name: "final_balance")
  final String? finalBalance;
  @JsonKey(name: "movements")
  final List<Movements>? movements;

  Bank({this.finalBalance, this.movements});

  factory Bank.fromJson(Map<String, dynamic> json) {
    return _$BankFromJson(json);
  }

  Map<String, dynamic> toJson() {
    return _$BankToJson(this);
  }
}
