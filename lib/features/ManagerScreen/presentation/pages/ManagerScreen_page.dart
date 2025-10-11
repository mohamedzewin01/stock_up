import 'dart:convert';
import 'package:barcode_widget/barcode_widget.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:stock_up/features/ManagerScreen/presentation/widgets/confirm_cancel_dialog.dart';
import 'package:stock_up/features/ManagerScreen/presentation/widgets/empty_state_view.dart';
import 'package:stock_up/features/ManagerScreen/presentation/widgets/error_view.dart';
import 'package:stock_up/features/ManagerScreen/presentation/widgets/loading_view.dart';
import 'package:stock_up/features/ManagerScreen/presentation/widgets/pending_inventory_card.dart';

class ManagerScreen extends StatefulWidget {
  const ManagerScreen({super.key});

  @override
  State<ManagerScreen> createState() => _ManagerScreenState();
}

class _ManagerScreenState extends State<ManagerScreen> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      body: SafeArea(
        child: Column(
          children: [
            _buildAppBar(),
            Expanded(
              child: _buildBody(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAppBar() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFFFFB300), Color(0xFFFFA000)],
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          IconButton(
            icon: const Icon(Icons.arrow_back_ios, size: 20),
            onPressed: () => Navigator.pop(context),
            style: IconButton.styleFrom(
              backgroundColor: Colors.white.withOpacity(0.2),
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
          const SizedBox(width: 16),
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'لوحة تحكم المدير',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  'إدارة طلبات الجرد',
                  style: TextStyle(
                    fontSize: 13,
                    color: Colors.white70,
                  ),
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.2),
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(
              Icons.admin_panel_settings,
              color: Colors.white,
              size: 24,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBody() {
    return StreamBuilder<QuerySnapshot>(
      stream: _firestore
          .collection('inventory_updates')
          .where('status', isEqualTo: 'pending')
          .orderBy('timestamp', descending: true)
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const LoadingView();
        }

        if (snapshot.hasError) {
          return ErrorView(message: 'حدث خطأ: ${snapshot.error}');
        }

        final documents = snapshot.data?.docs ?? [];

        if (documents.isEmpty) {
          return const EmptyStateView();
        }

        return ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: documents.length,
          itemBuilder: (context, index) {
            final doc = documents[index];
            final data = doc.data() as Map<String, dynamic>;
            return PendingInventoryCard(
              docId: doc.id,
              data: data,
              onConfirm: () => _confirmUpdate(doc.id, data),
              onCancel: () => _cancelUpdate(doc.id),
            );
          },
        );
      },
    );
  }

  Future<void> _confirmUpdate(String docId, Map<String, dynamic> data) async {
    // Show loading dialog
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => const Center(
        child: Card(
          child: Padding(
            padding: EdgeInsets.all(24),
            child: CircularProgressIndicator(),
          ),
        ),
      ),
    );

    try {
      final url = 'https://artawiya.com/stock_up_DB/api/v1/stocktaking/update_quantity';
      final response = await http.post(
        Uri.parse(url),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'رقم_الصنف': data['product_number'].toString(),
          'اجمالى_الكمية': data['new_quantity'],
        }),
      );

      if (mounted) Navigator.pop(context); // Close loading dialog

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
      if (mounted) Navigator.pop(context); // Close loading dialog
      _showMessage('حدث خطأ: $e', isError: true);
    }
  }

  Future<void> _cancelUpdate(String docId) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => const ConfirmCancelDialog(),
    );

    if (confirm == true) {
      try {
        await _firestore.collection('inventory_updates').doc(docId).delete();
        _showMessage('تم إلغاء العملية', isError: false);
      } catch (e) {
        _showMessage('فشل في الإلغاء: $e', isError: true);
      }
    }
  }

  void _showMessage(String message, {required bool isError}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            Icon(
              isError ? Icons.error_outline : Icons.check_circle_outline,
              color: Colors.white,
            ),
            const SizedBox(width: 12),
            Expanded(child: Text(message)),
          ],
        ),
        backgroundColor: isError ? const Color(0xFFE74C3C) : const Color(0xFF00B894),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
  }
}

