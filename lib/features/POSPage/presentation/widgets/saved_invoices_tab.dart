// lib/features/POSPage/presentation/widgets/saved_invoices_tab.dart

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

import '../../data/models/invoice_model.dart';
import '../../domain/models/invoice_model.dart';
import '../bloc/invoice_cubit.dart';
import 'invoice_details_dialog.dart';

class SavedInvoicesTab extends StatefulWidget {
  const SavedInvoicesTab({super.key});

  @override
  State<SavedInvoicesTab> createState() => _SavedInvoicesTabState();
}

class _SavedInvoicesTabState extends State<SavedInvoicesTab> {
  @override
  void initState() {
    super.initState();
    // Load invoices when tab is opened
    Future.microtask(() {
      context.read<InvoiceCubit>().loadInvoices();
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<InvoiceCubit, InvoiceState>(
      builder: (context, state) {
        if (state is InvoiceLoading) {
          return _buildLoadingState();
        }

        if (state is InvoicesLoaded) {
          if (state.invoices.isEmpty) {
            return _buildEmptyState();
          }
          return _buildInvoicesList(state.invoices);
        }

        if (state is InvoiceError) {
          return _buildErrorState(state.message);
        }

        return _buildEmptyState();
      },
    );
  }

  Widget _buildLoadingState() {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  const Color(0xFF6C63FF).withOpacity(0.1),
                  const Color(0xFF5A52E0).withOpacity(0.05),
                ],
              ),
              shape: BoxShape.circle,
            ),
            child: const CircularProgressIndicator(
              color: Color(0xFF6C63FF),
              strokeWidth: 3,
            ),
          ),
          const SizedBox(height: 24),
          const Text(
            'جاري تحميل الفواتير...',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: Color(0xFF2D3436),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(40),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.all(40),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    const Color(0xFF6C63FF).withOpacity(0.1),
                    const Color(0xFF5A52E0).withOpacity(0.05),
                  ],
                ),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.receipt_long_outlined,
                size: 80,
                color: Colors.grey[300],
              ),
            ),
            const SizedBox(height: 24),
            const Text(
              'لا توجد فواتير محفوظة',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Color(0xFF2D3436),
              ),
            ),
            const SizedBox(height: 12),
            Text(
              'ابدأ بإنشاء فاتورة جديدة',
              style: TextStyle(fontSize: 15, color: Colors.grey[500]),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildErrorState(String message) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(40),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.error_outline, size: 80, color: Color(0xFFFF6B6B)),
            const SizedBox(height: 24),
            Text(
              'حدث خطأ',
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Color(0xFF2D3436),
              ),
            ),
            const SizedBox(height: 12),
            Text(
              message,
              style: TextStyle(fontSize: 15, color: Colors.grey[600]),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: () {
                context.read<InvoiceCubit>().loadInvoices();
              },
              icon: const Icon(Icons.refresh),
              label: const Text('إعادة المحاولة'),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF6C63FF),
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 12,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInvoicesList(List<Invoice> invoices) {
    return RefreshIndicator(
      onRefresh: () async {
        context.read<InvoiceCubit>().loadInvoices();
      },
      child: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: invoices.length,
        itemBuilder: (context, index) {
          return _buildInvoiceCard(invoices[index]);
        },
      ),
    );
  }

  Widget _buildInvoiceCard(Invoice invoice) {
    final dateFormat = DateFormat('dd/MM/yyyy - HH:mm');

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: () {
            _showInvoiceDetails(invoice);
          },
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Container(
                                padding: const EdgeInsets.all(8),
                                decoration: BoxDecoration(
                                  gradient: const LinearGradient(
                                    colors: [
                                      Color(0xFF6C63FF),
                                      Color(0xFF5A52E0),
                                    ],
                                  ),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: const Icon(
                                  Icons.receipt,
                                  color: Colors.white,
                                  size: 16,
                                ),
                              ),
                              const SizedBox(width: 8),
                              Expanded(
                                child: Text(
                                  invoice.id,
                                  style: const TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold,
                                    color: Color(0xFF2D3436),
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          Row(
                            children: [
                              Icon(
                                Icons.access_time,
                                size: 14,
                                color: Colors.grey[600],
                              ),
                              const SizedBox(width: 4),
                              Text(
                                dateFormat.format(invoice.createdAt),
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.grey[600],
                                ),
                              ),
                            ],
                          ),
                          if (invoice.customerName != null) ...[
                            const SizedBox(height: 4),
                            Row(
                              children: [
                                Icon(
                                  Icons.person_outline,
                                  size: 14,
                                  color: Colors.grey[600],
                                ),
                                const SizedBox(width: 4),
                                Text(
                                  invoice.customerName!,
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: Colors.grey[600],
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ],
                      ),
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          '${invoice.grandTotal.toStringAsFixed(2)}',
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF11998E),
                          ),
                        ),
                        const Text(
                          'ر.س',
                          style: TextStyle(
                            fontSize: 12,
                            color: Color(0xFF11998E),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 8,
                  ),
                  decoration: BoxDecoration(
                    color: const Color(0xFF6C63FF).withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(
                        Icons.shopping_bag_outlined,
                        size: 16,
                        color: Color(0xFF6C63FF),
                      ),
                      const SizedBox(width: 6),
                      Text(
                        '${invoice.items.length} منتج',
                        style: const TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF6C63FF),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _showInvoiceDetails(Invoice invoice) {
    showDialog(
      context: context,
      builder: (context) => InvoiceDetailsDialog(invoice: invoice),
    );
  }
}
