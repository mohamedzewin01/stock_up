import 'package:flutter/material.dart';
import 'package:stock_up/core/utils/cashed_data_shared_preferences.dart';
import 'package:stock_up/features/AuditItems/presentation/pages/AuditItems_page.dart';
import 'package:stock_up/features/Barcodes/presentation/pages/Barcodes_page.dart';
import 'package:stock_up/features/Home/presentation/widgets/placeholder_page.dart';
import 'package:stock_up/features/Home/presentation/widgets/premium_card.dart';
import 'package:stock_up/features/Inventory/presentation/pages/inventory_page.dart';
import 'package:stock_up/features/POSPage/presentation/pages/POSPage_page.dart';
import 'package:stock_up/features/Shift/presentation/pages/Shift_page.dart';

class MenuGrid extends StatelessWidget {
  const MenuGrid({super.key});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        int crossAxisCount = 2;
        double childAspectRatio = 1.1;
        double horizontalPadding = 20;

        if (constraints.maxWidth > 1200) {
          crossAxisCount = 4;
          childAspectRatio = 1.0;
          horizontalPadding = 40;
        } else if (constraints.maxWidth > 900) {
          crossAxisCount = 3;
          childAspectRatio = 1.05;
          horizontalPadding = 30;
        } else if (constraints.maxWidth > 600) {
          crossAxisCount = 2;
          childAspectRatio = 1.1;
          horizontalPadding = 24;
        }

        return GridView.count(
          padding: EdgeInsets.symmetric(
            horizontal: horizontalPadding,
            vertical: 8,
          ),
          crossAxisCount: crossAxisCount,
          crossAxisSpacing: 20,
          mainAxisSpacing: 20,
          childAspectRatio: childAspectRatio,
          children: [
            PremiumCard(
              icon: Icons.inventory_2_rounded,
              title: 'الجرد',
              subtitle: 'إدارة المخزون',
              gradientColors: const [Color(0xFF9D4EDD), Color(0xFF7B2CBF)],
              delay: 0,
              onTap: () {
                if (CacheService.getData(key: CacheKeys.userRole) == 'admin' ||
                    CacheService.getData(key: CacheKeys.userRole) == 'super') {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => InventoryPage()),
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
            PremiumCard(
              icon: Icons.shopping_bag_rounded,
              title: 'المنتجات',
              subtitle: 'عرض المنتجات',
              gradientColors: const [Color(0xFF6EC1E4), Color(0xFF3B82F6)],
              // أزرق هادئ وحيوي
              delay: 100,
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => PlaceholderPage(title: 'المنتجات'),
                  ),
                );
              },
            ),
            PremiumCard(
              icon: Icons.book_rounded,
              title: 'دفتر اليومية',
              subtitle: 'السجلات اليومية',
              gradientColors: const [Color(0xFF4ADE80), Color(0xFF22C55E)],
              // أخضر هادئ وحيوي
              delay: 200,
              onTap: () {
                //title: 'دفتر اليومية'
                if (CacheService.getData(key: CacheKeys.userRole) == 'admin' ||
                    CacheService.getData(key: CacheKeys.userRole) ==
                        'cashier' ||
                    CacheService.getData(key: CacheKeys.userRole) == 'super') {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const ShiftPage()),
                  );
                } else {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) =>
                          const PlaceholderPage(title: 'دفتر اليومية'),
                    ),
                  );
                }
              },
            ),
            PremiumCard(
              icon: Icons.point_of_sale_rounded,
              title: 'المبيعات',
              subtitle: 'الفواتير والمبيعات',
              gradientColors: const [Color(0xFFFFB473), Color(0xFFF97316)],
              // برتقالي هادئ وحيوي
              delay: 300,
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => POSPage()),
                );
              },
            ),
            PremiumCard(
              icon: Icons.settings_rounded,
              title: 'الإعدادات',
              subtitle: 'إعدادات النظام',
              gradientColors: const [Color(0xFF9CA3AF), Color(0xFF6B7280)],
              // رمادي هادئ قليلاً مش مطفي
              delay: 400,
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const PlaceholderPage(title: 'الإعدادات'),
                  ),
                );
              },
            ),
            PremiumCard(
              icon: Icons.show_chart,
              title: 'تحليل البيانات',
              subtitle: 'عرض التقارير والإحصائيات',
              gradientColors: const [Color(0xFF60A5FA), Color(0xFF3B82F6)],
              // أزرق هادئ وحيوي
              delay: 500,
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) =>
                        const PlaceholderPage(title: 'تحليل البيانات'),
                  ),
                );
              },
            ),
            PremiumCard(
              icon: Icons.barcode_reader,
              title: 'اضافة باركود',
              subtitle: 'اضافة باركود للكميات',
              gradientColors: const [Color(0xFFE0D1E6), Color(0xF9AD8EDA)],

              delay: 500,
              onTap: () {
                //title: 'دفتر اليومية'
                if (CacheService.getData(key: CacheKeys.userRole) == 'super') {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const BarcodesPage(),
                    ),
                  );
                } else {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) =>
                          const PlaceholderPage(title: 'اضافة باكود'),
                    ),
                  );
                }
              },
            ),
            PremiumCard(
              icon: Icons.barcode_reader,
              title: 'تاريخ الانتهاء',
              subtitle: 'اضافة باركود للكميات',
              gradientColors: const [Color(0xFFE0D1E6), Color(0xF9AD8EDA)],
              delay: 500,
              onTap: () {
                //title: 'دفتر اليومية'
                // if (CacheService.getData(key: CacheKeys.userRole) == 'super') {
                //   Navigator.push(
                //     context,
                //     MaterialPageRoute(
                //       builder: (context) => BlocProvider(
                //         create: (context) => DateScannerCubit(),
                //         child: const DateScannerPage(),
                //       ),
                //     ),
                //   );
                // } else {
                //   Navigator.push(
                //     context,
                //     MaterialPageRoute(
                //       builder: (_) =>
                //           const PlaceholderPage(title: 'اضافة باكود'),
                //     ),
                //   );
                // }
              },
            ),
          ],
        );
      },
    );
  }
}
