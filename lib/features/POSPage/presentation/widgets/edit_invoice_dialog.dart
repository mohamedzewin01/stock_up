// lib/features/POSPage/presentation/widgets/edit_invoice_dialog.dart

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../data/models/invoice_model.dart';
import '../bloc/POSPage_cubit.dart';
import 'invoice_item.dart';

class EditInvoiceDialog extends StatefulWidget {
  final Invoice invoice;

  const EditInvoiceDialog({super.key, required this.invoice});

  @override
  State<EditInvoiceDialog> createState() => _EditInvoiceDialogState();
}

class _EditInvoiceDialogState extends State<EditInvoiceDialog> {
  late TextEditingController _nameController;
  late TextEditingController _phoneController;
  late List<InvoiceItem> _items;
  double _totalAmount = 0.0;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(
      text: widget.invoice.customerName ?? '',
    );
    _phoneController = TextEditingController(
      text: widget.invoice.customerPhone ?? '',
    );
    _items = List.from(widget.invoice.items);
    _calculateTotal();
  }

  void _calculateTotal() {
    _totalAmount = _items.fold(0.0, (sum, item) {
      final price = double.tryParse(item.product.sellingPrice ?? '0') ?? 0.0;
      return sum + (price * item.quantity);
    });
  }

  void _updateQuantity(int index, int newQuantity) {
    if (newQuantity <= 0) {
      _removeItem(index);
      return;
    }
    setState(() {
      _items[index].quantity = newQuantity;
      _calculateTotal();
    });
  }

  void _removeItem(int index) {
    setState(() {
      _items.removeAt(index);
      _calculateTotal();
    });
  }

  void _saveChanges() {
    if (_items.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Row(
            children: [
              Icon(Icons.warning, color: Colors.white),
              SizedBox(width: 12),
              Text('يجب أن تحتوي الفاتورة على منتج واحد على الأقل'),
            ],
          ),
          backgroundColor: const Color(0xFFFF6B6B),
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      );
      return;
    }

    final tax = _totalAmount * 0.15;
    final grandTotal = _totalAmount + tax;

    final updatedInvoice = widget.invoice.copyWith(
      items: _items,
      totalAmount: _totalAmount,
      tax: tax,
      grandTotal: grandTotal,
      customerName: _nameController.text.isNotEmpty
          ? _nameController.text
          : null,
      customerPhone: _phoneController.text.isNotEmpty
          ? _phoneController.text
          : null,
      updatedAt: DateTime.now(),
    );

    context.read<InvoiceCubit>().updateInvoice(updatedInvoice);
    Navigator.pop(context);
  }

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: Container(
        constraints: BoxConstraints(
          maxHeight: MediaQuery.of(context).size.height * 0.85,
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
                  const Icon(Icons.edit, color: Colors.white, size: 28),
                  const SizedBox(width: 12),
                  const Expanded(
                    child: Text(
                      'تعديل الفاتورة',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
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
                    // Customer Info
                    const Text(
                      'معلومات العميل',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 12),
                    TextField(
                      controller: _nameController,
                      decoration: InputDecoration(
                        labelText: 'اسم العميل',
                        prefixIcon: const Icon(Icons.person_outline),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),
                    TextField(
                      controller: _phoneController,
                      keyboardType: TextInputType.phone,
                      decoration: InputDecoration(
                        labelText: 'رقم الهاتف',
                        prefixIcon: const Icon(Icons.phone_outlined),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),

                    const SizedBox(height: 24),
                    const Divider(),
                    const SizedBox(height: 16),

                    // Items
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'المنتجات',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 6,
                          ),
                          decoration: BoxDecoration(
                            color: const Color(0xFF6C63FF).withOpacity(0.1),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Text(
                            '${_items.length} منتج',
                            style: const TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF6C63FF),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),

                    if (_items.isEmpty)
                      Container(
                        padding: const EdgeInsets.all(24),
                        decoration: BoxDecoration(
                          color: Colors.grey[100],
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Center(
                          child: Text(
                            'لا توجد منتجات',
                            style: TextStyle(
                              color: Colors.grey[600],
                              fontSize: 14,
                            ),
                          ),
                        ),
                      )
                    else
                      ..._items.asMap().entries.map((entry) {
                        final index = entry.key;
                        final item = entry.value;
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
                              // Product Info
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
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      '${price.toStringAsFixed(2)} ر.س',
                                      style: TextStyle(
                                        fontSize: 12,
                                        color: Colors.grey[600],
                                      ),
                                    ),
                                  ],
                                ),
                              ),

                              const SizedBox(width: 12),

                              // Quantity Controls
                              Container(
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(8),
                                  border: Border.all(color: Colors.grey[300]!),
                                ),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    IconButton(
                                      icon: const Icon(Icons.remove, size: 18),
                                      onPressed: () => _updateQuantity(
                                        index,
                                        item.quantity - 1,
                                      ),
                                      color: const Color(0xFFFF6B6B),
                                      padding: const EdgeInsets.all(6),
                                      constraints: const BoxConstraints(),
                                    ),
                                    Container(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 12,
                                      ),
                                      child: Text(
                                        '${item.quantity}',
                                        style: const TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                    IconButton(
                                      icon: const Icon(Icons.add, size: 18),
                                      onPressed: () => _updateQuantity(
                                        index,
                                        item.quantity + 1,
                                      ),
                                      color: const Color(0xFF11998E),
                                      padding: const EdgeInsets.all(6),
                                      constraints: const BoxConstraints(),
                                    ),
                                  ],
                                ),
                              ),

                              const SizedBox(width: 12),

                              // Total
                              SizedBox(
                                width: 70,
                                child: Text(
                                  '${total.toStringAsFixed(2)} ر.س',
                                  style: const TextStyle(
                                    fontSize: 13,
                                    fontWeight: FontWeight.bold,
                                    color: Color(0xFF11998E),
                                  ),
                                  textAlign: TextAlign.end,
                                ),
                              ),
                            ],
                          ),
                        );
                      }).toList(),

                    const SizedBox(height: 16),
                    const Divider(),
                    const SizedBox(height: 16),

                    // Total Summary
                    _buildTotalRow(
                      'المجموع الفرعي:',
                      '${_totalAmount.toStringAsFixed(2)} ر.س',
                    ),
                    const SizedBox(height: 8),
                    _buildTotalRow(
                      'ضريبة القيمة المضافة (15%):',
                      '${(_totalAmount * 0.15).toStringAsFixed(2)} ر.س',
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
                            '${(_totalAmount * 1.15).toStringAsFixed(2)} ر.س',
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
                    child: OutlinedButton(
                      onPressed: () => Navigator.pop(context),
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: const Text('إلغاء'),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    flex: 2,
                    child: ElevatedButton.icon(
                      onPressed: _saveChanges,
                      icon: const Icon(Icons.save, size: 20),
                      label: const Text('حفظ التغييرات'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF11998E),
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
}
