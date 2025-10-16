import 'package:flutter/material.dart';

import '../../data/models/response/search_model.dart';
import 'barcode_card.dart';
import 'detail_card.dart';

class ProductDetailsView extends StatelessWidget {
  final Results product;
  final ScrollController? scrollController;

  const ProductDetailsView({
    super.key,
    required this.product,
    this.scrollController,
  });

  @override
  Widget build(BuildContext context) {
    return ListView(
      controller: scrollController,
      padding: const EdgeInsets.all(24),
      children: [
        // Product Header
        Row(
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFF6C63FF), Color(0xFF5A52E0)],
                ),
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFF6C63FF).withOpacity(0.3),
                    blurRadius: 15,
                    offset: const Offset(0, 5),
                  ),
                ],
              ),
              child: const Icon(
                Icons.inventory_2_rounded,
                color: Colors.white,
                size: 32,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    product.productName ?? 'بدون اسم',
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF2D3436),
                      height: 1.3,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          const Color(0xFF4FACFE).withOpacity(0.2),
                          const Color(0xFF00F2FE).withOpacity(0.2),
                        ],
                      ),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      'رقم المنتج: #${product.productNumber ?? ''}',
                      style: const TextStyle(
                        color: Color(0xFF4FACFE),
                        fontWeight: FontWeight.bold,
                        fontSize: 13,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: 32),

        // Price Card
        DetailCard(
          icon: Icons.payments_rounded,
          title: 'السعر',
          gradient: const [Color(0xFF11998E), Color(0xFF38EF7D)],
          children: [
            _buildDetailRow(
              'سعر البيع',
              '${product.sellingPrice ?? '0'} ر.س',
              Icons.sell_rounded,
            ),
            if (product.averagePurchasePrice != null) ...[
              const Divider(height: 24),
              _buildDetailRow(
                'متوسط سعر الشراء',
                '${product.averagePurchasePrice} ر.س',
                Icons.shopping_cart_rounded,
              ),
            ],
            if (product.lastPurchasePrice != null) ...[
              const Divider(height: 24),
              _buildDetailRow(
                'آخر سعر شراء',
                '${product.lastPurchasePrice} ر.س',
                Icons.receipt_long_rounded,
              ),
            ],
          ],
        ),

        const SizedBox(height: 16),

        // Stock Card
        DetailCard(
          icon: Icons.inventory_rounded,
          title: 'المخزون',
          gradient: const [Color(0xFFFF6B9D), Color(0xFFFFA06B)],
          children: [
            _buildDetailRow(
              'الكمية المتاحة',
              '${product.totalQuantity ?? '0'} ${product.unit ?? ''}',
              Icons.store_rounded,
            ),
          ],
        ),

        const SizedBox(height: 16),

        // Category Card
        if (product.categoryName != null)
          DetailCard(
            icon: Icons.category_rounded,
            title: 'التصنيف',
            gradient: const [Color(0xFFFA709A), Color(0xFFFEE140)],
            children: [
              _buildDetailRow(
                'الفئة',
                product.categoryName!,
                Icons.label_rounded,
              ),
            ],
          ),

        const SizedBox(height: 16),

        // Tax Card
        if (product.taxable == 1)
          DetailCard(
            icon: Icons.receipt_rounded,
            title: 'الضريبة',
            gradient: const [Color(0xFF667EEA), Color(0xFF764BA2)],
            children: [
              _buildDetailRow(
                'نسبة الضريبة',
                '${product.taxRate ?? '0'}%',
                Icons.percent_rounded,
              ),
            ],
          ),

        const SizedBox(height: 16),

        // Barcodes Card
        if (product.barcodes != null && product.barcodes!.isNotEmpty)
          BarcodeCard(barcodes: product.barcodes!),
      ],
    );
  }

  // Widget _buildDetailCard({
  //   required IconData icon,
  //   required String title,
  //   required List<Color> gradient,
  //   required List<Widget> children,
  // }) {
  //   return Container(
  //     decoration: BoxDecoration(
  //       color: Colors.white,
  //       borderRadius: BorderRadius.circular(20),
  //       boxShadow: [
  //         BoxShadow(
  //           color: Colors.black.withOpacity(0.05),
  //           blurRadius: 15,
  //           offset: const Offset(0, 5),
  //         ),
  //       ],
  //     ),
  //     child: Column(
  //       crossAxisAlignment: CrossAxisAlignment.start,
  //       children: [
  //         Container(
  //           padding: const EdgeInsets.all(16),
  //           decoration: BoxDecoration(
  //             gradient: LinearGradient(colors: gradient),
  //             borderRadius: const BorderRadius.only(
  //               topLeft: Radius.circular(20),
  //               topRight: Radius.circular(20),
  //             ),
  //           ),
  //           child: Row(
  //             children: [
  //               Icon(icon, color: Colors.white, size: 24),
  //               const SizedBox(width: 12),
  //               Text(
  //                 title,
  //                 style: const TextStyle(
  //                   color: Colors.white,
  //                   fontSize: 18,
  //                   fontWeight: FontWeight.bold,
  //                 ),
  //               ),
  //             ],
  //           ),
  //         ),
  //         Padding(
  //           padding: const EdgeInsets.all(20),
  //           child: Column(children: children),
  //         ),
  //       ],
  //     ),
  //   );
  // }

  Widget _buildDetailRow(String label, String value, IconData icon) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: Colors.grey[100],
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(icon, size: 20, color: Colors.grey[700]),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: TextStyle(fontSize: 13, color: Colors.grey[600]),
              ),
              const SizedBox(height: 2),
              Text(
                value,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF2D3436),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
