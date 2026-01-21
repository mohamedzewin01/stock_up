// lib/features/POSPage/presentation/widgets/invoice_details_dialog.dart

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

import '../../domain/models/invoice_model.dart';
import '../bloc/POSPage_cubit.dart';
import '../bloc/invoice_cubit.dart';
import 'edit_invoice_dialog.dart';

class InvoiceDetailsDialog extends StatelessWidget {
  final Invoice invoice;

  const InvoiceDetailsDialog({super.key, required this.invoice});

  @override
  Widget build(BuildContext context) {
    final dateFormat = DateFormat('dd/MM/yyyy - HH:mm');

    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: Container(
        constraints: BoxConstraints(
          maxHeight: MediaQuery.of(context).size.height * 0.8,
          maxWidth: 500,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Header
            Container(
              padding: const EdgeInsets.all(20),
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [Color(0xFF6C63FF), Color(0xFF5A52E0)],
                ),
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(20),
                  topRight: Radius.circular(20),
                ),
              ),
              child: Row(
                children: [
                  const Icon(Icons.receipt_long, color: Colors.white, size: 28),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'تفاصيل الفاتورة',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          invoice.id,
                          style: const TextStyle(
                            fontSize: 12,
                            color: Colors.white70,
                          ),
                        ),
                      ],
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close, color: Colors.white),
                    onPressed: () => Navigator.pop(context),
                  ),
                ],
              ),
            ),

            // Content
            Flexible(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Date and Customer Info
                    _buildInfoSection(
                      icon: Icons.access_time,
                      label: 'تاريخ الإنشاء',
                      value: dateFormat.format(invoice.createdAt),
                    ),

                    if (invoice.updatedAt != null) ...[
                      const SizedBox(height: 12),
                      _buildInfoSection(
                        icon: Icons.update,
                        label: 'آخر تحديث',
                        value: dateFormat.format(invoice.updatedAt!),
                      ),
                    ],

                    if (invoice.customerName != null) ...[
                      const SizedBox(height: 12),
                      _buildInfoSection(
                        icon: Icons.person_outline,
                        label: 'اسم العميل',
                        value: invoice.customerName!,
                      ),
                    ],

                    if (invoice.customerPhone != null) ...[
                      const SizedBox(height: 12),
                      _buildInfoSection(
                        icon: Icons.phone_outlined,
                        label: 'رقم الهاتف',
                        value: invoice.customerPhone!,
                      ),
                    ],

                    const SizedBox(height: 24),
                    const Divider(),
                    const SizedBox(height: 16),

                    // Items Header
                    const Text(
                      'المنتجات',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF2D3436),
                      ),
                    ),
                    const SizedBox(height: 12),

                    // Items List
                    ...invoice.items.map((item) {
                      final price =
                          double.tryParse(item.product.sellingPrice ?? '0') ??
                          0.0;
                      final total = price * item.quantity;

                      return Container(
                        margin: const EdgeInsets.only(bottom: 12),
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: Colors.grey[50],
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: Colors.grey[200]!),
                        ),
                        child: Row(
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    item.product.productName ?? '',
                                    style: const TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    '${price.toStringAsFixed(2)} ر.س × ${item.quantity}',
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: Colors.grey[600],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Text(
                              '${total.toStringAsFixed(2)} ر.س',
                              style: const TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF11998E),
                              ),
                            ),
                          ],
                        ),
                      );
                    }).toList(),

                    const SizedBox(height: 16),
                    const Divider(),
                    const SizedBox(height: 16),

                    // Total Section
                    _buildTotalRow(
                      'المجموع الفرعي:',
                      '${invoice.totalAmount.toStringAsFixed(2)} ر.س',
                    ),
                    const SizedBox(height: 8),
                    _buildTotalRow(
                      'ضريبة القيمة المضافة (15%):',
                      '${invoice.tax.toStringAsFixed(2)} ر.س',
                    ),
                    const SizedBox(height: 12),
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            const Color(0xFF11998E).withOpacity(0.1),
                            const Color(0xFF38EF7D).withOpacity(0.05),
                          ],
                        ),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            'الإجمالي الكلي:',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            '${invoice.grandTotal.toStringAsFixed(2)} ر.س',
                            style: const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF11998E),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // Actions
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.grey[50],
                borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.circular(20),
                  bottomRight: Radius.circular(20),
                ),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: () {
                        Navigator.pop(context);
                        _confirmDelete(context);
                      },
                      icon: const Icon(Icons.delete_outline, size: 20),
                      label: const Text('حذف'),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: const Color(0xFFFF6B6B),
                        side: const BorderSide(
                          color: Color(0xFFFF6B6B),
                          width: 2,
                        ),
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: () {
                        Navigator.pop(context);
                        _showEditDialog(context);
                      },
                      icon: const Icon(Icons.edit, size: 20),
                      label: const Text('تعديل'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF6C63FF),
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoSection({
    required IconData icon,
    required String label,
    required String value,
  }) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Icon(icon, size: 20, color: const Color(0xFF6C63FF)),
          const SizedBox(width: 12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: TextStyle(fontSize: 12, color: Colors.grey[600]),
              ),
              const SizedBox(height: 2),
              Text(
                value,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildTotalRow(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: TextStyle(fontSize: 14, color: Colors.grey[700])),
        Text(
          value,
          style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
        ),
      ],
    );
  }

  void _confirmDelete(BuildContext context) {
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Row(
          children: [
            Icon(Icons.warning_rounded, color: Color(0xFFFF6B6B)),
            SizedBox(width: 12),
            Text('تأكيد الحذف'),
          ],
        ),
        content: const Text('هل أنت متأكد من حذف هذه الفاتورة؟'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: const Text('إلغاء'),
          ),
          ElevatedButton(
            onPressed: () {
              context.read<InvoiceCubit>().deleteInvoice(invoice.id);
              Navigator.pop(dialogContext);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFFF6B6B),
              foregroundColor: Colors.white,
            ),
            child: const Text('حذف'),
          ),
        ],
      ),
    );
  }

  void _showEditDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => EditInvoiceDialog(invoice: invoice),
    );
  }
}
