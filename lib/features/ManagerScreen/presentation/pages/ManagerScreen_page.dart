import 'dart:convert';

import 'package:barcode_widget/barcode_widget.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class ManagerScreen extends StatefulWidget {
  @override
  _ManagerScreenState createState() => _ManagerScreenState();
}

class _ManagerScreenState extends State<ManagerScreen> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('لوحة تحكم المدير'),
        backgroundColor: Colors.amber[700],
        foregroundColor: Colors.white,
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: _firestore
            .collection('inventory_updates')
            .where('status', isEqualTo: 'pending')
            .orderBy('timestamp', descending: true)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(
              child: Text('حدث خطأ: ${snapshot.error}'),
            );
          }

          final documents = snapshot.data?.docs ?? [];

          if (documents.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.check_circle, size: 80, color: Colors.green[300]),
                  const SizedBox(height: 16),
                  const Text(
                    'لا توجد عمليات جرد معلقة',
                    style: TextStyle(fontSize: 18),
                  ),
                ],
              ),
            );
          }

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: documents.length,
            itemBuilder: (context, index) {
              final doc = documents[index];
              final data = doc.data() as Map<String, dynamic>;
              return _buildPendingCard(doc.id, data);
            },
          );
        },
      ),
    );
  }

  Widget _buildPendingCard(String docId, Map<String, dynamic> data) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              data['product_name'] ?? 'غير محدد',
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text('رقم الصنف: ${data['product_id']}'),
            Text('التصنيف: ${data['category']}'),
            const Divider(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Column(
                  children: [
                    const Text('الكمية السابقة'),
                    Text(
                      '${data['old_quantity']}',
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.red,
                      ),
                    ),
                  ],
                ),
                const Icon(Icons.arrow_forward),
                Column(
                  children: [
                    const Text('الكمية الجديدة'),
                    Text(
                      '${data['new_quantity']}',
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.green,
                      ),
                    ),
                  ],
                ),
              ],
            ),
            if (data['all_data']?['باركود'] != null &&
                data['all_data']!['باركود'].toString().isNotEmpty) ...[
              const Divider(height: 24),
              const Text('الباركود:', style: TextStyle(fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              BarcodeWidget(
                barcode: Barcode.code128(),
                data: data['all_data']!['باركود'].toString(),
                height: 80,
                drawText: true,
              ),
            ],

            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () => _cancelUpdate(docId),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: Colors.red,
                    ),
                    child: const Text('إلغاء'),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: FilledButton(
                    onPressed: () => _confirmUpdate(docId, data),
                    style: FilledButton.styleFrom(
                      backgroundColor: Colors.green,
                    ),
                    child: const Text('تأكيد الجرد'),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _confirmUpdate(String docId, Map<String, dynamic> data) async {
    try {
      final url = 'https://artawiya.com/stock_up_DB/api/v1/stocktaking/update_quantity';
      final response = await http.post(
        Uri.parse(url),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'رقم_الصنف': data['product_id'].toString(),
          'اجمالى_الكمية': data['new_quantity'],
        }),
      );

      if (response.statusCode == 200) {
        await _firestore.collection('inventory_updates').doc(docId).update({
          'status': 'confirmed',
          'confirmed_at': FieldValue.serverTimestamp(),
        });

        _showMessage('تم تأكيد الجرد بنجاح', isError: false);
      } else {
        _showMessage('فشل تحديث الكمية', isError: true);
      }
    } catch (e) {
      _showMessage('حدث خطأ: $e', isError: true);
    }
  }

  Future<void> _cancelUpdate(String docId) async {
    try {
      await _firestore.collection('inventory_updates').doc(docId).delete();
      _showMessage('تم إلغاء العملية', isError: false);
    } catch (e) {
      _showMessage('فشل في الإلغاء: $e', isError: true);
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