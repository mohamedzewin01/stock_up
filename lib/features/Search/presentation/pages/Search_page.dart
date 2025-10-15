// import 'dart:async';
//
// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:mobile_scanner/mobile_scanner.dart';
//
// import '../../../../core/di/di.dart';
// import '../../data/models/response/search_model.dart';
// import '../bloc/Search_cubit.dart';
//
// class SearchPage extends StatefulWidget {
//   const SearchPage({super.key});
//
//   @override
//   State<SearchPage> createState() => _SearchPageState();
// }
//
// class _SearchPageState extends State<SearchPage> {
//   late SearchCubit viewModel;
//   final TextEditingController _searchController = TextEditingController();
//   final ScrollController _scrollController = ScrollController();
//   Timer? _debounce;
//   int _currentPage = 1;
//   bool _isLoadingMore = false;
//   List<Results> _allResults = [];
//
//   @override
//   void initState() {
//     super.initState();
//     viewModel = getIt.get<SearchCubit>();
//     _searchController.addListener(_onSearchChanged);
//     _scrollController.addListener(_onScroll);
//   }
//
//   void _onSearchChanged() {
//     if (_debounce?.isActive ?? false) _debounce!.cancel();
//     _debounce = Timer(const Duration(milliseconds: 500), () {
//       if (_searchController.text.isNotEmpty) {
//         _currentPage = 1;
//         _allResults.clear();
//         viewModel.search(_searchController.text, _currentPage);
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
//     final state = viewModel.state;
//     if (state is SearchSuccess &&
//         state.searchEntity?.page != null &&
//         state.searchEntity?.totalPages != null &&
//         state.searchEntity!.page! < state.searchEntity!.totalPages!) {
//       setState(() {
//         _isLoadingMore = true;
//         _currentPage++;
//       });
//       viewModel.search(_searchController.text, _currentPage);
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
//             viewModel.search(barcode, _currentPage);
//           },
//         ),
//       ),
//     );
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
//     return BlocProvider.value(
//       value: viewModel,
//       child: GestureDetector(
//         onTap: () {
//           FocusScope.of(context).unfocus();
//         },
//         child: Scaffold(
//           appBar: AppBar(
//             title: const Text('البحث عن المنتجات'),
//             centerTitle: true,
//           ),
//           body: Column(
//             children: [
//               // Search Bar
//               Padding(
//                 padding: const EdgeInsets.all(16.0),
//                 child: Row(
//                   children: [
//                     Expanded(
//                       child: TextField(
//                         controller: _searchController,
//                         decoration: InputDecoration(
//                           hintText: 'ابحث عن منتج...',
//                           prefixIcon: const Icon(Icons.search),
//                           suffixIcon: _searchController.text.isNotEmpty
//                               ? IconButton(
//                                   icon: const Icon(Icons.clear),
//                                   onPressed: () {
//                                     _searchController.clear();
//                                     _allResults.clear();
//                                     setState(() {});
//                                   },
//                                 )
//                               : null,
//                           border: OutlineInputBorder(
//                             borderRadius: BorderRadius.circular(12),
//                           ),
//                           filled: true,
//                           fillColor: Colors.grey[100],
//                         ),
//                       ),
//                     ),
//                     const SizedBox(width: 8),
//                     Container(
//                       decoration: BoxDecoration(
//                         color: Theme.of(context).primaryColor,
//                         borderRadius: BorderRadius.circular(12),
//                       ),
//                       child: IconButton(
//                         icon: const Icon(
//                           Icons.qr_code_scanner,
//                           color: Colors.white,
//                         ),
//                         onPressed: _openBarcodeScanner,
//                         tooltip: 'مسح الباركود',
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//
//               // Results
//               Expanded(
//                 child: BlocConsumer<SearchCubit, SearchState>(
//                   listener: (context, state) {
//                     if (state is SearchSuccess) {
//                       setState(() {
//                         if (_currentPage == 1) {
//                           _allResults = state.searchEntity?.results ?? [];
//                         } else {
//                           _allResults.addAll(state.searchEntity?.results ?? []);
//                         }
//                         _isLoadingMore = false;
//                       });
//                     } else if (state is SearchFailure) {
//                       setState(() {
//                         _isLoadingMore = false;
//                       });
//                       ScaffoldMessenger.of(context).showSnackBar(
//                         SnackBar(
//                           content: Text('خطأ: ${state.exception.toString()}'),
//                         ),
//                       );
//                     }
//                   },
//                   builder: (context, state) {
//                     if (state is SearchLoading && _currentPage == 1) {
//                       return const Center(child: CircularProgressIndicator());
//                     }
//
//                     if (_allResults.isEmpty && _searchController.text.isEmpty) {
//                       return Center(
//                         child: Column(
//                           mainAxisAlignment: MainAxisAlignment.center,
//                           children: [
//                             Icon(
//                               Icons.search,
//                               size: 80,
//                               color: Colors.grey[400],
//                             ),
//                             const SizedBox(height: 16),
//                             Text(
//                               'ابدأ بالبحث عن المنتجات',
//                               style: TextStyle(
//                                 fontSize: 18,
//                                 color: Colors.grey[600],
//                               ),
//                             ),
//                           ],
//                         ),
//                       );
//                     }
//
//                     if (_allResults.isEmpty &&
//                         _searchController.text.isNotEmpty) {
//                       return Center(
//                         child: Column(
//                           mainAxisAlignment: MainAxisAlignment.center,
//                           children: [
//                             Icon(
//                               Icons.inventory_2_outlined,
//                               size: 80,
//                               color: Colors.grey[400],
//                             ),
//                             const SizedBox(height: 16),
//                             Text(
//                               'لا توجد نتائج',
//                               style: TextStyle(
//                                 fontSize: 18,
//                                 color: Colors.grey[600],
//                               ),
//                             ),
//                           ],
//                         ),
//                       );
//                     }
//
//                     return ListView.builder(
//                       controller: _scrollController,
//                       padding: const EdgeInsets.all(16),
//                       itemCount: _allResults.length + (_isLoadingMore ? 1 : 0),
//                       itemBuilder: (context, index) {
//                         if (index == _allResults.length) {
//                           return const Center(
//                             child: Padding(
//                               padding: EdgeInsets.all(16.0),
//                               child: CircularProgressIndicator(),
//                             ),
//                           );
//                         }
//
//                         final product = _allResults[index];
//                         return ProductCard(product: product);
//                       },
//                     );
//                   },
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
//
// class ProductCard extends StatelessWidget {
//   final Results product;
//
//   const ProductCard({super.key, required this.product});
//
//   @override
//   Widget build(BuildContext context) {
//     return Card(
//       margin: const EdgeInsets.only(bottom: 12),
//       elevation: 2,
//       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
//       child: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             // Product Name
//             Row(
//               children: [
//                 Expanded(
//                   child: Text(
//                     product.productName ?? 'بدون اسم',
//                     style: const TextStyle(
//                       fontSize: 18,
//                       fontWeight: FontWeight.bold,
//                     ),
//                   ),
//                 ),
//                 Container(
//                   padding: const EdgeInsets.symmetric(
//                     horizontal: 8,
//                     vertical: 4,
//                   ),
//                   decoration: BoxDecoration(
//                     color: Colors.blue[100],
//                     borderRadius: BorderRadius.circular(8),
//                   ),
//                   child: Text(
//                     '#${product.productNumber ?? ''}',
//                     style: TextStyle(
//                       color: Colors.blue[900],
//                       fontWeight: FontWeight.bold,
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//             const SizedBox(height: 12),
//
//             // Category
//             if (product.categoryName != null)
//               Row(
//                 children: [
//                   Icon(Icons.category, size: 18, color: Colors.grey[600]),
//                   const SizedBox(width: 8),
//                   Text(
//                     'الفئة: ${product.categoryName}',
//                     style: TextStyle(color: Colors.grey[700]),
//                   ),
//                 ],
//               ),
//             const SizedBox(height: 8),
//
//             // Quantity and Unit
//             Row(
//               children: [
//                 Icon(Icons.inventory, size: 18, color: Colors.grey[600]),
//                 const SizedBox(width: 8),
//                 Text(
//                   'الكمية: ${product.totalQuantity ?? '0'} ${product.unit ?? ''}',
//                   style: TextStyle(color: Colors.grey[700]),
//                 ),
//               ],
//             ),
//             const SizedBox(height: 8),
//
//             // Selling Price
//             Row(
//               children: [
//                 Icon(Icons.attach_money, size: 18, color: Colors.green[700]),
//                 const SizedBox(width: 8),
//                 Text(
//                   'سعر البيع: ${product.sellingPrice ?? '0'} ريال',
//                   style: TextStyle(
//                     color: Colors.green[700],
//                     fontWeight: FontWeight.bold,
//                     fontSize: 16,
//                   ),
//                 ),
//               ],
//             ),
//
//             // Barcodes
//             if (product.barcodes != null && product.barcodes!.isNotEmpty)
//               Padding(
//                 padding: const EdgeInsets.only(top: 12),
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     const Divider(),
//                     Row(
//                       children: [
//                         Icon(Icons.qr_code, size: 18, color: Colors.grey[600]),
//                         const SizedBox(width: 8),
//                         const Text(
//                           'الباركود:',
//                           style: TextStyle(fontWeight: FontWeight.w500),
//                         ),
//                       ],
//                     ),
//                     const SizedBox(height: 4),
//                     Wrap(
//                       spacing: 8,
//                       runSpacing: 8,
//                       children: product.barcodes!
//                           .map(
//                             (barcode) => Container(
//                               padding: const EdgeInsets.symmetric(
//                                 horizontal: 12,
//                                 vertical: 6,
//                               ),
//                               decoration: BoxDecoration(
//                                 color: Colors.grey[200],
//                                 borderRadius: BorderRadius.circular(6),
//                               ),
//                               child: Text(
//                                 barcode.toString(),
//                                 style: const TextStyle(
//                                   fontFamily: 'monospace',
//                                   fontSize: 12,
//                                 ),
//                               ),
//                             ),
//                           )
//                           .toList(),
//                     ),
//                   ],
//                 ),
//               ),
//           ],
//         ),
//       ),
//     );
//   }
// }
//
// class BarcodeScannerPage extends StatefulWidget {
//   final Function(String) onBarcodeDetected;
//
//   const BarcodeScannerPage({super.key, required this.onBarcodeDetected});
//
//   @override
//   State<BarcodeScannerPage> createState() => _BarcodeScannerPageState();
// }
//
// class _BarcodeScannerPageState extends State<BarcodeScannerPage> {
//   final MobileScannerController cameraController = MobileScannerController();
//   bool _isScanned = false;
//   bool _torchOn = false;
//
//   void _toggleTorch() async {
//     await cameraController.toggleTorch();
//     setState(() {
//       _torchOn = !_torchOn;
//     });
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('مسح الباركود'),
//         actions: [
//           IconButton(
//             icon: Icon(_torchOn ? Icons.flash_on : Icons.flash_off),
//             onPressed: _toggleTorch,
//           ),
//           IconButton(
//             icon: const Icon(Icons.flip_camera_ios),
//             onPressed: () => cameraController.switchCamera(),
//           ),
//         ],
//       ),
//       body: Stack(
//         children: [
//           MobileScanner(
//             controller: cameraController,
//             onDetect: (capture) {
//               if (!_isScanned) {
//                 final List<Barcode> barcodes = capture.barcodes;
//                 if (barcodes.isNotEmpty && barcodes.first.rawValue != null) {
//                   _isScanned = true;
//                   final String code = barcodes.first.rawValue!;
//                   widget.onBarcodeDetected(code);
//                   Navigator.pop(context);
//                 }
//               }
//             },
//           ),
//           // Overlay
//           Center(
//             child: Container(
//               width: 250,
//               height: 250,
//               decoration: BoxDecoration(
//                 border: Border.all(color: Colors.white, width: 3),
//                 borderRadius: BorderRadius.circular(12),
//               ),
//             ),
//           ),
//           Positioned(
//             bottom: 50,
//             left: 0,
//             right: 0,
//             child: Center(
//               child: Container(
//                 padding: const EdgeInsets.symmetric(
//                   horizontal: 24,
//                   vertical: 12,
//                 ),
//                 decoration: BoxDecoration(
//                   color: Colors.black54,
//                   borderRadius: BorderRadius.circular(24),
//                 ),
//                 child: const Text(
//                   'وجه الكاميرا نحو الباركود',
//                   style: TextStyle(color: Colors.white, fontSize: 16),
//                 ),
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
//     cameraController.dispose();
//     super.dispose();
//   }
// }
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

