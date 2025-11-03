// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:stock_up/features/Shift/data/models/response/get_open_shift_model.dart';
//
// import '../../../../core/di/di.dart';
// import '../bloc/Transaction_cubit.dart';
// import '../widgets/add_transaction_dialog.dart';
// import '../widgets/transaction_bottom_bar.dart';
// import '../widgets/transaction_dialogs.dart';
// import '../widgets/transaction_empty_state.dart';
// import '../widgets/transaction_list.dart';
// import '../widgets/transaction_statistics_card.dart';
// import '../widgets/transaction_types.dart';
//
// class TransactionPage extends StatefulWidget {
//   const TransactionPage({super.key, required this.shift});
//
//   final ShiftInfo shift;
//
//   @override
//   State<TransactionPage> createState() => _TransactionPageState();
// }
//
// class _TransactionPageState extends State<TransactionPage> {
//   late TransactionCubit viewModel;
//   final List<TransactionItem> _transactions = [];
//   final ScrollController _scrollController = ScrollController();
//
//   // إحصائيات المعاملات
//   double _totalPositive = 0.0;
//   double _totalNegative = 0.0;
//   double _netAmount = 0.0;
//
//   @override
//   void initState() {
//     viewModel = getIt.get<TransactionCubit>();
//     super.initState();
//   }
//
//   @override
//   void dispose() {
//     _scrollController.dispose();
//     super.dispose();
//   }
//
//   void _updateStatistics() {
//     _totalPositive = _transactions
//         .where((t) => t.type.isPositive)
//         .fold(0.0, (sum, t) => sum + t.amount);
//
//     _totalNegative = _transactions
//         .where((t) => !t.type.isPositive)
//         .fold(0.0, (sum, t) => sum + t.amount);
//
//     _netAmount = _totalPositive - _totalNegative;
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     final screenWidth = MediaQuery.of(context).size.width;
//     final isTablet = screenWidth > 600;
//
//     return BlocProvider.value(
//       value: viewModel,
//       child: BlocListener<TransactionCubit, TransactionState>(
//         listener: (context, state) {
//           if (state is TransactionSuccess) {
//             TransactionDialogs.showSuccessDialog(context);
//           } else if (state is TransactionFailure) {
//             TransactionDialogs.showErrorDialog(
//               context,
//               state.exception.toString(),
//             );
//           }
//         },
//         child: Scaffold(
//           backgroundColor: const Color(0xFFF8F9FA),
//           appBar: _buildAppBar(isTablet),
//           body: Column(
//             children: [
//               // إحصائيات المعاملات
//               TransactionStatisticsCard(
//                 totalPositive: _totalPositive,
//                 totalNegative: _totalNegative,
//                 netAmount: _netAmount,
//                 transactionCount: _transactions.length,
//                 isTablet: isTablet,
//               ),
//
//               // قائمة المعاملات
//               Expanded(
//                 child: _transactions.isEmpty
//                     ? TransactionEmptyState(
//                         isTablet: isTablet,
//                         onAddTransaction: _showAddTransactionDialog,
//                       )
//                     : TransactionList(
//                         transactions: _transactions,
//                         scrollController: _scrollController,
//                         isTablet: isTablet,
//                         onEditTransaction: _editTransaction,
//                         onRemoveTransaction: _removeTransaction,
//                       ),
//               ),
//
//               // شريط الإجراءات السفلي
//               TransactionBottomBar(
//                 hasTransactions: _transactions.isNotEmpty,
//                 totalPositive: _totalPositive,
//                 totalNegative: _totalNegative,
//                 netAmount: _netAmount,
//                 transactionCount: _transactions.length,
//                 isTablet: isTablet,
//                 onClearAll: _clearAllTransactions,
//                 onFinishShift: _sendTransactionsAndFinishShift,
//               ),
//             ],
//           ),
//           floatingActionButton: FloatingActionButton(
//             onPressed: _showAddTransactionDialog,
//             backgroundColor: const Color(0xFF007AFF),
//             child: const Icon(Icons.add, color: Colors.white),
//           ),
//         ),
//       ),
//     );
//   }
//
//   PreferredSizeWidget _buildAppBar(bool isTablet) {
//     return AppBar(
//       backgroundColor: Colors.white,
//       elevation: 0,
//       centerTitle: true,
//       leading: IconButton(
//         onPressed: () => Navigator.of(context).pop(),
//         icon: Icon(
//           Icons.arrow_back_ios,
//           color: const Color(0xFF1A1A1A),
//           size: isTablet ? 24 : 20,
//         ),
//       ),
//       title: Column(
//         children: [
//           Text(
//             'إدارة المعاملات',
//             style: TextStyle(
//               fontSize: isTablet ? 20 : 18,
//               fontWeight: FontWeight.bold,
//               color: const Color(0xFF1A1A1A),
//             ),
//           ),
//           if (widget.shift.shiftId != null) ...[
//             Text(
//               'وردية #${widget.shift.shiftId}',
//               style: TextStyle(
//                 fontSize: isTablet ? 12 : 10,
//                 color: const Color(0xFF666666),
//               ),
//             ),
//           ],
//         ],
//       ),
//       actions: [
//         if (_transactions.isNotEmpty)
//           IconButton(
//             onPressed: _clearAllTransactions,
//             icon: Icon(
//               Icons.clear_all,
//               color: const Color(0xFFFF3B30),
//               size: isTablet ? 24 : 20,
//             ),
//             tooltip: 'مسح جميع المعاملات',
//           ),
//         const SizedBox(width: 8),
//       ],
//       bottom: PreferredSize(
//         preferredSize: const Size.fromHeight(1),
//         child: Container(height: 1, color: const Color(0xFFE5E5E5)),
//       ),
//     );
//   }
//
//   void _showAddTransactionDialog() {
//     showDialog(
//       context: context,
//       builder: (context) =>
//           AddTransactionDialog(onTransactionAdded: _addTransaction),
//     );
//   }
//
//   void _addTransaction(TransactionItem transaction) {
//     setState(() {
//       _transactions.add(transaction);
//       _updateStatistics();
//     });
//
//     // تحريك القائمة للأسفل لإظهار المعاملة الجديدة
//     WidgetsBinding.instance.addPostFrameCallback((_) {
//       if (_scrollController.hasClients) {
//         _scrollController.animateTo(
//           _scrollController.position.maxScrollExtent,
//           duration: const Duration(milliseconds: 300),
//           curve: Curves.easeOut,
//         );
//       }
//     });
//   }
//
//   void _editTransaction(int index) {
//     final transaction = _transactions[index];
//     showDialog(
//       context: context,
//       builder: (context) => AddTransactionDialog(
//         transaction: transaction,
//         onTransactionAdded: (updatedTransaction) {
//           setState(() {
//             _transactions[index] = updatedTransaction;
//             _updateStatistics();
//           });
//         },
//       ),
//     );
//   }
//
//   void _removeTransaction(int index) {
//     setState(() {
//       _transactions.removeAt(index);
//       _updateStatistics();
//     });
//
//     ScaffoldMessenger.of(context).showSnackBar(
//       const SnackBar(
//         content: Text('تم حذف المعاملة'),
//         behavior: SnackBarBehavior.floating,
//         duration: Duration(seconds: 2),
//       ),
//     );
//   }
//
//   void _clearAllTransactions() {
//     TransactionDialogs.showClearConfirmationDialog(
//       context,
//       onConfirm: () {
//         setState(() {
//           _transactions.clear();
//           _updateStatistics();
//         });
//       },
//     );
//   }
//
//   void _sendTransactionsAndFinishShift() {
//     TransactionDialogs.showFinishShiftConfirmationDialog(
//       context,
//       totalPositive: _totalPositive,
//       totalNegative: _totalNegative,
//       netAmount: _netAmount,
//       transactionCount: _transactions.length,
//       onConfirm: () {
//         // تحويل المعاملات إلى نموذج API
//         final apiTransactions = _transactions
//             .map((t) => t.toApiModel())
//             .toList();
//
//         // إرسال المعاملات
//         viewModel.addTransaction(
//           shiftId: widget.shift.shiftId ?? 0,
//           transactions: apiTransactions,
//         );
//       },
//     );
//   }
// }
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:stock_up/features/Shift/data/models/response/get_open_shift_model.dart';

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

  final ShiftInfo shift;

  @override
  State<TransactionPage> createState() => _TransactionPageState();
}

