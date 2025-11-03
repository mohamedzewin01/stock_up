// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'add_transaction_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AddTransactionRequest _$AddTransactionRequestFromJson(
  Map<String, dynamic> json,
) => AddTransactionRequest(
  shiftId: (json['shift_id'] as num?)?.toInt(),
  transactions: (json['transactions'] as List<dynamic>?)
      ?.map((e) => Transactions.fromJson(e as Map<String, dynamic>))
      .toList(),
);

Map<String, dynamic> _$AddTransactionRequestToJson(
  AddTransactionRequest instance,
) => <String, dynamic>{
  'shift_id': instance.shiftId,
  'transactions': instance.transactions,
};

Transactions _$TransactionsFromJson(Map<String, dynamic> json) => Transactions(
  amount: (json['amount'] as num?)?.toDouble(),
  type: json['type'] as String?,
  description: json['description'] as String?,
);

Map<String, dynamic> _$TransactionsToJson(Transactions instance) =>
    <String, dynamic>{
      'amount': instance.amount,
      'type': instance.type,
      'description': instance.description,
    };
