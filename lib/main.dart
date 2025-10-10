// import 'package:firebase_core/firebase_core.dart';
// import 'package:flutter/material.dart';
// import 'package:mobile_scanner/mobile_scanner.dart';
// import 'package:http/http.dart' as http;
// import 'dart:convert';
//
// import 'firebase_options.dart';
//
// void main() async{
//   await Firebase.initializeApp(
//     options: DefaultFirebaseOptions.currentPlatform,
//   );
//   runApp(MyApp());
// }
//
// class MyApp extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       title: 'إدارة المخزون',
//       theme: ThemeData(
//         useMaterial3: true,
//         colorScheme: ColorScheme.fromSeed(
//           seedColor: const Color(0xFF1565C0),
//           brightness: Brightness.light,
//         ),
//         appBarTheme: const AppBarTheme(
//           centerTitle: true,
//           elevation: 0,
//           scrolledUnderElevation: 1,
//         ),
//         cardTheme: CardThemeData(
//           elevation: 2,
//           shape: RoundedRectangleBorder(
//             borderRadius: BorderRadius.circular(16),
//           ),
//         ),
//         elevatedButtonTheme: ElevatedButtonThemeData(
//           style: ElevatedButton.styleFrom(
//             elevation: 2,
//             padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
//             shape: RoundedRectangleBorder(
//               borderRadius: BorderRadius.circular(12),
//             ),
//           ),
//         ),
//         inputDecorationTheme: InputDecorationTheme(
//           filled: true,
//           fillColor: Colors.grey[50],
//           border: OutlineInputBorder(
//             borderRadius: BorderRadius.circular(12),
//             borderSide: BorderSide(color: Colors.grey[300]!),
//           ),
//           enabledBorder: OutlineInputBorder(
//             borderRadius: BorderRadius.circular(12),
//             borderSide: BorderSide(color: Colors.grey[300]!),
//           ),
//           focusedBorder: OutlineInputBorder(
//             borderRadius: BorderRadius.circular(12),
//             borderSide: const BorderSide(color: Color(0xFF1565C0), width: 2),
//           ),
//           contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
//         ),
//       ),
//       home: MainScreen(),
//       debugShowCheckedModeBanner: false,
//     );
//   }
// }
//
// class MainScreen extends StatefulWidget {
//   @override
//   _MainScreenState createState() => _MainScreenState();
// }
//
// class _MainScreenState extends State<MainScreen> {
//   int _currentIndex = 0;
//   final PageController _pageController = PageController();
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: PageView(
//         controller: _pageController,
//         onPageChanged: (index) {
//           setState(() {
//             _currentIndex = index;
//           });
//         },
//         children: [
//           BarcodeScanner(),
//           SearchScreen(),
//         ],
//       ),
//       bottomNavigationBar: Container(
//         decoration: BoxDecoration(
//           boxShadow: [
//             BoxShadow(
//               color: Colors.black.withOpacity(0.1),
//               blurRadius: 8,
//               offset: const Offset(0, -2),
//             ),
//           ],
//         ),
//         child: BottomNavigationBar(
//           currentIndex: _currentIndex,
//           onTap: (index) {
//             _pageController.animateToPage(
//               index,
//               duration: const Duration(milliseconds: 200),
//               curve: Curves.easeInOut,
//             );
//           },
//           type: BottomNavigationBarType.fixed,
//           backgroundColor: Colors.white,
//           selectedItemColor: const Color(0xFF1565C0),
//           unselectedItemColor: Colors.grey[600],
//           selectedLabelStyle: const TextStyle(fontWeight: FontWeight.w600),
//           items: const [
//             BottomNavigationBarItem(
//               icon: Icon(Icons.qr_code_scanner, size: 26),
//               label: 'مسح الباركود',
//             ),
//             BottomNavigationBarItem(
//               icon: Icon(Icons.search, size: 26),
//               label: 'البحث',
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
//
// class BarcodeScanner extends StatefulWidget {
//   @override
//   _BarcodeScannerState createState() => _BarcodeScannerState();
// }
//
// class _BarcodeScannerState extends State<BarcodeScanner> {
//   MobileScannerController cameraController = MobileScannerController(
//     formats: [BarcodeFormat.all],
//   );
//
//   bool isScanning = true;
//   bool isLoading = false;
//   Map<String, dynamic>? productData;
//   String? errorMessage;
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('مسح الباركود', style: TextStyle(fontWeight: FontWeight.w600)),
//         backgroundColor: Theme.of(context).colorScheme.primary,
//         foregroundColor: Colors.white,
//       ),
//       body: SafeArea(
//         child: Column(
//           children: [
//             if (isScanning) ...[
//               Expanded(
//                 flex: 3,
//                 child: Container(
//                   margin: const EdgeInsets.all(16),
//                   decoration: BoxDecoration(
//                     borderRadius: BorderRadius.circular(16),
//                     boxShadow: [
//                       BoxShadow(
//                         color: Colors.black.withOpacity(0.1),
//                         blurRadius: 8,
//                         offset: const Offset(0, 4),
//                       ),
//                     ],
//                   ),
//                   child: ClipRRect(
//                     borderRadius: BorderRadius.circular(16),
//                     child: MobileScanner(
//                       controller: cameraController,
//                       onDetect: (capture) {
//                         final List<Barcode> barcodes = capture.barcodes;
//                         for (final barcode in barcodes) {
//                           if (barcode.rawValue != null) {
//                             _onBarcodeDetected(barcode.rawValue!);
//                             break;
//                           }
//                         }
//                       },
//                     ),
//                   ),
//                 ),
//               ),
//               Container(
//                 margin: const EdgeInsets.all(16),
//                 padding: const EdgeInsets.all(20),
//                 decoration: BoxDecoration(
//                   color: Colors.blue[50],
//                   borderRadius: BorderRadius.circular(16),
//                   border: Border.all(color: Colors.blue[100]!),
//                 ),
//                 child: Row(
//                   children: [
//                     Icon(Icons.camera_alt_outlined, color: Colors.blue[700], size: 24),
//                     const SizedBox(width: 12),
//                     Expanded(
//                       child: Text(
//                         'وجه الكاميرا نحو الباركود للمسح التلقائي',
//                         style: TextStyle(
//                           fontSize: 16,
//                           fontWeight: FontWeight.w500,
//                           color: Colors.blue[800],
//                         ),
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//             ],
//
//             if (isLoading) ...[
//               Expanded(
//                 child: Center(
//                   child: Column(
//                     mainAxisAlignment: MainAxisAlignment.center,
//                     children: [
//                       Container(
//                         padding: const EdgeInsets.all(24),
//                         decoration: BoxDecoration(
//                           color: Colors.white,
//                           borderRadius: BorderRadius.circular(20),
//                           boxShadow: [
//                             BoxShadow(
//                               color: Colors.black.withOpacity(0.1),
//                               blurRadius: 16,
//                               offset: const Offset(0, 8),
//                             ),
//                           ],
//                         ),
//                         child: Column(
//                           children: [
//                             const CircularProgressIndicator(strokeWidth: 3),
//                             const SizedBox(height: 20),
//                             Text(
//                               'جاري البحث عن المنتج...',
//                               style: TextStyle(
//                                 fontSize: 16,
//                                 fontWeight: FontWeight.w500,
//                                 color: Colors.grey[700],
//                               ),
//                             ),
//                           ],
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//               ),
//             ],
//
//             if (productData != null) ...[
//               Expanded(
//                 child: ProductDetailsWidget(
//                   productData: productData!,
//                   onQuantityUpdated: () => _resetScanner(),
//                   onBackToScanner: () => _resetScanner(),
//                 ),
//               ),
//             ],
//
//             if (errorMessage != null) ...[
//               Expanded(
//                 child: Center(
//                   child: Container(
//                     margin: const EdgeInsets.all(24),
//                     padding: const EdgeInsets.all(32),
//                     decoration: BoxDecoration(
//                       color: Colors.white,
//                       borderRadius: BorderRadius.circular(20),
//                       boxShadow: [
//                         BoxShadow(
//                           color: Colors.black.withOpacity(0.1),
//                           blurRadius: 16,
//                           offset: const Offset(0, 8),
//                         ),
//                       ],
//                     ),
//                     child: Column(
//                       mainAxisSize: MainAxisSize.min,
//                       children: [
//                         Container(
//                           padding: const EdgeInsets.all(16),
//                           decoration: BoxDecoration(
//                             color: Colors.red[50],
//                             borderRadius: BorderRadius.circular(50),
//                           ),
//                           child: Icon(Icons.error_outline, size: 48, color: Colors.red[600]),
//                         ),
//                         const SizedBox(height: 20),
//                         Text(
//                           errorMessage!,
//                           style: TextStyle(
//                             fontSize: 16,
//                             color: Colors.grey[700],
//                             height: 1.5,
//                           ),
//                           textAlign: TextAlign.center,
//                         ),
//                         const SizedBox(height: 28),
//                         FilledButton.icon(
//                           onPressed: _resetScanner,
//                           icon: const Icon(Icons.refresh),
//                           label: const Text('إعادة المحاولة'),
//                         ),
//                       ],
//                     ),
//                   ),
//                 ),
//               ),
//             ],
//           ],
//         ),
//       ),
//     );
//   }
//
//   void _onBarcodeDetected(String barcode) async {
//     if (!isScanning) return;
//
//     setState(() {
//       isScanning = false;
//       isLoading = true;
//       productData = null;
//       errorMessage = null;
//     });
//
//     await cameraController.stop();
//     await _fetchProductData(barcode);
//   }
//
//   Future<void> _fetchProductData(String search) async {
//     try {
//       final url = 'https://artawiya.com/stock_up_DB/api/v1/stocktaking/search_product?search=$search';
//       final response = await http.get(Uri.parse(url));
//
//       if (response.statusCode == 200) {
//         final data = json.decode(response.body);
//
//         if (data['status'] == 'success' && data['data'] != null && data['data'].isNotEmpty) {
//           setState(() {
//             productData = data['data'][0];
//             isLoading = false;
//           });
//         } else {
//           setState(() {
//             errorMessage = 'لم يتم العثور على المنتج بالباركود المحدد';
//             isLoading = false;
//           });
//         }
//       } else {
//         setState(() {
//           errorMessage = 'حدث خطأ في الاتصال بالخادم\nيرجى المحاولة مرة أخرى';
//           isLoading = false;
//         });
//       }
//     } catch (e) {
//       setState(() {
//         errorMessage = 'تعذر الاتصال بالإنترنت\nيرجى التحقق من الاتصال والمحاولة مرة أخرى';
//         isLoading = false;
//       });
//     }
//   }
//
//   void _resetScanner() {
//     setState(() {
//       isScanning = true;
//       isLoading = false;
//       productData = null;
//       errorMessage = null;
//     });
//     cameraController.start();
//   }
//
//   @override
//   void dispose() {
//     cameraController.dispose();
//     super.dispose();
//   }
// }
//
// class SearchScreen extends StatefulWidget {
//   @override
//   _SearchScreenState createState() => _SearchScreenState();
// }
//
// class _SearchScreenState extends State<SearchScreen> {
//   final TextEditingController _searchController = TextEditingController();
//   bool isLoading = false;
//   Map<String, dynamic>? productData;
//   String? errorMessage;
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('البحث عن المنتج', style: TextStyle(fontWeight: FontWeight.w600)),
//         backgroundColor: Theme.of(context).colorScheme.primary,
//         foregroundColor: Colors.white,
//       ),
//       body: SafeArea(
//         child: Column(
//           children: [
//             Container(
//               margin: const EdgeInsets.all(16),
//               child: Card(
//                 child: Padding(
//                   padding: const EdgeInsets.all(20),
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       Row(
//                         children: [
//                           Container(
//                             padding: const EdgeInsets.all(8),
//                             decoration: BoxDecoration(
//                               color: Colors.blue[50],
//                               borderRadius: BorderRadius.circular(8),
//                             ),
//                             child: Icon(Icons.search, color: Colors.blue[700], size: 20),
//                           ),
//                           const SizedBox(width: 12),
//                           const Text(
//                             'البحث في المخزون',
//                             style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
//                           ),
//                         ],
//                       ),
//                       const SizedBox(height: 20),
//                       TextField(
//                         controller: _searchController,
//                         decoration: const InputDecoration(
//                           labelText: 'ادخل اسم المنتج أو الباركود',
//                           hintText: 'مثال: مايونيز الصفاء أو 1234567890',
//                           prefixIcon: Icon(Icons.inventory_2_outlined),
//                         ),
//                         textInputAction: TextInputAction.search,
//                         onSubmitted: (value) => _searchProduct(),
//                       ),
//                       const SizedBox(height: 20),
//                       SizedBox(
//                         width: double.infinity,
//                         child: FilledButton(
//                           onPressed: isLoading ? null : _searchProduct,
//                           child: isLoading
//                               ? const SizedBox(
//                             height: 20,
//                             width: 20,
//                             child: CircularProgressIndicator(
//                               strokeWidth: 2,
//                               color: Colors.white,
//                             ),
//                           )
//                               : const Text('البحث', style: TextStyle(fontSize: 16)),
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//               ),
//             ),
//
//             if (errorMessage != null)
//               Container(
//                 margin: const EdgeInsets.symmetric(horizontal: 16),
//                 child: Card(
//                   color: Colors.red[50],
//                   child: Padding(
//                     padding: const EdgeInsets.all(16),
//                     child: Row(
//                       children: [
//                         Container(
//                           padding: const EdgeInsets.all(8),
//                           decoration: BoxDecoration(
//                             color: Colors.red[100],
//                             borderRadius: BorderRadius.circular(20),
//                           ),
//                           child: Icon(Icons.error_outline, color: Colors.red[700], size: 20),
//                         ),
//                         const SizedBox(width: 12),
//                         Expanded(
//                           child: Text(
//                             errorMessage!,
//                             style: TextStyle(
//                               color: Colors.red[800],
//                               fontWeight: FontWeight.w500,
//                             ),
//                           ),
//                         ),
//                       ],
//                     ),
//                   ),
//                 ),
//               ),
//
//             if (productData != null)
//               Expanded(
//                 child: ProductDetailsWidget(
//                   productData: productData!,
//                   onQuantityUpdated: () => _clearResults(),
//                   onBackToScanner: () => _clearResults(),
//                 ),
//               ),
//
//             if (productData == null && errorMessage == null && !isLoading)
//               Expanded(
//                 child: Center(
//                   child: Column(
//                     mainAxisAlignment: MainAxisAlignment.center,
//                     children: [
//                       Container(
//                         padding: const EdgeInsets.all(20),
//                         decoration: BoxDecoration(
//                           color: Colors.grey[100],
//                           borderRadius: BorderRadius.circular(50),
//                         ),
//                         child: Icon(Icons.search, size: 48, color: Colors.grey[400]),
//                       ),
//                       const SizedBox(height: 16),
//                       Text(
//                         'ابحث عن المنتجات في المخزون',
//                         style: TextStyle(
//                           fontSize: 16,
//                           color: Colors.grey[600],
//                           fontWeight: FontWeight.w500,
//                         ),
//                       ),
//                       const SizedBox(height: 8),
//                       Text(
//                         'يمكنك البحث باسم المنتج أو الباركود',
//                         style: TextStyle(
//                           fontSize: 14,
//                           color: Colors.grey[500],
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//               ),
//           ],
//         ),
//       ),
//     );
//   }
//
//   void _searchProduct() async {
//     final searchText = _searchController.text.trim();
//     if (searchText.isEmpty) {
//       setState(() {
//         errorMessage = 'يرجى إدخال نص للبحث';
//       });
//       return;
//     }
//
//     setState(() {
//       isLoading = true;
//       errorMessage = null;
//       productData = null;
//     });
//
//     await _fetchProductData(searchText);
//   }
//
//   Future<void> _fetchProductData(String search) async {
//     try {
//       final url = 'https://artawiya.com/stock_up_DB/api/v1/stocktaking/search_product?search=${Uri.encodeComponent(search)}';
//       final response = await http.get(Uri.parse(url));
//
//       if (response.statusCode == 200) {
//         final data = json.decode(response.body);
//
//         if (data['status'] == 'success' && data['data'] != null && data['data'].isNotEmpty) {
//           setState(() {
//             productData = data['data'][0];
//             isLoading = false;
//           });
//         } else {
//           setState(() {
//             errorMessage = 'لم يتم العثور على المنتج المطلوب';
//             isLoading = false;
//           });
//         }
//       } else {
//         setState(() {
//           errorMessage = 'حدث خطأ في الاتصال بالخادم';
//           isLoading = false;
//         });
//       }
//     } catch (e) {
//       setState(() {
//         errorMessage = 'تعذر الاتصال بالإنترنت';
//         isLoading = false;
//       });
//     }
//   }
//
//   void _clearResults() {
//     setState(() {
//       productData = null;
//       errorMessage = null;
//       _searchController.clear();
//     });
//   }
// }
//
// class ProductDetailsWidget extends StatefulWidget {
//   final Map<String, dynamic> productData;
//   final VoidCallback onQuantityUpdated;
//   final VoidCallback onBackToScanner;
//
//   const ProductDetailsWidget({
//     Key? key,
//     required this.productData,
//     required this.onQuantityUpdated,
//     required this.onBackToScanner,
//   }) : super(key: key);
//
//   @override
//   _ProductDetailsWidgetState createState() => _ProductDetailsWidgetState();
// }
//
// class _ProductDetailsWidgetState extends State<ProductDetailsWidget> {
//   final TextEditingController _quantityController = TextEditingController();
//   bool isUpdating = false;
//
//   @override
//   void initState() {
//     super.initState();
//     _quantityController.text = widget.productData['إجمالى الكمية']?.toString() ?? '0';
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return SingleChildScrollView(
//       padding: const EdgeInsets.all(16),
//       child: Column(
//         children: [
//           // بيانات المنتج
//           Card(
//             child: Padding(
//               padding: const EdgeInsets.all(20),
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Row(
//                     children: [
//                       Container(
//                         padding: const EdgeInsets.all(8),
//                         decoration: BoxDecoration(
//                           color: Colors.green[50],
//                           borderRadius: BorderRadius.circular(8),
//                         ),
//                         child: Icon(Icons.inventory_2, color: Colors.green[700], size: 20),
//                       ),
//                       const SizedBox(width: 12),
//                       const Text(
//                         'بيانات المنتج',
//                         style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
//                       ),
//                     ],
//                   ),
//                   const Divider(height: 32),
//
//                   _buildInfoCard(
//                     title: widget.productData['اسم الصنف']?.toString() ?? 'غير محدد',
//                     subtitle: 'رقم الصنف: ${widget.productData['رقم الصنف']?.toString() ?? 'غير محدد'}',
//                     icon: Icons.label_outline,
//                     color: Colors.blue,
//                   ),
//
//                   const SizedBox(height: 16),
//
//                   Row(
//                     children: [
//                       Expanded(
//                         child: _buildInfoTile(
//                           'الكمية الحالية',
//                           '${widget.productData['إجمالى الكمية']} ${widget.productData['الوحدة']}',
//                           Icons.inventory,
//                           Colors.orange,
//                         ),
//                       ),
//                       const SizedBox(width: 16),
//                       Expanded(
//                         child: _buildInfoTile(
//                           'التصنيف',
//                           widget.productData['التصنيف']?.toString() ?? 'غير محدد',
//                           Icons.category_outlined,
//                           Colors.purple,
//                         ),
//                       ),
//                     ],
//                   ),
//
//                   const SizedBox(height: 16),
//
//                   Row(
//                     children: [
//                       Expanded(
//                         child: _buildInfoTile(
//                           'سعر البيع',
//                           '${widget.productData['سعر البيع']} ر.س',
//                           Icons.sell_outlined,
//                           Colors.green,
//                         ),
//                       ),
//                       const SizedBox(width: 16),
//                       Expanded(
//                         child: _buildInfoTile(
//                           'آخر سعر شراء',
//                           '${widget.productData['آخر سعر شراء']} ر.س',
//                           Icons.shopping_cart_outlined,
//                           Colors.red,
//                         ),
//                       ),
//                     ],
//                   ),
//
//                   const SizedBox(height: 16),
//
//                   Container(
//                     width: double.infinity,
//                     padding: const EdgeInsets.all(16),
//                     decoration: BoxDecoration(
//                       color: Colors.grey[50],
//                       borderRadius: BorderRadius.circular(12),
//                       border: Border.all(color: Colors.grey[200]!),
//                     ),
//                     child: Column(
//                       children: [
//                         Row(
//                           mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                           children: [
//                             Text(
//                               'خاضع للضريبة:',
//                               style: TextStyle(color: Colors.grey[600], fontSize: 14),
//                             ),
//                             Container(
//                               padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
//                               decoration: BoxDecoration(
//                                 color: widget.productData['خاضع للضريبة'] == 'نعم'
//                                     ? Colors.green[100]
//                                     : Colors.red[100],
//                                 borderRadius: BorderRadius.circular(12),
//                               ),
//                               child: Text(
//                                 widget.productData['خاضع للضريبة']?.toString() ?? 'غير محدد',
//                                 style: TextStyle(
//                                   color: widget.productData['خاضع للضريبة'] == 'نعم'
//                                       ? Colors.green[800]
//                                       : Colors.red[800],
//                                   fontSize: 12,
//                                   fontWeight: FontWeight.w600,
//                                 ),
//                               ),
//                             ),
//                           ],
//                         ),
//                         if (widget.productData['خاضع للضريبة'] == 'نعم') ...[
//                           const SizedBox(height: 8),
//                           Row(
//                             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                             children: [
//                               Text(
//                                 'نسبة الضريبة:',
//                                 style: TextStyle(color: Colors.grey[600], fontSize: 14),
//                               ),
//                               Text(
//                                 '${widget.productData['نسبة الضريبة']}%',
//                                 style: const TextStyle(fontWeight: FontWeight.w600),
//                               ),
//                             ],
//                           ),
//                         ],
//                       ],
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//           ),
//
//           const SizedBox(height: 16),
//
//           // تعديل الكمية
//           Card(
//             child: Padding(
//               padding: const EdgeInsets.all(20),
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Row(
//                     children: [
//                       Container(
//                         padding: const EdgeInsets.all(8),
//                         decoration: BoxDecoration(
//                           color: Colors.orange[50],
//                           borderRadius: BorderRadius.circular(8),
//                         ),
//                         child: Icon(Icons.edit_outlined, color: Colors.orange[700], size: 20),
//                       ),
//                       const SizedBox(width: 12),
//                       const Text(
//                         'تعديل الكمية',
//                         style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
//                       ),
//                     ],
//                   ),
//                   const Divider(height: 32),
//
//                   TextField(
//                     controller: _quantityController,
//                     keyboardType: const TextInputType.numberWithOptions(decimal: true),
//                     decoration: InputDecoration(
//                       labelText: 'الكمية الجديدة',
//                       hintText: 'ادخل الكمية المحدثة',
//                       prefixIcon: const Icon(Icons.inventory_outlined),
//                       suffixText: widget.productData['الوحدة']?.toString() ?? '',
//                     ),
//                   ),
//
//                   const SizedBox(height: 20),
//
//                   SizedBox(
//                     width: double.infinity,
//                     child: FilledButton.icon(
//                       onPressed: isUpdating ? null : _updateQuantity,
//                       icon: isUpdating
//                           ? const SizedBox(
//                         height: 16,
//                         width: 16,
//                         child: CircularProgressIndicator(
//                           strokeWidth: 2,
//                           color: Colors.white,
//                         ),
//                       )
//                           : const Icon(Icons.save_outlined),
//                       label: Text(isUpdating ? 'جاري التحديث...' : 'تحديث الكمية'),
//                       style: FilledButton.styleFrom(
//                         backgroundColor: Colors.orange[600],
//                       ),
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//           ),
//
//           const SizedBox(height: 16),
//
//           SizedBox(
//             width: double.infinity,
//             child: OutlinedButton.icon(
//               onPressed: widget.onBackToScanner,
//               icon: const Icon(Icons.refresh),
//               label: const Text('البحث عن منتج آخر'),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
//
//   Widget _buildInfoCard({
//     required String title,
//     required String subtitle,
//     required IconData icon,
//     required Color color,
//   }) {
//     return Container(
//       width: double.infinity,
//       padding: const EdgeInsets.all(16),
//       decoration: BoxDecoration(
//         color: color.withOpacity(0.05),
//         borderRadius: BorderRadius.circular(12),
//         border: Border.all(color: color.withOpacity(0.2)),
//       ),
//       child: Row(
//         children: [
//           Container(
//             padding: const EdgeInsets.all(8),
//             decoration: BoxDecoration(
//               color: color.withOpacity(0.1),
//               borderRadius: BorderRadius.circular(8),
//             ),
//             child: Icon(icon, color: color, size: 20),
//           ),
//           const SizedBox(width: 12),
//           Expanded(
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Text(
//                   title,
//                   style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
//                   maxLines: 2,
//                   overflow: TextOverflow.ellipsis,
//                 ),
//                 const SizedBox(height: 4),
//                 Text(
//                   subtitle,
//                   style: TextStyle(color: Colors.grey[600], fontSize: 14),
//                 ),
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }
//
//   Widget _buildInfoTile(String label, String value, IconData icon, Color color) {
//     return Container(
//       padding: const EdgeInsets.all(16),
//       decoration: BoxDecoration(
//         color: color.withOpacity(0.05),
//         borderRadius: BorderRadius.circular(12),
//         border: Border.all(color: color.withOpacity(0.2)),
//       ),
//       child: Column(
//         children: [
//           Container(
//             padding: const EdgeInsets.all(8),
//             decoration: BoxDecoration(
//               color: color.withOpacity(0.1),
//               borderRadius: BorderRadius.circular(20),
//             ),
//             child: Icon(icon, color: color, size: 20),
//           ),
//           const SizedBox(height: 8),
//           Text(
//             label,
//             style: TextStyle(
//               fontSize: 12,
//               color: Colors.grey[600],
//               fontWeight: FontWeight.w500,
//             ),
//           ),
//           const SizedBox(height: 4),
//           Text(
//             value,
//             style: const TextStyle(
//               fontWeight: FontWeight.w600,
//               fontSize: 14,
//             ),
//             textAlign: TextAlign.center,
//             maxLines: 2,
//             overflow: TextOverflow.ellipsis,
//           ),
//         ],
//       ),
//     );
//   }
//
//   void _updateQuantity() async {
//     final quantityText = _quantityController.text.trim();
//
//     if (quantityText.isEmpty) {
//       _showMessage('يرجى إدخال الكمية', isError: true);
//       return;
//     }
//
//     final quantity = double.tryParse(quantityText);
//     if (quantity == null || quantity < 0) {
//       _showMessage('يرجى إدخال كمية صحيحة', isError: true);
//       return;
//     }
//
//     setState(() {
//       isUpdating = true;
//     });
//
//     try {
//       final url = 'https://artawiya.com/stock_up_DB/api/v1/stocktaking/update_quantity';
//       final response = await http.post(
//         Uri.parse(url),
//         headers: {
//           'Content-Type': 'application/json',
//         },
//         body: json.encode({
//           'رقم_الصنف': widget.productData['رقم الصنف'].toString(),
//           'اجمالى_الكمية': quantity,
//         }),
//       );
//
//       if (response.statusCode == 200) {
//         final responseData = json.decode(response.body);
//         if (responseData['status'] == 'success') {
//           _showMessage('تم تحديث الكمية بنجاح', isError: false);
//
//           // تحديث البيانات المحلية
//           setState(() {
//             widget.productData['إجمالى الكمية'] = quantity.toString();
//           });
//
//           // تأخير قليل ثم العودة
//           Future.delayed(const Duration(seconds: 2), () {
//             if (mounted) {
//               widget.onQuantityUpdated();
//             }
//           });
//         } else {
//           _showMessage('فشل في تحديث الكمية: ${responseData['message'] ?? 'خطأ غير معروف'}', isError: true);
//         }
//       } else {
//         _showMessage('حدث خطأ في الخادم (${response.statusCode})', isError: true);
//       }
//     } catch (e) {
//       _showMessage('تعذر الاتصال بالخادم', isError: true);
//     }
//
//     if (mounted) {
//       setState(() {
//         isUpdating = false;
//       });
//     }
//   }
//
//   void _showMessage(String message, {required bool isError}) {
//     if (!mounted) return;
//
//     ScaffoldMessenger.of(context).showSnackBar(
//       SnackBar(
//         content: Row(
//           children: [
//             Icon(
//               isError ? Icons.error_outline : Icons.check_circle_outline,
//               color: Colors.white,
//               size: 20,
//             ),
//             const SizedBox(width: 8),
//             Expanded(
//               child: Text(
//                 message,
//                 style: const TextStyle(fontWeight: FontWeight.w500),
//               ),
//             ),
//           ],
//         ),
//         backgroundColor: isError ? Colors.red[600] : Colors.green[600],
//         behavior: SnackBarBehavior.floating,
//         shape: RoundedRectangleBorder(
//           borderRadius: BorderRadius.circular(12),
//         ),
//         duration: Duration(seconds: isError ? 4 : 3),
//         margin: const EdgeInsets.all(16),
//       ),
//     );
//   }
//
//   @override
//   void dispose() {
//     _quantityController.dispose();
//     super.dispose();
//   }
// }

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:barcode_widget/barcode_widget.dart';

import 'features/EmployeeBarcodeScreen/presentation/pages/EmployeeBarcodeScreen_page.dart';
import 'features/ManagerScreen/presentation/pages/ManagerScreen_page.dart';
import 'firebase_options.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'نظام جرد المخزون',
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF1565C0),
          brightness: Brightness.light,
        ),
        appBarTheme: const AppBarTheme(
          centerTitle: true,
          elevation: 0,
        ),
        cardTheme: CardThemeData(
          elevation: 2,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
        ),
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: Colors.grey[50],
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      ),
      home: LoginScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}

// ============= شاشة تسجيل الدخول =============
class LoginScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              const Color(0xFF1565C0),
              const Color(0xFF0D47A1),
            ],
          ),
        ),
        child: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    padding: const EdgeInsets.all(24),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(30),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.2),
                          blurRadius: 20,
                          offset: const Offset(0, 10),
                        ),
                      ],
                    ),
                    child: Icon(
                      Icons.inventory_2_rounded,
                      size: 80,
                      color: const Color(0xFF1565C0),
                    ),
                  ),
                  const SizedBox(height: 40),
                  const Text(
                    'نظام جرد المخزون',
                    style: TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    'اختر نوع الحساب للدخول',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.white.withOpacity(0.9),
                    ),
                  ),
                  const SizedBox(height: 60),
                  _buildRoleCard(
                    context: context,
                    title: 'دخول كعامل',
                    subtitle: 'إضافة وتعديل كميات المنتجات',
                    icon: Icons.person_outline,
                    color: Colors.white,
                    textColor: const Color(0xFF1565C0),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => EmployeeMainScreen(),
                        ),
                      );
                    },
                  ),
                  const SizedBox(height: 20),
                  _buildRoleCard(
                    context: context,
                    title: 'دخول كمدير',
                    subtitle: 'مراجعة وتأكيد عمليات الجرد',
                    icon: Icons.admin_panel_settings_outlined,
                    color: Colors.amber[700]!,
                    textColor: Colors.white,
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ManagerScreen(),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildRoleCard({
    required BuildContext context,
    required String title,
    required String subtitle,
    required IconData icon,
    required Color color,
    required Color textColor,
    required VoidCallback onTap,
  }) {
    return SizedBox(
      width: double.infinity,
      child: Material(
        color: color,
        borderRadius: BorderRadius.circular(20),
        elevation: 8,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(20),
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: textColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Icon(icon, size: 36, color: textColor),
                ),
                const SizedBox(width: 20),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: textColor,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        subtitle,
                        style: TextStyle(
                          fontSize: 14,
                          color: textColor.withOpacity(0.8),
                        ),
                      ),
                    ],
                  ),
                ),
                Icon(Icons.arrow_forward_ios, color: textColor, size: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// ============= الشاشة الرئيسية للعامل =============
class EmployeeMainScreen extends StatefulWidget {
  @override
  _EmployeeMainScreenState createState() => _EmployeeMainScreenState();
}

class _EmployeeMainScreenState extends State<EmployeeMainScreen> {
  int _currentIndex = 0;
  final PageController _pageController = PageController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView(
        controller: _pageController,
        onPageChanged: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        children: [
          EmployeeSearchScreen(),
          EmployeeBarcodeScreen(),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          _pageController.animateToPage(
            index,
            duration: const Duration(milliseconds: 200),
            curve: Curves.easeInOut,
          );
        },
        backgroundColor: Colors.white,
        selectedItemColor: const Color(0xFF1565C0),
        unselectedItemColor: Colors.grey[600],
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.search, size: 26),
            label: 'البحث',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.qr_code_scanner, size: 26),
            label: 'الباركود',
          ),
        ],
      ),
    );
  }
}

