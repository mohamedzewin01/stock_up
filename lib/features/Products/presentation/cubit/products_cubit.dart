// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:injectable/injectable.dart';
// import 'package:stock_up/core/common/api_result.dart';
// import 'package:stock_up/features/Products/data/models/response/get_all_products_model.dart';
// import 'package:stock_up/features/Products/domain/useCases/Products_useCase_repo.dart';
// import 'package:stock_up/features/Products/presentation/cubit/products_state.dart';
// import 'package:stock_up/features/Products/presentation/database_helper.dart';
//
// import '../../domain/entities/products_entities.dart';
//
// @injectable
// class ProductsCubit extends Cubit<ProductsState> {
//   final ProductsUseCaseRepo productsUseCase;
//   final DatabaseHelper databaseHelper;
//
//   ProductsCubit(this.productsUseCase, this.databaseHelper)
//     : super(ProductsInitial());
//
//   // تحميل المنتجات عند بدء التطبيق
//   Future<void> initializeProducts() async {
//     try {
//       // التحقق من وجود بيانات محلية
//       final hasLocalData = await databaseHelper.hasProducts();
//
//       if (hasLocalData) {
//         // تحميل من قاعدة البيانات المحلية
//         await loadProductsFromLocal();
//
//         // محاولة المزامنة في الخلفية
//         syncProductsInBackground();
//       } else {
//         // لا توجد بيانات محلية، جلب من API مع عرض التقدم
//         await syncProductsWithProgress();
//       }
//     } catch (e) {
//       // طباعة الأخطاء المهمة فقط
//       print('❌ خطأ في initializeProducts: $e');
//       emit(ProductsError(message: 'فشل في تحميل المنتجات: ${e.toString()}'));
//     }
//   }
//
//   // تحميل المنتجات من قاعدة البيانات المحلية
//   Future<void> loadProductsFromLocal() async {
//     emit(ProductsLoading());
//     try {
//       final products = await databaseHelper.getAllProducts();
//       final storeInfo = await databaseHelper.getStoreInfo();
//
//       // طباعة معلومة واحدة فقط
//       print('✅ تم تحميل ${products.length} منتج من القاعدة المحلية');
//
//       emit(ProductsLoadedFromLocal(products: products, storeInfo: storeInfo));
//     } catch (e) {
//       print('❌ خطأ في loadProductsFromLocal: $e');
//       emit(
//         ProductsError(
//           message: 'فشل في تحميل البيانات المحلية: ${e.toString()}',
//         ),
//       );
//     }
//   }
//
//   // مزامنة المنتجات من API مع عرض التقدم (للمرة الأولى)
//   Future<void> syncProductsWithProgress() async {
//     try {
//       print('🔄 بدء التحميل الأولي للمنتجات...');
//
//       // عرض تقدم 0%
//       emit(
//         const ProductsFirstTimeLoading(
//           progress: 0,
//           currentCount: 0,
//           totalCount: 0,
//         ),
//       );
//
//       // بدء جلب البيانات
//       final result = await productsUseCase.getAllProducts();
//
//       switch (result) {
//         case Success<GetAllProductsEntity?>():
//           final data = result.data;
//
//           if (data != null && data.results != null) {
//             final products = data.results!;
//             final totalCount = products.length;
//
//             print('📦 تم استلام $totalCount منتج من API');
//
//             // عرض تقدم 30% - تم استلام البيانات
//             emit(
//               ProductsFirstTimeLoading(
//                 progress: 30,
//                 currentCount: 0,
//                 totalCount: totalCount,
//               ),
//             );
//
//             // حفظ البيانات على دفعات لتحسين الأداء
//             const batchSize = 500;
//             int savedCount = 0;
//
//             print(
//               '💾 بدء حفظ البيانات على دفعات (${(totalCount / batchSize).ceil()} دفعة)',
//             );
//
//             for (int i = 0; i < products.length; i += batchSize) {
//               final end = (i + batchSize < products.length)
//                   ? i + batchSize
//                   : products.length;
//               final batch = products.sublist(i, end);
//
//               // حفظ الدفعة
//               await databaseHelper.insertProductsBatch(batch);
//
//               savedCount = end;
//               final progress = 30 + ((savedCount / totalCount) * 60).toInt();
//
//               // طباعة التقدم كل 1000 منتج فقط
//               if (savedCount % 1000 == 0 || savedCount == totalCount) {
//                 print('📊 تم حفظ $savedCount/$totalCount منتج ($progress%)');
//               }
//
//               // تحديث التقدم
//               emit(
//                 ProductsFirstTimeLoading(
//                   progress: progress,
//                   currentCount: savedCount,
//                   totalCount: totalCount,
//                 ),
//               );
//
//               // تأخير بسيط لإعطاء فرصة للواجهة للتحديث
//               await Future.delayed(const Duration(milliseconds: 50));
//             }
//
//             // حفظ معلومات المتجر
//             if (data.store != null) {
//               await databaseHelper.insertStoreInfo(data.store!);
//               print('🏪 تم حفظ معلومات المتجر: ${data.store!.name}');
//             }
//
//             // عرض تقدم 100%
//             emit(
//               ProductsFirstTimeLoading(
//                 progress: 100,
//                 currentCount: totalCount,
//                 totalCount: totalCount,
//               ),
//             );
//
//             print('✅ اكتمل التحميل الأولي بنجاح!');
//
//             // تأخير بسيط قبل الانتقال للحالة النهائية
//             await Future.delayed(const Duration(milliseconds: 500));
//
//             // تحديث الحالة النهائية
//             emit(
//               ProductsSynced(
//                 products: products,
//                 storeInfo: data.store,
//                 syncTime: DateTime.now(),
//               ),
//             );
//           } else {
//             print('⚠️ لا توجد بيانات من الخادم');
//             emit(const ProductsError(message: 'لا توجد بيانات من الخادم'));
//           }
//           break;
//
//         case Fail<GetAllProductsEntity?>():
//           print('❌ فشل في جلب البيانات: ${result.exception}');
//           emit(
//             ProductsError(message: 'فشل في جلب البيانات: ${result.exception}'),
//           );
//           break;
//       }
//     } catch (e) {
//       print('❌ خطأ في syncProductsWithProgress: $e');
//       emit(ProductsError(message: 'خطأ غير متوقع: ${e.toString()}'));
//     }
//   }
//
//   // مزامنة المنتجات من API (بدون عرض التقدم)
//   Future<void> syncProducts() async {
//     // الحصول على المنتجات الحالية إن وجدت
//     List<Results>? currentProducts;
//
//     if (state is ProductsLoadedFromLocal) {
//       currentProducts = (state as ProductsLoadedFromLocal).products;
//       emit(ProductsSyncing(currentProducts));
//     } else {
//       emit(ProductsLoading());
//     }
//
//     try {
//       print('🔄 بدء المزامنة من API...');
//
//       final result = await productsUseCase.getAllProducts();
//
//       switch (result) {
//         case Success<GetAllProductsEntity?>():
//           final data = result.data;
//
//           if (data != null) {
//             // حفظ في قاعدة البيانات المحلية
//             if (data.results != null) {
//               print('💾 حفظ ${data.results!.length} منتج...');
//               await databaseHelper.insertProducts(data.results!);
//             }
//             if (data.store != null) {
//               await databaseHelper.insertStoreInfo(data.store!);
//             }
//
//             print('✅ تمت المزامنة بنجاح');
//
//             // تحديث الحالة
//             emit(
//               ProductsSynced(
//                 products: data.results ?? [],
//                 storeInfo: data.store,
//                 syncTime: DateTime.now(),
//               ),
//             );
//           } else {
//             print('⚠️ لا توجد بيانات من الخادم');
//             if (currentProducts != null) {
//               emit(
//                 ProductsError(
//                   message: 'لا توجد بيانات من الخادم',
//                   cachedProducts: currentProducts,
//                 ),
//               );
//             } else {
//               emit(const ProductsError(message: 'لا توجد بيانات من الخادم'));
//             }
//           }
//           break;
//
//         case Fail<GetAllProductsEntity?>():
//           print('❌ فشل في المزامنة: ${result.exception}');
//           if (currentProducts != null) {
//             emit(
//               ProductsError(
//                 message: 'فشل في المزامنة: ${result.exception}',
//                 cachedProducts: currentProducts,
//               ),
//             );
//           } else {
//             emit(
//               ProductsError(
//                 message: 'فشل في جلب البيانات: ${result.exception}',
//               ),
//             );
//           }
//           break;
//       }
//     } catch (e) {
//       print('❌ خطأ في syncProducts: $e');
//       if (currentProducts != null) {
//         emit(
//           ProductsError(
//             message: 'خطأ غير متوقع: ${e.toString()}',
//             cachedProducts: currentProducts,
//           ),
//         );
//       } else {
//         emit(ProductsError(message: 'خطأ غير متوقع: ${e.toString()}'));
//       }
//     }
//   }
//
//   // مزامنة في الخلفية دون تأثير على الحالة الحالية
//   Future<void> syncProductsInBackground() async {
//     try {
//       print('🔄 مزامنة خلفية...');
//
//       final result = await productsUseCase.getAllProducts();
//
//       switch (result) {
//         case Success<GetAllProductsEntity?>():
//           final data = result.data;
//
//           if (data != null) {
//             // حفظ في قاعدة البيانات المحلية فقط
//             if (data.results != null) {
//               await databaseHelper.insertProducts(data.results!);
//               print('✅ تمت المزامنة الخلفية: ${data.results!.length} منتج');
//             }
//             if (data.store != null) {
//               await databaseHelper.insertStoreInfo(data.store!);
//             }
//           }
//           break;
//
//         case Fail<GetAllProductsEntity?>():
//           // تجاهل الأخطاء في المزامنة الخلفية
//           print('⚠️ فشلت المزامنة الخلفية (تم التجاهل)');
//           break;
//       }
//     } catch (e) {
//       // تجاهل الأخطاء في المزامنة الخلفية
//       print('⚠️ خطأ في المزامنة الخلفية (تم التجاهل): $e');
//     }
//   }
//
//   // البحث عن منتجات
//   Future<void> searchProducts(String query) async {
//     if (query.isEmpty) {
//       await loadProductsFromLocal();
//       return;
//     }
//
//     try {
//       final results = await databaseHelper.searchProducts(query);
//       print('🔍 نتائج البحث عن "$query": ${results.length} منتج');
//       emit(ProductsSearchResult(searchResults: results, query: query));
//     } catch (e) {
//       print('❌ خطأ في البحث: $e');
//       emit(ProductsError(message: 'فشل في البحث: ${e.toString()}'));
//     }
//   }
//
//   // إعادة تحميل المنتجات
//   Future<void> refreshProducts() async {
//     print('🔄 إعادة تحميل المنتجات...');
//     await loadProductsFromLocal();
//   }
// }
