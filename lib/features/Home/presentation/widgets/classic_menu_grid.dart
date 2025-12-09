import 'package:flutter/material.dart';
import 'package:stock_up/core/resources/style_manager.dart';
import 'package:stock_up/core/utils/cashed_data_shared_preferences.dart';
import 'package:stock_up/features/AuditItems/presentation/pages/AuditItems_page.dart';
import 'package:stock_up/features/Barcodes/presentation/pages/Barcodes_page.dart';
import 'package:stock_up/features/Home/presentation/widgets/placeholder_page.dart';
import 'package:stock_up/features/Inventory/presentation/pages/inventory_page.dart';
import 'package:stock_up/features/POSPage/presentation/pages/POSPage_page.dart';
import 'package:stock_up/features/Shift/presentation/pages/Shift_page.dart';

class DashboardMenuSection extends StatelessWidget {
  const DashboardMenuSection({super.key});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final width = constraints.maxWidth;

        // Determine layout type based on screen width
        if (width < 600) {
          // Mobile: Vertical stack with full-width cards
          return _buildMobileLayout(context);
        } else if (width < 1000) {
          // Tablet: 2-column grid with some variation
          return _buildTabletLayout(context);
        } else {
          // Desktop: Full asymmetric layout
          return _buildDesktopLayout(context);
        }
      },
    );
  }

  // Mobile Layout - Vertical Stack
  Widget _buildMobileLayout(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(bottom: 16, right: 4),
            child: Text(
              'القائمة الرئيسية',
              style: getBoldStyle(color: Colors.white, fontSize: 20),
            ),
          ),
          _buildFeaturedCard(
            context: context,
            icon: Icons.inventory_2_rounded,
            title: 'الجرد',
            subtitle: 'إدارة المخزون الكاملة',
            gradient: const LinearGradient(
              colors: [Color(0xFF8B5CF6), Color(0xFF6366F1)],
            ),
            onTap: () => _navigateToInventory(context),
            delay: 0,
          ),
          const SizedBox(height: 12),
          _buildCompactCard(
            context: context,
            icon: Icons.shopping_bag_rounded,
            title: 'المنتجات',
            subtitle: 'عرض المنتجات',
            color: const Color(0xFF3B82F6),
            onTap: () => _navigateToProducts(context),
            delay: 50,
          ),
          const SizedBox(height: 12),
          _buildCompactCard(
            context: context,
            icon: Icons.book_rounded,
            title: 'دفتر اليومية',
            subtitle: 'السجلات اليومية',
            color: const Color(0xFF10B981),
            onTap: () => _navigateToShift(context),
            delay: 100,
          ),
          const SizedBox(height: 12),
          _buildCompactCard(
            context: context,
            icon: Icons.point_of_sale_rounded,
            title: 'المبيعات',
            subtitle: 'الفواتير والمبيعات',
            color: const Color(0xFFF59E0B),
            onTap: () => _navigateToPOS(context),
            delay: 150,
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: _buildSmallCard(
                  context: context,
                  icon: Icons.settings_rounded,
                  title: 'الإعدادات',
                  color: const Color(0xFF6B7280),
                  onTap: () => _navigateToSettings(context),
                  delay: 200,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildSmallCard(
                  context: context,
                  icon: Icons.show_chart,
                  title: 'التحليلات',
                  color: const Color(0xFF06B6D4),
                  onTap: () => _navigateToAnalytics(context),
                  delay: 250,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: _buildSmallCard(
                  context: context,
                  icon: Icons.qr_code_scanner_rounded,
                  title: 'الباركود',
                  color: const Color(0xFFEC4899),
                  onTap: () => _navigateToBarcode(context),
                  delay: 300,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildSmallCard(
                  context: context,
                  icon: Icons.calendar_today_rounded,
                  title: 'الصلاحية',
                  color: const Color(0xFFEF4444),
                  onTap: () => _navigateToExpiry(context),
                  delay: 350,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // Tablet Layout - 2 Column Grid with variation
  Widget _buildTabletLayout(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(bottom: 16, right: 4),
            child: Text(
              'القائمة الرئيسية',
              style: getBoldStyle(color: Colors.white, fontSize: 20),
            ),
          ),
          // Row 1: Full width featured
          _buildFeaturedCard(
            context: context,
            icon: Icons.inventory_2_rounded,
            title: 'الجرد',
            subtitle: 'إدارة المخزون الكاملة',
            gradient: const LinearGradient(
              colors: [Color(0xFF8B5CF6), Color(0xFF6366F1)],
            ),
            onTap: () => _navigateToInventory(context),
            delay: 0,
          ),
          const SizedBox(height: 12),
          // Row 2: Two equal cards
          Row(
            children: [
              Expanded(
                child: _buildNormalCard(
                  context: context,
                  icon: Icons.shopping_bag_rounded,
                  title: 'المنتجات',
                  color: const Color(0xFF3B82F6),
                  onTap: () => _navigateToProducts(context),
                  delay: 50,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildNormalCard(
                  context: context,
                  icon: Icons.book_rounded,
                  title: 'دفتر اليومية',
                  color: const Color(0xFF10B981),
                  onTap: () => _navigateToShift(context),
                  delay: 100,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          // Row 3: Two equal cards
          Row(
            children: [
              Expanded(
                child: _buildNormalCard(
                  context: context,
                  icon: Icons.point_of_sale_rounded,
                  title: 'المبيعات',
                  color: const Color(0xFFF59E0B),
                  onTap: () => _navigateToPOS(context),
                  delay: 150,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildNormalCard(
                  context: context,
                  icon: Icons.show_chart,
                  title: 'تحليل البيانات',
                  color: const Color(0xFF06B6D4),
                  onTap: () => _navigateToAnalytics(context),
                  delay: 200,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          // Row 4: Two equal cards
          Row(
            children: [
              Expanded(
                child: _buildNormalCard(
                  context: context,
                  icon: Icons.settings_rounded,
                  title: 'الإعدادات',
                  color: const Color(0xFF6B7280),
                  onTap: () => _navigateToSettings(context),
                  delay: 250,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildNormalCard(
                  context: context,
                  icon: Icons.qr_code_scanner_rounded,
                  title: 'إضافة باركود',
                  color: const Color(0xFFEC4899),
                  onTap: () => _navigateToBarcode(context),
                  delay: 300,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          // Row 5: Single card
          _buildWideCard(
            context: context,
            icon: Icons.calendar_today_rounded,
            title: 'تاريخ الانتهاء',
            subtitle: 'مسح تاريخ الصلاحية',
            gradient: const LinearGradient(
              colors: [Color(0xFFEF4444), Color(0xFFDC2626)],
            ),
            onTap: () => _navigateToExpiry(context),
            delay: 350,
          ),
        ],
      ),
    );
  }

  // Desktop Layout - Full Asymmetric
  Widget _buildDesktopLayout(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(bottom: 16, right: 4),
            child: Text(
              'القائمة الرئيسية',
              style: getBoldStyle(color: Colors.white, fontSize: 20),
            ),
          ),
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
                  onTap: () => _navigateToInventory(context),
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
                  onTap: () => _navigateToProducts(context),
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
                  onTap: () => _navigateToShift(context),
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
                  onTap: () => _navigateToPOS(context),
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
                  onTap: () => _navigateToSettings(context),
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
                  onTap: () => _navigateToAnalytics(context),
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
                  onTap: () => _navigateToBarcode(context),
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
                  onTap: () => _navigateToExpiry(context),
                  delay: 450,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // Navigation Methods
  void _navigateToInventory(BuildContext context) {
    if (CacheService.getData(key: CacheKeys.userRole) == 'admin' ||
        CacheService.getData(key: CacheKeys.userRole) == 'super') {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => InventoryPage()),
      );
    } else {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => const SearchProductsPage()),
      );
    }
  }

  void _navigateToProducts(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => PlaceholderPage(title: 'المنتجات')),
    );
  }

  void _navigateToShift(BuildContext context) {
    if (CacheService.getData(key: CacheKeys.userRole) == 'admin' ||
        CacheService.getData(key: CacheKeys.userRole) == 'cashier' ||
        CacheService.getData(key: CacheKeys.userRole) == 'super') {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const ShiftPage()),
      );
    } else {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => const PlaceholderPage(title: 'دفتر اليومية'),
        ),
      );
    }
  }

  void _navigateToPOS(BuildContext context) {
    Navigator.push(context, MaterialPageRoute(builder: (_) => POSPage()));
  }

  void _navigateToSettings(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => const PlaceholderPage(title: 'الإعدادات'),
      ),
    );
  }

  void _navigateToAnalytics(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => const PlaceholderPage(title: 'تحليل البيانات'),
      ),
    );
  }

  void _navigateToBarcode(BuildContext context) {
    if (CacheService.getData(key: CacheKeys.userRole) == 'super') {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const BarcodesPage()),
      );
    } else {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => const PlaceholderPage(title: 'إضافة باركود'),
        ),
      );
    }
  }

  void _navigateToExpiry(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => const PlaceholderPage(title: 'تاريخ الانتهاء'),
      ),
    );
  }

  // Card Builders

  // Featured Large Card (Desktop/Tablet)
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

  // Normal Card (All screens)
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

  // Wide Card (Desktop/Tablet)
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

  // Compact Card (Mobile only - with subtitle)
  Widget _buildCompactCard({
    required BuildContext context,
    required IconData icon,
    required String title,
    required String subtitle,
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
          height: 90,
          decoration: BoxDecoration(
            color: const Color(0xFF1E293B),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: color.withOpacity(0.3), width: 1),
          ),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: color.withOpacity(0.15),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(icon, size: 28, color: color),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        title,
                        style: getSemiBoldStyle(
                          color: Colors.white,
                          fontSize: 16,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        subtitle,
                        style: getRegularStyle(
                          color: Colors.white.withOpacity(0.6),
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

  // Small Card (Mobile only - icon and text only)
  Widget _buildSmallCard({
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
          height: 100,
          decoration: BoxDecoration(
            color: const Color(0xFF1E293B),
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: color.withOpacity(0.3), width: 1),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.15),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(icon, size: 24, color: color),
              ),
              const SizedBox(height: 10),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8),
                child: Text(
                  title,
                  style: getMediumStyle(color: Colors.white, fontSize: 13),
                  textAlign: TextAlign.center,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
