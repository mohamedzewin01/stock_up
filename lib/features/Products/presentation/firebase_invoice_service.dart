// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:injectable/injectable.dart';
// import 'package:stock_up/features/Products/domain/entities/products_entities.dart';
//
// @injectable
// class FirebaseInvoiceService {
//   final FirebaseFirestore _firestore;
//
//   FirebaseInvoiceService(this._firestore);
//
//   CollectionReference get _invoicesCollection =>
//       _firestore.collection('invoices');
//
//   // إضافة فاتورة جديدة
//   Future<String> addInvoice(Invoice invoice) async {
//     try {
//       final docRef = await _invoicesCollection.add(invoice.toJson());
//       return docRef.id;
//     } catch (e) {
//       throw Exception('فشل في حفظ الفاتورة: $e');
//     }
//   }
//
//   // تحديث فاتورة موجودة
//   Future<void> updateInvoice(Invoice invoice) async {
//     if (invoice.id == null) {
//       throw Exception('معرف الفاتورة مطلوب للتحديث');
//     }
//
//     try {
//       await _invoicesCollection
//           .doc(invoice.id)
//           .update(invoice.copyWith(updatedAt: DateTime.now()).toJson());
//     } catch (e) {
//       throw Exception('فشل في تحديث الفاتورة: $e');
//     }
//   }
//
//   // إلغاء فاتورة
//   Future<void> cancelInvoice(String invoiceId) async {
//     try {
//       await _invoicesCollection.doc(invoiceId).update({
//         'status': InvoiceStatus.cancelled.name,
//         'updatedAt': Timestamp.fromDate(DateTime.now()),
//       });
//     } catch (e) {
//       throw Exception('فشل في إلغاء الفاتورة: $e');
//     }
//   }
//
//   // حذف فاتورة
//   Future<void> deleteInvoice(String invoiceId) async {
//     try {
//       await _invoicesCollection.doc(invoiceId).delete();
//     } catch (e) {
//       throw Exception('فشل في حذف الفاتورة: $e');
//     }
//   }
//
//   // استرجاع جميع الفواتير
//   Stream<List<Invoice>> getAllInvoices() {
//     return _invoicesCollection
//         .orderBy('createdAt', descending: true)
//         .snapshots()
//         .map((snapshot) {
//           return snapshot.docs.map((doc) {
//             return Invoice.fromJson(doc.id, doc.data() as Map<String, dynamic>);
//           }).toList();
//         });
//   }
//
//   // استرجاع فاتورة واحدة
//   Future<Invoice?> getInvoiceById(String invoiceId) async {
//     try {
//       final doc = await _invoicesCollection.doc(invoiceId).get();
//       if (!doc.exists) return null;
//       return Invoice.fromJson(doc.id, doc.data() as Map<String, dynamic>);
//     } catch (e) {
//       throw Exception('فشل في استرجاع الفاتورة: $e');
//     }
//   }
//
//   // البحث عن فواتير
//   Stream<List<Invoice>> searchInvoices({
//     String? customerName,
//     String? invoiceNumber,
//     DateTime? startDate,
//     DateTime? endDate,
//     InvoiceStatus? status,
//   }) {
//     Query query = _invoicesCollection;
//
//     if (customerName != null && customerName.isNotEmpty) {
//       query = query.where('customerName', isGreaterThanOrEqualTo: customerName);
//     }
//
//     if (invoiceNumber != null && invoiceNumber.isNotEmpty) {
//       query = query.where('invoiceNumber', isEqualTo: invoiceNumber);
//     }
//
//     if (status != null) {
//       query = query.where('status', isEqualTo: status.name);
//     }
//
//     if (startDate != null) {
//       query = query.where(
//         'invoiceDate',
//         isGreaterThanOrEqualTo: Timestamp.fromDate(startDate),
//       );
//     }
//
//     if (endDate != null) {
//       query = query.where(
//         'invoiceDate',
//         isLessThanOrEqualTo: Timestamp.fromDate(endDate),
//       );
//     }
//
//     return query.orderBy('createdAt', descending: true).snapshots().map((
//       snapshot,
//     ) {
//       return snapshot.docs.map((doc) {
//         return Invoice.fromJson(doc.id, doc.data() as Map<String, dynamic>);
//       }).toList();
//     });
//   }
//
//   // توليد رقم فاتورة جديد
//   Future<String> generateInvoiceNumber() async {
//     try {
//       final lastInvoice = await _invoicesCollection
//           .orderBy('createdAt', descending: true)
//           .limit(1)
//           .get();
//
//       if (lastInvoice.docs.isEmpty) {
//         return 'INV-0001';
//       }
//
//       // إصلاح مشكلة null safety
//       final data = lastInvoice.docs.first.data() as Map<String, dynamic>?;
//       if (data == null || !data.containsKey('invoiceNumber')) {
//         return 'INV-0001';
//       }
//
//       final lastInvoiceNumber = data['invoiceNumber'] as String?;
//       if (lastInvoiceNumber == null || lastInvoiceNumber.isEmpty) {
//         return 'INV-0001';
//       }
//
//       final parts = lastInvoiceNumber.split('-');
//       if (parts.length < 2) {
//         return 'INV-0001';
//       }
//
//       final lastNumber = int.tryParse(parts.last) ?? 0;
//       final newNumber = lastNumber + 1;
//
//       return 'INV-${newNumber.toString().padLeft(4, '0')}';
//     } catch (e) {
//       // في حالة الفشل، استخدم التاريخ والوقت
//       return 'INV-${DateTime.now().millisecondsSinceEpoch}';
//     }
//   }
// }
