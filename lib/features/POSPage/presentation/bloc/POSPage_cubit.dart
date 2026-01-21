// import 'package:bloc/bloc.dart';
// import 'package:meta/meta.dart';
// import 'package:injectable/injectable.dart';
// import '../../domain/useCases/POSPage_useCase_repo.dart';
//
// part 'POSPage_state.dart';
//
// @injectable
// class POSPageCubit extends Cubit<POSPageState> {
//   POSPageCubit(this._pospageUseCaseRepo) : super(POSPageInitial());
//   final POSPageUseCaseRepo _pospageUseCaseRepo;
// }
// lib/features/POSPage/presentation/bloc/invoice_cubit.dart

import 'package:bloc/bloc.dart';
import 'package:injectable/injectable.dart';

import '../../data/models/invoice_model.dart';
import '../widgets/invoice_repository.dart';
import 'POSPage_state.dart';

@injectable
class InvoiceCubit extends Cubit<InvoiceState> {
  final InvoiceRepository _invoiceRepository;

  InvoiceCubit(this._invoiceRepository) : super(InvoiceInitial());

  Future<void> saveInvoice(Invoice invoice) async {
    try {
      emit(InvoiceSaving());
      await _invoiceRepository.saveInvoice(invoice);
      emit(InvoiceSaved(invoice));
      await loadInvoices(); // Reload all invoices
    } catch (e) {
      emit(InvoiceError(e.toString()));
    }
  }

  Future<void> updateInvoice(Invoice invoice) async {
    try {
      emit(InvoiceUpdating());
      await _invoiceRepository.updateInvoice(invoice);
      emit(InvoiceUpdated(invoice));
      await loadInvoices();
    } catch (e) {
      emit(InvoiceError(e.toString()));
    }
  }

  Future<void> deleteInvoice(String invoiceId) async {
    try {
      emit(InvoiceDeleting());
      await _invoiceRepository.deleteInvoice(invoiceId);
      emit(InvoiceDeleted());
      await loadInvoices();
    } catch (e) {
      emit(InvoiceError(e.toString()));
    }
  }

  Future<void> loadInvoices() async {
    try {
      emit(InvoiceLoading());
      final invoices = await _invoiceRepository.getAllInvoices();
      emit(InvoicesLoaded(invoices));
    } catch (e) {
      emit(InvoiceError(e.toString()));
    }
  }

  Future<void> loadInvoiceById(String invoiceId) async {
    try {
      emit(InvoiceLoading());
      final invoice = await _invoiceRepository.getInvoiceById(invoiceId);
      if (invoice != null) {
        emit(InvoiceLoaded(invoice));
      } else {
        emit(InvoiceError('الفاتورة غير موجودة'));
      }
    } catch (e) {
      emit(InvoiceError(e.toString()));
    }
  }
}

// lib/features/POSPage/presentation/bloc/invoice_state.dart
