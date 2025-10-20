import 'package:flutter/material.dart';
import 'package:stock_up/features/AuditItems/presentation/widgets/info_row.dart';

import '../../data/models/response/search_products_model.dart';

class ProductCardDetails extends StatelessWidget {
  final Results product;
  final VoidCallback onEdit;

  const ProductCardDetails({
    super.key,
    required this.product,
    required this.onEdit,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Column(
        children: [
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.grey.shade50,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              children: [
                InfoRow(
                  icon: Icons.qr_code,
                  label: 'الباركود',
                  value: product.barcodes?.isNotEmpty == true
                      ? product.barcodes!.first.toString()
                      : 'لا يوجد',
                  color: Colors.purple,
                ),
                const Divider(height: 16),
                InfoRow(
                  icon: Icons.attach_money,
                  label: 'السعر',
                  value: '${product.sellingPrice ?? '0'} ر.س',
                  color: Colors.green,
                ),
                const Divider(height: 16),
                InfoRow(
                  icon: Icons.inventory,
                  label: 'الكمية المتاحة',
                  value:
                      '${product.totalQuantity ?? '0'} ${product.unit ?? ''}',
                  color: Colors.orange,
                ),
                const Divider(height: 16),
                InfoRow(
                  icon: Icons.category,
                  label: 'القسم',
                  value: product.categoryName?.toString() ?? 'غير محدد',
                  color: Colors.blue,
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: onEdit,
              icon: const Icon(Icons.add_circle_outline),
              label: const Text('إضافة كمية'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue.shade600,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                elevation: 0,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
