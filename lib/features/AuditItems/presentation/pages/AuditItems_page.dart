import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:stock_up/core/utils/cashed_data_shared_preferences.dart';
import 'package:stock_up/features/AuditItems/presentation/widgets/products_list_section.dart';
import 'package:stock_up/features/AuditItems/presentation/widgets/search_bar.dart';

import '../../../../core/di/di.dart';
import '../../data/models/response/search_products_model.dart';
import '../bloc/AuditItems_cubit.dart';
import '../bloc/SearchProducts/search_products_cubit.dart';
import '../widgets/camera_section.dart';
import '../widgets/modern_quantity_sheet.dart';

class SearchProductsPage extends StatefulWidget {
  const SearchProductsPage({super.key});

  @override
  State<SearchProductsPage> createState() => _SearchProductsPageState();
}

class _SearchProductsPageState extends State<SearchProductsPage> {
  late SearchProductsCubit searchViewModel;
  late AuditItemsCubit auditViewModel;

  final TextEditingController searchController = TextEditingController();
  final ScrollController scrollController = ScrollController();
  final MobileScannerController cameraController = MobileScannerController(
    detectionSpeed: DetectionSpeed.noDuplicates, // منع المسح المتكرر
    facing: CameraFacing.back,
    torchEnabled: false,
  );

  final FirebaseFirestore firebaseRef = FirebaseFirestore.instance;

  List<Results> allProducts = [];
  int currentPage = 1;
  bool isLoadingMore = false;
  bool hasMoreData = true;
  String? lastSearchQuery;
  bool isCameraExpanded = false;
  bool isCameraActive = true;
  bool isFlashOn = false;

  @override
  void initState() {
    super.initState();
    searchViewModel = getIt.get<SearchProductsCubit>();
    auditViewModel = getIt.get<AuditItemsCubit>();

    scrollController.addListener(_onScroll);
    searchController.addListener(_onSearchChanged);
  }

  @override
  void dispose() {
    searchController.dispose();
    scrollController.dispose();
    cameraController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (scrollController.position.pixels >=
        scrollController.position.maxScrollExtent * 0.8) {
      if (!isLoadingMore && hasMoreData) {
        _loadMoreProducts();
      }
    }
  }

  void _onSearchChanged() {
    final query = searchController.text.trim();

    // البحث فقط إذا كان النص 3 حروف أو أكثر، أو فارغ لإعادة التعيين
    if (query != lastSearchQuery) {
      if (query.isEmpty || query.length >= 3) {
        setState(() {
          currentPage = 1;
          allProducts.clear();
          hasMoreData = true;
        });
        _searchProducts(query);
      }
    }
  }

  void _searchProducts(String query) {
    lastSearchQuery = query;
    if (query.isEmpty || query.length >= 3) {
      searchViewModel.search(query.isEmpty ? null : query, currentPage);
    }
  }

  void _loadMoreProducts() {
    if (!isLoadingMore && hasMoreData && lastSearchQuery != null) {
      setState(() {
        isLoadingMore = true;
        currentPage++;
      });
      searchViewModel.search(lastSearchQuery, currentPage);
    }
  }

  void _onBarcodeDetected(BarcodeCapture capture) {
    final String? barcode = capture.barcodes.firstOrNull?.rawValue;
    if (barcode != null && barcode.isNotEmpty) {
      HapticFeedback.mediumImpact();
      searchController.text = barcode;
      _searchProducts(barcode);
      setState(() => isCameraExpanded = false);
    }
  }

  // void _toggleCamera() {
  //   setState(() {
  //     isCameraActive = !isCameraActive;
  //     if (!isCameraActive) {
  //       cameraController.stop();
  //       isFlashOn = false;
  //     } else {
  //       cameraController.start();
  //     }
  //   });
  // }
  void _toggleCamera() async {
    setState(() {
      isCameraActive = !isCameraActive;
    });

    if (!isCameraActive) {
      await cameraController.stop(); // انتظار إيقاف الكاميرا
    } else {
      await cameraController.start(); // انتظار تشغيل الكاميرا
    }
  }

