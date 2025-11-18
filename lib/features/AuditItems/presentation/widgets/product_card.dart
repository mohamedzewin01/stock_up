// import 'package:flutter/material.dart';
// import 'package:stock_up/features/AuditItems/presentation/widgets/product_card_details.dart';
// import 'package:stock_up/features/AuditItems/presentation/widgets/product_card_header.dart';
//
// import '../../data/models/response/search_products_model.dart';
//
// class ProductCard extends StatefulWidget {
//   final Results product;
//   final VoidCallback onEdit;
//
//   const ProductCard({super.key, required this.product, required this.onEdit});
//
//   @override
//   State<ProductCard> createState() => _ProductCardState();
// }
//
// class _ProductCardState extends State<ProductCard> {
//   bool isExpanded = false;
//
//   @override
//   Widget build(BuildContext context) {
//     return GestureDetector(
//       onTap: () => FocusScope.of(context).unfocus(),
//       child: Stack(
//         children: [
//           Container(
//             margin: const EdgeInsets.only(bottom: 16),
//             decoration: BoxDecoration(
//               color: Colors.white,
//               borderRadius: BorderRadius.circular(16),
//               boxShadow: [
//                 BoxShadow(
//                   color: Colors.grey.shade200,
//                   blurRadius: 8,
//                   offset: const Offset(0, 2),
//                 ),
//               ],
//             ),
//             child: Material(
//               color: Colors.transparent,
//               child: InkWell(
//                 borderRadius: BorderRadius.circular(16),
//                 onTap: () {
//                   FocusScope.of(context).unfocus();
//                   setState(() => isExpanded = !isExpanded);
//                 },
//                 child: Padding(
//                   padding: const EdgeInsets.all(16.0),
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       // Header - Always Visible
//                       ProductCardHeader(
//                         product: widget.product,
//                         isExpanded: isExpanded,
//                       ),
//
//                       // Details - Expandable
//                       AnimatedCrossFade(
//                         firstChild: const SizedBox.shrink(),
//                         secondChild: ProductCardDetails(
//                           product: widget.product,
//                           onEdit: widget.onEdit,
//                         ),
//                         crossFadeState: isExpanded
//                             ? CrossFadeState.showSecond
//                             : CrossFadeState.showFirst,
//                         duration: const Duration(milliseconds: 300),
//                       ),
//                     ],
//                   ),
//                 ),
//               ),
//             ),
//           ),
//           Positioned(
//             top: 0,
//             right: 8,
//             child: Container(
//               padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
//               decoration: BoxDecoration(
//                 color: Colors.red,
//                 borderRadius: BorderRadius.circular(8),
//               ),
//               child: Text(
//                 widget.product.unit ?? 'قطعة',
//                 style: TextStyle(
//                   color: Colors.white,
//                   fontWeight: FontWeight.bold,
//                 ),
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:stock_up/features/AuditItems/presentation/widgets/product_card_details.dart';
import 'package:stock_up/features/AuditItems/presentation/widgets/product_card_header.dart';

import '../../data/models/response/search_products_model.dart';

class ProductCard extends StatefulWidget {
  final Results product;
  final VoidCallback onEdit;

  const ProductCard({super.key, required this.product, required this.onEdit});

  @override
  State<ProductCard> createState() => _ProductCardState();
}

