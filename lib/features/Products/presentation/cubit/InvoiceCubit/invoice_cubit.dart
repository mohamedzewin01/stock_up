import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:stock_up/features/Products/data/models/response/get_all_products_model.dart';

import '../../../domain/entities/products_entities.dart';
import '../../firebase_invoice_service.dart';
import 'invoice_state.dart';

@injectable
class InvoiceCubit extends Cubit<InvoiceState> {
  final FirebaseInvoiceService firebaseService;
  Invoice? _currentInvoice;

  InvoiceCubit(this.firebaseService)
    : super(InvoiceInitial(_createEmptyInvoice()));

  static Invoice _createEmptyInvoice() {
    return Invoice(
      invoiceNumber: '',
      invoiceDate: DateTime.now(),
      items: [],
      createdAt: DateTime.now(),
    );
  }

  // بدء فاتورة جديدة
  Future<void> startNewInvoice() async {
    try {
      final invoiceNumber = await firebaseService.generateInvoiceNumber();
      _currentInvoice = Invoice(
        invoiceNumber: invoiceNumber,
        invoiceDate: DateTime.now(),
        items: [],
        createdAt: DateTime.now(),
      );
      emit(InvoiceInitial(_currentInvoice!));
    } catch (e) {
      emit(
        InvoiceError(
          message: 'فشل في إنشاء فاتورة جديدة: ${e.toString()}',
          currentInvoice: _currentInvoice,
        ),
      );
    }
  }

  // إضافة منتج للفاتورة
  void addProduct(Results product, {double? quantity, double? customPrice}) {
    if (_currentInvoice == null) return;

    final qty = quantity ?? 1.0;
    final price =
        customPrice ?? double.tryParse(product.sellingPrice ?? '0') ?? 0.0;
    final taxRate = double.tryParse(product.taxRate ?? '0');
    final taxable = product.taxable == 'true';

    final item = InvoiceItem(
      productId: product.productId ?? '',
      productName: product.productName ?? '',
      productNumber: product.productNumber ?? '',
      quantity: qty,
      price: price,
      unit: product.unit ?? '',
      taxRate: taxRate,
      taxable: taxable,
    );

    final updatedItems = List<InvoiceItem>.from(_currentInvoice!.items)
      ..add(item);
    _currentInvoice = _currentInvoice!.copyWith(items: updatedItems);

    emit(InvoiceItemAdded(_currentInvoice!));
  }

  // تحديث كمية منتج في الفاتورة
  void updateItemQuantity(int itemIndex, double newQuantity) {
    if (_currentInvoice == null || itemIndex >= _currentInvoice!.items.length)
      return;

    final updatedItems = List<InvoiceItem>.from(_currentInvoice!.items);
    final oldItem = updatedItems[itemIndex];

    updatedItems[itemIndex] = InvoiceItem(
      productId: oldItem.productId,
      productName: oldItem.productName,
      productNumber: oldItem.productNumber,
      quantity: newQuantity,
      price: oldItem.price,
      unit: oldItem.unit,
      taxRate: oldItem.taxRate,
      taxable: oldItem.taxable,
    );

    _currentInvoice = _currentInvoice!.copyWith(items: updatedItems);
    emit(InvoiceItemUpdated(_currentInvoice!));
  }

  // تحديث سعر منتج في الفاتورة
  void updateItemPrice(int itemIndex, double newPrice) {
    if (_currentInvoice == null || itemIndex >= _currentInvoice!.items.length)
      return;

    final updatedItems = List<InvoiceItem>.from(_currentInvoice!.items);
    final oldItem = updatedItems[itemIndex];

    updatedItems[itemIndex] = InvoiceItem(
      productId: oldItem.productId,
      productName: oldItem.productName,
      productNumber: oldItem.productNumber,
      quantity: oldItem.quantity,
      price: newPrice,
      unit: oldItem.unit,
      taxRate: oldItem.taxRate,
      taxable: oldItem.taxable,
    );

    _currentInvoice = _currentInvoice!.copyWith(items: updatedItems);
    emit(InvoiceItemUpdated(_currentInvoice!));
  }

  // حذف منتج من الفاتورة
  void removeItem(int itemIndex) {
    if (_currentInvoice == null || itemIndex >= _currentInvoice!.items.length)
      return;

    final updatedItems = List<InvoiceItem>.from(_currentInvoice!.items)
      ..removeAt(itemIndex);

    _currentInvoice = _currentInvoice!.copyWith(items: updatedItems);
    emit(InvoiceItemRemoved(_currentInvoice!));
  }

  // تحديث معلومات العميل
  void updateCustomerInfo({String? name, String? phone}) {
    if (_currentInvoice == null) return;

    _currentInvoice = _currentInvoice!.copyWith(
      customerName: name,
      customerPhone: phone,
    );

    emit(InvoiceItemUpdated(_currentInvoice!));
  }

  // تحديث الملاحظات
  void updateNotes(String notes) {
    if (_currentInvoice == null) return;

    _currentInvoice = _currentInvoice!.copyWith(notes: notes);
    emit(InvoiceItemUpdated(_currentInvoice!));
  }

  // حفظ الفاتورة في Firebase
  Future<void> saveInvoice() async {
    if (_currentInvoice == null || _currentInvoice!.items.isEmpty) {
      emit(
        InvoiceError(
          message: 'لا يمكن حفظ فاتورة فارغة',
          currentInvoice: _currentInvoice,
        ),
      );
      return;
    }

    emit(InvoiceSaving(_currentInvoice!));

    try {
      final invoiceId = await firebaseService.addInvoice(_currentInvoice!);

      final savedInvoice = _currentInvoice!.copyWith(id: invoiceId);

      emit(InvoiceSaved(invoiceId: invoiceId, savedInvoice: savedInvoice));

      // بدء فاتورة جديدة تلقائياً
      await startNewInvoice();
    } catch (e) {
      emit(
        InvoiceError(
          message: 'فشل في حفظ الفاتورة: ${e.toString()}',
          currentInvoice: _currentInvoice,
        ),
      );
    }
  }

  // الحصول على الفاتورة الحالية
  Invoice? get currentInvoice => _currentInvoice;
}
