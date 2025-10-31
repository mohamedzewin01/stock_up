import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:stock_up/core/utils/cashed_data_shared_preferences.dart';
import 'package:stock_up/features/AuditItems/presentation/widgets/add_new_product_sheet.dart';
import 'package:stock_up/features/AuditItems/presentation/widgets/products_list_section.dart';
import 'package:stock_up/features/AuditItems/presentation/widgets/search_bar.dart';

import '../../../../core/di/di.dart';
import '../../data/models/response/search_products_model.dart';
import '../bloc/AuditItems_cubit.dart';
import '../bloc/SearchProducts/search_products_cubit.dart';
import '../bloc/search_audit_user/search_audit_user_cubit.dart';
import '../widgets/camera_section.dart';
import '../widgets/modern_quantity_sheet.dart';

class SearchProductsPage extends StatefulWidget {
  const SearchProductsPage({super.key});

  @override
  State<SearchProductsPage> createState() => _SearchProductsPageState();
}

class _SearchProductsPageState extends State<SearchProductsPage> {
  String? scannedBarcode; // لحفظ الباركود المسوح
  bool isSearchingByBarcode = false;
  late SearchProductsCubit searchViewModel;
  late AuditItemsCubit auditViewModel;
  late SearchAuditUserCubit searchAuditUserCubit;

  final TextEditingController searchController = TextEditingController();
  final ScrollController scrollController = ScrollController();
  final MobileScannerController cameraController = MobileScannerController(
    detectionSpeed: DetectionSpeed.noDuplicates,
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
  bool isCameraActive = false;
  bool isFlashOn = false;
  int? auditId; // لحفظ audit_id من الاستجابة
  bool isAuditValid = false; // للتحقق من صلاحية الجرد

  @override
  void initState() {
    super.initState();
    searchViewModel = getIt.get<SearchProductsCubit>();
    auditViewModel = getIt.get<AuditItemsCubit>();
    searchAuditUserCubit = getIt.get<SearchAuditUserCubit>();

    scrollController.addListener(_onScroll);
    searchController.addListener(_onSearchChanged);

    // التحقق من حالة الجرد عند بدء الصفحة
    WidgetsBinding.instance.addPostFrameCallback((_) {
      searchAuditUserCubit.searchAuditUser();
    });
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
      // إذا كان المستخدم يكتب يدوياً، نلغي حالة البحث بالباركود
      if (!isSearchingByBarcode) {
        setState(() {
          scannedBarcode = null;
        });
      }

      if (query.isEmpty || query.length >= 3) {
        setState(() {
          currentPage = 1;
          allProducts.clear();
          hasMoreData = true;

          // إذا تم حذف النص، نعيد تعيين حالة الباركود
          if (query.isEmpty) {
            scannedBarcode = null;
            isSearchingByBarcode = false;
          }
        });
        _searchProducts(query);
      }
    }
  }

  // void _onSearchChanged() {
  //   final query = searchController.text.trim();
  //
  //   if (query != lastSearchQuery) {
  //     if (query.isEmpty || query.length >= 3) {
  //       setState(() {
  //         currentPage = 1;
  //         allProducts.clear();
  //         hasMoreData = true;
  //       });
  //       _searchProducts(query);
  //     }
  //   }
  // }
  void _searchProducts(String query) {
    lastSearchQuery = query;

    // تحديد إذا كان البحث بالباركود
    setState(() {
      isSearchingByBarcode = scannedBarcode != null && query == scannedBarcode;
    });

    if (query.isEmpty || query.length >= 3) {
      searchViewModel.search(query.isEmpty ? null : query, currentPage);
    }
  }

  // void _searchProducts(String query) {
  //   lastSearchQuery = query;
  //   if (query.isEmpty || query.length >= 3) {
  //     searchViewModel.search(query.isEmpty ? null : query, currentPage);
  //   }
  // }

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

      // حفظ الباركود وتحديد أن البحث بالباركود
      setState(() {
        scannedBarcode = barcode;
        isSearchingByBarcode = true;
      });

