// lib/features/Transaction/presentation/widgets/transaction_empty_state.dart
import 'package:flutter/material.dart';

class TransactionEmptyState extends StatelessWidget {
  final bool isTablet;
  final VoidCallback onAddTransaction;

  const TransactionEmptyState({
    super.key,
    required this.isTablet,
    required this.onAddTransaction,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: EdgeInsets.all(isTablet ? 40 : 32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _buildIcon(),
            SizedBox(height: isTablet ? 24 : 20),
            _buildTitle(),
            SizedBox(height: isTablet ? 12 : 8),
            _buildDescription(),
            SizedBox(height: isTablet ? 32 : 24),
            _buildAddButton(),
          ],
        ),
      ),
    );
  }

  Widget _buildIcon() {
    return Container(
      width: isTablet ? 120 : 100,
      height: isTablet ? 120 : 100,
      decoration: BoxDecoration(
        color: const Color(0xFF007AFF).withOpacity(0.1),
        shape: BoxShape.circle,
      ),
      child: Icon(
        Icons.receipt_long,
        size: isTablet ? 60 : 50,
        color: const Color(0xFF007AFF),
      ),
    );
  }

  Widget _buildTitle() {
    return Text(
      'لا توجد معاملات بعد',
      style: TextStyle(
        fontSize: isTablet ? 24 : 20,
        fontWeight: FontWeight.bold,
        color: const Color(0xFF1A1A1A),
      ),
    );
  }

  Widget _buildDescription() {
    return Text(
      'ابدأ بإضافة معاملات الوردية\n(نقدية، فيزا، آجل، مصروفات، مرتجع)',
      style: TextStyle(
        fontSize: isTablet ? 16 : 14,
        color: const Color(0xFF666666),
        height: 1.5,
      ),
      textAlign: TextAlign.center,
    );
  }

  Widget _buildAddButton() {
    return ElevatedButton.icon(
      onPressed: onAddTransaction,
      icon: const Icon(Icons.add),
      label: const Text('إضافة معاملة'),
      style: ElevatedButton.styleFrom(
        backgroundColor: const Color(0xFF007AFF),
        foregroundColor: Colors.white,
        padding: EdgeInsets.symmetric(
          horizontal: isTablet ? 32 : 24,
          vertical: isTablet ? 16 : 12,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
    );
  }
}