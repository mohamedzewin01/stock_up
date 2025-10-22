import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:stock_up/features/Products/data/models/response/get_all_products_model.dart';
import 'package:stock_up/features/Products/domain/entities/products_entities.dart';
import 'package:stock_up/features/Products/presentation/cubit/InvoiceCubit/invoice_cubit.dart';
import 'package:stock_up/features/Products/presentation/cubit/products_cubit.dart';
import 'package:stock_up/features/Products/presentation/cubit/products_state.dart';

import '../cubit/InvoiceCubit/invoice_state.dart';

class CreateInvoicePage extends StatefulWidget {
  const CreateInvoicePage({super.key});

  @override
  State<CreateInvoicePage> createState() => _CreateInvoicePageState();
}

class _CreateInvoicePageState extends State<CreateInvoicePage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final TextEditingController _searchController = TextEditingController();
  final TextEditingController _customerNameController = TextEditingController();
  final TextEditingController _customerPhoneController =
      TextEditingController();
  final TextEditingController _notesController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    context.read<InvoiceCubit>().startNewInvoice();
    context.read<ProductsCubit>().loadProductsFromLocal();
  }

  @override
  void dispose() {
    _tabController.dispose();
    _searchController.dispose();
    _customerNameController.dispose();
    _customerPhoneController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      appBar: AppBar(
        title: const Text(
          'إنشاء فاتورة',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
        ),
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.blue.shade700,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {
              context.read<ProductsCubit>().syncProducts();
            },
            tooltip: 'تحديث المنتجات',
          ),
        ],
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
            Tab(text: 'إضافة منتجات'),
            Tab(text: 'مراجعة الفاتورة'),
          ],
        ),
      ),
      body: BlocListener<InvoiceCubit, InvoiceState>(
        listener: (context, state) {
          if (state is InvoiceSaved) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Row(
                  children: [
                    const Icon(Icons.check_circle, color: Colors.white),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        'تم حفظ الفاتورة رقم: ${state.savedInvoice.invoiceNumber}',
                      ),
                    ),
                  ],
                ),
                backgroundColor: Colors.green.shade600,
                behavior: SnackBarBehavior.floating,
                duration: const Duration(seconds: 2),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            );
            // الانتقال إلى تاب المنتجات بعد الحفظ
            _tabController.animateTo(0);
          } else if (state is InvoiceError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Row(
                  children: [
                    const Icon(Icons.error, color: Colors.white),
                    const SizedBox(width: 8),
                    Expanded(child: Text(state.message)),
                  ],
                ),
                backgroundColor: Colors.red.shade600,
                behavior: SnackBarBehavior.floating,
              ),
            );
          }
        },
        child: TabBarView(
          controller: _tabController,
          children: [
            // تاب البحث وإضافة المنتجات
            _buildProductsTab(),
            // تاب مراجعة الفاتورة
            _buildReviewTab(),
          ],
        ),
      ),
    );
  }

  // تاب البحث وإضافة المنتجات (بنفس تصميم AuditItems)
  Widget _buildProductsTab() {
    return Column(
      children: [
        // شريط البحث
        Container(
          padding: const EdgeInsets.all(16),
          color: Colors.white,
          child: TextField(
            controller: _searchController,
            decoration: InputDecoration(
              labelText: 'البحث عن منتج',
              hintText: 'اسم المنتج، الباركود، أو رقم المنتج',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              prefixIcon: const Icon(Icons.search),
              suffixIcon: _searchController.text.isNotEmpty
                  ? IconButton(
                      icon: const Icon(Icons.clear),
                      onPressed: () {
                        _searchController.clear();
                        context.read<ProductsCubit>().refreshProducts();
                      },
                    )
                  : null,
            ),
            onChanged: (value) {
              context.read<ProductsCubit>().searchProducts(value);
            },
          ),
        ),

        // قائمة المنتجات بتصميم مشابه لـ AuditItems
        Expanded(
          child: BlocBuilder<ProductsCubit, ProductsState>(
            builder: (context, state) {
              if (state is ProductsLoading) {
                return const Center(child: CircularProgressIndicator());
              }

              if (state is ProductsError) {
                return ErrorView(
                  message: state.message,
                  onRetry: () {
                    context.read<ProductsCubit>().refreshProducts();
                  },
                );
              }

              List<Results> products = [];
              if (state is ProductsLoadedFromLocal) {
                products = state.products;
              } else if (state is ProductsSynced) {
                products = state.products;
              } else if (state is ProductsSearchResult) {
                products = state.searchResults;
              }

              if (products.isEmpty) {
                return const EmptyStateView(
                  icon: Icons.inventory_2_outlined,
                  message: 'لا توجد منتجات',
                );
              }

              return PageView.builder(
                scrollDirection: Axis.vertical,
                itemCount: products.length,
                itemBuilder: (context, index) {
                  final product = products[index];
                  return ProductCardForInvoice(
                    product: product,
                    currentIndex: index + 1,
                    totalCount: products.length,
                    onAddToInvoice: (quantity, price) {
                      context.read<InvoiceCubit>().addProduct(
                        product,
                        quantity: quantity,
                        customPrice: price,
                      );

                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Row(
                            children: [
                              const Icon(
                                Icons.check_circle,
                                color: Colors.white,
                              ),
                              const SizedBox(width: 8),
                              Expanded(
                                child: Text(
                                  'تمت إضافة ${product.productName ?? "المنتج"} للفاتورة',
                                ),
                              ),
                            ],
                          ),
                          backgroundColor: Colors.green.shade600,
                          behavior: SnackBarBehavior.floating,
                          duration: const Duration(seconds: 1),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                      );
                    },
                  );
                },
              );
            },
          ),
        ),
      ],
    );
  }

  // تاب مراجعة الفاتورة
  Widget _buildReviewTab() {
    return BlocBuilder<InvoiceCubit, InvoiceState>(
      builder: (context, state) {
        final invoice = context.read<InvoiceCubit>().currentInvoice;

        if (invoice == null || invoice.items.isEmpty) {
          return const EmptyStateView(
            icon: Icons.shopping_cart_outlined,
            message: 'لم يتم إضافة منتجات للفاتورة بعد',
          );
        }

        return SingleChildScrollView(
          child: Column(
            children: [
              // معلومات الفاتورة
              _buildInvoiceHeader(invoice),

              // معلومات العميل
              _buildCustomerInfoSection(),

              // قائمة المنتجات المضافة
              _buildInvoiceItemsList(invoice),

              // الملاحظات
              _buildNotesSection(),

              // الملخص المالي
              _buildInvoiceSummary(invoice),

              // زر الحفظ
              _buildSaveButton(state, invoice),

              const SizedBox(height: 20),
            ],
          ),
        );
      },
    );
  }

  Widget _buildInvoiceHeader(Invoice invoice) {
    return Container(
      margin: const EdgeInsets.all(12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.blue.shade500, Colors.blue.shade700],
        ),
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.blue.shade200,
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.receipt_long, color: Colors.white, size: 28),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      invoice.invoiceNumber,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      'التاريخ: ${invoice.invoiceDate.toString().split(' ')[0]}',
                      style: const TextStyle(
                        color: Colors.white70,
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  'عدد المنتجات: ${invoice.items.length}',
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildCustomerInfoSection() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.shade200,
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            children: [
              Icon(Icons.person, color: Colors.blue),
              SizedBox(width: 8),
              Text(
                'معلومات العميل',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
            ],
          ),
          const SizedBox(height: 12),
          TextField(
            controller: _customerNameController,
            decoration: InputDecoration(
              labelText: 'اسم العميل',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              prefixIcon: const Icon(Icons.person_outline),
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 12,
                vertical: 12,
              ),
            ),
            onChanged: (value) {
              context.read<InvoiceCubit>().updateCustomerInfo(name: value);
            },
          ),
          const SizedBox(height: 12),
          TextField(
            controller: _customerPhoneController,
            decoration: InputDecoration(
              labelText: 'رقم الهاتف',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              prefixIcon: const Icon(Icons.phone_outlined),
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 12,
                vertical: 12,
              ),
            ),
            keyboardType: TextInputType.phone,
            onChanged: (value) {
              context.read<InvoiceCubit>().updateCustomerInfo(phone: value);
            },
          ),
        ],
      ),
    );
  }

  Widget _buildInvoiceItemsList(Invoice invoice) {
    return Container(
      margin: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.shade200,
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                const Icon(Icons.shopping_basket, color: Colors.green),
                const SizedBox(width: 8),
                const Text(
                  'المنتجات المضافة',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                const Spacer(),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.green.shade100,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    '${invoice.items.length}',
                    style: TextStyle(
                      color: Colors.green.shade700,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const Divider(height: 1),
          ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: invoice.items.length,
            separatorBuilder: (context, index) => const Divider(height: 1),
            itemBuilder: (context, index) {
              final item = invoice.items[index];
              return InvoiceItemCard(
                item: item,
                index: index,
                onEdit: () => _showEditItemDialog(context, index, item),
                onRemove: () {
                  context.read<InvoiceCubit>().removeItem(index);
                },
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildNotesSection() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.shade200,
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            children: [
              Icon(Icons.note_alt, color: Colors.orange),
              SizedBox(width: 8),
              Text(
                'ملاحظات',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
            ],
          ),
          const SizedBox(height: 12),
          TextField(
            controller: _notesController,
            decoration: InputDecoration(
              hintText: 'أضف ملاحظات على الفاتورة (اختياري)',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              contentPadding: const EdgeInsets.all(12),
            ),
            maxLines: 3,
            onChanged: (value) {
              context.read<InvoiceCubit>().updateNotes(value);
            },
          ),
        ],
      ),
    );
  }

  Widget _buildInvoiceSummary(Invoice invoice) {
    return Container(
      margin: const EdgeInsets.all(12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.purple.shade50, Colors.purple.shade100],
        ),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.purple.shade300, width: 2),
      ),
      child: Column(
        children: [
          _buildSummaryRow(
            'المجموع الفرعي',
            invoice.subtotal,
            Colors.grey.shade700,
          ),
          const SizedBox(height: 8),
          _buildSummaryRow('الضريبة', invoice.totalTax, Colors.orange.shade700),
          const Divider(thickness: 2),
          _buildSummaryRow(
            'الإجمالي',
            invoice.total,
            Colors.purple.shade700,
            isTotal: true,
          ),
        ],
      ),
    );
  }

  Widget _buildSummaryRow(
    String label,
    double value,
    Color color, {
    bool isTotal = false,
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: isTotal ? 18 : 14,
            fontWeight: isTotal ? FontWeight.bold : FontWeight.normal,
            color: color,
          ),
        ),
        Text(
          '${value.toStringAsFixed(2)} ر.س',
          style: TextStyle(
            fontSize: isTotal ? 22 : 16,
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
      ],
    );
  }

  Widget _buildSaveButton(InvoiceState state, Invoice invoice) {
    final isLoading = state is InvoiceSaving;
    final canSave = invoice.items.isNotEmpty && !isLoading;

    return Container(
      margin: const EdgeInsets.all(12),
      width: double.infinity,
      child: ElevatedButton.icon(
        onPressed: canSave
            ? () {
                context.read<InvoiceCubit>().saveInvoice();
              }
            : null,
        icon: isLoading
            ? const SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  color: Colors.white,
                ),
              )
            : const Icon(Icons.save),
        label: Text(
          isLoading ? 'جاري الحفظ...' : 'حفظ الفاتورة',
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.green.shade600,
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          elevation: 4,
        ),
      ),
    );
  }

  void _showEditItemDialog(BuildContext context, int index, InvoiceItem item) {
    final quantityController = TextEditingController(
      text: item.quantity.toString(),
    );
    final priceController = TextEditingController(text: item.price.toString());

    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: Text('تعديل: ${item.productName}'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: quantityController,
              decoration: InputDecoration(
                labelText: 'الكمية (${item.unit})',
                border: const OutlineInputBorder(),
              ),
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 16),
            TextField(
              controller: priceController,
              decoration: const InputDecoration(
                labelText: 'السعر',
                border: OutlineInputBorder(),
                suffixText: 'ر.س',
              ),
              keyboardType: TextInputType.number,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: const Text('إلغاء'),
          ),
          ElevatedButton(
            onPressed: () {
              final quantity = double.tryParse(quantityController.text) ?? 1.0;
              final price = double.tryParse(priceController.text) ?? 0.0;

              context.read<InvoiceCubit>().updateItemQuantity(index, quantity);
              context.read<InvoiceCubit>().updateItemPrice(index, price);

              Navigator.pop(dialogContext);
            },
            child: const Text('تحديث'),
          ),
        ],
      ),
    );
  }
}

