// // lib/features/Transaction/presentation/widgets/transaction_list.dart
// import 'package:flutter/material.dart';
// import 'transaction_types.dart';
// import 'transaction_card.dart';
//
// class TransactionList extends StatelessWidget {
//   final List<TransactionItem> transactions;
//   final ScrollController scrollController;
//   final bool isTablet;
//   final Function(int) onEditTransaction;
//   final Function(int) onRemoveTransaction;
//
//   const TransactionList({
//     super.key,
//     required this.transactions,
//     required this.scrollController,
//     required this.isTablet,
//     required this.onEditTransaction,
//     required this.onRemoveTransaction,
//   });
//
//   @override
//   Widget build(BuildContext context) {
//     return ListView.separated(
//       controller: scrollController,
//       padding: EdgeInsets.all(isTablet ? 20 : 16),
//       itemCount: transactions.length,
//       separatorBuilder: (context, index) => SizedBox(height: isTablet ? 12 : 8),
//       itemBuilder: (context, index) {
//         final transaction = transactions[index];
//         return TransactionCard(
//           transaction: transaction,
//           index: index,
//           isTablet: isTablet,
//           onEdit: () => onEditTransaction(index),
//           onRemove: () => onRemoveTransaction(index),
//         );
//       },
//     );
//   }
// }
import 'package:flutter/material.dart';

import 'transaction_card.dart';
import 'transaction_types.dart';

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
    return SliverList(
      delegate: SliverChildBuilderDelegate((context, index) {
        final transaction = transactions[index];

        // Add staggered animation
        return TweenAnimationBuilder<double>(
          duration: Duration(milliseconds: 300 + (index * 50)),
          tween: Tween(begin: 0.0, end: 1.0),
          curve: Curves.easeOutCubic,
          builder: (context, value, child) {
            return Transform.translate(
              offset: Offset(0, 20 * (1 - value)),
              child: Opacity(
                opacity: value,
                child: Padding(
                  padding: EdgeInsets.only(
                    bottom: isTablet ? 12 : 10,
                    top: index == 0 ? 0 : 0,
                  ),
                  child: TransactionCard(
                    transaction: transaction,
                    index: index,
                    isTablet: isTablet,
                    onEdit: () => onEditTransaction(index),
                    onRemove: () => onRemoveTransaction(index),
                  ),
                ),
              ),
            );
          },
        );
      }, childCount: transactions.length),
    );
  }
}
