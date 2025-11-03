import 'dart:io';

import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';

/// خدمة إنشاء وإرسال PDF للورديات
class PdfService {
  /// إنشاء PDF لتقرير الوردية
  static Future<File> generateShiftPdf({
    required int shiftId,
    required double totalPositive,
    required double totalNegative,
    required double netAmount,
    required int transactionCount,
    String? userName,
    String? storeName,
  }) async {
    final pdf = pw.Document();
    final now = DateTime.now();
    final dateFormat = DateFormat('yyyy/MM/dd - hh:mm a', 'ar');

    pdf.addPage(
      pw.Page(
        pageFormat: PdfPageFormat.a4,
        textDirection: pw.TextDirection.rtl,
        build: (pw.Context context) {
          return pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              // Header
              pw.Container(
                padding: const pw.EdgeInsets.all(20),
                decoration: pw.BoxDecoration(
                  color: PdfColor.fromHex('#667EEA'),
                  borderRadius: const pw.BorderRadius.all(
                    pw.Radius.circular(12),
                  ),
                ),
                child: pw.Column(
                  crossAxisAlignment: pw.CrossAxisAlignment.center,
                  children: [
                    pw.Text(
                      'تقرير الوردية',
                      style: pw.TextStyle(
                        fontSize: 28,
                        fontWeight: pw.FontWeight.bold,
                        color: PdfColors.white,
                      ),
                    ),
                    pw.SizedBox(height: 8),
                    pw.Text(
                      dateFormat.format(now),
                      style: const pw.TextStyle(
                        fontSize: 14,
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
                  borderRadius: const pw.BorderRadius.all(
                    pw.Radius.circular(12),
                  ),
                ),
                child: pw.Column(
                  crossAxisAlignment: pw.CrossAxisAlignment.start,
                  children: [
                    pw.Text(
                      'معلومات الوردية',
                      style: pw.TextStyle(
                        fontSize: 18,
                        fontWeight: pw.FontWeight.bold,
                        color: PdfColor.fromHex('#2D3748'),
                      ),
                    ),
                    pw.SizedBox(height: 12),
                    pw.Divider(color: PdfColor.fromHex('#E2E8F0')),
                    pw.SizedBox(height: 12),
                    _buildInfoRow('رقم الوردية', '#$shiftId'),
                    _buildInfoRow('اسم الموظف', userName ?? 'غير محدد'),
                    _buildInfoRow('المتجر', storeName ?? 'غير محدد'),
                    _buildInfoRow('عدد المعاملات', '$transactionCount'),
                  ],
                ),
              ),

              pw.SizedBox(height: 20),

              // الإحصائيات المالية
              pw.Container(
                padding: const pw.EdgeInsets.all(16),
                decoration: pw.BoxDecoration(
                  color: PdfColor.fromHex('#F8F9FA'),
                  borderRadius: const pw.BorderRadius.all(
                    pw.Radius.circular(12),
                  ),
                ),
                child: pw.Column(
                  crossAxisAlignment: pw.CrossAxisAlignment.start,
                  children: [
                    pw.Text(
                      'الإحصائيات المالية',
                      style: pw.TextStyle(
                        fontSize: 18,
                        fontWeight: pw.FontWeight.bold,
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
                            style: pw.TextStyle(
                              fontSize: 14,
                              fontWeight: pw.FontWeight.bold,
                              color: PdfColor.fromHex('#059669'),
                            ),
                          ),
                          pw.Text(
                            '${totalPositive.toStringAsFixed(2)} ر.س',
                            style: pw.TextStyle(
                              fontSize: 16,
                              fontWeight: pw.FontWeight.bold,
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
                            style: pw.TextStyle(
                              fontSize: 14,
                              fontWeight: pw.FontWeight.bold,
                              color: PdfColor.fromHex('#DC2626'),
                            ),
                          ),
                          pw.Text(
                            '${totalNegative.toStringAsFixed(2)} ر.س',
                            style: pw.TextStyle(
                              fontSize: 16,
                              fontWeight: pw.FontWeight.bold,
                              color: PdfColor.fromHex('#DC2626'),
                            ),
                          ),
                        ],
                      ),
                    ),

                    pw.SizedBox(height: 16),
                    pw.Divider(
                      color: PdfColor.fromHex('#667EEA'),
                      thickness: 2,
                    ),
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
                            style: pw.TextStyle(
                              fontSize: 18,
                              fontWeight: pw.FontWeight.bold,
                              color: netAmount >= 0
                                  ? PdfColor.fromHex('#059669')
                                  : PdfColor.fromHex('#DC2626'),
                            ),
                          ),
                          pw.Text(
                            '${netAmount >= 0 ? '+' : ''}${netAmount.toStringAsFixed(2)} ر.س',
                            style: pw.TextStyle(
                              fontSize: 22,
                              fontWeight: pw.FontWeight.bold,
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

              pw.Spacer(),

              // Footer
              pw.Container(
                padding: const pw.EdgeInsets.all(16),
                decoration: pw.BoxDecoration(
                  color: PdfColor.fromHex('#F8F9FA'),
                  borderRadius: const pw.BorderRadius.all(
                    pw.Radius.circular(8),
                  ),
                ),
                child: pw.Column(
                  children: [
                    pw.Text(
                      'تم إنشاء هذا التقرير تلقائياً',
                      style: pw.TextStyle(
                        fontSize: 10,
                        color: PdfColor.fromHex('#718096'),
                      ),
                    ),
                    pw.SizedBox(height: 4),
                    pw.Text(
                      'نظام إدارة المخزون - StockUp',
                      style: pw.TextStyle(
                        fontSize: 10,
                        fontWeight: pw.FontWeight.bold,
                        color: PdfColor.fromHex('#667EEA'),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );

    // حفظ PDF
    final output = await getTemporaryDirectory();
    final file = File('${output.path}/shift_report_$shiftId.pdf');
    await file.writeAsBytes(await pdf.save());

    return file;
  }

  /// إرسال PDF عبر واتساب
  static Future<void> sendPdfViaWhatsApp({
    required String phoneNumber,
    required File pdfFile,
    required int shiftId,
  }) async {
    // تنظيف رقم الهاتف
    String cleanPhone = phoneNumber.replaceAll(RegExp(r'[^\d+]'), '');
    if (!cleanPhone.startsWith('+')) {
      cleanPhone = '+$cleanPhone';
    }

    // رسالة مرفقة
    final message =
        '''
مرحباً! 👋

إليك تقرير الوردية #$shiftId

تم إرساله من نظام StockUp 📊
    ''';

    // إنشاء رابط واتساب
    final whatsappUrl =
        'https://wa.me/$cleanPhone?text=${Uri.encodeComponent(message)}';

    // فتح واتساب
    if (await canLaunchUrl(Uri.parse(whatsappUrl))) {
      await launchUrl(
        Uri.parse(whatsappUrl),
        mode: LaunchMode.externalApplication,
      );
    } else {
      throw Exception('لا يمكن فتح واتساب');
    }

    await Share.shareXFiles([XFile(pdfFile.path)]);
  }

  /// إنشاء وإرسال PDF (دالة شاملة)
  static Future<void> generateAndSendShiftPdf({
    required String phoneNumber,
    required int shiftId,
    required double totalPositive,
    required double totalNegative,
    required double netAmount,
    required int transactionCount,
    String? userName,
    String? storeName,
  }) async {
    // إنشاء PDF
    final pdfFile = await generateShiftPdf(
      shiftId: shiftId,
      totalPositive: totalPositive,
      totalNegative: totalNegative,
      netAmount: netAmount,
      transactionCount: transactionCount,
      userName: userName,
      storeName: storeName,
    );

    // إرسال عبر واتساب
    await sendPdfViaWhatsApp(
      phoneNumber: phoneNumber,
      pdfFile: pdfFile,
      shiftId: shiftId,
    );
  }

  /// دالة مساعدة لبناء صف معلومات
  static pw.Widget _buildInfoRow(String label, String value) {
    return pw.Padding(
      padding: const pw.EdgeInsets.symmetric(vertical: 6),
      child: pw.Row(
        mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
        children: [
          pw.Text(
            label,
            style: pw.TextStyle(
              fontSize: 14,
              color: PdfColor.fromHex('#718096'),
            ),
          ),
          pw.Text(
            value,
            style: pw.TextStyle(
              fontSize: 14,
              fontWeight: pw.FontWeight.bold,
              color: PdfColor.fromHex('#2D3748'),
            ),
          ),
        ],
      ),
    );
  }
}
