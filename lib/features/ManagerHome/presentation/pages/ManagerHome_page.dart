// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:stock_up/core/widgets/custom_app_bar.dart';
// import 'package:stock_up/features/ManagerHome/presentation/widgets/menu_card.dart';
// import 'package:stock_up/features/ManagerHome/presentation/widgets/placeholder_page.dart';
// import 'package:stock_up/features/Products/presentation/bloc/products_cubit.dart';
// import 'package:stock_up/features/Search/presentation/pages/Search_page.dart';
// import 'package:stock_up/features/Settings/presentation/pages/Settings_page.dart';
//
// class ManagerHome extends StatefulWidget {
//   const ManagerHome({super.key});
//
//   @override
//   State<ManagerHome> createState() => _ManagerHomeState();
// }
//
// class _ManagerHomeState extends State<ManagerHome> {
//   bool _isFirstLoad = true; // للتحكم في ظهور الديالوج لأول مرة
//
//   @override
//   void initState() {
//     super.initState();
//     WidgetsBinding.instance.addPostFrameCallback((_) {
//       if (_isFirstLoad) {
//         _showFirstSyncDialog();
//       }
//     });
//   }
//
//   void _showFirstSyncDialog() {
//     showDialog(
//       context: context,
//       barrierDismissible: false,
//       builder: (context) => AlertDialog(
//         title: const Text('تهيئة قاعدة البيانات'),
//         content: const Text(
//           'سيتم تحميل جميع المنتجات إلى قاعدة البيانات المحلية لأول مرة.\nالرجاء الانتظار حتى الانتهاء.',
//         ),
//         actions: [
//           TextButton(
//             onPressed: () async {
//               Navigator.pop(context);
//               _syncDatabase();
//               setState(() => _isFirstLoad = false);
//             },
//             child: const Text('بدء التحميل'),
//           ),
//         ],
//       ),
//     );
//   }
//
//   // دالة لمزامنة قاعدة البيانات (تحديث أو أول مرة)
//   void _syncDatabase() async {
//     final cubit = context.read<ProductsCubit>();
//
//     // نعرض ProgressDialog أثناء المزامنة
//     showDialog(
//       context: context,
//       barrierDismissible: false,
//       builder: (context) {
//         return BlocConsumer<ProductsCubit, ProductsState>(
//           listener: (context, state) {
//             if (state is ProductsSyncSuccess) {
//               Navigator.pop(context); // إغلاق الـ Dialog
//               ScaffoldMessenger.of(context).showSnackBar(
//                 const SnackBar(content: Text('تم تحديث قاعدة البيانات ✅')),
//               );
//             } else if (state is ProductsSyncError) {
//               Navigator.pop(context);
//               ScaffoldMessenger.of(context).showSnackBar(
//                 SnackBar(
//                   content: Text('خطأ أثناء المزامنة: ${state.exception}'),
//                 ),
//               );
//             }
//           },
//           builder: (context, state) {
//             double progress = 0.0;
//             if (state is ProductsSyncProgress) {
//               progress = state.progress;
//             }
//             return AlertDialog(
//               title: const Text('جاري تحميل المنتجات...'),
//               content: Column(
//                 mainAxisSize: MainAxisSize.min,
//                 children: [
//                   LinearProgressIndicator(value: progress),
//                   const SizedBox(height: 16),
//                   Text('${(progress * 100).toStringAsFixed(0)} %'),
//                 ],
//               ),
//             );
//           },
//         );
//       },
//     );
//
//     // استدعاء Cubit للمزامنة
//     await cubit.syncProducts();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: CustomAppBar(
//         title: 'لوحة التحكم',
//         startColor: const Color(0xFF00BCD4),
//         endColor: const Color(0xFF0097A7),
//         actions: [
//           IconButton(
//             tooltip: 'تحديث قاعدة البيانات',
//             icon: const Icon(Icons.refresh),
//             onPressed: _syncDatabase,
//           ),
//         ],
//       ),
//       body: SafeArea(
//         child: Padding(
//           padding: const EdgeInsets.all(16),
//           child: LayoutBuilder(
//             builder: (context, constraints) {
//               int crossAxisCount = 2;
//               double childAspectRatio = 1.2;
//
//               if (constraints.maxWidth > 1200) {
//                 crossAxisCount = 5;
//                 childAspectRatio = 1.0;
//               } else if (constraints.maxWidth > 800) {
//                 crossAxisCount = 3;
//                 childAspectRatio = 1.1;
//               } else if (constraints.maxWidth > 600) {
//                 crossAxisCount = 2;
//                 childAspectRatio = 1.2;
//               }
//
//               return GridView.count(
//                 crossAxisCount: crossAxisCount,
//                 crossAxisSpacing: 16,
//                 mainAxisSpacing: 16,
//                 children: [
//                   MenuCard(
//                     icon: Icons.inventory_2_rounded,
//                     title: 'الجرد',
//                     color: const Color(0xFF4CAF50),
//                     gradient: const LinearGradient(
//                       colors: [Color(0xFF4CAF50), Color(0xFF388E3C)],
//                       begin: Alignment.topLeft,
//                       end: Alignment.bottomRight,
//                     ),
//                     onTap: () {
//                       Navigator.push(
//                         context,
//                         MaterialPageRoute(
//                           builder: (_) => const PlaceholderPage(title: 'الجرد'),
//                         ),
//                       );
//                     },
//                   ),
//                   MenuCard(
//                     icon: Icons.shopping_bag_rounded,
//                     title: 'المنتجات',
//                     color: const Color(0xFFFF9800),
//                     gradient: const LinearGradient(
//                       colors: [Color(0xFFFF9800), Color(0xFFF57C00)],
//                       begin: Alignment.topLeft,
//                       end: Alignment.bottomRight,
//                     ),
//                     onTap: () {
//                       Navigator.push(
//                         context,
//                         MaterialPageRoute(builder: (_) => const SearchPage()),
//                       );
//                     },
//                   ),
//                   MenuCard(
//                     icon: Icons.book_rounded,
//                     title: 'دفتر اليومية',
//                     color: const Color(0xFF9C27B0),
//                     gradient: const LinearGradient(
//                       colors: [Color(0xFF9C27B0), Color(0xFF7B1FA2)],
//                       begin: Alignment.topLeft,
//                       end: Alignment.bottomRight,
//                     ),
//                     onTap: () {
//                       Navigator.push(
//                         context,
//                         MaterialPageRoute(
//                           builder: (_) =>
//                               const PlaceholderPage(title: 'دفتر اليومية'),
//                         ),
//                       );
//                     },
//                   ),
//                   MenuCard(
//                     icon: Icons.point_of_sale_rounded,
//                     title: 'المبيعات',
//                     color: const Color(0xFFF44336),
//                     gradient: const LinearGradient(
//                       colors: [Color(0xFFF44336), Color(0xFFD32F2F)],
//                       begin: Alignment.topLeft,
//                       end: Alignment.bottomRight,
//                     ),
//                     onTap: () {
//                       Navigator.push(
//                         context,
//                         MaterialPageRoute(
//                           builder: (_) =>
//                               const PlaceholderPage(title: 'المبيعات'),
//                         ),
//                       );
//                     },
//                   ),
//                   MenuCard(
//                     icon: Icons.settings_rounded,
//                     title: 'الإعدادات',
//                     color: const Color(0xFF607D8B),
//                     gradient: const LinearGradient(
//                       colors: [Color(0xFF607D8B), Color(0xFF455A64)],
//                       begin: Alignment.topLeft,
//                       end: Alignment.bottomRight,
//                     ),
//                     onTap: () {
//                       Navigator.push(
//                         context,
//                         MaterialPageRoute(builder: (_) => const SettingsPage()),
//                       );
//                     },
//                   ),
//                 ],
//               );
//             },
//           ),
//         ),
//       ),
//     );
//   }
// }
import 'package:flutter/material.dart';
import 'package:stock_up/core/utils/cashed_data_shared_preferences.dart';
import 'package:stock_up/core/widgets/custom_app_bar.dart';
import 'package:stock_up/features/AuditItems/presentation/pages/AuditItems_page.dart';
import 'package:stock_up/features/Inventory/presentation/widgets/inventory_list_page.dart';
import 'package:stock_up/features/ManagerHome/presentation/widgets/menu_card.dart';
import 'package:stock_up/features/ManagerHome/presentation/widgets/placeholder_page.dart';
import 'package:stock_up/features/POSPage/presentation/pages/POSPage_page.dart';

