// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'add_transaction_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AddTransactionModel _$AddTransactionModelFromJson(Map<String, dynamic> json) =>
    AddTransactionModel(
      status: json['status'] as String?,
      addedTransactions: (json['added_transactions'] as List<dynamic>?)
          ?.map((e) => AddedTransactions.fromJson(e as Map<String, dynamic>))
          .toList(),
      closingBalance: (json['closing_balance'] as num?)?.toInt(),
      shiftStatus: json['shift_status'] as String?,
    );

Map<String, dynamic> _$AddTransactionModelToJson(
  AddTransactionModel instance,
) => <String, dynamic>{
  'status': instance.status,
  'added_transactions': instance.addedTransactions,
  'closing_balance': instance.closingBalance,
  'shift_status': instance.shiftStatus,
};

AddedTransactions _$AddedTransactionsFromJson(Map<String, dynamic> json) =>
    AddedTransactions(
      transactionId: json['transaction_id'] as String?,
      shiftId: (json['shift_id'] as num?)?.toInt(),
      amount: (json['amount'] as num?)?.toInt(),
      type: json['type'] as String?,
      notes: json['notes'] as String?,
      transTime: json['trans_time'] as String?,
    );

Map<String, dynamic> _$AddedTransactionsToJson(AddedTransactions instance) =>
    <String, dynamic>{
      'transaction_id': instance.transactionId,
      'shift_id': instance.shiftId,
      'amount': instance.amount,
      'type': instance.type,
      'notes': instance.notes,
      'trans_time': instance.transTime,
    };
