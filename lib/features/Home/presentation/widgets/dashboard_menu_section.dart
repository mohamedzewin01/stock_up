import 'package:flutter/material.dart';
import 'package:stock_up/core/resources/style_manager.dart';
import 'package:stock_up/core/utils/cashed_data_shared_preferences.dart';
import 'package:stock_up/features/AuditItems/presentation/pages/AuditItems_page.dart';
import 'package:stock_up/features/Barcodes/presentation/pages/Barcodes_page.dart';
import 'package:stock_up/features/Home/presentation/widgets/placeholder_page.dart';
import 'package:stock_up/features/Inventory/presentation/pages/inventory_page.dart';
import 'package:stock_up/features/POSPage/presentation/pages/POSPage_page.dart';
import 'package:stock_up/features/Summary/presentation/pages/Summary_page.dart';

class DashboardMenuSection extends StatelessWidget {
  const DashboardMenuSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Section Title
          Padding(
            padding: const EdgeInsets.only(bottom: 16, right: 4),
            child: Text(
              'القائمة الرئيسية',
              style: getBoldStyle(color: Colors.white, fontSize: 20),
            ),
          ),

          // Menu Items - Asymmetric Layout
          Column(
            children: [
              // Row 1: Featured Large Card + Small Card
              Row(
                children: [
                  Expanded(
                    flex: 2,
                    child: _buildFeaturedCard(
                      context: context,
                      icon: Icons.inventory_2_rounded,
                      title: 'الجرد',
                      subtitle: 'إدارة المخزون الكاملة',
                      gradient: const LinearGradient(
                        colors: [Color(0xFF8B5CF6), Color(0xFF6366F1)],
                      ),
                      onTap: () {
                        if (CacheService.getData(key: CacheKeys.userRole) ==
                                'admin' ||
                            CacheService.getData(key: CacheKeys.userRole) ==
                                'super') {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => InventoryPage(),
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
                      delay: 0,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _buildNormalCard(
                      context: context,
                      icon: Icons.shopping_bag_rounded,
                      title: 'المنتجات',
                      color: const Color(0xFF3B82F6),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => PlaceholderPage(title: 'المنتجات'),
                          ),
                        );
                      },
                      delay: 100,
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 12),

              // Row 2: Two Equal Cards
              Row(
                children: [
                  Expanded(
                    child: _buildNormalCard(
                      context: context,
                      icon: Icons.book_rounded,
                      title: 'دفتر اليومية',
                      color: const Color(0xFF10B981),
                      onTap: () {
                        if (CacheService.getData(key: CacheKeys.userRole) ==
                                'admin' ||
                            // CacheService.getData(key: CacheKeys.userRole) ==
                            //     'cashier' ||
                            CacheService.getData(key: CacheKeys.userRole) ==
                                'super') {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => SummaryPage(),
                              //const ShiftPage(),
                            ),
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
                      delay: 200,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _buildNormalCard(
                      context: context,
                      icon: Icons.point_of_sale_rounded,
                      title: 'المبيعات',
                      color: const Color(0xFFF59E0B),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (_) => POSPage()),
                        );
                      },
                      delay: 250,
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 12),

              // Row 3: Small Card + Wide Card
              Row(
                children: [
                  Expanded(
                    child: _buildNormalCard(
                      context: context,
                      icon: Icons.settings_rounded,
                      title: 'الإعدادات',
                      color: const Color(0xFF6B7280),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) =>
                                const PlaceholderPage(title: 'الإعدادات'),
                          ),
                        );
                      },
                      delay: 300,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    flex: 2,
                    child: _buildWideCard(
                      context: context,
                      icon: Icons.show_chart,
                      title: 'تحليل البيانات',
                      subtitle: 'التقارير والإحصائيات',
                      gradient: const LinearGradient(
                        colors: [Color(0xFF06B6D4), Color(0xFF3B82F6)],
                      ),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) =>
                                const PlaceholderPage(title: 'تحليل البيانات'),
                          ),
                        );
                      },
                      delay: 350,
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 12),

              // Row 4: Two Equal Cards
              Row(
                children: [
                  Expanded(
                    child: _buildNormalCard(
                      context: context,
                      icon: Icons.qr_code_scanner_rounded,
                      title: 'إضافة باركود',
                      color: const Color(0xFFEC4899),
                      onTap: () {
                        if (CacheService.getData(key: CacheKeys.userRole) ==
                            'super') {
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
                                  const PlaceholderPage(title: 'إضافة باركود'),
                            ),
                          );
                        }
                      },
                      delay: 400,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _buildNormalCard(
                      context: context,
                      icon: Icons.calendar_today_rounded,
                      title: 'تاريخ الانتهاء',
                      color: const Color(0xFFEF4444),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) =>
                                const PlaceholderPage(title: 'تاريخ الانتهاء'),
                          ),
                        );
                      },
                      delay: 450,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  // Featured Large Card
  Widget _buildFeaturedCard({
    required BuildContext context,
    required IconData icon,
    required String title,
    required String subtitle,
    required Gradient gradient,
    required VoidCallback onTap,
    required int delay,
  }) {
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0.0, end: 1.0),
      duration: Duration(milliseconds: 600 + delay),
      curve: Curves.easeOut,
      builder: (context, value, child) {
        return Opacity(
          opacity: value,
          child: Transform.translate(
            offset: Offset(0, 30 * (1 - value)),
            child: child,
          ),
        );
      },
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          height: 180,
          decoration: BoxDecoration(
            gradient: gradient,
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: gradient.colors.first.withOpacity(0.4),
                blurRadius: 20,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: Stack(
            children: [
              // Background Pattern
              Positioned(
                top: -20,
                left: -20,
                child: Container(
                  width: 100,
                  height: 100,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.white.withOpacity(0.1),
                  ),
                ),
              ),
              Positioned(
                bottom: -30,
                right: -30,
                child: Container(
                  width: 120,
                  height: 120,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.white.withOpacity(0.05),
                  ),
                ),
              ),

              // Content
              Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(14),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(14),
                      ),
                      child: Icon(icon, size: 32, color: Colors.white),
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          title,
                          style: getBoldStyle(
                            color: Colors.white,
                            fontSize: 20,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          subtitle,
                          style: getRegularStyle(
                            color: Colors.white.withOpacity(0.9),
                            fontSize: 13,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Normal Card
  Widget _buildNormalCard({
    required BuildContext context,
    required IconData icon,
    required String title,
    required Color color,
    required VoidCallback onTap,
    required int delay,
  }) {
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0.0, end: 1.0),
      duration: Duration(milliseconds: 600 + delay),
      curve: Curves.easeOut,
      builder: (context, value, child) {
        return Opacity(
          opacity: value,
          child: Transform.translate(
            offset: Offset(0, 30 * (1 - value)),
            child: child,
          ),
        );
      },
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          height: 120,
          decoration: BoxDecoration(
            color: const Color(0xFF1E293B),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: color.withOpacity(0.3), width: 1),
          ),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: color.withOpacity(0.15),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(icon, size: 24, color: color),
                ),
                Text(
                  title,
                  style: getSemiBoldStyle(color: Colors.white, fontSize: 15),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // Wide Card
  Widget _buildWideCard({
    required BuildContext context,
    required IconData icon,
    required String title,
    required String subtitle,
    required Gradient gradient,
    required VoidCallback onTap,
    required int delay,
  }) {
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0.0, end: 1.0),
      duration: Duration(milliseconds: 600 + delay),
      curve: Curves.easeOut,
      builder: (context, value, child) {
        return Opacity(
          opacity: value,
          child: Transform.translate(
            offset: Offset(0, 30 * (1 - value)),
            child: child,
          ),
        );
      },
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          height: 120,
          decoration: BoxDecoration(
            gradient: gradient,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: gradient.colors.first.withOpacity(0.3),
                blurRadius: 15,
                offset: const Offset(0, 6),
              ),
            ],
          ),
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: Icon(icon, size: 32, color: Colors.white),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        title,
                        style: getBoldStyle(color: Colors.white, fontSize: 17),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        subtitle,
                        style: getRegularStyle(
                          color: Colors.white.withOpacity(0.9),
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
