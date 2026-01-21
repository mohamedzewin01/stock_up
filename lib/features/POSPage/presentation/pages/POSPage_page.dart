// // import 'dart:async';
// //
// // import 'package:flutter/material.dart';
// // import 'package:flutter_bloc/flutter_bloc.dart';
// // import 'package:mobile_scanner/mobile_scanner.dart';
// // import 'package:stock_up/core/di/di.dart';
// // import 'package:stock_up/features/POSPage/presentation/widgets/invoice_item.dart';
// // import 'package:stock_up/features/POSPage/presentation/widgets/invoice_pdf_service.dart';
// // import 'package:stock_up/features/Search/data/models/response/search_model.dart';
// // import 'package:stock_up/features/Search/presentation/bloc/Search_cubit.dart';
// //
// // class POSPage extends StatefulWidget {
// //   const POSPage({super.key});
// //
// //   @override
// //   State<POSPage> createState() => _POSPageState();
// // }
// //
// // class _POSPageState extends State<POSPage> {
// //   late SearchCubit viewModel;
// //   final TextEditingController _searchController = TextEditingController();
// //   final ScrollController _scrollController = ScrollController();
// //   final MobileScannerController _cameraController = MobileScannerController(
// //     detectionSpeed: DetectionSpeed.noDuplicates,
// //   );
// //
// //   Timer? _debounce;
// //   bool _isCameraLocked = true;
// //   bool _torchOn = false;
// //   List<InvoiceItem> _invoiceItems = [];
// //   List<Results> _searchResults = [];
// //   double _totalAmount = 0.0;
// //
// //   @override
// //   void initState() {
// //     super.initState();
// //     viewModel = getIt.get<SearchCubit>();
// //     _searchController.addListener(_onSearchChanged);
// //   }
// //
// //   void _onSearchChanged() {
// //     if (_debounce?.isActive ?? false) _debounce!.cancel();
// //
// //     if (_searchController.text.isEmpty) {
// //       setState(() {
// //         _searchResults.clear();
// //       });
// //       return;
// //     }
// //
// //     _debounce = Timer(const Duration(milliseconds: 500), () {
// //       if (_searchController.text.isNotEmpty) {
// //         viewModel.search(_searchController.text, 1);
// //       }
// //     });
// //   }
// //
// //   void _toggleCamera() {
// //     setState(() {
// //       _isCameraLocked = !_isCameraLocked;
// //     });
// //     if (_isCameraLocked) {
// //       _cameraController.stop();
// //     } else {
// //       _cameraController.start();
// //     }
// //   }
// //
// //   void _toggleTorch() async {
// //     await _cameraController.toggleTorch();
// //     setState(() {
// //       _torchOn = !_torchOn;
// //     });
// //   }
// //
// //   void _onBarcodeDetected(String barcode) {
// //     if (!_isCameraLocked) {
// //       _searchController.text = barcode;
// //       viewModel.search(barcode, 1);
// //     }
// //   }
// //
// //   void _addToInvoice(Results product) {
// //     setState(() {
// //       final existingIndex = _invoiceItems.indexWhere(
// //         (item) => item.product.productId == product.productId,
// //       );
// //
// //       if (existingIndex != -1) {
// //         _invoiceItems[existingIndex].quantity++;
// //       } else {
// //         _invoiceItems.add(InvoiceItem(product: product, quantity: 1));
// //       }
// //       _calculateTotal();
// //     });
// //
// //     ScaffoldMessenger.of(context).showSnackBar(
// //       SnackBar(
// //         content: Row(
// //           children: [
// //             const Icon(Icons.check_circle, color: Colors.white),
// //             const SizedBox(width: 12),
// //             Expanded(child: Text('تم إضافة ${product.productName}')),
// //           ],
// //         ),
// //         backgroundColor: const Color(0xFF11998E),
// //         behavior: SnackBarBehavior.floating,
// //         shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
// //         margin: const EdgeInsets.all(16),
// //         duration: const Duration(seconds: 1),
// //       ),
// //     );
// //   }
// //
// //   void _removeFromInvoice(int index) {
// //     setState(() {
// //       _invoiceItems.removeAt(index);
// //       _calculateTotal();
// //     });
// //   }
// //
// //   void _updateQuantity(int index, int newQuantity) {
// //     if (newQuantity <= 0) {
// //       _removeFromInvoice(index);
// //       return;
// //     }
// //     setState(() {
// //       _invoiceItems[index].quantity = newQuantity;
// //       _calculateTotal();
// //     });
// //   }
// //
// //   void _calculateTotal() {
// //     _totalAmount = _invoiceItems.fold(0.0, (sum, item) {
// //       final price = double.tryParse(item.product.sellingPrice ?? '0') ?? 0.0;
// //       return sum + (price * item.quantity);
// //     });
// //   }
// //
// //   void _clearInvoice() {
// //     showDialog(
// //       context: context,
// //       builder: (context) => AlertDialog(
// //         shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
// //         title: const Row(
// //           children: [
// //             Icon(Icons.warning_rounded, color: Color(0xFFFF6B6B)),
// //             SizedBox(width: 12),
// //             Text('تأكيد المسح'),
// //           ],
// //         ),
// //         content: const Text('هل تريد مسح جميع المنتجات من الفاتورة؟'),
// //         actions: [
// //           TextButton(
// //             onPressed: () => Navigator.pop(context),
// //             child: const Text('إلغاء'),
// //           ),
// //           ElevatedButton(
// //             onPressed: () {
// //               setState(() {
// //                 _invoiceItems.clear();
// //                 _totalAmount = 0.0;
// //               });
// //               Navigator.pop(context);
// //             },
// //             style: ElevatedButton.styleFrom(
// //               backgroundColor: const Color(0xFFFF6B6B),
// //               foregroundColor: Colors.white,
// //             ),
// //             child: const Text('مسح'),
// //           ),
// //         ],
// //       ),
// //     );
// //   }
// //
// //   Future<void> _sendInvoiceWhatsApp() async {
// //     if (_invoiceItems.isEmpty) {
// //       if (!mounted) return;
// //       ScaffoldMessenger.of(context).showSnackBar(
// //         SnackBar(
// //           content: const Row(
// //             children: [
// //               Icon(Icons.warning, color: Colors.white),
// //               SizedBox(width: 12),
// //               Text('الفاتورة فارغة'),
// //             ],
// //           ),
// //           backgroundColor: const Color(0xFFFF6B6B),
// //           behavior: SnackBarBehavior.floating,
// //           shape: RoundedRectangleBorder(
// //             borderRadius: BorderRadius.circular(12),
// //           ),
// //         ),
// //       );
// //       return;
// //     }
// //
// //     final phoneController = TextEditingController();
// //     final nameController = TextEditingController();
// //
// //     if (!mounted) return;
// //
// //     showDialog(
// //       context: context,
// //       builder: (dialogContext) => AlertDialog(
// //         shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
// //         title: Row(
// //           children: [
// //             Container(
// //               padding: const EdgeInsets.all(8),
// //               decoration: BoxDecoration(
// //                 gradient: const LinearGradient(
// //                   colors: [Color(0xFF25D366), Color(0xFF128C7E)],
// //                 ),
// //                 borderRadius: BorderRadius.circular(12),
// //               ),
// //               child: const Icon(Icons.send, color: Colors.white, size: 24),
// //             ),
// //             const SizedBox(width: 12),
// //             const Text('إرسال الفاتورة', style: TextStyle(fontSize: 18)),
// //           ],
// //         ),
// //         content: SingleChildScrollView(
// //           child: Column(
// //             mainAxisSize: MainAxisSize.min,
// //             crossAxisAlignment: CrossAxisAlignment.start,
// //             children: [
// //               const Text(
// //                 'معلومات العميل (اختياري)',
// //                 style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
// //               ),
// //               const SizedBox(height: 16),
// //               TextField(
// //                 controller: nameController,
// //                 decoration: InputDecoration(
// //                   labelText: 'اسم العميل',
// //                   prefixIcon: const Icon(Icons.person_outline),
// //                   border: OutlineInputBorder(
// //                     borderRadius: BorderRadius.circular(12),
// //                   ),
// //                 ),
// //               ),
// //               const SizedBox(height: 12),
// //               TextField(
// //                 controller: phoneController,
// //                 keyboardType: TextInputType.phone,
// //                 decoration: InputDecoration(
// //                   labelText: 'رقم الهاتف (مع كود الدولة)',
// //                   hintText: '+966501234567',
// //                   prefixIcon: const Icon(Icons.phone_outlined),
// //                   border: OutlineInputBorder(
// //                     borderRadius: BorderRadius.circular(12),
// //                   ),
// //                 ),
// //               ),
// //               const SizedBox(height: 16),
// //               Container(
// //                 padding: const EdgeInsets.all(12),
// //                 decoration: BoxDecoration(
// //                   color: const Color(0xFF4FACFE).withOpacity(0.1),
// //                   borderRadius: BorderRadius.circular(12),
// //                   border: Border.all(
// //                     color: const Color(0xFF4FACFE).withOpacity(0.3),
// //                   ),
// //                 ),
// //                 child: Row(
// //                   children: [
// //                     const Icon(
// //                       Icons.info_outline,
// //                       color: Color(0xFF4FACFE),
// //                       size: 20,
// //                     ),
// //                     const SizedBox(width: 8),
// //                     Expanded(
// //                       child: Text(
// //                         'سيتم إنشاء فاتورة PDF وإرسالها عبر WhatsApp',
// //                         style: TextStyle(fontSize: 12, color: Colors.grey[700]),
// //                       ),
// //                     ),
// //                   ],
// //                 ),
// //               ),
// //             ],
// //           ),
// //         ),
// //         actions: [
// //           TextButton(
// //             onPressed: () => Navigator.pop(dialogContext),
// //             child: const Text('إلغاء'),
// //           ),
// //           ElevatedButton.icon(
// //             onPressed: () async {
// //               // إغلاق الـ Dialog الأول
// //               Navigator.pop(dialogContext);
// //
// //               // الانتظار قليلاً لضمان إغلاق الـ Dialog
// //               await Future.delayed(const Duration(milliseconds: 100));
// //
// //               if (!mounted) return;
// //
// //               // عرض Loading Dialog مع context جديد
// //               showDialog(
// //                 context: context,
// //                 barrierDismissible: false,
// //                 builder: (loadingContext) => PopScope(
// //                   canPop: false,
// //                   child: const Center(
// //                     child: Card(
// //                       child: Padding(
// //                         padding: EdgeInsets.all(24),
// //                         child: Column(
// //                           mainAxisSize: MainAxisSize.min,
// //                           children: [
// //                             CircularProgressIndicator(),
// //                             SizedBox(height: 16),
// //                             Text('جاري إنشاء الفاتورة...'),
// //                           ],
// //                         ),
// //                       ),
// //                     ),
// //                   ),
// //                 ),
// //               );
// //
// //               try {
// //                 final pdfFile = await InvoicePDFService.generateInvoicePDF(
// //                   items: _invoiceItems,
// //                   totalAmount: _totalAmount,
// //                   customerName: nameController.text.isNotEmpty
// //                       ? nameController.text
// //                       : null,
// //                   customerPhone: phoneController.text.isNotEmpty
// //                       ? phoneController.text
// //                       : null,
// //                 );
// //
// //                 // إغلاق Loading Dialog
// //                 if (mounted) {
// //                   Navigator.of(context).pop();
// //
// //                   // الانتظار قليلاً قبل فتح WhatsApp
// //                   await Future.delayed(const Duration(milliseconds: 200));
// //                 }
// //
// //                 if (phoneController.text.isNotEmpty) {
// //                   final message =
// //                       'مرحباً ${nameController.text.isNotEmpty ? nameController.text : ""}\n'
// //                       'إليك فاتورتك بقيمة ${_totalAmount.toStringAsFixed(2)} ر.س\n'
// //                       'شكراً لتعاملك معنا!';
// //
// //                   await InvoicePDFService.shareWithMessage(
// //                     pdfFile,
// //                     phoneController.text,
// //                     message,
// //                   );
// //                 } else {
// //                   await InvoicePDFService.shareViaWhatsApp(pdfFile);
// //                 }
// //
// //                 if (mounted) {
// //                   ScaffoldMessenger.of(context).showSnackBar(
// //                     SnackBar(
// //                       content: const Row(
// //                         children: [
// //                           Icon(Icons.check_circle, color: Colors.white),
// //                           SizedBox(width: 12),
// //                           Text('تم إنشاء الفاتورة بنجاح!'),
// //                         ],
// //                       ),
// //                       backgroundColor: const Color(0xFF11998E),
// //                       behavior: SnackBarBehavior.floating,
// //                       shape: RoundedRectangleBorder(
// //                         borderRadius: BorderRadius.circular(12),
// //                       ),
// //                     ),
// //                   );
// //
// //                   setState(() {
// //                     _invoiceItems.clear();
// //                     _totalAmount = 0.0;
// //                   });
// //                 }
// //               } catch (e) {
// //                 // إغلاق Loading Dialog في حالة الخطأ
// //                 if (mounted) {
// //                   Navigator.of(context).pop();
// //
// //                   await Future.delayed(const Duration(milliseconds: 100));
// //
// //                   ScaffoldMessenger.of(context).showSnackBar(
// //                     SnackBar(
// //                       content: Row(
// //                         children: [
// //                           const Icon(Icons.error_outline, color: Colors.white),
// //                           const SizedBox(width: 12),
// //                           Expanded(child: Text('خطأ: ${e.toString()}')),
// //                         ],
// //                       ),
// //                       backgroundColor: const Color(0xFFFF6B6B),
// //                       behavior: SnackBarBehavior.floating,
// //                       shape: RoundedRectangleBorder(
// //                         borderRadius: BorderRadius.circular(12),
// //                       ),
// //                     ),
// //                   );
// //                 }
// //               }
// //             },
// //             icon: const Icon(Icons.send_rounded),
// //             label: const Text('إرسال'),
// //             style: ElevatedButton.styleFrom(
// //               backgroundColor: const Color(0xFF25D366),
// //               foregroundColor: Colors.white,
// //               padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
// //               shape: RoundedRectangleBorder(
// //                 borderRadius: BorderRadius.circular(12),
// //               ),
// //             ),
// //           ),
// //         ],
// //       ),
// //     );
// //   }
// //
// //   @override
// //   void dispose() {
// //     _searchController.dispose();
// //     _scrollController.dispose();
// //     _cameraController.dispose();
// //     _debounce?.cancel();
// //     super.dispose();
// //   }
// //
// //   @override
// //   Widget build(BuildContext context) {
// //     return BlocProvider.value(
// //       value: viewModel,
// //       child: GestureDetector(
// //         behavior: HitTestBehavior.opaque,
// //         onTap: () {
// //           // هذا السطر يخفي الكيبورد وأي فوكَس مفتوح
// //           FocusScope.of(context).unfocus();
// //         },
// //         child: Scaffold(
// //           backgroundColor: const Color(0xFFF8F9FE),
// //           body: SafeArea(
// //             child: Column(
// //               children: [
// //                 _buildCameraSection(),
// //                 _buildSearchSection(),
// //                 Expanded(
// //                   child: BlocConsumer<SearchCubit, SearchState>(
// //                     listener: (context, state) {
// //                       if (state is SearchSuccess) {
// //                         setState(() {
// //                           _searchResults = state.searchEntity?.results ?? [];
// //                         });
// //                       } else if (state is SearchFailure) {
// //                         ScaffoldMessenger.of(context).showSnackBar(
// //                           SnackBar(
// //                             content: Row(
// //                               children: [
// //                                 const Icon(
// //                                   Icons.error_outline,
// //                                   color: Colors.white,
// //                                 ),
// //                                 const SizedBox(width: 12),
// //                                 Expanded(
// //                                   child: Text(
// //                                     'خطأ: ${state.exception.toString()}',
// //                                   ),
// //                                 ),
// //                               ],
// //                             ),
// //                             backgroundColor: const Color(0xFFFF6B6B),
// //                             behavior: SnackBarBehavior.floating,
// //                             shape: RoundedRectangleBorder(
// //                               borderRadius: BorderRadius.circular(12),
// //                             ),
// //                             margin: const EdgeInsets.all(16),
// //                           ),
// //                         );
// //                       }
// //                     },
// //                     builder: (context, state) {
// //                       return _buildMainContent(state);
// //                     },
// //                   ),
// //                 ),
// //               ],
// //             ),
// //           ),
// //         ),
// //       ),
// //     );
// //   }
// //
// //   Widget _buildCameraSection() {
// //     return Container(
// //       height: MediaQuery.of(context).size.height * 0.25,
// //       decoration: BoxDecoration(
// //         gradient: LinearGradient(
// //           colors: [const Color(0xFF2D3436), const Color(0xFF636E72)],
// //           begin: Alignment.topCenter,
// //           end: Alignment.bottomCenter,
// //         ),
// //         boxShadow: [
// //           BoxShadow(
// //             color: Colors.black.withOpacity(0.3),
// //             blurRadius: 15,
// //             offset: const Offset(0, 5),
// //           ),
// //         ],
// //       ),
// //       child: Stack(
// //         children: [
// //           if (!_isCameraLocked)
// //             MobileScanner(
// //               controller: _cameraController,
// //               onDetect: (capture) {
// //                 final barcodes = capture.barcodes;
// //                 if (barcodes.isNotEmpty && barcodes.first.rawValue != null) {
// //                   _onBarcodeDetected(barcodes.first.rawValue!);
// //                 }
// //               },
// //             )
// //           else
// //             Center(
// //               child: Column(
// //                 mainAxisAlignment: MainAxisAlignment.center,
// //                 children: [
// //                   Icon(
// //                     Icons.lock_rounded,
// //                     size: 48,
// //                     color: Colors.white.withOpacity(0.5),
// //                   ),
// //                   const SizedBox(height: 8),
// //                   Text(
// //                     'الكاميرا مقفلة',
// //                     style: TextStyle(
// //                       color: Colors.white.withOpacity(0.7),
// //                       fontSize: 16,
// //                       fontWeight: FontWeight.w500,
// //                     ),
// //                   ),
// //                 ],
// //               ),
// //             ),
// //           Positioned(
// //             bottom: 12,
// //             left: 12,
// //             right: 12,
// //             child: Row(
// //               mainAxisAlignment: MainAxisAlignment.spaceBetween,
// //               children: [
// //                 // Total Amount
// //                 Column(
// //                   crossAxisAlignment: CrossAxisAlignment.start,
// //                   children: [
// //                     Text(
// //                       'الإجمالي',
// //                       style: TextStyle(
// //                         color: Colors.white.withOpacity(0.9),
// //                         fontSize: 13,
// //                         fontWeight: FontWeight.w500,
// //                       ),
// //                     ),
// //                     const SizedBox(height: 2),
// //                     Text(
// //                       '${_totalAmount.toStringAsFixed(2)} ر.س',
// //                       style: const TextStyle(
// //                         color: Colors.white,
// //                         fontSize: 24,
// //                         fontWeight: FontWeight.bold,
// //                       ),
// //                     ),
// //                   ],
// //                 ),
// //
// //                 // Items Count
// //                 Container(
// //                   padding: const EdgeInsets.symmetric(
// //                     horizontal: 16,
// //                     vertical: 10,
// //                   ),
// //                   decoration: BoxDecoration(
// //                     color: Colors.white.withOpacity(0.2),
// //                     borderRadius: BorderRadius.circular(12),
// //                   ),
// //                   child: Row(
// //                     mainAxisSize: MainAxisSize.min,
// //                     children: [
// //                       const Icon(
// //                         Icons.shopping_cart_rounded,
// //                         color: Colors.white,
// //                         size: 20,
// //                       ),
// //                       const SizedBox(width: 8),
// //                       Text(
// //                         '${_invoiceItems.length} منتج',
// //                         style: const TextStyle(
// //                           color: Colors.white,
// //                           fontSize: 16,
// //                           fontWeight: FontWeight.bold,
// //                         ),
// //                       ),
// //                     ],
// //                   ),
// //                 ),
// //               ],
// //             ),
// //           ),
// //           Positioned(
// //             top: 12,
// //             left: 12,
// //             right: 12,
// //             child: Row(
// //               mainAxisAlignment: MainAxisAlignment.spaceBetween,
// //               children: [
// //                 _buildCameraButton(
// //                   icon: _isCameraLocked
// //                       ? Icons.lock_rounded
// //                       : Icons.lock_open_rounded,
// //                   onPressed: _toggleCamera,
// //                   color: _isCameraLocked
// //                       ? const Color(0xFFFF6B6B)
// //                       : const Color(0xFF11998E),
// //                 ),
// //
// //                 if (!_isCameraLocked)
// //                   _buildCameraButton(
// //                     icon: _torchOn
// //                         ? Icons.flash_on_rounded
// //                         : Icons.flash_off_rounded,
// //                     onPressed: _toggleTorch,
// //                     color: _torchOn
// //                         ? const Color(0xFFFFA06B)
// //                         : Colors.white.withOpacity(0.3),
// //                   ),
// //               ],
// //             ),
// //           ),
// //
// //           if (!_isCameraLocked)
// //             Center(
// //               child: Container(
// //                 width: 200,
// //                 height: 100,
// //                 decoration: BoxDecoration(
// //                   border: Border.all(color: const Color(0xFF6C63FF), width: 3),
// //                   borderRadius: BorderRadius.circular(12),
// //                 ),
// //               ),
// //             ),
// //         ],
// //       ),
// //     );
// //   }
// //
// //   Widget _buildCameraButton({
// //     required IconData icon,
// //     required VoidCallback onPressed,
// //     required Color color,
// //   }) {
// //     return Container(
// //       decoration: BoxDecoration(
// //         color: color,
// //         borderRadius: BorderRadius.circular(12),
// //         boxShadow: [
// //           BoxShadow(
// //             color: color.withOpacity(0.3),
// //             blurRadius: 8,
// //             offset: const Offset(0, 4),
// //           ),
// //         ],
// //       ),
// //       child: IconButton(
// //         icon: Icon(icon, color: Colors.white),
// //         onPressed: onPressed,
// //       ),
// //     );
// //   }
// //
// //   Widget _buildSearchSection() {
// //     return Container(
// //       margin: const EdgeInsets.all(16),
// //       padding: const EdgeInsets.symmetric(horizontal: 16),
// //       decoration: BoxDecoration(
// //         color: Colors.white,
// //         borderRadius: BorderRadius.circular(16),
// //         boxShadow: [
// //           BoxShadow(
// //             color: Colors.black.withOpacity(0.1),
// //             blurRadius: 15,
// //             offset: const Offset(0, 5),
// //           ),
// //         ],
// //       ),
// //       child: Row(
// //         children: [
// //           const Icon(Icons.search_rounded, color: Color(0xFF6C63FF)),
// //           const SizedBox(width: 12),
// //           Expanded(
// //             child: TextField(
// //               controller: _searchController,
// //               decoration: const InputDecoration(
// //                 hintText: 'ابحث عن منتج أو امسح الباركود...',
// //                 border: InputBorder.none,
// //               ),
// //               style: const TextStyle(fontSize: 16),
// //             ),
// //           ),
// //           if (_searchController.text.isNotEmpty)
// //             IconButton(
// //               icon: const Icon(Icons.clear_rounded, color: Colors.grey),
// //               onPressed: () {
// //                 _searchController.clear();
// //                 setState(() {
// //                   _searchResults.clear();
// //                 });
// //               },
// //             ),
// //         ],
// //       ),
// //     );
// //   }
// //
// //   Widget _buildMainContent(SearchState state) {
// //     return ListView(
// //       controller: _scrollController,
// //       padding: const EdgeInsets.symmetric(horizontal: 16),
// //       children: [
// //         if (_searchResults.isNotEmpty) ...[
// //           Container(
// //             padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
// //             margin: const EdgeInsets.only(bottom: 12),
// //             decoration: BoxDecoration(
// //               gradient: LinearGradient(
// //                 colors: [
// //                   const Color(0xFF6C63FF).withOpacity(0.1),
// //                   const Color(0xFF5A52E0).withOpacity(0.05),
// //                 ],
// //               ),
// //               borderRadius: BorderRadius.circular(12),
// //               border: Border.all(
// //                 color: const Color(0xFF6C63FF).withOpacity(0.3),
// //               ),
// //             ),
// //             child: Row(
// //               children: [
// //                 const Icon(
// //                   Icons.search_rounded,
// //                   color: Color(0xFF6C63FF),
// //                   size: 20,
// //                 ),
// //                 const SizedBox(width: 8),
// //                 Text(
// //                   'نتائج البحث (${_searchResults.length})',
// //                   style: const TextStyle(
// //                     fontWeight: FontWeight.bold,
// //                     fontSize: 14,
// //                     color: Color(0xFF6C63FF),
// //                   ),
// //                 ),
// //               ],
// //             ),
// //           ),
// //           ..._searchResults.map((product) => _buildSearchResultCard(product)),
// //           const SizedBox(height: 24),
// //         ],
// //
// //         if (state is SearchLoading && _searchResults.isEmpty)
// //           _buildLoadingState(),
// //
// //         if (_invoiceItems.isNotEmpty) ...[
// //           Container(
// //             padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
// //             margin: const EdgeInsets.only(bottom: 12),
// //             decoration: BoxDecoration(
// //               gradient: LinearGradient(
// //                 colors: [
// //                   const Color(0xFF11998E).withOpacity(0.1),
// //                   const Color(0xFF38EF7D).withOpacity(0.05),
// //                 ],
// //               ),
// //               borderRadius: BorderRadius.circular(12),
// //               border: Border.all(
// //                 color: const Color(0xFF11998E).withOpacity(0.3),
// //               ),
// //             ),
// //             child: Row(
// //               children: [
// //                 const Icon(
// //                   Icons.receipt_long_rounded,
// //                   color: Color(0xFF11998E),
// //                   size: 20,
// //                 ),
// //                 const SizedBox(width: 8),
// //                 Text(
// //                   'الفاتورة (${_invoiceItems.length} منتج)',
// //                   style: const TextStyle(
// //                     fontWeight: FontWeight.bold,
// //                     fontSize: 14,
// //                     color: Color(0xFF11998E),
// //                   ),
// //                 ),
// //               ],
// //             ),
// //           ),
// //           ..._invoiceItems.asMap().entries.map((entry) {
// //             return _buildInvoiceItemCard(entry.key, entry.value);
// //           }),
// //           _buildBottomBar(),
// //         ],
// //
// //         if (_invoiceItems.isEmpty &&
// //             _searchResults.isEmpty &&
// //             state is! SearchLoading)
// //           _buildEmptyState(),
// //
// //         const SizedBox(height: 16),
// //       ],
// //     );
// //   }
// //
// //   Widget _buildSearchResultCard(Results product) {
// //     final isInInvoice = _invoiceItems.any(
// //       (item) => item.product.productId == product.productId,
// //     );
// //
// //     return Container(
// //       margin: const EdgeInsets.only(bottom: 12),
// //       decoration: BoxDecoration(
// //         color: Colors.white,
// //         borderRadius: BorderRadius.circular(16),
// //         border: Border.all(
// //           color: isInInvoice
// //               ? const Color(0xFF11998E).withOpacity(0.5)
// //               : const Color(0xFF6C63FF).withOpacity(0.3),
// //         ),
// //         boxShadow: [
// //           BoxShadow(
// //             color: Colors.black.withOpacity(0.05),
// //             blurRadius: 10,
// //             offset: const Offset(0, 4),
// //           ),
// //         ],
// //       ),
// //       child: Padding(
// //         padding: const EdgeInsets.all(12),
// //         child: Row(
// //           children: [
// //             Container(
// //               padding: const EdgeInsets.all(12),
// //               decoration: BoxDecoration(
// //                 gradient: const LinearGradient(
// //                   colors: [Color(0xFF6C63FF), Color(0xFF5A52E0)],
// //                 ),
// //                 borderRadius: BorderRadius.circular(12),
// //               ),
// //               child: const Icon(
// //                 Icons.inventory_2_rounded,
// //                 color: Colors.white,
// //                 size: 24,
// //               ),
// //             ),
// //             const SizedBox(width: 12),
// //             Expanded(
// //               child: Column(
// //                 crossAxisAlignment: CrossAxisAlignment.start,
// //                 children: [
// //                   Text(
// //                     product.productName ?? '',
// //                     style: const TextStyle(
// //                       fontSize: 15,
// //                       fontWeight: FontWeight.bold,
// //                       color: Color(0xFF2D3436),
// //                     ),
// //                     maxLines: 2,
// //                     overflow: TextOverflow.ellipsis,
// //                   ),
// //                   const SizedBox(height: 4),
// //                   Row(
// //                     children: [
// //                       Text(
// //                         '${product.sellingPrice ?? '0'} ر.س',
// //                         style: const TextStyle(
// //                           fontSize: 12,
// //                           fontWeight: FontWeight.bold,
// //                           color: Color(0xFF11998E),
// //                         ),
// //                       ),
// //                     ],
// //                   ),
// //                 ],
// //               ),
// //             ),
// //             const SizedBox(width: 8),
// //             ElevatedButton.icon(
// //               onPressed: () => _addToInvoice(product),
// //               icon: Icon(
// //                 isInInvoice ? Icons.add_circle_outline : Icons.add_rounded,
// //                 size: 20,
// //               ),
// //               label: Text(isInInvoice ? 'إضافة المزيد' : 'إضافة'),
// //               style: ElevatedButton.styleFrom(
// //                 backgroundColor: const Color(0xFF6C63FF),
// //                 foregroundColor: Colors.white,
// //                 padding: const EdgeInsets.symmetric(
// //                   horizontal: 16,
// //                   vertical: 12,
// //                 ),
// //                 shape: RoundedRectangleBorder(
// //                   borderRadius: BorderRadius.circular(12),
// //                 ),
// //               ),
// //             ),
// //           ],
// //         ),
// //       ),
// //     );
// //   }
// //
// //   Widget _buildInvoiceItemCard(int index, InvoiceItem item) {
// //     final price = double.tryParse(item.product.sellingPrice ?? '0') ?? 0.0;
// //     final total = price * item.quantity;
// //
// //     return Container(
// //       margin: const EdgeInsets.only(bottom: 12),
// //       decoration: BoxDecoration(
// //         color: Colors.white,
// //         borderRadius: BorderRadius.circular(16),
// //         boxShadow: [
// //           BoxShadow(
// //             color: Colors.black.withOpacity(0.05),
// //             blurRadius: 10,
// //             offset: const Offset(0, 4),
// //           ),
// //         ],
// //       ),
// //       child: Padding(
// //         padding: const EdgeInsets.all(16),
// //         child: Row(
// //           children: [
// //             Expanded(
// //               child: Column(
// //                 crossAxisAlignment: CrossAxisAlignment.start,
// //                 children: [
// //                   Text(
// //                     item.product.productName ?? '',
// //                     style: const TextStyle(
// //                       fontSize: 16,
// //                       fontWeight: FontWeight.bold,
// //                       color: Color(0xFF2D3436),
// //                     ),
// //                     maxLines: 2,
// //                     overflow: TextOverflow.ellipsis,
// //                   ),
// //                   const SizedBox(height: 4),
// //                   Text(
// //                     '${price.toStringAsFixed(2)} ر.س × ${item.quantity}',
// //                     style: TextStyle(fontSize: 14, color: Colors.grey[600]),
// //                   ),
// //                 ],
// //               ),
// //             ),
// //
// //             const SizedBox(width: 12),
// //
// //             Container(
// //               decoration: BoxDecoration(
// //                 color: Colors.grey[100],
// //                 borderRadius: BorderRadius.circular(12),
// //               ),
// //               child: Row(
// //                 mainAxisSize: MainAxisSize.min,
// //                 children: [
// //                   IconButton(
// //                     icon: const Icon(Icons.remove_rounded, size: 20),
// //                     onPressed: () => _updateQuantity(index, item.quantity - 1),
// //                     color: const Color(0xFFFF6B6B),
// //                     padding: const EdgeInsets.all(8),
// //                     constraints: const BoxConstraints(),
// //                   ),
// //                   Container(
// //                     padding: const EdgeInsets.symmetric(horizontal: 12),
// //                     child: Text(
// //                       '${item.quantity}',
// //                       style: const TextStyle(
// //                         fontSize: 16,
// //                         fontWeight: FontWeight.bold,
// //                       ),
// //                     ),
// //                   ),
// //                   IconButton(
// //                     icon: const Icon(Icons.add_rounded, size: 20),
// //                     onPressed: () => _updateQuantity(index, item.quantity + 1),
// //                     color: const Color(0xFF11998E),
// //                     padding: const EdgeInsets.all(8),
// //                     constraints: const BoxConstraints(),
// //                   ),
// //                 ],
// //               ),
// //             ),
// //
// //             const SizedBox(width: 12),
// //
// //             Column(
// //               crossAxisAlignment: CrossAxisAlignment.end,
// //               children: [
// //                 Text(
// //                   '${total.toStringAsFixed(2)}',
// //                   style: const TextStyle(
// //                     fontSize: 18,
// //                     fontWeight: FontWeight.bold,
// //                     color: Color(0xFF11998E),
// //                   ),
// //                 ),
// //                 const Text(
// //                   'ر.س',
// //                   style: TextStyle(fontSize: 12, color: Color(0xFF11998E)),
// //                 ),
// //               ],
// //             ),
// //           ],
// //         ),
// //       ),
// //     );
// //   }
// //
// //   Widget _buildLoadingState() {
// //     return Center(
// //       child: Padding(
// //         padding: const EdgeInsets.all(40),
// //         child: Column(
// //           mainAxisSize: MainAxisSize.min,
// //           children: [
// //             Container(
// //               padding: const EdgeInsets.all(20),
// //               decoration: BoxDecoration(
// //                 gradient: LinearGradient(
// //                   colors: [
// //                     const Color(0xFF6C63FF).withOpacity(0.1),
// //                     const Color(0xFF5A52E0).withOpacity(0.05),
// //                   ],
// //                 ),
// //                 shape: BoxShape.circle,
// //               ),
// //               child: const CircularProgressIndicator(
// //                 color: Color(0xFF6C63FF),
// //                 strokeWidth: 3,
// //               ),
// //             ),
// //             const SizedBox(height: 24),
// //             const Text(
// //               'جاري البحث...',
// //               style: TextStyle(
// //                 fontSize: 16,
// //                 fontWeight: FontWeight.w600,
// //                 color: Color(0xFF2D3436),
// //               ),
// //             ),
// //           ],
// //         ),
// //       ),
// //     );
// //   }
// //
// //   Widget _buildEmptyState() {
// //     return Center(
// //       child: Padding(
// //         padding: const EdgeInsets.all(40),
// //         child: Column(
// //           mainAxisSize: MainAxisSize.min,
// //           children: [
// //             Container(
// //               padding: const EdgeInsets.all(40),
// //               decoration: BoxDecoration(
// //                 gradient: LinearGradient(
// //                   colors: [
// //                     const Color(0xFF6C63FF).withOpacity(0.1),
// //                     const Color(0xFF5A52E0).withOpacity(0.05),
// //                   ],
// //                 ),
// //                 shape: BoxShape.circle,
// //               ),
// //               child: Icon(
// //                 Icons.qr_code_scanner_rounded,
// //                 size: 80,
// //                 color: Colors.grey[300],
// //               ),
// //             ),
// //             const SizedBox(height: 24),
// //             const Text(
// //               'ابدأ بإضافة المنتجات',
// //               style: TextStyle(
// //                 fontSize: 20,
// //                 fontWeight: FontWeight.bold,
// //                 color: Color(0xFF2D3436),
// //               ),
// //             ),
// //             const SizedBox(height: 12),
// //             Text(
// //               'امسح الباركود أو ابحث عن المنتج',
// //               style: TextStyle(fontSize: 15, color: Colors.grey[500]),
// //             ),
// //           ],
// //         ),
// //       ),
// //     );
// //   }
// //
// //   Widget _buildBottomBar() {
// //     return Container(
// //       padding: const EdgeInsets.all(16),
// //       child: Column(
// //         mainAxisSize: MainAxisSize.min,
// //         children: [
// //           Row(
// //             children: [
// //               // Clear Button
// //               Expanded(
// //                 child: OutlinedButton.icon(
// //                   onPressed: _invoiceItems.isEmpty ? null : _clearInvoice,
// //                   icon: const Icon(Icons.delete_outline_rounded, size: 20),
// //                   label: const Text('مسح الكل'),
// //                   style: OutlinedButton.styleFrom(
// //                     foregroundColor: Colors.red,
// //                     side: const BorderSide(
// //                       color: Colors.deepOrangeAccent,
// //                       width: 2,
// //                     ),
// //                     padding: const EdgeInsets.symmetric(vertical: 14),
// //                     shape: RoundedRectangleBorder(
// //                       borderRadius: BorderRadius.circular(12),
// //                     ),
// //                     disabledForegroundColor: Colors.white.withOpacity(0.3),
// //                     disabledBackgroundColor: Colors.transparent,
// //                   ),
// //                 ),
// //               ),
// //
// //               const SizedBox(width: 12),
// //
// //               // Send Invoice Button
// //               Expanded(
// //                 flex: 2,
// //                 child: ElevatedButton.icon(
// //                   onPressed: _invoiceItems.isEmpty
// //                       ? null
// //                       : _sendInvoiceWhatsApp,
// //                   icon: const Icon(Icons.send_rounded, size: 20),
// //                   label: const Text(
// //                     'إرسال الفاتورة',
// //                     style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
// //                   ),
// //                   style: ElevatedButton.styleFrom(
// //                     backgroundColor: Colors.white,
// //                     foregroundColor: const Color(0xFF11998E),
// //                     padding: const EdgeInsets.symmetric(vertical: 14),
// //                     elevation: 0,
// //                     shape: RoundedRectangleBorder(
// //                       borderRadius: BorderRadius.circular(12),
// //                     ),
// //                     disabledBackgroundColor: const Color(
// //                       0xFF11998E,
// //                     ).withOpacity(0.3),
// //                     disabledForegroundColor: const Color(
// //                       0xFF11998E,
// //                     ).withOpacity(0.5),
// //                   ),
// //                 ),
// //               ),
// //             ],
// //           ),
// //         ],
// //       ),
// //     );
// //   }
// // }
//
// import 'dart:async';
//
// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:stock_up/core/di/di.dart';
// import 'package:stock_up/features/POSPage/presentation/widgets/invoice_item.dart';
// import 'package:stock_up/features/POSPage/presentation/widgets/invoice_pdf_service.dart';
// import 'package:stock_up/features/Search/data/models/response/search_model.dart';
// import 'package:stock_up/features/Search/presentation/bloc/Search_cubit.dart';
//
// class POSPage extends StatefulWidget {
//   const POSPage({super.key});
//
//   @override
//   State<POSPage> createState() => _POSPageState();
// }
//
// class _POSPageState extends State<POSPage> {
//   late SearchCubit viewModel;
//   final TextEditingController _searchController = TextEditingController();
//   final ScrollController _scrollController = ScrollController();
//   final FocusNode _searchFocusNode = FocusNode();
//
//   Timer? _debounce;
//   List<InvoiceItem> _invoiceItems = [];
//   List<Results> _searchResults = [];
//   double _totalAmount = 0.0;
//   bool _isSearching = false;
//   bool _isKeyboardVisible = false;
//
//   @override
//   void initState() {
//     super.initState();
//     viewModel = getIt.get<SearchCubit>();
//     _searchController.addListener(_onSearchChanged);
//
//     // التأكد من أن Focus يبقى على حقل البحث دائماً
//     WidgetsBinding.instance.addPostFrameCallback((_) {
//       _searchFocusNode.requestFocus();
//     });
//
//     // إعادة Focus إذا تم فقدانه
//     _searchFocusNode.addListener(() {
//       if (!_searchFocusNode.hasFocus && mounted) {
//         Future.delayed(const Duration(milliseconds: 100), () {
//           if (mounted && !_searchFocusNode.hasFocus) {
//             _searchFocusNode.requestFocus();
//           }
//         });
//       }
//     });
//   }
//
//   void _onSearchChanged() {
//     if (_debounce?.isActive ?? false) _debounce!.cancel();
//
//     if (_searchController.text.isEmpty) {
//       setState(() {
//         _searchResults.clear();
//         _isSearching = false;
//       });
//       return;
//     }
//
//     setState(() {
//       _isSearching = true;
//     });
//
//     _debounce = Timer(const Duration(milliseconds: 500), () {
//       if (_searchController.text.isNotEmpty) {
//         viewModel.search(_searchController.text, 1);
//       }
//     });
//   }
//
//   void _toggleKeyboard() {
//     if (_isKeyboardVisible) {
//       // إخفاء لوحة المفاتيح
//       FocusScope.of(context).unfocus();
//       setState(() {
//         _isKeyboardVisible = false;
//       });
//       // إعادة Focus بدون إظهار الكيبورد
//       Future.delayed(const Duration(milliseconds: 100), () {
//         if (mounted) {
//           _searchFocusNode.requestFocus();
//         }
//       });
//     } else {
//       // إظهار لوحة المفاتيح
//       setState(() {
//         _isKeyboardVisible = true;
//       });
//       _searchFocusNode.requestFocus();
//     }
//   }
//
//   void _addToInvoice(Results product) {
//     setState(() {
//       final existingIndex = _invoiceItems.indexWhere(
//         (item) => item.product.productId == product.productId,
//       );
//
//       if (existingIndex != -1) {
//         _invoiceItems[existingIndex].quantity++;
//       } else {
//         _invoiceItems.add(InvoiceItem(product: product, quantity: 1));
//       }
//       _calculateTotal();
//     });
//
//     ScaffoldMessenger.of(context).showSnackBar(
//       SnackBar(
//         content: Row(
//           children: [
//             const Icon(Icons.check_circle, color: Colors.white, size: 16),
//             const SizedBox(width: 8),
//             Expanded(
//               child: Text(
//                 'تم إضافة ${product.productName}',
//                 style: const TextStyle(fontSize: 9),
//               ),
//             ),
//           ],
//         ),
//         backgroundColor: Colors.green[700],
//         behavior: SnackBarBehavior.floating,
//         shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
//         margin: const EdgeInsets.all(12),
//         duration: const Duration(seconds: 1),
//       ),
//     );
//
//     _searchController.clear();
//     setState(() {
//       _searchResults.clear();
//     });
//
//     // إعادة Focus لحقل البحث
//     Future.delayed(const Duration(milliseconds: 100), () {
//       if (mounted) {
//         _searchFocusNode.requestFocus();
//       }
//     });
//   }
//
//   void _removeFromInvoice(int index) {
//     setState(() {
//       _invoiceItems.removeAt(index);
//       _calculateTotal();
//     });
//
//     // إعادة Focus لحقل البحث
//     Future.delayed(const Duration(milliseconds: 100), () {
//       if (mounted) {
//         _searchFocusNode.requestFocus();
//       }
//     });
//   }
//
//   void _updateQuantity(int index, int newQuantity) {
//     if (newQuantity <= 0) {
//       _removeFromInvoice(index);
//       return;
//     }
//     setState(() {
//       _invoiceItems[index].quantity = newQuantity;
//       _calculateTotal();
//     });
//
//     // إعادة Focus لحقل البحث
//     Future.delayed(const Duration(milliseconds: 100), () {
//       if (mounted) {
//         _searchFocusNode.requestFocus();
//       }
//     });
//   }
//
//   void _calculateTotal() {
//     _totalAmount = _invoiceItems.fold(0.0, (sum, item) {
//       final price = double.tryParse(item.product.sellingPrice ?? '0') ?? 0.0;
//       return sum + (price * item.quantity);
//     });
//   }
//
//   void _clearInvoice() {
//     showDialog(
//       context: context,
//       builder: (context) => AlertDialog(
//         shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
//         title: const Row(
//           children: [
//             Icon(Icons.warning, color: Colors.orange, size: 20),
//             SizedBox(width: 8),
//             Text('تأكيد المسح', style: TextStyle(fontSize: 10)),
//           ],
//         ),
//         content: const Text(
//           'هل تريد مسح جميع المنتجات من الفاتورة؟',
//           style: TextStyle(fontSize: 9),
//         ),
//         actions: [
//           TextButton(
//             onPressed: () {
//               Navigator.pop(context);
//               // إعادة Focus بعد إغلاق Dialog
//               Future.delayed(const Duration(milliseconds: 100), () {
//                 if (mounted) {
//                   _searchFocusNode.requestFocus();
//                 }
//               });
//             },
//             child: const Text('إلغاء', style: TextStyle(fontSize: 9)),
//           ),
//           ElevatedButton(
//             onPressed: () {
//               setState(() {
//                 _invoiceItems.clear();
//                 _totalAmount = 0.0;
//               });
//               Navigator.pop(context);
//               // إعادة Focus بعد المسح
//               Future.delayed(const Duration(milliseconds: 100), () {
//                 if (mounted) {
//                   _searchFocusNode.requestFocus();
//                 }
//               });
//             },
//             style: ElevatedButton.styleFrom(
//               backgroundColor: Colors.red,
//               foregroundColor: Colors.white,
//             ),
//             child: const Text('مسح', style: TextStyle(fontSize: 9)),
//           ),
//         ],
//       ),
//     );
//   }
//
//   Future<void> _sendInvoiceWhatsApp() async {
//     if (_invoiceItems.isEmpty) {
//       if (!mounted) return;
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(
//           content: const Row(
//             children: [
//               Icon(Icons.warning, color: Colors.white, size: 16),
//               SizedBox(width: 8),
//               Text('الفاتورة فارغة', style: TextStyle(fontSize: 9)),
//             ],
//           ),
//           backgroundColor: Colors.orange,
//           behavior: SnackBarBehavior.floating,
//           shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
//         ),
//       );
//       // إعادة Focus
//       Future.delayed(const Duration(milliseconds: 100), () {
//         if (mounted) {
//           _searchFocusNode.requestFocus();
//         }
//       });
//       return;
//     }
//
//     final phoneController = TextEditingController();
//     final nameController = TextEditingController();
//
//     if (!mounted) return;
//
//     showDialog(
//       context: context,
//       builder: (dialogContext) => AlertDialog(
//         shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
//         title: Row(
//           children: [
//             Container(
//               padding: const EdgeInsets.all(6),
//               decoration: BoxDecoration(
//                 color: Colors.green[700],
//                 borderRadius: BorderRadius.circular(8),
//               ),
//               child: const Icon(Icons.send, color: Colors.white, size: 16),
//             ),
//             const SizedBox(width: 8),
//             const Text('إرسال الفاتورة', style: TextStyle(fontSize: 10)),
//           ],
//         ),
//         content: SingleChildScrollView(
//           child: Column(
//             mainAxisSize: MainAxisSize.min,
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               const Text(
//                 'معلومات العميل (اختياري)',
//                 style: TextStyle(fontSize: 9, fontWeight: FontWeight.bold),
//               ),
//               const SizedBox(height: 12),
//               TextField(
//                 controller: nameController,
//                 style: const TextStyle(fontSize: 9),
//                 decoration: InputDecoration(
//                   labelText: 'اسم العميل',
//                   labelStyle: const TextStyle(fontSize: 9),
//                   prefixIcon: const Icon(Icons.person, size: 16),
//                   border: OutlineInputBorder(
//                     borderRadius: BorderRadius.circular(8),
//                   ),
//                   contentPadding: const EdgeInsets.symmetric(
//                     horizontal: 12,
//                     vertical: 8,
//                   ),
//                 ),
//               ),
//               const SizedBox(height: 8),
//               TextField(
//                 controller: phoneController,
//                 keyboardType: TextInputType.phone,
//                 style: const TextStyle(fontSize: 9),
//                 decoration: InputDecoration(
//                   labelText: 'رقم الهاتف (مع كود الدولة)',
//                   labelStyle: const TextStyle(fontSize: 9),
//                   hintText: '+966501234567',
//                   hintStyle: const TextStyle(fontSize: 8),
//                   prefixIcon: const Icon(Icons.phone, size: 16),
//                   border: OutlineInputBorder(
//                     borderRadius: BorderRadius.circular(8),
//                   ),
//                   contentPadding: const EdgeInsets.symmetric(
//                     horizontal: 12,
//                     vertical: 8,
//                   ),
//                 ),
//               ),
//               const SizedBox(height: 12),
//               Container(
//                 padding: const EdgeInsets.all(8),
//                 decoration: BoxDecoration(
//                   color: Colors.blue[50],
//                   borderRadius: BorderRadius.circular(8),
//                   border: Border.all(color: Colors.blue[200]!),
//                 ),
//                 child: Row(
//                   children: [
//                     Icon(Icons.info, color: Colors.blue[700], size: 14),
//                     const SizedBox(width: 6),
//                     const Expanded(
//                       child: Text(
//                         'سيتم إنشاء فاتورة PDF وإرسالها عبر WhatsApp',
//                         style: TextStyle(fontSize: 8, color: Colors.black87),
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//             ],
//           ),
//         ),
//         actions: [
//           TextButton(
//             onPressed: () {
//               Navigator.pop(dialogContext);
//               // إعادة Focus بعد الإلغاء
//               Future.delayed(const Duration(milliseconds: 100), () {
//                 if (mounted) {
//                   _searchFocusNode.requestFocus();
//                 }
//               });
//             },
//             child: const Text('إلغاء', style: TextStyle(fontSize: 9)),
//           ),
//           ElevatedButton.icon(
//             onPressed: () async {
//               Navigator.pop(dialogContext);
//               await Future.delayed(const Duration(milliseconds: 100));
//
//               if (!mounted) return;
//
//               showDialog(
//                 context: context,
//                 barrierDismissible: false,
//                 builder: (loadingContext) => PopScope(
//                   canPop: false,
//                   child: const Center(
//                     child: Card(
//                       child: Padding(
//                         padding: EdgeInsets.all(20),
//                         child: Column(
//                           mainAxisSize: MainAxisSize.min,
//                           children: [
//                             CircularProgressIndicator(strokeWidth: 2),
//                             SizedBox(height: 12),
//                             Text(
//                               'جاري إنشاء الفاتورة...',
//                               style: TextStyle(fontSize: 9),
//                             ),
//                           ],
//                         ),
//                       ),
//                     ),
//                   ),
//                 ),
//               );
//
//               try {
//                 final pdfFile = await InvoicePDFService.generateInvoicePDF(
//                   items: _invoiceItems,
//                   totalAmount: _totalAmount,
//                   customerName: nameController.text.isNotEmpty
//                       ? nameController.text
//                       : null,
//                   customerPhone: phoneController.text.isNotEmpty
//                       ? phoneController.text
//                       : null,
//                 );
//
//                 if (mounted) {
//                   Navigator.of(context).pop();
//                   await Future.delayed(const Duration(milliseconds: 200));
//                 }
//
//                 if (phoneController.text.isNotEmpty) {
//                   final message =
//                       'مرحباً ${nameController.text.isNotEmpty ? nameController.text : ""}\n'
//                       'إليك فاتورتك بقيمة ${_totalAmount.toStringAsFixed(2)} ر.س\n'
//                       'شكراً لتعاملك معنا!';
//
//                   await InvoicePDFService.shareWithMessage(
//                     pdfFile,
//                     phoneController.text,
//                     message,
//                   );
//                 } else {
//                   await InvoicePDFService.shareViaWhatsApp(pdfFile);
//                 }
//
//                 if (mounted) {
//                   ScaffoldMessenger.of(context).showSnackBar(
//                     SnackBar(
//                       content: const Row(
//                         children: [
//                           Icon(
//                             Icons.check_circle,
//                             color: Colors.white,
//                             size: 16,
//                           ),
//                           SizedBox(width: 8),
//                           Text(
//                             'تم إنشاء الفاتورة بنجاح!',
//                             style: TextStyle(fontSize: 9),
//                           ),
//                         ],
//                       ),
//                       backgroundColor: Colors.green[700],
//                       behavior: SnackBarBehavior.floating,
//                       shape: RoundedRectangleBorder(
//                         borderRadius: BorderRadius.circular(8),
//                       ),
//                     ),
//                   );
//
//                   setState(() {
//                     _invoiceItems.clear();
//                     _totalAmount = 0.0;
//                   });
//
//                   // إعادة Focus بعد إتمام العملية
//                   Future.delayed(const Duration(milliseconds: 100), () {
//                     if (mounted) {
//                       _searchFocusNode.requestFocus();
//                     }
//                   });
//                 }
//               } catch (e) {
//                 if (mounted) {
//                   Navigator.of(context).pop();
//                   await Future.delayed(const Duration(milliseconds: 100));
//
//                   ScaffoldMessenger.of(context).showSnackBar(
//                     SnackBar(
//                       content: Row(
//                         children: [
//                           const Icon(
//                             Icons.error,
//                             color: Colors.white,
//                             size: 16,
//                           ),
//                           const SizedBox(width: 8),
//                           Expanded(
//                             child: Text(
//                               'خطأ: ${e.toString()}',
//                               style: const TextStyle(fontSize: 9),
//                             ),
//                           ),
//                         ],
//                       ),
//                       backgroundColor: Colors.red,
//                       behavior: SnackBarBehavior.floating,
//                       shape: RoundedRectangleBorder(
//                         borderRadius: BorderRadius.circular(8),
//                       ),
//                     ),
//                   );
//
//                   // إعادة Focus بعد الخطأ
//                   Future.delayed(const Duration(milliseconds: 100), () {
//                     if (mounted) {
//                       _searchFocusNode.requestFocus();
//                     }
//                   });
//                 }
//               }
//             },
//             icon: const Icon(Icons.send, size: 14),
//             label: const Text('إرسال', style: TextStyle(fontSize: 9)),
//             style: ElevatedButton.styleFrom(
//               backgroundColor: Colors.green[700],
//               foregroundColor: Colors.white,
//               padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
//               shape: RoundedRectangleBorder(
//                 borderRadius: BorderRadius.circular(8),
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
//
//   @override
//   void dispose() {
//     _searchController.dispose();
//     _scrollController.dispose();
//     _searchFocusNode.dispose();
//     _debounce?.cancel();
//     super.dispose();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return BlocProvider.value(
//       value: viewModel,
//       child: Scaffold(
//         backgroundColor: Colors.grey[100],
//         body: SafeArea(
//           child: BlocConsumer<SearchCubit, SearchState>(
//             listener: (context, state) {
//               if (state is SearchSuccess) {
//                 setState(() {
//                   _searchResults = state.searchEntity?.results ?? [];
//                   _isSearching = false;
//                 });
//
//                 if (_searchResults.length == 1) {
//                   Future.delayed(const Duration(milliseconds: 300), () {
//                     _addToInvoice(_searchResults.first);
//                   });
//                 }
//               } else if (state is SearchFailure) {
//                 setState(() {
//                   _isSearching = false;
//                 });
//                 ScaffoldMessenger.of(context).showSnackBar(
//                   SnackBar(
//                     content: Row(
//                       children: [
//                         const Icon(Icons.error, color: Colors.white, size: 16),
//                         const SizedBox(width: 8),
//                         Expanded(
//                           child: Text(
//                             'خطأ: ${state.exception.toString()}',
//                             style: const TextStyle(fontSize: 9),
//                           ),
//                         ),
//                       ],
//                     ),
//                     backgroundColor: Colors.red,
//                     behavior: SnackBarBehavior.floating,
//                     shape: RoundedRectangleBorder(
//                       borderRadius: BorderRadius.circular(8),
//                     ),
//                     margin: const EdgeInsets.all(12),
//                   ),
//                 );
//
//                 // إعادة Focus بعد الخطأ
//                 Future.delayed(const Duration(milliseconds: 100), () {
//                   if (mounted) {
//                     _searchFocusNode.requestFocus();
//                   }
//                 });
//               }
//             },
//             builder: (context, state) {
//               return Column(
//                 children: [
//                   _buildHeaderSection(),
//                   _buildSearchSection(),
//                   Expanded(
//                     child: ListView(
//                       controller: _scrollController,
//                       padding: const EdgeInsets.all(12),
//                       children: [
//                         if (_isSearching && _searchResults.isEmpty)
//                           _buildLoadingState(),
//
//                         if (_searchResults.isNotEmpty) ...[
//                           Container(
//                             padding: const EdgeInsets.symmetric(
//                               horizontal: 8,
//                               vertical: 4,
//                             ),
//                             margin: const EdgeInsets.only(bottom: 8),
//                             decoration: BoxDecoration(
//                               color: Colors.blue[50],
//                               borderRadius: BorderRadius.circular(6),
//                               border: Border.all(color: Colors.blue[200]!),
//                             ),
//                             child: Row(
//                               children: [
//                                 Icon(
//                                   Icons.search,
//                                   color: Colors.blue[700],
//                                   size: 14,
//                                 ),
//                                 const SizedBox(width: 6),
//                                 Text(
//                                   _searchResults.length == 1
//                                       ? 'سيتم إضافة المنتج تلقائياً...'
//                                       : 'نتائج البحث (${_searchResults.length})',
//                                   style: TextStyle(
//                                     fontWeight: FontWeight.bold,
//                                     fontSize: 9,
//                                     color: Colors.blue[700],
//                                   ),
//                                 ),
//                               ],
//                             ),
//                           ),
//                           ..._searchResults.map(
//                             (product) => _buildSearchResultCard(product),
//                           ),
//                           const SizedBox(height: 16),
//                         ],
//
//                         if (_invoiceItems.isNotEmpty) ...[
//                           Container(
//                             padding: const EdgeInsets.symmetric(
//                               horizontal: 8,
//                               vertical: 4,
//                             ),
//                             margin: const EdgeInsets.only(bottom: 8),
//                             decoration: BoxDecoration(
//                               color: Colors.green[50],
//                               borderRadius: BorderRadius.circular(6),
//                               border: Border.all(color: Colors.green[200]!),
//                             ),
//                             child: Row(
//                               children: [
//                                 Icon(
//                                   Icons.receipt,
//                                   color: Colors.green[700],
//                                   size: 14,
//                                 ),
//                                 const SizedBox(width: 6),
//                                 Text(
//                                   'الفاتورة (${_invoiceItems.length} منتج)',
//                                   style: TextStyle(
//                                     fontWeight: FontWeight.bold,
//                                     fontSize: 9,
//                                     color: Colors.green[700],
//                                   ),
//                                 ),
//                               ],
//                             ),
//                           ),
//                           ..._invoiceItems.asMap().entries.map((entry) {
//                             return _buildInvoiceItemCard(
//                               entry.key,
//                               entry.value,
//                             );
//                           }),
//                           const SizedBox(height: 16),
//                         ],
//
//                         if (_invoiceItems.isEmpty &&
//                             _searchResults.isEmpty &&
//                             !_isSearching)
//                           _buildEmptyState(),
//                       ],
//                     ),
//                   ),
//                   if (_invoiceItems.isNotEmpty) _buildBottomBar(),
//                 ],
//               );
//             },
//           ),
//         ),
//       ),
//     );
//   }
//
//   Widget _buildHeaderSection() {
//     return Container(
//       padding: const EdgeInsets.all(12),
//       decoration: BoxDecoration(
//         color: Colors.white,
//         boxShadow: [
//           BoxShadow(
//             color: Colors.black.withOpacity(0.05),
//             blurRadius: 4,
//             offset: const Offset(0, 2),
//           ),
//         ],
//       ),
//       child: Row(
//         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//         children: [
//           Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               const Text(
//                 'الإجمالي',
//                 style: TextStyle(
//                   color: Colors.black54,
//                   fontSize: 8,
//                   fontWeight: FontWeight.w500,
//                 ),
//               ),
//               const SizedBox(height: 2),
//               Text(
//                 '${_totalAmount.toStringAsFixed(2)} ر.س',
//                 style: const TextStyle(
//                   color: Colors.black87,
//                   fontSize: 10,
//                   fontWeight: FontWeight.bold,
//                 ),
//               ),
//             ],
//           ),
//           Container(
//             padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
//             decoration: BoxDecoration(
//               color: Colors.grey[200],
//               borderRadius: BorderRadius.circular(8),
//             ),
//             child: Row(
//               mainAxisSize: MainAxisSize.min,
//               children: [
//                 const Icon(
//                   Icons.shopping_cart,
//                   color: Colors.black87,
//                   size: 14,
//                 ),
//                 const SizedBox(width: 6),
//                 Text(
//                   '${_invoiceItems.length} منتج',
//                   style: const TextStyle(
//                     color: Colors.black87,
//                     fontSize: 9,
//                     fontWeight: FontWeight.bold,
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }
//
//   Widget _buildSearchSection() {
//     return Container(
//       margin: const EdgeInsets.all(12),
//       padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
//       decoration: BoxDecoration(
//         color: Colors.white,
//         borderRadius: BorderRadius.circular(8),
//         border: Border.all(color: Colors.grey[300]!),
//       ),
//       child: Row(
//         children: [
//           const Icon(Icons.search, color: Colors.black54, size: 18),
//           const SizedBox(width: 8),
//           Expanded(
//             child: TextField(
//               controller: _searchController,
//               focusNode: _searchFocusNode,
//               // منع إظهار الكيبورد إلا عند الضغط على الزر
//               readOnly: !_isKeyboardVisible,
//               showCursor: true,
//               decoration: const InputDecoration(
//                 hintText: 'امسح الباركود أو اكتب للبحث...',
//                 border: InputBorder.none,
//                 hintStyle: TextStyle(fontSize: 9, color: Colors.black38),
//               ),
//               style: const TextStyle(fontSize: 9, fontWeight: FontWeight.w500),
//             ),
//           ),
//           if (_searchController.text.isNotEmpty)
//             IconButton(
//               icon: const Icon(Icons.clear, color: Colors.black38, size: 18),
//               padding: EdgeInsets.zero,
//               constraints: const BoxConstraints(),
//               onPressed: () {
//                 _searchController.clear();
//                 setState(() {
//                   _searchResults.clear();
//                 });
//                 // إعادة Focus بعد المسح
//                 Future.delayed(const Duration(milliseconds: 100), () {
//                   if (mounted) {
//                     _searchFocusNode.requestFocus();
//                   }
//                 });
//               },
//             ),
//           const SizedBox(width: 4),
//           IconButton(
//             icon: Icon(
//               _isKeyboardVisible ? Icons.keyboard_hide : Icons.keyboard,
//               color: Colors.black54,
//               size: 18,
//             ),
//             padding: EdgeInsets.zero,
//             constraints: const BoxConstraints(),
//             onPressed: _toggleKeyboard,
//             tooltip: _isKeyboardVisible
//                 ? 'إخفاء لوحة المفاتيح'
//                 : 'إظهار لوحة المفاتيح',
//           ),
//         ],
//       ),
//     );
//   }
//
//   Widget _buildSearchResultCard(Results product) {
//     final isInInvoice = _invoiceItems.any(
//       (item) => item.product.productId == product.productId,
//     );
//
//     return Container(
//       margin: const EdgeInsets.only(bottom: 8),
//       decoration: BoxDecoration(
//         color: Colors.white,
//         borderRadius: BorderRadius.circular(8),
//         border: Border.all(
//           color: isInInvoice ? Colors.green[300]! : Colors.grey[300]!,
//         ),
//       ),
//       child: Padding(
//         padding: const EdgeInsets.all(8),
//         child: Row(
//           children: [
//             Container(
//               padding: const EdgeInsets.all(6),
//               decoration: BoxDecoration(
//                 color: Colors.grey[200],
//                 borderRadius: BorderRadius.circular(6),
//               ),
//               child: const Icon(
//                 Icons.inventory_2,
//                 color: Colors.black54,
//                 size: 16,
//               ),
//             ),
//             const SizedBox(width: 8),
//             Expanded(
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Text(
//                     product.productName ?? '',
//                     style: const TextStyle(
//                       fontSize: 9,
//                       fontWeight: FontWeight.bold,
//                       color: Colors.black87,
//                     ),
//                     maxLines: 2,
//                     overflow: TextOverflow.ellipsis,
//                   ),
//                   const SizedBox(height: 2),
//                   Text(
//                     '${product.sellingPrice ?? '0'} ر.س',
//                     style: TextStyle(
//                       fontSize: 9,
//                       fontWeight: FontWeight.bold,
//                       color: Colors.green[700],
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//             const SizedBox(width: 8),
//             ElevatedButton(
//               onPressed: () => _addToInvoice(product),
//               style: ElevatedButton.styleFrom(
//                 backgroundColor: Colors.blue[700],
//                 foregroundColor: Colors.white,
//                 padding: const EdgeInsets.symmetric(
//                   horizontal: 10,
//                   vertical: 6,
//                 ),
//                 shape: RoundedRectangleBorder(
//                   borderRadius: BorderRadius.circular(6),
//                 ),
//                 minimumSize: const Size(0, 0),
//               ),
//               child: Text(
//                 isInInvoice ? 'إضافة المزيد' : 'إضافة',
//                 style: const TextStyle(fontSize: 8),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
//
//   Widget _buildInvoiceItemCard(int index, InvoiceItem item) {
//     final price = double.tryParse(item.product.sellingPrice ?? '0') ?? 0.0;
//     final total = price * item.quantity;
//
//     return Container(
//       margin: const EdgeInsets.only(bottom: 8),
//       decoration: BoxDecoration(
//         color: Colors.white,
//         borderRadius: BorderRadius.circular(8),
//         border: Border.all(color: Colors.grey[300]!),
//       ),
//       child: Padding(
//         padding: const EdgeInsets.all(8),
//         child: Row(
//           children: [
//             Expanded(
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Text(
//                     item.product.productName ?? '',
//                     style: const TextStyle(
//                       fontSize: 9,
//                       fontWeight: FontWeight.bold,
//                       color: Colors.black87,
//                     ),
//                     maxLines: 2,
//                     overflow: TextOverflow.ellipsis,
//                   ),
//                   const SizedBox(height: 2),
//                   Text(
//                     '${price.toStringAsFixed(2)} ر.س × ${item.quantity}',
//                     style: const TextStyle(fontSize: 8, color: Colors.black54),
//                   ),
//                 ],
//               ),
//             ),
//             const SizedBox(width: 8),
//             Container(
//               decoration: BoxDecoration(
//                 color: Colors.grey[100],
//                 borderRadius: BorderRadius.circular(6),
//               ),
//               child: Row(
//                 mainAxisSize: MainAxisSize.min,
//                 children: [
//                   IconButton(
//                     icon: const Icon(Icons.remove, size: 14),
//                     onPressed: () => _updateQuantity(index, item.quantity - 1),
//                     color: Colors.red,
//                     padding: const EdgeInsets.all(4),
//                     constraints: const BoxConstraints(),
//                   ),
//                   Container(
//                     padding: const EdgeInsets.symmetric(horizontal: 8),
//                     child: Text(
//                       '${item.quantity}',
//                       style: const TextStyle(
//                         fontSize: 9,
//                         fontWeight: FontWeight.bold,
//                       ),
//                     ),
//                   ),
//                   IconButton(
//                     icon: const Icon(Icons.add, size: 14),
//                     onPressed: () => _updateQuantity(index, item.quantity + 1),
//                     color: Colors.green,
//                     padding: const EdgeInsets.all(4),
//                     constraints: const BoxConstraints(),
//                   ),
//                 ],
//               ),
//             ),
//             const SizedBox(width: 8),
//             Column(
//               crossAxisAlignment: CrossAxisAlignment.end,
//               children: [
//                 Text(
//                   total.toStringAsFixed(2),
//                   style: TextStyle(
//                     fontSize: 10,
//                     fontWeight: FontWeight.bold,
//                     color: Colors.green[700],
//                   ),
//                 ),
//                 Text(
//                   'ر.س',
//                   style: TextStyle(fontSize: 8, color: Colors.green[700]),
//                 ),
//               ],
//             ),
//           ],
//         ),
//       ),
//     );
//   }
//
//   Widget _buildLoadingState() {
//     return Center(
//       child: Padding(
//         padding: const EdgeInsets.all(32),
//         child: Column(
//           mainAxisSize: MainAxisSize.min,
//           children: [
//             Container(
//               padding: const EdgeInsets.all(16),
//               decoration: BoxDecoration(
//                 color: Colors.grey[100],
//                 shape: BoxShape.circle,
//               ),
//               child: const CircularProgressIndicator(
//                 color: Colors.blue,
//                 strokeWidth: 2,
//               ),
//             ),
//             const SizedBox(height: 16),
//             const Text(
//               'جاري البحث...',
//               style: TextStyle(
//                 fontSize: 9,
//                 fontWeight: FontWeight.w600,
//                 color: Colors.black54,
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
//
//   Widget _buildEmptyState() {
//     return Center(
//       child: Padding(
//         padding: const EdgeInsets.all(32),
//         child: Column(
//           mainAxisSize: MainAxisSize.min,
//           children: [
//             Container(
//               padding: const EdgeInsets.all(24),
//               decoration: BoxDecoration(
//                 color: Colors.grey[100],
//                 shape: BoxShape.circle,
//               ),
//               child: Icon(
//                 Icons.barcode_reader,
//                 size: 48,
//                 color: Colors.grey[400],
//               ),
//             ),
//             const SizedBox(height: 16),
//             const Text(
//               'ابدأ بإضافة المنتجات',
//               style: TextStyle(
//                 fontSize: 10,
//                 fontWeight: FontWeight.bold,
//                 color: Colors.black87,
//               ),
//             ),
//             const SizedBox(height: 8),
//             Text(
//               'امسح الباركود أو ابحث عن المنتج',
//               style: TextStyle(fontSize: 9, color: Colors.grey[600]),
//               textAlign: TextAlign.center,
//             ),
//             const SizedBox(height: 6),
//             Container(
//               padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
//               decoration: BoxDecoration(
//                 color: Colors.blue[50],
//                 borderRadius: BorderRadius.circular(6),
//               ),
//               child: const Text(
//                 '💡 المنتج الواحد سيُضاف تلقائياً',
//                 style: TextStyle(
//                   fontSize: 8,
//                   color: Colors.blue,
//                   fontWeight: FontWeight.w500,
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
//
//   Widget _buildBottomBar() {
//     return Container(
//       padding: const EdgeInsets.all(12),
//       decoration: BoxDecoration(
//         color: Colors.white,
//         boxShadow: [
//           BoxShadow(
//             color: Colors.black.withOpacity(0.05),
//             blurRadius: 4,
//             offset: const Offset(0, -2),
//           ),
//         ],
//       ),
//       child: Row(
//         children: [
//           Expanded(
//             child: OutlinedButton(
//               onPressed: _invoiceItems.isEmpty ? null : _clearInvoice,
//               style: OutlinedButton.styleFrom(
//                 foregroundColor: Colors.red,
//                 side: const BorderSide(color: Colors.red, width: 1),
//                 padding: const EdgeInsets.symmetric(vertical: 10),
//                 shape: RoundedRectangleBorder(
//                   borderRadius: BorderRadius.circular(8),
//                 ),
//               ),
//               child: const Text('مسح الكل', style: TextStyle(fontSize: 9)),
//             ),
//           ),
//           const SizedBox(width: 8),
//           Expanded(
//             flex: 2,
//             child: ElevatedButton(
//               onPressed: _invoiceItems.isEmpty ? null : _sendInvoiceWhatsApp,
//               style: ElevatedButton.styleFrom(
//                 backgroundColor: Colors.green[700],
//                 foregroundColor: Colors.white,
//                 padding: const EdgeInsets.symmetric(vertical: 10),
//                 shape: RoundedRectangleBorder(
//                   borderRadius: BorderRadius.circular(8),
//                 ),
//               ),
//               child: const Text(
//                 'إرسال الفاتورة',
//                 style: TextStyle(fontSize: 9, fontWeight: FontWeight.bold),
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
// lib/features/POSPage/presentation/pages/POSPage_page.dart

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:stock_up/core/di/di.dart';
import 'package:stock_up/features/POSPage/data/models/invoice_model.dart';
import 'package:stock_up/features/POSPage/presentation/widgets/invoice_item.dart';
import 'package:stock_up/features/POSPage/presentation/widgets/saved_invoices_tab.dart';
import 'package:stock_up/features/Search/data/models/response/search_model.dart'
    hide Results;
import 'package:stock_up/features/Search/presentation/bloc/Search_cubit.dart';

import '../bloc/POSPage_cubit.dart';

class POSPage extends StatefulWidget {
  const POSPage({super.key});

  @override
  State<POSPage> createState() => _POSPageState();
}

class _POSPageState extends State<POSPage> with SingleTickerProviderStateMixin {
  late SearchCubit searchViewModel;
  late InvoiceCubit invoiceViewModel;
  late TabController _tabController;

  final TextEditingController _searchController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  final MobileScannerController _cameraController = MobileScannerController(
    detectionSpeed: DetectionSpeed.noDuplicates,
  );

  Timer? _debounce;
  bool _isCameraLocked = true;
  bool _torchOn = false;
  List<InvoiceItem> _invoiceItems = [];
  List<Results> _searchResults = [];
  double _totalAmount = 0.0;

  @override
  void initState() {
    super.initState();
    searchViewModel = getIt.get<SearchCubit>();
    invoiceViewModel = getIt.get<InvoiceCubit>();
    _tabController = TabController(length: 2, vsync: this);
    _searchController.addListener(_onSearchChanged);

    // Load saved invoices when tab is switched
    _tabController.addListener(() {
      if (_tabController.index == 1) {
        invoiceViewModel.loadInvoices();
      }
    });
  }

  void _onSearchChanged() {
    if (_debounce?.isActive ?? false) _debounce!.cancel();

    if (_searchController.text.isEmpty) {
      setState(() {
        _searchResults.clear();
      });
      return;
    }

    _debounce = Timer(const Duration(milliseconds: 500), () {
      if (_searchController.text.isNotEmpty) {
        searchViewModel.search(_searchController.text, 1);
      }
    });
  }

  void _toggleCamera() {
    setState(() {
      _isCameraLocked = !_isCameraLocked;
    });
    if (_isCameraLocked) {
      _cameraController.stop();
    } else {
      _cameraController.start();
    }
  }

  void _toggleTorch() async {
    await _cameraController.toggleTorch();
    setState(() {
      _torchOn = !_torchOn;
    });
  }

  void _onBarcodeDetected(String barcode) {
    if (!_isCameraLocked) {
      _searchController.text = barcode;
      searchViewModel.search(barcode, 1);
    }
  }

  void _addToInvoice(Results product) {
    setState(() {
      final existingIndex = _invoiceItems.indexWhere(
        (item) => item.product.productId == product.productId,
      );

      if (existingIndex != -1) {
        _invoiceItems[existingIndex].quantity++;
      } else {
        _invoiceItems.add(InvoiceItem(product: r, quantity: 1));
      }
      _calculateTotal();
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(Icons.check_circle, color: Colors.white),
            const SizedBox(width: 12),
            Expanded(child: Text('تم إضافة ${product.productName}')),
          ],
        ),
        backgroundColor: const Color(0xFF11998E),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        margin: const EdgeInsets.all(16),
        duration: const Duration(seconds: 1),
      ),
    );
  }

  void _removeFromInvoice(int index) {
    setState(() {
      _invoiceItems.removeAt(index);
      _calculateTotal();
    });
  }

  void _updateQuantity(int index, int newQuantity) {
    if (newQuantity <= 0) {
      _removeFromInvoice(index);
      return;
    }
    setState(() {
      _invoiceItems[index].quantity = newQuantity;
      _calculateTotal();
    });
  }

  void _calculateTotal() {
    _totalAmount = _invoiceItems.fold(0.0, (sum, item) {
      final price = double.tryParse(item.product.sellingPrice ?? '0') ?? 0.0;
      return sum + (price * item.quantity);
    });
  }

  void _clearInvoice() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Row(
          children: [
            Icon(Icons.warning_rounded, color: Color(0xFFFF6B6B)),
            SizedBox(width: 12),
            Text('تأكيد المسح'),
          ],
        ),
        content: const Text('هل تريد مسح جميع المنتجات من الفاتورة؟'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('إلغاء'),
          ),
          ElevatedButton(
            onPressed: () {
              setState(() {
                _invoiceItems.clear();
                _totalAmount = 0.0;
              });
              Navigator.pop(context);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFFF6B6B),
              foregroundColor: Colors.white,
            ),
            child: const Text('مسح'),
          ),
        ],
      ),
    );
  }

  Future<void> _saveInvoice() async {
    if (_invoiceItems.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Row(
            children: [
              Icon(Icons.warning, color: Colors.white),
              SizedBox(width: 12),
              Text('الفاتورة فارغة'),
            ],
          ),
          backgroundColor: const Color(0xFFFF6B6B),
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      );
      return;
    }

    final nameController = TextEditingController();
    final phoneController = TextEditingController();

    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFF11998E), Color(0xFF38EF7D)],
                ),
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Icon(Icons.save, color: Colors.white, size: 24),
            ),
            const SizedBox(width: 12),
            const Text('حفظ الفاتورة', style: TextStyle(fontSize: 18)),
          ],
        ),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'معلومات العميل (اختياري)',
                style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: nameController,
                decoration: InputDecoration(
                  labelText: 'اسم العميل',
                  prefixIcon: const Icon(Icons.person_outline),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: phoneController,
                keyboardType: TextInputType.phone,
                decoration: InputDecoration(
                  labelText: 'رقم الهاتف',
                  hintText: '+966501234567',
                  prefixIcon: const Icon(Icons.phone_outlined),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: const Text('إلغاء'),
          ),
          ElevatedButton.icon(
            onPressed: () {
              Navigator.pop(dialogContext);
              _performSaveInvoice(nameController.text, phoneController.text);
            },
            icon: const Icon(Icons.save_rounded),
            label: const Text('حفظ'),
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF11998E),
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _performSaveInvoice(String customerName, String customerPhone) {
    final tax = _totalAmount * 0.15;
    final grandTotal = _totalAmount + tax;

    final invoice = Invoice(
      id: 'INV-${DateTime.now().millisecondsSinceEpoch}',
      items: List.from(_invoiceItems),
      totalAmount: _totalAmount,
      tax: tax,
      grandTotal: grandTotal,
      customerName: customerName.isNotEmpty ? customerName : null,
      customerPhone: customerPhone.isNotEmpty ? customerPhone : null,
      createdAt: DateTime.now(),
    );

    invoiceViewModel.saveInvoice(invoice);
  }

  @override
  void dispose() {
    _searchController.dispose();
    _scrollController.dispose();
    _cameraController.dispose();
    _tabController.dispose();
    _debounce?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider.value(value: searchViewModel),
        BlocProvider.value(value: invoiceViewModel),
      ],
      child: BlocListener<InvoiceCubit, InvoiceState>(
        listener: (context, state) {
          if (state is InvoiceSaved) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: const Row(
                  children: [
                    Icon(Icons.check_circle, color: Colors.white),
                    SizedBox(width: 12),
                    Text('تم حفظ الفاتورة بنجاح'),
                  ],
                ),
                backgroundColor: const Color(0xFF11998E),
                behavior: SnackBarBehavior.floating,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            );
            setState(() {
              _invoiceItems.clear();
              _totalAmount = 0.0;
            });
            _tabController.animateTo(1); // Switch to saved invoices tab
          } else if (state is InvoiceError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Row(
                  children: [
                    const Icon(Icons.error_outline, color: Colors.white),
                    const SizedBox(width: 12),
                    Expanded(child: Text(state.message)),
                  ],
                ),
                backgroundColor: const Color(0xFFFF6B6B),
                behavior: SnackBarBehavior.floating,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            );
          }
        },
        child: GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTap: () => FocusScope.of(context).unfocus(),
          child: Scaffold(
            backgroundColor: const Color(0xFFF8F9FE),
            body: SafeArea(
              child: Column(
                children: [
                  _buildTabBar(),
                  Expanded(
                    child: TabBarView(
                      controller: _tabController,
                      children: [
                        _buildNewInvoiceTab(),
                        const SavedInvoicesTab(),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTabBar() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: TabBar(
        controller: _tabController,
        indicatorColor: const Color(0xFF6C63FF),
        labelColor: const Color(0xFF6C63FF),
        unselectedLabelColor: Colors.grey,
        labelStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        tabs: const [
          Tab(icon: Icon(Icons.add_shopping_cart), text: 'فاتورة جديدة'),
          Tab(icon: Icon(Icons.receipt_long), text: 'الفواتير المحفوظة'),
        ],
      ),
    );
  }

  Widget _buildNewInvoiceTab() {
    return Column(
      children: [
        _buildCameraSection(),
        _buildSearchSection(),
        Expanded(
          child: BlocConsumer<SearchCubit, SearchState>(
            listener: (context, state) {
              if (state is SearchSuccess) {
                setState(() {
                  _searchResults = state.searchEntity?.results ?? [];
                });
              } else if (state is SearchFailure) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Row(
                      children: [
                        const Icon(Icons.error_outline, color: Colors.white),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Text('خطأ: ${state.exception.toString()}'),
                        ),
                      ],
                    ),
                    backgroundColor: const Color(0xFFFF6B6B),
                    behavior: SnackBarBehavior.floating,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    margin: const EdgeInsets.all(16),
                  ),
                );
              }
            },
            builder: (context, state) {
              return _buildMainContent(state);
            },
          ),
        ),
      ],
    );
  }

  // Keep all the existing build methods (_buildCameraSection, _buildSearchSection, etc.)
  // I'll include the key modified methods below

  Widget _buildBottomBar() {
    return Container(
      padding: const EdgeInsets.all(16),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: _invoiceItems.isEmpty ? null : _clearInvoice,
                  icon: const Icon(Icons.delete_outline_rounded, size: 20),
                  label: const Text('مسح الكل'),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: Colors.red,
                    side: const BorderSide(
                      color: Colors.deepOrangeAccent,
                      width: 2,
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                flex: 2,
                child: ElevatedButton.icon(
                  onPressed: _invoiceItems.isEmpty ? null : _saveInvoice,
                  icon: const Icon(Icons.save_rounded, size: 20),
                  label: const Text(
                    'حفظ الفاتورة',
                    style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF11998E),
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    disabledBackgroundColor: const Color(
                      0xFF11998E,
                    ).withOpacity(0.3),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // Include all other existing build methods here...
  // (I'm omitting them for brevity, but keep _buildCameraSection, _buildSearchSection,
  // _buildMainContent, _buildSearchResultCard, _buildInvoiceItemCard,
  // _buildLoadingState, _buildEmptyState, _buildCameraButton)
}
