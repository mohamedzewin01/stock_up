import 'package:json_annotation/json_annotation.dart';
import 'package:stock_up/features/Summary/domain/entities/summary_entities.dart';

part 'summary_accounts_model.g.dart';

@JsonSerializable()
class SummaryAccountsModel {
  @JsonKey(name: "status")
  final String? status;
  @JsonKey(name: "store")
  final StoreAccounts? store;
  @JsonKey(name: "page")
  final int? page;
  @JsonKey(name: "limit")
  final int? limit;
  @JsonKey(name: "total_items")
  final int? totalItems;
  @JsonKey(name: "total_pages")
  final int? totalPages;
  @JsonKey(name: "results")
  final List<ResultsAccounts>? results;

  SummaryAccountsModel({
    this.status,
    this.store,
    this.page,
    this.limit,
    this.totalItems,
    this.totalPages,
    this.results,
  });

  factory SummaryAccountsModel.fromJson(Map<String, dynamic> json) {
    return _$SummaryAccountsModelFromJson(json);
  }

  Map<String, dynamic> toJson() {
    return _$SummaryAccountsModelToJson(this);
  }

  SummaryAccountsEntity toEntity() {
    return SummaryAccountsEntity(
      status: status,
      store: store,
      page: page,
      limit: limit,
      totalItems: totalItems,
      totalPages: totalPages,
      results: results,
    );
  }
}

@JsonSerializable()
class StoreAccounts {
  @JsonKey(name: "id")
  final String? id;
  @JsonKey(name: "name")
  final String? name;

  StoreAccounts({this.id, this.name});

  factory StoreAccounts.fromJson(Map<String, dynamic> json) {
    return _$StoreAccountsFromJson(json);
  }

  Map<String, dynamic> toJson() {
    return _$StoreAccountsToJson(this);
  }
}

@JsonSerializable()
class ResultsAccounts {
  @JsonKey(name: "id")
  final int? id;
  @JsonKey(name: "store_id")
  final int? storeId;
  @JsonKey(name: "account_number")
  final String? accountNumber;
  @JsonKey(name: "account_name")
  final String? accountName;
  @JsonKey(name: "account_type")
  final String? accountType;
  @JsonKey(name: "balance_debit")
  final String? balanceDebit;
  @JsonKey(name: "balance_credit")
  final String? balanceCredit;
  @JsonKey(name: "checks_debit")
  final String? checksDebit;
  @JsonKey(name: "checks_credit")
  final String? checksCredit;
  @JsonKey(name: "account_nature")
  final dynamic? accountNature;
  @JsonKey(name: "classification")
  final String? classification;
  @JsonKey(name: "mobile")
  final String? mobile;
  @JsonKey(name: "address")
  final String? address;
  @JsonKey(name: "sale_price")
  final String? salePrice;
  @JsonKey(name: "review_date")
  final dynamic? reviewDate;
  @JsonKey(name: "last_sale_date")
  final dynamic? lastSaleDate;
  @JsonKey(name: "last_sale_total")
  final String? lastSaleTotal;
  @JsonKey(name: "last_receive_date")
  final dynamic? lastReceiveDate;
  @JsonKey(name: "last_receive_value")
  final String? lastReceiveValue;
  @JsonKey(name: "created_at")
  final String? createdAt;
  @JsonKey(name: "updated_at")
  final String? updatedAt;
  @JsonKey(name: "relevance_score")
  final int? relevanceScore;

  ResultsAccounts({
    this.id,
    this.storeId,
    this.accountNumber,
    this.accountName,
    this.accountType,
    this.balanceDebit,
    this.balanceCredit,
    this.checksDebit,
    this.checksCredit,
    this.accountNature,
    this.classification,
    this.mobile,
    this.address,
    this.salePrice,
    this.reviewDate,
    this.lastSaleDate,
    this.lastSaleTotal,
    this.lastReceiveDate,
    this.lastReceiveValue,
    this.createdAt,
    this.updatedAt,
    this.relevanceScore,
  });

  factory ResultsAccounts.fromJson(Map<String, dynamic> json) {
    return _$ResultsAccountsFromJson(json);
  }

  Map<String, dynamic> toJson() {
    return _$ResultsAccountsToJson(this);
  }
}
