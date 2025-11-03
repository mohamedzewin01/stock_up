import 'package:flutter/material.dart';
import 'package:stock_up/features/Transaction/data/models/request/add_transaction_request.dart';

// أنواع المعاملات المتاحة للوردية
enum ShiftTransactionType {
  // ========== معاملات إيجابية (مبيعات ودخل) ==========
  cash('نقدية', Icons.money, Color(0xFF28A745)),
  visaSale('بيع فيزا', Icons.credit_card, Color(0xFF007AFF)),
  deferredSale('بيع آجل', Icons.schedule, Color(0xFFFF9500)),
  collectDebt(
    'قبض دين من عميل',
    Icons.account_balance_wallet,
    Color(0xFF16A085),
  ),

  // ========== معاملات سلبية (مصروفات) ==========
  expenses('مصروفات الوردية', Icons.remove_circle, Color(0xFFFF3B30)),
  purchaseGoods('شراء بضاعة', Icons.shopping_cart, Color(0xFFE74C3C)),
  paySupplier('سداد مورد', Icons.account_balance, Color(0xFFC0392B)),
  payBills('سداد فواتير', Icons.receipt, Color(0xFF95A5A6)),
  payObligation('سداد التزام', Icons.assignment, Color(0xFF8E44AD)),
  returns('مرتجع', Icons.undo, Color(0xFF6C757D)),
  other('أخرى', Icons.more_horiz, Color(0xFF34495E));

  const ShiftTransactionType(this.displayName, this.icon, this.color);

  final String displayName;
  final IconData icon;
  final Color color;

  /// تحديد إذا كانت المعاملة إيجابية (دخل) أو سلبية (مصروف)
  bool get isPositive =>
      this == cash ||
      this == visaSale ||
      this == deferredSale ||
      this == collectDebt;

  /// تحديد إذا كانت المعاملة متعلقة بالمبيعات
  bool get isSale => this == cash || this == visaSale || this == deferredSale;

  /// تحديد إذا كانت المعاملة متعلقة بالتحصيل
  bool get isCollection => this == collectDebt;

  /// تحديد إذا كانت المعاملة متعلقة بالمصروفات
  bool get isExpense =>
      this == expenses ||
      this == purchaseGoods ||
      this == paySupplier ||
      this == payBills ||
      this == payObligation ||
      this == other;

  /// الحصول على فئة المعاملة
  TransactionCategory get category {
    if (isSale) return TransactionCategory.sales;
    if (this == returns) return TransactionCategory.returns;
    return TransactionCategory.expenses;
  }
}

/// فئات المعاملات للتصنيف والفلترة
enum TransactionCategory {
  sales('المبيعات', Icons.trending_up, Color(0xFF28A745)),
  expenses('المصروفات', Icons.trending_down, Color(0xFFFF3B30)),
  returns('المرتجعات', Icons.undo, Color(0xFF6C757D));

  const TransactionCategory(this.displayName, this.icon, this.color);

  final String displayName;
  final IconData icon;
  final Color color;
}

class TransactionItem {
  final double amount;
  final ShiftTransactionType type;
  final String description;
  final DateTime timestamp;

  TransactionItem({
    required this.amount,
    required this.type,
    required this.description,
    required this.timestamp,
  });

  /// تحويل إلى نموذج API
  Transactions toApiModel() {
    return Transactions(
      amount: amount,
      type: _getApiTypeName(type),
      description: description,
    );
  }

  /// تحويل أسماء الأنواع لما يتوقعه الـ API (متطابق مع قاعدة البيانات)
  String _getApiTypeName(ShiftTransactionType type) {
    switch (type) {
      case ShiftTransactionType.cash:
        return 'sale_cash';
      case ShiftTransactionType.visaSale:
        return 'sale_card';
      case ShiftTransactionType.deferredSale:
        return 'sale_credit';
      case ShiftTransactionType.collectDebt:
        return 'collectDebt';
      case ShiftTransactionType.expenses:
        return 'expense';
      case ShiftTransactionType.purchaseGoods:
        return 'purchaseGoods';
      case ShiftTransactionType.paySupplier:
        return 'paySupplier';
      case ShiftTransactionType.payBills:
        return 'payBills';
      case ShiftTransactionType.payObligation:
        return 'payObligation';
      case ShiftTransactionType.returns:
        return 'return';
      case ShiftTransactionType.other:
        return 'other';
    }
  }

