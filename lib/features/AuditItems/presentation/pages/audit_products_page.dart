import 'package:barcode_widget/barcode_widget.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class AuditProductsPage extends StatefulWidget {
  const AuditProductsPage({super.key});

  @override
  State<AuditProductsPage> createState() => _AuditProductsPageState();
}

class _AuditProductsPageState extends State<AuditProductsPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Future<void> _updateProductStatus(String docId, String newStatus) async {
    try {
      await _firestore.collection('inventory_audit').doc(docId).update({
        'status': newStatus,
        'updated_at': DateTime.now().toIso8601String(),
      });

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Row(
              children: [
                Icon(
                  newStatus == 'DONE' ? Icons.check_circle : Icons.cancel,
                  color: Colors.white,
                ),
                const SizedBox(width: 8),
                Text(newStatus == 'DONE' ? 'تم التأكيد' : 'تم الإلغاء'),
              ],
            ),
            backgroundColor: newStatus == 'DONE'
                ? Colors.green.shade600
                : Colors.red.shade600,
            behavior: SnackBarBehavior.floating,
            duration: const Duration(seconds: 2),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('خطأ: ${e.toString()}'),
            backgroundColor: Colors.red.shade600,
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      appBar: AppBar(
        title: const Text(
          'مراجعة الجرد',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
        ),
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.blue.shade700,
        foregroundColor: Colors.white,
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: Colors.white,
          indicatorWeight: 3,
          labelColor: Colors.white,
          unselectedLabelColor: Colors.white70,
          labelStyle: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 14,
          ),
          tabs: const [
            Tab(text: 'قيد المراجعة'),
            Tab(text: 'المكتمل'),
            Tab(text: 'الملغي'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          // Pending Products
          PendingProductsView(onUpdateStatus: _updateProductStatus),

          // Done Products
          CompletedProductsView(
            status: 'DONE',
            onUpdateStatus: _updateProductStatus,
          ),

          // Cancelled Products
          CompletedProductsView(
            status: 'CANCEL',
            onUpdateStatus: _updateProductStatus,
          ),
        ],
      ),
    );
  }
}

// ============================================
// Pending Products View (Bidirectional Scroll)
// ============================================
class PendingProductsView extends StatelessWidget {
  final Function(String docId, String status) onUpdateStatus;

  const PendingProductsView({super.key, required this.onUpdateStatus});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection('inventory_audit')
          .where('status', isEqualTo: 'pending')
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        if (snapshot.hasError) {
          return ErrorView(message: 'حدث خطأ: ${snapshot.error}');
        }

        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
          return const EmptyStateView(
            icon: Icons.inbox_outlined,
            message: 'لا توجد منتجات قيد المراجعة',
          );
        }

        final products = snapshot.data!.docs;

        // ترتيب: الأقدم أولاً (ما دخل أولاً يعرض أولاً)
        products.sort((a, b) {
          final aTime =
              (a.data() as Map<String, dynamic>)['timestamp'] as Timestamp?;
          final bTime =
              (b.data() as Map<String, dynamic>)['timestamp'] as Timestamp?;
          if (aTime == null || bTime == null) return 0;
          return aTime.compareTo(bTime); // ترتيب تصاعدي (الأقدم أولاً)
        });

        return PageView.builder(
          scrollDirection: Axis.vertical,
          itemCount: products.length,
          itemBuilder: (context, index) {
            final doc = products[index];
            final data = doc.data() as Map<String, dynamic>;

            return CompactProductCard(
              docId: doc.id,
              productData: data,
              onConfirm: () => onUpdateStatus(doc.id, 'DONE'),
              onCancel: () => onUpdateStatus(doc.id, 'CANCEL'),
              currentIndex: index + 1,
              totalCount: products.length,
            );
          },
        );
      },
    );
  }
}

// ============================================
// Compact Product Card (Smaller Design)
// ============================================
class CompactProductCard extends StatelessWidget {
  final String docId;
  final Map<String, dynamic> productData;
  final VoidCallback onConfirm;
  final VoidCallback onCancel;
  final int currentIndex;
  final int totalCount;

  const CompactProductCard({
    super.key,
    required this.docId,
    required this.productData,
    required this.onConfirm,
    required this.onCancel,
    required this.currentIndex,
    required this.totalCount,
  });

  int _parseToInt(dynamic value) {
    if (value == null) return 0;
    if (value is int) return value;
    if (value is double) return value.toInt();
    if (value is String) return int.tryParse(value) ?? 0;
    return 0;
  }

