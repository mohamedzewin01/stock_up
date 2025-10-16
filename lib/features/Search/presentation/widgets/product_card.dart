// import 'package:flutter/material.dart';
// import 'package:stock_up/features/Search/data/models/response/search_model.dart';
//
// import 'info_chip.dart';
//
// class ProductCard extends StatelessWidget {
//   final Results product;
//
//   const ProductCard({super.key, required this.product});
//
//   @override
//   Widget build(BuildContext context) {
//     return Card(
//       margin: const EdgeInsets.only(bottom: 8),
//       elevation: 0,
//       shape: RoundedRectangleBorder(
//         borderRadius: BorderRadius.circular(12),
//         side: BorderSide(color: Colors.grey[200]!, width: 1),
//       ),
//       child: InkWell(
//         borderRadius: BorderRadius.circular(12),
//         onTap: () {
//           // يمكن إضافة انتقال لصفحة التفاصيل هنا
//         },
//         child: Padding(
//           padding: const EdgeInsets.all(12.0),
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               // Product Name & Number Row
//               Row(
//                 children: [
//                   Expanded(
//                     child: Text(
//                       product.productName ?? 'بدون اسم',
//                       style: const TextStyle(
//                         fontSize: 15,
//                         fontWeight: FontWeight.bold,
//                         height: 1.3,
//                         color: Colors.black87,
//                       ),
//                       maxLines: 2,
//                       overflow: TextOverflow.ellipsis,
//                     ),
//                   ),
//                   const SizedBox(width: 8),
//                   Container(
//                     padding: const EdgeInsets.symmetric(
//                       horizontal: 8,
//                       vertical: 4,
//                     ),
//                     decoration: BoxDecoration(
//                       color: Colors.blue[50],
//                       borderRadius: BorderRadius.circular(6),
//                       border: Border.all(color: Colors.blue[200]!, width: 1),
//                     ),
//                     child: Text(
//                       '#${product.productNumber ?? ''}',
//                       style: TextStyle(
//                         color: Colors.blue[800],
//                         fontWeight: FontWeight.w600,
//                         fontSize: 11,
//                       ),
//                     ),
//                   ),
//                 ],
//               ),
//               const SizedBox(height: 10),
//
//               // Compact Info Grid
//               Row(
//                 children: [
//                   // Category
//                   if (product.categoryName != null)
//                     Expanded(
//                       child: InfoChip(
//                         icon: Icons.category_outlined,
//                         text: product.categoryName!,
//                         color: Colors.orange,
//                       ),
//                     ),
//                   if (product.categoryName != null) const SizedBox(width: 8),
//
//                   // Quantity
//                   Expanded(
//                     child: InfoChip(
//                       icon: Icons.inventory_2_outlined,
//                       text:
//                           '${product.totalQuantity ?? '0'} ${product.unit ?? ''}',
//                       color: Colors.purple,
//                     ),
//                   ),
//                 ],
//               ),
//               const SizedBox(height: 8),
//
//               // Price & Barcode Row
//               Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                 children: [
//                   // Price
//                   Container(
//                     padding: const EdgeInsets.symmetric(
//                       horizontal: 10,
//                       vertical: 6,
//                     ),
//                     decoration: BoxDecoration(
//                       color: Colors.green[50],
//                       borderRadius: BorderRadius.circular(8),
//                       border: Border.all(color: Colors.green[200]!, width: 1),
//                     ),
//                     child: Row(
//                       mainAxisSize: MainAxisSize.min,
//                       children: [
//                         Icon(
//                           Icons.payments_outlined,
//                           size: 16,
//                           color: Colors.green[700],
//                         ),
//                         const SizedBox(width: 4),
//                         Text(
//                           '${product.sellingPrice ?? '0'} ر.س',
//                           style: TextStyle(
//                             color: Colors.green[800],
//                             fontWeight: FontWeight.bold,
//                             fontSize: 14,
//                           ),
//                         ),
//                       ],
//                     ),
//                   ),
//
//                   // Barcode Count
//                   if (product.barcodes != null && product.barcodes!.isNotEmpty)
//                     Container(
//                       padding: const EdgeInsets.symmetric(
//                         horizontal: 8,
//                         vertical: 6,
//                       ),
//                       decoration: BoxDecoration(
//                         color: Colors.grey[100],
//                         borderRadius: BorderRadius.circular(8),
//                         border: Border.all(color: Colors.grey[300]!, width: 1),
//                       ),
//                       child: Row(
//                         mainAxisSize: MainAxisSize.min,
//                         children: [
//                           Icon(
//                             Icons.qr_code_2,
//                             size: 14,
//                             color: Colors.grey[700],
//                           ),
//                           const SizedBox(width: 4),
//                           Text(
//                             '${product.barcodes!.length}',
//                             style: TextStyle(
//                               color: Colors.grey[700],
//                               fontWeight: FontWeight.w600,
//                               fontSize: 12,
//                             ),
//                           ),
//                         ],
//                       ),
//                     ),
//                 ],
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
import 'package:flutter/material.dart';
import 'package:stock_up/features/Search/data/models/response/search_model.dart';

