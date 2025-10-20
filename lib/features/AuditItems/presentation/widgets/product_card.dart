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

class _ProductCardState extends State<ProductCard> {
  bool isExpanded = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Container(
        margin: const EdgeInsets.only(bottom: 16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.shade200,
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            borderRadius: BorderRadius.circular(16),
            onTap: () {
              FocusScope.of(context).unfocus();
              setState(() => isExpanded = !isExpanded);
            },
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Header - Always Visible
                  ProductCardHeader(
                    product: widget.product,
                    isExpanded: isExpanded,
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
      ),
    );
  }
}
