import 'dart:io';

import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:share_plus/share_plus.dart';
import 'package:stock_up/features/POSPage/presentation/widgets/invoice_item.dart';
import 'package:url_launcher/url_launcher.dart';

class InvoicePDFService {
  static Future<File> generateInvoicePDF({
    required List<InvoiceItem> items,
    required double totalAmount,
    String? customerName,
    String? customerPhone,
  }) async {
    final pdf = pw.Document();
    final now = DateTime.now();
    final invoiceNumber = 'INV-${now.millisecondsSinceEpoch}';
    final dateFormat = DateFormat('yyyy-MM-dd HH:mm');

    pdf.addPage(
      pw.Page(
        pageFormat: PdfPageFormat.a4,
        build: (context) {
          return pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              // Header
              _buildHeader(invoiceNumber, dateFormat.format(now)),
              pw.SizedBox(height: 30),

              // Customer Info (if provided)
              if (customerName != null || customerPhone != null)
                _buildCustomerInfo(customerName, customerPhone),

              pw.SizedBox(height: 20),

              // Items Table
              _buildItemsTable(items),

              pw.SizedBox(height: 30),

              // Total Section
              _buildTotalSection(items, totalAmount),

              pw.Spacer(),

              // Footer
              _buildFooter(),
            ],
          );
        },
      ),
    );

    // Save PDF to file
    final output = await getTemporaryDirectory();
    final file = File('${output.path}/invoice_$invoiceNumber.pdf');
    await file.writeAsBytes(await pdf.save());

    return file;
  }

  static pw.Widget _buildHeader(String invoiceNumber, String date) {
    return pw.Container(
      padding: const pw.EdgeInsets.all(20),
      decoration: pw.BoxDecoration(
        color: PdfColors.blue50,
        borderRadius: pw.BorderRadius.circular(10),
      ),
      child: pw.Row(
        mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
        children: [
          pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              pw.Text(
                'فاتورة بيع',
                style: pw.TextStyle(
                  fontSize: 28,
                  fontWeight: pw.FontWeight.bold,
                  color: PdfColors.blue900,
                ),
              ),
              pw.SizedBox(height: 5),
              pw.Text(
                'رقم الفاتورة: $invoiceNumber',
                style: const pw.TextStyle(fontSize: 12),
              ),
            ],
          ),
          pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.end,
            children: [
              pw.Text(date, style: const pw.TextStyle(fontSize: 12)),
              pw.SizedBox(height: 5),
              pw.Container(
                padding: const pw.EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 6,
                ),
                decoration: pw.BoxDecoration(
                  color: PdfColors.green,
                  borderRadius: pw.BorderRadius.circular(20),
                ),
                child: pw.Text(
                  'مدفوع',
                  style: pw.TextStyle(
                    color: PdfColors.white,
                    fontWeight: pw.FontWeight.bold,
                    fontSize: 10,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  static pw.Widget _buildCustomerInfo(String? name, String? phone) {
    return pw.Container(
      padding: const pw.EdgeInsets.all(15),
      decoration: pw.BoxDecoration(
        border: pw.Border.all(color: PdfColors.grey300),
        borderRadius: pw.BorderRadius.circular(8),
      ),
      child: pw.Column(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          pw.Text(
            'بيانات العميل',
            style: pw.TextStyle(
              fontSize: 14,
              fontWeight: pw.FontWeight.bold,
              color: PdfColors.grey700,
            ),
          ),
          pw.SizedBox(height: 10),
          if (name != null)
            pw.Row(
              children: [
                pw.Text(
                  'الاسم: ',
                  style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
                ),
                pw.Text(name),
              ],
            ),
          if (phone != null)
            pw.Row(
              children: [
                pw.Text(
                  'الهاتف: ',
                  style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
                ),
                pw.Text(phone),
              ],
            ),
        ],
      ),
    );
  }

  static pw.Widget _buildItemsTable(List<InvoiceItem> items) {
    return pw.Table(
      border: pw.TableBorder.all(color: PdfColors.grey300),
      children: [
        // Header Row
        pw.TableRow(
          decoration: const pw.BoxDecoration(color: PdfColors.blue50),
          children: [
            _buildTableCell('#', isHeader: true),
            _buildTableCell('اسم المنتج', isHeader: true),
            _buildTableCell('السعر', isHeader: true),
            _buildTableCell('الكمية', isHeader: true),
            _buildTableCell('الإجمالي', isHeader: true),
          ],
        ),

        // Items Rows
        ...items.asMap().entries.map((entry) {
          final index = entry.key + 1;
          final item = entry.value;
          final price =
              double.tryParse(item.product.sellingPrice ?? '0') ?? 0.0;
          final total = price * item.quantity;

          return pw.TableRow(
            children: [
              _buildTableCell('$index'),
              _buildTableCell(item.product.productName ?? ''),
              _buildTableCell('${price.toStringAsFixed(2)} ر.س'),
              _buildTableCell('${item.quantity}'),
              _buildTableCell('${total.toStringAsFixed(2)} ر.س'),
            ],
          );
        }).toList(),
      ],
    );
  }

  static pw.Widget _buildTableCell(String text, {bool isHeader = false}) {
    return pw.Padding(
      padding: const pw.EdgeInsets.all(8),
      child: pw.Text(
        text,
        style: pw.TextStyle(
          fontWeight: isHeader ? pw.FontWeight.bold : pw.FontWeight.normal,
          fontSize: isHeader ? 12 : 10,
        ),
        textAlign: pw.TextAlign.center,
      ),
    );
  }

  static pw.Widget _buildTotalSection(
    List<InvoiceItem> items,
    double totalAmount,
  ) {
    final subtotal = totalAmount;
    final tax = totalAmount * 0.15; // 15% VAT
    final grandTotal = subtotal + tax;

    return pw.Container(
      padding: const pw.EdgeInsets.all(20),
      decoration: pw.BoxDecoration(
        color: PdfColors.grey100,
        borderRadius: pw.BorderRadius.circular(10),
      ),
      child: pw.Column(
        children: [
          _buildTotalRow(
            'المجموع الفرعي:',
            '${subtotal.toStringAsFixed(2)} ر.س',
          ),
          pw.SizedBox(height: 8),
          _buildTotalRow(
            'ضريبة القيمة المضافة (15%):',
            '${tax.toStringAsFixed(2)} ر.س',
          ),
          pw.Divider(thickness: 2),
          pw.SizedBox(height: 8),
          _buildTotalRow(
            'الإجمالي الكلي:',
            '${grandTotal.toStringAsFixed(2)} ر.س',
            isGrandTotal: true,
          ),
        ],
      ),
    );
  }

  static pw.Widget _buildTotalRow(
    String label,
    String value, {
    bool isGrandTotal = false,
  }) {
    return pw.Row(
      mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
      children: [
        pw.Text(
          label,
          style: pw.TextStyle(
            fontSize: isGrandTotal ? 16 : 12,
            fontWeight: isGrandTotal
                ? pw.FontWeight.bold
                : pw.FontWeight.normal,
          ),
        ),
        pw.Text(
          value,
          style: pw.TextStyle(
            fontSize: isGrandTotal ? 18 : 12,
            fontWeight: pw.FontWeight.bold,
            color: isGrandTotal ? PdfColors.green700 : PdfColors.black,
          ),
        ),
      ],
    );
  }

  static pw.Widget _buildFooter() {
    return pw.Container(
      padding: const pw.EdgeInsets.all(15),
      decoration: pw.BoxDecoration(
        border: pw.Border(top: pw.BorderSide(color: PdfColors.grey300)),
      ),
      child: pw.Column(
        children: [
          pw.Text(
            'شكراً لتعاملكم معنا',
            style: pw.TextStyle(fontSize: 14, fontWeight: pw.FontWeight.bold),
          ),
          pw.SizedBox(height: 5),
          pw.Text(
            'تم إنشاء هذه الفاتورة إلكترونياً',
            style: const pw.TextStyle(fontSize: 10, color: PdfColors.grey600),
          ),
        ],
      ),
    );
  }

  // Share via WhatsApp
  static Future<void> shareViaWhatsApp(
    File pdfFile, {
    String? phoneNumber,
  }) async {
    try {
      if (phoneNumber != null && phoneNumber.isNotEmpty) {
        // Send directly to specific number
        final whatsappUrl = 'https://wa.me/$phoneNumber';
        final uri = Uri.parse(whatsappUrl);

        if (await canLaunchUrl(uri)) {
          await launchUrl(uri);
          // After opening WhatsApp, share the file
          await Future.delayed(const Duration(seconds: 1));
          await Share.shareXFiles([XFile(pdfFile.path)], text: 'فاتورة جديدة');
        }
      } else {
        // General share
        await Share.shareXFiles([XFile(pdfFile.path)], text: 'فاتورة جديدة');
      }
    } catch (e) {
      throw Exception('فشل إرسال الفاتورة: $e');
    }
  }

  // Alternative: Share with message
  static Future<void> shareWithMessage(
    File pdfFile,
    String phoneNumber,
    String message,
  ) async {
    try {
      // Clean phone number (remove spaces, dashes, etc.)
      final cleanPhone = phoneNumber.replaceAll(RegExp(r'[^\d+]'), '');

      // Open WhatsApp with message
      final whatsappUrl =
          'https://wa.me/$cleanPhone?text=${Uri.encodeComponent(message)}';
      final uri = Uri.parse(whatsappUrl);

      if (await canLaunchUrl(uri)) {
        await launchUrl(uri, mode: LaunchMode.externalApplication);

        // Share file after a short delay
        await Future.delayed(const Duration(milliseconds: 1500));
        await Share.shareXFiles([XFile(pdfFile.path)]);
      } else {
        throw Exception('تعذر فتح WhatsApp');
      }
    } catch (e) {
      throw Exception('فشل إرسال الفاتورة: $e');
    }
  }
}
