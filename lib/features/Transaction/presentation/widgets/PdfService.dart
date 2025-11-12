// import 'dart:io';
//
// import 'package:flutter/services.dart';
// import 'package:intl/intl.dart';
// import 'package:path_provider/path_provider.dart';
// import 'package:pdf/pdf.dart';
// import 'package:pdf/widgets.dart' as pw;
// import 'package:share_plus/share_plus.dart';
//
// /// خدمة إنشاء وإرسال PDF للورديات
// class PdfService {
//   /// إنشاء PDF لتقرير الوردية
//   static Future<File> generateShiftPdf({
//     required int shiftId,
//     required double totalPositive,
//     required double totalNegative,
//     required double netAmount,
//     required int transactionCount,
//     String? userName,
//     String? storeName,
//   }) async {
//     final pdf = pw.Document();
//     final now = DateTime.now();
//     final dateFormat = DateFormat('yyyy/MM/dd - hh:mm a');
//     final formattedDate = dateFormat.format(now);
//
//     // تحميل الخطوط العربية
//     final fontRegular = await rootBundle.load('assets/fonts/Cairo-Regular.ttf');
//     final fontBold = await rootBundle.load('assets/fonts/Cairo-Bold.ttf');
//
//     final ttfRegular = pw.Font.ttf(fontRegular);
//     final ttfBold = pw.Font.ttf(fontBold);
//
//     pdf.addPage(
//       pw.Page(
//         pageFormat: PdfPageFormat.a4,
//         textDirection: pw.TextDirection.rtl,
//         theme: pw.ThemeData.withFont(base: ttfRegular, bold: ttfBold),
//         build: (pw.Context context) {
//           return pw.Column(
//             crossAxisAlignment: pw.CrossAxisAlignment.start,
//             children: [
//               // Header
//               pw.Container(
//                 padding: const pw.EdgeInsets.all(20),
//                 decoration: pw.BoxDecoration(
//                   color: PdfColor.fromHex('#667EEA'),
//                   borderRadius: const pw.BorderRadius.all(
//                     pw.Radius.circular(12),
//                   ),
//                 ),
//                 child: pw.Column(
//                   crossAxisAlignment: pw.CrossAxisAlignment.center,
//                   children: [
//                     pw.Text(
//                       'تقرير الوردية',
//                       textDirection: pw.TextDirection.rtl,
//                       style: pw.TextStyle(
//                         fontSize: 28,
//                         font: ttfBold,
//                         color: PdfColors.white,
//                       ),
//                     ),
//                     pw.SizedBox(height: 8),
//                     pw.Text(
//                       formattedDate,
//                       textDirection: pw.TextDirection.rtl,
//                       style: pw.TextStyle(
//                         fontSize: 14,
//                         font: ttfRegular,
//                         color: PdfColors.white,
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//
//               pw.SizedBox(height: 30),
//
//               // معلومات الوردية
//               pw.Container(
//                 padding: const pw.EdgeInsets.all(16),
//                 decoration: pw.BoxDecoration(
//                   border: pw.Border.all(
//                     color: PdfColor.fromHex('#E2E8F0'),
//                     width: 2,
//                   ),
//                   borderRadius: const pw.BorderRadius.all(
//                     pw.Radius.circular(12),
//                   ),
//                 ),
//                 child: pw.Column(
//                   crossAxisAlignment: pw.CrossAxisAlignment.start,
//                   children: [
//                     pw.Text(
//                       'معلومات الوردية',
//                       textDirection: pw.TextDirection.rtl,
//                       style: pw.TextStyle(
//                         fontSize: 18,
//                         font: ttfBold,
//                         color: PdfColor.fromHex('#2D3748'),
//                       ),
//                     ),
//                     pw.SizedBox(height: 12),
//                     pw.Divider(color: PdfColor.fromHex('#E2E8F0')),
//                     pw.SizedBox(height: 12),
//                     _buildInfoRow(
//                       'رقم الوردية',
//                       '#$shiftId',
//                       ttfRegular,
//                       ttfBold,
//                     ),
//                     _buildInfoRow(
//                       'اسم الموظف',
//                       userName ?? 'غير محدد',
//                       ttfRegular,
//                       ttfBold,
//                     ),
//                     _buildInfoRow(
//                       'المتجر',
//                       storeName ?? 'غير محدد',
//                       ttfRegular,
//                       ttfBold,
//                     ),
//                     _buildInfoRow(
//                       'عدد المعاملات',
//                       '$transactionCount',
//                       ttfRegular,
//                       ttfBold,
//                     ),
//                   ],
//                 ),
//               ),
//
//               pw.SizedBox(height: 20),
//
//               // الإحصائيات المالية
//               pw.Container(
//                 padding: const pw.EdgeInsets.all(16),
//                 decoration: pw.BoxDecoration(
//                   color: PdfColor.fromHex('#F8F9FA'),
//                   borderRadius: const pw.BorderRadius.all(
//                     pw.Radius.circular(12),
//                   ),
//                 ),
//                 child: pw.Column(
//                   crossAxisAlignment: pw.CrossAxisAlignment.start,
//                   children: [
//                     pw.Text(
//                       'الإحصائيات المالية',
//                       textDirection: pw.TextDirection.rtl,
//                       style: pw.TextStyle(
//                         fontSize: 18,
//                         font: ttfBold,
//                         color: PdfColor.fromHex('#2D3748'),
//                       ),
//                     ),
//                     pw.SizedBox(height: 12),
//                     pw.Divider(color: PdfColor.fromHex('#E2E8F0')),
//                     pw.SizedBox(height: 12),
//
//                     // إجمالي الدخل
//                     pw.Container(
//                       padding: const pw.EdgeInsets.all(12),
//                       decoration: pw.BoxDecoration(
//                         color: PdfColor.fromHex('#D1FAE5'),
//                         borderRadius: const pw.BorderRadius.all(
//                           pw.Radius.circular(8),
//                         ),
//                       ),
//                       child: pw.Row(
//                         mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
//                         children: [
//                           pw.Text(
//                             'إجمالي المبيعات والدخل',
//                             textDirection: pw.TextDirection.rtl,
//                             style: pw.TextStyle(
//                               fontSize: 14,
//                               font: ttfBold,
//                               color: PdfColor.fromHex('#059669'),
//                             ),
//                           ),
//                           pw.Text(
//                             '${totalPositive.toStringAsFixed(2)} ر.س',
//                             textDirection: pw.TextDirection.rtl,
//                             style: pw.TextStyle(
//                               fontSize: 16,
//                               font: ttfBold,
//                               color: PdfColor.fromHex('#059669'),
//                             ),
//                           ),
//                         ],
//                       ),
//                     ),
//
//                     pw.SizedBox(height: 8),
//
//                     // إجمالي المصروفات
//                     pw.Container(
//                       padding: const pw.EdgeInsets.all(12),
//                       decoration: pw.BoxDecoration(
//                         color: PdfColor.fromHex('#FEE2E2'),
//                         borderRadius: const pw.BorderRadius.all(
//                           pw.Radius.circular(8),
//                         ),
//                       ),
//                       child: pw.Row(
//                         mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
//                         children: [
//                           pw.Text(
//                             'إجمالي المصروفات والمدفوعات',
//                             textDirection: pw.TextDirection.rtl,
//                             style: pw.TextStyle(
//                               fontSize: 14,
//                               font: ttfBold,
//                               color: PdfColor.fromHex('#DC2626'),
//                             ),
//                           ),
//                           pw.Text(
//                             '${totalNegative.toStringAsFixed(2)} ر.س',
//                             textDirection: pw.TextDirection.rtl,
//                             style: pw.TextStyle(
//                               fontSize: 16,
//                               font: ttfBold,
//                               color: PdfColor.fromHex('#DC2626'),
//                             ),
//                           ),
//                         ],
//                       ),
//                     ),
//
//                     pw.SizedBox(height: 16),
//                     pw.Divider(
//                       color: PdfColor.fromHex('#667EEA'),
//                       thickness: 2,
//                     ),
//                     pw.SizedBox(height: 8),
//
//                     // الصافي
//                     pw.Container(
//                       padding: const pw.EdgeInsets.all(16),
//                       decoration: pw.BoxDecoration(
//                         color: netAmount >= 0
//                             ? PdfColor.fromHex('#D1FAE5')
//                             : PdfColor.fromHex('#FEE2E2'),
//                         borderRadius: const pw.BorderRadius.all(
//                           pw.Radius.circular(8),
//                         ),
//                         border: pw.Border.all(
//                           color: netAmount >= 0
//                               ? PdfColor.fromHex('#059669')
//                               : PdfColor.fromHex('#DC2626'),
//                           width: 2,
//                         ),
//                       ),
//                       child: pw.Row(
//                         mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
//                         children: [
//                           pw.Text(
//                             'الصافي',
//                             textDirection: pw.TextDirection.rtl,
//                             style: pw.TextStyle(
//                               fontSize: 18,
//                               font: ttfBold,
//                               color: netAmount >= 0
//                                   ? PdfColor.fromHex('#059669')
//                                   : PdfColor.fromHex('#DC2626'),
//                             ),
//                           ),
//                           pw.Text(
//                             '${netAmount >= 0 ? '+' : ''}${netAmount.toStringAsFixed(2)} ر.س',
//                             textDirection: pw.TextDirection.rtl,
//                             style: pw.TextStyle(
//                               fontSize: 22,
//                               font: ttfBold,
//                               color: netAmount >= 0
//                                   ? PdfColor.fromHex('#059669')
//                                   : PdfColor.fromHex('#DC2626'),
//                             ),
//                           ),
//                         ],
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//
//               pw.Spacer(),
//
//               // Footer
//               pw.Container(
//                 padding: const pw.EdgeInsets.all(16),
//                 decoration: pw.BoxDecoration(
//                   color: PdfColor.fromHex('#F8F9FA'),
//                   borderRadius: const pw.BorderRadius.all(
//                     pw.Radius.circular(8),
//                   ),
//                 ),
//                 child: pw.Column(
//                   children: [
//                     pw.Text(
//                       'تم إنشاء هذا التقرير تلقائياً',
//                       textDirection: pw.TextDirection.rtl,
//                       style: pw.TextStyle(
//                         fontSize: 10,
//                         font: ttfRegular,
//                         color: PdfColor.fromHex('#718096'),
//                       ),
//                     ),
//                     pw.SizedBox(height: 4),
//                     pw.Text(
//                       'نظام إدارة المخزون - StockUp',
//                       textDirection: pw.TextDirection.rtl,
//                       style: pw.TextStyle(
//                         fontSize: 10,
//                         font: ttfBold,
//                         color: PdfColor.fromHex('#667EEA'),
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//             ],
//           );
//         },
//       ),
//     );
//
//     // حفظ PDF
//     final output = await getTemporaryDirectory();
//     final file = File('${output.path}/shift_report_$shiftId.pdf');
//     await file.writeAsBytes(await pdf.save());
//
//     return file;
//   }
//
//   /// إرسال PDF عبر واتساب
//   static Future<void> sendPdfViaWhatsApp({
//     required String phoneNumber,
//     required File pdfFile,
//     required int shiftId,
//   }) async {
//     try {
//       final message =
//           '''
// مرحباً! 👋
//
// إليك تقرير الوردية #$shiftId
//
// تم إرساله من نظام StockUp 📊
//     ''';
//
//       final result = await Share.shareXFiles(
//         [XFile(pdfFile.path)],
//         text: message,
//         subject: 'تقرير الوردية #$shiftId',
//       );
//
//       if (result.status == ShareResultStatus.dismissed) {
//         throw Exception('تم إلغاء المشاركة');
//       }
//     } catch (e) {
//       print('Error sharing PDF: $e');
//       rethrow;
//     }
//   }
//
//   /// إنشاء وإرسال PDF (دالة شاملة)
//   static Future<void> generateAndSendShiftPdf({
//     required String phoneNumber,
//     required int shiftId,
//     required double totalPositive,
//     required double totalNegative,
//     required double netAmount,
//     required int transactionCount,
//     String? userName,
//     String? storeName,
//   }) async {
//     try {
//       final pdfFile = await generateShiftPdf(
//         shiftId: shiftId,
//         totalPositive: totalPositive,
//         totalNegative: totalNegative,
//         netAmount: netAmount,
//         transactionCount: transactionCount,
//         userName: userName,
//         storeName: storeName,
//       );
//
//       await sendPdfViaWhatsApp(
//         phoneNumber: phoneNumber,
//         pdfFile: pdfFile,
//         shiftId: shiftId,
//       );
//     } catch (e) {
//       print('Error in generateAndSendShiftPdf: $e');
//       rethrow;
//     }
//   }
//
//   /// دالة مساعدة لبناء صف معلومات
//   static pw.Widget _buildInfoRow(
//     String label,
//     String value,
//     pw.Font fontRegular,
//     pw.Font fontBold,
//   ) {
//     return pw.Padding(
//       padding: const pw.EdgeInsets.symmetric(vertical: 6),
//       child: pw.Row(
//         mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
//         children: [
//           pw.Text(
//             label,
//             textDirection: pw.TextDirection.rtl,
//             style: pw.TextStyle(
//               fontSize: 14,
//               font: fontRegular,
//               color: PdfColor.fromHex('#718096'),
//             ),
//           ),
//           pw.Text(
//             value,
//             textDirection: pw.TextDirection.rtl,
//             style: pw.TextStyle(
//               fontSize: 14,
//               font: fontBold,
//               color: PdfColor.fromHex('#2D3748'),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }

