import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final TextEditingController _searchController = TextEditingController();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  List<Map<String, dynamic>> searchResults = [];
  bool isLoading = false;
  String? errorMessage;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('البحث عن المنتجات'),
        backgroundColor: Theme.of(context).colorScheme.primary,
        foregroundColor: Colors.white,
      ),
      body: Column(
        children: [
          Container(
            margin: const EdgeInsets.all(16),
            child: Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: TextField(
                  controller: _searchController,
                  decoration: const InputDecoration(
                    labelText: 'ابحث عن المنتج',
                    hintText: 'اسم المنتج أو الباركود',
                    prefixIcon: Icon(Icons.search),
                  ),
                  onChanged: (value) {
                    if (value.length >= 2) {
                      _searchProducts(value);
                    } else if (value.isEmpty) {
                      setState(() {
                        searchResults.clear();
                        errorMessage = null;
                      });
                    }
                  },
                ),
              ),
            ),
          ),
          if (errorMessage != null)
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 16),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.red[50],
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                children: [
                  Icon(Icons.error_outline, color: Colors.red[700]),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      errorMessage!,
                      style: TextStyle(color: Colors.red[800]),
                    ),
                  ),
                ],
              ),
            ),
          if (isLoading)
            const Padding(
              padding: EdgeInsets.all(20),
              child: CircularProgressIndicator(),
            ),
          if (searchResults.isNotEmpty)
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: searchResults.length,
                itemBuilder: (context, index) {
                  return _buildProductCard(searchResults[index]);
                },
              ),
            ),
          if (searchResults.isEmpty && !isLoading && _searchController.text.isEmpty)
            Expanded(
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.search, size: 80, color: Colors.grey[300]),
                    const SizedBox(height: 16),
                    Text(
                      'ابدأ البحث عن المنتجات',
                      style: TextStyle(fontSize: 18, color: Colors.grey[600]),
                    ),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }

  Future<void> _searchProducts(String query) async {
    setState(() {
      isLoading = true;
      errorMessage = null;
    });

    try {
      final url = 'https://artawiya.com/stock_up_DB/api/v1/alrayan/smart_search2?q=${Uri.encodeComponent(query)}';
      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['status'] == 'success' && data['results'] != null) {
          setState(() {
            searchResults = List<Map<String, dynamic>>.from(data['results']);
            isLoading = false;
          });
        } else {
          setState(() {
            searchResults = [];
            errorMessage = 'لم يتم العثور على نتائج';
            isLoading = false;
          });
        }
      }
    } catch (e) {
      setState(() {
        errorMessage = 'تعذر الاتصال بالإنترنت';
        isLoading = false;
      });
    }
  }

  Widget _buildProductCard(Map<String, dynamic> product) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: InkWell(
        onTap: () => _showQuantityDialog(product),
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                product['product_name']?.toString() ?? 'غير محدد',
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('الكمية: ${product['total_quantity']} ${product['unit']}'),
                  Text('رقم الصنف: ${product['barcodes']}'),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showQuantityDialog(Map<String, dynamic> product) {
    final TextEditingController quantityController = TextEditingController();
    quantityController.text = product['total_quantity']?.toString() ?? '0';

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('تعديل الكمية'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(product['اسم الصنف']?.toString() ?? ''),
            const SizedBox(height: 16),
            TextField(
              controller: quantityController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: 'الكمية الجديدة',
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('إلغاء'),
          ),
          FilledButton(
            onPressed: () {
              _saveToFirebase(product, quantityController.text);
              Navigator.pop(context);
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
        _showMessage('يرجى إدخال كمية صحيحة', isError: true);
        return;
      }


      await _firestore.collection('inventory_updates').add({
        'product_id': product['رقم الصنف'],
        'product_name': product['product_name'],
        'old_quantity': product['إجمالى الكمية'],
        'new_quantity': quantity,
        'unit': product['الوحدة'],
        'category': product['category'],
        'barcode': product['barcodes'],
        'status': 'pending',
        'timestamp': FieldValue.serverTimestamp(),
        'all_data': product,
      });

      _showMessage('تم حفظ التعديل بنجاح', isError: false);
    } catch (e) {
      _showMessage('فشل في حفظ البيانات: $e', isError: true);
    }
  }

  void _showMessage(String message, {required bool isError}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: isError ? Colors.red : Colors.green,
      ),
    );
  }
}