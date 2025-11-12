import 'package:flutter/material.dart';
import 'package:stock_up/features/AuditItems/data/models/response/search_products_model.dart';

class AddBarcodeSheet extends StatefulWidget {
  final Results product;
  final Function(
    String barcode,
    String? barcodeType,
    int? unitQuantity,
    double? unitPrice,
  )
  onConfirm;

  const AddBarcodeSheet({
    super.key,
    required this.product,
    required this.onConfirm,
  });

  @override
  State<AddBarcodeSheet> createState() => _AddBarcodeSheetState();
}

class _AddBarcodeSheetState extends State<AddBarcodeSheet> {
  final TextEditingController barcodeController = TextEditingController();
  final TextEditingController unitQuantityController = TextEditingController();
  final TextEditingController unitPriceController = TextEditingController();
  final TextEditingController selectedBarcodeType = TextEditingController();

  // String selectedBarcodeType = 'EAN-13';
  bool isLoading = false;

  final List<String> barcodeTypes = [
    'EAN-13',
    'EAN-8',
    'UPC-A',
    'UPC-E',
    'CODE-128',
    'CODE-39',
  ];

  @override
  void dispose() {
    barcodeController.dispose();
    unitQuantityController.dispose();
    unitPriceController.dispose();
    super.dispose();
  }

  Future<void> _handleConfirm() async {
    final barcode = barcodeController.text.trim();

    if (barcode.isEmpty) {
      _showError('يرجى إدخال الباركود');
      return;
    }

    setState(() => isLoading = true);

    try {
      final unitQuantity = unitQuantityController.text.isEmpty
          ? null
          : int.tryParse(unitQuantityController.text);
      final unitPrice = unitPriceController.text.isEmpty
          ? null
          : double.tryParse(unitPriceController.text);

      await widget.onConfirm(
        barcode,
        selectedBarcodeType.text,
        unitQuantity,
        unitPrice,
      );
    } catch (e) {
      setState(() => isLoading = false);
    }
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(Icons.error_outline, color: Colors.white),
            const SizedBox(width: 12),
            Expanded(child: Text(message)),
          ],
        ),
        backgroundColor: Colors.orange.shade600,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
      ),
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
      ),
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              margin: const EdgeInsets.only(top: 12),
              width: 50,
              height: 5,
              decoration: BoxDecoration(
                color: Colors.grey.shade300,
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildHeader(),
                  const SizedBox(height: 24),
                  _buildBarcodeInput(),
                  const SizedBox(height: 16),
                  _buildBarcodeTypeDropdown(),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Expanded(child: _buildUnitQuantityInput()),
                      const SizedBox(width: 12),
                      Expanded(child: _buildUnitPriceInput()),
                    ],
                  ),
                  const SizedBox(height: 32),
                  _buildActionButtons(),
                  SizedBox(height: MediaQuery.of(context).padding.bottom),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.green.shade400, Colors.green.shade700],
            ),
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Colors.green.shade200,
                blurRadius: 8,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: const Icon(
            Icons.qr_code_scanner_rounded,
            color: Colors.white,
            size: 28,
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'إضافة باركود',
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey.shade600,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 4),
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
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildBarcodeInput() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'الباركود *',
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.bold,
            color: Colors.grey.shade800,
          ),
        ),
        const SizedBox(height: 8),
        Container(
          decoration: BoxDecoration(
            color: Colors.grey.shade50,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.grey.shade200),
          ),
          child: TextField(
            controller: barcodeController,
            enabled: !isLoading,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              fontFamily: 'monospace',
            ),
            decoration: InputDecoration(
              hintText: 'أدخل رقم الباركود',
              hintStyle: TextStyle(color: Colors.grey.shade400),
              prefixIcon: Icon(
                Icons.qr_code_2,
                color: Colors.green.shade700,
                size: 20,
              ),
              border: InputBorder.none,
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 14,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildBarcodeTypeDropdown() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'نوع الباركود',
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.bold,
            color: Colors.grey.shade800,
          ),
        ),
        const SizedBox(height: 8),
        Container(
          decoration: BoxDecoration(
            color: Colors.grey.shade50,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.grey.shade200),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: TextField(
            controller: selectedBarcodeType,
            keyboardType: TextInputType.text,
            enabled: !isLoading,
            decoration: InputDecoration(
              hintText: 'اكتب نوع الكمية شد12 كرتون12 علبه12',
              hintStyle: TextStyle(color: Colors.grey.shade400),
              prefixIcon: Icon(
                Icons.card_travel_outlined,
                color: Colors.orange.shade700,
                size: 20,
              ),
              border: InputBorder.none,
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 14,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildUnitQuantityInput() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'الكمية بالوحدة',
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.bold,
            color: Colors.grey.shade800,
          ),
        ),
        const SizedBox(height: 8),
        Container(
          decoration: BoxDecoration(
            color: Colors.grey.shade50,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.grey.shade200),
          ),
          child: TextField(
            controller: unitQuantityController,
            keyboardType: TextInputType.number,
            enabled: !isLoading,
            decoration: InputDecoration(
              hintText: '0',
              hintStyle: TextStyle(color: Colors.grey.shade400),
              prefixIcon: Icon(
                Icons.numbers,
                color: Colors.orange.shade700,
                size: 20,
              ),
              border: InputBorder.none,
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 14,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildUnitPriceInput() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'سعر الوحدة',
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.bold,
            color: Colors.grey.shade800,
          ),
        ),
        const SizedBox(height: 8),
        Container(
          decoration: BoxDecoration(
            color: Colors.grey.shade50,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.grey.shade200),
          ),
          child: TextField(
            controller: unitPriceController,
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
            enabled: !isLoading,
            decoration: InputDecoration(
              hintText: '0.00',
              hintStyle: TextStyle(color: Colors.grey.shade400),
              prefixIcon: Icon(
                Icons.attach_money,
                color: Colors.green.shade700,
                size: 20,
              ),
              border: InputBorder.none,
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 14,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildActionButtons() {
    return Row(
      children: [
        Expanded(
          child: OutlinedButton(
            onPressed: isLoading ? null : () => Navigator.pop(context),
            style: OutlinedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(14),
              ),
              side: BorderSide(color: Colors.grey.shade300, width: 2),
            ),
            child: Text(
              'إلغاء',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.grey.shade700,
              ),
            ),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          flex: 2,
          child: ElevatedButton(
            onPressed: isLoading ? null : _handleConfirm,
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 16),
              backgroundColor: Colors.green.shade600,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(14),
              ),
              elevation: 0,
              disabledBackgroundColor: Colors.grey.shade300,
            ),
            child: isLoading
                ? const SizedBox(
                    height: 20,
                    width: 20,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                    ),
                  )
                : const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.add_circle_rounded, size: 22),
                      SizedBox(width: 8),
                      Text(
                        'إضافة الباركود',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
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