      _searchProducts(barcode);
      setState(() => isCameraExpanded = false);
    }
  }

  // void _onBarcodeDetected(BarcodeCapture capture) {
  //   final String? barcode = capture.barcodes.firstOrNull?.rawValue;
  //   if (barcode != null && barcode.isNotEmpty) {
  //     HapticFeedback.mediumImpact();
  //     searchController.text = barcode;
  //     _searchProducts(barcode);
  //     setState(() => isCameraExpanded = false);
  //   }
  // }

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
      currentPage = 0;
      hasMoreData = true;
      lastSearchQuery = null;
      scannedBarcode = null; // إعادة تعيين الباركود
      isSearchingByBarcode = false;
    });
  }

  // void _clearSearch() {
  //   searchController.clear();
  //   setState(() {
  //     allProducts.clear();
  //     currentPage = 1;
  //     hasMoreData = true;
  //     lastSearchQuery = null;
  //   });
  // }
  Future<void> _saveNewProductToFirebase(
    String barcode,
    String productName,
    int quantity,
    double price,
    String? notes,
  ) async {
    try {
      // إظهار مؤشر التحميل
      if (context.mounted) {
        showDialog(
          context: context,
          barrierDismissible: false,
          builder: (ctx) => const Center(child: CircularProgressIndicator()),
        );
      }

      // إنشاء مرجع للمستند الجديد
      final docRef = firebaseRef.collection('inventory_audit').doc();

      // كتابة البيانات في المستند
      await docRef.set({
        'docID': docRef.id,
        'user_id': CacheService.getData(key: CacheKeys.userId),
        'audit_id': auditId,
        'store_id': CacheService.getData(key: CacheKeys.storeId),
        'userName': CacheService.getData(key: CacheKeys.userName),
        'status': 'pending',
        'product_id': 0, // منتج جديد بدون ID من قاعدة البيانات
        'product_name': productName,
        'product_number': 0,
        'quantity': quantity,
        'notes': notes,
        'unit': 'قطعة', // الوحدة الافتراضية
        'selling_price': price.toString(),
        'category_name': 'غير محدد',
        'total_quantity': '0', // المنتج جديد فالكمية السابقة 0
        'barcodes': [barcode], // الباركود المسوح
        'timestamp': FieldValue.serverTimestamp(),
        'created_at': DateTime.now().toIso8601String(),
        'is_new_product': true, // علامة لتمييز المنتج الجديد
      });

      debugPrint('✅ New product saved successfully with docID: ${docRef.id}');

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
                Expanded(child: Text('تم إضافة المنتج الجديد بنجاح')),
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
      debugPrint('❌ Error saving new product: $e');

      if (context.mounted) {
        Navigator.pop(context); // إغلاق مؤشر التحميل

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Row(
              children: [
                const Icon(Icons.error, color: Colors.white),
                const SizedBox(width: 12),
                Expanded(child: Text('خطأ في حفظ المنتج: ${e.toString()}')),
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
  }

  void _showAddNewProductSheet(String barcode) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => AddNewProductSheet(
        barcode: barcode,
        onConfirm: (name, quantity, price, notes) async {
          await _saveNewProductToFirebase(
            barcode,
            name,
            quantity,
            price,
            notes,
          );
        },
      ),
    );
  }

  Future<void> _sendToFirebase(
    Results product,
    int quantity,
    String? notes,
  ) async {
    try {
      // إنشاء مرجع للمستند الجديد
      final docRef = firebaseRef.collection('inventory_audit').doc();

      // كتابة البيانات في المستند مع تضمين docID
      await docRef.set({
        'docID': docRef.id,
        'user_id': CacheService.getData(key: CacheKeys.userId),
        'audit_id': auditId, // استخدام audit_id من الاستجابة
        'store_id': CacheService.getData(key: CacheKeys.storeId),
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

      debugPrint('✅ Data sent successfully with docID: ${docRef.id}');
    } catch (e) {
      debugPrint('❌ Error sending to Firebase: $e');
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
            // ✅ الآن نقوم بإرسال البيانات للـ API أولاً
            auditViewModel.addInventoryAuditItems(
              auditId: auditId ?? 0,
              productId: product.productId!,
              quantity: quantity,
              notes: notes,
            );

            // ⏳ ننتظر استجابة API
            await Future.delayed(const Duration(milliseconds: 500));

            // ✅ بعد النجاح، نرسل للـ Firebase
            await _sendToFirebase(product, quantity, notes);

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
                      Expanded(
                        child: Text(
                          'تم إضافة المنتج بنجاح لقاعدة البيانات وFirebase',
                        ),
                      ),
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
              // إغلاق مؤشر التحميل
              Navigator.pop(context);

              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Row(
                    children: [
                      const Icon(Icons.error, color: Colors.white),
                      const SizedBox(width: 12),
                      Expanded(child: Text('خطأ في الإرسال: ${e.toString()}')),
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

  // صفحة خطأ عدم وجود جرد صالح
  Widget _buildNoAuditErrorPage(String message) {
    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.all(32),
                decoration: BoxDecoration(
                  color: Colors.orange.shade50,
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.inventory_2_outlined,
                  size: 80,
                  color: Colors.orange.shade600,
                ),
              ),
              const SizedBox(height: 32),
              Text(
                'غير مصرح بالدخول',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.grey.shade800,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),
              Text(
                message,
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey.shade600,
                  height: 1.5,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 32),
              ElevatedButton.icon(
                onPressed: () {
                  // إعادة المحاولة
                  searchAuditUserCubit.searchAuditUser();
                },
                icon: const Icon(Icons.refresh),
                label: const Text('إعادة المحاولة'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue.shade600,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 32,
                    vertical: 16,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              TextButton.icon(
                onPressed: () {
                  Navigator.pop(context);
                },
                icon: const Icon(Icons.arrow_back),
                label: const Text('العودة'),
                style: TextButton.styleFrom(
                  foregroundColor: Colors.grey.shade700,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider.value(value: searchViewModel),
        BlocProvider.value(value: auditViewModel),
        BlocProvider.value(value: searchAuditUserCubit),
      ],
      child: BlocConsumer<SearchAuditUserCubit, SearchAuditUserState>(
        listener: (context, state) {
          if (state is SearchAuditUserSuccess) {
            // التحقق من وجود بيانات
            if (state.searchAuditUserEntity?.data != null &&
                state.searchAuditUserEntity!.data!.isNotEmpty) {
              setState(() {
                auditId = state.searchAuditUserEntity!.data!.first.auditId;
                isAuditValid = true;
              });
            } else {
              setState(() {
                isAuditValid = false;
              });
            }
          } else if (state is SearchAuditUserFailure) {
            setState(() {
              isAuditValid = false;
            });
          }
        },
        builder: (context, auditState) {
          // شاشة التحميل
          if (auditState is SearchAuditUserLoading) {
            return Scaffold(
              backgroundColor: Colors.grey.shade50,
              body: const Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CircularProgressIndicator(),
                    SizedBox(height: 16),
                    Text(
                      'جارٍ التحقق من صلاحية الجرد...',
                      style: TextStyle(fontSize: 16, color: Colors.grey),
                    ),
                  ],
                ),
              ),
            );
          }

          // في حالة الفشل أو عدم وجود جرد
          if (!isAuditValid) {
            String errorMessage =
                'لا يوجد جرد مفتوح حاليًا أو لم تتم إضافتك للجرد.\n'
                'يرجى التواصل مع المسؤول لإضافتك.';

            if (auditState is SearchAuditUserFailure) {
              errorMessage =
                  'حدث خطأ أثناء التحقق من صلاحية الجرد.\n'
                  'يرجى المحاولة مرة أخرى.';
            }

            return _buildNoAuditErrorPage(errorMessage);
          }

          // الصفحة الرئيسية في حالة النجاح
          return GestureDetector(
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
                      // إضافة المعاملات الجديدة
                      scannedBarcode: scannedBarcode,
                      isSearchingByBarcode: isSearchingByBarcode,
                      onAddNewProduct: _showAddNewProductSheet,
                    ),

                    const SliverToBoxAdapter(child: SizedBox(height: 80)),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
