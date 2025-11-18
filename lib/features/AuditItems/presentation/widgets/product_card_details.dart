// import 'package:flutter/material.dart';
// import 'package:stock_up/features/AuditItems/presentation/widgets/info_row.dart';
//
// import '../../data/models/response/search_products_model.dart';
//
// class ProductCardDetails extends StatelessWidget {
//   final Results product;
//   final VoidCallback onEdit;
//
//   const ProductCardDetails({
//     super.key,
//     required this.product,
//     required this.onEdit,
//   });
//
//   @override
//   Widget build(BuildContext context) {
//     return GestureDetector(
//       onTap: () => FocusScope.of(context).unfocus(),
//       child: Column(
//         children: [
//           const SizedBox(height: 16),
//           Container(
//             padding: const EdgeInsets.all(12),
//             decoration: BoxDecoration(
//               color: Colors.grey.shade50,
//               borderRadius: BorderRadius.circular(12),
//             ),
//             child: Column(
//               children: [
//                 InfoRow(
//                   icon: Icons.qr_code,
//                   label: 'الباركود',
//                   value: product.barcodes?.isNotEmpty == true
//                       ? product.barcodes!.first.toString()
//                       : 'لا يوجد',
//                   color: Colors.purple,
//                 ),
//                 const Divider(height: 16),
//                 InfoRow(
//                   icon: Icons.attach_money,
//                   label: 'السعر',
//                   value: '${product.sellingPrice ?? '0'} ر.س',
//                   color: Colors.green,
//                 ),
//                 const Divider(height: 16),
//                 InfoRow(
//                   icon: Icons.inventory,
//                   label: 'الكمية المتاحة',
//                   value:
//                       '${product.totalQuantity ?? '0'} ${product.unit ?? ''}',
//                   color: Colors.orange,
//                 ),
//                 const Divider(height: 16),
//                 InfoRow(
//                   icon: Icons.category,
//                   label: 'القسم',
//                   value: product.categoryName?.toString() ?? 'غير محدد',
//                   color: Colors.blue,
//                 ),
//                 const Divider(height: 16),
//                 InfoRow(
//                   icon: Icons.inventory_2,
//                   label: 'الوحدة',
//                   value: product.unit?.toString() ?? 'غير محدد',
//                   color: Colors.indigo,
//                 ),
//               ],
//             ),
//           ),
//           const SizedBox(height: 12),
//           SizedBox(
//             width: double.infinity,
//             child: ElevatedButton.icon(
//               onPressed: onEdit,
//               icon: const Icon(Icons.add_circle_outline),
//               label: const Text('إضافة كمية'),
//               style: ElevatedButton.styleFrom(
//                 backgroundColor: Colors.blue.shade600,
//                 foregroundColor: Colors.white,
//                 padding: const EdgeInsets.symmetric(vertical: 14),
//                 shape: RoundedRectangleBorder(
//                   borderRadius: BorderRadius.circular(12),
//                 ),
//                 elevation: 0,
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:stock_up/features/AuditItems/presentation/widgets/info_row.dart';

import '../../data/models/response/search_products_model.dart';

class ProductCardDetails extends StatefulWidget {
  final Results product;
  final VoidCallback onEdit;

  const ProductCardDetails({
    super.key,
    required this.product,
    required this.onEdit,
  });

  @override
  State<ProductCardDetails> createState() => _ProductCardDetailsState();
}

class _ProductCardDetailsState extends State<ProductCardDetails> {
  void _copyBarcode(String barcode) {
    Clipboard.setData(ClipboardData(text: barcode));
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(Icons.check_circle, color: Colors.white),
            const SizedBox(width: 12),
            Expanded(child: Text('تم نسخ الباركود: $barcode')),
          ],
        ),
        backgroundColor: Colors.green.shade600,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final barcodes = widget.product.barcodes ?? [];

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
                // قسم الباركودات
                _buildBarcodesSection(barcodes),

                if (barcodes.isNotEmpty) const Divider(height: 16),

                InfoRow(
                  icon: Icons.attach_money,
                  label: 'السعر',
                  value: '${widget.product.sellingPrice ?? '0'} ر.س',
                  color: Colors.green,
                ),
                const Divider(height: 16),
                InfoRow(
                  icon: Icons.inventory,
                  label: 'الكمية المتاحة',
                  value:
                      '${widget.product.totalQuantity ?? '0'} ${widget.product.unit ?? ''}',
                  color: Colors.orange,
                ),
                const Divider(height: 16),
                InfoRow(
                  icon: Icons.category,
                  label: 'القسم',
                  value: widget.product.categoryName?.toString() ?? 'غير محدد',
                  color: Colors.blue,
                ),
                const Divider(height: 16),
                InfoRow(
                  icon: Icons.inventory_2,
                  label: 'الوحدة',
                  value: widget.product.unit?.toString() ?? 'غير محدد',
                  color: Colors.indigo,
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: widget.onEdit,
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

  Widget _buildBarcodesSection(List<dynamic> barcodes) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // العنوان
        Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.purple.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(
                Icons.qr_code,
                size: 20,
                color: Colors.purple.shade700,
              ),
            ),
            const SizedBox(width: 12),
            Text(
              'الباركودات (${barcodes.length})',
              style: TextStyle(
                color: Colors.grey.shade800,
                fontSize: 14,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),

        // عرض الباركودات
        if (barcodes.isEmpty)
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.orange.shade50,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: Colors.orange.shade200),
            ),
            child: Row(
              children: [
                Icon(
                  Icons.warning_amber,
                  color: Colors.orange.shade700,
                  size: 20,
                ),
                const SizedBox(width: 8),
                const Text(
                  'لا توجد باركودات مضافة',
                  style: TextStyle(fontSize: 13),
                ),
              ],
            ),
          )
        else
          ...barcodes.map((barcode) {
            final barcodeStr = barcode.toString();
            return Container(
              margin: const EdgeInsets.only(bottom: 8),
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: Colors.purple.shade50,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.purple.shade200),
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.qr_code_scanner,
                    color: Colors.purple.shade700,
                    size: 18,
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      barcodeStr,
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: Colors.purple.shade900,
                        fontFamily: 'monospace',
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  // زر النسخ
                  Material(
                    color: Colors.transparent,
                    child: InkWell(
                      borderRadius: BorderRadius.circular(8),
                      onTap: () => _copyBarcode(barcodeStr),
                      child: Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              Colors.purple.shade400,
                              Colors.purple.shade600,
                            ],
                          ),
                          borderRadius: BorderRadius.circular(8),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.purple.shade200,
                              blurRadius: 4,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: const Icon(
                          Icons.copy_rounded,
                          color: Colors.white,
                          size: 18,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            );
          }),
      ],
    );
  }
}
