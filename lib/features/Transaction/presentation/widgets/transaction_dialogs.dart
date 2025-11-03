// lib/features/Transaction/presentation/widgets/transaction_dialogs.dart
import 'package:flutter/material.dart';
import 'package:stock_up/core/resources/routes_manager.dart';

class TransactionDialogs {
  // حوار تأكيد مسح جميع المعاملات
  static void showClearConfirmationDialog(
    BuildContext context, {
    required VoidCallback onConfirm,
  }) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Row(
          children: [
            Icon(Icons.warning, color: Color(0xFFFF9500)),
            SizedBox(width: 8),
            Text('تأكيد المسح'),
          ],
        ),
        content: const Text('هل أنت متأكد من رغبتك في مسح جميع المعاملات؟'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('إلغاء'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).pop();
              onConfirm();
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFFF3B30),
              foregroundColor: Colors.white,
            ),
            child: const Text('مسح الكل'),
          ),
        ],
      ),
    );
  }

  // حوار تأكيد إنهاء الوردية
  static void showFinishShiftConfirmationDialog(
    BuildContext context, {
    required double totalPositive,
    required double totalNegative,
    required double netAmount,
    required int transactionCount,
    required VoidCallback onConfirm,
  }) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Row(
          children: [
            Icon(Icons.warning, color: Color(0xFFFF9500)),
            SizedBox(width: 8),
            Text('إنهاء الوردية'),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              '⚠️ تحذير: سيتم إنهاء الوردية نهائياً وإرسال جميع المعاملات إلى الخادم.',
              style: TextStyle(
                fontWeight: FontWeight.w600,
                color: Color(0xFFFF9500),
              ),
            ),
            const SizedBox(height: 16),
            const Text('ملخص المعاملات:'),
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: const Color(0xFFF8F9FA),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('عدد المعاملات: $transactionCount'),
                  Text(
                    'إجمالي المبيعات: ${totalPositive.toStringAsFixed(2)} ر.س',
                  ),
                  Text(
                    'إجمالي المصروفات: ${totalNegative.toStringAsFixed(2)} ر.س',
                  ),
                  const Divider(),
                  Text(
                    'الصافي: ${netAmount.toStringAsFixed(2)} ر.س',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: netAmount >= 0
                          ? const Color(0xFF28A745)
                          : const Color(0xFFFF3B30),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 12),
            const Text(
              'لن تتمكن من التراجع بعد الإرسال.',
              style: TextStyle(
                fontSize: 12,
                color: Color(0xFF666666),
                fontStyle: FontStyle.italic,
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('إلغاء'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).pop();
              onConfirm();
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFFF9500),
              foregroundColor: Colors.white,
            ),
            child: const Text('تأكيد الإنهاء'),
          ),
        ],
      ),
    );
  }

  // حوار نجح الإرسال
  static void showSuccessDialog(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 80,
              height: 80,
              decoration: const BoxDecoration(
                color: Color(0xFF28A745),
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.check, color: Colors.white, size: 50),
            ),
            const SizedBox(height: 16),
            const Text(
              'تم إنهاء الوردية بنجاح',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            const Text(
              'تم إرسال جميع المعاملات وإنهاء الوردية.',
              textAlign: TextAlign.center,
              style: TextStyle(color: Color(0xFF666666)),
            ),
          ],
        ),
        actions: [
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).pop(); // إغلاق الحوار
              Navigator.pushReplacementNamed(context, RoutesManager.loginPage);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF28A745),
              foregroundColor: Colors.white,
              minimumSize: const Size(double.infinity, 48),
            ),
            child: const Text('العودة للرئيسية'),
          ),
        ],
      ),
    );
  }

  // حوار خطأ في الإرسال
  static void showErrorDialog(BuildContext context, String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Row(
          children: [
            Icon(Icons.error, color: Color(0xFFFF3B30)),
            SizedBox(width: 8),
            Text('خطأ في الإرسال'),
          ],
        ),
        content: Text('حدث خطأ أثناء إرسال المعاملات:\n$message'),
        actions: [
          ElevatedButton(
            onPressed: () => Navigator.of(context).pop(),
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFFF3B30),
              foregroundColor: Colors.white,
            ),
            child: const Text('حسناً'),
          ),
        ],
      ),
    );
  }
}
