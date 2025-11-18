// import 'package:flutter/material.dart';
// import 'package:stock_up/features/AuditItems/data/models/response/search_products_model.dart';
//
// class AddBarcodeSheet extends StatefulWidget {
//   final Results product;
//   final Function(
//     String barcode,
//     String? barcodeType,
//     int? unitQuantity,
//     double? unitPrice,
//   )
//   onConfirm;
//
//   const AddBarcodeSheet({
//     super.key,
//     required this.product,
//     required this.onConfirm,
//   });
//
//   @override
//   State<AddBarcodeSheet> createState() => _AddBarcodeSheetState();
// }
//
// class _AddBarcodeSheetState extends State<AddBarcodeSheet> {
//   final TextEditingController barcodeController = TextEditingController();
//   final TextEditingController unitQuantityController = TextEditingController();
//   final TextEditingController unitPriceController = TextEditingController();
//   final TextEditingController selectedBarcodeType = TextEditingController();
//
//   // String selectedBarcodeType = 'EAN-13';
//   bool isLoading = false;
//
//   final List<String> barcodeTypes = [
//     'EAN-13',
//     'EAN-8',
//     'UPC-A',
//     'UPC-E',
//     'CODE-128',
//     'CODE-39',
//   ];
//
//   @override
//   void dispose() {
//     barcodeController.dispose();
//     unitQuantityController.dispose();
//     unitPriceController.dispose();
//     super.dispose();
//   }
//
//   Future<void> _handleConfirm() async {
//     final barcode = barcodeController.text.trim();
//
//     if (barcode.isEmpty) {
//       _showError('يرجى إدخال الباركود');
//       return;
//     }
//
//     setState(() => isLoading = true);
//
//     try {
//       final unitQuantity = unitQuantityController.text.isEmpty
//           ? null
//           : int.tryParse(unitQuantityController.text);
//       final unitPrice = unitPriceController.text.isEmpty
//           ? null
//           : double.tryParse(unitPriceController.text);
//
//       await widget.onConfirm(
//         barcode,
//         selectedBarcodeType.text,
//         unitQuantity,
//         unitPrice,
//       );
//     } catch (e) {
//       setState(() => isLoading = false);
//     }
//   }
//
//   void _showError(String message) {
//     ScaffoldMessenger.of(context).showSnackBar(
//       SnackBar(
//         content: Row(
//           children: [
//             const Icon(Icons.error_outline, color: Colors.white),
//             const SizedBox(width: 12),
//             Expanded(child: Text(message)),
//           ],
//         ),
//         backgroundColor: Colors.orange.shade600,
//         behavior: SnackBarBehavior.floating,
//         shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
//       ),
//     );
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       decoration: const BoxDecoration(
//         color: Colors.white,
//         borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
//       ),
//       padding: EdgeInsets.only(
//         bottom: MediaQuery.of(context).viewInsets.bottom,
//       ),
//       child: SingleChildScrollView(
//         child: Column(
//           mainAxisSize: MainAxisSize.min,
//           children: [
//             Container(
//               margin: const EdgeInsets.only(top: 12),
//               width: 50,
//               height: 5,
//               decoration: BoxDecoration(
//                 color: Colors.grey.shade300,
//                 borderRadius: BorderRadius.circular(10),
//               ),
//             ),
//             Padding(
//               padding: const EdgeInsets.all(24),
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   _buildHeader(),
//                   const SizedBox(height: 24),
//                   _buildBarcodeInput(),
//                   const SizedBox(height: 16),
//                   _buildBarcodeTypeDropdown(),
//                   const SizedBox(height: 16),
//                   Row(
//                     children: [
//                       Expanded(child: _buildUnitQuantityInput()),
//                       const SizedBox(width: 12),
//                       Expanded(child: _buildUnitPriceInput()),
//                     ],
//                   ),
//                   const SizedBox(height: 32),
//                   _buildActionButtons(),
//                   SizedBox(height: MediaQuery.of(context).padding.bottom),
//                 ],
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
//
//   Widget _buildHeader() {
//     return Row(
//       children: [
//         Container(
//           padding: const EdgeInsets.all(14),
//           decoration: BoxDecoration(
//             gradient: LinearGradient(
//               colors: [Colors.green.shade400, Colors.green.shade700],
//             ),
//             borderRadius: BorderRadius.circular(16),
//             boxShadow: [
//               BoxShadow(
//                 color: Colors.green.shade200,
//                 blurRadius: 8,
//                 offset: const Offset(0, 4),
//               ),
//             ],
//           ),
//           child: const Icon(
//             Icons.qr_code_scanner_rounded,
//             color: Colors.white,
//             size: 28,
//           ),
//         ),
//         const SizedBox(width: 16),
//         Expanded(
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               Text(
//                 'إضافة باركود',
//                 style: TextStyle(
//                   fontSize: 14,
//                   color: Colors.grey.shade600,
//                   fontWeight: FontWeight.w500,
//                 ),
//               ),
//               const SizedBox(height: 4),
//               Text(
//                 widget.product.productName ?? 'غير معروف',
//                 style: const TextStyle(
//                   fontSize: 18,
//                   fontWeight: FontWeight.bold,
//                   color: Colors.black87,
//                 ),
//                 maxLines: 2,
//                 overflow: TextOverflow.ellipsis,
//               ),
//             ],
//           ),
//         ),
//       ],
//     );
//   }
//
//   Widget _buildBarcodeInput() {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         Text(
//           'الباركود *',
//           style: TextStyle(
//             fontSize: 14,
//             fontWeight: FontWeight.bold,
//             color: Colors.grey.shade800,
//           ),
//         ),
//         const SizedBox(height: 8),
//         Container(
//           decoration: BoxDecoration(
//             color: Colors.grey.shade50,
//             borderRadius: BorderRadius.circular(12),
//             border: Border.all(color: Colors.grey.shade200),
//           ),
//           child: TextField(
//             controller: barcodeController,
//             enabled: !isLoading,
//             style: const TextStyle(
//               fontSize: 16,
//               fontWeight: FontWeight.w600,
//               fontFamily: 'monospace',
//             ),
//             decoration: InputDecoration(
//               hintText: 'أدخل رقم الباركود',
//               hintStyle: TextStyle(color: Colors.grey.shade400),
//               prefixIcon: Icon(
//                 Icons.qr_code_2,
//                 color: Colors.green.shade700,
//                 size: 20,
//               ),
//               border: InputBorder.none,
//               contentPadding: const EdgeInsets.symmetric(
//                 horizontal: 16,
//                 vertical: 14,
//               ),
//             ),
//           ),
//         ),
//       ],
//     );
//   }
//
//   Widget _buildBarcodeTypeDropdown() {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         Text(
//           'نوع الباركود',
//           style: TextStyle(
//             fontSize: 14,
//             fontWeight: FontWeight.bold,
//             color: Colors.grey.shade800,
//           ),
//         ),
//         const SizedBox(height: 8),
//         Container(
//           decoration: BoxDecoration(
//             color: Colors.grey.shade50,
//             borderRadius: BorderRadius.circular(12),
//             border: Border.all(color: Colors.grey.shade200),
//           ),
//           padding: const EdgeInsets.symmetric(horizontal: 16),
//           child: TextField(
//             controller: selectedBarcodeType,
//             keyboardType: TextInputType.text,
//             enabled: !isLoading,
//             decoration: InputDecoration(
//               hintText: 'اكتب نوع الكمية شد12 كرتون12 علبه12',
//               hintStyle: TextStyle(color: Colors.grey.shade400),
//               prefixIcon: Icon(
//                 Icons.card_travel_outlined,
//                 color: Colors.orange.shade700,
//                 size: 20,
//               ),
//               border: InputBorder.none,
//               contentPadding: const EdgeInsets.symmetric(
//                 horizontal: 16,
//                 vertical: 14,
//               ),
//             ),
//           ),
//         ),
//       ],
//     );
//   }
//
//   Widget _buildUnitQuantityInput() {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         Text(
//           'الكمية بالوحدة',
//           style: TextStyle(
//             fontSize: 14,
//             fontWeight: FontWeight.bold,
//             color: Colors.grey.shade800,
//           ),
//         ),
//         const SizedBox(height: 8),
//         Container(
//           decoration: BoxDecoration(
//             color: Colors.grey.shade50,
//             borderRadius: BorderRadius.circular(12),
//             border: Border.all(color: Colors.grey.shade200),
//           ),
//           child: TextField(
//             controller: unitQuantityController,
//             keyboardType: TextInputType.number,
//             enabled: !isLoading,
//             decoration: InputDecoration(
//               hintText: '0',
//               hintStyle: TextStyle(color: Colors.grey.shade400),
//               prefixIcon: Icon(
//                 Icons.numbers,
//                 color: Colors.orange.shade700,
//                 size: 20,
//               ),
//               border: InputBorder.none,
//               contentPadding: const EdgeInsets.symmetric(
//                 horizontal: 16,
//                 vertical: 14,
//               ),
//             ),
//           ),
//         ),
//       ],
//     );
//   }
//
//   Widget _buildUnitPriceInput() {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         Text(
//           'سعر الوحدة',
//           style: TextStyle(
//             fontSize: 14,
//             fontWeight: FontWeight.bold,
//             color: Colors.grey.shade800,
//           ),
//         ),
//         const SizedBox(height: 8),
//         Container(
//           decoration: BoxDecoration(
//             color: Colors.grey.shade50,
//             borderRadius: BorderRadius.circular(12),
//             border: Border.all(color: Colors.grey.shade200),
//           ),
//           child: TextField(
//             controller: unitPriceController,
//             keyboardType: const TextInputType.numberWithOptions(decimal: true),
//             enabled: !isLoading,
//             decoration: InputDecoration(
//               hintText: '0.00',
//               hintStyle: TextStyle(color: Colors.grey.shade400),
//               prefixIcon: Icon(
//                 Icons.attach_money,
//                 color: Colors.green.shade700,
//                 size: 20,
//               ),
//               border: InputBorder.none,
//               contentPadding: const EdgeInsets.symmetric(
//                 horizontal: 16,
//                 vertical: 14,
//               ),
//             ),
//           ),
//         ),
//       ],
//     );
//   }
//
//   Widget _buildActionButtons() {
//     return Row(
//       children: [
//         Expanded(
//           child: OutlinedButton(
//             onPressed: isLoading ? null : () => Navigator.pop(context),
//             style: OutlinedButton.styleFrom(
//               padding: const EdgeInsets.symmetric(vertical: 16),
//               shape: RoundedRectangleBorder(
//                 borderRadius: BorderRadius.circular(14),
//               ),
//               side: BorderSide(color: Colors.grey.shade300, width: 2),
//             ),
//             child: Text(
//               'إلغاء',
//               style: TextStyle(
//                 fontSize: 16,
//                 fontWeight: FontWeight.bold,
//                 color: Colors.grey.shade700,
//               ),
//             ),
//           ),
//         ),
//         const SizedBox(width: 12),
//         Expanded(
//           flex: 2,
//           child: ElevatedButton(
//             onPressed: isLoading ? null : _handleConfirm,
//             style: ElevatedButton.styleFrom(
//               padding: const EdgeInsets.symmetric(vertical: 16),
//               backgroundColor: Colors.green.shade600,
//               foregroundColor: Colors.white,
//               shape: RoundedRectangleBorder(
//                 borderRadius: BorderRadius.circular(14),
//               ),
//               elevation: 0,
//               disabledBackgroundColor: Colors.grey.shade300,
//             ),
//             child: isLoading
//                 ? const SizedBox(
//                     height: 20,
//                     width: 20,
//                     child: CircularProgressIndicator(
//                       strokeWidth: 2,
//                       valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
//                     ),
//                   )
//                 : const Row(
//                     mainAxisAlignment: MainAxisAlignment.center,
//                     children: [
//                       Icon(Icons.add_circle_rounded, size: 22),
//                       SizedBox(width: 8),
//                       Text(
//                         'إضافة الباركود',
//                         style: TextStyle(
//                           fontSize: 16,
//                           fontWeight: FontWeight.bold,
//                         ),
//                       ),
//                     ],
//                   ),
//           ),
//         ),
//       ],
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
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

  bool isLoading = false;

  @override
  void dispose() {
    barcodeController.dispose();
    unitQuantityController.dispose();
    unitPriceController.dispose();
    selectedBarcodeType.dispose();
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
        selectedBarcodeType.text.isNotEmpty ? selectedBarcodeType.text : null,
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

  Future<void> _scanBarcode() async {
    try {
      await Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => _BarcodeScannerScreen(
            onBarcodeScanned: (String code) {
              setState(() {
                barcodeController.text = code;
              });
            },
          ),
        ),
      );
    } catch (e) {
      _showError('حدث خطأ أثناء المسح: ${e.toString()}');
    }
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
                  _buildBarcodeTypeInput(),
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
        Row(
          children: [
            // حقل إدخال الباركود
            Expanded(
              child: Container(
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
            ),
            const SizedBox(width: 8),
            // زر المسح بالكاميرا
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Colors.green.shade400, Colors.green.shade700],
                ),
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.green.shade200,
                    blurRadius: 4,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  onTap: isLoading ? null : _scanBarcode,
                  borderRadius: BorderRadius.circular(12),
                  child: Container(
                    padding: const EdgeInsets.all(14),
                    child: const Icon(
                      Icons.camera_alt_rounded,
                      color: Colors.white,
                      size: 24,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Row(
          children: [
            Icon(Icons.info_outline, size: 14, color: Colors.blue.shade600),
            const SizedBox(width: 4),
            Text(
              'يمكنك الكتابة يدوياً أو المسح بالكاميرا',
              style: TextStyle(
                fontSize: 12,
                color: Colors.blue.shade600,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildBarcodeTypeInput() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
              'نوع الوحدة',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: Colors.grey.shade800,
              ),
            ),
            const SizedBox(width: 6),
            Text(
              '(اختياري)',
              style: TextStyle(
                fontSize: 12,
                color: Colors.grey.shade500,
                fontWeight: FontWeight.normal,
              ),
            ),
          ],
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
              hintText: 'مثال: شد12، كرتون12، علبة12، قطعة، درزن',
              hintStyle: TextStyle(color: Colors.grey.shade400, fontSize: 13),
              prefixIcon: Icon(
                Icons.inventory_2_outlined,
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
        const SizedBox(height: 8),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 4),
          child: Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              _buildSuggestionChip('شد12', Icons.straighten),
              _buildSuggestionChip('كرتون12', Icons.inventory),
              _buildSuggestionChip('علبة12', Icons.local_shipping),
              _buildSuggestionChip('قطعة', Icons.square),
              _buildSuggestionChip('درزن', Icons.grid_3x3),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildSuggestionChip(String label, IconData icon) {
    return InkWell(
      onTap: isLoading
          ? null
          : () {
              setState(() {
                selectedBarcodeType.text = label;
              });
            },
      borderRadius: BorderRadius.circular(20),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color: Colors.orange.shade50,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: Colors.orange.shade200),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 14, color: Colors.orange.shade700),
            const SizedBox(width: 4),
            Text(
              label,
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: Colors.orange.shade900,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildUnitQuantityInput() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
              'الكمية',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: Colors.grey.shade800,
              ),
            ),
            const SizedBox(width: 4),
            Text(
              '(اختياري)',
              style: TextStyle(fontSize: 11, color: Colors.grey.shade500),
            ),
          ],
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
                color: Colors.blue.shade700,
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
        Row(
          children: [
            Text(
              'السعر',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: Colors.grey.shade800,
              ),
            ),
            const SizedBox(width: 4),
            Text(
              '(اختياري)',
              style: TextStyle(fontSize: 11, color: Colors.grey.shade500),
            ),
          ],
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

// شاشة مسح الباركود
class _BarcodeScannerScreen extends StatefulWidget {
  final Function(String) onBarcodeScanned;

  const _BarcodeScannerScreen({required this.onBarcodeScanned});

  @override
  State<_BarcodeScannerScreen> createState() => _BarcodeScannerScreenState();
}

class _BarcodeScannerScreenState extends State<_BarcodeScannerScreen> {
  MobileScannerController cameraController = MobileScannerController();
  bool isScanned = false;
  bool isTorchOn = false;

  @override
  void dispose() {
    cameraController.dispose();
    super.dispose();
  }

  void _onBarcodeDetect(BarcodeCapture capture) {
    if (isScanned) return;

    final List<Barcode> barcodes = capture.barcodes;
    if (barcodes.isNotEmpty) {
      final String? code = barcodes.first.rawValue;
      if (code != null && code.isNotEmpty) {
        setState(() => isScanned = true);
        widget.onBarcodeScanned(code);
        Navigator.pop(context);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: const Text('مسح الباركود'),
        backgroundColor: Colors.green.shade700,
        foregroundColor: Colors.white,
        elevation: 0,
        actions: [
          IconButton(
            icon: Icon(
              isTorchOn ? Icons.flash_on : Icons.flash_off,
              color: isTorchOn ? Colors.yellow : Colors.white,
            ),
            onPressed: () {
              setState(() {
                isTorchOn = !isTorchOn;
              });
              cameraController.toggleTorch();
            },
          ),
          IconButton(
            icon: const Icon(Icons.flip_camera_ios),
            onPressed: () => cameraController.switchCamera(),
          ),
        ],
      ),
      body: Stack(
        children: [
          // الكاميرا
          MobileScanner(
            controller: cameraController,
            onDetect: _onBarcodeDetect,
          ),

          // إطار المسح
          Center(
            child: Container(
              width: 280,
              height: 280,
              decoration: BoxDecoration(
                border: Border.all(color: Colors.green.shade400, width: 3),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Stack(
                children: [
                  // الزوايا
                  Positioned(
                    top: 0,
                    left: 0,
                    child: _buildCorner(Colors.green.shade400),
                  ),
                  Positioned(
                    top: 0,
                    right: 0,
                    child: Transform.rotate(
                      angle: 1.5708,
                      child: _buildCorner(Colors.green.shade400),
                    ),
                  ),
                  Positioned(
                    bottom: 0,
                    left: 0,
                    child: Transform.rotate(
                      angle: -1.5708,
                      child: _buildCorner(Colors.green.shade400),
                    ),
                  ),
                  Positioned(
                    bottom: 0,
                    right: 0,
                    child: Transform.rotate(
                      angle: 3.14159,
                      child: _buildCorner(Colors.green.shade400),
                    ),
                  ),
                ],
              ),
            ),
          ),

          // التعليمات
          Positioned(
            bottom: 100,
            left: 0,
            right: 0,
            child: Center(
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 16,
                ),
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.7),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Text(
                  'وجّه الكاميرا نحو الباركود',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCorner(Color color) {
    return Container(
      width: 30,
      height: 30,
      decoration: BoxDecoration(
        border: Border(
          top: BorderSide(color: color, width: 4),
          left: BorderSide(color: color, width: 4),
        ),
      ),
    );
  }
}
