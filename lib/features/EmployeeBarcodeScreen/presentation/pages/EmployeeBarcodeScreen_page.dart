import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:stock_up/features/EmployeeBarcodeScreen/presentation/widgets/info_row.dart';

class EmployeeBarcodeScreen extends StatefulWidget {
  @override
  _EmployeeBarcodeScreenState createState() => _EmployeeBarcodeScreenState();
}

class _EmployeeBarcodeScreenState extends State<EmployeeBarcodeScreen> {
  MobileScannerController cameraController = MobileScannerController();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  bool isScanning = true;
  bool isLoading = false;
  Map<String, dynamic>? productData;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('مسح الباركود'),
        backgroundColor: Theme.of(context).colorScheme.primary,
        foregroundColor: Colors.white,
      ),
      body: Column(
        children: [
          if (isScanning)
            Expanded(
              child: Container(
                margin: const EdgeInsets.all(16),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(16),
                  child: MobileScanner(
                    controller: cameraController,
                    onDetect: (capture) {
                      final List<Barcode> barcodes = capture.barcodes;
                      for (final barcode in barcodes) {
                        if (barcode.rawValue != null) {
                          _onBarcodeDetected(barcode.rawValue!);
                          break;
                        }
                      }
                    },
                  ),
                ),
              ),
            ),
          if (isLoading)
            const Expanded(
              child: Center(child: CircularProgressIndicator()),
            ),
          if (productData != null)
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    Card(
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              productData!['اسم الصنف']?.toString() ?? '',
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const Divider(height: 24),
                            InfoRow(label: 'الكمية',value:  '${productData!['إجمالى الكمية']} ${productData!['الوحدة']}'),
                            InfoRow(label: 'رقم الصنف',value: productData!['رقم الصنف']?.toString() ?? ''),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    SizedBox(
                      width: double.infinity,
                      child: FilledButton(
                        onPressed: () => _showQuantityDialog(productData!),
                        child: const Text('تعديل الكمية'),
                      ),
                    ),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }



  void _onBarcodeDetected(String barcode) async {
    if (!isScanning) return;

    setState(() {
      isScanning = false;
      isLoading = true;
    });

    await cameraController.stop();
    await _fetchProductData(barcode);
  }

  Future<void> _fetchProductData(String search) async {
    try {
      https://artawiya.com/zrranDB/api/v1/stocktaking/search_product?search=6281014472241
      final url = 'https://artawiya.com/stock_up_DB/api/v1/stocktaking/search_product?search=$search';
      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['status'] == 'success' && data['data'] != null && data['data'].isNotEmpty) {
          setState(() {
            productData = data['data'][0];
            isLoading = false;
          });
        }
      }
    } catch (e) {
      _resetScanner();
    }
  }

  void _showQuantityDialog(Map<String, dynamic> product) {
    final TextEditingController quantityController = TextEditingController();
    quantityController.text = product['إجمالى الكمية']?.toString() ?? '0';

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('تعديل الكمية'),
        content: TextField(
          controller: quantityController,
          keyboardType: TextInputType.number,
          decoration: const InputDecoration(labelText: 'الكمية الجديدة'),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('إلغاء'),
          ),
          FilledButton(
            onPressed: () async {
              await _saveToFirebase(product, quantityController.text);
              Navigator.pop(context);
              _resetScanner();
            },
            child: const Text('حفظ'),
          ),
        ],
      ),
    );
  }
  Future<void> _saveToFirebase(Map<String, dynamic> product, String newQuantity) async {
    try {
      final quantity = double.tryParse(newQuantity);
      if (quantity == null) return;

      // هنا بنحول الحقول المهمة للعربية أو الإنجليزية حسب الحاجة
      final Map<String, dynamic> dataToSave = {

        'status': 'pending',
        'timestamp': FieldValue.serverTimestamp(),
        'all_data': product, // لو عايز تحتفظ بالنسخة الكاملة احتياطيًا ممكن تتركه
      };

      await _firestore.collection('inventory_updates').add(dataToSave);

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('تم حفظ التعديل بنجاح'),
          backgroundColor: Colors.green,
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('فشل في حفظ البيانات: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }


  void _resetScanner() {
    setState(() {
      isScanning = true;
      isLoading = false;
      productData = null;
    });
    cameraController.start();
  }

  @override
  void dispose() {
    cameraController.dispose();
    super.dispose();
  }
}