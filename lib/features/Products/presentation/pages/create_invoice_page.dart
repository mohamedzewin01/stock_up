import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:stock_up/features/Products/data/models/response/get_all_products_model.dart';
import 'package:stock_up/features/Products/presentation/cubit/products_cubit.dart';
import 'package:stock_up/features/Products/presentation/cubit/products_state.dart';

import '../../../../shared/test.dart';
import '../cubit/InvoiceCubit/invoice_cubit.dart';

class CreateInvoicePage extends StatefulWidget {
  const CreateInvoicePage({Key? key}) : super(key: key);

  @override
  State<CreateInvoicePage> createState() => _CreateInvoicePageState();
}

class _CreateInvoicePageState extends State<CreateInvoicePage> {
  final TextEditingController _searchController = TextEditingController();
  final TextEditingController _customerNameController = TextEditingController();
  final TextEditingController _customerPhoneController =
      TextEditingController();
  final TextEditingController _notesController = TextEditingController();

  @override
  void initState() {
    super.initState();
    context.read<InvoiceCubit>().startNewInvoice();
    context.read<ProductsCubit>().loadProductsFromLocal();
  }

  @override
  void dispose() {
    _searchController.dispose();
    _customerNameController.dispose();
    _customerPhoneController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('إنشاء فاتورة جديدة'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {
              context.read<ProductsCubit>().syncProducts();
            },
            tooltip: 'تحديث المنتجات',
          ),
        ],
      ),
      body: BlocListener<InvoiceCubit, InvoiceState>(
        listener: (context, state) {
          if (state is InvoiceSaved) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(
                  'تم حفظ الفاتورة رقم: ${state.savedInvoice.invoiceNumber}',
                ),
                backgroundColor: Colors.green,
              ),
            );
          } else if (state is InvoiceError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: Colors.red,
              ),
            );
          }
        },
        child: Column(
          children: [
            // معلومات الفاتورة
            _buildInvoiceHeader(),

            // معلومات العميل
            _buildCustomerInfo(),

            // قائمة المنتجات المضافة
            Expanded(flex: 2, child: _buildInvoiceItems()),

            // البحث والمنتجات المتاحة
            Expanded(flex: 3, child: _buildProductsList()),

            // الإجمالي وزر الحفظ
            _buildFooter(),
          ],
        ),
      ),
    );
  }

  Widget _buildInvoiceHeader() {
    return BlocBuilder<InvoiceCubit, InvoiceState>(
      builder: (context, state) {
        final invoice = context.read<InvoiceCubit>().currentInvoice;
        if (invoice == null) return const SizedBox.shrink();

        return Container(
          padding: const EdgeInsets.all(16),
          color: Colors.blue.shade50,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'رقم الفاتورة: ${invoice.invoiceNumber}',
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                'التاريخ: ${invoice.invoiceDate.toString().split(' ')[0]}',
                style: const TextStyle(fontSize: 16),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildCustomerInfo() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: _customerNameController,
              decoration: const InputDecoration(
                labelText: 'اسم العميل',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.person),
              ),
              onChanged: (value) {
                context.read<InvoiceCubit>().updateCustomerInfo(name: value);
              },
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: TextField(
              controller: _customerPhoneController,
              decoration: const InputDecoration(
                labelText: 'رقم الهاتف',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.phone),
              ),
              keyboardType: TextInputType.phone,
              onChanged: (value) {
                context.read<InvoiceCubit>().updateCustomerInfo(phone: value);
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInvoiceItems() {
    return BlocBuilder<InvoiceCubit, InvoiceState>(
      builder: (context, state) {
        final invoice = context.read<InvoiceCubit>().currentInvoice;
        if (invoice == null || invoice.items.isEmpty) {
          return const Center(
            child: Text(
              'لم يتم إضافة منتجات بعد',
              style: TextStyle(fontSize: 16, color: Colors.grey),
            ),
          );
        }

        return Column(
          children: [
            const Padding(
              padding: EdgeInsets.all(8.0),
              child: Text(
                'المنتجات المضافة',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
            ),
            Expanded(
              child: ListView.builder(
                itemCount: invoice.items.length,
                itemBuilder: (context, index) {
                  final item = invoice.items[index];
                  return Card(
                    margin: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 4,
                    ),
                    child: ListTile(
                      title: Text(item.productName),
                      subtitle: Text(
                        'السعر: ${item.price} × ${item.quantity} ${item.unit}',
                      ),
                      trailing: SizedBox(
                        width: 150,
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              '${item.total.toStringAsFixed(2)} ر.س',
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),
                            IconButton(
                              icon: const Icon(Icons.delete, color: Colors.red),
                              onPressed: () {
                                context.read<InvoiceCubit>().removeItem(index);
                              },
                            ),
                          ],
                        ),
                      ),
                      onTap: () => _showEditItemDialog(context, index, item),
                    ),
                  );
                },
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildProductsList() {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(16),
          child: TextField(
            controller: _searchController,
            decoration: InputDecoration(
              labelText: 'البحث عن منتج',
              border: const OutlineInputBorder(),
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
        Expanded(
          child: BlocBuilder<ProductsCubit, ProductsState>(
            builder: (context, state) {
              if (state is ProductsLoading) {
                return const Center(child: CircularProgressIndicator());
              }

              if (state is ProductsError) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(state.message),
                      if (state.cachedProducts != null)
                        ElevatedButton(
                          onPressed: () {
                            context.read<ProductsCubit>().refreshProducts();
                          },
                          child: const Text('استخدام البيانات المحلية'),
                        ),
                    ],
                  ),
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
                return const Center(child: Text('لا توجد منتجات'));
              }

              return ListView.builder(
                itemCount: products.length,
                itemBuilder: (context, index) {
                  final product = products[index];
                  return Card(
                    margin: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 4,
                    ),
                    child: ListTile(
                      title: Text(product.productName ?? ''),
                      subtitle: Text(
                        'الرقم: ${product.productNumber ?? ''}\n'
                        'السعر: ${product.sellingPrice ?? '0'} ر.س\n'
                        'المخزون: ${product.totalQuantity ?? '0'} ${product.unit ?? ''}',
                      ),
                      trailing: IconButton(
                        icon: const Icon(Icons.add_circle, color: Colors.green),
                        onPressed: () {
                          _showAddProductDialog(context, product);
                        },
                      ),
                      isThreeLine: true,
                    ),
                  );
                },
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildFooter() {
    return BlocBuilder<InvoiceCubit, InvoiceState>(
      builder: (context, state) {
        final invoice = context.read<InvoiceCubit>().currentInvoice;
        if (invoice == null) return const SizedBox.shrink();

        return Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                color: Colors.grey.shade300,
                blurRadius: 5,
                offset: const Offset(0, -2),
              ),
            ],
          ),
          child: Column(
            children: [
              TextField(
                controller: _notesController,
                decoration: const InputDecoration(
                  labelText: 'ملاحظات',
                  border: OutlineInputBorder(),
                ),
                maxLines: 2,
                onChanged: (value) {
                  context.read<InvoiceCubit>().updateNotes(value);
                },
              ),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'المجموع الفرعي: ${invoice.subtotal.toStringAsFixed(2)} ر.س',
                      ),
                      Text(
                        'الضريبة: ${invoice.totalTax.toStringAsFixed(2)} ر.س',
                      ),
                      Text(
                        'الإجمالي: ${invoice.total.toStringAsFixed(2)} ر.س',
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  ElevatedButton.icon(
                    onPressed: invoice.items.isEmpty || state is InvoiceSaving
                        ? null
                        : () {
                            context.read<InvoiceCubit>().saveInvoice();
                          },
                    icon: state is InvoiceSaving
                        ? const SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: Colors.white,
                            ),
                          )
                        : const Icon(Icons.save),
                    label: const Text('حفظ الفاتورة'),
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 32,
                        vertical: 16,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  void _showAddProductDialog(BuildContext context, Results product) {
    final quantityController = TextEditingController(text: '1');
    final priceController = TextEditingController(
      text: product.sellingPrice ?? '0',
    );

    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: Text(product.productName ?? ''),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: quantityController,
              decoration: InputDecoration(
                labelText: 'الكمية (${product.unit ?? ''})',
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

              context.read<InvoiceCubit>().addProduct(
                product,
                quantity: quantity,
                customPrice: price,
              );

              Navigator.pop(dialogContext);
            },
            child: const Text('إضافة'),
          ),
        ],
      ),
    );
  }

  void _showEditItemDialog(BuildContext context, int index, item) {
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