import '../../../../core/di/di.dart';
import '../../data/models/response/search_model.dart';
import '../bloc/Search_cubit.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  late SearchCubit viewModel;
  final TextEditingController _searchController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  Timer? _debounce;
  int _currentPage = 1;
  bool _isLoadingMore = false;
  List<Results> _allResults = [];

  @override
  void initState() {
    super.initState();
    viewModel = getIt.get<SearchCubit>();
    _searchController.addListener(_onSearchChanged);
    _scrollController.addListener(_onScroll);
  }

  void _onSearchChanged() {
    if (_debounce?.isActive ?? false) _debounce!.cancel();
    _debounce = Timer(const Duration(milliseconds: 2), () {
      if (_searchController.text.isNotEmpty) {
        _currentPage = 1;
        _allResults.clear();
        viewModel.search(_searchController.text, _currentPage);
      }
    });
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
            _scrollController.position.maxScrollExtent * 0.9 &&
        !_isLoadingMore) {
      _loadMoreResults();
    }
  }

  void _loadMoreResults() {
    final state = viewModel.state;
    if (state is SearchSuccess &&
        state.searchEntity?.page != null &&
        state.searchEntity?.totalPages != null &&
        state.searchEntity!.page! < state.searchEntity!.totalPages!) {
      setState(() {
        _isLoadingMore = true;
        _currentPage++;
      });
      viewModel.search(_searchController.text, _currentPage);
    }
  }

  void _openBarcodeScanner() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => BarcodeScannerPage(
          onBarcodeDetected: (String barcode) {
            _searchController.text = barcode;
            _currentPage = 1;
            _allResults.clear();
            viewModel.search(barcode, _currentPage);
          },
        ),
      ),
    );
  }

  @override
  void dispose() {
    _searchController.dispose();
    _scrollController.dispose();
    _debounce?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: viewModel,
      child: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: Scaffold(
          backgroundColor: Colors.grey[50],
          appBar: AppBar(
            elevation: 0,
            backgroundColor: Colors.white,
            title: const Text(
              'البحث عن المنتجات',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
            centerTitle: true,
          ),
          body: Column(
            children: [
              // Modern Search Bar
              Container(
                color: Colors.white,
                padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
                child: Row(
                  children: [
                    Expanded(
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.grey[100],
                          borderRadius: BorderRadius.circular(14),
                          border: Border.all(
                            color: Colors.grey[300]!,
                            width: 1,
                          ),
                        ),
                        child: TextField(
                          controller: _searchController,
                          style: const TextStyle(fontSize: 15),
                          decoration: InputDecoration(
                            hintText: 'ابحث عن منتج...',
                            hintStyle: TextStyle(color: Colors.grey[500]),
                            prefixIcon: Icon(
                              Icons.search,
                              color: Colors.grey[600],
                              size: 22,
                            ),
                            suffixIcon: _searchController.text.isNotEmpty
                                ? IconButton(
                                    icon: Icon(
                                      Icons.clear,
                                      size: 20,
                                      color: Colors.grey[600],
                                    ),
                                    onPressed: () {
                                      _searchController.clear();
                                      _allResults.clear();
                                      setState(() {});
                                    },
                                  )
                                : null,
                            border: InputBorder.none,
                            contentPadding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 14,
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            Theme.of(context).primaryColor,
                            Theme.of(context).primaryColor.withOpacity(0.8),
                          ],
                        ),
                        borderRadius: BorderRadius.circular(14),
                        boxShadow: [
                          BoxShadow(
                            color: Theme.of(
                              context,
                            ).primaryColor.withOpacity(0.3),
                            blurRadius: 8,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Material(
                        color: Colors.transparent,
                        child: InkWell(
                          borderRadius: BorderRadius.circular(14),
                          onTap: _openBarcodeScanner,
                          child: Container(
                            padding: const EdgeInsets.all(12),
                            child: const Icon(
                              Icons.qr_code_scanner,
                              color: Colors.white,
                              size: 24,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              // Results Count Badge
              BlocBuilder<SearchCubit, SearchState>(
                builder: (context, state) {
                  if (_allResults.isNotEmpty) {
                    return Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 8,
                      ),
                      color: Colors.blue[50],
                      child: Row(
                        children: [
                          Icon(
                            Icons.check_circle,
                            size: 16,
                            color: Colors.blue[700],
                          ),
                          const SizedBox(width: 8),
                          Text(
                            'تم العثور على ${_allResults.length} منتج',
                            style: TextStyle(
                              color: Colors.blue[900],
                              fontWeight: FontWeight.w600,
                              fontSize: 13,
                            ),
                          ),
                        ],
                      ),
                    );
                  }
                  return const SizedBox.shrink();
                },
              ),

              // Results
              Expanded(
                child: BlocConsumer<SearchCubit, SearchState>(
                  listener: (context, state) {
                    if (state is SearchSuccess) {
                      setState(() {
                        if (_currentPage == 1) {
                          _allResults = state.searchEntity?.results ?? [];
                        } else {
                          _allResults.addAll(state.searchEntity?.results ?? []);
                        }
                        _isLoadingMore = false;
                      });
                    } else if (state is SearchFailure) {
                      setState(() {
                        _isLoadingMore = false;
                      });
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('خطأ: ${state.exception.toString()}'),
                          backgroundColor: Colors.red[700],
                          behavior: SnackBarBehavior.floating,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                      );
                    }
                  },
                  builder: (context, state) {
                    if (state is SearchLoading && _currentPage == 1) {
                      return Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            CircularProgressIndicator(
                              color: Theme.of(context).primaryColor,
                            ),
                            const SizedBox(height: 16),
                            Text(
                              'جاري البحث...',
                              style: TextStyle(
                                color: Colors.grey[600],
                                fontSize: 14,
                              ),
                            ),
                          ],
                        ),
                      );
                    }

                    if (_allResults.isEmpty && _searchController.text.isEmpty) {
                      return Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                              padding: const EdgeInsets.all(24),
                              decoration: BoxDecoration(
                                color: Colors.blue[50],
                                shape: BoxShape.circle,
                              ),
                              child: Icon(
                                Icons.search,
                                size: 64,
                                color: Colors.blue[300],
                              ),
                            ),
                            const SizedBox(height: 20),
                            Text(
                              'ابدأ بالبحث عن المنتجات',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w600,
                                color: Colors.grey[700],
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              'استخدم شريط البحث أو مسح الباركود',
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.grey[500],
                              ),
                            ),
                          ],
                        ),
                      );
                    }

                    if (_allResults.isEmpty &&
                        _searchController.text.isNotEmpty) {
                      return Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                              padding: const EdgeInsets.all(24),
                              decoration: BoxDecoration(
                                color: Colors.orange[50],
                                shape: BoxShape.circle,
                              ),
                              child: Icon(
                                Icons.inventory_2_outlined,
                                size: 64,
                                color: Colors.orange[300],
                              ),
                            ),
                            const SizedBox(height: 20),
                            Text(
                              'لا توجد نتائج',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w600,
                                color: Colors.grey[700],
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              'جرب البحث بكلمات مختلفة',
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.grey[500],
                              ),
                            ),
                          ],
                        ),
                      );
                    }

                    return ListView.builder(
                      controller: _scrollController,
                      padding: const EdgeInsets.all(12),
                      itemCount: _allResults.length + (_isLoadingMore ? 1 : 0),
                      itemBuilder: (context, index) {
                        if (index == _allResults.length) {
                          return Container(
                            padding: const EdgeInsets.all(16),
                            alignment: Alignment.center,
                            child: CircularProgressIndicator(
                              color: Theme.of(context).primaryColor,
                            ),
                          );
                        }

                        final product = _allResults[index];
                        return ProductCard(product: product);
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class ProductCard extends StatelessWidget {
  final Results product;

  const ProductCard({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: Colors.grey[200]!, width: 1),
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: () {
          // يمكن إضافة انتقال لصفحة التفاصيل هنا
        },
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Product Name & Number Row
              Row(
                children: [
                  Expanded(
                    child: Text(
                      product.productName ?? 'بدون اسم',
                      style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                        height: 1.3,
                        color: Colors.black87,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.blue[50],
                      borderRadius: BorderRadius.circular(6),
                      border: Border.all(color: Colors.blue[200]!, width: 1),
                    ),
                    child: Text(
                      '#${product.productNumber ?? ''}',
                      style: TextStyle(
                        color: Colors.blue[800],
                        fontWeight: FontWeight.w600,
                        fontSize: 11,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),

              // Compact Info Grid
              Row(
                children: [
                  // Category
                  if (product.categoryName != null)
                    Expanded(
                      child: _InfoChip(
                        icon: Icons.category_outlined,
                        text: product.categoryName!,
                        color: Colors.orange,
                      ),
                    ),
                  if (product.categoryName != null) const SizedBox(width: 8),

                  // Quantity
                  Expanded(
                    child: _InfoChip(
                      icon: Icons.inventory_2_outlined,
                      text:
                          '${product.totalQuantity ?? '0'} ${product.unit ?? ''}',
                      color: Colors.purple,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),

              // Price & Barcode Row
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Price
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.green[50],
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: Colors.green[200]!, width: 1),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.payments_outlined,
                          size: 16,
                          color: Colors.green[700],
                        ),
                        const SizedBox(width: 4),
                        Text(
                          '${product.sellingPrice ?? '0'} ر.س',
                          style: TextStyle(
                            color: Colors.green[800],
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                  ),

                  // Barcode Count
                  if (product.barcodes != null && product.barcodes!.isNotEmpty)
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.grey[100],
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: Colors.grey[300]!, width: 1),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.qr_code_2,
                            size: 14,
                            color: Colors.grey[700],
                          ),
                          const SizedBox(width: 4),
                          Text(
                            '${product.barcodes!.length}',
                            style: TextStyle(
                              color: Colors.grey[700],
                              fontWeight: FontWeight.w600,
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                    ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// Widget مساعد للمعلومات المدمجة
class _InfoChip extends StatelessWidget {
  final IconData icon;
  final String text;
  final MaterialColor color;

  const _InfoChip({
    required this.icon,
    required this.text,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
      decoration: BoxDecoration(
        color: color[50],
        borderRadius: BorderRadius.circular(6),
        border: Border.all(color: color[200]!, width: 1),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: color[700]),
          const SizedBox(width: 4),
          Flexible(
            child: Text(
              text,
              style: TextStyle(
                color: color[900],
                fontSize: 12,
                fontWeight: FontWeight.w500,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }
}

class BarcodeScannerPage extends StatefulWidget {
  final Function(String) onBarcodeDetected;

  const BarcodeScannerPage({super.key, required this.onBarcodeDetected});

  @override
  State<BarcodeScannerPage> createState() => _BarcodeScannerPageState();
}

class _BarcodeScannerPageState extends State<BarcodeScannerPage> {
  /// 🔹 تهيئة الكنترولر مع إعداد سرعة المسح
  final MobileScannerController cameraController = MobileScannerController(
    detectionSpeed: DetectionSpeed.noDuplicates,
  );

  bool _isScanned = false;
  bool _torchOn = false;

  void _toggleTorch() async {
    await cameraController.toggleTorch();
    setState(() {
      _torchOn = !_torchOn;
    });
  }

  @override
  Widget build(BuildContext context) {
    final double boxHeight = 220; // الطول
    final double boxWidth = MediaQuery.of(context).size.width * 0.95; // العرض

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'مسح الباركود',
          style: TextStyle(color: Colors.white),
        ),
        actions: [
          IconButton(
            icon: Icon(
              _torchOn ? Icons.flash_on : Icons.flash_off,
              color: _torchOn ? Colors.yellow : Colors.white,
            ),
            onPressed: _toggleTorch,
          ),
          IconButton(
            icon: const Icon(Icons.flip_camera_ios, color: Colors.white),
            onPressed: () => cameraController.switchCamera(),
          ),
        ],
      ),
      body: Stack(
        children: [
          /// 👁️ عرض الكاميرا
          MobileScanner(
            controller: cameraController,
            onDetect: (capture) {
              if (!_isScanned) {
                final barcodes = capture.barcodes;
                if (barcodes.isNotEmpty && barcodes.first.rawValue != null) {
                  _isScanned = true;
                  cameraController.stop(); // إيقاف الكاميرا بعد أول قراءة
                  final code = barcodes.first.rawValue!;
                  widget.onBarcodeDetected(code);
                  Navigator.pop(context);
                }
              }
            },
          ),

          /// 🌓 طبقة التعتيم مع الفتحة الشفافة
          LayoutBuilder(
            builder: (context, constraints) {
              final width = constraints.maxWidth;
              final height = constraints.maxHeight;

              return ClipPath(
                clipper: HoleClipper(
                  rect: Rect.fromCenter(
                    center: Offset(width / 2, height / 2),
                    width: boxWidth,
                    height: boxHeight,
                  ),
                ),
                child: Container(color: Colors.black54),
              );
            },
          ),

          /// 🔲 حدود المستطيل
          Center(
            child: Container(
              width: boxWidth,
              height: boxHeight,
              decoration: BoxDecoration(
                border: Border.all(color: Colors.white, width: 3),
                borderRadius: BorderRadius.circular(16),
              ),
            ),
          ),

          /// 📜 النص في الأسفل
          Positioned(
            bottom: 80,
            left: 0,
            right: 0,
            child: Center(
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 14,
                ),
                decoration: BoxDecoration(
                  color: Colors.black87,
                  borderRadius: BorderRadius.circular(30),
                  border: Border.all(color: Colors.white30, width: 1),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.qr_code_scanner,
                      color: Colors.blue[300],
                      size: 20,
                    ),
                    const SizedBox(width: 8),
                    const Text(
                      'وجه الكاميرا نحو الباركود',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 15,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    cameraController.dispose();
    super.dispose();
  }
}

/// 🔹 كلاس لقص الفتحة المستطيلة وسط الشاشة
class HoleClipper extends CustomClipper<Path> {
  final Rect rect;

  HoleClipper({required this.rect});

  @override
  Path getClip(Size size) {
    final path = Path()..addRect(Rect.fromLTWH(0, 0, size.width, size.height));
    path.addRRect(RRect.fromRectAndRadius(rect, const Radius.circular(16)));
    path.fillType = PathFillType.evenOdd; // الجزء داخل المستطيل يصبح شفاف
    return path;
  }

  @override
  bool shouldReclip(HoleClipper oldClipper) => oldClipper.rect != rect;
}
