// lib/features/Transaction/presentation/widgets/add_transaction_dialog.dart
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'transaction_types.dart';
import 'transaction_type_selector.dart';

class AddTransactionDialog extends StatefulWidget {
  final TransactionItem? transaction;
  final Function(TransactionItem) onTransactionAdded;

  const AddTransactionDialog({
    super.key,
    this.transaction,
    required this.onTransactionAdded,
  });

  @override
  State<AddTransactionDialog> createState() => _AddTransactionDialogState();
}

class _AddTransactionDialogState extends State<AddTransactionDialog>
    with SingleTickerProviderStateMixin {
  final TextEditingController _amountController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  ShiftTransactionType _selectedType = ShiftTransactionType.cash;
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();

    _animationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );

    _scaleAnimation = Tween<double>(
      begin: 0.8,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeOutBack,
    ));

    _animationController.forward();

    // تعبئة البيانات في حالة التعديل
    if (widget.transaction != null) {
      _amountController.text = widget.transaction!.amount.toString();
      _descriptionController.text = widget.transaction!.description;
      _selectedType = widget.transaction!.type;
    }
  }

  @override
  void dispose() {
    _animationController.dispose();
    _amountController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isTablet = screenWidth > 600;

    return ScaleTransition(
      scale: _scaleAnimation,
      child: Dialog(
        backgroundColor: Colors.transparent,
        insetPadding: EdgeInsets.all(isTablet ? 40 : 20),
        child: Container(
          constraints: BoxConstraints(
            maxWidth: isTablet ? 500 : double.infinity,
          ),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: const Color(0xFF000000).withOpacity(0.2),
                blurRadius: 20,
                offset: const Offset(0, 10),
              ),
            ],
          ),
          child: SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.all(isTablet ? 32 : 24),
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    _buildHeader(isTablet),
                    SizedBox(height: isTablet ? 24 : 20),

                    TransactionTypeSelector(
                      selectedType: _selectedType,
                      isTablet: isTablet,
                      onTypeSelected: (type) {
                        setState(() {
                          _selectedType = type;
                        });
                      },
                    ),
                    SizedBox(height: isTablet ? 20 : 16),

                    _buildAmountInput(isTablet),
                    SizedBox(height: isTablet ? 20 : 16),

                    _buildDescriptionInput(isTablet),
                    SizedBox(height: isTablet ? 32 : 24),

                    _buildActionButtons(isTablet),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(bool isTablet) {
    final isEditing = widget.transaction != null;

    return Column(
      children: [
        Container(
          width: isTablet ? 80 : 64,
          height: isTablet ? 80 : 64,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [_selectedType.color, _selectedType.color.withOpacity(0.7)],
            ),
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: _selectedType.color.withOpacity(0.3),
                blurRadius: 15,
                offset: const Offset(0, 5),
              ),
            ],
          ),
          child: Icon(
            _selectedType.icon,
            size: isTablet ? 40 : 32,
            color: Colors.white,
          ),
        ),

        SizedBox(height: isTablet ? 16 : 12),

        Text(
          isEditing ? 'تعديل المعاملة' : 'إضافة معاملة جديدة',
          style: TextStyle(
            fontSize: isTablet ? 24 : 20,
            fontWeight: FontWeight.bold,
            color: const Color(0xFF1A1A1A),
          ),
        ),

        const SizedBox(height: 8),

        Text(
          'اختر نوع المعاملة وأدخل التفاصيل',
          style: TextStyle(
            fontSize: isTablet ? 14 : 12,
            color: const Color(0xFF666666),
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  Widget _buildAmountInput(bool isTablet) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'المبلغ',
          style: TextStyle(
            fontSize: isTablet ? 16 : 14,
            fontWeight: FontWeight.w600,
            color: const Color(0xFF1A1A1A),
          ),
        ),

        const SizedBox(height: 8),

        TextFormField(
          controller: _amountController,
          keyboardType: const TextInputType.numberWithOptions(decimal: true),
          inputFormatters: [
            FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d*')),
          ],
          decoration: InputDecoration(
            hintText: 'ادخل المبلغ',
            hintStyle: TextStyle(
              color: const Color(0xFF999999),
              fontSize: isTablet ? 14 : 12,
            ),
            prefixIcon: Icon(
              Icons.attach_money,
              color: _selectedType.color,
              size: isTablet ? 24 : 20,
            ),
            suffixText: 'ر.س',
            suffixStyle: TextStyle(
              color: const Color(0xFF666666),
              fontSize: isTablet ? 14 : 12,
              fontWeight: FontWeight.w500,
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: Color(0xFFE5E5E5)),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: Color(0xFFE5E5E5)),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: _selectedType.color, width: 2),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: Colors.red),
            ),
            filled: true,
            fillColor: const Color(0xFFF8F9FA),
            contentPadding: EdgeInsets.symmetric(
              horizontal: isTablet ? 16 : 14,
              vertical: isTablet ? 16 : 12,
            ),
          ),
          style: TextStyle(
            fontSize: isTablet ? 16 : 14,
            fontWeight: FontWeight.w600,
            color: const Color(0xFF1A1A1A),
          ),
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'يرجى إدخال المبلغ';
            }
            final amount = double.tryParse(value);
            if (amount == null) {
              return 'يرجى إدخال رقم صحيح';
            }
            if (amount <= 0) {
              return 'المبلغ يجب أن يكون أكبر من صفر';
            }
            return null;
          },
        ),
      ],
    );
  }

  Widget _buildDescriptionInput(bool isTablet) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'وصف المعاملة',
          style: TextStyle(
            fontSize: isTablet ? 16 : 14,
            fontWeight: FontWeight.w600,
            color: const Color(0xFF1A1A1A),
          ),
        ),

        const SizedBox(height: 8),

        TextFormField(
          controller: _descriptionController,
          maxLines: 3,
          decoration: InputDecoration(
            hintText: 'ادخل وصف المعاملة (اختياري)',
            hintStyle: TextStyle(
              color: const Color(0xFF999999),
              fontSize: isTablet ? 14 : 12,
            ),
            prefixIcon: Padding(
              padding: const EdgeInsets.only(bottom: 32),
              child: Icon(
                Icons.description,
                color: _selectedType.color,
                size: isTablet ? 24 : 20,
              ),
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: Color(0xFFE5E5E5)),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: Color(0xFFE5E5E5)),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: _selectedType.color, width: 2),
            ),
            filled: true,
            fillColor: const Color(0xFFF8F9FA),
            contentPadding: EdgeInsets.all(isTablet ? 16 : 14),
          ),
          style: TextStyle(
            fontSize: isTablet ? 14 : 12,
            color: const Color(0xFF1A1A1A),
          ),
        ),
      ],
    );
  }

  Widget _buildActionButtons(bool isTablet) {
    final isEditing = widget.transaction != null;

    return Row(
      children: [
        Expanded(
          child: TextButton(
            onPressed: () => Navigator.of(context).pop(),
            style: TextButton.styleFrom(
              padding: EdgeInsets.symmetric(
                vertical: isTablet ? 16 : 12,
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: Text(
              'إلغاء',
              style: TextStyle(
                fontSize: isTablet ? 16 : 14,
                fontWeight: FontWeight.w600,
                color: const Color(0xFF666666),
              ),
            ),
          ),
        ),

        const SizedBox(width: 16),

        Expanded(
          flex: 2,
          child: ElevatedButton(
            onPressed: _saveTransaction,
            style: ElevatedButton.styleFrom(
              backgroundColor: _selectedType.color,
              foregroundColor: Colors.white,
              elevation: 0,
              padding: EdgeInsets.symmetric(
                vertical: isTablet ? 16 : 12,
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: Text(
              isEditing ? 'حفظ التعديل' : 'إضافة المعاملة',
              style: TextStyle(
                fontSize: isTablet ? 16 : 14,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ),
      ],
    );
  }

  void _saveTransaction() {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    final amount = double.parse(_amountController.text);
    final description = _descriptionController.text.isEmpty
        ? TransactionUtils.getDefaultDescription(_selectedType)
        : _descriptionController.text;

    final transaction = TransactionItem(
      amount: amount,
      type: _selectedType,
      description: description,
      timestamp: DateTime.now(),
    );

    widget.onTransactionAdded(transaction);
    Navigator.of(context).pop();
  }
}