  // String _getApiTypeName(ShiftTransactionType type) {
  //   switch (type) {
  //     // المبيعات
  //     case ShiftTransactionType.cash:
  //       return 'sale_cash';
  //     case ShiftTransactionType.visaSale:
  //       return 'sale_card';
  //     case ShiftTransactionType.deferredSale:
  //       return 'sale_credit';
  //
  //     // التحصيل
  //     case ShiftTransactionType.collectDebt:
  //       return 'collectDebt';
  //
  //     // المصروفات
  //     case ShiftTransactionType.expenses:
  //       return 'expense';
  //     case ShiftTransactionType.purchaseGoods:
  //       return 'purchaseGoods';
  //     case ShiftTransactionType.paySupplier:
  //       return 'paySupplier';
  //     case ShiftTransactionType.payBills:
  //       return 'payBills';
  //     case ShiftTransactionType.payObligation:
  //       return 'payObligation';
  //
  //     // المرتجعات
  //     case ShiftTransactionType.returns:
  //       return 'return';
  //
  //     // أخرى
  //     case ShiftTransactionType.other:
  //       return 'other';
  //   }
  // }

  /// الحصول على فئة المعاملة
  TransactionCategory get category => type.category;

  /// هل المعاملة إيجابية (دخل)
  bool get isPositive => type.isPositive;

  /// هل المعاملة سلبية (مصروف)
  bool get isNegative => !type.isPositive;
}

class TransactionUtils {
  /// تنسيق الوقت
  static String formatTime(DateTime time) {
    final hour = time.hour.toString().padLeft(2, '0');
    final minute = time.minute.toString().padLeft(2, '0');
    return '$hour:$minute';
  }

  /// تنسيق التاريخ والوقت معاً
  static String formatDateTime(DateTime time) {
    final date =
        '${time.year}/${time.month.toString().padLeft(2, '0')}/${time.day.toString().padLeft(2, '0')}';
    final timeStr = formatTime(time);
    return '$date - $timeStr';
  }

  /// الحصول على الوصف الافتراضي حسب نوع المعاملة
  static String getDefaultDescription(ShiftTransactionType type) {
    switch (type) {
      // المبيعات
      case ShiftTransactionType.cash:
        return 'معاملة نقدية';
      case ShiftTransactionType.visaSale:
        return 'بيع بالفيزا';
      case ShiftTransactionType.deferredSale:
        return 'بيع آجل';

      // التحصيل
      case ShiftTransactionType.collectDebt:
        return 'قبض دين من عميل';

      // المصروفات
      case ShiftTransactionType.expenses:
        return 'مصروف وردية';
      case ShiftTransactionType.purchaseGoods:
        return 'شراء بضاعة';
      case ShiftTransactionType.paySupplier:
        return 'سداد مورد';
      case ShiftTransactionType.payBills:
        return 'سداد فواتير';
      case ShiftTransactionType.payObligation:
        return 'سداد التزام';

      // المرتجعات
      case ShiftTransactionType.returns:
        return 'مرتجع';

      // أخرى
      case ShiftTransactionType.other:
        return 'معاملة أخرى';
    }
  }

