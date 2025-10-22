import 'package:cloud_firestore/cloud_firestore.dart';

import '../../data/models/response/get_all_products_model.dart';

class GetAllProductsEntity {
  final String? status;

  final Store? store;

  final int? totalItems;

  final List<Results>? results;

  GetAllProductsEntity({
    this.status,
    this.store,
    this.totalItems,
    this.results,
  });
}

class InvoiceItem {
  final String productId;
  final String productName;
  final String productNumber;
  final double quantity;
  final double price;
  final String unit;
  final double? taxRate;
  final bool taxable;

  InvoiceItem({
    required this.productId,
    required this.productName,
    required this.productNumber,
    required this.quantity,
    required this.price,
    required this.unit,
    this.taxRate,
    this.taxable = false,
  });

  double get subtotal => quantity * price;

  double get taxAmount {
    if (!taxable || taxRate == null) return 0;
    return subtotal * (taxRate! / 100);
  }

  double get total => subtotal + taxAmount;

  Map<String, dynamic> toJson() {
    return {
      'productId': productId,
      'productName': productName,
      'productNumber': productNumber,
      'quantity': quantity,
      'price': price,
      'unit': unit,
      'taxRate': taxRate,
      'taxable': taxable,
      'subtotal': subtotal,
      'taxAmount': taxAmount,
      'total': total,
    };
  }

  factory InvoiceItem.fromJson(Map<String, dynamic> json) {
    return InvoiceItem(
      productId: json['productId'] as String,
      productName: json['productName'] as String,
      productNumber: json['productNumber'] as String,
      quantity: (json['quantity'] as num).toDouble(),
      price: (json['price'] as num).toDouble(),
      unit: json['unit'] as String,
      taxRate: json['taxRate'] != null
          ? (json['taxRate'] as num).toDouble()
          : null,
      taxable: json['taxable'] as bool? ?? false,
    );
  }
}

class Invoice {
  final String? id;
  final String invoiceNumber;
  final DateTime invoiceDate;
  final List<InvoiceItem> items;
  final String? customerName;
  final String? customerPhone;
  final String? notes;
  final InvoiceStatus status;
  final DateTime createdAt;
  final DateTime? updatedAt;

  Invoice({
    this.id,
    required this.invoiceNumber,
    required this.invoiceDate,
    required this.items,
    this.customerName,
    this.customerPhone,
    this.notes,
    this.status = InvoiceStatus.active,
    required this.createdAt,
    this.updatedAt,
  });

  double get subtotal => items.fold(0, (sum, item) => sum + item.subtotal);

  double get totalTax => items.fold(0, (sum, item) => sum + item.taxAmount);

  double get total => items.fold(0, (sum, item) => sum + item.total);

  Invoice copyWith({
    String? id,
    String? invoiceNumber,
    DateTime? invoiceDate,
    List<InvoiceItem>? items,
    String? customerName,
    String? customerPhone,
    String? notes,
    InvoiceStatus? status,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return Invoice(
      id: id ?? this.id,
      invoiceNumber: invoiceNumber ?? this.invoiceNumber,
      invoiceDate: invoiceDate ?? this.invoiceDate,
      items: items ?? this.items,
      customerName: customerName ?? this.customerName,
      customerPhone: customerPhone ?? this.customerPhone,
      notes: notes ?? this.notes,
      status: status ?? this.status,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'invoiceNumber': invoiceNumber,
      'invoiceDate': Timestamp.fromDate(invoiceDate),
      'items': items.map((item) => item.toJson()).toList(),
      'customerName': customerName,
      'customerPhone': customerPhone,
      'notes': notes,
      'status': status.name,
      'subtotal': subtotal,
      'totalTax': totalTax,
      'total': total,
      'createdAt': Timestamp.fromDate(createdAt),
      'updatedAt': updatedAt != null ? Timestamp.fromDate(updatedAt!) : null,
    };
  }

  factory Invoice.fromJson(String id, Map<String, dynamic> json) {
    return Invoice(
      id: id,
      invoiceNumber: json['invoiceNumber'] as String,
      invoiceDate: (json['invoiceDate'] as Timestamp).toDate(),
      items: (json['items'] as List)
          .map((item) => InvoiceItem.fromJson(item as Map<String, dynamic>))
          .toList(),
      customerName: json['customerName'] as String?,
      customerPhone: json['customerPhone'] as String?,
      notes: json['notes'] as String?,
      status: InvoiceStatus.values.firstWhere(
        (e) => e.name == json['status'],
        orElse: () => InvoiceStatus.active,
      ),
      createdAt: (json['createdAt'] as Timestamp).toDate(),
      updatedAt: json['updatedAt'] != null
          ? (json['updatedAt'] as Timestamp).toDate()
          : null,
    );
  }
}

enum InvoiceStatus { active, cancelled, edited }
