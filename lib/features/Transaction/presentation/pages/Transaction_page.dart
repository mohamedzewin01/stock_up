import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:stock_up/features/Shift/data/models/response/get_open_shift_model.dart';

import '../../../../core/di/di.dart';
import '../bloc/Transaction_cubit.dart';
import '../widgets/transaction_dialogs.dart';
import '../widgets/transaction_types.dart';

class TransactionPage extends StatefulWidget {
  const TransactionPage({super.key, required this.shift});

  final ShiftInfo shift;

  @override
  State<TransactionPage> createState() => _TransactionPageState();
}

class _TransactionPageState extends State<TransactionPage> {
  late TransactionCubit viewModel;
  final List<TransactionItem> _transactions = [];

  // Controllers
  final TextEditingController _amountController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();

  // State
  ShiftTransactionType _selectedType = ShiftTransactionType.cash;
  String _calculatorDisplay = '0';
  bool _isCalculatorMode = false;

  // Statistics
  double _totalPositive = 0.0;
  double _totalNegative = 0.0;
  double _netAmount = 0.0;

  // Colors
  final Color primaryColor = const Color(0xFF6366F1);
  final Color secondaryColor = const Color(0xFF8B5CF6);
  final Color successColor = const Color(0xFF10B981);
  final Color dangerColor = const Color(0xFFEF4444);

  @override
  void initState() {
    super.initState();
    viewModel = getIt.get<TransactionCubit>();
  }

