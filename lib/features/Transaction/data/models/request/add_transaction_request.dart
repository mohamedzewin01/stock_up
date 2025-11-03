import 'package:json_annotation/json_annotation.dart';

part 'add_transaction_request.g.dart';

@JsonSerializable()
class AddTransactionRequest {
  @JsonKey(name: "shift_id")
  final int? shiftId;
  @JsonKey(name: "transactions")
  final List<Transactions>? transactions;

  AddTransactionRequest ({
    this.shiftId,
    this.transactions,
  });

  factory AddTransactionRequest.fromJson(Map<String, dynamic> json) {
    return _$AddTransactionRequestFromJson(json);
  }

  Map<String, dynamic> toJson() {
    return _$AddTransactionRequestToJson(this);
  }
}

@JsonSerializable()
class Transactions {
  @JsonKey(name: "amount")
  final double? amount;
  @JsonKey(name: "type")
  final String? type;
  @JsonKey(name: "description")
  final String? description;

  Transactions ({
    this.amount,
    this.type,
    this.description,
  });

  factory Transactions.fromJson(Map<String, dynamic> json) {
    return _$TransactionsFromJson(json);
  }

  Map<String, dynamic> toJson() {
    return _$TransactionsToJson(this);
  }
}