class ProductCard extends StatelessWidget {
  final Results product;
  final bool isSelected;
  final VoidCallback? onTap;

  const ProductCard({
    super.key,
    required this.product,
    this.isSelected = false,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        gradient: isSelected
            ? LinearGradient(
                colors: [
                  const Color(0xFF6C63FF).withOpacity(0.1),
                  const Color(0xFF5A52E0).withOpacity(0.05),
                ],
              )
            : null,
        boxShadow: [
          BoxShadow(
            color: isSelected
                ? const Color(0xFF6C63FF).withOpacity(0.2)
                : Colors.black.withOpacity(0.05),
            blurRadius: isSelected ? 20 : 10,
            offset: Offset(0, isSelected ? 8 : 4),
          ),
        ],
      ),
      child: Material(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        child: InkWell(
          borderRadius: BorderRadius.circular(20),
          onTap: onTap,
          child: Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: isSelected ? const Color(0xFF6C63FF) : Colors.grey[200]!,
                width: isSelected ? 2 : 1,
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header Row
                Row(
                  children: [
                    // Product Icon
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          colors: [Color(0xFF6C63FF), Color(0xFF5A52E0)],
                        ),
                        borderRadius: BorderRadius.circular(14),
                        boxShadow: [
                          BoxShadow(
                            color: const Color(0xFF6C63FF).withOpacity(0.3),
                            blurRadius: 8,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: const Icon(
                        Icons.inventory_2_rounded,
                        color: Colors.white,
                        size: 24,
                      ),
                    ),
                    const SizedBox(width: 12),
                    // Product Name
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            product.productName ?? 'بدون اسم',
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF2D3436),
                              height: 1.3,
                            ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'رقم المنتج: #${product.productNumber ?? ''}',
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.grey[600],
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 8),
                    // Product Number Badge
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            const Color(0xFF4FACFE).withOpacity(0.2),
                            const Color(0xFF00F2FE).withOpacity(0.2),
                          ],
                        ),
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(
                          color: const Color(0xFF4FACFE).withOpacity(0.3),
                          width: 1,
                        ),
                      ),
                      child: Text(
                        '#${product.productNumber ?? ''}',
                        style: const TextStyle(
                          color: Color(0xFF4FACFE),
                          fontWeight: FontWeight.bold,
                          fontSize: 12,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),

                // Info Chips Row
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: [
                    // Category Chip
                    if (product.categoryName != null)
                      _buildModernChip(
                        icon: Icons.category_rounded,
                        label: product.categoryName!,
                        gradient: const [Color(0xFFFA709A), Color(0xFFFEE140)],
                      ),
                    // Quantity Chip
                    _buildModernChip(
                      icon: Icons.inventory_rounded,
                      label:
                          '${product.totalQuantity ?? '0'} ${product.unit ?? ''}',
                      gradient: const [Color(0xFF667EEA), Color(0xFF764BA2)],
                    ),
                    // Tax Chip
                    if (product.taxable == 1)
                      _buildModernChip(
                        icon: Icons.receipt_rounded,
                        label: 'ضريبة ${product.taxRate ?? '0'}%',
                        gradient: const [Color(0xFFFF6B9D), Color(0xFFFFA06B)],
                      ),
                  ],
                ),
                const SizedBox(height: 16),

                // Bottom Row - Price & Barcode
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // Price Container
                    Expanded(
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 14,
                          vertical: 12,
                        ),
                        decoration: BoxDecoration(
                          gradient: const LinearGradient(
                            colors: [Color(0xFF11998E), Color(0xFF38EF7D)],
                          ),
                          borderRadius: BorderRadius.circular(14),
                          boxShadow: [
                            BoxShadow(
                              color: const Color(0xFF11998E).withOpacity(0.3),
                              blurRadius: 8,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(
                              Icons.payments_rounded,
                              color: Colors.white,
                              size: 20,
                            ),
                            const SizedBox(width: 8),
                            Flexible(
                              child: Text(
                                '${product.sellingPrice ?? '0'} ر.س',
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                ),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    // Barcode Badge
                    if (product.barcodes != null &&
                        product.barcodes!.isNotEmpty)
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 12,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.grey[100],
                          borderRadius: BorderRadius.circular(14),
                          border: Border.all(
                            color: Colors.grey[300]!,
                            width: 1.5,
                          ),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              Icons.qr_code_2_rounded,
                              color: Colors.grey[700],
                              size: 18,
                            ),
                            const SizedBox(width: 6),
                            Text(
                              '${product.barcodes!.length}',
                              style: TextStyle(
                                color: Colors.grey[800],
                                fontWeight: FontWeight.bold,
                                fontSize: 14,
                              ),
                            ),
                          ],
                        ),
                      ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildModernChip({
    required IconData icon,
    required String label,
    required List<Color> gradient,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: gradient.map((c) => c.withOpacity(0.15)).toList(),
        ),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: gradient[0].withOpacity(0.3), width: 1),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 16, color: gradient[0]),
          const SizedBox(width: 6),
          Flexible(
            child: Text(
              label,
              style: TextStyle(
                color: gradient[0],
                fontSize: 13,
                fontWeight: FontWeight.w600,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }
}