// ===== Widgets المساعدة =====

class ProductCardForInvoice extends StatelessWidget {
  final Results product;
  final int currentIndex;
  final int totalCount;
  final Function(double quantity, double price) onAddToInvoice;

  const ProductCardForInvoice({
    Key? key,
    required this.product,
    required this.currentIndex,
    required this.totalCount,
    required this.onAddToInvoice,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

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
            // عداد المنتجات
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

            SizedBox(height: screenHeight * 0.02),

            // البطاقة الرئيسية
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
                  // Header المنتج
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [Colors.green.shade400, Colors.green.shade600],
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
                          size: 36,
                        ),
                        const SizedBox(height: 8),
                        Text(
                          product.productName ?? 'منتج غير معروف',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 18,
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
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      children: [
                        // تفاصيل المنتج
                        Row(
                          children: [
                            Expanded(
                              child: _DetailItem(
                                icon: Icons.attach_money,
                                label: 'السعر',
                                value: '${product.sellingPrice ?? "0"} ر.س',
                                color: Colors.green,
                              ),
                            ),
                            Container(
                              width: 1,
                              height: 50,
                              color: Colors.grey.shade300,
                            ),
                            Expanded(
                              child: _DetailItem(
                                icon: Icons.inventory,
                                label: 'المخزون',
                                value:
                                    '${product.totalQuantity ?? "0"} ${product.unit ?? ""}',
                                color: Colors.blue,
                              ),
                            ),
                          ],
                        ),

                        const SizedBox(height: 12),

                        Row(
                          children: [
                            Expanded(
                              child: _DetailItem(
                                icon: Icons.category,
                                label: 'القسم',
                                value: product.categoryName ?? 'غير محدد',
                                color: Colors.purple,
                              ),
                            ),
                            Container(
                              width: 1,
                              height: 50,
                              color: Colors.grey.shade300,
                            ),
                            Expanded(
                              child: _DetailItem(
                                icon: Icons.numbers,
                                label: 'رقم المنتج',
                                value: product.productNumber ?? 'غير متوفر',
                                color: Colors.orange,
                              ),
                            ),
                          ],
                        ),

                        if (product.barcodes != null &&
                            product.barcodes!.isNotEmpty) ...[
                          const SizedBox(height: 16),
                          Container(
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: Colors.grey.shade100,
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(color: Colors.grey.shade300),
                            ),
                            child: Row(
                              children: [
                                Icon(
                                  Icons.qr_code,
                                  color: Colors.grey.shade700,
                                ),
                                const SizedBox(width: 8),
                                Expanded(
                                  child: Text(
                                    product.barcodes!.first,
                                    style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.grey.shade800,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                ],
              ),
            ),

            SizedBox(height: screenHeight * 0.02),

            // زر الإضافة
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: () {
                  _showAddToInvoiceDialog(context);
                },
                icon: const Icon(Icons.add_shopping_cart, size: 20),
                label: const Text(
                  'إضافة للفاتورة',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green.shade600,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  elevation: 4,
                ),
              ),
            ),

            SizedBox(height: screenHeight * 0.01),

            // تلميح السحب
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

  void _showAddToInvoiceDialog(BuildContext context) {
    final quantityController = TextEditingController(text: '1');
    final priceController = TextEditingController(
      text: product.sellingPrice ?? '0',
    );

    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: Text(product.productName ?? 'إضافة منتج'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: quantityController,
              decoration: InputDecoration(
                labelText: 'الكمية (${product.unit ?? ''})',
                border: const OutlineInputBorder(),
                prefixIcon: const Icon(Icons.shopping_basket),
              ),
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 16),
            TextField(
              controller: priceController,
              decoration: const InputDecoration(
                labelText: 'السعر',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.attach_money),
                suffixText: 'ر.س',
              ),
              keyboardType: TextInputType.number,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: const Text('إلغاء'),
          ),
          ElevatedButton.icon(
            onPressed: () {
              final quantity = double.tryParse(quantityController.text) ?? 1.0;
              final price = double.tryParse(priceController.text) ?? 0.0;

              onAddToInvoice(quantity, price);
              Navigator.pop(dialogContext);
            },
            icon: const Icon(Icons.add),
            label: const Text('إضافة'),
            style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
          ),
        ],
      ),
    );
  }
}