class ManagerHome extends StatefulWidget {
  const ManagerHome({super.key});

  @override
  State<ManagerHome> createState() => _ManagerHomeState();
}

class _ManagerHomeState extends State<ManagerHome> {
  bool _isFirstLoad = true;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: 'لوحة التحكم',
        startColor: const Color(0xFF00BCD4),
        endColor: const Color(0xFF0097A7),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: LayoutBuilder(
            builder: (context, constraints) {
              int crossAxisCount = 2;
              double childAspectRatio = 1.2;

              if (constraints.maxWidth > 1200) {
                crossAxisCount = 5;
                childAspectRatio = 1.0;
              } else if (constraints.maxWidth > 800) {
                crossAxisCount = 3;
                childAspectRatio = 1.1;
              } else if (constraints.maxWidth > 600) {
                crossAxisCount = 2;
                childAspectRatio = 1.2;
              }

              return GridView.count(
                crossAxisCount: crossAxisCount,
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
                children: [
                  MenuCard(
                    icon: Icons.inventory_2_rounded,
                    title: 'الجرد',
                    color: const Color(0xFF4CAF50),
                    gradient: const LinearGradient(
                      colors: [Color(0xFF4CAF50), Color(0xFF388E3C)],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    onTap: () {
                      if (CacheService.getData(key: CacheKeys.userRole) ==
                          'admin') {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => InventoryListPage(),
                          ),
                        );
                      } else {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => const SearchProductsPage(),
                          ),
                        );
                      }
                    },
                  ),
                  MenuCard(
                    icon: Icons.shopping_bag_rounded,
                    title: 'المنتجات',
                    color: const Color(0xFFFF9800),
                    gradient: const LinearGradient(
                      colors: [Color(0xFFFF9800), Color(0xFFF57C00)],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => POSPage()),
                      );
                    },
                  ),
                  MenuCard(
                    icon: Icons.book_rounded,
                    title: 'دفتر اليومية',
                    color: const Color(0xFF9C27B0),
                    gradient: const LinearGradient(
                      colors: [Color(0xFF9C27B0), Color(0xFF7B1FA2)],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) =>
                              const PlaceholderPage(title: 'دفتر اليومية'),
                        ),
                      );
                    },
                  ),
                  MenuCard(
                    icon: Icons.point_of_sale_rounded,
                    title: 'المبيعات',
                    color: const Color(0xFFF44336),
                    gradient: const LinearGradient(
                      colors: [Color(0xFFF44336), Color(0xFFD32F2F)],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    onTap: () {
                      //   Navigator.push(
                      //     context,
                      //     MaterialPageRoute(builder: (_) => const InvoicePage()),
                      //   );
                    },
                  ),
                  MenuCard(
                    icon: Icons.settings_rounded,
                    title: 'الإعدادات',
                    color: const Color(0xFF607D8B),
                    gradient: const LinearGradient(
                      colors: [Color(0xFF607D8B), Color(0xFF455A64)],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) =>
                              const PlaceholderPage(title: 'الإعدادات'),
                        ),
                      );
                    },
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}