  double _parseToDouble(dynamic value) {
    if (value == null) return 0.0;
    if (value is double) return value;
    if (value is int) return value.toDouble();
    if (value is String) return double.tryParse(value) ?? 0.0;
    return 0.0;
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    final String userName = productData['userName'] ?? 'غير معروف';
    final String productName = productData['product_name'] ?? 'غير معروف';
    final int currentQuantity = _parseToInt(productData['quantity']);
    final int previousQuantity = _parseToInt(productData['total_quantity']);
    final String unit = productData['unit'] ?? '';
    final double price = _parseToDouble(productData['selling_price']);
    final String category = productData['category_name'] ?? 'غير محدد';
    final String? notes = productData['notes'];
    final List<dynamic>? barcodes = productData['barcodes'];
    final String barcode = (barcodes != null && barcodes.isNotEmpty)
        ? barcodes.first.toString()
        : '';

    return Container(
      width: screenWidth,
      height: screenHeight,
      padding: EdgeInsets.symmetric(
        horizontal: screenWidth * 0.04,
        vertical: screenHeight * 0.02,
      ),
      child: SingleChildScrollView(
        child: Column(
          children: [
            // Counter Badge
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: Colors.blue.shade100,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                '$currentIndex من $totalCount',
                style: TextStyle(
                  color: Colors.blue.shade800,
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),

            SizedBox(height: screenHeight * 0.01),

            // User Badge
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Colors.blue.shade500, Colors.blue.shade700],
                ),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.person, color: Colors.white, size: 16),
                  const SizedBox(width: 6),
                  Text(
                    userName,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 13,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),

            SizedBox(height: screenHeight * 0.015),

            // Main Card
            Container(
              width: double.infinity,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.shade300,
                    blurRadius: 10,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              child: Column(
                children: [
                  // Product Header
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          Colors.purple.shade400,
                          Colors.purple.shade600,
                        ],
                      ),
                      borderRadius: const BorderRadius.vertical(
                        top: Radius.circular(16),
                      ),
                    ),
                    child: Column(
                      children: [
                        const Icon(
                          Icons.inventory_2_rounded,
                          color: Colors.white,
                          size: 32,
                        ),
                        const SizedBox(height: 6),
                        Text(
                          productName,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                          textAlign: TextAlign.center,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),

                  Padding(
                    padding: const EdgeInsets.all(12),
                    child: Column(
                      children: [
                        // Quantity Comparison
                        CompactQuantityWidget(
                          previousQuantity: previousQuantity,
                          currentQuantity: currentQuantity,
                          unit: unit,
                        ),

                        const SizedBox(height: 12),

                        // Details
                        Row(
                          children: [
                            Expanded(
                              child: CompactDetailItem(
                                icon: Icons.attach_money,
                                label: 'السعر',
                                value: '$price ر.س',
                                color: Colors.green,
                              ),
                            ),
                            Container(
                              width: 1,
                              height: 40,
                              color: Colors.grey.shade300,
                            ),
                            Expanded(
                              child: CompactDetailItem(
                                icon: Icons.category,
                                label: 'القسم',
                                value: category,
                                color: Colors.blue,
                              ),
                            ),
                          ],
                        ),

                        if (notes != null && notes.isNotEmpty) ...[
                          const SizedBox(height: 12),
                          CompactNotesWidget(notes: notes),
                        ],

                        const SizedBox(height: 12),

                        // Barcode
                        if (barcode.isNotEmpty)
                          CompactBarcodeWidget(barcode: barcode),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            SizedBox(height: screenHeight * 0.015),

            // Action Buttons
            Row(
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: onCancel,
                    icon: const Icon(Icons.close, size: 18),
                    label: const Text(
                      'إلغاء',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red.shade600,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: onConfirm,
                    icon: const Icon(Icons.check, size: 18),
                    label: const Text(
                      'تأكيد',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green.shade600,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                ),
              ],
            ),

            SizedBox(height: screenHeight * 0.01),

            // Scroll Hint
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: Colors.grey.shade300,
                borderRadius: BorderRadius.circular(15),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.swipe_vertical,
                    color: Colors.grey.shade600,
                    size: 16,
                  ),
                  const SizedBox(width: 6),
                  Text(
                    'اسحب للأعلى أو الأسفل',
                    style: TextStyle(color: Colors.grey.shade700, fontSize: 11),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ============================================
// Compact Quantity Widget
// ============================================
class CompactQuantityWidget extends StatelessWidget {
  final int previousQuantity;
  final int currentQuantity;
  final String unit;

  const CompactQuantityWidget({
    super.key,
    required this.previousQuantity,
    required this.currentQuantity,
    required this.unit,
  });

  @override
  Widget build(BuildContext context) {
    final difference = currentQuantity - previousQuantity;
    final isIncrease = difference >= 0;

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: isIncrease
              ? [Colors.green.shade50, Colors.green.shade100]
              : [Colors.orange.shade50, Colors.orange.shade100],
        ),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isIncrease ? Colors.green.shade300 : Colors.orange.shade300,
          width: 1.5,
        ),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              children: [
                Text(
                  'السابقة',
                  style: TextStyle(fontSize: 11, color: Colors.grey.shade700),
                ),
                const SizedBox(height: 4),
                Text(
                  '$previousQuantity',
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
                Text(
                  unit,
                  style: TextStyle(fontSize: 10, color: Colors.grey.shade600),
                ),
              ],
            ),
          ),

          Icon(
            Icons.arrow_forward,
            color: isIncrease ? Colors.green.shade700 : Colors.orange.shade700,
            size: 20,
          ),

          Expanded(
            child: Column(
              children: [
                Text(
                  'الحالية',
                  style: TextStyle(fontSize: 11, color: Colors.grey.shade700),
                ),
                const SizedBox(height: 4),
                Text(
                  '$currentQuantity',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: isIncrease
                        ? Colors.green.shade700
                        : Colors.orange.shade700,
                  ),
                ),
                Text(
                  unit,
                  style: TextStyle(fontSize: 10, color: Colors.grey.shade600),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ============================================
// Compact Detail Item
// ============================================
class CompactDetailItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final Color color;

  const CompactDetailItem({
    super.key,
    required this.icon,
    required this.label,
    required this.value,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Icon(icon, color: color, size: 20),
        const SizedBox(height: 4),
        Text(
          label,
          style: TextStyle(fontSize: 10, color: Colors.grey.shade600),
        ),
        const SizedBox(height: 2),
        Text(
          value,
          style: const TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
          textAlign: TextAlign.center,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
      ],
    );
  }
}

// ============================================
// Compact Notes Widget
// ============================================
class CompactNotesWidget extends StatelessWidget {
  final String notes;

  const CompactNotesWidget({super.key, required this.notes});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Colors.amber.shade50,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Colors.amber.shade300),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(Icons.note_alt, color: Colors.amber.shade700, size: 16),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              notes,
              style: TextStyle(
                fontSize: 12,
                color: Colors.grey.shade800,
                height: 1.4,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ============================================
// Compact Barcode Widget
// ============================================
class CompactBarcodeWidget extends StatelessWidget {
  final String barcode;

  const CompactBarcodeWidget({super.key, required this.barcode});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.grey.shade50,
              borderRadius: BorderRadius.circular(8),
            ),
            child: BarcodeWidget(
              barcode: Barcode.code128(),
              data: barcode,
              width: 200,
              height: 50,
              drawText: false,
            ),
          ),
          const SizedBox(height: 6),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(
              color: Colors.grey.shade800,
              borderRadius: BorderRadius.circular(6),
            ),
            child: Text(
              barcode,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 12,
                fontWeight: FontWeight.bold,
                letterSpacing: 1,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ============================================
// Completed Products View (Full Details)
// ============================================
class CompletedProductsView extends StatelessWidget {
  final String status;
  final Function(String docId, String status) onUpdateStatus;

  const CompletedProductsView({
    super.key,
    required this.status,
    required this.onUpdateStatus,
  });

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection('inventory_audit')
          .where('status', isEqualTo: status)
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        if (snapshot.hasError) {
          return ErrorView(message: 'حدث خطأ: ${snapshot.error}');
        }

        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
          return EmptyStateView(
            icon: status == 'DONE'
                ? Icons.check_circle_outline
                : Icons.cancel_outlined,
            message: status == 'DONE'
                ? 'لا توجد منتجات مكتملة'
                : 'لا توجد منتجات ملغية',
          );
        }

        final products = snapshot.data!.docs;

        // ترتيب: الأحدث أولاً
        products.sort((a, b) {
          final aTime =
              (a.data() as Map<String, dynamic>)['timestamp'] as Timestamp?;
          final bTime =
              (b.data() as Map<String, dynamic>)['timestamp'] as Timestamp?;
          if (aTime == null || bTime == null) return 0;
          return bTime.compareTo(aTime); // ترتيب تنازلي (الأحدث أولاً)
        });

        return ListView.builder(
          padding: const EdgeInsets.all(12),
          itemCount: products.length,
          itemBuilder: (context, index) {
            final doc = products[index];
            final data = doc.data() as Map<String, dynamic>;

            return FullDetailsCard(productData: data, status: status);
          },
        );
      },
    );
  }
}

// ============================================
// Full Details Card (For Done/Cancel)
// ============================================
class FullDetailsCard extends StatelessWidget {
  final Map<String, dynamic> productData;
  final String status;

  const FullDetailsCard({
    super.key,
    required this.productData,
    required this.status,
  });

  int _parseToInt(dynamic value) {
    if (value == null) return 0;
    if (value is int) return value;
    if (value is double) return value.toInt();
    if (value is String) return int.tryParse(value) ?? 0;
    return 0;
  }

  double _parseToDouble(dynamic value) {
    if (value == null) return 0.0;
    if (value is double) return value;
    if (value is int) return value.toDouble();
    if (value is String) return double.tryParse(value) ?? 0.0;
    return 0.0;
  }

  @override
  Widget build(BuildContext context) {
    final String userName = productData['userName'] ?? 'غير معروف';
    final String productName = productData['product_name'] ?? 'غير معروف';
    final int currentQuantity = _parseToInt(productData['quantity']);
    final int previousQuantity = _parseToInt(productData['total_quantity']);
    final String unit = productData['unit'] ?? '';
    final double price = _parseToDouble(productData['selling_price']);
    final String category = productData['category_name'] ?? 'غير محدد';
    final String? notes = productData['notes'];
    final List<dynamic>? barcodes = productData['barcodes'];
    final String barcode = (barcodes != null && barcodes.isNotEmpty)
        ? barcodes.first.toString()
        : '';

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: status == 'DONE' ? Colors.green.shade300 : Colors.red.shade300,
          width: 2,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.shade200,
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          // Header
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: status == 'DONE'
                  ? Colors.green.shade50
                  : Colors.red.shade50,
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(10),
              ),
            ),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: status == 'DONE'
                        ? Colors.green.shade100
                        : Colors.red.shade100,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(
                    status == 'DONE' ? Icons.check_circle : Icons.cancel,
                    color: status == 'DONE'
                        ? Colors.green.shade700
                        : Colors.red.shade700,
                    size: 24,
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        productName,
                        style: const TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 2),
                      Text(
                        'بواسطة: $userName',
                        style: TextStyle(
                          fontSize: 11,
                          color: Colors.grey.shade600,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              children: [
                // Quantities
                Row(
                  children: [
                    Expanded(
                      child: _InfoBox(
                        label: 'السابقة',
                        value: '$previousQuantity $unit',
                        color: Colors.grey,
                      ),
                    ),
                    const SizedBox(width: 8),
                    const Icon(Icons.arrow_forward, size: 20),
                    const SizedBox(width: 8),
                    Expanded(
                      child: _InfoBox(
                        label: 'الحالية',
                        value: '$currentQuantity $unit',
                        color: status == 'DONE' ? Colors.green : Colors.orange,
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 10),

                // Details
                Row(
                  children: [
                    Expanded(
                      child: _InfoBox(
                        label: 'السعر',
                        value: '$price ر.س',
                        color: Colors.blue,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: _InfoBox(
                        label: 'القسم',
                        value: category,
                        color: Colors.purple,
                      ),
                    ),
                  ],
                ),

                if (notes != null && notes.isNotEmpty) ...[
                  const SizedBox(height: 10),
                  CompactNotesWidget(notes: notes),
                ],

                if (barcode.isNotEmpty) ...[
                  const SizedBox(height: 10),
                  CompactBarcodeWidget(barcode: barcode),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ============================================
// Info Box Widget
// ============================================
class _InfoBox extends StatelessWidget {
  final String label;
  final String value;
  final Color color;

  const _InfoBox({
    required this.label,
    required this.value,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Column(
        children: [
          Text(
            label,
            style: TextStyle(fontSize: 10, color: Colors.grey.shade700),
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.bold,
              color: color,
            ),
            textAlign: TextAlign.center,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}

// ============================================
// Empty State View
// ============================================
class EmptyStateView extends StatelessWidget {
  final IconData icon;
  final String message;

  const EmptyStateView({super.key, required this.icon, required this.message});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: 80, color: Colors.grey.shade400),
          const SizedBox(height: 12),
          Text(
            message,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.grey.shade600,
            ),
          ),
        ],
      ),
    );
  }
}

// ============================================
// Error View
// ============================================
class ErrorView extends StatelessWidget {
  final String message;

  const ErrorView({super.key, required this.message});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.error_outline, size: 60, color: Colors.red.shade400),
          const SizedBox(height: 12),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Text(
              message,
              style: TextStyle(fontSize: 14, color: Colors.grey.shade700),
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
    );
  }
}