  /// الحصول على وصف تفصيلي لنوع المعاملة
  static String getDetailedDescription(ShiftTransactionType type) {
    switch (type) {
      // المبيعات
      case ShiftTransactionType.cash:
        return 'عملية بيع نقدية';
      case ShiftTransactionType.visaSale:
        return 'عملية بيع بالبطاقة الائتمانية';
      case ShiftTransactionType.deferredSale:
        return 'عملية بيع بالأجل للعميل';

      // التحصيل
      case ShiftTransactionType.collectDebt:
        return 'تحصيل دين مستحق من عميل';

      // المصروفات
      case ShiftTransactionType.expenses:
        return 'مصروفات عامة للوردية';
      case ShiftTransactionType.purchaseGoods:
        return 'شراء بضاعة للمخزن';
      case ShiftTransactionType.paySupplier:
        return 'سداد مبلغ مستحق لمورد';
      case ShiftTransactionType.payBills:
        return 'سداد فواتير (كهرباء، ماء، إلخ)';
      case ShiftTransactionType.payObligation:
        return 'سداد التزام مالي';

      // المرتجعات
      case ShiftTransactionType.returns:
        return 'إرجاع بضاعة من عميل';

      // أخرى
      case ShiftTransactionType.other:
        return 'معاملة مالية أخرى';
    }
  }

  /// الحصول على جميع أنواع المعاملات مصنفة
  static Map<String, List<ShiftTransactionType>> getGroupedTypes() {
    return {
      'المبيعات والدخل 💰': [
        ShiftTransactionType.cash,
        ShiftTransactionType.visaSale,
        ShiftTransactionType.deferredSale,
        ShiftTransactionType.collectDebt,
      ],
      'المصروفات والمدفوعات 💸': [
        ShiftTransactionType.expenses,
        ShiftTransactionType.purchaseGoods,
        ShiftTransactionType.paySupplier,
        ShiftTransactionType.payBills,
        ShiftTransactionType.payObligation,
      ],
      'المرتجعات والأخرى 🔄': [
        ShiftTransactionType.returns,
        ShiftTransactionType.other,
      ],
    };
  }

  /// تصفية المعاملات حسب النوع
  static List<TransactionItem> filterByType(
    List<TransactionItem> transactions,
    ShiftTransactionType type,
  ) {
    return transactions.where((t) => t.type == type).toList();
  }

  /// تصفية المعاملات حسب الفئة
  static List<TransactionItem> filterByCategory(
    List<TransactionItem> transactions,
    TransactionCategory category,
  ) {
    return transactions.where((t) => t.category == category).toList();
  }

  /// حساب إجمالي المبلغ لنوع معين
  static double calculateTotalByType(
    List<TransactionItem> transactions,
    ShiftTransactionType type,
  ) {
    return transactions
        .where((t) => t.type == type)
        .fold(0.0, (sum, t) => sum + t.amount);
  }

  /// حساب إجمالي المبلغ لفئة معينة
  static double calculateTotalByCategory(
    List<TransactionItem> transactions,
    TransactionCategory category,
  ) {
    return transactions
        .where((t) => t.category == category)
        .fold(0.0, (sum, t) => sum + t.amount);
  }

  /// الحصول على إحصائيات مفصلة
  static Map<String, dynamic> getStatistics(
    List<TransactionItem> transactions,
  ) {
    final positive = transactions.where((t) => t.isPositive).toList();
    final negative = transactions.where((t) => t.isNegative).toList();

    return {
      'total_transactions': transactions.length,
      'total_positive': positive.fold(0.0, (sum, t) => sum + t.amount),
      'total_negative': negative.fold(0.0, (sum, t) => sum + t.amount),
      'positive_count': positive.length,
      'negative_count': negative.length,
      'net_amount':
          positive.fold(0.0, (sum, t) => sum + t.amount) -
          negative.fold(0.0, (sum, t) => sum + t.amount),
      'by_type': ShiftTransactionType.values.map((type) {
        final filtered = transactions.where((t) => t.type == type).toList();
        return {
          'type': type.displayName,
          'count': filtered.length,
          'total': filtered.fold(0.0, (sum, t) => sum + t.amount),
        };
      }).toList(),
    };
  }
}
