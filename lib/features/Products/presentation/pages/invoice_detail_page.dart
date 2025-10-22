import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:stock_up/features/Invoice/domain/entities/invoice_entity.dart';
import 'package:stock_up/features/Invoice/presentation/cubit/invoice_list_cubit.dart';
import 'package:stock_up/features/Invoice/presentation/cubit/invoice_state.dart';

class InvoiceDetailPage extends StatefulWidget {
  final String invoiceId;

  const InvoiceDetailPage({Key? key, required this.invoiceId})
    : super(key: key);

  @override
  State<InvoiceDetailPage> createState() => _InvoiceDetailPageState();
}

class _InvoiceDetailPageState extends State<InvoiceDetailPage> {
  @override
  void initState() {
    super.initState();
    context.read<InvoiceListCubit>().loadInvoiceById(widget.invoiceId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('تفاصيل الفاتورة'),
        actions: [
          BlocBuilder<InvoiceListCubit, InvoiceState>(
            builder: (context, state) {
              if (state is InvoiceDetailLoaded &&
                  state.invoice.status == InvoiceStatus.active) {
                return PopupMenuButton<String>(
                  onSelected: (value) {
                    if (value == 'edit') {
                      _showEditDialog(state.invoice);
                    } else if (value == 'cancel') {
                      _showCancelDialog(state.invoice);
                    } else if (value == 'delete') {
                      _showDeleteDialog(state.invoice);
                    }
                  },
                  itemBuilder: (context) => [
                    const PopupMenuItem(
                      value: 'edit',
                      child: Row(
                        children: [
                          Icon(Icons.edit, size: 20),
                          SizedBox(width: 8),
                          Text('تعديل'),
                        ],
                      ),
                    ),
                    const PopupMenuItem(
                      value: 'cancel',
                      child: Row(
                        children: [
                          Icon(Icons.cancel, size: 20, color: Colors.orange),
                          SizedBox(width: 8),
                          Text('إلغاء الفاتورة'),
                        ],
                      ),
                    ),
                    const PopupMenuItem(
                      value: 'delete',
                      child: Row(
                        children: [
                          Icon(Icons.delete, size: 20, color: Colors.red),
                          SizedBox(width: 8),
                          Text('حذف'),
                        ],
                      ),
                    ),
                  ],
                );
              }
              return const SizedBox.shrink();
            },
          ),
        ],
      ),
      body: BlocConsumer<InvoiceListCubit, InvoiceState>(
        listener: (context, state) {
          if (state is InvoiceListError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: Colors.red,
              ),
            );
          } else if (state is InvoiceUpdated || state is InvoiceCancelled) {
            Navigator.pop(context);
          }
        },
        builder: (context, state) {
          if (state is InvoiceListLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state is InvoiceDetailLoaded) {
            return _buildInvoiceDetail(state.invoice);
          }

          return const Center(child: Text('فشل في تحميل الفاتورة'));
        },
      ),
    );
  }

  Widget _buildInvoiceDetail(Invoice invoice) {
    return SingleChildScrollView(
      child: Column(
        children: [
          _buildInvoiceHeader(invoice),
          _buildCustomerInfo(invoice),
          _buildInvoiceItems(invoice),
          _buildInvoiceSummary(invoice),
          if (invoice.notes != null && invoice.notes!.isNotEmpty)
            _buildNotes(invoice),
        ],
      ),
    );
  }

  Widget _buildInvoiceHeader(Invoice invoice) {
    Color statusColor;
    String statusText;

    switch (invoice.status) {
      case InvoiceStatus.active:
        statusColor = Colors.green;
        statusText = 'نشطة';
        break;
      case InvoiceStatus.cancelled:
        statusColor = Colors.red;
        statusText = 'ملغاة';
        break;
      case InvoiceStatus.edited:
        statusColor = Colors.orange;
        statusText = 'معدلة';
        break;
    }

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Theme.of(context).primaryColor,
            Theme.of(context).primaryColor.withOpacity(0.8),
          ],
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                invoice.invoiceNumber,
                style: const TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: statusColor,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  statusText,
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            'التاريخ: ${invoice.invoiceDate.toString().split(' ')[0]}',
            style: const TextStyle(fontSize: 16, color: Colors.white70),
          ),
          if (invoice.updatedAt != null)
            Text(
              'آخر تحديث: ${invoice.updatedAt.toString().split(' ')[0]}',
              style: const TextStyle(fontSize: 14, color: Colors.white60),
            ),
        ],
      ),
    );
  }

  Widget _buildCustomerInfo(Invoice invoice) {
    if (invoice.customerName == null && invoice.customerPhone == null) {
      return const SizedBox.shrink();
    }

    return Card(
      margin: const EdgeInsets.all(16),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'معلومات العميل',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const Divider(),
            if (invoice.customerName != null)
              Row(
                children: [
                  const Icon(Icons.person, size: 20, color: Colors.grey),
                  const SizedBox(width: 8),
                  Text(
                    invoice.customerName!,
                    style: const TextStyle(fontSize: 16),
                  ),
                ],
              ),
            if (invoice.customerPhone != null) ...[
              const SizedBox(height: 8),
              Row(
                children: [
                  const Icon(Icons.phone, size: 20, color: Colors.grey),
                  const SizedBox(width: 8),
                  Text(
                    invoice.customerPhone!,
                    style: const TextStyle(fontSize: 16),
                  ),
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildInvoiceItems(Invoice invoice) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'المنتجات',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const Divider(),
            ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: invoice.items.length,
              separatorBuilder: (context, index) => const Divider(),
              itemBuilder: (context, index) {
                final item = invoice.items[index];
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      item.productName,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'رقم المنتج: ${item.productNumber}',
                      style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          '${item.quantity} ${item.unit} × ${item.price.toStringAsFixed(2)} ر.س',
                          style: const TextStyle(fontSize: 14),
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Text(
                              '${item.subtotal.toStringAsFixed(2)} ر.س',
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            if (item.taxable && item.taxAmount > 0)
                              Text(
                                'ضريبة: ${item.taxAmount.toStringAsFixed(2)} ر.س',
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.grey[600],
                                ),
                              ),
                          ],
                        ),
                      ],
                    ),
                  ],
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInvoiceSummary(Invoice invoice) {
    return Card(
      margin: const EdgeInsets.all(16),
      color: Colors.blue.shade50,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            _buildSummaryRow('المجموع الفرعي', invoice.subtotal),
            const SizedBox(height: 8),
            _buildSummaryRow('الضريبة', invoice.totalTax),
            const Divider(thickness: 2),
            _buildSummaryRow('الإجمالي', invoice.total, isTotal: true),
          ],
        ),
      ),
    );
  }

  Widget _buildSummaryRow(String label, double value, {bool isTotal = false}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: isTotal ? 20 : 16,
            fontWeight: isTotal ? FontWeight.bold : FontWeight.normal,
          ),
        ),
        Text(
          '${value.toStringAsFixed(2)} ر.س',
          style: TextStyle(
            fontSize: isTotal ? 24 : 16,
            fontWeight: FontWeight.bold,
            color: isTotal ? Colors.blue : Colors.black,
          ),
        ),
      ],
    );
  }

  Widget _buildNotes(Invoice invoice) {
    return Card(
      margin: const EdgeInsets.all(16),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'ملاحظات',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const Divider(),
            Text(invoice.notes!, style: const TextStyle(fontSize: 16)),
          ],
        ),
      ),
    );
  }

  void _showEditDialog(Invoice invoice) {
    final notesController = TextEditingController(text: invoice.notes);
    final customerNameController = TextEditingController(
      text: invoice.customerName,
    );
    final customerPhoneController = TextEditingController(
      text: invoice.customerPhone,
    );

    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('تعديل الفاتورة'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: customerNameController,
                decoration: const InputDecoration(
                  labelText: 'اسم العميل',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: customerPhoneController,
                decoration: const InputDecoration(
                  labelText: 'رقم الهاتف',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: notesController,
                decoration: const InputDecoration(
                  labelText: 'ملاحظات',
                  border: OutlineInputBorder(),
                ),
                maxLines: 3,
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: const Text('إلغاء'),
          ),
          ElevatedButton(
            onPressed: () {
              final updatedInvoice = invoice.copyWith(
                customerName: customerNameController.text,
                customerPhone: customerPhoneController.text,
                notes: notesController.text,
                status: InvoiceStatus.edited,
              );

              context.read<InvoiceListCubit>().updateInvoice(updatedInvoice);
              Navigator.pop(dialogContext);
            },
            child: const Text('حفظ'),
          ),
        ],
      ),
    );
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
            style: ElevatedButton.styleFrom(backgroundColor: Colors.orange),
            child: const Text('نعم، إلغاء'),
          ),
        ],
      ),
    );
  }

  void _showDeleteDialog(Invoice invoice) {
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('تأكيد الحذف'),
        content: Text(
          'هل أنت متأكد من حذف الفاتورة رقم ${invoice.invoiceNumber}؟\nهذا الإجراء لا يمكن التراجع عنه.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: const Text('لا'),
          ),
          ElevatedButton(
            onPressed: () {
              context.read<InvoiceListCubit>().deleteInvoice(invoice.id!);
              Navigator.pop(dialogContext);
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: const Text('نعم، حذف'),
          ),
        ],
      ),
    );
  }
}
