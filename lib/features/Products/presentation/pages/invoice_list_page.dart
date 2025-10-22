import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

// import 'package:stock_up/features/Invoice/domain/entities/invoice_entity.dart';
// import 'package:stock_up/features/Invoice/presentation/cubit/invoice_list_cubit.dart';
// import 'package:stock_up/features/Invoice/presentation/cubit/invoice_state.dart';
// import 'package:stock_up/features/Invoice/presentation/pages/invoice_detail_page.dart';

import '../../domain/entities/products_entities.dart';
import '../cubit/InvoiceCubit/invoice_state.dart';
import '../cubit/InvoiceListCubit/invoice_list_cubit.dart';
import 'invoice_detail_page.dart';

class InvoiceListPage extends StatefulWidget {
  const InvoiceListPage({Key? key}) : super(key: key);

  @override
  State<InvoiceListPage> createState() => _InvoiceListPageState();
}

class _InvoiceListPageState extends State<InvoiceListPage> {
  InvoiceStatus? _selectedStatus;
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    context.read<InvoiceListCubit>().loadInvoices();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('قائمة الفواتير'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {
              context.read<InvoiceListCubit>().loadInvoices();
            },
          ),
          IconButton(
            icon: const Icon(Icons.filter_list),
            onPressed: _showFilterDialog,
          ),
        ],
      ),
      body: Column(
        children: [
          _buildSearchBar(),
          _buildStatusFilter(),
          Expanded(
            child: BlocConsumer<InvoiceListCubit, InvoiceState>(
              listener: (context, state) {
                if (state is InvoiceListError) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(state.message),
                      backgroundColor: Colors.red,
                    ),
                  );
                } else if (state is InvoiceCancelled) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('تم إلغاء الفاتورة بنجاح'),
                      backgroundColor: Colors.orange,
                    ),
                  );
                }
              },
              builder: (context, state) {
                if (state is InvoiceListLoading) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (state is InvoiceListLoaded) {
                  if (state.invoices.isEmpty) {
                    return const Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.receipt_long,
                            size: 100,
                            color: Colors.grey,
                          ),
                          SizedBox(height: 16),
                          Text(
                            'لا توجد فواتير',
                            style: TextStyle(fontSize: 18, color: Colors.grey),
                          ),
                        ],
                      ),
                    );
                  }

                  return ListView.builder(
                    itemCount: state.invoices.length,
                    padding: const EdgeInsets.all(8),
                    itemBuilder: (context, index) {
                      final invoice = state.invoices[index];
                      return _buildInvoiceCard(invoice);
                    },
                  );
                }

                return const SizedBox.shrink();
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchBar() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: TextField(
        controller: _searchController,
        decoration: InputDecoration(
          labelText: 'البحث برقم الفاتورة أو اسم العميل',
          border: const OutlineInputBorder(),
          prefixIcon: const Icon(Icons.search),
          suffixIcon: _searchController.text.isNotEmpty
              ? IconButton(
                  icon: const Icon(Icons.clear),
                  onPressed: () {
                    _searchController.clear();
                    context.read<InvoiceListCubit>().loadInvoices();
                  },
                )
              : null,
        ),
        onSubmitted: (value) {
          if (value.isNotEmpty) {
            context.read<InvoiceListCubit>().searchInvoices(
              invoiceNumber: value.contains('INV') ? value : null,
              customerName: !value.contains('INV') ? value : null,
            );
          }
        },
      ),
    );
  }

  Widget _buildStatusFilter() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: [
          _buildFilterChip('الكل', null),
          const SizedBox(width: 8),
          _buildFilterChip('نشطة', InvoiceStatus.active),
          const SizedBox(width: 8),
          _buildFilterChip('ملغاة', InvoiceStatus.cancelled),
          const SizedBox(width: 8),
          _buildFilterChip('معدلة', InvoiceStatus.edited),
        ],
      ),
    );
  }

  Widget _buildFilterChip(String label, InvoiceStatus? status) {
    final isSelected = _selectedStatus == status;
    return FilterChip(
      label: Text(label),
      selected: isSelected,
      onSelected: (selected) {
        setState(() {
          _selectedStatus = selected ? status : null;
        });
        if (_selectedStatus != null) {
          context.read<InvoiceListCubit>().searchInvoices(
            status: _selectedStatus,
          );
        } else {
          context.read<InvoiceListCubit>().loadInvoices();
        }
      },
    );
  }

  Widget _buildInvoiceCard(Invoice invoice) {
    Color statusColor;
    IconData statusIcon;

    switch (invoice.status) {
      case InvoiceStatus.active:
        statusColor = Colors.green;
        statusIcon = Icons.check_circle;
        break;
      case InvoiceStatus.cancelled:
        statusColor = Colors.red;
        statusIcon = Icons.cancel;
        break;
      case InvoiceStatus.edited:
        statusColor = Colors.orange;
        statusIcon = Icons.edit;
        break;
    }

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      elevation: 2,
      child: InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => InvoiceDetailPage(invoiceId: invoice.id!),
            ),
          );
        },
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Icon(statusIcon, color: statusColor, size: 20),
                      const SizedBox(width: 8),
                      Text(
                        invoice.invoiceNumber,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  Text(
                    invoice.invoiceDate.toString().split(' ')[0],
                    style: TextStyle(color: Colors.grey[600], fontSize: 14),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              if (invoice.customerName != null &&
                  invoice.customerName!.isNotEmpty)
                Row(
                  children: [
                    const Icon(Icons.person, size: 16, color: Colors.grey),
                    const SizedBox(width: 4),
                    Text(
                      invoice.customerName!,
                      style: TextStyle(color: Colors.grey[700]),
                    ),
                  ],
                ),
              const SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'عدد المنتجات: ${invoice.items.length}',
                    style: TextStyle(color: Colors.grey[600]),
                  ),
                  Text(
                    '${invoice.total.toStringAsFixed(2)} ر.س',
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.blue,
                    ),
                  ),
                ],
              ),
              if (invoice.status == InvoiceStatus.active) ...[
                const SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextButton.icon(
                      onPressed: () => _showCancelDialog(invoice),
                      icon: const Icon(Icons.cancel, size: 18),
                      label: const Text('إلغاء'),
                      style: TextButton.styleFrom(foregroundColor: Colors.red),
                    ),
                  ],
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  void _showFilterDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('تصفية الفواتير'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              title: const Text('حسب التاريخ'),
              leading: const Icon(Icons.date_range),
              onTap: () {
                Navigator.pop(context);
                _showDateRangeDialog();
              },
            ),
            ListTile(
              title: const Text('حسب الحالة'),
              leading: const Icon(Icons.filter_alt),
              onTap: () {
                Navigator.pop(context);
                // يمكن إضافة حوار اختيار الحالة
              },
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('إلغاء'),
          ),
        ],
      ),
    );
  }

  void _showDateRangeDialog() async {
    final dateRange = await showDateRangePicker(
      context: context,
      firstDate: DateTime(2020),
      lastDate: DateTime.now(),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.light(
              primary: Theme.of(context).primaryColor,
            ),
          ),
          child: child!,
        );
      },
    );

    if (dateRange != null && mounted) {
      context.read<InvoiceListCubit>().searchInvoices(
        startDate: dateRange.start,
        endDate: dateRange.end,
      );
    }
  }

  void _showCancelDialog(Invoice invoice) {
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('تأكيد الإلغاء'),
        content: Text(
          'هل أنت متأكد من إلغاء الفاتورة رقم ${invoice.invoiceNumber}؟',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: const Text('لا'),
          ),
          ElevatedButton(
            onPressed: () {
              context.read<InvoiceListCubit>().cancelInvoice(invoice.id!);
              Navigator.pop(dialogContext);
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: const Text('نعم، إلغاء'),
          ),
        ],
      ),
    );
  }
}