// ============= شاشة البحث للعامل =============
class EmployeeSearchScreen extends StatefulWidget {
  @override
  _EmployeeSearchScreenState createState() => _EmployeeSearchScreenState();
}

class _EmployeeSearchScreenState extends State<EmployeeSearchScreen> {
  final TextEditingController _searchController = TextEditingController();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  List<Map<String, dynamic>> searchResults = [];
  bool isLoading = false;
  String? errorMessage;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('البحث عن المنتجات'),
        backgroundColor: Theme.of(context).colorScheme.primary,
        foregroundColor: Colors.white,
      ),
      body: Column(
        children: [
          Container(
            margin: const EdgeInsets.all(16),
            child: Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: TextField(
                  controller: _searchController,
                  decoration: const InputDecoration(
                    labelText: 'ابحث عن المنتج',
                    hintText: 'اسم المنتج أو الباركود',
                    prefixIcon: Icon(Icons.search),
                  ),
                  onChanged: (value) {
                    if (value.length >= 2) {
                      _searchProducts(value);
                    } else if (value.isEmpty) {
                      setState(() {
                        searchResults.clear();
                        errorMessage = null;
                      });
                    }
                  },
                ),
              ),
            ),
          ),
          if (errorMessage != null)
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 16),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.red[50],
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                children: [
                  Icon(Icons.error_outline, color: Colors.red[700]),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      errorMessage!,
                      style: TextStyle(color: Colors.red[800]),
                    ),
                  ),
                ],
              ),
            ),
          if (isLoading)
            const Padding(
              padding: EdgeInsets.all(20),
              child: CircularProgressIndicator(),
            ),
          if (searchResults.isNotEmpty)
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: searchResults.length,
                itemBuilder: (context, index) {
                  return _buildProductCard(searchResults[index]);
                },
              ),
            ),
          if (searchResults.isEmpty && !isLoading && _searchController.text.isEmpty)
            Expanded(
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.search, size: 80, color: Colors.grey[300]),
                    const SizedBox(height: 16),
                    Text(
                      'ابدأ البحث عن المنتجات',
                      style: TextStyle(fontSize: 18, color: Colors.grey[600]),
                    ),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }

  Future<void> _searchProducts(String query) async {
    setState(() {
      isLoading = true;
      errorMessage = null;
    });

    try {
      final url = 'https://artawiya.com/stock_up_DB/api/v1/alrayan/smart_search2?q=${Uri.encodeComponent(query)}';
      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['status'] == 'success' && data['results'] != null) {
          setState(() {
            searchResults = List<Map<String, dynamic>>.from(data['results']);
            isLoading = false;
          });
        } else {
          setState(() {
            searchResults = [];
            errorMessage = 'لم يتم العثور على نتائج';
            isLoading = false;
          });
        }
      }
    } catch (e) {
      setState(() {
        errorMessage = 'تعذر الاتصال بالإنترنت';
        isLoading = false;
      });
    }
  }

  Widget _buildProductCard(Map<String, dynamic> product) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: InkWell(
        onTap: () => _showQuantityDialog(product),
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                product['product_name']?.toString() ?? 'غير محدد',
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('الكمية: ${product['total_quantity']} ${product['unit']}'),
                  Text('رقم الصنف: ${product['barcodes']}'),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showQuantityDialog(Map<String, dynamic> product) {
    final TextEditingController quantityController = TextEditingController();
    quantityController.text = product['total_quantity']?.toString() ?? '0';

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('تعديل الكمية'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(product['اسم الصنف']?.toString() ?? ''),
            const SizedBox(height: 16),
            TextField(
              controller: quantityController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: 'الكمية الجديدة',
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('إلغاء'),
          ),
          FilledButton(
            onPressed: () {
              _saveToFirebase(product, quantityController.text);
              Navigator.pop(context);
            },
            child: const Text('حفظ'),
          ),
        ],
      ),
    );
  }

  Future<void> _saveToFirebase(Map<String, dynamic> product, String newQuantity) async {
    try {
      final quantity = double.tryParse(newQuantity);
      if (quantity == null) {
        _showMessage('يرجى إدخال كمية صحيحة', isError: true);
        return;
      }


      await _firestore.collection('inventory_updates').add({
        'product_id': product['رقم الصنف'],
        'product_name': product['product_name'],
        'old_quantity': product['إجمالى الكمية'],
        'new_quantity': quantity,
        'unit': product['الوحدة'],
        'category': product['category'],
        'barcode': product['barcodes'],
        'status': 'pending',
        'timestamp': FieldValue.serverTimestamp(),
        'all_data': product,
      });

      _showMessage('تم حفظ التعديل بنجاح', isError: false);
    } catch (e) {
      _showMessage('فشل في حفظ البيانات: $e', isError: true);
    }
  }

  void _showMessage(String message, {required bool isError}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: isError ? Colors.red : Colors.green,
      ),
    );
  }
}

// ============= شاشة الباركود للعامل =============


// ============= شاشة المدير =============