import 'dart:io';

import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:share_plus/share_plus.dart';
import 'package:stock_up/features/Transaction/presentation/widgets/transaction_types.dart';

/// خدمة إنشاء وإرسال PDF للورديات
class PdfService {
  /// إنشاء PDF لتقرير الوردية
  static Future<File> generateShiftPdf({
    required int shiftId,
    required double totalPositive,
    required double totalNegative,
    required double netAmount,
    required int transactionCount,
    required List<TransactionItem> transactions, // 🆕 إضافة قائمة المعاملات
    String? userName,
    String? storeName,
  }) async {
    final pdf = pw.Document();
    final now = DateTime.now();
    final dateFormat = DateFormat('yyyy/MM/dd - hh:mm a');
    final formattedDate = dateFormat.format(now);

    // تحميل الخطوط العربية
    final fontRegular = await rootBundle.load('assets/fonts/Cairo-Regular.ttf');
    final fontBold = await rootBundle.load('assets/fonts/Cairo-Bold.ttf');

    final ttfRegular = pw.Font.ttf(fontRegular);
    final ttfBold = pw.Font.ttf(fontBold);

    pdf.addPage(
      pw.MultiPage(
        pageFormat: PdfPageFormat.a4,
        textDirection: pw.TextDirection.rtl,
        theme: pw.ThemeData.withFont(base: ttfRegular, bold: ttfBold),
        build: (pw.Context context) {
          return [
            // Header
            pw.Container(
              padding: const pw.EdgeInsets.all(20),
              decoration: pw.BoxDecoration(
                color: PdfColor.fromHex('#667EEA'),
                borderRadius: const pw.BorderRadius.all(pw.Radius.circular(12)),
              ),
              child: pw.Column(
                crossAxisAlignment: pw.CrossAxisAlignment.center,
                children: [
                  pw.Text(
                    'تقرير الوردية',
                    textDirection: pw.TextDirection.rtl,
                    style: pw.TextStyle(
                      fontSize: 28,
                      font: ttfBold,
                      color: PdfColors.white,
                    ),
                  ),
                  pw.SizedBox(height: 8),
                  pw.Text(
                    formattedDate,
                    textDirection: pw.TextDirection.rtl,
                    style: pw.TextStyle(
                      fontSize: 14,
                      font: ttfRegular,
                      color: PdfColors.white,
                    ),
                  ),
                ],
              ),
            ),

            pw.SizedBox(height: 30),

            // معلومات الوردية
            pw.Container(
              padding: const pw.EdgeInsets.all(16),
              decoration: pw.BoxDecoration(
                border: pw.Border.all(
                  color: PdfColor.fromHex('#E2E8F0'),
                  width: 2,
                ),
                borderRadius: const pw.BorderRadius.all(pw.Radius.circular(12)),
              ),
              child: pw.Column(
                crossAxisAlignment: pw.CrossAxisAlignment.start,
                children: [
                  pw.Text(
                    'معلومات الوردية',
                    textDirection: pw.TextDirection.rtl,
                    style: pw.TextStyle(
                      fontSize: 18,
                      font: ttfBold,
                      color: PdfColor.fromHex('#2D3748'),
                    ),
                  ),
                  pw.SizedBox(height: 12),
                  pw.Divider(color: PdfColor.fromHex('#E2E8F0')),
                  pw.SizedBox(height: 12),
                  _buildInfoRow(
                    'رقم الوردية',
                    '#$shiftId',
                    ttfRegular,
                    ttfBold,
                  ),
                  _buildInfoRow(
                    'اسم الموظف',
                    userName ?? 'غير محدد',
                    ttfRegular,
                    ttfBold,
                  ),
                  _buildInfoRow(
                    'المتجر',
                    storeName ?? 'غير محدد',
                    ttfRegular,
                    ttfBold,
                  ),
                  _buildInfoRow(
                    'عدد المعاملات',
                    '$transactionCount',
                    ttfRegular,
                    ttfBold,
                  ),
                ],
              ),
            ),

            pw.SizedBox(height: 20),

            // الإحصائيات المالية
            pw.Container(
              padding: const pw.EdgeInsets.all(16),
              decoration: pw.BoxDecoration(
                color: PdfColor.fromHex('#F8F9FA'),
                borderRadius: const pw.BorderRadius.all(pw.Radius.circular(12)),
              ),
              child: pw.Column(
                crossAxisAlignment: pw.CrossAxisAlignment.start,
                children: [
                  pw.Text(
                    'الإحصائيات المالية',
                    textDirection: pw.TextDirection.rtl,
                    style: pw.TextStyle(
                      fontSize: 18,
                      font: ttfBold,
                      color: PdfColor.fromHex('#2D3748'),
                    ),
                  ),
                  pw.SizedBox(height: 12),
                  pw.Divider(color: PdfColor.fromHex('#E2E8F0')),
                  pw.SizedBox(height: 12),

                  // إجمالي الدخل
                  pw.Container(
                    padding: const pw.EdgeInsets.all(12),
                    decoration: pw.BoxDecoration(
                      color: PdfColor.fromHex('#D1FAE5'),
                      borderRadius: const pw.BorderRadius.all(
                        pw.Radius.circular(8),
                      ),
                    ),
                    child: pw.Row(
                      mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                      children: [
                        pw.Text(
                          'إجمالي المبيعات والدخل',
                          textDirection: pw.TextDirection.rtl,
                          style: pw.TextStyle(
                            fontSize: 14,
                            font: ttfBold,
                            color: PdfColor.fromHex('#059669'),
                          ),
                        ),
                        pw.Text(
                          '${totalPositive.toStringAsFixed(2)} ر.س',
                          textDirection: pw.TextDirection.rtl,
                          style: pw.TextStyle(
                            fontSize: 16,
                            font: ttfBold,
                            color: PdfColor.fromHex('#059669'),
                          ),
                        ),
                      ],
                    ),
                  ),

                  pw.SizedBox(height: 8),

                  // إجمالي المصروفات
                  pw.Container(
                    padding: const pw.EdgeInsets.all(12),
                    decoration: pw.BoxDecoration(
                      color: PdfColor.fromHex('#FEE2E2'),
                      borderRadius: const pw.BorderRadius.all(
                        pw.Radius.circular(8),
                      ),
                    ),
                    child: pw.Row(
                      mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                      children: [
                        pw.Text(
                          'إجمالي المصروفات والمدفوعات',
                          textDirection: pw.TextDirection.rtl,
                          style: pw.TextStyle(
                            fontSize: 14,
                            font: ttfBold,
                            color: PdfColor.fromHex('#DC2626'),
                          ),
                        ),
                        pw.Text(
                          '${totalNegative.toStringAsFixed(2)} ر.س',
                          textDirection: pw.TextDirection.rtl,
                          style: pw.TextStyle(
                            fontSize: 16,
                            font: ttfBold,
                            color: PdfColor.fromHex('#DC2626'),
                          ),
                        ),
                      ],
                    ),
                  ),

                  pw.SizedBox(height: 16),
                  pw.Divider(color: PdfColor.fromHex('#667EEA'), thickness: 2),
                  pw.SizedBox(height: 8),

                  // الصافي
                  pw.Container(
                    padding: const pw.EdgeInsets.all(16),
                    decoration: pw.BoxDecoration(
                      color: netAmount >= 0
                          ? PdfColor.fromHex('#D1FAE5')
                          : PdfColor.fromHex('#FEE2E2'),
                      borderRadius: const pw.BorderRadius.all(
                        pw.Radius.circular(8),
                      ),
                      border: pw.Border.all(
                        color: netAmount >= 0
                            ? PdfColor.fromHex('#059669')
                            : PdfColor.fromHex('#DC2626'),
                        width: 2,
                      ),
                    ),
                    child: pw.Row(
                      mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                      children: [
                        pw.Text(
                          'الصافي',
                          textDirection: pw.TextDirection.rtl,
                          style: pw.TextStyle(
                            fontSize: 18,
                            font: ttfBold,
                            color: netAmount >= 0
                                ? PdfColor.fromHex('#059669')
                                : PdfColor.fromHex('#DC2626'),
                          ),
                        ),
                        pw.Text(
                          '${netAmount >= 0 ? '+' : ''}${netAmount.toStringAsFixed(2)} ر.س',
                          textDirection: pw.TextDirection.rtl,
                          style: pw.TextStyle(
                            fontSize: 22,
                            font: ttfBold,
                            color: netAmount >= 0
                                ? PdfColor.fromHex('#059669')
                                : PdfColor.fromHex('#DC2626'),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            pw.SizedBox(height: 30),

            // 🆕 جدول المعاملات التفصيلي
            _buildTransactionsTable(transactions, ttfRegular, ttfBold),

            pw.SizedBox(height: 30),

            // Footer
            pw.Container(
              padding: const pw.EdgeInsets.all(16),
              decoration: pw.BoxDecoration(
                color: PdfColor.fromHex('#F8F9FA'),
                borderRadius: const pw.BorderRadius.all(pw.Radius.circular(8)),
              ),
              child: pw.Column(
                children: [
                  pw.Text(
                    'تم إنشاء هذا التقرير تلقائياً',
                    textDirection: pw.TextDirection.rtl,
                    style: pw.TextStyle(
                      fontSize: 10,
                      font: ttfRegular,
                      color: PdfColor.fromHex('#718096'),
                    ),
                  ),
                  pw.SizedBox(height: 4),
                  pw.Text(
                    'نظام إدارة المخزون - StockUp',
                    textDirection: pw.TextDirection.rtl,
                    style: pw.TextStyle(
                      fontSize: 10,
                      font: ttfBold,
                      color: PdfColor.fromHex('#667EEA'),
                    ),
                  ),
                ],
              ),
            ),
          ];
        },
      ),
    );

    // حفظ PDF
    final output = await getTemporaryDirectory();
    final file = File('${output.path}/shift_report_$shiftId.pdf');
    await file.writeAsBytes(await pdf.save());

    return file;
  }

  /// 🆕 بناء جدول المعاملات
  static pw.Widget _buildTransactionsTable(
    List<TransactionItem> transactions,
    pw.Font ttfRegular,
    pw.Font ttfBold,
  ) {
    return pw.Container(
      decoration: pw.BoxDecoration(
        border: pw.Border.all(color: PdfColor.fromHex('#E2E8F0'), width: 2),
        borderRadius: const pw.BorderRadius.all(pw.Radius.circular(12)),
      ),
      child: pw.Column(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          // Header
          pw.Container(
            padding: const pw.EdgeInsets.all(16),
            decoration: pw.BoxDecoration(
              color: PdfColor.fromHex('#667EEA'),
              borderRadius: const pw.BorderRadius.only(
                topLeft: pw.Radius.circular(10),
                topRight: pw.Radius.circular(10),
              ),
            ),
            child: pw.Text(
              'تفاصيل المعاملات (${transactions.length})',
              textDirection: pw.TextDirection.rtl,
              style: pw.TextStyle(
                fontSize: 16,
                font: ttfBold,
                color: PdfColors.white,
              ),
            ),
          ),

          // Table
          pw.Table(
            border: pw.TableBorder(
              horizontalInside: pw.BorderSide(
                color: PdfColor.fromHex('#E2E8F0'),
                width: 1,
              ),
            ),
            columnWidths: {
              0: const pw.FlexColumnWidth(1), // #
              1: const pw.FlexColumnWidth(2), // النوع
              2: const pw.FlexColumnWidth(3), // الوصف
              3: const pw.FlexColumnWidth(2), // المبلغ
              4: const pw.FlexColumnWidth(1.5), // الوقت
            },
            children: [
              // Table Header
              pw.TableRow(
                decoration: pw.BoxDecoration(
                  color: PdfColor.fromHex('#F8F9FA'),
                ),
                children: [
                  _buildTableHeaderCell('#', ttfBold),
                  _buildTableHeaderCell('النوع', ttfBold),
                  _buildTableHeaderCell('الوصف', ttfBold),
                  _buildTableHeaderCell('المبلغ', ttfBold),
                  _buildTableHeaderCell('الوقت', ttfBold),
                ],
              ),

              // Table Rows
              ...transactions.asMap().entries.map((entry) {
                final index = entry.key;
                final transaction = entry.value;
                final isPositive = transaction.isPositive;

                return pw.TableRow(
                  decoration: pw.BoxDecoration(
                    color: index % 2 == 0
                        ? PdfColors.white
                        : PdfColor.fromHex('#F8F9FA'),
                  ),
                  children: [
                    _buildTableCell(
                      '${index + 1}',
                      ttfRegular,
                      alignment: pw.Alignment.center,
                    ),
                    _buildTableCell(
                      transaction.type.displayName,
                      ttfBold,
                      color: _getColorForTransactionType(transaction.type),
                    ),
                    _buildTableCell(transaction.description, ttfRegular),
                    _buildTableCell(
                      '${isPositive ? '+' : '-'}${transaction.amount.toStringAsFixed(2)} ر.س',
                      ttfBold,
                      color: isPositive
                          ? PdfColor.fromHex('#059669')
                          : PdfColor.fromHex('#DC2626'),
                      alignment: pw.Alignment.centerLeft,
                    ),
                    _buildTableCell(
                      TransactionUtils.formatTime(transaction.timestamp),
                      ttfRegular,
                      fontSize: 9,
                    ),
                  ],
                );
              }).toList(),
            ],
          ),
        ],
      ),
    );
  }

  /// 🆕 بناء خلية الجدول (Header)
  static pw.Widget _buildTableHeaderCell(String text, pw.Font font) {
    return pw.Container(
      padding: const pw.EdgeInsets.all(10),
      child: pw.Text(
        text,
        textDirection: pw.TextDirection.rtl,
        style: pw.TextStyle(
          fontSize: 11,
          font: font,
          color: PdfColor.fromHex('#2D3748'),
        ),
        textAlign: pw.TextAlign.center,
      ),
    );
  }

  /// 🆕 بناء خلية الجدول (Data)
  static pw.Widget _buildTableCell(
    String text,
    pw.Font font, {
    PdfColor? color,
    pw.Alignment? alignment,
    double fontSize = 10,
  }) {
    return pw.Container(
      padding: const pw.EdgeInsets.all(8),
      alignment: alignment ?? pw.Alignment.centerRight,
      child: pw.Text(
        text,
        textDirection: pw.TextDirection.rtl,
        style: pw.TextStyle(
          fontSize: fontSize,
          font: font,
          color: color ?? PdfColor.fromHex('#2D3748'),
        ),
        maxLines: 2,
        overflow: pw.TextOverflow.clip,
      ),
    );
  }

  /// 🆕 الحصول على اللون المناسب لكل نوع معاملة
  static PdfColor _getColorForTransactionType(ShiftTransactionType type) {
    switch (type) {
      case ShiftTransactionType.cash:
        return PdfColor.fromHex('#28A745');
      case ShiftTransactionType.visaSale:
        return PdfColor.fromHex('#007AFF');
      case ShiftTransactionType.deferredSale:
        return PdfColor.fromHex('#FF9500');
      case ShiftTransactionType.collectDebt:
        return PdfColor.fromHex('#16A085');
      case ShiftTransactionType.expenses:
        return PdfColor.fromHex('#FF3B30');
      case ShiftTransactionType.purchaseGoods:
        return PdfColor.fromHex('#E74C3C');
      case ShiftTransactionType.paySupplier:
        return PdfColor.fromHex('#C0392B');
      case ShiftTransactionType.payBills:
        return PdfColor.fromHex('#95A5A6');
      case ShiftTransactionType.payObligation:
        return PdfColor.fromHex('#8E44AD');
      case ShiftTransactionType.returns:
        return PdfColor.fromHex('#6C757D');
      case ShiftTransactionType.other:
        return PdfColor.fromHex('#34495E');
    }
  }

  /// إرسال PDF عبر واتساب
  static Future<void> sendPdfViaWhatsApp({
    required String phoneNumber,
    required File pdfFile,
    required int shiftId,
  }) async {
    try {
      final message =
          '''
مرحباً! 👋

إليك تقرير الوردية #$shiftId

تم إرساله من نظام StockUp 📊
    ''';

      final result = await Share.shareXFiles(
        [XFile(pdfFile.path)],
        text: message,
        subject: 'تقرير الوردية #$shiftId',
      );

      if (result.status == ShareResultStatus.dismissed) {
        throw Exception('تم إلغاء المشاركة');
      }
    } catch (e) {
      print('Error sharing PDF: $e');
      rethrow;
    }
  }

  /// إنشاء وإرسال PDF (دالة شاملة)
  static Future<void> generateAndSendShiftPdf({
    required String phoneNumber,
    required int shiftId,
    required double totalPositive,
    required double totalNegative,
    required double netAmount,
    required int transactionCount,
    required List<TransactionItem> transactions, // 🆕
    String? userName,
    String? storeName,
  }) async {
    try {
      final pdfFile = await generateShiftPdf(
        shiftId: shiftId,
        totalPositive: totalPositive,
        totalNegative: totalNegative,
        netAmount: netAmount,
        transactionCount: transactionCount,
        transactions: transactions,
        // 🆕
        userName: userName,
        storeName: storeName,
      );

      await sendPdfViaWhatsApp(
        phoneNumber: phoneNumber,
        pdfFile: pdfFile,
        shiftId: shiftId,
      );
    } catch (e) {
      print('Error in generateAndSendShiftPdf: $e');
      rethrow;
    }
  }

  /// دالة مساعدة لبناء صف معلومات
  static pw.Widget _buildInfoRow(
    String label,
    String value,
    pw.Font fontRegular,
    pw.Font fontBold,
  ) {
    return pw.Padding(
      padding: const pw.EdgeInsets.symmetric(vertical: 6),
      child: pw.Row(
        mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
        children: [
          pw.Text(
            label,
            textDirection: pw.TextDirection.rtl,
            style: pw.TextStyle(
              fontSize: 14,
              font: fontRegular,
              color: PdfColor.fromHex('#718096'),
            ),
          ),
          pw.Text(
            value,
            textDirection: pw.TextDirection.rtl,
            style: pw.TextStyle(
              fontSize: 14,
              font: fontBold,
              color: PdfColor.fromHex('#2D3748'),
            ),
          ),
        ],
      ),
    );
  }
}
