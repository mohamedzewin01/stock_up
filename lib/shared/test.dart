// import 'dart:async';
//
// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:stock_up/core/di/di.dart';
// import 'package:stock_up/features/Search/presentation/bloc/Search_cubit.dart';
// import 'package:stock_up/features/Search/presentation/widgets/barcode_scanner.dart';
//
// import '../features/Search/data/models/response/search_model.dart';
//
// // ==================== ENTITIES ====================
// class InvoiceEntity {
//   final List<InvoiceItem> items;
//   final double subtotal;
//   final double tax;
//   final double total;
//
//   InvoiceEntity({
//     required this.items,
//     required this.subtotal,
//     required this.tax,
//     required this.total,
//   });
//
//   InvoiceEntity copyWith({
//     List<InvoiceItem>? items,
//     double? subtotal,
//     double? tax,
//     double? total,
//   }) {
//     return InvoiceEntity(
//       items: items ?? this.items,
//       subtotal: subtotal ?? this.subtotal,
//       tax: tax ?? this.tax,
//       total: total ?? this.total,
//     );
//   }
// }
//
// class InvoiceItem {
//   final Results product;
//   final int quantity;
//   final double itemTotal;
//   final double itemTax;
//
//   InvoiceItem({
//     required this.product,
//     required this.quantity,
//     required this.itemTotal,
//     required this.itemTax,
//   });
//
//   InvoiceItem copyWith({
//     Results? product,
//     int? quantity,
//     double? itemTotal,
//     double? itemTax,
//   }) {
//     return InvoiceItem(
//       product: product ?? this.product,
//       quantity: quantity ?? this.quantity,
//       itemTotal: itemTotal ?? this.itemTotal,
//       itemTax: itemTax ?? this.itemTax,
//     );
//   }
// }
//
// // ==================== CUBIT ====================
// class InvoiceCubit extends Cubit<InvoiceEntity> {
//   InvoiceCubit()
//     : super(InvoiceEntity(items: [], subtotal: 0, tax: 0, total: 0));
//
//   void addProduct(Results product, {int quantity = 1}) {
//     final items = List<InvoiceItem>.from(state.items);
//
//     // Check if product already exists
//     final existingIndex = items.indexWhere(
//       (item) => item.product.productId == product.productId,
//     );
//
//     if (existingIndex >= 0) {
//       // Update quantity if exists
//       final existingItem = items[existingIndex];
//       items[existingIndex] = _createInvoiceItem(
//         product,
//         existingItem.quantity + quantity,
//       );
//     } else {
//       // Add new item
//       items.add(_createInvoiceItem(product, quantity));
//     }
//
//     _updateInvoice(items);
//   }
//
//   void updateQuantity(int productId, int newQuantity) {
//     if (newQuantity <= 0) {
//       removeProduct(productId);
//       return;
//     }
//
//     final items = List<InvoiceItem>.from(state.items);
//     final index = items.indexWhere(
//       (item) => item.product.productId == productId,
//     );
//
//     if (index >= 0) {
//       items[index] = _createInvoiceItem(items[index].product, newQuantity);
//       _updateInvoice(items);
//     }
//   }
//
//   void removeProduct(int productId) {
//     final items = state.items
//         .where((item) => item.product.productId != productId)
//         .toList();
//     _updateInvoice(items);
//   }
//
//   void clearInvoice() {
//     emit(InvoiceEntity(items: [], subtotal: 0, tax: 0, total: 0));
//   }
//
//   InvoiceItem _createInvoiceItem(Results product, int quantity) {
//     final price = double.tryParse(product.sellingPrice ?? '0') ?? 0;
//     final taxRate = double.tryParse(product.taxRate ?? '0') ?? 0;
//     final isTaxable = product.taxable == 1;
//
//     final itemSubtotal = price * quantity;
//     final double itemTax = isTaxable ? (itemSubtotal * taxRate / 100) : 0;
//     final itemTotal = itemSubtotal + itemTax;
//
//     return InvoiceItem(
//       product: product,
//       quantity: quantity,
//       itemTotal: itemTotal,
//       itemTax: itemTax,
//     );
//   }
//
//   void _updateInvoice(List<InvoiceItem> items) {
//     double subtotal = 0;
//     double tax = 0;
//
//     for (var item in items) {
//       final price = double.tryParse(item.product.sellingPrice ?? '0') ?? 0;
//       subtotal += price * item.quantity;
//       tax += item.itemTax;
//     }
//
//     final total = subtotal + tax;
//
//     emit(
//       InvoiceEntity(items: items, subtotal: subtotal, tax: tax, total: total),
//     );
//   }
// }
//
// // ==================== MAIN PAGE ====================
// class InvoicePage extends StatefulWidget {
//   const InvoicePage({super.key});
//
//   @override
//   State<InvoicePage> createState() => _InvoicePageState();
// }
//
// class _InvoicePageState extends State<InvoicePage> {
//   late SearchCubit searchViewModel;
//   late InvoiceCubit invoiceViewModel;
//
//   final TextEditingController _searchController = TextEditingController();
//   final ScrollController _scrollController = ScrollController();
//   Timer? _debounce;
//   int _currentPage = 1;
//   bool _isLoadingMore = false;
//   List<Results> _allResults = [];
//   bool _isSearching = false;
//
//   @override
//   void initState() {
//     super.initState();
//     searchViewModel = getIt.get<SearchCubit>();
//     invoiceViewModel = InvoiceCubit();
//     _searchController.addListener(_onSearchChanged);
//     _scrollController.addListener(_onScroll);
//   }
//
//   void _onSearchChanged() {
//     if (_debounce?.isActive ?? false) _debounce!.cancel();
//     _debounce = Timer(const Duration(milliseconds: 500), () {
//       if (_searchController.text.isNotEmpty) {
//         setState(() => _isSearching = true);
//         _currentPage = 1;
//         _allResults.clear();
//         searchViewModel.search(_searchController.text, _currentPage);
//       } else {
//         setState(() {
//           _allResults.clear();
//           _isSearching = false;
//         });
//       }
//     });
//   }
//
//   void _onScroll() {
//     if (_scrollController.position.pixels >=
//             _scrollController.position.maxScrollExtent * 0.9 &&
//         !_isLoadingMore) {
//       _loadMoreResults();
//     }
//   }
//
//   void _loadMoreResults() {
//     final state = searchViewModel.state;
//     if (state is SearchSuccess &&
//         state.searchEntity?.page != null &&
//         state.searchEntity?.totalPages != null &&
//         state.searchEntity!.page! < state.searchEntity!.totalPages!) {
//       setState(() {
//         _isLoadingMore = true;
//         _currentPage++;
//       });
//       searchViewModel.search(_searchController.text, _currentPage);
//     }
//   }
//
//   void _openBarcodeScanner() {
//     Navigator.push(
//       context,
//       MaterialPageRoute(
//         builder: (context) => BarcodeScannerPage(
//           onBarcodeDetected: (String barcode) {
//             _searchController.text = barcode;
//             _currentPage = 1;
//             _allResults.clear();
//             setState(() => _isSearching = true);
//             searchViewModel.search(barcode, _currentPage);
//           },
//         ),
//       ),
//     );
//   }
//
//   void _addProductToInvoice(Results product) {
//     invoiceViewModel.addProduct(product);
//
//     // Show success message
//     ScaffoldMessenger.of(context).showSnackBar(
//       SnackBar(
//         content: Row(
//           children: [
//             Container(
//               padding: const EdgeInsets.all(8),
//               decoration: const BoxDecoration(
//                 gradient: LinearGradient(
//                   colors: [Color(0xFF11998E), Color(0xFF38EF7D)],
//                 ),
//                 shape: BoxShape.circle,
//               ),
//               child: const Icon(
//                 Icons.check_rounded,
//                 color: Colors.white,
//                 size: 20,
//               ),
//             ),
//             const SizedBox(width: 12),
//             const Expanded(
//               child: Text(
//                 'تمت الإضافة للفاتورة',
//                 style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
//               ),
//             ),
//           ],
//         ),
//         backgroundColor: const Color(0xFF2D3436),
//         behavior: SnackBarBehavior.floating,
//         shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
//         margin: const EdgeInsets.all(16),
//         duration: const Duration(milliseconds: 1500),
//       ),
//     );
//
//     // Clear search and open scanner again
//     _searchController.clear();
//     setState(() {
//       _allResults.clear();
//       _isSearching = false;
//     });
//
//     // Open barcode scanner again automatically
//     Future.delayed(const Duration(milliseconds: 300), () {
//       _openBarcodeScanner();
//     });
//   }
//
//   @override
//   void dispose() {
//     _searchController.dispose();
//     _scrollController.dispose();
//     _debounce?.cancel();
//     super.dispose();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return MultiBlocProvider(
//       providers: [
//         BlocProvider.value(value: searchViewModel),
//         BlocProvider.value(value: invoiceViewModel),
//       ],
//       child: LayoutBuilder(
//         builder: (context, constraints) {
//           final isWideScreen = constraints.maxWidth > 800;
//
//           return GestureDetector(
//             onTap: () => FocusScope.of(context).unfocus(),
//             child: Scaffold(
//               backgroundColor: const Color(0xFFF8F9FE),
//               body: SafeArea(
//                 child: Column(
//                   children: [
//                     _buildModernHeader(context, isWideScreen),
//                     Expanded(
//                       child: isWideScreen
//                           ? _buildWideLayout()
//                           : _buildNarrowLayout(),
//                     ),
//                   ],
//                 ),
//               ),
//             ),
//           );
//         },
//       ),
//     );
//   }
//
//   Widget _buildModernHeader(BuildContext context, bool isWideScreen) {
//     return Container(
//       decoration: BoxDecoration(
//         gradient: const LinearGradient(
//           colors: [Color(0xFF6C63FF), Color(0xFF5A52E0)],
//           begin: Alignment.topRight,
//           end: Alignment.bottomLeft,
//         ),
//         boxShadow: [
//           BoxShadow(
//             color: const Color(0xFF6C63FF).withOpacity(0.3),
//             blurRadius: 20,
//             offset: const Offset(0, 5),
//           ),
//         ],
//       ),
//       padding: EdgeInsets.all(isWideScreen ? 24 : 16),
//       child: Column(
//         children: [
//           Row(
//             children: [
//               Container(
//                 padding: const EdgeInsets.all(12),
//                 decoration: BoxDecoration(
//                   color: Colors.white.withOpacity(0.2),
//                   borderRadius: BorderRadius.circular(16),
//                 ),
//                 child: const Icon(
//                   Icons.receipt_long_rounded,
//                   color: Colors.white,
//                   size: 28,
//                 ),
//               ),
//               const SizedBox(width: 16),
//               const Expanded(
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     Text(
//                       'فاتورة جديدة',
//                       style: TextStyle(
//                         color: Colors.white,
//                         fontSize: 24,
//                         fontWeight: FontWeight.bold,
//                         letterSpacing: 0.5,
//                       ),
//                     ),
//                     Text(
//                       'ابحث وأضف المنتجات للفاتورة',
//                       style: TextStyle(color: Colors.white70, fontSize: 13),
//                     ),
//                   ],
//                 ),
//               ),
//               BlocBuilder<InvoiceCubit, InvoiceEntity>(
//                 builder: (context, invoice) {
//                   return Container(
//                     padding: const EdgeInsets.symmetric(
//                       horizontal: 16,
//                       vertical: 10,
//                     ),
//                     decoration: BoxDecoration(
//                       color: Colors.white.withOpacity(0.2),
//                       borderRadius: BorderRadius.circular(12),
//                     ),
//                     child: Column(
//                       children: [
//                         Text(
//                           '${invoice.items.length}',
//                           style: const TextStyle(
//                             color: Colors.white,
//                             fontSize: 20,
//                             fontWeight: FontWeight.bold,
//                           ),
//                         ),
//                         const Text(
//                           'منتج',
//                           style: TextStyle(color: Colors.white70, fontSize: 11),
//                         ),
//                       ],
//                     ),
//                   );
//                 },
//               ),
//             ],
//           ),
//           const SizedBox(height: 20),
//           _buildSearchBar(context),
//         ],
//       ),
//     );
//   }
//
//   Widget _buildSearchBar(BuildContext context) {
//     return Row(
//       children: [
//         Expanded(
//           child: Container(
//             decoration: BoxDecoration(
//               color: Colors.white,
//               borderRadius: BorderRadius.circular(16),
//               boxShadow: [
//                 BoxShadow(
//                   color: Colors.black.withOpacity(0.1),
//                   blurRadius: 20,
//                   offset: const Offset(0, 5),
//                 ),
//               ],
//             ),
//             child: TextField(
//               controller: _searchController,
//               style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
//               decoration: InputDecoration(
//                 hintText: 'ابحث عن منتج...',
//                 hintStyle: TextStyle(
//                   color: Colors.grey[400],
//                   fontWeight: FontWeight.w400,
//                 ),
//                 prefixIcon: const Icon(
//                   Icons.search_rounded,
//                   color: Color(0xFF6C63FF),
//                   size: 24,
//                 ),
//                 suffixIcon: _searchController.text.isNotEmpty
//                     ? IconButton(
//                         icon: Icon(
//                           Icons.close_rounded,
//                           color: Colors.grey[600],
//                         ),
//                         onPressed: () {
//                           _searchController.clear();
//                           _allResults.clear();
//                           setState(() => _isSearching = false);
//                         },
//                       )
//                     : null,
//                 border: InputBorder.none,
//                 contentPadding: const EdgeInsets.symmetric(
//                   horizontal: 20,
//                   vertical: 18,
//                 ),
//               ),
//             ),
//           ),
//         ),
//         const SizedBox(width: 12),
//         Container(
//           decoration: BoxDecoration(
//             gradient: const LinearGradient(
//               colors: [Color(0xFFFF6B9D), Color(0xFFFFA06B)],
//             ),
//             borderRadius: BorderRadius.circular(16),
//             boxShadow: [
//               BoxShadow(
//                 color: const Color(0xFFFF6B9D).withOpacity(0.4),
//                 blurRadius: 15,
//                 offset: const Offset(0, 5),
//               ),
//             ],
//           ),
//           child: Material(
//             color: Colors.transparent,
//             child: InkWell(
//               borderRadius: BorderRadius.circular(16),
//               onTap: _openBarcodeScanner,
//               child: Container(
//                 padding: const EdgeInsets.all(16),
//                 child: const Icon(
//                   Icons.qr_code_scanner_rounded,
//                   color: Colors.white,
//                   size: 28,
//                 ),
//               ),
//             ),
//           ),
//         ),
//       ],
//     );
//   }
//
//   Widget _buildWideLayout() {
//     return Row(
//       children: [
//         Expanded(flex: 5, child: _buildSearchResults()),
//         Container(width: 1, color: Colors.grey[200]),
//         Expanded(flex: 4, child: _buildInvoiceView()),
//       ],
//     );
//   }
//
//   Widget _buildNarrowLayout() {
//     return Stack(
//       children: [_buildSearchResults(), if (!_isSearching) _buildInvoiceView()],
//     );
//   }
//
//   Widget _buildSearchResults() {
//     if (!_isSearching) return const SizedBox.shrink();
//
//     return BlocConsumer<SearchCubit, SearchState>(
//       listener: (context, state) {
//         if (state is SearchSuccess) {
//           setState(() {
//             if (_currentPage == 1) {
//               _allResults = state.searchEntity?.results ?? [];
//
//               // Auto-add if only one result from barcode
//               if (_allResults.length == 1) {
//                 _addProductToInvoice(_allResults.first);
//               }
//             } else {
//               _allResults.addAll(state.searchEntity?.results ?? []);
//             }
//             _isLoadingMore = false;
//           });
//         } else if (state is SearchFailure) {
//           setState(() => _isLoadingMore = false);
//           ScaffoldMessenger.of(context).showSnackBar(
//             SnackBar(
//               content: Row(
//                 children: [
//                   const Icon(Icons.error_outline, color: Colors.white),
//                   const SizedBox(width: 12),
//                   Expanded(child: Text('خطأ: ${state.exception.toString()}')),
//                 ],
//               ),
//               backgroundColor: const Color(0xFFFF6B6B),
//               behavior: SnackBarBehavior.floating,
//               shape: RoundedRectangleBorder(
//                 borderRadius: BorderRadius.circular(12),
//               ),
//               margin: const EdgeInsets.all(16),
//             ),
//           );
//         }
//       },
//       builder: (context, state) {
//         if (state is SearchLoading && _currentPage == 1) {
//           return _buildLoadingState();
//         }
//
//         if (_allResults.isEmpty) {
//           return _buildNoResultsState();
//         }
//
//         return Column(
//           children: [
//             Container(
//               margin: const EdgeInsets.all(16),
//               padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
//               decoration: BoxDecoration(
//                 gradient: LinearGradient(
//                   colors: [
//                     const Color(0xFF4FACFE).withOpacity(0.1),
//                     const Color(0xFF00F2FE).withOpacity(0.1),
//                   ],
//                 ),
//                 borderRadius: BorderRadius.circular(16),
//                 border: Border.all(
//                   color: const Color(0xFF4FACFE).withOpacity(0.3),
//                   width: 1.5,
//                 ),
//               ),
//               child: Row(
//                 children: [
//                   Container(
//                     padding: const EdgeInsets.all(10),
//                     decoration: BoxDecoration(
//                       color: const Color(0xFF4FACFE).withOpacity(0.2),
//                       borderRadius: BorderRadius.circular(12),
//                     ),
//                     child: const Icon(
//                       Icons.check_circle_rounded,
//                       color: Color(0xFF4FACFE),
//                       size: 22,
//                     ),
//                   ),
//                   const SizedBox(width: 12),
//                   Expanded(
//                     child: Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         Text(
//                           'تم العثور على ${_allResults.length} منتج',
//                           style: const TextStyle(
//                             color: Color(0xFF2D3436),
//                             fontWeight: FontWeight.bold,
//                             fontSize: 16,
//                           ),
//                         ),
//                         Text(
//                           'اضغط على منتج لإضافته للفاتورة',
//                           style: TextStyle(
//                             color: Colors.grey[600],
//                             fontSize: 12,
//                           ),
//                         ),
//                       ],
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//             Expanded(
//               child: ListView.builder(
//                 controller: _scrollController,
//                 padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
//                 itemCount: _allResults.length + (_isLoadingMore ? 1 : 0),
//                 itemBuilder: (context, index) {
//                   if (index == _allResults.length) {
//                     return Container(
//                       padding: const EdgeInsets.all(20),
//                       alignment: Alignment.center,
//                       child: const CircularProgressIndicator(
//                         color: Color(0xFF6C63FF),
//                       ),
//                     );
//                   }
//
//                   final product = _allResults[index];
//                   return _buildProductCard(product);
//                 },
//               ),
//             ),
//           ],
//         );
//       },
//     );
//   }
//
//   Widget _buildProductCard(Results product) {
//     return Container(
//       margin: const EdgeInsets.only(bottom: 12),
//       decoration: BoxDecoration(
//         color: Colors.white,
//         borderRadius: BorderRadius.circular(20),
//         boxShadow: [
//           BoxShadow(
//             color: Colors.black.withOpacity(0.05),
//             blurRadius: 10,
//             offset: const Offset(0, 4),
//           ),
//         ],
//       ),
//       child: Material(
//         color: Colors.transparent,
//         child: InkWell(
//           borderRadius: BorderRadius.circular(20),
//           onTap: () => _addProductToInvoice(product),
//           child: Padding(
//             padding: const EdgeInsets.all(16),
//             child: Row(
//               children: [
//                 Container(
//                   padding: const EdgeInsets.all(12),
//                   decoration: BoxDecoration(
//                     gradient: const LinearGradient(
//                       colors: [Color(0xFF6C63FF), Color(0xFF5A52E0)],
//                     ),
//                     borderRadius: BorderRadius.circular(14),
//                   ),
//                   child: const Icon(
//                     Icons.inventory_2_rounded,
//                     color: Colors.white,
//                     size: 24,
//                   ),
//                 ),
//                 const SizedBox(width: 12),
//                 Expanded(
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       Text(
//                         product.productName ?? 'بدون اسم',
//                         style: const TextStyle(
//                           fontSize: 16,
//                           fontWeight: FontWeight.bold,
//                           color: Color(0xFF2D3436),
//                         ),
//                         maxLines: 2,
//                         overflow: TextOverflow.ellipsis,
//                       ),
//                       const SizedBox(height: 4),
//                       Text(
//                         '#${product.productNumber ?? ''}',
//                         style: TextStyle(fontSize: 12, color: Colors.grey[600]),
//                       ),
//                     ],
//                   ),
//                 ),
//                 const SizedBox(width: 12),
//                 Container(
//                   padding: const EdgeInsets.symmetric(
//                     horizontal: 14,
//                     vertical: 10,
//                   ),
//                   decoration: BoxDecoration(
//                     gradient: const LinearGradient(
//                       colors: [Color(0xFF11998E), Color(0xFF38EF7D)],
//                     ),
//                     borderRadius: BorderRadius.circular(12),
//                   ),
//                   child: Text(
//                     '${product.sellingPrice ?? '0'} ر.س',
//                     style: const TextStyle(
//                       color: Colors.white,
//                       fontWeight: FontWeight.bold,
//                       fontSize: 14,
//                     ),
//                   ),
//                 ),
//                 const SizedBox(width: 8),
//                 Container(
//                   padding: const EdgeInsets.all(8),
//                   decoration: BoxDecoration(
//                     color: const Color(0xFF6C63FF).withOpacity(0.1),
//                     borderRadius: BorderRadius.circular(10),
//                   ),
//                   child: const Icon(
//                     Icons.add_rounded,
//                     color: Color(0xFF6C63FF),
//                     size: 20,
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }
//
//   Widget _buildInvoiceView() {
//     return BlocBuilder<InvoiceCubit, InvoiceEntity>(
//       builder: (context, invoice) {
//         return Container(
//           decoration: BoxDecoration(
//             color: Colors.white,
//             boxShadow: [
//               BoxShadow(
//                 color: Colors.black.withOpacity(0.05),
//                 blurRadius: 20,
//                 offset: const Offset(-5, 0),
//               ),
//             ],
//           ),
//           child: Column(
//             children: [
//               // Invoice Header
//               Container(
//                 padding: const EdgeInsets.all(20),
//                 decoration: BoxDecoration(
//                   gradient: const LinearGradient(
//                     colors: [Color(0xFF667EEA), Color(0xFF764BA2)],
//                   ),
//                   boxShadow: [
//                     BoxShadow(
//                       color: const Color(0xFF667EEA).withOpacity(0.3),
//                       blurRadius: 15,
//                       offset: const Offset(0, 5),
//                     ),
//                   ],
//                 ),
//                 child: Row(
//                   children: [
//                     const Icon(
//                       Icons.receipt_long_rounded,
//                       color: Colors.white,
//                       size: 28,
//                     ),
//                     const SizedBox(width: 12),
//                     const Expanded(
//                       child: Text(
//                         'الفاتورة',
//                         style: TextStyle(
//                           color: Colors.white,
//                           fontSize: 20,
//                           fontWeight: FontWeight.bold,
//                         ),
//                       ),
//                     ),
//                     if (invoice.items.isNotEmpty)
//                       IconButton(
//                         icon: const Icon(
//                           Icons.delete_outline_rounded,
//                           color: Colors.white,
//                         ),
//                         onPressed: () {
//                           showDialog(
//                             context: context,
//                             builder: (context) => AlertDialog(
//                               shape: RoundedRectangleBorder(
//                                 borderRadius: BorderRadius.circular(20),
//                               ),
//                               title: const Text('مسح الفاتورة'),
//                               content: const Text(
//                                 'هل تريد مسح جميع المنتجات من الفاتورة؟',
//                               ),
//                               actions: [
//                                 TextButton(
//                                   onPressed: () => Navigator.pop(context),
//                                   child: const Text('إلغاء'),
//                                 ),
//                                 ElevatedButton(
//                                   onPressed: () {
//                                     invoiceViewModel.clearInvoice();
//                                     Navigator.pop(context);
//                                   },
//                                   style: ElevatedButton.styleFrom(
//                                     backgroundColor: Colors.red,
//                                     shape: RoundedRectangleBorder(
//                                       borderRadius: BorderRadius.circular(12),
//                                     ),
//                                   ),
//                                   child: const Text('مسح'),
//                                 ),
//                               ],
//                             ),
//                           );
//                         },
//                       ),
//                   ],
//                 ),
//               ),
//
//               // Invoice Items
//               Expanded(
//                 child: invoice.items.isEmpty
//                     ? Center(
//                         child: Column(
//                           mainAxisAlignment: MainAxisAlignment.center,
//                           children: [
//                             Container(
//                               padding: const EdgeInsets.all(40),
//                               decoration: BoxDecoration(
//                                 gradient: LinearGradient(
//                                   colors: [
//                                     const Color(0xFF6C63FF).withOpacity(0.1),
//                                     const Color(0xFF5A52E0).withOpacity(0.05),
//                                   ],
//                                 ),
//                                 shape: BoxShape.circle,
//                               ),
//                               child: Icon(
//                                 Icons.shopping_cart_outlined,
//                                 size: 80,
//                                 color: Colors.grey[300],
//                               ),
//                             ),
//                             const SizedBox(height: 24),
//                             Text(
//                               'الفاتورة فارغة',
//                               style: TextStyle(
//                                 fontSize: 18,
//                                 fontWeight: FontWeight.w600,
//                                 color: Colors.grey[600],
//                               ),
//                             ),
//                             const SizedBox(height: 8),
//                             Text(
//                               'ابحث وأضف منتجات للفاتورة',
//                               style: TextStyle(
//                                 fontSize: 14,
//                                 color: Colors.grey[400],
//                               ),
//                             ),
//                           ],
//                         ),
//                       )
//                     : ListView.builder(
//                         padding: const EdgeInsets.all(16),
//                         itemCount: invoice.items.length,
//                         itemBuilder: (context, index) {
//                           final item = invoice.items[index];
//                           return _buildInvoiceItem(item);
//                         },
//                       ),
//               ),
//
//               // Invoice Total
//               if (invoice.items.isNotEmpty)
//                 Container(
//                   padding: const EdgeInsets.all(20),
//                   decoration: BoxDecoration(
//                     color: Colors.grey[50],
//                     border: Border(
//                       top: BorderSide(color: Colors.grey[200]!, width: 1),
//                     ),
//                   ),
//                   child: Column(
//                     children: [
//                       _buildTotalRow('المجموع الفرعي', invoice.subtotal),
//                       const SizedBox(height: 8),
//                       _buildTotalRow('الضريبة', invoice.tax),
//                       const Divider(height: 24),
//                       _buildTotalRow('الإجمالي', invoice.total, isTotal: true),
//                       const SizedBox(height: 16),
//                       ElevatedButton(
//                         onPressed: () {
//                           // Complete invoice
//                           showDialog(
//                             context: context,
//                             builder: (context) => AlertDialog(
//                               shape: RoundedRectangleBorder(
//                                 borderRadius: BorderRadius.circular(20),
//                               ),
//                               title: const Text('إتمام الفاتورة'),
//                               content: Text(
//                                 'المجموع: ${invoice.total.toStringAsFixed(2)} ر.س\nعدد المنتجات: ${invoice.items.length}',
//                               ),
//                               actions: [
//                                 TextButton(
//                                   onPressed: () => Navigator.pop(context),
//                                   child: const Text('إلغاء'),
//                                 ),
//                                 ElevatedButton(
//                                   onPressed: () {
//                                     invoiceViewModel.clearInvoice();
//                                     Navigator.pop(context);
//                                     ScaffoldMessenger.of(context).showSnackBar(
//                                       SnackBar(
//                                         content: Row(
//                                           children: [
//                                             Container(
//                                               padding: const EdgeInsets.all(8),
//                                               decoration: const BoxDecoration(
//                                                 gradient: LinearGradient(
//                                                   colors: [
//                                                     Color(0xFF11998E),
//                                                     Color(0xFF38EF7D),
//                                                   ],
//                                                 ),
//                                                 shape: BoxShape.circle,
//                                               ),
//                                               child: const Icon(
//                                                 Icons.check_rounded,
//                                                 color: Colors.white,
//                                                 size: 20,
//                                               ),
//                                             ),
//                                             const SizedBox(width: 12),
//                                             const Expanded(
//                                               child: Text(
//                                                 'تم إتمام الفاتورة بنجاح',
//                                                 style: TextStyle(
//                                                   fontWeight: FontWeight.bold,
//                                                   fontSize: 15,
//                                                 ),
//                                               ),
//                                             ),
//                                           ],
//                                         ),
//                                         backgroundColor: const Color(
//                                           0xFF2D3436,
//                                         ),
//                                         behavior: SnackBarBehavior.floating,
//                                         shape: RoundedRectangleBorder(
//                                           borderRadius: BorderRadius.circular(
//                                             12,
//                                           ),
//                                         ),
//                                         margin: const EdgeInsets.all(16),
//                                       ),
//                                     );
//                                   },
//                                   style: ElevatedButton.styleFrom(
//                                     backgroundColor: const Color(0xFF11998E),
//                                     shape: RoundedRectangleBorder(
//                                       borderRadius: BorderRadius.circular(12),
//                                     ),
//                                   ),
//                                   child: const Text('إتمام'),
//                                 ),
//                               ],
//                             ),
//                           );
//                         },
//                         style: ElevatedButton.styleFrom(
//                           backgroundColor: const Color(0xFF6C63FF),
//                           padding: const EdgeInsets.symmetric(vertical: 16),
//                           shape: RoundedRectangleBorder(
//                             borderRadius: BorderRadius.circular(16),
//                           ),
//                           elevation: 0,
//                         ),
//                         child: Row(
//                           mainAxisAlignment: MainAxisAlignment.center,
//                           children: [
//                             const Icon(Icons.check_circle_rounded, size: 24),
//                             const SizedBox(width: 8),
//                             const Text(
//                               'إتمام الفاتورة',
//                               style: TextStyle(
//                                 fontSize: 18,
//                                 fontWeight: FontWeight.bold,
//                               ),
//                             ),
//                           ],
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//             ],
//           ),
//         );
//       },
//     );
//   }
//
//   Widget _buildInvoiceItem(InvoiceItem item) {
//     return Container(
//       margin: const EdgeInsets.only(bottom: 12),
//       padding: const EdgeInsets.all(16),
//       decoration: BoxDecoration(
//         color: Colors.white,
//         borderRadius: BorderRadius.circular(16),
//         border: Border.all(color: Colors.grey[200]!, width: 1),
//         boxShadow: [
//           BoxShadow(
//             color: Colors.black.withOpacity(0.03),
//             blurRadius: 8,
//             offset: const Offset(0, 2),
//           ),
//         ],
//       ),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Row(
//             children: [
//               Expanded(
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     Text(
//                       item.product.productName ?? 'بدون اسم',
//                       style: const TextStyle(
//                         fontSize: 15,
//                         fontWeight: FontWeight.bold,
//                         color: Color(0xFF2D3436),
//                       ),
//                       maxLines: 2,
//                       overflow: TextOverflow.ellipsis,
//                     ),
//                     const SizedBox(height: 4),
//                     Text(
//                       '#${item.product.productNumber ?? ''}',
//                       style: TextStyle(fontSize: 12, color: Colors.grey[600]),
//                     ),
//                   ],
//                 ),
//               ),
//               IconButton(
//                 icon: const Icon(
//                   Icons.close_rounded,
//                   color: Colors.red,
//                   size: 20,
//                 ),
//                 onPressed: () {
//                   invoiceViewModel.removeProduct(item.product.productId!);
//                 },
//                 padding: EdgeInsets.zero,
//                 constraints: const BoxConstraints(),
//               ),
//             ],
//           ),
//           const SizedBox(height: 12),
//           const Divider(height: 1),
//           const SizedBox(height: 12),
//           Row(
//             children: [
//               // Quantity Controls
//               Container(
//                 decoration: BoxDecoration(
//                   color: Colors.grey[100],
//                   borderRadius: BorderRadius.circular(12),
//                 ),
//                 child: Row(
//                   children: [
//                     _buildQuantityButton(
//                       icon: Icons.remove_rounded,
//                       onPressed: () {
//                         invoiceViewModel.updateQuantity(
//                           item.product.productId!,
//                           item.quantity - 1,
//                         );
//                       },
//                     ),
//                     Container(
//                       padding: const EdgeInsets.symmetric(horizontal: 8),
//                       child: Text(
//                         '${item.quantity}',
//                         style: const TextStyle(
//                           fontSize: 16,
//                           fontWeight: FontWeight.bold,
//                           color: Color(0xFF2D3436),
//                         ),
//                       ),
//                     ),
//                     _buildQuantityButton(
//                       icon: Icons.add_rounded,
//                       onPressed: () {
//                         invoiceViewModel.updateQuantity(
//                           item.product.productId!,
//                           item.quantity + 1,
//                         );
//                       },
//                     ),
//                   ],
//                 ),
//               ),
//               const SizedBox(width: 12),
//               Text(
//                 '×',
//                 style: TextStyle(
//                   fontSize: 16,
//                   fontWeight: FontWeight.bold,
//                   color: Colors.grey[400],
//                 ),
//               ),
//               const SizedBox(width: 12),
//               Container(
//                 padding: const EdgeInsets.symmetric(
//                   horizontal: 12,
//                   vertical: 8,
//                 ),
//                 decoration: BoxDecoration(
//                   color: const Color(0xFF4FACFE).withOpacity(0.1),
//                   borderRadius: BorderRadius.circular(10),
//                 ),
//                 child: Text(
//                   '${item.product.sellingPrice ?? '0'} ر.س',
//                   style: const TextStyle(
//                     fontSize: 14,
//                     fontWeight: FontWeight.w600,
//                     color: Color(0xFF4FACFE),
//                   ),
//                 ),
//               ),
//               const Spacer(),
//               Container(
//                 padding: const EdgeInsets.symmetric(
//                   horizontal: 12,
//                   vertical: 8,
//                 ),
//                 decoration: BoxDecoration(
//                   gradient: const LinearGradient(
//                     colors: [Color(0xFF11998E), Color(0xFF38EF7D)],
//                   ),
//                   borderRadius: BorderRadius.circular(10),
//                 ),
//                 child: Text(
//                   '${item.itemTotal.toStringAsFixed(2)} ر.س',
//                   style: const TextStyle(
//                     fontSize: 14,
//                     fontWeight: FontWeight.bold,
//                     color: Colors.white,
//                   ),
//                 ),
//               ),
//             ],
//           ),
//           if (item.itemTax > 0) ...[
//             const SizedBox(height: 8),
//             Row(
//               children: [
//                 Icon(Icons.receipt_rounded, size: 14, color: Colors.grey[600]),
//                 const SizedBox(width: 4),
//                 Text(
//                   'ضريبة: ${item.itemTax.toStringAsFixed(2)} ر.س',
//                   style: TextStyle(fontSize: 12, color: Colors.grey[600]),
//                 ),
//               ],
//             ),
//           ],
//         ],
//       ),
//     );
//   }
//
//   Widget _buildQuantityButton({
//     required IconData icon,
//     required VoidCallback onPressed,
//   }) {
//     return Material(
//       color: Colors.transparent,
//       child: InkWell(
//         onTap: onPressed,
//         borderRadius: BorderRadius.circular(10),
//         child: Container(
//           padding: const EdgeInsets.all(8),
//           child: Icon(icon, size: 20, color: const Color(0xFF6C63FF)),
//         ),
//       ),
//     );
//   }
//
//   Widget _buildTotalRow(String label, double amount, {bool isTotal = false}) {
//     return Row(
//       mainAxisAlignment: MainAxisAlignment.spaceBetween,
//       children: [
//         Text(
//           label,
//           style: TextStyle(
//             fontSize: isTotal ? 18 : 15,
//             fontWeight: isTotal ? FontWeight.bold : FontWeight.w600,
//             color: isTotal ? const Color(0xFF2D3436) : Colors.grey[700],
//           ),
//         ),
//         Text(
//           '${amount.toStringAsFixed(2)} ر.س',
//           style: TextStyle(
//             fontSize: isTotal ? 20 : 15,
//             fontWeight: FontWeight.bold,
//             color: isTotal ? const Color(0xFF6C63FF) : const Color(0xFF2D3436),
//           ),
//         ),
//       ],
//     );
//   }
//
//   Widget _buildLoadingState() {
//     return Center(
//       child: Column(
//         mainAxisAlignment: MainAxisAlignment.center,
//         children: [
//           Container(
//             padding: const EdgeInsets.all(20),
//             decoration: BoxDecoration(
//               gradient: LinearGradient(
//                 colors: [
//                   const Color(0xFF6C63FF).withOpacity(0.1),
//                   const Color(0xFF5A52E0).withOpacity(0.05),
//                 ],
//               ),
//               shape: BoxShape.circle,
//             ),
//             child: const CircularProgressIndicator(
//               color: Color(0xFF6C63FF),
//               strokeWidth: 3,
//             ),
//           ),
//           const SizedBox(height: 24),
//           const Text(
//             'جاري البحث...',
//             style: TextStyle(
//               fontSize: 16,
//               fontWeight: FontWeight.w600,
//               color: Color(0xFF2D3436),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
//
//   Widget _buildNoResultsState() {
//     return Center(
//       child: Column(
//         mainAxisAlignment: MainAxisAlignment.center,
//         children: [
//           Container(
//             padding: const EdgeInsets.all(40),
//             decoration: BoxDecoration(
//               gradient: LinearGradient(
//                 colors: [
//                   const Color(0xFFFF6B9D).withOpacity(0.1),
//                   const Color(0xFFFFA06B).withOpacity(0.05),
//                 ],
//               ),
//               shape: BoxShape.circle,
//             ),
//             child: Icon(
//               Icons.search_off_rounded,
//               size: 80,
//               color: Colors.grey[300],
//             ),
//           ),
//           const SizedBox(height: 24),
//           const Text(
//             'لم نجد أي نتائج',
//             style: TextStyle(
//               fontSize: 20,
//               fontWeight: FontWeight.bold,
//               color: Color(0xFF2D3436),
//             ),
//           ),
//           const SizedBox(height: 12),
//           Text(
//             'جرب البحث بكلمات مختلفة',
//             style: TextStyle(fontSize: 15, color: Colors.grey[500]),
//           ),
//         ],
//       ),
//     );
//   }
// }
