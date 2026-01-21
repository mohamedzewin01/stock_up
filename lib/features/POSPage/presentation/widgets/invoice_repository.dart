// lib/features/POSPage/domain/repositories/invoice_repository.dart

import 'dart:convert';
import 'dart:ui';

import 'package:injectable/injectable.dart';
import 'package:stock_up/features/POSPage/data/models/invoice_model.dart';

abstract class InvoiceRepository {
  Future<void> saveInvoice(Invoice invoice);

  Future<void> updateInvoice(Invoice invoice);

  Future<void> deleteInvoice(String invoiceId);

  Future<List<Invoice>> getAllInvoices();

  Future<Invoice?> getInvoiceById(String invoiceId);
}

// lib/features/POSPage/data/repositories_impl/invoice_repository_impl.dart

@Injectable(as: InvoiceRepository)
class InvoiceRepositoryImpl implements InvoiceRepository {
  static const String _storagePrefix = 'invoice:';

  @override
  Future<void> saveInvoice(Invoice invoice) async {
    try {
      final jsonData = json.encode(invoice.toJson());
      final result = await window.storage.set(
        '$_storagePrefix${invoice.id}',
        jsonData,
        false, // personal data
      );

      if (result == null) {
        throw Exception('فشل حفظ الفاتورة');
      }
    } catch (e) {
      throw Exception('خطأ في حفظ الفاتورة: $e');
    }
  }

  @override
  Future<void> updateInvoice(Invoice invoice) async {
    try {
      final updatedInvoice = invoice.copyWith(updatedAt: DateTime.now());
      final jsonData = json.encode(updatedInvoice.toJson());

      final result = await window.storage.set(
        '$_storagePrefix${invoice.id}',
        jsonData,
        false,
      );

      if (result == null) {
        throw Exception('فشل تحديث الفاتورة');
      }
    } catch (e) {
      throw Exception('خطأ في تحديث الفاتورة: $e');
    }
  }

  @override
  Future<void> deleteInvoice(String invoiceId) async {
    try {
      final result = await window.storage.delete(
        '$_storagePrefix$invoiceId',
        false,
      );

      if (result == null) {
        throw Exception('فشل حذف الفاتورة');
      }
    } catch (e) {
      throw Exception('خطأ في حذف الفاتورة: $e');
    }
  }

  @override
  Future<List<Invoice>> getAllInvoices() async {
    try {
      final result = await window.storage.list(_storagePrefix, false);

      if (result == null || result['keys'] == null) {
        return [];
      }

      final keys = result['keys'] as List;
      final invoices = <Invoice>[];

      for (final key in keys) {
        try {
          final data = await window.storage.get(key, false);
          if (data != null && data['value'] != null) {
            final invoiceData = json.decode(data['value']);
            invoices.add(Invoice.fromJson(invoiceData));
          }
        } catch (e) {
          print('خطأ في قراءة الفاتورة $key: $e');
          continue;
        }
      }

      // Sort by creation date (newest first)
      invoices.sort((a, b) => b.createdAt.compareTo(a.createdAt));

      return invoices;
    } catch (e) {
      throw Exception('خطأ في تحميل الفواتير: $e');
    }
  }

  @override
  Future<Invoice?> getInvoiceById(String invoiceId) async {
    try {
      final result = await window.storage.get(
        '$_storagePrefix$invoiceId',
        false,
      );

      if (result == null || result['value'] == null) {
        return null;
      }

      final invoiceData = json.decode(result['value']);
      return Invoice.fromJson(invoiceData);
    } catch (e) {
      print('خطأ في تحميل الفاتورة: $e');
      return null;
    }
  }
}