class _DetailItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final Color color;

  const _DetailItem({
    required this.icon,
    required this.label,
    required this.value,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Icon(icon, color: color, size: 24),
        const SizedBox(height: 6),
        Text(
          label,
          style: TextStyle(fontSize: 11, color: Colors.grey.shade600),
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: const TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
          textAlign: TextAlign.center,
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
        ),
      ],
    );
  }
}

class InvoiceItemCard extends StatelessWidget {
  final InvoiceItem item;
  final int index;
  final VoidCallback onEdit;
  final VoidCallback onRemove;

  const InvoiceItemCard({
    Key? key,
    required this.item,
    required this.index,
    required this.onEdit,
    required this.onRemove,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      leading: CircleAvatar(
        backgroundColor: Colors.blue.shade100,
        child: Text(
          '${index + 1}',
          style: TextStyle(
            color: Colors.blue.shade700,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      title: Text(
        item.productName,
        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
      ),
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 4),
          Text(
            '${item.quantity} ${item.unit} × ${item.price.toStringAsFixed(2)} ر.س',
            style: TextStyle(color: Colors.grey.shade600, fontSize: 13),
          ),
          if (item.taxable && item.taxAmount > 0)
            Text(
              'ضريبة: ${item.taxAmount.toStringAsFixed(2)} ر.س',
              style: TextStyle(color: Colors.orange.shade600, fontSize: 12),
            ),
        ],
      ),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                '${item.total.toStringAsFixed(2)} ر.س',
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                  color: Colors.green,
                ),
              ),
            ],
          ),
          IconButton(
            icon: const Icon(Icons.edit, size: 20),
            color: Colors.blue,
            onPressed: onEdit,
          ),
          IconButton(
            icon: const Icon(Icons.delete, size: 20),
            color: Colors.red,
            onPressed: onRemove,
          ),
        ],
      ),
    );
  }
}

class EmptyStateView extends StatelessWidget {
  final IconData icon;
  final String message;

  const EmptyStateView({Key? key, required this.icon, required this.message})
    : super(key: key);

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
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}

class ErrorView extends StatelessWidget {
  final String message;
  final VoidCallback? onRetry;

  const ErrorView({Key? key, required this.message, this.onRetry})
    : super(key: key);

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
          if (onRetry != null) ...[
            const SizedBox(height: 16),
            ElevatedButton.icon(
              onPressed: onRetry,
              icon: const Icon(Icons.refresh),
              label: const Text('إعادة المحاولة'),
            ),
          ],
        ],
      ),
    );
  }
}
