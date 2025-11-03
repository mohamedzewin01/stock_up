// // lib/features/Transaction/presentation/widgets/transaction_bottom_bar.dart
// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import '../bloc/Transaction_cubit.dart';
//
// class TransactionBottomBar extends StatelessWidget {
//   final bool hasTransactions;
//   final double totalPositive;
//   final double totalNegative;
//   final double netAmount;
//   final int transactionCount;
//   final bool isTablet;
//   final VoidCallback onClearAll;
//   final VoidCallback onFinishShift;
//
//   const TransactionBottomBar({
//     super.key,
//     required this.hasTransactions,
//     required this.totalPositive,
//     required this.totalNegative,
//     required this.netAmount,
//     required this.transactionCount,
//     required this.isTablet,
//     required this.onClearAll,
//     required this.onFinishShift,
//   });
//
//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       padding: EdgeInsets.all(isTablet ? 20 : 16),
//       decoration: const BoxDecoration(
//         color: Colors.white,
//         border: Border(
//           top: BorderSide(
//             color: Color(0xFFE5E5E5),
//             width: 1,
//           ),
//         ),
//       ),
//       child: SafeArea(
//         child: BlocBuilder<TransactionCubit, TransactionState>(
//           builder: (context, state) {
//             final isLoading = state is TransactionLoading;
//
//             return Row(
//               children: [
//                 // زر مسح الكل
//                 if (hasTransactions) ...[
//                   Expanded(
//                     child: OutlinedButton.icon(
//                       onPressed: isLoading ? null : onClearAll,
//                       icon: const Icon(Icons.clear_all),
//                       label: const Text('مسح الكل'),
//                       style: OutlinedButton.styleFrom(
//                         foregroundColor: const Color(0xFFFF3B30),
//                         side: const BorderSide(color: Color(0xFFFF3B30)),
//                         padding: EdgeInsets.symmetric(vertical: isTablet ? 16 : 12),
//                         shape: RoundedRectangleBorder(
//                           borderRadius: BorderRadius.circular(12),
//                         ),
//                       ),
//                     ),
//                   ),
//                   const SizedBox(width: 12),
//                 ],
//
//                 // زر إنهاء الوردية وإرسال المعاملات
//                 Expanded(
//                   flex: 2,
//                   child: ElevatedButton.icon(
//                     onPressed: !hasTransactions || isLoading ? null : onFinishShift,
//                     icon: isLoading
//                         ? SizedBox(
//                       width: isTablet ? 20 : 16,
//                       height: isTablet ? 20 : 16,
//                       child: const CircularProgressIndicator(
//                         color: Colors.white,
//                         strokeWidth: 2,
//                       ),
//                     )
//                         : const Icon(Icons.send),
//                     label: Text(
//                       isLoading ? 'جاري الإرسال...' : 'إنهاء الوردية وإرسال',
//                       style: TextStyle(
//                         fontSize: isTablet ? 16 : 14,
//                         fontWeight: FontWeight.w600,
//                       ),
//                     ),
//                     style: ElevatedButton.styleFrom(
//                       backgroundColor: const Color(0xFF007AFF),
//                       foregroundColor: Colors.white,
//                       disabledBackgroundColor: const Color(0xFF007AFF).withOpacity(0.6),
//                       padding: EdgeInsets.symmetric(vertical: isTablet ? 16 : 12),
//                       shape: RoundedRectangleBorder(
//                         borderRadius: BorderRadius.circular(12),
//                       ),
//                     ),
//                   ),
//                 ),
//               ],
//             );
//           },
//         ),
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../bloc/Transaction_cubit.dart';

class TransactionBottomBar extends StatelessWidget {
  final bool hasTransactions;
  final double totalPositive;
  final double totalNegative;
  final double netAmount;
  final int transactionCount;
  final bool isTablet;
  final VoidCallback onClearAll;
  final VoidCallback onFinishShift;

