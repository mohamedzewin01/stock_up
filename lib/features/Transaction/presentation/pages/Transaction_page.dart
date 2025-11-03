import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:stock_up/features/Auth/domain/entities/login_entity.dart';

import '../../../../core/di/di.dart';
import '../bloc/Transaction_cubit.dart';
import '../widgets/add_transaction_dialog.dart';
import '../widgets/transaction_bottom_bar.dart';
import '../widgets/transaction_dialogs.dart';
import '../widgets/transaction_empty_state.dart';
import '../widgets/transaction_list.dart';
import '../widgets/transaction_statistics_card.dart';
import '../widgets/transaction_types.dart';

class TransactionPage extends StatefulWidget {
  const TransactionPage({super.key, required this.shift});

  final LoginEntity shift;

  @override
  State<TransactionPage> createState() => _TransactionPageState();
}

class _TransactionPageState extends State<TransactionPage> {
  late TransactionCubit viewModel;
  final List<TransactionItem> _transactions = [];
  final ScrollController _scrollController = ScrollController();

  // إحصائيات المعاملات
  double _totalPositive = 0.0;
  double _totalNegative = 0.0;
  double _netAmount = 0.0;

  @override
  void initState() {
    viewModel = getIt.get<TransactionCubit>();
    super.initState();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _updateStatistics() {
    _totalPositive = _transactions
        .where((t) => t.type.isPositive)
        .fold(0.0, (sum, t) => sum + t.amount);

    _totalNegative = _transactions
        .where((t) => !t.type.isPositive)
        .fold(0.0, (sum, t) => sum + t.amount);

    _netAmount = _totalPositive - _totalNegative;
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isTablet = screenWidth > 600;

    return BlocProvider.value(
      value: viewModel,
      child: BlocListener<TransactionCubit, TransactionState>(
        listener: (context, state) {
          if (state is TransactionSuccess) {
            TransactionDialogs.showSuccessDialog(context);
          } else if (state is TransactionFailure) {
            TransactionDialogs.showErrorDialog(
              context,
              state.exception.toString(),
            );
          }
        },
        child: Scaffold(
          backgroundColor: const Color(0xFFF8F9FA),
          appBar: _buildAppBar(isTablet),
          body: Column(
            children: [
              // إحصائيات المعاملات
              TransactionStatisticsCard(
                totalPositive: _totalPositive,
                totalNegative: _totalNegative,
                netAmount: _netAmount,
                transactionCount: _transactions.length,
                isTablet: isTablet,
              ),

              // قائمة المعاملات
              Expanded(
                child: _transactions.isEmpty
                    ? TransactionEmptyState(
                        isTablet: isTablet,
                        onAddTransaction: _showAddTransactionDialog,
                      )
                    : TransactionList(
                        transactions: _transactions,
                        scrollController: _scrollController,
                        isTablet: isTablet,
                        onEditTransaction: _editTransaction,
                        onRemoveTransaction: _removeTransaction,
                      ),
              ),

              // شريط الإجراءات السفلي
              TransactionBottomBar(
                hasTransactions: _transactions.isNotEmpty,
                totalPositive: _totalPositive,
                totalNegative: _totalNegative,
                netAmount: _netAmount,
                transactionCount: _transactions.length,
                isTablet: isTablet,
                onClearAll: _clearAllTransactions,
                onFinishShift: _sendTransactionsAndFinishShift,
              ),
            ],
          ),
          floatingActionButton: FloatingActionButton(
            onPressed: _showAddTransactionDialog,
            backgroundColor: const Color(0xFF007AFF),
            child: const Icon(Icons.add, color: Colors.white),
          ),
        ),
      ),
    );
  }

  PreferredSizeWidget _buildAppBar(bool isTablet) {
    return AppBar(
      backgroundColor: Colors.white,
      elevation: 0,
      centerTitle: true,
      leading: IconButton(
        onPressed: () => Navigator.of(context).pop(),
        icon: Icon(
          Icons.arrow_back_ios,
          color: const Color(0xFF1A1A1A),
          size: isTablet ? 24 : 20,
        ),
      ),
      title: Column(
        children: [
          Text(
            'إدارة المعاملات',
            style: TextStyle(
              fontSize: isTablet ? 20 : 18,
              fontWeight: FontWeight.bold,
              color: const Color(0xFF1A1A1A),
            ),
          ),
          if (widget.shift.store?.id != null) ...[
            Text(
              'وردية #${widget.shift.store?.id}',
              style: TextStyle(
                fontSize: isTablet ? 12 : 10,
                color: const Color(0xFF666666),
              ),
            ),
          ],
        ],
      ),
      actions: [
        if (_transactions.isNotEmpty)
          IconButton(
            onPressed: _clearAllTransactions,
            icon: Icon(
              Icons.clear_all,
              color: const Color(0xFFFF3B30),
              size: isTablet ? 24 : 20,
            ),
            tooltip: 'مسح جميع المعاملات',
          ),
        const SizedBox(width: 8),
      ],
      bottom: PreferredSize(
        preferredSize: const Size.fromHeight(1),
        child: Container(height: 1, color: const Color(0xFFE5E5E5)),
      ),
    );
  }

  void _showAddTransactionDialog() {
    showDialog(
      context: context,
      builder: (context) =>
          AddTransactionDialog(onTransactionAdded: _addTransaction),
    );
  }

  void _addTransaction(TransactionItem transaction) {
    setState(() {
      _transactions.add(transaction);
      _updateStatistics();
    });

    // تحريك القائمة للأسفل لإظهار المعاملة الجديدة
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  void _editTransaction(int index) {
    final transaction = _transactions[index];
    showDialog(
      context: context,
      builder: (context) => AddTransactionDialog(
        transaction: transaction,
        onTransactionAdded: (updatedTransaction) {
          setState(() {
            _transactions[index] = updatedTransaction;
            _updateStatistics();
          });
        },
      ),
    );
  }

  void _removeTransaction(int index) {
    setState(() {
      _transactions.removeAt(index);
      _updateStatistics();
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('تم حذف المعاملة'),
        behavior: SnackBarBehavior.floating,
        duration: Duration(seconds: 2),
      ),
    );
  }

  void _clearAllTransactions() {
    TransactionDialogs.showClearConfirmationDialog(
      context,
      onConfirm: () {
        setState(() {
          _transactions.clear();
          _updateStatistics();
        });
      },
    );
  }

  void _sendTransactionsAndFinishShift() {
    TransactionDialogs.showFinishShiftConfirmationDialog(
      context,
      totalPositive: _totalPositive,
      totalNegative: _totalNegative,
      netAmount: _netAmount,
      transactionCount: _transactions.length,
      onConfirm: () {
        // تحويل المعاملات إلى نموذج API
        final apiTransactions = _transactions
            .map((t) => t.toApiModel())
            .toList();

        // إرسال المعاملات
        viewModel.addTransaction(
          shiftId: widget.shift.store?.id ?? 0,
          transactions: apiTransactions,
        );
      },
    );
  }
}
