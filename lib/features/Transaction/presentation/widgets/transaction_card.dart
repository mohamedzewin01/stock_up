// lib/features/Transaction/presentation/widgets/transaction_card.dart
import 'package:flutter/material.dart';
import 'transaction_types.dart';

class TransactionCard extends StatelessWidget {
  final TransactionItem transaction;
  final int index;
  final bool isTablet;
  final VoidCallback onEdit;
  final VoidCallback onRemove;

  const TransactionCard({
    super.key,
    required this.transaction,
    required this.index,
    required this.isTablet,
    required this.onEdit,
    required this.onRemove,
  });

  @override
  Widget build(BuildContext context) {
    final isPositive = transaction.type.isPositive;
    final color = transaction.type.color;

    return Dismissible(
      key: Key('transaction_$index'),
      direction: DismissDirection.endToStart,
      background: _buildDismissBackground(),
      onDismissed: (direction) => onRemove(),
      child: Container(
        padding: EdgeInsets.all(isTablet ? 20 : 16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: color.withOpacity(0.2),
            width: 1.5,
          ),
          boxShadow: [
            BoxShadow(
              color: color.withOpacity(0.1),
              blurRadius: 10,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          children: [
            _buildTypeIcon(color),
            const SizedBox(width: 16),
            _buildTransactionDetails(),
            _buildAmountSection(isPositive, color),
            const SizedBox(width: 8),
            _buildEditButton(),
          ],
        ),
      ),
    );
  }

  Widget _buildDismissBackground() {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFFFF3B30),
        borderRadius: BorderRadius.circular(16),
      ),
      alignment: Alignment.centerLeft,
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: const Icon(
        Icons.delete,
        color: Colors.white,
        size: 24,
      ),
    );
  }

  Widget _buildTypeIcon(Color color) {
    return Container(
      width: isTablet ? 56 : 48,
      height: isTablet ? 56 : 48,
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(14),
      ),
      child: Icon(
        transaction.type.icon,
        color: color,
        size: isTablet ? 28 : 24,
      ),
    );
  }

  Widget _buildTransactionDetails() {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            transaction.description,
            style: TextStyle(
              fontSize: isTablet ? 16 : 14,
              fontWeight: FontWeight.w600,
              color: const Color(0xFF1A1A1A),
            ),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 4),
          Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                decoration: BoxDecoration(
                  color: transaction.type.color.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  transaction.type.displayName,
                  style: TextStyle(
                    fontSize: isTablet ? 10 : 8,
                    fontWeight: FontWeight.w600,
                    color: transaction.type.color,
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Icon(
                Icons.access_time,
                size: isTablet ? 14 : 12,
                color: const Color(0xFF666666),
              ),
              const SizedBox(width: 4),
              Text(
                TransactionUtils.formatTime(transaction.timestamp),
                style: TextStyle(
                  fontSize: isTablet ? 12 : 10,
                  color: const Color(0xFF666666),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildAmountSection(bool isPositive, Color color) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Text(
          '${isPositive ? '+' : '-'}${transaction.amount.toStringAsFixed(2)}',
          style: TextStyle(
            fontSize: isTablet ? 18 : 16,
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
        Text(
          'ريال سعودي',
          style: TextStyle(
            fontSize: isTablet ? 10 : 8,
            color: const Color(0xFF666666),
          ),
        ),
      ],
    );
  }

  Widget _buildEditButton() {
    return GestureDetector(
      onTap: onEdit,
      child: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: const Color(0xFFF8F9FA),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Icon(
          Icons.edit,
          size: isTablet ? 18 : 16,
          color: const Color(0xFF666666),
        ),
      ),
    );
  }
}