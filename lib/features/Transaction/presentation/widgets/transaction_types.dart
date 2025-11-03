// // lib/features/Transaction/presentation/widgets/transaction_types.dart
// import 'package:flutter/material.dart';
// import 'package:stock_up/features/Transaction/data/models/request/add_transaction_request.dart';
//
// // أنواع المعاملات المتاحة للوردية
// enum ShiftTransactionType {
//   cash('نقدية', Icons.money, Color(0xFF28A745)),
//   expenses('مصروفات الوردية', Icons.remove_circle, Color(0xFFFF3B30)),
//   visaSale('بيع فيزا', Icons.credit_card, Color(0xFF007AFF)),
//   deferredSale('بيع آجل', Icons.schedule, Color(0xFFFF9500)),
//   returns('مرتجع', Icons.undo, Color(0xFF6C757D));
//
//   const ShiftTransactionType(this.displayName, this.icon, this.color);
//
//   final String displayName;
//   final IconData icon;
//   final Color color;
//
//   bool get isPositive => this == cash || this == visaSale || this == deferredSale;
// }
//
// class TransactionItem {
//   final double amount;
//   final ShiftTransactionType type;
//   final String description;
//   final DateTime timestamp;
//
//   TransactionItem({
//     required this.amount,
//     required this.type,
//     required this.description,
//     required this.timestamp,
//   });
//
//   // تحويل إلى نموذج API
//   Transactions toApiModel() {
//     return Transactions(
//       amount: amount.toInt(),
//       type: type.name,
//       description: description,
//     );
//   }
// }
//
// class TransactionUtils {
//   static String formatTime(DateTime time) {
//     final hour = time.hour.toString().padLeft(2, '0');
//     final minute = time.minute.toString().padLeft(2, '0');
//     return '$hour:$minute';
//   }
//
//   static String getDefaultDescription(ShiftTransactionType type) {
//     switch (type) {
//       case ShiftTransactionType.cash:
//         return 'معاملة نقدية';
//       case ShiftTransactionType.expenses:
//         return 'مصروف وردية';
//       case ShiftTransactionType.visaSale:
//         return 'بيع بالفيزا';
//       case ShiftTransactionType.deferredSale:
//         return 'بيع آجل';
//       case ShiftTransactionType.returns:
//         return 'مرتجع';
//     }
//   }
// }

// lib/features/Transaction/presentation/widgets/transaction_types.dart
import 'package:flutter/material.dart';
import 'package:stock_up/features/Transaction/data/models/request/add_transaction_request.dart';

// أنواع المعاملات المتاحة للوردية
enum ShiftTransactionType {
  cash('نقدية', Icons.money, Color(0xFF28A745)),
  expenses('مصروفات الوردية', Icons.remove_circle, Color(0xFFFF3B30)),
  visaSale('بيع فيزا', Icons.credit_card, Color(0xFF007AFF)),
  deferredSale('بيع آجل', Icons.schedule, Color(0xFFFF9500)),
  returns('مرتجع', Icons.undo, Color(0xFF6C757D));

  const ShiftTransactionType(this.displayName, this.icon, this.color);

  final String displayName;
  final IconData icon;
  final Color color;

  bool get isPositive =>
      this == cash || this == visaSale || this == deferredSale;
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

  // ✅ إصلاح تحويل إلى نموذج API
  Transactions toApiModel() {
    return Transactions(
      amount: amount, // ✅ إرسال كـ double بدلاً من int
      type: _getApiTypeName(type), // ✅ استخدام أسماء صحيحة للـ API
      description: description,
    );
  }

  // ✅ تحويل أسماء الأنواع لما يتوقعه الـ API (متطابق مع قاعدة البيانات)
  String _getApiTypeName(ShiftTransactionType type) {
    switch (type) {
      case ShiftTransactionType.cash:
        return 'sale_cash';
      case ShiftTransactionType.expenses:
        return 'expense';
      case ShiftTransactionType.visaSale:
        return 'sale_card';
      case ShiftTransactionType.deferredSale:
        return 'sale_credit';
      case ShiftTransactionType.returns:
        return 'return';
    }
  }
}

class TransactionUtils {
  static String formatTime(DateTime time) {
    final hour = time.hour.toString().padLeft(2, '0');
    final minute = time.minute.toString().padLeft(2, '0');
    return '$hour:$minute';
  }

  static String getDefaultDescription(ShiftTransactionType type) {
    switch (type) {
      case ShiftTransactionType.cash:
        return 'معاملة نقدية';
      case ShiftTransactionType.expenses:
        return 'مصروف وردية';
      case ShiftTransactionType.visaSale:
        return 'بيع بالفيزا';
      case ShiftTransactionType.deferredSale:
        return 'بيع آجل';
      case ShiftTransactionType.returns:
        return 'مرتجع';
    }
  }
}
