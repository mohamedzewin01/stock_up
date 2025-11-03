// // lib/features/Transaction/presentation/widgets/transaction_statistics_card.dart
// import 'package:flutter/material.dart';
//
// class TransactionStatisticsCard extends StatelessWidget {
//   final double totalPositive;
//   final double totalNegative;
//   final double netAmount;
//   final int transactionCount;
//   final bool isTablet;
//
//   const TransactionStatisticsCard({
//     super.key,
//     required this.totalPositive,
//     required this.totalNegative,
//     required this.netAmount,
//     required this.transactionCount,
//     required this.isTablet,
//   });
//
//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       margin: EdgeInsets.all(isTablet ? 20 : 16),
//       padding: EdgeInsets.all(isTablet ? 24 : 20),
//       decoration: BoxDecoration(
//         gradient: const LinearGradient(
//           begin: Alignment.topLeft,
//           end: Alignment.bottomRight,
//           colors: [Color(0xFF007AFF), Color(0xFF5856D6)],
//         ),
//         borderRadius: BorderRadius.circular(20),
//         boxShadow: [
//           BoxShadow(
//             color: const Color(0xFF007AFF).withOpacity(0.3),
//             blurRadius: 15,
//             offset: const Offset(0, 5),
//           ),
//         ],
//       ),
//       child: Column(
//         children: [
//           _buildHeader(),
//           const SizedBox(height: 20),
//           _buildStatisticsRow(),
//         ],
//       ),
//     );
//   }
//
//   Widget _buildHeader() {
//     return Row(
//       children: [
//         Icon(
//           Icons.analytics,
//           color: Colors.white,
//           size: isTablet ? 24 : 20,
//         ),
//         const SizedBox(width: 8),
//         Text(
//           'ملخص المعاملات',
//           style: TextStyle(
//             fontSize: isTablet ? 18 : 16,
//             fontWeight: FontWeight.bold,
//             color: Colors.white,
//           ),
//         ),
//         const Spacer(),
//         Container(
//           padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
//           decoration: BoxDecoration(
//             color: Colors.white.withOpacity(0.2),
//             borderRadius: BorderRadius.circular(20),
//           ),
//           child: Text(
//             '$transactionCount معاملة',
//             style: TextStyle(
//               fontSize: isTablet ? 12 : 10,
//               fontWeight: FontWeight.w600,
//               color: Colors.white,
//             ),
//           ),
//         ),
//       ],
//     );
//   }
//
//   Widget _buildStatisticsRow() {
//     return Row(
//       children: [
//         Expanded(
//           child: _buildStatItem(
//             'المبيعات والإيرادات',
//             totalPositive,
//             Icons.trending_up,
//             const Color(0xFF28A745),
//           ),
//         ),
//         Container(
//           width: 1,
//           height: 50,
//           color: Colors.white.withOpacity(0.3),
//         ),
//         Expanded(
//           child: _buildStatItem(
//             'المصروفات والمرتجع',
//             totalNegative,
//             Icons.trending_down,
//             const Color(0xFFFF3B30),
//           ),
//         ),
//         Container(
//           width: 1,
//           height: 50,
//           color: Colors.white.withOpacity(0.3),
//         ),
//         Expanded(
//           child: _buildStatItem(
//             'الصافي',
//             netAmount,
//             netAmount >= 0 ? Icons.add_circle : Icons.remove_circle,
//             netAmount >= 0 ? const Color(0xFF28A745) : const Color(0xFFFF3B30),
//           ),
//         ),
//       ],
//     );
//   }
//
//   Widget _buildStatItem(String title, double amount, IconData icon, Color color) {
//     return Column(
//       children: [
//         Container(
//           padding: const EdgeInsets.all(8),
//           decoration: BoxDecoration(
//             color: color.withOpacity(0.2),
//             borderRadius: BorderRadius.circular(12),
//           ),
//           child: Icon(
//             icon,
//             color: color,
//             size: isTablet ? 24 : 20,
//           ),
//         ),
//         const SizedBox(height: 8),
//         Text(
//           title,
//           style: TextStyle(
//             fontSize: isTablet ? 10 : 8,
//             color: Colors.white.withOpacity(0.8),
//           ),
//           textAlign: TextAlign.center,
//         ),
//         const SizedBox(height: 4),
//         Text(
//           '${amount.toStringAsFixed(2)} ر.س',
//           style: TextStyle(
//             fontSize: isTablet ? 14 : 12,
//             fontWeight: FontWeight.bold,
//             color: Colors.white,
//           ),
//         ),
//       ],
//     );
//   }
// }

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
      margin: EdgeInsets.symmetric(horizontal: isTablet ? 20 : 16),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFF667EEA), Color(0xFF764BA2)],
        ),
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF667EEA).withOpacity(0.3),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Stack(
        children: [
          // Decorative circles
          Positioned(
            right: -20,
            top: -20,
            child: Container(
              width: 100,
              height: 100,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white.withOpacity(0.1),
              ),
            ),
          ),
          Positioned(
            left: -30,
            bottom: -30,
            child: Container(
              width: 120,
              height: 120,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white.withOpacity(0.05),
              ),
            ),
          ),

          // Content
          Padding(
            padding: EdgeInsets.all(isTablet ? 24 : 20),
            child: Column(
              children: [
                _buildHeader(),
                SizedBox(height: isTablet ? 24 : 20),
                _buildStatisticsGrid(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.2),
            borderRadius: BorderRadius.circular(14),
          ),
          child: Icon(
            Icons.analytics_rounded,
            color: Colors.white,
            size: isTablet ? 26 : 22,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'ملخص المعاملات',
                style: TextStyle(
                  fontSize: isTablet ? 20 : 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                  letterSpacing: -0.5,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                'الوضع المالي للوردية',
                style: TextStyle(
                  fontSize: isTablet ? 13 : 12,
                  color: Colors.white.withOpacity(0.8),
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.2),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: Colors.white.withOpacity(0.3)),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.receipt_long_rounded,
                color: Colors.white,
                size: isTablet ? 18 : 16,
              ),
              const SizedBox(width: 6),
              Text(
                '$transactionCount',
                style: TextStyle(
                  fontSize: isTablet ? 16 : 14,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildStatisticsGrid() {
    return Column(
      children: [
        // الصف الأول: المبيعات والمصروفات
        Row(
          children: [
            Expanded(
              child: _buildStatCard(
                'إجمالي المبيعات',
                totalPositive,
                Icons.trending_up_rounded,
                const Color(0xFF48BB78),
                isPositive: true,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _buildStatCard(
                'إجمالي المصروفات',
                totalNegative,
                Icons.trending_down_rounded,
                const Color(0xFFFC8181),
                isPositive: false,
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        // الصف الثاني: الصافي
        _buildNetAmountCard(),
      ],
    );
  }

  Widget _buildStatCard(
    String title,
    double amount,
    IconData icon,
    Color color, {
    required bool isPositive,
  }) {
    return Container(
      padding: EdgeInsets.all(isTablet ? 18 : 16),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.15),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.white.withOpacity(0.2)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(icon, color: color, size: isTablet ? 20 : 18),
              ),
              const Spacer(),
              Icon(
                isPositive
                    ? Icons.arrow_upward_rounded
                    : Icons.arrow_downward_rounded,
                color: color,
                size: 16,
              ),
            ],
          ),
          SizedBox(height: isTablet ? 12 : 10),
          Text(
            title,
            style: TextStyle(
              fontSize: isTablet ? 12 : 11,
              color: Colors.white.withOpacity(0.9),
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 4),
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Expanded(
                child: Text(
                  amount.toStringAsFixed(2),
                  style: TextStyle(
                    fontSize: isTablet ? 22 : 20,
                    fontWeight: FontWeight.w800,
                    color: Colors.white,
                    letterSpacing: -0.5,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              const SizedBox(width: 4),
              Padding(
                padding: const EdgeInsets.only(bottom: 2),
                child: Text(
                  'ر.س',
                  style: TextStyle(
                    fontSize: isTablet ? 12 : 11,
                    color: Colors.white.withOpacity(0.8),
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildNetAmountCard() {
    final isProfit = netAmount >= 0;
    final netColor = isProfit
        ? const Color(0xFF48BB78)
        : const Color(0xFFFC8181);

    return Container(
      padding: EdgeInsets.all(isTablet ? 16 : 14),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.15),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.white.withOpacity(0.3), width: 2),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [netColor.withOpacity(0.3), netColor.withOpacity(0.1)],
              ),
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: netColor.withOpacity(0.3)),
            ),
            child: Icon(
              isProfit
                  ? Icons.trending_up_rounded
                  : Icons.trending_down_rounded,
              color: netColor,
              size: isTablet ? 32 : 28,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      'الصافي',
                      style: TextStyle(
                        fontSize: isTablet ? 14 : 13,
                        color: Colors.white.withOpacity(0.9),
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 3,
                      ),
                      decoration: BoxDecoration(
                        color: netColor.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        isProfit ? 'ربح' : 'خسارة',
                        style: TextStyle(
                          fontSize: isTablet ? 10 : 9,
                          color: netColor,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 6),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      '${isProfit ? '+' : ''}${netAmount.toStringAsFixed(2)}',
                      style: TextStyle(
                        fontSize: isTablet ? 28 : 26,
                        fontWeight: FontWeight.w900,
                        color: Colors.white,
                        letterSpacing: -1,
                      ),
                    ),
                    const SizedBox(width: 6),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.only(bottom: 4),
                        child: Text(
                          'ريال سعودي',
                          style: TextStyle(
                            fontSize: isTablet ? 13 : 12,
                            color: Colors.white.withOpacity(0.8),
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Icon(
            isProfit ? Icons.celebration_rounded : Icons.info_outline_rounded,
            color: netColor,
            size: isTablet ? 32 : 28,
          ),
        ],
      ),
    );
  }
}
