import 'package:flutter/material.dart';
import 'package:stock_up/core/resources/color_manager.dart';
import 'package:stock_up/features/AuditItems/data/models/response/search_products_model.dart';

class BarcodeProductCard extends StatefulWidget {
  final Results product;
  final VoidCallback onAddBarcode;
  final VoidCallback onDeleteBarcode;

  const BarcodeProductCard({
    super.key,
    required this.product,
    required this.onAddBarcode,
    required this.onDeleteBarcode,
  });

  @override
  State<BarcodeProductCard> createState() => _BarcodeProductCardState();
}

class _BarcodeProductCardState extends State<BarcodeProductCard> {
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
                  // Header
                  _buildHeader(),

                  // Details
                  AnimatedCrossFade(
                    firstChild: const SizedBox.shrink(),
                    secondChild: _buildDetails(),
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

  Widget _buildHeader() {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [ColorManager.primaryLight, ColorManager.purple1],
            ),
            borderRadius: BorderRadius.circular(12),
          ),
          child: const Icon(Icons.qr_code_2, color: Colors.white, size: 24),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                widget.product.productName ?? 'غير معروف',
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              if (!isExpanded) ...[
                const SizedBox(height: 4),
                Text(
                  'اضغط لعرض الباركودات',
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.blue.shade600,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ],
          ),
        ),
        Icon(
          isExpanded ? Icons.keyboard_arrow_up : Icons.keyboard_arrow_down,
          color: Colors.grey.shade600,
        ),
      ],
    );
  }

  Widget _buildDetails() {
    final barcodes = widget.product.barcodes ?? [];

    return Column(
      children: [
        const SizedBox(height: 16),
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Colors.grey.shade50,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildInfoRow(
                icon: Icons.category,
                label: 'القسم',
                value: widget.product.categoryName ?? 'غير محدد',
                color: Colors.blue,
              ),
              const Divider(height: 16),
              _buildInfoRow(
                icon: Icons.attach_money,
                label: 'السعر',
                value: '${widget.product.sellingPrice ?? '0'} ر.س',
                color: Colors.green,
              ),
              const Divider(height: 16),
              _buildInfoRow(
                icon: Icons.inventory,
                label: 'الكمية المتاحة',
                value:
                    '${widget.product.totalQuantity ?? '0'} ${widget.product.unit ?? ''}',
                color: Colors.orange,
              ),
              const Divider(height: 16),
              // عرض الباركودات الموجودة
              _buildBarcodesSection(barcodes),
            ],
          ),
        ),
        const SizedBox(height: 12),
        // Buttons
        Row(
          children: [
            Expanded(
              child: ElevatedButton.icon(
                onPressed: widget.onAddBarcode,
                icon: const Icon(Icons.add_circle_outline, size: 20),
                label: const Text('إضافة باركود'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green.shade600,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  elevation: 0,
                ),
              ),
            ),
            if (barcodes.isNotEmpty) ...[
              const SizedBox(width: 8),
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: widget.onDeleteBarcode,
                  icon: const Icon(Icons.delete_outline, size: 20),
                  label: const Text('حذف باركود'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red.shade600,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    elevation: 0,
                  ),
                ),
              ),
            ],
          ],
        ),
      ],
    );
  }

  Widget _buildInfoRow({
    required IconData icon,
    required String label,
    required String value,
    required Color color,
  }) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(icon, size: 20, color: color),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: TextStyle(
                  color: Colors.grey.shade600,
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                value,
                style: const TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                  color: Colors.black87,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildBarcodesSection(List<dynamic> barcodes) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
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
          ...barcodes.map(
            (barcode) => Container(
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
                      barcode.toString(),
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: Colors.purple.shade900,
                        fontFamily: 'monospace',
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
      ],
    );
  }
}
