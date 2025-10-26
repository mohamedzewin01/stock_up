import 'package:barcode_widget/barcode_widget.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:stock_up/core/di/di.dart';
import 'package:stock_up/core/utils/cashed_data_shared_preferences.dart';
import 'package:stock_up/features/AuditItems/presentation/bloc/update_inventory_items_status/update_items_status_cubit.dart';

class AuditProductsPage extends StatefulWidget {
  const AuditProductsPage({super.key});

  @override
  State<AuditProductsPage> createState() => _AuditProductsPageState();
}

class _AuditProductsPageState extends State<AuditProductsPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  late UpdateItemsStatusCubit _updateStatusCubit;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  late int storeId;
  final Map<String, String> _docIdMap = {};

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _updateStatusCubit = getIt.get<UpdateItemsStatusCubit>();

    storeId = CacheService.getData(key: CacheKeys.storeId) ?? 0;

    if (storeId == 0) {
      debugPrint('⚠️ Warning: storeId is 0 or null!');
    }
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Future<void> _updateProductStatus(
    String docId, // ✅ استقبال docId مباشرة
    String newStatus,
    int auditId,
    int itemId,
  ) async {
    try {
      // ✅ حفظ docId في Map
      final key = '${auditId}_$itemId';
      _docIdMap[key] = docId;

      debugPrint('🔍 Saving docId: $docId for key: $key');

      _updateStatusCubit.updateInventoryItemsStatus(
        auditId: auditId,
        itemId: itemId,
        status: newStatus,
      );
    } catch (e) {
      debugPrint('❌ Error: $e');
    }
  }

  Future<void> _updateFirebaseStatus(
    String docId,
    String newStatus,
    int storeId,
  ) async {
    try {
      await _firestore.collection('inventory_audit').doc(docId).update({
        'status': newStatus,
        'store_id': storeId,
        'updated_at': DateTime.now().toIso8601String(),
      });
    } catch (e) {
      debugPrint('Error updating Firebase: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: _updateStatusCubit,
      child: Scaffold(
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
        body: BlocListener<UpdateItemsStatusCubit, UpdateItemsStatusState>(
          listener: (context, state) async {
            if (state is UpdateItemsStatusLoaded) {
              final auditId = state.data?.auditId;
              final itemId = state.data?.itemId;
              final newStatus = state.data?.newStatus ?? '';

              // ✅ الحصول على docId من Map
              final key = '${auditId}_$itemId';
              final docId = _docIdMap[key];

              if (docId == null || docId.isEmpty) {
                debugPrint('⚠️ Warning: docId not found for key: $key');
                return;
              }

              debugPrint('✅ Found docId: $docId for key: $key');

              String firebaseStatus;
              if (newStatus == 'done') {
                firebaseStatus = 'DONE';
              } else if (newStatus == 'pending') {
                firebaseStatus = 'CANCEL';
              } else {
                firebaseStatus = newStatus.toUpperCase();
              }

              try {
                // ✅ تحديث مباشر بدون Query
                await _firestore
                    .collection('inventory_audit')
                    .doc(docId)
                    .update({
                      'status': firebaseStatus,
                      'store_id': storeId,
                      'updated_at': DateTime.now().toIso8601String(),
                    });

                debugPrint('✅ Firebase updated successfully for docId: $docId');

                // ✅ حذف من Map بعد الاستخدام
                _docIdMap.remove(key);

                if (context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Row(
                        children: [
                          Icon(
                            newStatus == 'done'
                                ? Icons.check_circle
                                : Icons.cancel,
                            color: Colors.white,
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              state.data?.message ?? 'تم التحديث بنجاح',
                            ),
                          ),
                        ],
                      ),
                      backgroundColor: newStatus == 'done'
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
                debugPrint('❌ Error updating Firebase: $e');
                if (context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('خطأ في Firebase: ${e.toString()}'),
                      backgroundColor: Colors.orange.shade600,
                      behavior: SnackBarBehavior.floating,
                    ),
                  );
                }
              }
            }
          },
          child: TabBarView(
            controller: _tabController,
            children: [
              PendingProductsView(
                onUpdateStatus: _updateProductStatus,
                storeId: storeId,
              ),
              CompletedProductsView(
                status: 'DONE',
                onUpdateStatus: _updateProductStatus,
                storeId: storeId,
              ),
              CancelledProductsView(
                onUpdateStatus: _updateProductStatus,
                storeId: storeId,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ============================================
// Pending Products View - سكرول محسّن
// ============================================
class PendingProductsView extends StatefulWidget {
  final Function(String docId, String status, int auditId, int itemId)
  onUpdateStatus;
  final int storeId;

  const PendingProductsView({
    super.key,
    required this.onUpdateStatus,
    required this.storeId,
  });

  @override
  State<PendingProductsView> createState() => _PendingProductsViewState();
}

class _PendingProductsViewState extends State<PendingProductsView> {
  final ScrollController _scrollController = ScrollController();
  final Set<String> _processingIds = {}; // لتتبع المنتجات قيد المعالجة

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  Future<bool> _showConfirmDialog({
    required String title,
    required String message,
    required Color color,
    required IconData icon,
  }) async {
    return await showDialog<bool>(
          context: context,
          barrierDismissible: false,
          builder: (BuildContext context) {
            return AlertDialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              title: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: color.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Icon(icon, color: color, size: 28),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      title,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
              content: Text(
                message,
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey.shade700,
                  height: 1.4,
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.of(context).pop(false),
                  child: Text(
                    'رجوع',
                    style: TextStyle(
                      color: Colors.grey.shade600,
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                ElevatedButton(
                  onPressed: () => Navigator.of(context).pop(true),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: color,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 24,
                      vertical: 12,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text(
                    'تأكيد',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            );
          },
        ) ??
        false;
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection('inventory_audit')
          .where('status', isEqualTo: 'pending')
          .where('store_id', isEqualTo: widget.storeId)
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

        products.sort((a, b) {
          final aTime =
              (a.data() as Map<String, dynamic>)['timestamp'] as Timestamp?;
          final bTime =
              (b.data() as Map<String, dynamic>)['timestamp'] as Timestamp?;
          if (aTime == null || bTime == null) return 0;
          return aTime.compareTo(bTime);
        });

        return ListView.builder(
          controller: _scrollController,
          physics: const BouncingScrollPhysics(),
          // سكرول سلس
          padding: const EdgeInsets.symmetric(vertical: 8),
          itemCount: products.length,
          itemBuilder: (context, index) {
            final doc = products[index];
            final data = doc.data() as Map<String, dynamic>;
            final isProcessing = _processingIds.contains(doc.id);

            return CompactProductCard(
              docId: doc.id,
              productData: data,
              isProcessing: isProcessing,
              onConfirm: () async {
                // منع التنفيذ إذا كان قيد المعالجة
                if (isProcessing) return;

                final confirmed = await _showConfirmDialog(
                  title: 'تأكيد المنتج',
                  message: 'هل أنت متأكد من تأكيد هذا المنتج؟',
                  color: Colors.green.shade600,
                  icon: Icons.check_circle,
                );

                if (confirmed && mounted) {
                  setState(() {
                    _processingIds.add(doc.id);
                  });

                  final auditId = data['audit_id'] as int? ?? 0;
                  final itemId = data['product_id'] as int? ?? 0;
                  widget.onUpdateStatus(doc.id, 'done', auditId, itemId);

                  // إزالة من قائمة المعالجة بعد 2 ثانية
                  Future.delayed(const Duration(seconds: 2), () {
                    if (mounted) {
                      setState(() {
                        _processingIds.remove(doc.id);
                      });
                    }
                  });
                }
              },
              onCancel: () async {
                // منع التنفيذ إذا كان قيد المعالجة
                if (isProcessing) return;

                final confirmed = await _showConfirmDialog(
                  title: 'إلغاء المنتج',
                  message: 'هل أنت متأكد من إلغاء هذا المنتج؟',
                  color: Colors.red.shade600,
                  icon: Icons.cancel,
                );

                if (confirmed && mounted) {
                  setState(() {
                    _processingIds.add(doc.id);
                  });

                  final auditId = data['audit_id'] as int? ?? 0;
                  final itemId = data['product_id'] as int? ?? 0;
                  widget.onUpdateStatus(doc.id, 'pending', auditId, itemId);

                  // إزالة من قائمة المعالجة بعد 2 ثانية
                  Future.delayed(const Duration(seconds: 2), () {
                    if (mounted) {
                      setState(() {
                        _processingIds.remove(doc.id);
                      });
                    }
                  });
                }
              },
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
// Compact Product Card - محدّث
// ============================================
class CompactProductCard extends StatelessWidget {
  final String docId;
  final Map<String, dynamic> productData;
  final VoidCallback onConfirm;
  final VoidCallback onCancel;
  final int currentIndex;
  final int totalCount;
  final bool isProcessing;

  const CompactProductCard({
    super.key,
    required this.docId,
    required this.productData,
    required this.onConfirm,
    required this.onCancel,
    required this.currentIndex,
    required this.totalCount,
    this.isProcessing = false,
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
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
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
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
              color: Colors.blue.shade100,
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(16),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '$currentIndex من $totalCount',
                  style: TextStyle(
                    color: Colors.blue.shade800,
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [Colors.blue.shade500, Colors.blue.shade700],
                    ),
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(Icons.person, color: Colors.white, size: 14),
                      const SizedBox(width: 4),
                      Text(
                        userName,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 11,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [Colors.purple.shade400, Colors.purple.shade600],
                    ),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    children: [
                      const Icon(
                        Icons.inventory_2_rounded,
                        color: Colors.white,
                        size: 24,
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          productName,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                CompactQuantityWidget(
                  previousQuantity: previousQuantity,
                  currentQuantity: currentQuantity,
                  unit: unit,
                ),
                const SizedBox(height: 12),
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
                if (barcode.isNotEmpty) ...[
                  const SizedBox(height: 12),
                  CompactBarcodeWidget(barcode: barcode),
                ],
                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      child: ElevatedButton.icon(
                        onPressed: isProcessing ? null : onCancel,
                        icon: isProcessing
                            ? const SizedBox(
                                width: 16,
                                height: 16,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  valueColor: AlwaysStoppedAnimation<Color>(
                                    Colors.white,
                                  ),
                                ),
                              )
                            : const Icon(Icons.close, size: 18),
                        label: Text(
                          isProcessing ? 'جاري المعالجة...' : 'إلغاء',
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: isProcessing
                              ? Colors.grey.shade400
                              : Colors.red.shade600,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          disabledBackgroundColor: Colors.grey.shade400,
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: ElevatedButton.icon(
                        onPressed: isProcessing ? null : onConfirm,
                        icon: isProcessing
                            ? const SizedBox(
                                width: 16,
                                height: 16,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  valueColor: AlwaysStoppedAnimation<Color>(
                                    Colors.white,
                                  ),
                                ),
                              )
                            : const Icon(Icons.check, size: 18),
                        label: Text(
                          isProcessing ? 'جاري المعالجة...' : 'تأكيد',
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: isProcessing
                              ? Colors.grey.shade400
                              : Colors.green.shade600,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          disabledBackgroundColor: Colors.grey.shade400,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// باقي الـ Widgets (CompactQuantityWidget, CompactDetailItem, إلخ) تبقى كما هي
// سأضع فقط الـ widgets المهمة

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

class CompactBarcodeWidget extends StatelessWidget {
  final String barcode;

  const CompactBarcodeWidget({super.key, required this.barcode});

  Barcode _getBarcodeType(String barcode) {
    final cleanBarcode = barcode.replaceAll(RegExp(r'[^0-9]'), '');

    if (cleanBarcode.length == 13) {
      return Barcode.ean13();
    } else if (cleanBarcode.length == 8) {
      return Barcode.ean8();
    } else if (cleanBarcode.length == 12) {
      return Barcode.upcA();
    } else {
      return Barcode.code128();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Colors.grey.shade300, width: 2),
      ),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(8),
            ),
            child: BarcodeWidget(
              barcode: _getBarcodeType(barcode),
              data: barcode,
              width: 280,
              height: 80,
              drawText: true,
              textPadding: 2,
              style: const TextStyle(fontSize: 14),
            ),
          ),
          const SizedBox(height: 8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: Colors.grey.shade800,
              borderRadius: BorderRadius.circular(6),
            ),
            child: Text(
              barcode,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 13,
                fontWeight: FontWeight.bold,
                letterSpacing: 1.5,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// Cancelled Products View - نفس التحديثات
class CancelledProductsView extends StatefulWidget {
  final Function(String docId, String status, int auditId, int itemId)
  onUpdateStatus;
  final int storeId;

  const CancelledProductsView({
    super.key,
    required this.onUpdateStatus,
    required this.storeId,
  });

  @override
  State<CancelledProductsView> createState() => _CancelledProductsViewState();
}

class _CancelledProductsViewState extends State<CancelledProductsView> {
  final Set<String> _processingIds = {};

  Future<bool> _showConfirmDialog() async {
    return await showDialog<bool>(
          context: context,
          barrierDismissible: false,
          builder: (BuildContext context) {
            return AlertDialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              title: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.green.shade100,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Icon(
                      Icons.check_circle,
                      color: Colors.green.shade600,
                      size: 28,
                    ),
                  ),
                  const SizedBox(width: 12),
                  const Expanded(
                    child: Text(
                      'تأكيد المنتج',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
              content: Text(
                'هل أنت متأكد من تأكيد هذا المنتج الملغي؟',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey.shade700,
                  height: 1.4,
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.of(context).pop(false),
                  child: Text(
                    'رجوع',
                    style: TextStyle(
                      color: Colors.grey.shade600,
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                ElevatedButton(
                  onPressed: () => Navigator.of(context).pop(true),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green.shade600,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 24,
                      vertical: 12,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text(
                    'تأكيد',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            );
          },
        ) ??
        false;
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection('inventory_audit')
          .where('status', isEqualTo: 'CANCEL')
          .where('store_id', isEqualTo: widget.storeId)
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
            icon: Icons.cancel_outlined,
            message: 'لا توجد منتجات ملغية',
          );
        }

        final products = snapshot.data!.docs;

        return ListView.builder(
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.all(12),
          itemCount: products.length,
          itemBuilder: (context, index) {
            final doc = products[index];
            final data = doc.data() as Map<String, dynamic>;
            final isProcessing = _processingIds.contains(doc.id);

            return CancelledProductCard(
              docId: doc.id,
              productData: data,
              isProcessing: isProcessing,
              onConfirm: () async {
                if (isProcessing) return;

                final confirmed = await _showConfirmDialog();

                if (confirmed && mounted) {
                  setState(() {
                    _processingIds.add(doc.id);
                  });

                  final auditId = data['audit_id'] as int? ?? 0;
                  final itemId = data['product_id'] as int? ?? 0;
                  widget.onUpdateStatus(doc.id, 'done', auditId, itemId);

                  Future.delayed(const Duration(seconds: 2), () {
                    if (mounted) {
                      setState(() {
                        _processingIds.remove(doc.id);
                      });
                    }
                  });
                }
              },
            );
          },
        );
      },
    );
  }
}

// Cancelled Product Card - محدّث
class CancelledProductCard extends StatelessWidget {
  final String docId;
  final Map<String, dynamic> productData;
  final VoidCallback onConfirm;
  final bool isProcessing;

  const CancelledProductCard({
    super.key,
    required this.docId,
    required this.productData,
    required this.onConfirm,
    this.isProcessing = false,
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
        border: Border.all(color: Colors.red.shade300, width: 2),
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
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.red.shade50,
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(10),
              ),
            ),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.red.shade100,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(
                    Icons.cancel,
                    color: Colors.red.shade700,
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
                        color: Colors.orange,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
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
                const SizedBox(height: 12),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    onPressed: isProcessing ? null : onConfirm,
                    icon: isProcessing
                        ? const SizedBox(
                            width: 16,
                            height: 16,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              valueColor: AlwaysStoppedAnimation<Color>(
                                Colors.white,
                              ),
                            ),
                          )
                        : const Icon(Icons.check, size: 18),
                    label: Text(
                      isProcessing ? 'جاري المعالجة...' : 'تأكيد',
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: isProcessing
                          ? Colors.grey.shade400
                          : Colors.green.shade600,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      disabledBackgroundColor: Colors.grey.shade400,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// Completed Products View
class CompletedProductsView extends StatelessWidget {
  final String status;
  final Function(String docId, String status, int auditId, int itemId)
  onUpdateStatus;
  final int storeId;

  const CompletedProductsView({
    super.key,
    required this.status,
    required this.onUpdateStatus,
    required this.storeId,
  });

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection('inventory_audit')
          .where('status', isEqualTo: status)
          .where('store_id', isEqualTo: storeId)
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

        return ListView.builder(
          physics: const BouncingScrollPhysics(),
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

// Full Details Card و باقي الـ widgets تبقى كما هي...
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
