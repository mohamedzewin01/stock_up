// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:stock_up/features/AuditItems/presentation/widgets/empty_products.dart';
// import 'package:stock_up/features/AuditItems/presentation/widgets/product_card.dart';
//
// import '../../data/models/response/search_products_model.dart';
// import '../bloc/SearchProducts/search_products_cubit.dart';
//
// class ProductsListSection extends StatelessWidget {
//   final List<Results> allProducts;
//   final bool isLoadingMore;
//   final int currentPage;
//   final TextEditingController searchController;
//   final Function(Results) onProductTap;
//   final Function(List<Results>, bool, bool) onStateChanged;
//
//   const ProductsListSection({
//     super.key,
//     required this.allProducts,
//     required this.isLoadingMore,
//     required this.currentPage,
//     required this.searchController,
//     required this.onProductTap,
//     required this.onStateChanged,
//   });
//
//   @override
//   Widget build(BuildContext context) {
//     return BlocConsumer<SearchProductsCubit, SearchProductsState>(
//       listener: (context, state) {
//         if (state is SearchProductsSuccess) {
//           List<Results> updatedProducts = allProducts;
//           if (currentPage == 1) {
//             updatedProducts = state.searchProductsEntity?.results ?? [];
//           } else {
//             updatedProducts = [
//               ...allProducts,
//               ...(state.searchProductsEntity?.results ?? []),
//             ];
//           }
//
//           final hasMore =
//               (state.searchProductsEntity?.results?.length ?? 0) >= 10;
//           onStateChanged(updatedProducts, false, hasMore);
//         } else if (state is SearchProductsFailure) {
//           onStateChanged(allProducts, false, true);
//           ScaffoldMessenger.of(context).showSnackBar(
//             SnackBar(
//               content: const Row(
//                 children: [
//                   Icon(Icons.error, color: Colors.white),
//                   SizedBox(width: 12),
//                   Text('حدث خطأ أثناء البحث'),
//                 ],
//               ),
//               backgroundColor: Colors.red.shade600,
//               behavior: SnackBarBehavior.floating,
//             ),
//           );
//         }
//       },
//       builder: (context, state) {
//         if (state is SearchProductsLoading && currentPage == 1) {
//           return const SliverFillRemaining(
//             child: Center(child: CircularProgressIndicator()),
//           );
//         }
//
//         // رسالة عندما يكون البحث أقل من 3 حروف
//         if (searchController.text.isNotEmpty &&
//             searchController.text.length < 3) {
//           return SliverFillRemaining(
//             child: Center(
//               child: Column(
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 children: [
//                   Icon(
//                     Icons.edit_outlined,
//                     size: 80,
//                     color: Colors.grey.shade400,
//                   ),
//                   const SizedBox(height: 16),
//                   Text(
//                     'أدخل 3 حروف على الأقل للبحث',
//                     style: TextStyle(
//                       fontSize: 18,
//                       fontWeight: FontWeight.bold,
//                       color: Colors.grey.shade600,
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//           );
//         }
//
//         if (allProducts.isEmpty) {
//           return const EmptyProductsWidget();
//         }
//
//         return SliverPadding(
//           padding: const EdgeInsets.symmetric(horizontal: 16),
//           sliver: SliverList(
//             delegate: SliverChildBuilderDelegate((context, index) {
//               if (index == allProducts.length) {
//                 return Container(
//                   padding: const EdgeInsets.all(16),
//                   child: const Center(child: CircularProgressIndicator()),
//                 );
//               }
//
//               final product = allProducts[index];
//               return ProductCard(
//                 product: product,
//                 onEdit: () => onProductTap(product),
//               );
//             }, childCount: allProducts.length + (isLoadingMore ? 1 : 0)),
//           ),
//         );
//       },
//     );
//   }
// }
///----
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:stock_up/features/AuditItems/presentation/widgets/add_product_button_widget.dart';
import 'package:stock_up/features/AuditItems/presentation/widgets/empty_products.dart';
import 'package:stock_up/features/AuditItems/presentation/widgets/product_card.dart';

import '../../data/models/response/search_products_model.dart';
import '../bloc/SearchProducts/search_products_cubit.dart';

class ProductsListSection extends StatelessWidget {
  final List<Results> allProducts;
  final bool isLoadingMore;
  final int currentPage;
  final TextEditingController searchController;
  final Function(Results) onProductTap;
  final Function(List<Results>, bool, bool) onStateChanged;
  final String? scannedBarcode;
  final bool isSearchingByBarcode;
  final Function(String) onAddNewProduct;

  const ProductsListSection({
    super.key,
    required this.allProducts,
    required this.isLoadingMore,
    required this.currentPage,
    required this.searchController,
    required this.onProductTap,
    required this.onStateChanged,
    this.scannedBarcode,
    this.isSearchingByBarcode = false,
    required this.onAddNewProduct,
  });

  @override
  Widget build(BuildContext context) {
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
          onStateChanged(updatedProducts, false, hasMore);
        } else if (state is SearchProductsFailure) {
          onStateChanged(allProducts, false, true);
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

        // رسالة عندما يكون البحث أقل من 3 حروف
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

        // ✅ الحالة الجديدة: إذا كان البحث بالباركود ولا توجد نتائج
        if (allProducts.isEmpty &&
            isSearchingByBarcode &&
            scannedBarcode != null &&
            scannedBarcode!.isNotEmpty &&
            state is! SearchProductsLoading) {
          return AddProductButtonWidget(
            barcode: scannedBarcode!,
            onPressed: () => onAddNewProduct(scannedBarcode!),
          );
        }

        // الحالة العادية: لا توجد منتجات
        if (allProducts.isEmpty) {
          return const EmptyProductsWidget();
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
              return ProductCard(
                product: product,
                onEdit: () => onProductTap(product),
              );
            }, childCount: allProducts.length + (isLoadingMore ? 1 : 0)),
          ),
        );
      },
    );
  }
}
