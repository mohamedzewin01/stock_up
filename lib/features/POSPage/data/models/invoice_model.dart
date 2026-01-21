// lib/features/POSPage/domain/models/invoice_model.dart

// import 'package:stock_up/features/POSPage/presentation/widgets/invoice_item.dart';

import '../../presentation/widgets/invoice_item.dart';

class Invoice {
  final String id;
  final List<InvoiceItem> items;
  final double totalAmount;
  final double tax;
  final double grandTotal;
  final String? customerName;
  final String? customerPhone;
  final DateTime createdAt;
  final DateTime? updatedAt;

  Invoice({
    required this.id,
    required this.items,
    required this.totalAmount,
    required this.tax,
    required this.grandTotal,
    this.customerName,
    this.customerPhone,
    required this.createdAt,
    this.updatedAt,
  });

  // Convert to JSON for storage
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'items': items
          .map(
            (item) => {
              'productId': item.product.productId,
              'productName': item.product.productName,
              'sellingPrice': item.product.sellingPrice,
              'quantity': item.quantity,
            },
          )
          .toList(),
      'totalAmount': totalAmount,
      'tax': tax,
      'grandTotal': grandTotal,
      'customerName': customerName,
      'customerPhone': customerPhone,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt?.toIso8601String(),
    };
  }

  // Create from JSON
  factory Invoice.fromJson(Map<String, dynamic> json) {
    return Invoice(
      id: json['id'],
      items: (json['items'] as List).map((item) {
        // Create a minimal Results object for display
        final product = Results(
          productId: item['productId'],
          productName: item['productName'],
          sellingPrice: item['sellingPrice'],
        );
        return InvoiceItem(product: product, quantity: item['quantity']);
      }).toList(),
      totalAmount: json['totalAmount'],
      tax: json['tax'],
      grandTotal: json['grandTotal'],
      customerName: json['customerName'],
      customerPhone: json['customerPhone'],
      createdAt: DateTime.parse(json['createdAt']),
      updatedAt: json['updatedAt'] != null
          ? DateTime.parse(json['updatedAt'])
          : null,
    );
  }

  // Create copy with updated fields
  Invoice copyWith({
    String? id,
    List<InvoiceItem>? items,
    double? totalAmount,
    double? tax,
    double? grandTotal,
    String? customerName,
    String? customerPhone,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return Invoice(
      id: id ?? this.id,
      items: items ?? this.items,
      totalAmount: totalAmount ?? this.totalAmount,
      tax: tax ?? this.tax,
      grandTotal: grandTotal ?? this.grandTotal,
      customerName: customerName ?? this.customerName,
      customerPhone: customerPhone ?? this.customerPhone,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}

// Minimal Results class extension for stored invoices
class Results {
  final String? productId;
  final String? productName;
  final String? sellingPrice;

  Results({this.productId, this.productName, this.sellingPrice});
}
