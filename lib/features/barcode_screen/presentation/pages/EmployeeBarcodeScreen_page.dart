import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:mobile_scanner/mobile_scanner.dart';

class BarcodeScreen extends StatefulWidget {
  const BarcodeScreen({super.key});

  @override
  _BarcodeScreenState createState() => _BarcodeScreenState();
}

class _BarcodeScreenState extends State<BarcodeScreen> {
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
                    // عرض صور المنتج
                    if (_hasImages())
                      Card(
                        clipBehavior: Clip.antiAlias,
                        child: Column(
                          children: [
                            SizedBox(
                              height: 200,
                              child: PageView(
                                children: _buildImageWidgets(),
                              ),
                            ),
                            if (_buildImageWidgets().length > 1)
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(
                                  'اسحب لعرض المزيد من الصور',
                                  style: TextStyle(
                                    color: Colors.grey[600],
                                    fontSize: 12,
                                  ),
                                ),
                              ),
                          ],
                        ),
                      ),
                    const SizedBox(height: 16),
                    Card(
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              productData!['product_name']?.toString() ?? '',
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const Divider(height: 24),
                            _buildInfoRow('الكمية', '${productData!['total_quantity']} ${productData!['unit']}'),
                            _buildInfoRow('رقم الصنف', productData!['product_number']?.toString() ?? ''),
                            _buildInfoRow('الفئة', productData!['category']?.toString() ?? ''),
                            _buildInfoRow('سعر البيع', '${productData!['selling_price']} ر.س'),
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

  bool _hasImages() {
    if (productData == null) return false;
    return (productData!['image_front_url'] != null && productData!['image_front_url'].toString().isNotEmpty) ||
        (productData!['image_ingredients_url'] != null && productData!['image_ingredients_url'].toString().isNotEmpty) ||
        (productData!['image_nutrition_url'] != null && productData!['image_nutrition_url'].toString().isNotEmpty);
  }

  List<Widget> _buildImageWidgets() {
    List<Widget> images = [];

    if (productData!['image_front_url'] != null && productData!['image_front_url'].toString().isNotEmpty) {
      images.add(_buildImageWidget(productData!['image_front_url'], 'صورة المنتج'));
    }

    if (productData!['image_ingredients_url'] != null && productData!['image_ingredients_url'].toString().isNotEmpty) {
      images.add(_buildImageWidget(productData!['image_ingredients_url'], 'المكونات'));
    }

    if (productData!['image_nutrition_url'] != null && productData!['image_nutrition_url'].toString().isNotEmpty) {
      images.add(_buildImageWidget(productData!['image_nutrition_url'], 'القيمة الغذائية'));
    }

    if (images.isEmpty) {
      images.add(_buildPlaceholderImage());
    }

    return images;
  }

  Widget _buildImageWidget(String url, String label) {
    return Stack(
      fit: StackFit.expand,
      children: [
        Image.network(
          url,
          fit: BoxFit.contain,
          errorBuilder: (context, error, stackTrace) => _buildPlaceholderImage(),
          loadingBuilder: (context, child, loadingProgress) {
            if (loadingProgress == null) return child;
            return const Center(child: CircularProgressIndicator());
          },
        ),
        Positioned(
          bottom: 0,
          left: 0,
          right: 0,
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.bottomCenter,
                end: Alignment.topCenter,
                colors: [
                  Colors.black.withOpacity(0.7),
                  Colors.transparent,
                ],
              ),
            ),
            child: Text(
              label,
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 14,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildPlaceholderImage() {
    return Container(
      color: Colors.grey[200],
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.image_not_supported, size: 64, color: Colors.grey[400]),
          const SizedBox(height: 8),
          Text(
            'لا توجد صورة متاحة',
            style: TextStyle(color: Colors.grey[600]),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: TextStyle(color: Colors.grey[600])),
          Text(value, style: const TextStyle(fontWeight: FontWeight.w600)),
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
      final url = 'https://artawiya.com/stock_up_DB/api/v1/alrayan/smart_search2?q=$search';
      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['status'] == 'success' && data['results'] != null && data['results'].isNotEmpty) {
          setState(() {
            productData = data['results'][0];
            isLoading = false;
          });
        } else {
          _showError('لم يتم العثور على المنتج');
        }
      } else {
        _showError('فشل في الاتصال بالسيرفر');
      }
    } catch (e) {
      _showError('حدث خطأ: $e');
    }
  }

  void _showError(String message) {
    setState(() {
      isLoading = false;
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
      ),
    );
    _resetScanner();
  }

  void _showQuantityDialog(Map<String, dynamic> product) {
    final TextEditingController quantityController = TextEditingController();
    quantityController.text = product['total_quantity']?.toString() ?? '0';

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
      if (quantity == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('الرجاء إدخال كمية صحيحة'),
            backgroundColor: Colors.red,
          ),
        );
        return;
      }

      final Map<String, dynamic> dataToSave = {
        'product_number': product['product_number'],
        'product_name': product['product_name'],
        'old_quantity': product['total_quantity'],
        'new_quantity': newQuantity,
        'unit': product['unit'],
        'status': 'pending',
        'timestamp': FieldValue.serverTimestamp(),
        'all_data': product,
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