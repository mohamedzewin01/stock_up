// import 'package:equatable/equatable.dart';
//
// import '../../../domain/entities/products_entities.dart';
//
// abstract class InvoiceState extends Equatable {
//   const InvoiceState();
//
//   @override
//   List<Object?> get props => [];
// }
//
// // حالة الفاتورة الجديدة
// class InvoiceInitial extends InvoiceState {
//   final Invoice currentInvoice;
//
//   const InvoiceInitial(this.currentInvoice);
//
//   @override
//   List<Object?> get props => [currentInvoice];
// }
//
// class InvoiceItemAdded extends InvoiceState {
//   final Invoice currentInvoice;
//
//   const InvoiceItemAdded(this.currentInvoice);
//
//   @override
//   List<Object?> get props => [currentInvoice];
// }
//
// class InvoiceItemUpdated extends InvoiceState {
//   final Invoice currentInvoice;
//
//   const InvoiceItemUpdated(this.currentInvoice);
//
//   @override
//   List<Object?> get props => [currentInvoice];
// }
//
// class InvoiceItemRemoved extends InvoiceState {
//   final Invoice currentInvoice;
//
//   const InvoiceItemRemoved(this.currentInvoice);
//
//   @override
//   List<Object?> get props => [currentInvoice];
// }
//
// class InvoiceSaving extends InvoiceState {
//   final Invoice invoice;
//
//   const InvoiceSaving(this.invoice);
//
//   @override
//   List<Object?> get props => [invoice];
// }
//
// class InvoiceSaved extends InvoiceState {
//   final String invoiceId;
//   final Invoice savedInvoice;
//
//   const InvoiceSaved({required this.invoiceId, required this.savedInvoice});
//
//   @override
//   List<Object?> get props => [invoiceId, savedInvoice];
// }
//
// class InvoiceError extends InvoiceState {
//   final String message;
//   final Invoice? currentInvoice;
//
//   const InvoiceError({required this.message, this.currentInvoice});
//
//   @override
//   List<Object?> get props => [message, currentInvoice];
// }
//
// // حالات قائمة الفواتير
// class InvoiceListLoading extends InvoiceState {}
//
// class InvoiceListLoaded extends InvoiceState {
//   final List<Invoice> invoices;
//
//   const InvoiceListLoaded(this.invoices);
//
//   @override
//   List<Object?> get props => [invoices];
// }
//
// class InvoiceListError extends InvoiceState {
//   final String message;
//
//   const InvoiceListError(this.message);
//
//   @override
//   List<Object?> get props => [message];
// }
//
// class InvoiceDetailLoaded extends InvoiceState {
//   final Invoice invoice;
//
//   const InvoiceDetailLoaded(this.invoice);
//
//   @override
//   List<Object?> get props => [invoice];
// }
//
// class InvoiceUpdating extends InvoiceState {
//   final Invoice invoice;
//
//   const InvoiceUpdating(this.invoice);
//
//   @override
//   List<Object?> get props => [invoice];
// }
//
// class InvoiceUpdated extends InvoiceState {
//   final Invoice invoice;
//
//   const InvoiceUpdated(this.invoice);
//
//   @override
//   List<Object?> get props => [invoice];
// }
//
// class InvoiceCancelled extends InvoiceState {
//   final String invoiceId;
//
//   const InvoiceCancelled(this.invoiceId);
//
//   @override
//   List<Object?> get props => [invoiceId];
// }
