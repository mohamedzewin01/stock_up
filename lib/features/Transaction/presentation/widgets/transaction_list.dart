// lib/features/Transaction/presentation/widgets/transaction_list.dart
import 'package:flutter/material.dart';
import 'transaction_types.dart';
import 'transaction_card.dart';

class TransactionList extends StatelessWidget {
  final List<TransactionItem> transactions;
  final ScrollController scrollController;
  final bool isTablet;
  final Function(int) onEditTransaction;
  final Function(int) onRemoveTransaction;

  const TransactionList({
    super.key,
    required this.transactions,
    required this.scrollController,
    required this.isTablet,
    required this.onEditTransaction,
    required this.onRemoveTransaction,
  });

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      controller: scrollController,
      padding: EdgeInsets.all(isTablet ? 20 : 16),
      itemCount: transactions.length,
      separatorBuilder: (context, index) => SizedBox(height: isTablet ? 12 : 8),
      itemBuilder: (context, index) {
        final transaction = transactions[index];
        return TransactionCard(
          transaction: transaction,
          index: index,
          isTablet: isTablet,
          onEdit: () => onEditTransaction(index),
          onRemove: () => onRemoveTransaction(index),
        );
      },
    );
  }
}