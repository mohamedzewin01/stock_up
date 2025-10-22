import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:stock_up/features/Products/domain/useCases/Products_useCase_repo.dart';
import 'package:stock_up/features/Products/presentation/cubit/products_state.dart';
import 'package:stock_up/features/Products/presentation/database_helper.dart';

@injectable
class ProductsCubit extends Cubit<ProductsState> {
  final ProductsUseCaseRepo productsUseCase;
  final DatabaseHelper databaseHelper;

  ProductsCubit(this.productsUseCase, this.databaseHelper)
    : super(ProductsInitial());

  // تحميل المنتجات عند بدء التطبيق
  Future<void> initializeProducts() async {
    emit(ProductsLoading());

    try {
      // التحقق من وجود بيانات محلية
      final hasLocalData = await databaseHelper.hasProducts();

      if (hasLocalData) {
        // تحميل من قاعدة البيانات المحلية
        await loadProductsFromLocal();

        // محاولة المزامنة في الخلفية
        syncProductsInBackground();
      } else {
        // لا توجد بيانات محلية، جلب من API
        await syncProducts();
      }
    } catch (e) {
      emit(ProductsError(message: 'فشل في تحميل المنتجات: ${e.toString()}'));
    }
  }

  // تحميل المنتجات من قاعدة البيانات المحلية
  Future<void> loadProductsFromLocal() async {
    try {
      final products = await databaseHelper.getAllProducts();
      final storeInfo = await databaseHelper.getStoreInfo();

      emit(ProductsLoadedFromLocal(products: products, storeInfo: storeInfo));
    } catch (e) {
      emit(
        ProductsError(
          message: 'فشل في تحميل البيانات المحلية: ${e.toString()}',
        ),
      );
    }
  }

  // مزامنة المنتجات من API
  Future<void> syncProducts() async {
    // الحصول على المنتجات الحالية إن وجدت
    List<dynamic>? currentProducts;
    if (state is ProductsLoadedFromLocal) {
      currentProducts = (state as ProductsLoadedFromLocal).products;
      emit(ProductsSyncing(currentProducts));
    } else {
      emit(ProductsLoading());
    }

    try {
      final result = await productsUseCase.getAllProducts();

      result.when(
        success: (data) async {
          if (data != null) {
            // حفظ في قاعدة البيانات المحلية
            if (data.results != null) {
              await databaseHelper.insertProducts(data.results!);
            }
            if (data.store != null) {
              await databaseHelper.insertStoreInfo(data.store!);
            }

            // تحديث الحالة
            emit(
              ProductsSynced(
                products: data.results ?? [],
                storeInfo: data.store,
                syncTime: DateTime.now(),
              ),
            );
          } else {
            throw Exception('لا توجد بيانات من الخادم');
          }
        },
        failure: (error) {
          // في حالة الفشل، إرجاع البيانات المحلية إن وجدت
          if (currentProducts != null) {
            emit(
              ProductsError(
                message: 'فشل في المزامنة: ${error.message}',
                cachedProducts: currentProducts,
              ),
            );
          } else {
            emit(
              ProductsError(message: 'فشل في جلب البيانات: ${error.message}'),
            );
          }
        },
      );
    } catch (e) {
      if (currentProducts != null) {
        emit(
          ProductsError(
            message: 'خطأ غير متوقع: ${e.toString()}',
            cachedProducts: currentProducts,
          ),
        );
      } else {
        emit(ProductsError(message: 'خطأ غير متوقع: ${e.toString()}'));
      }
    }
  }

  // مزامنة في الخلفية دون تأثير على الحالة الحالية
  Future<void> syncProductsInBackground() async {
    try {
      final result = await productsUseCase.getAllProducts();

      result.when(
        success: (data) async {
          if (data != null) {
            // حفظ في قاعدة البيانات المحلية فقط
            if (data.results != null) {
              await databaseHelper.insertProducts(data.results!);
            }
            if (data.store != null) {
              await databaseHelper.insertStoreInfo(data.store!);
            }
          }
        },
        failure: (_) {
          // تجاهل الأخطاء في المزامنة الخلفية
        },
      );
    } catch (e) {
      // تجاهل الأخطاء في المزامنة الخلفية
    }
  }

  // البحث عن منتجات
  Future<void> searchProducts(String query) async {
    if (query.isEmpty) {
      await loadProductsFromLocal();
      return;
    }

    try {
      final results = await databaseHelper.searchProducts(query);
      emit(ProductsSearchResult(searchResults: results, query: query));
    } catch (e) {
      emit(ProductsError(message: 'فشل في البحث: ${e.toString()}'));
    }
  }

  // إعادة تحميل المنتجات
  Future<void> refreshProducts() async {
    await loadProductsFromLocal();
  }
}