  @override
  void dispose() {
    _amountController.dispose();
    _descriptionController.dispose();
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

  void _addQuickAmount(String amount) {
    if (_isCalculatorMode) {
      if (_calculatorDisplay == '0') {
        _calculatorDisplay = amount;
      } else {
        _calculatorDisplay += amount;
      }
      _amountController.text = _calculatorDisplay;
    } else {
      final currentAmount = double.tryParse(_amountController.text) ?? 0;
      final quickAmount = double.parse(amount);
      _amountController.text = (currentAmount + quickAmount).toString();
    }
    setState(() {});
  }

  void _handleCalculator(String value) {
    setState(() {
      if (value == 'C') {
        _calculatorDisplay = '0';
        _amountController.text = '0';
      } else if (value == '⌫') {
        if (_calculatorDisplay.length > 1) {
          _calculatorDisplay = _calculatorDisplay.substring(
            0,
            _calculatorDisplay.length - 1,
          );
        } else {
          _calculatorDisplay = '0';
        }
        _amountController.text = _calculatorDisplay;
      } else if (value == '.') {
        if (!_calculatorDisplay.contains('.')) {
          _calculatorDisplay += '.';
          _amountController.text = _calculatorDisplay;
        }
      } else {
        if (_calculatorDisplay == '0') {
          _calculatorDisplay = value;
        } else {
          _calculatorDisplay += value;
        }
        _amountController.text = _calculatorDisplay;
      }
    });
  }

  void _addTransaction() {
    final amount = double.tryParse(_amountController.text);
    if (amount == null || amount <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Row(
            children: const [
              Icon(Icons.warning, color: Colors.white),
              SizedBox(width: 12),
              Text('يرجى إدخال مبلغ صحيح'),
            ],
          ),
          backgroundColor: dangerColor,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      );
      return;
    }

    final transaction = TransactionItem(
      amount: amount,
      type: _selectedType,
      description: _descriptionController.text.isEmpty
          ? TransactionUtils.getDefaultDescription(_selectedType)
          : _descriptionController.text,
      timestamp: DateTime.now(),
    );

    setState(() {
      _transactions.add(transaction);
      _updateStatistics();

      // Reset
      _amountController.clear();
      _descriptionController.clear();
      _calculatorDisplay = '0';
      _isCalculatorMode = false;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: const [
            Icon(Icons.check_circle, color: Colors.white),
            SizedBox(width: 12),
            Text('تم إضافة المعاملة بنجاح'),
          ],
        ),
        backgroundColor: successColor,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        duration: const Duration(seconds: 1),
      ),
    );
  }

  void _finishShift() {
    if (_transactions.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('لا توجد معاملات لإرسالها'),
          backgroundColor: dangerColor,
          behavior: SnackBarBehavior.floating,
        ),
      );
      return;
    }

    TransactionDialogs.showFinishShiftConfirmationDialog(
      context,
      totalPositive: _totalPositive,
      totalNegative: _totalNegative,
      netAmount: _netAmount,
      transactionCount: _transactions.length,
      onConfirm: () {
        final apiTransactions = _transactions
            .map((t) => t.toApiModel())
            .toList();
        viewModel.addTransaction(
          shiftId: widget.shift.shiftId ?? 0,
          transactions: apiTransactions,
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: viewModel,
      child: BlocListener<TransactionCubit, TransactionState>(
        listener: (context, state) {
          if (state is TransactionSuccess) {
            TransactionDialogs.showSuccessDialog(
              context,
              shiftId: widget.shift.shiftId,
              totalPositive: _totalPositive,
              totalNegative: _totalNegative,
              netAmount: _netAmount,
              transactionCount: _transactions.length,
            );
          } else if (state is TransactionFailure) {
            TransactionDialogs.showErrorDialog(
              context,
              state.exception.toString(),
            );
          }
        },
        child: Scaffold(
          backgroundColor: const Color(0xFFF5F7FA),
          body: SafeArea(
            child: Column(
              children: [
                _buildHeader(),
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      children: [
                        _buildStatsCard(),
                        const SizedBox(height: 16),
                        _buildQuickInputCard(),
                        const SizedBox(height: 16),
                        _buildTransactionsList(),
                      ],
                    ),
                  ),
                ),
                _buildBottomBar(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(colors: [primaryColor, secondaryColor]),
        boxShadow: [
          BoxShadow(
            color: primaryColor.withOpacity(0.3),
            blurRadius: 15,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            children: [
              IconButton(
                onPressed: () => Navigator.pop(context),
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
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'إدارة المعاملات',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'وردية #${widget.shift.shiftId ?? 'N/A'}',
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.white.withOpacity(0.9),
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 8,
                ),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(
                  children: [
                    const Icon(
                      Icons.receipt_long,
                      color: Colors.white,
                      size: 18,
                    ),
                    const SizedBox(width: 6),
                    Text(
                      '${_transactions.length}',
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStatsCard() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            primaryColor.withOpacity(0.1),
            secondaryColor.withOpacity(0.05),
          ],
        ),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: primaryColor.withOpacity(0.2)),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Icon(Icons.analytics_rounded, color: primaryColor, size: 24),
              const SizedBox(width: 12),
              const Text(
                'الملخص المالي',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: _buildStatItem(
                  'الدخل',
                  _totalPositive,
                  successColor,
                  Icons.arrow_upward_rounded,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildStatItem(
                  'المصروفات',
                  _totalNegative,
                  dangerColor,
                  Icons.arrow_downward_rounded,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: _netAmount >= 0
                  ? successColor.withOpacity(0.1)
                  : dangerColor.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: _netAmount >= 0 ? successColor : dangerColor,
                width: 2,
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Icon(
                      _netAmount >= 0 ? Icons.trending_up : Icons.trending_down,
                      color: _netAmount >= 0 ? successColor : dangerColor,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      'الصافي',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: _netAmount >= 0 ? successColor : dangerColor,
                      ),
                    ),
                  ],
                ),
                Text(
                  '${_netAmount >= 0 ? '+' : ''}${_netAmount.toStringAsFixed(2)} ر.س',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w900,
                    color: _netAmount >= 0 ? successColor : dangerColor,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatItem(
    String label,
    double value,
    Color color,
    IconData icon,
  ) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Column(
        children: [
          Icon(icon, color: color, size: 20),
          const SizedBox(height: 8),
          Text(label, style: TextStyle(fontSize: 12, color: color)),
          const SizedBox(height: 4),
          Text(
            value.toStringAsFixed(2),
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQuickInputCard() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 15,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.add_circle_outline, color: primaryColor),
              const SizedBox(width: 12),
              const Text(
                'إضافة معاملة سريعة',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ],
          ),
          const SizedBox(height: 16),

          // Type Selector
          const Text(
            'نوع المعاملة',
            style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 8),
          _buildTypeSelector(),

          const SizedBox(height: 16),

          // Amount Input
          const Text(
            'المبلغ',
            style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 8),
          _buildAmountInput(),

          const SizedBox(height: 12),

          // Quick Amount Buttons
          _buildQuickAmountButtons(),

          const SizedBox(height: 12),

          // Calculator Toggle
          Row(
            children: [
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: () {
                    setState(() {
                      _isCalculatorMode = !_isCalculatorMode;
                      if (!_isCalculatorMode) {
                        _calculatorDisplay = '0';
                      }
                    });
                  },
                  icon: Icon(
                    _isCalculatorMode ? Icons.keyboard : Icons.calculate,
                    size: 18,
                  ),
                  label: Text(_isCalculatorMode ? 'إخفاء الآلة' : 'آلة حاسبة'),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: primaryColor,
                    side: BorderSide(color: primaryColor),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
              ),
            ],
          ),

          if (_isCalculatorMode) ...[
            const SizedBox(height: 12),
            _buildCalculator(),
          ],

          const SizedBox(height: 16),

          // Description (Optional)
          const Text(
            'الوصف (اختياري)',
            style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 8),
          TextField(
            controller: _descriptionController,
            decoration: InputDecoration(
              hintText: 'أدخل وصف المعاملة',
              prefixIcon: Icon(Icons.notes, color: primaryColor),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(color: Color(0xFFE2E8F0)),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(color: primaryColor, width: 2),
              ),
            ),
          ),

          const SizedBox(height: 20),

          // Add Button
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: _addTransaction,
              icon: const Icon(Icons.add, size: 24),
              label: const Text(
                'إضافة المعاملة',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: _selectedType.color,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                elevation: 2,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTypeSelector() {
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: ShiftTransactionType.values.take(6).map((type) {
        final isSelected = type == _selectedType;
        return GestureDetector(
          onTap: () => setState(() => _selectedType = type),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
              color: isSelected
                  ? type.color.withOpacity(0.15)
                  : Colors.grey[100],
              borderRadius: BorderRadius.circular(10),
              border: Border.all(
                color: isSelected ? type.color : Colors.grey[300]!,
                width: isSelected ? 2 : 1,
              ),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  type.icon,
                  size: 18,
                  color: isSelected ? type.color : Colors.grey[600],
                ),
                const SizedBox(width: 6),
                Text(
                  type.displayName,
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: isSelected
                        ? FontWeight.bold
                        : FontWeight.normal,
                    color: isSelected ? type.color : Colors.grey[700],
                  ),
                ),
              ],
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildAmountInput() {
    return TextField(
      controller: _amountController,
      keyboardType: TextInputType.number,
      style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
      decoration: InputDecoration(
        hintText: '0.00',
        prefixIcon: Icon(
          Icons.attach_money,
          color: _selectedType.color,
          size: 28,
        ),
        suffixText: 'ر.س',
        suffixStyle: TextStyle(
          fontSize: 16,
          color: Colors.grey[600],
          fontWeight: FontWeight.bold,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Color(0xFFE2E8F0)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: _selectedType.color, width: 2),
        ),
        filled: true,
        fillColor: _selectedType.color.withOpacity(0.05),
      ),
    );
  }

  Widget _buildQuickAmountButtons() {
    final amounts = ['50', '100', '200', '500', '1000'];
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: amounts.map((amount) {
        return InkWell(
          onTap: () => _addQuickAmount(amount),
          borderRadius: BorderRadius.circular(10),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  primaryColor.withOpacity(0.1),
                  secondaryColor.withOpacity(0.05),
                ],
              ),
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: primaryColor.withOpacity(0.3)),
            ),
            child: Text(
              '+$amount',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: primaryColor,
              ),
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildCalculator() {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          GridView.count(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            crossAxisCount: 4,
            mainAxisSpacing: 8,
            crossAxisSpacing: 8,
            children:
                [
                  '7',
                  '8',
                  '9',
                  'C',
                  '4',
                  '5',
                  '6',
                  '⌫',
                  '1',
                  '2',
                  '3',
                  '.',
                  '0',
                  '00',
                ].map((key) {
                  return InkWell(
                    onTap: () => _handleCalculator(key),
                    borderRadius: BorderRadius.circular(8),
                    child: Container(
                      decoration: BoxDecoration(
                        color: ['C', '⌫'].contains(key)
                            ? dangerColor.withOpacity(0.1)
                            : Colors.white,
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: Colors.grey[300]!),
                      ),
                      child: Center(
                        child: Text(
                          key,
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: ['C', '⌫'].contains(key)
                                ? dangerColor
                                : Colors.grey[800],
                          ),
                        ),
                      ),
                    ),
                  );
                }).toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildTransactionsList() {
    if (_transactions.isEmpty) {
      return Container(
        padding: const EdgeInsets.all(40),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Column(
          children: [
            Icon(
              Icons.receipt_long_outlined,
              size: 64,
              color: Colors.grey[400],
            ),
            const SizedBox(height: 16),
            Text(
              'لا توجد معاملات بعد',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.grey[700],
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'ابدأ بإضافة معاملات جديدة',
              style: TextStyle(fontSize: 14, color: Colors.grey[500]),
            ),
          ],
        ),
      );
    }

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Icon(Icons.list_alt, color: primaryColor),
                const SizedBox(width: 12),
                const Text(
                  'قائمة المعاملات',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const Spacer(),
                Text(
                  '${_transactions.length} معاملة',
                  style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                ),
              ],
            ),
          ),
          const Divider(height: 1),
          ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: _transactions.length,
            separatorBuilder: (context, index) => const Divider(height: 1),
            itemBuilder: (context, index) {
              final transaction = _transactions[index];
              return Dismissible(
                key: Key('transaction_$index'),
                direction: DismissDirection.endToStart,
                background: Container(
                  color: dangerColor,
                  alignment: Alignment.centerLeft,
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: const Icon(Icons.delete, color: Colors.white),
                ),
                onDismissed: (direction) {
                  setState(() {
                    _transactions.removeAt(index);
                    _updateStatistics();
                  });
                },
                child: ListTile(
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 8,
                  ),
                  leading: Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: transaction.type.color.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Icon(
                      transaction.type.icon,
                      color: transaction.type.color,
                    ),
                  ),
                  title: Text(
                    transaction.description,
                    style: const TextStyle(fontWeight: FontWeight.w600),
                  ),
                  subtitle: Text(
                    TransactionUtils.formatTime(transaction.timestamp),
                    style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                  ),
                  trailing: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        '${transaction.isPositive ? '+' : '-'}${transaction.amount.toStringAsFixed(2)}',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: transaction.type.color,
                        ),
                      ),
                      Text(
                        transaction.type.displayName,
                        style: TextStyle(fontSize: 10, color: Colors.grey[600]),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildBottomBar() {
    return BlocBuilder<TransactionCubit, TransactionState>(
      builder: (context, state) {
        final isLoading = state is TransactionLoading;
        return Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 10,
                offset: const Offset(0, -2),
              ),
            ],
          ),
          child: SafeArea(
            child: SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: isLoading || _transactions.isEmpty
                    ? null
                    : _finishShift,
                icon: isLoading
                    ? const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(
                          color: Colors.white,
                          strokeWidth: 2,
                        ),
                      )
                    : const Icon(Icons.send_rounded, size: 24),
                label: Text(
                  isLoading ? 'جاري الإرسال...' : 'إنهاء الوردية وإرسال',
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: successColor,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  elevation: 0,
                  disabledBackgroundColor: Colors.grey[300],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
