import 'package:stock_up/features/Transaction/data/models/response/add_transaction_model.dart';

class AddTransactionEntity {
  final String? status;

  final List<AddedTransactions>? addedTransactions;

  final int? closingBalance;

  final String? shiftStatus;

  AddTransactionEntity({
    this.status,
    this.addedTransactions,
    this.closingBalance,
    this.shiftStatus,
  });
}
