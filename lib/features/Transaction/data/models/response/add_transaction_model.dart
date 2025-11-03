import 'package:json_annotation/json_annotation.dart';
import 'package:stock_up/features/Transaction/domain/entities/transaction_entity.dart';

part 'add_transaction_model.g.dart';

@JsonSerializable()
class AddTransactionModel {
  @JsonKey(name: "status")
  final String? status;
  @JsonKey(name: "added_transactions")
  final List<AddedTransactions>? addedTransactions;
  @JsonKey(name: "closing_balance")
  final int? closingBalance;
  @JsonKey(name: "shift_status")
  final String? shiftStatus;

  AddTransactionModel({
    this.status,
    this.addedTransactions,
    this.closingBalance,
    this.shiftStatus,
  });

  factory AddTransactionModel.fromJson(Map<String, dynamic> json) {
    return _$AddTransactionModelFromJson(json);
  }

  Map<String, dynamic> toJson() {
    return _$AddTransactionModelToJson(this);
  }

  AddTransactionEntity toEntity() {
    return AddTransactionEntity(
      status: status,
      addedTransactions: addedTransactions,
      closingBalance: closingBalance,
      shiftStatus: shiftStatus,
    );
  }
}

@JsonSerializable()
class AddedTransactions {
  @JsonKey(name: "transaction_id")
  final String? transactionId;
  @JsonKey(name: "shift_id")
  final int? shiftId;
  @JsonKey(name: "amount")
  final int? amount;
  @JsonKey(name: "type")
  final String? type;
  @JsonKey(name: "notes")
  final String? notes;
  @JsonKey(name: "trans_time")
  final String? transTime;

  AddedTransactions({
    this.transactionId,
    this.shiftId,
    this.amount,
    this.type,
    this.notes,
    this.transTime,
  });

  factory AddedTransactions.fromJson(Map<String, dynamic> json) {
    return _$AddedTransactionsFromJson(json);
  }

  Map<String, dynamic> toJson() {
    return _$AddedTransactionsToJson(this);
  }
}
