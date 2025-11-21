import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:stock_up/core/di/di.dart';
import 'package:stock_up/features/AuditItems/data/models/response/search_products_model.dart';
import 'package:stock_up/features/AuditItems/presentation/bloc/SearchProducts/search_products_cubit.dart';
import 'package:stock_up/features/AuditItems/presentation/widgets/camera_section.dart';
import 'package:stock_up/features/AuditItems/presentation/widgets/search_bar.dart';
import 'package:stock_up/features/Barcodes/presentation/bloc/Barcodes_cubit.dart';
import 'package:stock_up/features/Barcodes/presentation/widgets/add_barcode_sheet.dart';
import 'package:stock_up/features/Barcodes/presentation/widgets/barcode_product_card.dart';
import 'package:stock_up/features/Barcodes/presentation/widgets/delete_barcode_sheet.dart';

class BarcodesPage extends StatefulWidget {
  const BarcodesPage({super.key});

  @override
  State<BarcodesPage> createState() => _BarcodesPageState();
}

class _BarcodesPageState extends State<BarcodesPage> {
  late SearchProductsCubit searchViewModel;
  late BarcodesCubit barcodeCubit;

  final TextEditingController searchController = TextEditingController();
  final ScrollController scrollController = ScrollController();
  final MobileScannerController cameraController = MobileScannerController(
    detectionSpeed: DetectionSpeed.noDuplicates,
    facing: CameraFacing.back,
    torchEnabled: false,
  );

  List<Results> allProducts = [];
  int currentPage = 1;
  bool isLoadingMore = false;
  bool hasMoreData = true;
  String? lastSearchQuery;
  bool isCameraExpanded = false;
  bool isCameraActive = false;
  bool isFlashOn = false;

