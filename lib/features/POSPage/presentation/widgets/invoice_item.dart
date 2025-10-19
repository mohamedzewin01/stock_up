// lib/features/POSPage/domain/models/invoice_item.dart

import 'package:stock_up/features/Search/data/models/response/search_model.dart';

class InvoiceItem {
  final Results product;
  int quantity;

  InvoiceItem({required this.product, required this.quantity});
}