class _ProductCardState extends State<ProductCard>
    with SingleTickerProviderStateMixin {
  bool isExpanded = false;
  late AnimationController _animationController;
  late Animation<double> _rotationAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _rotationAnimation = Tween<double>(begin: 0, end: 0.5).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _toggleExpanded() {
    setState(() {
      isExpanded = !isExpanded;
      if (isExpanded) {
        _animationController.forward();
      } else {
        _animationController.reverse();
      }
    });
  }

  Color _getUnitColor() {
    final unit = widget.product.unit?.toLowerCase() ?? '';
    if (unit.contains('كرتون') || unit.contains('شد')) {
      return Colors.purple.shade600;
    } else if (unit.contains('قطعة') || unit.contains('حبة')) {
      return Colors.blue.shade600;
    } else if (unit.contains('علبة') || unit.contains('صندوق')) {
      return Colors.orange.shade600;
    } else if (unit.contains('درزن')) {
      return Colors.green.shade600;
    }
    return Colors.teal.shade600;
  }

  IconData _getUnitIcon() {
    final unit = widget.product.unit?.toLowerCase() ?? '';
    if (unit.contains('كرتون') || unit.contains('شد')) {
      return Icons.inventory_2;
    } else if (unit.contains('قطعة') || unit.contains('حبة')) {
      return Icons.circle;
    } else if (unit.contains('علبة') || unit.contains('صندوق')) {
      return Icons.gif_box;
    } else if (unit.contains('درزن')) {
      return Icons.grid_3x3;
    }
    return Icons.category;
  }

  bool _isLowStock() {
    try {
      final quantity = widget.product.totalQuantity;
      if (quantity == null || quantity.toString().isEmpty) return false;

      // تحويل الـ String إلى double
      final parsed = double.tryParse(quantity.toString());
      if (parsed != null) {
        return parsed < 10.0;
      }

      return false;
    } catch (e) {
      return false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Container(
        margin: const EdgeInsets.only(bottom: 16),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Colors.white, Colors.grey.shade50],
          ),
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.shade300,
              blurRadius: 12,
              offset: const Offset(0, 4),
              spreadRadius: 0,
            ),
            BoxShadow(
              color: Colors.white,
              blurRadius: 8,
              offset: const Offset(-4, -4),
              spreadRadius: 0,
            ),
          ],
          border: Border.all(color: Colors.grey.shade200, width: 1),
        ),
        child: Stack(
          children: [
            // محتوى البطاقة
            Material(
              color: Colors.transparent,
              child: InkWell(
                borderRadius: BorderRadius.circular(20),
                onTap: () {
                  FocusScope.of(context).unfocus();
                  _toggleExpanded();
                },
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16, vertical: 30),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Header
                      Row(
                        children: [
                          Expanded(
                            child: ProductCardHeader(
                              product: widget.product,
                              isExpanded: isExpanded,
                            ),
                          ),
                          // زر التوسيع
                          Container(
                            decoration: BoxDecoration(
                              color: Colors.grey.shade100,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            padding: const EdgeInsets.all(8),
                            child: RotationTransition(
                              turns: _rotationAnimation,
                              child: Icon(
                                Icons.keyboard_arrow_down,
                                color: Colors.grey.shade700,
                                size: 24,
                              ),
                            ),
                          ),
                        ],
                      ),

                      // Details - Expandable
                      AnimatedCrossFade(
                        firstChild: const SizedBox.shrink(),
                        secondChild: ProductCardDetails(
                          product: widget.product,
                          onEdit: widget.onEdit,
                        ),
                        crossFadeState: isExpanded
                            ? CrossFadeState.showSecond
                            : CrossFadeState.showFirst,
                        duration: const Duration(milliseconds: 300),
                      ),
                    ],
                  ),
                ),
              ),
            ),

            // شارة الوحدة (Unit Badge)
            Positioned(
              top: 0,
              right: 12,
              child: TweenAnimationBuilder<double>(
                duration: const Duration(milliseconds: 300),
                tween: Tween<double>(begin: 0.8, end: 1.0),
                builder: (context, scale, child) {
                  return Transform.scale(
                    scale: scale,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [
                            _getUnitColor(),
                            _getUnitColor().withOpacity(0.8),
                          ],
                        ),
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: [
                          BoxShadow(
                            color: _getUnitColor().withOpacity(0.3),
                            blurRadius: 8,
                            offset: const Offset(0, 3),
                          ),
                        ],
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(_getUnitIcon(), color: Colors.white, size: 16),
                          const SizedBox(width: 6),
                          Text(
                            widget.product.unit ?? 'قطعة',
                            style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 13,
                              letterSpacing: 0.5,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),

            // مؤشر الحالة (إذا كان المنتج قليل المخزون)
            // if (_isLowStock())
            Positioned(
              top: 0,
              left: 12,
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 5,
                ),
                decoration: BoxDecoration(
                  color: Colors.orange.shade100,
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: Colors.orange.shade300, width: 1.5),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.warning_amber_rounded,
                      color: Colors.orange.shade700,
                      size: 14,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      widget.product.totalQuantity.toString(),
                      style: TextStyle(
                        color: Colors.orange.shade900,
                        fontWeight: FontWeight.bold,
                        fontSize: 11,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