  @override
  void initState() {
    super.initState();
    searchViewModel = getIt.get<SearchProductsCubit>();
    barcodeCubit = getIt.get<BarcodesCubit>();

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

  void _toggleCamera() async {
    setState(() {
      isCameraActive = !isCameraActive;
    });

    if (!isCameraActive) {
      await cameraController.stop();
    } else {
      await cameraController.start();
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

  void _showAddBarcodeSheet(Results product) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => AddBarcodeSheet(
        product: product,
        onConfirm: (barcode, barcodeType, unitQuantity, unitPrice) async {
          // إظهار مؤشر التحميل
          if (context.mounted) {
            showDialog(
              context: context,
              barrierDismissible: false,
              builder: (ctx) =>
                  const Center(child: CircularProgressIndicator()),
            );
          }

          try {
            await barcodeCubit.addBarcode(
              productId: product.productId!,
              barcode: barcode,
              barcodeType: barcodeType,
              unitQuantity: unitQuantity,
              unitPrice: unitPrice,
            );

            // ⏳ ننتظر استجابة
            await Future.delayed(const Duration(milliseconds: 500));

            if (context.mounted) {
              // إغلاق مؤشر التحميل
              Navigator.pop(context);
              // إغلاق الـ bottom sheet
              Navigator.pop(context);

              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: const Row(
                    children: [
                      Icon(Icons.check_circle, color: Colors.white),
                      SizedBox(width: 12),
                      Expanded(child: Text('تم إضافة الباركود بنجاح')),
                    ],
                  ),
                  backgroundColor: Colors.green.shade600,
                  behavior: SnackBarBehavior.floating,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              );

              // إعادة البحث لتحديث النتائج
              _clearSearch();
              if (lastSearchQuery != null && lastSearchQuery!.isNotEmpty) {
                _searchProducts(lastSearchQuery!);
              }
            }
          } catch (e) {
            if (context.mounted) {
              Navigator.pop(context); // إغلاق مؤشر التحميل

              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Row(
                    children: [
                      const Icon(Icons.error, color: Colors.white),
                      const SizedBox(width: 12),
                      Expanded(child: Text('خطأ في الإضافة: ${e.toString()}')),
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

  void _showDeleteBarcodeSheet(Results product) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => DeleteBarcodeSheet(
        product: product,
        onConfirm: (barcode) async {
          // إظهار مؤشر التحميل
          if (context.mounted) {
            showDialog(
              context: context,
              barrierDismissible: false,
              builder: (ctx) =>
                  const Center(child: CircularProgressIndicator()),
            );
          }

          try {
            await barcodeCubit.deleteBarcode(
              productId: product.productId!,
              barcode: barcode,
            );

            // ⏳ ننتظر استجابة
            await Future.delayed(const Duration(milliseconds: 500));

            if (context.mounted) {
              // إغلاق مؤشر التحميل
              Navigator.pop(context);
              // إغلاق الـ bottom sheet
              Navigator.pop(context);

              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: const Row(
                    children: [
                      Icon(Icons.check_circle, color: Colors.white),
                      SizedBox(width: 12),
                      Expanded(child: Text('تم حذف الباركود بنجاح')),
                    ],
                  ),
                  backgroundColor: Colors.green.shade600,
                  behavior: SnackBarBehavior.floating,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              );

              // إعادة البحث لتحديث النتائج
              _clearSearch();
              if (lastSearchQuery != null && lastSearchQuery!.isNotEmpty) {
                _searchProducts(lastSearchQuery!);
              }
            }
          } catch (e) {
            if (context.mounted) {
              Navigator.pop(context); // إغلاق مؤشر التحميل

              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Row(
                    children: [
                      const Icon(Icons.error, color: Colors.white),
                      const SizedBox(width: 12),
                      Expanded(child: Text('خطأ في الحذف: ${e.toString()}')),
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
        BlocProvider.value(value: barcodeCubit),
      ],
      child: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: SafeArea(
          child: Scaffold(
            backgroundColor: Colors.grey.shade50,
            appBar: AppBar(
              title: const Text(
                'إدارة الباركودات',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
              ),
              centerTitle: true,
              elevation: 0,
              backgroundColor: Colors.purple.shade700,
              foregroundColor: Colors.white,
            ),
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
                _buildProductsList(),

                const SliverToBoxAdapter(child: SizedBox(height: 80)),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildProductsList() {
    return BlocConsumer<SearchProductsCubit, SearchProductsState>(
      listener: (context, state) {
        if (state is SearchProductsSuccess) {
          List<Results> updatedProducts = allProducts;
          if (currentPage == 1) {
            updatedProducts = state.searchProductsEntity?.results ?? [];
          } else {
            updatedProducts = [
              ...allProducts,
              ...(state.searchProductsEntity?.results ?? []),
            ];
          }

          final hasMore =
              (state.searchProductsEntity?.results?.length ?? 0) >= 10;
          setState(() {
            allProducts = updatedProducts;
            isLoadingMore = false;
            hasMoreData = hasMore;
          });
        } else if (state is SearchProductsFailure) {
          setState(() {
            isLoadingMore = false;
          });
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: const Row(
                children: [
                  Icon(Icons.error, color: Colors.white),
                  SizedBox(width: 12),
                  Text('حدث خطأ أثناء البحث'),
                ],
              ),
              backgroundColor: Colors.red.shade600,
              behavior: SnackBarBehavior.floating,
            ),
          );
        }
      },
      builder: (context, state) {
        if (state is SearchProductsLoading && currentPage == 1) {
          return const SliverFillRemaining(
            child: Center(child: CircularProgressIndicator()),
          );
        }

        if (searchController.text.isNotEmpty &&
            searchController.text.length < 3) {
          return SliverFillRemaining(
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.edit_outlined,
                    size: 80,
                    color: Colors.grey.shade400,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'أدخل 3 حروف على الأقل للبحث',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.grey.shade600,
                    ),
                  ),
                ],
              ),
            ),
          );
        }

        if (allProducts.isEmpty) {
          return SliverFillRemaining(
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.qr_code_scanner,
                    size: 80,
                    color: Colors.grey.shade400,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'لا توجد منتجات',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.grey.shade600,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'ابدأ البحث أو امسح الباركود',
                    style: TextStyle(fontSize: 16, color: Colors.grey.shade500),
                  ),
                ],
              ),
            ),
          );
        }

        return SliverPadding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          sliver: SliverList(
            delegate: SliverChildBuilderDelegate((context, index) {
              if (index == allProducts.length) {
                return Container(
                  padding: const EdgeInsets.all(16),
                  child: const Center(child: CircularProgressIndicator()),
                );
              }

              final product = allProducts[index];
              return BarcodeProductCard(
                product: product,
                onAddBarcode: () => _showAddBarcodeSheet(product),
                onDeleteBarcode: () => _showDeleteBarcodeSheet(product),
              );
            }, childCount: allProducts.length + (isLoadingMore ? 1 : 0)),
          ),
        );
      },
    );
  }
}
