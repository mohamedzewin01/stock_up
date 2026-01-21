// part of 'POSPage_cubit.dart';
//
// @immutable
// sealed class POSPageState {}
//
// final class POSPageInitial extends POSPageState {}
// final class POSPageLoading extends POSPageState {}
// final class POSPageSuccess extends POSPageState {}
// final class POSPageFailure extends POSPageState {
//   final Exception exception;
//
//   POSPageFailure(this.exception);
// }

import 'package:flutter/material.dart';

import '../../data/models/invoice_model.dart';

@immutable
sealed class InvoiceState {}

final class InvoiceInitial extends InvoiceState {}

final class InvoiceLoading extends InvoiceState {}

final class InvoiceSaving extends InvoiceState {}

final class InvoiceUpdating extends InvoiceState {}

final class InvoiceDeleting extends InvoiceState {}

final class InvoiceSaved extends InvoiceState {
  final Invoice invoice;

  InvoiceSaved(this.invoice);
}

final class InvoiceUpdated extends InvoiceState {
  final Invoice invoice;

  InvoiceUpdated(this.invoice);
}

final class InvoiceDeleted extends InvoiceState {}

final class InvoiceLoaded extends InvoiceState {
  final Invoice invoice;

  InvoiceLoaded(this.invoice);
}

final class InvoicesLoaded extends InvoiceState {
  final List<Invoice> invoices;

  InvoicesLoaded(this.invoices);
}

final class InvoiceError extends InvoiceState {
  final String message;

  InvoiceError(this.message);
}