  void _toggleFlash() {
    setState(() {
      isFlashOn = !isFlashOn;
      cameraController.toggleTorch();
    });
  }

  void _clearSearch() {
    searchController.clear();
    setState(() {
      allProducts.clear();
      currentPage = 1;
      hasMoreData = true;
      lastSearchQuery = null;
    });
  }

  Future<void> _sendToFirebase(
    Results product,
    int quantity,
    String? notes,
  ) async {
    try {
      await firebaseRef.collection('inventory_audit').add({
        'audit_id': CacheService.getData(key: CacheKeys.auditId),
        'userName': CacheService.getData(key: CacheKeys.userName),
        'status': 'pending',
        'product_id': product.productId,
        'product_name': product.productName,
        'product_number': product.productNumber,
        'quantity': quantity,
        'notes': notes,
        'unit': product.unit,
        'selling_price': product.sellingPrice,
        'category_name': product.categoryName,
        'total_quantity': product.totalQuantity,
        'barcodes': product.barcodes,
        'timestamp': FieldValue.serverTimestamp(),
        'created_at': DateTime.now().toIso8601String(),
      });
    } catch (e) {
      debugPrint('Error sending to Firebase: $e');
      rethrow;
    }
  }

  void _showQuantityDialog(Results product) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => ModernQuantitySheet(
        product: product,
        onConfirm: (quantity, notes) async {
          try {
            auditViewModel.addInventoryAuditItems(
              productId: product.productId!,
              quantity: quantity,
              notes: notes,
            );

            await _sendToFirebase(product, quantity, notes);

            if (context.mounted) {
              Navigator.pop(context);

              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: const Row(
                    children: [
                      Icon(Icons.check_circle, color: Colors.white),
                      SizedBox(width: 12),
                      Expanded(child: Text('تم إضافة المنتج وحفظه بنجاح')),
                    ],
                  ),
                  backgroundColor: Colors.green.shade600,
                  behavior: SnackBarBehavior.floating,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              );

              _clearSearch();
            }
          } catch (e) {
            if (context.mounted) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Row(
                    children: [
                      const Icon(Icons.error, color: Colors.white),
                      const SizedBox(width: 12),
                      Expanded(child: Text('خطأ: ${e.toString()}')),
                    ],
                  ),
                  backgroundColor: Colors.red.shade600,
                  behavior: SnackBarBehavior.floating,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              );
            }
          }
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider.value(value: searchViewModel),
        BlocProvider.value(value: auditViewModel),
      ],
      child: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: SafeArea(
          child: Scaffold(
            backgroundColor: Colors.grey.shade50,
            body: CustomScrollView(
              controller: scrollController,
              slivers: [
                // Camera Section
                SliverToBoxAdapter(
                  child: CameraSection(
                    cameraController: cameraController,
                    isCameraExpanded: isCameraExpanded,
                    isCameraActive: isCameraActive,
                    isFlashOn: isFlashOn,
                    onBarcodeDetected: _onBarcodeDetected,
                    onToggleCamera: _toggleCamera,
                    onToggleFlash: _toggleFlash,
                    onToggleExpand: () {
                      setState(() {
                        isCameraExpanded = !isCameraExpanded;
                      });
                    },
                  ),
                ),

                // Search Bar
                SliverToBoxAdapter(
                  child: SearchBarWidget(
                    controller: searchController,
                    onClear: _clearSearch,
                  ),
                ),

                const SliverToBoxAdapter(child: SizedBox(height: 16)),

                // Products List
                ProductsListSection(
                  allProducts: allProducts,
                  isLoadingMore: isLoadingMore,
                  currentPage: currentPage,
                  searchController: searchController,
                  onProductTap: _showQuantityDialog,
                  onStateChanged: (products, loadingMore, hasMore) {
                    setState(() {
                      allProducts = products;
                      isLoadingMore = loadingMore;
                      hasMoreData = hasMore;
                    });
                  },
                ),

                const SliverToBoxAdapter(child: SizedBox(height: 80)),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
