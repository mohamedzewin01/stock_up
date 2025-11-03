// lib/features/Transaction/presentation/widgets/transaction_statistics_card.dart
import 'package:flutter/material.dart';

class TransactionStatisticsCard extends StatelessWidget {
  final double totalPositive;
  final double totalNegative;
  final double netAmount;
  final int transactionCount;
  final bool isTablet;

  const TransactionStatisticsCard({
    super.key,
    required this.totalPositive,
    required this.totalNegative,
    required this.netAmount,
    required this.transactionCount,
    required this.isTablet,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(isTablet ? 20 : 16),
      padding: EdgeInsets.all(isTablet ? 24 : 20),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFF007AFF), Color(0xFF5856D6)],
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF007AFF).withOpacity(0.3),
            blurRadius: 15,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        children: [
          _buildHeader(),
          const SizedBox(height: 20),
          _buildStatisticsRow(),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Row(
      children: [
        Icon(
          Icons.analytics,
          color: Colors.white,
          size: isTablet ? 24 : 20,
        ),
        const SizedBox(width: 8),
        Text(
          'ملخص المعاملات',
          style: TextStyle(
            fontSize: isTablet ? 18 : 16,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        const Spacer(),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.2),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Text(
            '$transactionCount معاملة',
            style: TextStyle(
              fontSize: isTablet ? 12 : 10,
              fontWeight: FontWeight.w600,
              color: Colors.white,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildStatisticsRow() {
    return Row(
      children: [
        Expanded(
          child: _buildStatItem(
            'المبيعات والإيرادات',
            totalPositive,
            Icons.trending_up,
            const Color(0xFF28A745),
          ),
        ),
        Container(
          width: 1,
          height: 50,
          color: Colors.white.withOpacity(0.3),
        ),
        Expanded(
          child: _buildStatItem(
            'المصروفات والمرتجع',
            totalNegative,
            Icons.trending_down,
            const Color(0xFFFF3B30),
          ),
        ),
        Container(
          width: 1,
          height: 50,
          color: Colors.white.withOpacity(0.3),
        ),
        Expanded(
          child: _buildStatItem(
            'الصافي',
            netAmount,
            netAmount >= 0 ? Icons.add_circle : Icons.remove_circle,
            netAmount >= 0 ? const Color(0xFF28A745) : const Color(0xFFFF3B30),
          ),
        ),
      ],
    );
  }

  Widget _buildStatItem(String title, double amount, IconData icon, Color color) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: color.withOpacity(0.2),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(
            icon,
            color: color,
            size: isTablet ? 24 : 20,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          title,
          style: TextStyle(
            fontSize: isTablet ? 10 : 8,
            color: Colors.white.withOpacity(0.8),
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 4),
        Text(
          '${amount.toStringAsFixed(2)} ر.س',
          style: TextStyle(
            fontSize: isTablet ? 14 : 12,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      ],
    );
  }
}