class _TransactionPageState extends State<TransactionPage>
    with SingleTickerProviderStateMixin {
  late TransactionCubit viewModel;
  final List<TransactionItem> _transactions = [];
  final ScrollController _scrollController = ScrollController();
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  // إحصائيات المعاملات
  double _totalPositive = 0.0;
  double _totalNegative = 0.0;
  double _netAmount = 0.0;

  @override
  void initState() {
    super.initState();
    viewModel = getIt.get<TransactionCubit>();

    // Animation setup
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeIn),
    );

    _slideAnimation =
        Tween<Offset>(begin: const Offset(0, 0.1), end: Offset.zero).animate(
          CurvedAnimation(
            parent: _animationController,
            curve: Curves.easeOutCubic,
          ),
        );

    _animationController.forward();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _animationController.dispose();
    super.dispose();
  }

  void _updateStatistics() {
    setState(() {
      _totalPositive = _transactions
          .where((t) => t.type.isPositive)
          .fold(0.0, (sum, t) => sum + t.amount);

      _totalNegative = _transactions
          .where((t) => !t.type.isPositive)
          .fold(0.0, (sum, t) => sum + t.amount);

      _netAmount = _totalPositive - _totalNegative;
    });
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
          backgroundColor: const Color(0xFFF5F7FA),
          body: CustomScrollView(
            physics: const BouncingScrollPhysics(),
            slivers: [
              _buildSliverAppBar(isTablet),
              SliverToBoxAdapter(
                child: FadeTransition(
                  opacity: _fadeAnimation,
                  child: SlideTransition(
                    position: _slideAnimation,
                    child: Column(
                      children: [
                        const SizedBox(height: 8),
                        // بطاقة معلومات الوردية
                        _buildShiftInfoCard(isTablet),
                        const SizedBox(height: 16),
                        // إحصائيات المعاملات
                        TransactionStatisticsCard(
                          totalPositive: _totalPositive,
                          totalNegative: _totalNegative,
                          netAmount: _netAmount,
                          transactionCount: _transactions.length,
                          isTablet: isTablet,
                        ),
                        const SizedBox(height: 16),
                      ],
                    ),
                  ),
                ),
              ),
              // قائمة المعاملات
              _transactions.isEmpty
                  ? SliverFillRemaining(
                      hasScrollBody: false,
                      child: TransactionEmptyState(
                        isTablet: isTablet,
                        onAddTransaction: _showAddTransactionDialog,
                      ),
                    )
                  : SliverPadding(
                      padding: EdgeInsets.symmetric(
                        horizontal: isTablet ? 20 : 16,
                      ),
                      sliver: TransactionList(
                        transactions: _transactions,
                        scrollController: _scrollController,
                        isTablet: isTablet,
                        onEditTransaction: _editTransaction,
                        onRemoveTransaction: _removeTransaction,
                      ),
                    ),
              const SliverToBoxAdapter(child: SizedBox(height: 100)),
            ],
          ),
          bottomNavigationBar: TransactionBottomBar(
            hasTransactions: _transactions.isNotEmpty,
            totalPositive: _totalPositive,
            totalNegative: _totalNegative,
            netAmount: _netAmount,
            transactionCount: _transactions.length,
            isTablet: isTablet,
            onClearAll: _clearAllTransactions,
            onFinishShift: _sendTransactionsAndFinishShift,
          ),
          floatingActionButton: _buildFloatingActionButton(isTablet),
          floatingActionButtonLocation:
              FloatingActionButtonLocation.centerFloat,
        ),
      ),
    );
  }

  Widget _buildSliverAppBar(bool isTablet) {
    return SliverAppBar(
      expandedHeight: 120,
      floating: false,
      pinned: true,
      elevation: 0,
      backgroundColor: Colors.transparent,
      flexibleSpace: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Color(0xFF667EEA), Color(0xFF764BA2)],
          ),
        ),
        child: FlexibleSpaceBar(
          centerTitle: true,
          title: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'إدارة المعاملات',
                style: TextStyle(
                  fontSize: isTablet ? 18 : 14,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                  shadows: [
                    Shadow(
                      color: Colors.black.withOpacity(0.2),
                      offset: const Offset(0, 2),
                      blurRadius: 4,
                    ),
                  ],
                ),
              ),
              if (widget.shift.shiftId != null) ...[
                const SizedBox(height: 2),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 2,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    'وردية #${widget.shift.shiftId}',
                    style: TextStyle(
                      fontSize: isTablet ? 11 : 10,
                      color: Colors.white,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
      leading: IconButton(
        onPressed: () => Navigator.of(context).pop(),
        icon: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.2),
            borderRadius: BorderRadius.circular(10),
          ),
          child: const Icon(
            Icons.arrow_back_ios_new,
            color: Colors.white,
            size: 18,
          ),
        ),
      ),
      actions: [
        if (_transactions.isNotEmpty)
          IconButton(
            onPressed: _clearAllTransactions,
            icon: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.red.withOpacity(0.2),
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Icon(
                Icons.delete_sweep,
                color: Colors.white,
                size: 20,
              ),
            ),
            tooltip: 'مسح الكل',
          ),
        const SizedBox(width: 8),
      ],
    );
  }

  Widget _buildShiftInfoCard(bool isTablet) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: isTablet ? 20 : 16),
      padding: EdgeInsets.all(isTablet ? 20 : 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFF667EEA), Color(0xFF764BA2)],
              ),
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(Icons.access_time, color: Colors.white, size: 24),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'وردية نشطة',
                  style: TextStyle(
                    fontSize: isTablet ? 16 : 14,
                    fontWeight: FontWeight.bold,
                    color: const Color(0xFF2D3748),
                  ),
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    Container(
                      width: 8,
                      height: 8,
                      decoration: const BoxDecoration(
                        color: Color(0xFF48BB78),
                        shape: BoxShape.circle,
                      ),
                    ),
                    const SizedBox(width: 6),
                    Text(
                      'جارية الآن',
                      style: TextStyle(
                        fontSize: isTablet ? 13 : 11,
                        color: const Color(0xFF718096),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                '${_transactions.length}',
                style: TextStyle(
                  fontSize: isTablet ? 24 : 20,
                  fontWeight: FontWeight.bold,
                  color: const Color(0xFF667EEA),
                ),
              ),
              Text(
                'معاملة',
                style: TextStyle(
                  fontSize: isTablet ? 12 : 10,
                  color: const Color(0xFF718096),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildFloatingActionButton(bool isTablet) {
    return Container(
      height: isTablet ? 70 : 60,
      width: isTablet ? 70 : 60,
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFF667EEA), Color(0xFF764BA2)],
        ),
        borderRadius: BorderRadius.circular(isTablet ? 20 : 16),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF667EEA).withOpacity(0.4),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: _showAddTransactionDialog,
          borderRadius: BorderRadius.circular(isTablet ? 20 : 16),
          child: Icon(
            Icons.add_rounded,
            color: Colors.white,
            size: isTablet ? 32 : 28,
          ),
        ),
      ),
    );
  }

  void _showAddTransactionDialog() {
    showGeneralDialog(
      context: context,
      barrierDismissible: true,
      barrierLabel: '',
      barrierColor: Colors.black.withOpacity(0.5),
      transitionDuration: const Duration(milliseconds: 300),
      pageBuilder: (context, animation, secondaryAnimation) {
        return AddTransactionDialog(onTransactionAdded: _addTransaction);
      },
      transitionBuilder: (context, animation, secondaryAnimation, child) {
        return ScaleTransition(
          scale: Tween<double>(begin: 0.8, end: 1.0).animate(
            CurvedAnimation(parent: animation, curve: Curves.easeOutBack),
          ),
          child: FadeTransition(opacity: animation, child: child),
        );
      },
    );
  }

  void _addTransaction(TransactionItem transaction) {
    setState(() {
      _transactions.add(transaction);
      _updateStatistics();
    });

    // عرض رسالة نجاح
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.2),
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Icon(
                Icons.check_circle,
                color: Colors.white,
                size: 20,
              ),
            ),
            const SizedBox(width: 12),
            const Expanded(
              child: Text(
                'تم إضافة المعاملة بنجاح',
                style: TextStyle(fontWeight: FontWeight.w600),
              ),
            ),
          ],
        ),
        backgroundColor: const Color(0xFF48BB78),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        duration: const Duration(seconds: 2),
      ),
    );

    // تحريك القائمة للأسفل
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 400),
          curve: Curves.easeOutCubic,
        );
      }
    });
  }

  void _editTransaction(int index) {
    final transaction = _transactions[index];
    showGeneralDialog(
      context: context,
      barrierDismissible: true,
      barrierLabel: '',
      barrierColor: Colors.black.withOpacity(0.5),
      transitionDuration: const Duration(milliseconds: 300),
      pageBuilder: (context, animation, secondaryAnimation) {
        return AddTransactionDialog(
          transaction: transaction,
          onTransactionAdded: (updatedTransaction) {
            setState(() {
              _transactions[index] = updatedTransaction;
              _updateStatistics();
            });

            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: const Row(
                  children: [
                    Icon(Icons.edit, color: Colors.white, size: 20),
                    SizedBox(width: 12),
                    Text(
                      'تم تعديل المعاملة بنجاح',
                      style: TextStyle(fontWeight: FontWeight.w600),
                    ),
                  ],
                ),
                backgroundColor: const Color(0xFF667EEA),
                behavior: SnackBarBehavior.floating,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            );
          },
        );
      },
      transitionBuilder: (context, animation, secondaryAnimation, child) {
        return ScaleTransition(
          scale: Tween<double>(begin: 0.8, end: 1.0).animate(
            CurvedAnimation(parent: animation, curve: Curves.easeOutBack),
          ),
          child: FadeTransition(opacity: animation, child: child),
        );
      },
    );
  }

  void _removeTransaction(int index) {
    final removedTransaction = _transactions[index];

    setState(() {
      _transactions.removeAt(index);
      _updateStatistics();
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Row(
          children: [
            Icon(Icons.delete, color: Colors.white, size: 20),
            SizedBox(width: 12),
            Text(
              'تم حذف المعاملة',
              style: TextStyle(fontWeight: FontWeight.w600),
            ),
          ],
        ),
        backgroundColor: const Color(0xFFFC8181),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        action: SnackBarAction(
          label: 'تراجع',
          textColor: Colors.white,
          onPressed: () {
            setState(() {
              _transactions.insert(index, removedTransaction);
              _updateStatistics();
            });
          },
        ),
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

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Row(
              children: [
                Icon(Icons.clear_all, color: Colors.white, size: 20),
                SizedBox(width: 12),
                Text(
                  'تم مسح جميع المعاملات',
                  style: TextStyle(fontWeight: FontWeight.w600),
                ),
              ],
            ),
            backgroundColor: const Color(0xFFFC8181),
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
        );
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
          shiftId: widget.shift.shiftId ?? 0,
          transactions: apiTransactions,
        );
      },
    );
  }
}
