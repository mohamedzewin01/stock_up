import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

import '../../../domain/entities/products_entities.dart';
import '../../firebase_invoice_service.dart';
import '../InvoiceCubit/invoice_state.dart';

@injectable
class InvoiceListCubit extends Cubit<InvoiceState> {
  final FirebaseInvoiceService firebaseService;
  StreamSubscription? _invoicesSubscription;

  InvoiceListCubit(this.firebaseService) : super(InvoiceListLoading());

  // تحميل جميع الفواتير
  void loadInvoices() {
    emit(InvoiceListLoading());

    _invoicesSubscription?.cancel();
    _invoicesSubscription = firebaseService.getAllInvoices().listen(
      (invoices) {
        emit(InvoiceListLoaded(invoices));
      },
      onError: (error) {
        emit(InvoiceListError('فشل في تحميل الفواتير: ${error.toString()}'));
      },
    );
  }

  // تحميل فاتورة واحدة
  Future<void> loadInvoiceById(String invoiceId) async {
    emit(InvoiceListLoading());

    try {
      final invoice = await firebaseService.getInvoiceById(invoiceId);
      if (invoice != null) {
        emit(InvoiceDetailLoaded(invoice));
      } else {
        emit(const InvoiceListError('الفاتورة غير موجودة'));
      }
    } catch (e) {
      emit(InvoiceListError('فشل في تحميل الفاتورة: ${e.toString()}'));
    }
  }

  // تحديث فاتورة
  Future<void> updateInvoice(Invoice invoice) async {
    emit(InvoiceUpdating(invoice));

    try {
      await firebaseService.updateInvoice(invoice);
      emit(InvoiceUpdated(invoice));

      // إعادة تحميل القائمة
      loadInvoices();
    } catch (e) {
      emit(InvoiceListError('فشل في تحديث الفاتورة: ${e.toString()}'));
    }
  }

  // إلغاء فاتورة
  Future<void> cancelInvoice(String invoiceId) async {
    try {
      await firebaseService.cancelInvoice(invoiceId);
      emit(InvoiceCancelled(invoiceId));

      // إعادة تحميل القائمة
      loadInvoices();
    } catch (e) {
      emit(InvoiceListError('فشل في إلغاء الفاتورة: ${e.toString()}'));
    }
  }

  // حذف فاتورة
  Future<void> deleteInvoice(String invoiceId) async {
    try {
      await firebaseService.deleteInvoice(invoiceId);

      // إعادة تحميل القائمة
      loadInvoices();
    } catch (e) {
      emit(InvoiceListError('فشل في حذف الفاتورة: ${e.toString()}'));
    }
  }

  // البحث عن فواتير
  void searchInvoices({
    String? customerName,
    String? invoiceNumber,
    DateTime? startDate,
    DateTime? endDate,
    InvoiceStatus? status,
  }) {
    emit(InvoiceListLoading());

    _invoicesSubscription?.cancel();
    _invoicesSubscription = firebaseService
        .searchInvoices(
          customerName: customerName,
          invoiceNumber: invoiceNumber,
          startDate: startDate,
          endDate: endDate,
          status: status,
        )
        .listen(
          (invoices) {
            emit(InvoiceListLoaded(invoices));
          },
          onError: (error) {
            emit(InvoiceListError('فشل في البحث: ${error.toString()}'));
          },
        );
  }

  @override
  Future<void> close() {
    _invoicesSubscription?.cancel();
    return super.close();
  }
}
