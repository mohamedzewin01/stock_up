// lib/features/Transaction/presentation/widgets/transaction_bottom_bar.dart
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
      padding: EdgeInsets.all(isTablet ? 20 : 16),
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(
          top: BorderSide(
            color: Color(0xFFE5E5E5),
            width: 1,
          ),
        ),
      ),
      child: SafeArea(
        child: BlocBuilder<TransactionCubit, TransactionState>(
          builder: (context, state) {
            final isLoading = state is TransactionLoading;

            return Row(
              children: [
                // زر مسح الكل
                if (hasTransactions) ...[
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: isLoading ? null : onClearAll,
                      icon: const Icon(Icons.clear_all),
                      label: const Text('مسح الكل'),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: const Color(0xFFFF3B30),
                        side: const BorderSide(color: Color(0xFFFF3B30)),
                        padding: EdgeInsets.symmetric(vertical: isTablet ? 16 : 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                ],

                // زر إنهاء الوردية وإرسال المعاملات
                Expanded(
                  flex: 2,
                  child: ElevatedButton.icon(
                    onPressed: !hasTransactions || isLoading ? null : onFinishShift,
                    icon: isLoading
                        ? SizedBox(
                      width: isTablet ? 20 : 16,
                      height: isTablet ? 20 : 16,
                      child: const CircularProgressIndicator(
                        color: Colors.white,
                        strokeWidth: 2,
                      ),
                    )
                        : const Icon(Icons.send),
                    label: Text(
                      isLoading ? 'جاري الإرسال...' : 'إنهاء الوردية وإرسال',
                      style: TextStyle(
                        fontSize: isTablet ? 16 : 14,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF007AFF),
                      foregroundColor: Colors.white,
                      disabledBackgroundColor: const Color(0xFF007AFF).withOpacity(0.6),
                      padding: EdgeInsets.symmetric(vertical: isTablet ? 16 : 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}