  const TransactionBottomBar({
    super.key,
    required this.hasTransactions,
    required this.totalPositive,
    required this.totalNegative,
    required this.netAmount,
    required this.transactionCount,
    required this.isTablet,
    required this.onClearAll,
    required this.onFinishShift,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 20,
            offset: const Offset(0, -4),
          ),
        ],
      ),
      child: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(isTablet ? 20 : 16),
          child: BlocBuilder<TransactionCubit, TransactionState>(
            builder: (context, state) {
              final isLoading = state is TransactionLoading;

              return Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (hasTransactions) ...[
                    _buildQuickSummary(),
                    const SizedBox(height: 16),
                  ],
                  Row(
                    children: [
                      // زر مسح الكل
                      if (hasTransactions) ...[
                        Expanded(child: _buildClearButton(isLoading)),
                        const SizedBox(width: 12),
                      ],

                      // زر إنهاء الوردية
                      Expanded(
                        flex: hasTransactions ? 2 : 1,
                        child: _buildFinishButton(isLoading),
                      ),
                    ],
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _buildQuickSummary() {
    return Container(
      padding: EdgeInsets.all(isTablet ? 16 : 14),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            const Color(0xFF667EEA).withOpacity(0.1),
            const Color(0xFF764BA2).withOpacity(0.05),
          ],
        ),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: const Color(0xFF667EEA).withOpacity(0.2)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildSummaryItem(
            'المبيعات',
            totalPositive,
            Icons.arrow_upward_rounded,
            const Color(0xFF48BB78),
          ),
          Container(width: 1, height: 30, color: const Color(0xFFE2E8F0)),
          _buildSummaryItem(
            'المصروفات',
            totalNegative,
            Icons.arrow_downward_rounded,
            const Color(0xFFFC8181),
          ),
          Container(width: 1, height: 30, color: const Color(0xFFE2E8F0)),
          _buildSummaryItem(
            'الصافي',
            netAmount,
            netAmount >= 0
                ? Icons.trending_up_rounded
                : Icons.trending_down_rounded,
            netAmount >= 0 ? const Color(0xFF48BB78) : const Color(0xFFFC8181),
          ),
        ],
      ),
    );
  }

  Widget _buildSummaryItem(
    String label,
    double value,
    IconData icon,
    Color color,
  ) {
    return Column(
      children: [
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, color: color, size: isTablet ? 16 : 14),
            const SizedBox(width: 4),
            Text(
              label,
              style: TextStyle(
                fontSize: isTablet ? 11 : 10,
                color: const Color(0xFF718096),
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
        const SizedBox(height: 4),
        Text(
          value.toStringAsFixed(2),
          style: TextStyle(
            fontSize: isTablet ? 16 : 14,
            fontWeight: FontWeight.w800,
            color: color,
            letterSpacing: -0.3,
          ),
        ),
      ],
    );
  }

  Widget _buildClearButton(bool isLoading) {
    return Container(
      height: isTablet ? 56 : 50,
      decoration: BoxDecoration(
        color: const Color(0xFFFFF5F5),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: const Color(0xFFFC8181).withOpacity(0.3)),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: isLoading ? null : onClearAll,
          borderRadius: BorderRadius.circular(14),
          child: Center(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.delete_sweep_rounded,
                  color: isLoading
                      ? const Color(0xFFFC8181).withOpacity(0.5)
                      : const Color(0xFFFC8181),
                  size: isTablet ? 22 : 20,
                ),
                const SizedBox(width: 8),
                Text(
                  'مسح الكل',
                  style: TextStyle(
                    fontSize: isTablet ? 15 : 14,
                    fontWeight: FontWeight.w700,
                    color: isLoading
                        ? const Color(0xFFFC8181).withOpacity(0.5)
                        : const Color(0xFFFC8181),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildFinishButton(bool isLoading) {
    final canFinish = hasTransactions && !isLoading;

    return Container(
      height: isTablet ? 56 : 50,
      decoration: BoxDecoration(
        gradient: canFinish
            ? const LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [Color(0xFF667EEA), Color(0xFF764BA2)],
              )
            : null,
        color: canFinish ? null : const Color(0xFFE2E8F0),
        borderRadius: BorderRadius.circular(14),
        boxShadow: canFinish
            ? [
                BoxShadow(
                  color: const Color(0xFF667EEA).withOpacity(0.4),
                  blurRadius: 15,
                  offset: const Offset(0, 4),
                ),
              ]
            : null,
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: canFinish ? onFinishShift : null,
          borderRadius: BorderRadius.circular(14),
          child: Center(
            child: isLoading
                ? SizedBox(
                    width: isTablet ? 24 : 20,
                    height: isTablet ? 24 : 20,
                    child: const CircularProgressIndicator(
                      color: Colors.white,
                      strokeWidth: 2.5,
                    ),
                  )
                : Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        padding: const EdgeInsets.all(6),
                        decoration: BoxDecoration(
                          color: canFinish
                              ? Colors.white.withOpacity(0.2)
                              : Colors.white.withOpacity(0.5),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Icon(
                          Icons.send_rounded,
                          color: canFinish
                              ? Colors.white
                              : const Color(0xFF718096),
                          size: isTablet ? 20 : 18,
                        ),
                      ),
                      const SizedBox(width: 10),
                      Text(
                        'إنهاء الوردية وإرسال',
                        style: TextStyle(
                          fontSize: isTablet ? 15 : 14,
                          fontWeight: FontWeight.w700,
                          color: canFinish
                              ? Colors.white
                              : const Color(0xFF718096),
                          letterSpacing: 0.2,
                        ),
                      ),
                    ],
                  ),
          ),
        ),
      ),
    );
  }
}
