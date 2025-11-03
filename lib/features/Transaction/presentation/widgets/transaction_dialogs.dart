// // lib/features/Transaction/presentation/widgets/transaction_dialogs.dart
// import 'package:flutter/material.dart';
// import 'package:stock_up/core/resources/routes_manager.dart';
//
// class TransactionDialogs {
//   // حوار تأكيد مسح جميع المعاملات
//   static void showClearConfirmationDialog(
//     BuildContext context, {
//     required VoidCallback onConfirm,
//   }) {
//     showDialog(
//       context: context,
//       builder: (context) => AlertDialog(
//         shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
//         title: const Row(
//           children: [
//             Icon(Icons.warning, color: Color(0xFFFF9500)),
//             SizedBox(width: 8),
//             Text('تأكيد المسح'),
//           ],
//         ),
//         content: const Text('هل أنت متأكد من رغبتك في مسح جميع المعاملات؟'),
//         actions: [
//           TextButton(
//             onPressed: () => Navigator.of(context).pop(),
//             child: const Text('إلغاء'),
//           ),
//           ElevatedButton(
//             onPressed: () {
//               Navigator.of(context).pop();
//               onConfirm();
//             },
//             style: ElevatedButton.styleFrom(
//               backgroundColor: const Color(0xFFFF3B30),
//               foregroundColor: Colors.white,
//             ),
//             child: const Text('مسح الكل'),
//           ),
//         ],
//       ),
//     );
//   }
//
//   // حوار تأكيد إنهاء الوردية
//   static void showFinishShiftConfirmationDialog(
//     BuildContext context, {
//     required double totalPositive,
//     required double totalNegative,
//     required double netAmount,
//     required int transactionCount,
//     required VoidCallback onConfirm,
//   }) {
//     showDialog(
//       context: context,
//       builder: (context) => AlertDialog(
//         shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
//         title: const Row(
//           children: [
//             Icon(Icons.warning, color: Color(0xFFFF9500)),
//             SizedBox(width: 8),
//             Text('إنهاء الوردية'),
//           ],
//         ),
//         content: Column(
//           mainAxisSize: MainAxisSize.min,
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             const Text(
//               '⚠️ تحذير: سيتم إنهاء الوردية نهائياً وإرسال جميع المعاملات إلى الخادم.',
//               style: TextStyle(
//                 fontWeight: FontWeight.w600,
//                 color: Color(0xFFFF9500),
//               ),
//             ),
//             const SizedBox(height: 16),
//             const Text('ملخص المعاملات:'),
//             const SizedBox(height: 8),
//             Container(
//               padding: const EdgeInsets.all(12),
//               decoration: BoxDecoration(
//                 color: const Color(0xFFF8F9FA),
//                 borderRadius: BorderRadius.circular(8),
//               ),
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Text('عدد المعاملات: $transactionCount'),
//                   Text(
//                     'إجمالي المبيعات: ${totalPositive.toStringAsFixed(2)} ر.س',
//                   ),
//                   Text(
//                     'إجمالي المصروفات: ${totalNegative.toStringAsFixed(2)} ر.س',
//                   ),
//                   const Divider(),
//                   Text(
//                     'الصافي: ${netAmount.toStringAsFixed(2)} ر.س',
//                     style: TextStyle(
//                       fontWeight: FontWeight.bold,
//                       color: netAmount >= 0
//                           ? const Color(0xFF28A745)
//                           : const Color(0xFFFF3B30),
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//             const SizedBox(height: 12),
//             const Text(
//               'لن تتمكن من التراجع بعد الإرسال.',
//               style: TextStyle(
//                 fontSize: 12,
//                 color: Color(0xFF666666),
//                 fontStyle: FontStyle.italic,
//               ),
//             ),
//           ],
//         ),
//         actions: [
//           TextButton(
//             onPressed: () => Navigator.of(context).pop(),
//             child: const Text('إلغاء'),
//           ),
//           ElevatedButton(
//             onPressed: () {
//               Navigator.of(context).pop();
//               onConfirm();
//             },
//             style: ElevatedButton.styleFrom(
//               backgroundColor: const Color(0xFFFF9500),
//               foregroundColor: Colors.white,
//             ),
//             child: const Text('تأكيد الإنهاء'),
//           ),
//         ],
//       ),
//     );
//   }
//
//   // حوار نجح الإرسال
//   static void showSuccessDialog(BuildContext context) {
//     showDialog(
//       context: context,
//       barrierDismissible: false,
//       builder: (context) => AlertDialog(
//         shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
//         content: Column(
//           mainAxisSize: MainAxisSize.min,
//           children: [
//             Container(
//               width: 80,
//               height: 80,
//               decoration: const BoxDecoration(
//                 color: Color(0xFF28A745),
//                 shape: BoxShape.circle,
//               ),
//               child: const Icon(Icons.check, color: Colors.white, size: 50),
//             ),
//             const SizedBox(height: 16),
//             const Text(
//               'تم إنهاء الوردية بنجاح',
//               style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
//             ),
//             const SizedBox(height: 8),
//             const Text(
//               'تم إرسال جميع المعاملات وإنهاء الوردية.',
//               textAlign: TextAlign.center,
//               style: TextStyle(color: Color(0xFF666666)),
//             ),
//           ],
//         ),
//         actions: [
//           ElevatedButton(
//             onPressed: () {
//               Navigator.of(context).pop(); // إغلاق الحوار
//               Navigator.pushReplacementNamed(context, RoutesManager.loginPage);
//             },
//             style: ElevatedButton.styleFrom(
//               backgroundColor: const Color(0xFF28A745),
//               foregroundColor: Colors.white,
//               minimumSize: const Size(double.infinity, 48),
//             ),
//             child: const Text('العودة للرئيسية'),
//           ),
//         ],
//       ),
//     );
//   }
//
//   // حوار خطأ في الإرسال
//   static void showErrorDialog(BuildContext context, String message) {
//     showDialog(
//       context: context,
//       builder: (context) => AlertDialog(
//         shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
//         title: const Row(
//           children: [
//             Icon(Icons.error, color: Color(0xFFFF3B30)),
//             SizedBox(width: 8),
//             Text('خطأ في الإرسال'),
//           ],
//         ),
//         content: Text('حدث خطأ أثناء إرسال المعاملات:\n$message'),
//         actions: [
//           ElevatedButton(
//             onPressed: () => Navigator.of(context).pop(),
//             style: ElevatedButton.styleFrom(
//               backgroundColor: const Color(0xFFFF3B30),
//               foregroundColor: Colors.white,
//             ),
//             child: const Text('حسناً'),
//           ),
//         ],
//       ),
//     );
//   }
// }

// lib/features/Transaction/presentation/widgets/transaction_dialogs.dart
import 'package:flutter/material.dart';
import 'package:stock_up/core/resources/routes_manager.dart';
import 'package:stock_up/core/utils/cashed_data_shared_preferences.dart';

import 'PdfService.dart';

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

  // ====================================================================
  // 🆕 حوار نجاح الإرسال المحدث (مع ميزة إرسال PDF)
  // ====================================================================
  static void showSuccessDialog(
    BuildContext context, {
    int? shiftId,
    double? totalPositive,
    double? totalNegative,
    double? netAmount,
    int? transactionCount,
  }) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Animation success icon
            TweenAnimationBuilder<double>(
              duration: const Duration(milliseconds: 600),
              tween: Tween(begin: 0.0, end: 1.0),
              curve: Curves.elasticOut,
              builder: (context, value, child) {
                return Transform.scale(
                  scale: value,
                  child: Container(
                    width: 80,
                    height: 80,
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [Color(0xFF28A745), Color(0xFF20C997)],
                      ),
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: const Color(0xFF28A745).withOpacity(0.3),
                          blurRadius: 20,
                          offset: const Offset(0, 10),
                        ),
                      ],
                    ),
                    child: const Icon(
                      Icons.check_circle_outline,
                      color: Colors.white,
                      size: 50,
                    ),
                  ),
                );
              },
            ),
            const SizedBox(height: 20),
            const Text(
              'تم إنهاء الوردية بنجاح! 🎉',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Color(0xFF2D3748),
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: const Color(0xFFF0FDF4),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: const Color(0xFF28A745).withOpacity(0.2),
                ),
              ),
              child: const Row(
                children: [
                  Icon(Icons.check_circle, color: Color(0xFF28A745), size: 20),
                  SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      'تم إرسال جميع المعاملات بنجاح',
                      style: TextStyle(
                        color: Color(0xFF166534),
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        actions: [
          // زر إرسال PDF
          OutlinedButton.icon(
            onPressed: () {
              Navigator.of(context).pop();
              _showSendPdfDialog(
                context,
                shiftId: shiftId,
                totalPositive: totalPositive,
                totalNegative: totalNegative,
                netAmount: netAmount,
                transactionCount: transactionCount,
              );
            },
            icon: const Icon(Icons.picture_as_pdf, size: 20),
            label: const Text('إرسال PDF'),
            style: OutlinedButton.styleFrom(
              foregroundColor: const Color(0xFF667EEA),
              side: const BorderSide(color: Color(0xFF667EEA)),
              padding: const EdgeInsets.symmetric(vertical: 14),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
          const SizedBox(height: 8),
          // زر العودة للرئيسية
          ElevatedButton.icon(
            onPressed: () {
              Navigator.of(context).pop();
              Navigator.pushReplacementNamed(context, RoutesManager.loginPage);
            },
            icon: const Icon(Icons.home, size: 20),
            label: const Text('العودة للرئيسية'),
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF28A745),
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 14),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              elevation: 2,
            ),
          ),
        ],
      ),
    );
  }

  // ====================================================================
  // 🆕 حوار إرسال PDF
  // ====================================================================
  static void _showSendPdfDialog(
    BuildContext context, {
    int? shiftId,
    double? totalPositive,
    double? totalNegative,
    double? netAmount,
    int? transactionCount,
  }) {
    final userPhone = CacheService.getData(key: CacheKeys.userPhone) ?? '';
    final formattedPhone = _formatPhoneNumber(userPhone);
    bool useOtherNumber = false;
    final phoneController = TextEditingController();

    showDialog(
      context: context,
      builder: (dialogContext) => StatefulBuilder(
        builder: (context, setState) {
          return AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(24),
            ),
            contentPadding: const EdgeInsets.all(24),
            content: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Header
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [Color(0xFF667EEA), Color(0xFF764BA2)],
                      ),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: const Column(
                      children: [
                        Icon(
                          Icons.picture_as_pdf,
                          color: Colors.white,
                          size: 48,
                        ),
                        SizedBox(height: 12),
                        Text(
                          'إرسال تقرير PDF',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 4),
                        Text(
                          'سيتم إرسال ملخص الوردية عبر واتساب',
                          style: TextStyle(color: Colors.white, fontSize: 13),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),

                  // معلومات الوردية
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: const Color(0xFFF8F9FA),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: const Color(0xFFE2E8F0)),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Row(
                          children: [
                            Icon(
                              Icons.summarize,
                              color: Color(0xFF667EEA),
                              size: 20,
                            ),
                            SizedBox(width: 8),
                            Text(
                              'ملخص الوردية',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 14,
                              ),
                            ),
                          ],
                        ),
                        const Divider(height: 16),
                        _buildInfoRow('رقم الوردية', '#${shiftId ?? 'N/A'}'),
                        _buildInfoRow(
                          'عدد المعاملات',
                          '${transactionCount ?? 0}',
                        ),
                        _buildInfoRow(
                          'إجمالي الدخل',
                          '${totalPositive?.toStringAsFixed(2) ?? '0.00'} ر.س',
                        ),
                        _buildInfoRow(
                          'إجمالي المصروفات',
                          '${totalNegative?.toStringAsFixed(2) ?? '0.00'} ر.س',
                        ),
                        const Divider(height: 12),
                        _buildInfoRow(
                          'الصافي',
                          '${netAmount?.toStringAsFixed(2) ?? '0.00'} ر.س',
                          isHighlight: true,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),

                  // اختيار رقم الإرسال
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'إرسال إلى:',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 15,
                        ),
                      ),
                      const SizedBox(height: 12),

                      // خيار الرقم المحفوظ
                      if (formattedPhone.isNotEmpty)
                        InkWell(
                          onTap: () {
                            setState(() {
                              useOtherNumber = false;
                            });
                          },
                          borderRadius: BorderRadius.circular(12),
                          child: Container(
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: !useOtherNumber
                                  ? const Color(0xFF667EEA).withOpacity(0.1)
                                  : Colors.white,
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(
                                color: !useOtherNumber
                                    ? const Color(0xFF667EEA)
                                    : const Color(0xFFE2E8F0),
                                width: 2,
                              ),
                            ),
                            child: Row(
                              children: [
                                Icon(
                                  !useOtherNumber
                                      ? Icons.radio_button_checked
                                      : Icons.radio_button_unchecked,
                                  color: !useOtherNumber
                                      ? const Color(0xFF667EEA)
                                      : const Color(0xFF718096),
                                ),
                                const SizedBox(width: 12),
                                const Icon(
                                  Icons.phone_android,
                                  color: Color(0xFF667EEA),
                                  size: 20,
                                ),
                                const SizedBox(width: 8),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      const Text(
                                        'رقمي المسجل',
                                        style: TextStyle(
                                          fontSize: 13,
                                          color: Color(0xFF718096),
                                        ),
                                      ),
                                      Text(
                                        formattedPhone,
                                        style: const TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      const SizedBox(height: 12),

                      // خيار رقم آخر
                      InkWell(
                        onTap: () {
                          setState(() {
                            useOtherNumber = true;
                          });
                        },
                        borderRadius: BorderRadius.circular(12),
                        child: Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: useOtherNumber
                                ? const Color(0xFF667EEA).withOpacity(0.1)
                                : Colors.white,
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color: useOtherNumber
                                  ? const Color(0xFF667EEA)
                                  : const Color(0xFFE2E8F0),
                              width: 2,
                            ),
                          ),
                          child: Row(
                            children: [
                              Icon(
                                useOtherNumber
                                    ? Icons.radio_button_checked
                                    : Icons.radio_button_unchecked,
                                color: useOtherNumber
                                    ? const Color(0xFF667EEA)
                                    : const Color(0xFF718096),
                              ),
                              const SizedBox(width: 12),
                              const Icon(
                                Icons.edit_note,
                                color: Color(0xFF667EEA),
                                size: 20,
                              ),
                              const SizedBox(width: 8),
                              const Expanded(
                                child: Text(
                                  'رقم آخر',
                                  style: TextStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),

                      // حقل إدخال الرقم
                      if (useOtherNumber) ...[
                        const SizedBox(height: 12),
                        TextField(
                          controller: phoneController,
                          keyboardType: TextInputType.phone,
                          decoration: InputDecoration(
                            labelText: 'رقم الجوال',
                            hintText: '5xxxxxxxx',
                            prefixIcon: Container(
                              margin: const EdgeInsets.all(12),
                              padding: const EdgeInsets.symmetric(
                                horizontal: 12,
                                vertical: 8,
                              ),
                              decoration: BoxDecoration(
                                color: const Color(0xFF667EEA).withOpacity(0.1),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: const Text(
                                '+966',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xFF667EEA),
                                ),
                              ),
                            ),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: const BorderSide(
                                color: Color(0xFF667EEA),
                                width: 2,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ],
                  ),
                ],
              ),
            ),
            actions: [
              // زر إلغاء
              OutlinedButton(
                onPressed: () => Navigator.of(context).pop(),
                style: OutlinedButton.styleFrom(
                  foregroundColor: const Color(0xFF718096),
                  side: const BorderSide(color: Color(0xFFE2E8F0)),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 24,
                    vertical: 14,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text('إلغاء'),
              ),
              // زر إرسال
              ElevatedButton.icon(
                onPressed: () {
                  final phoneToSend = useOtherNumber
                      ? '+966${phoneController.text.trim()}'
                      : formattedPhone;

                  if (phoneToSend.isEmpty ||
                      (useOtherNumber && phoneController.text.trim().isEmpty)) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('الرجاء إدخال رقم الجوال'),
                        backgroundColor: Colors.red,
                      ),
                    );
                    return;
                  }

                  Navigator.of(context).pop();
                  _sendPdfToWhatsApp(
                    context,
                    phoneNumber: phoneToSend,
                    shiftId: shiftId,
                    totalPositive: totalPositive,
                    totalNegative: totalNegative,
                    netAmount: netAmount,
                    transactionCount: transactionCount,
                  );
                },
                icon: const Icon(Icons.send, size: 20),
                label: const Text('إرسال'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF25D366),
                  // WhatsApp color
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 32,
                    vertical: 14,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  elevation: 2,
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  // ====================================================================
  // 🆕 إرسال PDF عبر واتساب
  // ====================================================================
  static Future<void> _sendPdfToWhatsApp(
    BuildContext context, {
    required String phoneNumber,
    int? shiftId,
    double? totalPositive,
    double? totalNegative,
    double? netAmount,
    int? transactionCount,
  }) async {
    // إظهار loader
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => WillPopScope(
        onWillPop: () async => false,
        child: AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const CircularProgressIndicator(color: Color(0xFF667EEA)),
              const SizedBox(height: 20),
              const Text(
                'جاري إنشاء وإرسال PDF...',
                style: TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
              ),
              const SizedBox(height: 8),
              Text(
                'الرجاء الانتظار',
                style: TextStyle(color: Colors.grey[600], fontSize: 13),
              ),
            ],
          ),
        ),
      ),
    );

    try {
      // إنشاء وإرسال PDF
      await PdfService.generateAndSendShiftPdf(
        phoneNumber: phoneNumber,
        shiftId: shiftId ?? 0,
        totalPositive: totalPositive ?? 0,
        totalNegative: totalNegative ?? 0,
        netAmount: netAmount ?? 0,
        transactionCount: transactionCount ?? 0,
      );

      // إغلاق loader
      if (context.mounted) {
        Navigator.of(context).pop();

        // إظهار رسالة نجاح
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: const Color(0xFF25D366).withOpacity(0.1),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.check_circle,
                    color: Color(0xFF25D366),
                    size: 64,
                  ),
                ),
                const SizedBox(height: 20),
                const Text(
                  'تم المشاركة بنجاح! ✓',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 12),
                const Text(
                  'تم مشاركة تقرير الوردية\nيمكنك الآن إرساله عبر واتساب',
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Color(0xFF718096), fontSize: 14),
                ),
              ],
            ),
            actions: [
              ElevatedButton(
                onPressed: () {
                  Navigator.of(context).pop();
                  Navigator.pushReplacementNamed(
                    context,
                    RoutesManager.loginPage,
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF667EEA),
                  foregroundColor: Colors.white,
                  minimumSize: const Size(double.infinity, 48),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text('العودة للرئيسية'),
              ),
            ],
          ),
        );
      }
    } catch (e) {
      // إغلاق loader
      if (context.mounted) {
        Navigator.of(context).pop();

        // إظهار رسالة خطأ
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            title: const Row(
              children: [
                Icon(Icons.error, color: Colors.red),
                SizedBox(width: 12),
                Text('فشل الإرسال'),
              ],
            ),
            content: Text('حدث خطأ أثناء إرسال PDF:\n${e.toString()}'),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: const Text('إغلاق'),
              ),
              ElevatedButton(
                onPressed: () {
                  Navigator.of(context).pop();
                  _showSendPdfDialog(
                    context,
                    shiftId: shiftId,
                    totalPositive: totalPositive,
                    totalNegative: totalNegative,
                    netAmount: netAmount,
                    transactionCount: transactionCount,
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF667EEA),
                ),
                child: const Text('إعادة المحاولة'),
              ),
            ],
          ),
        );
      }
    }
  }

  // static Future<void> _sendPdfToWhatsApp(
  //   BuildContext context, {
  //   required String phoneNumber,
  //   int? shiftId,
  //   double? totalPositive,
  //   double? totalNegative,
  //   double? netAmount,
  //   int? transactionCount,
  // }) async {
  //   // إظهار loader
  //   showDialog(
  //     context: context,
  //     barrierDismissible: false,
  //     builder: (context) => WillPopScope(
  //       onWillPop: () async => false,
  //       child: AlertDialog(
  //         shape: RoundedRectangleBorder(
  //           borderRadius: BorderRadius.circular(20),
  //         ),
  //         content: Column(
  //           mainAxisSize: MainAxisSize.min,
  //           children: [
  //             const CircularProgressIndicator(color: Color(0xFF667EEA)),
  //             const SizedBox(height: 20),
  //             const Text(
  //               'جاري إنشاء وإرسال PDF...',
  //               style: TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
  //             ),
  //             const SizedBox(height: 8),
  //             Text(
  //               'الرجاء الانتظار',
  //               style: TextStyle(color: Colors.grey[600], fontSize: 13),
  //             ),
  //           ],
  //         ),
  //       ),
  //     ),
  //   );
  //
  //   try {
  //     await PdfService.generateAndSendShiftPdf(
  //       phoneNumber: phoneNumber,
  //       shiftId: shiftId ?? 0,
  //       totalPositive: totalPositive ?? 0,
  //       totalNegative: totalNegative ?? 0,
  //       netAmount: netAmount ?? 0,
  //       transactionCount: transactionCount ?? 0,
  //     );
  //
  //     // محاكاة العملية (احذف هذا السطر عند تفعيل PDF الحقيقي)
  //     await Future.delayed(const Duration(seconds: 2));
  //
  //     Navigator.of(context).pop(); // إغلاق loader
  //
  //     // إظهار رسالة نجاح
  //     showDialog(
  //       context: context,
  //       builder: (context) => AlertDialog(
  //         shape: RoundedRectangleBorder(
  //           borderRadius: BorderRadius.circular(20),
  //         ),
  //         content: Column(
  //           mainAxisSize: MainAxisSize.min,
  //           children: [
  //             Container(
  //               padding: const EdgeInsets.all(16),
  //               decoration: BoxDecoration(
  //                 color: const Color(0xFF25D366).withOpacity(0.1),
  //                 shape: BoxShape.circle,
  //               ),
  //               child: const Icon(
  //                 Icons.check_circle,
  //                 color: Color(0xFF25D366),
  //                 size: 64,
  //               ),
  //             ),
  //             const SizedBox(height: 20),
  //             const Text(
  //               'تم الإرسال بنجاح! ✓',
  //               style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
  //             ),
  //             const SizedBox(height: 12),
  //             Text(
  //               'تم إرسال تقرير الوردية عبر واتساب إلى:\n$phoneNumber',
  //               textAlign: TextAlign.center,
  //               style: const TextStyle(color: Color(0xFF718096), fontSize: 14),
  //             ),
  //           ],
  //         ),
  //         actions: [
  //           ElevatedButton(
  //             onPressed: () {
  //               Navigator.of(context).pop(); // إغلاق dialog النجاح
  //               Navigator.pushReplacementNamed(
  //                 context,
  //                 RoutesManager.loginPage,
  //               );
  //             },
  //             style: ElevatedButton.styleFrom(
  //               backgroundColor: const Color(0xFF667EEA),
  //               foregroundColor: Colors.white,
  //               minimumSize: const Size(double.infinity, 48),
  //               shape: RoundedRectangleBorder(
  //                 borderRadius: BorderRadius.circular(12),
  //               ),
  //             ),
  //             child: const Text('العودة للرئيسية'),
  //           ),
  //         ],
  //       ),
  //     );
  //   } catch (e) {
  //     Navigator.of(context).pop(); // إغلاق loader
  //
  //     // إظهار رسالة خطأ
  //     showDialog(
  //       context: context,
  //       builder: (context) => AlertDialog(
  //         shape: RoundedRectangleBorder(
  //           borderRadius: BorderRadius.circular(20),
  //         ),
  //         title: const Row(
  //           children: [
  //             Icon(Icons.error, color: Colors.red),
  //             SizedBox(width: 12),
  //             Text('فشل الإرسال'),
  //           ],
  //         ),
  //         content: Text('حدث خطأ أثناء إرسال PDF:\n${e.toString()}'),
  //         actions: [
  //           TextButton(
  //             onPressed: () => Navigator.of(context).pop(),
  //             child: const Text('إغلاق'),
  //           ),
  //           ElevatedButton(
  //             onPressed: () {
  //               Navigator.of(context).pop();
  //               _showSendPdfDialog(
  //                 context,
  //                 shiftId: shiftId,
  //                 totalPositive: totalPositive,
  //                 totalNegative: totalNegative,
  //                 netAmount: netAmount,
  //                 transactionCount: transactionCount,
  //               );
  //             },
  //             style: ElevatedButton.styleFrom(
  //               backgroundColor: const Color(0xFF667EEA),
  //             ),
  //             child: const Text('إعادة المحاولة'),
  //           ),
  //         ],
  //       ),
  //     );
  //   }
  // }

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

  // ====================================================================
  // 🆕 دوال مساعدة
  // ====================================================================
  static Widget _buildInfoRow(
    String label,
    String value, {
    bool isHighlight = false,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              color: isHighlight
                  ? const Color(0xFF667EEA)
                  : const Color(0xFF718096),
              fontSize: 13,
              fontWeight: isHighlight ? FontWeight.bold : FontWeight.normal,
            ),
          ),
          Text(
            value,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: isHighlight ? 16 : 14,
              color: isHighlight
                  ? const Color(0xFF667EEA)
                  : const Color(0xFF2D3748),
            ),
          ),
        ],
      ),
    );
  }

  static String _formatPhoneNumber(String phone) {
    if (phone.isEmpty) return '';
    // إزالة أي رموز أو مسافات
    phone = phone.replaceAll(RegExp(r'[^\d+]'), '');
    // التأكد من وجود +966
    if (!phone.startsWith('+966')) {
      if (phone.startsWith('966')) {
        phone = '+$phone';
      } else if (phone.startsWith('0')) {
        phone = '+966${phone.substring(1)}';
      } else {
        phone = '+966$phone';
      }
    }
    return phone;
  }
}
