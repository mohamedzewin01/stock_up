// import 'package:flutter/material.dart';
// import 'package:stock_up/core/utils/cashed_data_shared_preferences.dart';
// import 'package:stock_up/core/widgets/animated_background.dart';
// import 'package:stock_up/features/AuditItems/presentation/pages/AuditItems_page.dart';
// import 'package:stock_up/features/Inventory/presentation/widgets/inventory_list_page.dart';
// import 'package:stock_up/features/ManagerHome/presentation/widgets/placeholder_page.dart';
// import 'package:stock_up/features/POSPage/presentation/pages/POSPage_page.dart';
// import 'package:stock_up/features/Products/presentation/pages/home_invoice.dart';
//
// class ManagerHome extends StatefulWidget {
//   const ManagerHome({super.key});
//
//   @override
//   State<ManagerHome> createState() => _ManagerHomeState();
// }
//
// class _ManagerHomeState extends State<ManagerHome>
//     with SingleTickerProviderStateMixin {
//   late AnimationController _controller;
//   late Animation<double> _fadeAnimation;
//
//   @override
//   void initState() {
//     super.initState();
//     _controller = AnimationController(
//       duration: const Duration(milliseconds: 800),
//       vsync: this,
//     );
//     _fadeAnimation = Tween<double>(
//       begin: 0.0,
//       end: 1.0,
//     ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));
//     _controller.forward();
//   }
//
//   @override
//   void dispose() {
//     _controller.dispose();
//     super.dispose();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.transparent,
//       body: Stack(
//         children: [
//           // الخلفية المتحركة
//           const AnimatedGradientBackground(),
//
//           // المحتوى الرئيسي
//           SafeArea(
//             child: Column(
//               children: [
//                 _buildHeader(),
//                 Expanded(
//                   child: FadeTransition(
//                     opacity: _fadeAnimation,
//                     child: _buildMenuGrid(),
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }
//
//   Widget _buildHeader() {
//     return Container(
//       padding: const EdgeInsets.all(24),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Row(
//             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//             children: [
//               Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Text(
//                     'مرحباً بك',
//                     style: TextStyle(
//                       fontSize: 16,
//                       color: Colors.white.withOpacity(0.8),
//                       fontWeight: FontWeight.w500,
//                     ),
//                   ),
//                   const SizedBox(height: 4),
//                   ShaderMask(
//                     shaderCallback: (bounds) => const LinearGradient(
//                       colors: [Color(0xFFFFFFFF), Color(0xFFE0AAFF)],
//                     ).createShader(bounds),
//                     child: const Text(
//                       'لوحة التحكم',
//                       style: TextStyle(
//                         fontSize: 32,
//                         fontWeight: FontWeight.w900,
//                         color: Colors.white,
//                       ),
//                     ),
//                   ),
//                 ],
//               ),
//               Container(
//                 decoration: BoxDecoration(
//                   gradient: LinearGradient(
//                     colors: [
//                       Colors.white.withOpacity(0.2),
//                       Colors.white.withOpacity(0.1),
//                     ],
//                   ),
//                   borderRadius: BorderRadius.circular(16),
//                   border: Border.all(
//                     color: Colors.white.withOpacity(0.3),
//                     width: 1.5,
//                   ),
//                   boxShadow: [
//                     BoxShadow(
//                       color: Colors.black.withOpacity(0.1),
//                       blurRadius: 10,
//                       offset: const Offset(0, 4),
//                     ),
//                   ],
//                 ),
//                 child: IconButton(
//                   icon: const Icon(Icons.notifications_rounded, size: 26),
//                   color: Colors.white,
//                   onPressed: () {},
//                 ),
//               ),
//             ],
//           ),
//         ],
//       ),
//     );
//   }
//
//   Widget _buildMenuGrid() {
//     return LayoutBuilder(
//       builder: (context, constraints) {
//         int crossAxisCount = 2;
//         double childAspectRatio = 1.1;
//         double horizontalPadding = 20;
//
//         if (constraints.maxWidth > 1200) {
//           crossAxisCount = 4;
//           childAspectRatio = 1.0;
//           horizontalPadding = 40;
//         } else if (constraints.maxWidth > 900) {
//           crossAxisCount = 3;
//           childAspectRatio = 1.05;
//           horizontalPadding = 30;
//         } else if (constraints.maxWidth > 600) {
//           crossAxisCount = 2;
//           childAspectRatio = 1.1;
//           horizontalPadding = 24;
//         }
//
//         return GridView.count(
//           padding: EdgeInsets.symmetric(
//             horizontal: horizontalPadding,
//             vertical: 8,
//           ),
//           crossAxisCount: crossAxisCount,
//           crossAxisSpacing: 20,
//           mainAxisSpacing: 20,
//           childAspectRatio: childAspectRatio,
//           children: [
//             _buildModernCard(
//               icon: Icons.inventory_2_rounded,
//               title: 'الجرد',
//               subtitle: 'إدارة المخزون',
//               gradientColors: const [Color(0xFF9D4EDD), Color(0xFF7B2CBF)],
//               delay: 0,
//               onTap: () {
//                 if (CacheService.getData(key: CacheKeys.userRole) == 'admin') {
//                   Navigator.push(
//                     context,
//                     MaterialPageRoute(
//                       builder: (context) => InventoryListPage(),
//                     ),
//                   );
//                 } else {
//                   Navigator.push(
//                     context,
//                     MaterialPageRoute(
//                       builder: (_) => const SearchProductsPage(),
//                     ),
//                   );
//                 }
//               },
//             ),
//             _buildModernCard(
//               icon: Icons.shopping_bag_rounded,
//               title: 'المنتجات',
//               subtitle: 'عرض المنتجات',
//               gradientColors: const [Color(0xFFBD5CFF), Color(0xFF9D4EDD)],
//               delay: 100,
//               onTap: () {
//                 Navigator.push(
//                   context,
//                   MaterialPageRoute(builder: (_) => POSPage()),
//                 );
//               },
//             ),
//             _buildModernCard(
//               icon: Icons.book_rounded,
//               title: 'دفتر اليومية',
//               subtitle: 'السجلات اليومية',
//               gradientColors: const [Color(0xFF06FFA5), Color(0xFF00D9FF)],
//               delay: 200,
//               onTap: () {
//                 Navigator.push(
//                   context,
//                   MaterialPageRoute(
//                     builder: (_) =>
//                         const PlaceholderPage(title: 'دفتر اليومية'),
//                   ),
//                 );
//               },
//             ),
//             _buildModernCard(
//               icon: Icons.point_of_sale_rounded,
//               title: 'المبيعات',
//               subtitle: 'الفواتير والمبيعات',
//               gradientColors: const [Color(0xFFFFB347), Color(0xFFFFCC33)],
//               delay: 300,
//               onTap: () {
//                 Navigator.push(
//                   context,
//                   MaterialPageRoute(builder: (_) => const HomeInvoice()),
//                 );
//               },
//             ),
//             _buildModernCard(
//               icon: Icons.settings_rounded,
//               title: 'الإعدادات',
//               subtitle: 'إعدادات النظام',
//               gradientColors: const [Color(0xFF5A189A), Color(0xFF7B2CBF)],
//               delay: 400,
//               onTap: () {
//                 Navigator.push(
//                   context,
//                   MaterialPageRoute(
//                     builder: (_) => const PlaceholderPage(title: 'الإعدادات'),
//                   ),
//                 );
//               },
//             ),
//           ],
//         );
//       },
//     );
//   }
//
//   Widget _buildModernCard({
//     required IconData icon,
//     required String title,
//     required String subtitle,
//     required List<Color> gradientColors,
//     required int delay,
//     required VoidCallback onTap,
//   }) {
//     return TweenAnimationBuilder<double>(
//       tween: Tween(begin: 0.0, end: 1.0),
//       duration: Duration(milliseconds: 600 + delay),
//       curve: Curves.easeOutBack,
//       builder: (context, value, child) {
//         // Ensure opacity is always between 0.0 and 1.0
//         final clampedValue = value.clamp(0.0, 1.0);
//         return Transform.scale(
//           scale: clampedValue,
//           child: Opacity(opacity: clampedValue, child: child),
//         );
//       },
//       child: LayoutBuilder(
//         builder: (context, constraints) {
//           final maxHeight = constraints.maxHeight;
//           final iconSize = maxHeight * 0.25;
//           final iconPadding = maxHeight * 0.08;
//           final titleSize = maxHeight * 0.12;
//           final subtitleSize = maxHeight * 0.08;
//
//           return Container(
//             decoration: BoxDecoration(
//               borderRadius: BorderRadius.circular(24),
//               boxShadow: [
//                 BoxShadow(
//                   color: gradientColors[0].withOpacity(0.4),
//                   blurRadius: 25,
//                   offset: const Offset(0, 12),
//                   spreadRadius: 2,
//                 ),
//               ],
//             ),
//             child: Material(
//               color: Colors.transparent,
//               borderRadius: BorderRadius.circular(24),
//               child: InkWell(
//                 onTap: onTap,
//                 borderRadius: BorderRadius.circular(24),
//                 splashColor: Colors.white.withOpacity(0.2),
//                 highlightColor: Colors.white.withOpacity(0.1),
//                 child: Container(
//                   decoration: BoxDecoration(
//                     gradient: LinearGradient(
//                       begin: Alignment.topLeft,
//                       end: Alignment.bottomRight,
//                       colors: gradientColors,
//                     ),
//                     borderRadius: BorderRadius.circular(24),
//                     border: Border.all(
//                       color: Colors.white.withOpacity(0.2),
//                       width: 1.5,
//                     ),
//                   ),
//                   padding: EdgeInsets.symmetric(
//                     horizontal: constraints.maxWidth * 0.1,
//                     vertical: maxHeight * 0.1,
//                   ),
//                   child: Column(
//                     mainAxisAlignment: MainAxisAlignment.center,
//                     mainAxisSize: MainAxisSize.min,
//                     children: [
//                       Container(
//                         padding: EdgeInsets.all(iconPadding),
//                         decoration: BoxDecoration(
//                           color: Colors.white.withOpacity(0.25),
//                           borderRadius: BorderRadius.circular(16),
//                           border: Border.all(
//                             color: Colors.white.withOpacity(0.3),
//                             width: 1,
//                           ),
//                         ),
//                         child: Icon(
//                           icon,
//                           size: iconSize.clamp(28.0, 50.0),
//                           color: Colors.white,
//                         ),
//                       ),
//                       SizedBox(height: maxHeight * 0.08),
//                       Flexible(
//                         child: Text(
//                           title,
//                           style: TextStyle(
//                             fontSize: titleSize.clamp(16.0, 24.0),
//                             fontWeight: FontWeight.w800,
//                             color: Colors.white,
//                             letterSpacing: 0.5,
//                           ),
//                           textAlign: TextAlign.center,
//                           maxLines: 1,
//                           overflow: TextOverflow.ellipsis,
//                         ),
//                       ),
//                       SizedBox(height: maxHeight * 0.03),
//                       Flexible(
//                         child: Text(
//                           subtitle,
//                           style: TextStyle(
//                             fontSize: subtitleSize.clamp(11.0, 15.0),
//                             color: Colors.white.withOpacity(0.9),
//                             fontWeight: FontWeight.w500,
//                             letterSpacing: 0.3,
//                           ),
//                           textAlign: TextAlign.center,
//                           maxLines: 1,
//                           overflow: TextOverflow.ellipsis,
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//               ),
//             ),
//           );
//         },
//       ),
//     );
//   }
// }
import 'package:flutter/material.dart';
import 'package:stock_up/core/resources/style_manager.dart';
import 'package:stock_up/core/utils/cashed_data_shared_preferences.dart';
import 'package:stock_up/core/widgets/animated_background.dart';
import 'package:stock_up/features/AuditItems/presentation/pages/AuditItems_page.dart';
import 'package:stock_up/features/Inventory/presentation/widgets/inventory_list_page.dart';
import 'package:stock_up/features/ManagerHome/presentation/widgets/placeholder_page.dart';
import 'package:stock_up/features/POSPage/presentation/pages/POSPage_page.dart';

class ManagerHome extends StatefulWidget {
  const ManagerHome({super.key});

  @override
  State<ManagerHome> createState() => _ManagerHomeState();
}

class _ManagerHomeState extends State<ManagerHome>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;
  bool _isFirstLoad = true;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    );
    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Stack(
        children: [
          // الخلفية المتحركة البريميوم
          const AnimatedGradientBackground(),

          // المحتوى الرئيسي
          SafeArea(
            child: Column(
              children: [
                _buildPremiumHeader(),
                Expanded(
                  child: FadeTransition(
                    opacity: _fadeAnimation,
                    child: _buildMenuGrid(),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPremiumHeader() {
    return Container(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'مرحباً بك',
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.white.withOpacity(0.8),
                        fontWeight: FontWeight.w500,
                        letterSpacing: 0.5,
                      ),
                    ),
                    const SizedBox(height: 6),
                    ShaderMask(
                      shaderCallback: (bounds) => const LinearGradient(
                        colors: [Color(0xFFFFFFFF), Color(0xFFE0AAFF)],
                      ).createShader(bounds),
                      child: const Text(
                        'لوحة التحكم',
                        style: TextStyle(
                          fontSize: 32,
                          fontWeight: FontWeight.w900,
                          color: Colors.white,
                          letterSpacing: 1,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Row(
                children: [
                  _buildHeaderButton(
                    icon: Icons.notifications_rounded,
                    onPressed: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Row(
                            children: [
                              Icon(Icons.info_outline, color: Colors.white),
                              const SizedBox(width: 12),
                              Text('لا توجد إشعارات جديدة'),
                            ],
                          ),
                          backgroundColor: Color(0xFF9D4EDD),
                          behavior: SnackBarBehavior.floating,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                      );
                    },
                  ),
                  const SizedBox(width: 12),
                  _buildHeaderButton(
                    icon: Icons.person_rounded,
                    onPressed: () {
                      _showUserProfileDialog();
                    },
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildHeaderButton({
    required IconData icon,
    required VoidCallback onPressed,
  }) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Colors.white.withOpacity(0.2),
            Colors.white.withOpacity(0.1),
          ],
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.white.withOpacity(0.3), width: 1.5),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: IconButton(
        icon: Icon(icon, size: 24),
        color: Colors.white,
        onPressed: onPressed,
      ),
    );
  }

  void _showUserProfileDialog() {
    final userName =
        CacheService.getData(key: CacheKeys.userName) ?? 'المستخدم';
    final userRole = CacheService.getData(key: CacheKeys.userRole) ?? 'موظف';

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        backgroundColor: Color(0xFF1A1A2E),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFF9D4EDD), Color(0xFF7B2CBF)],
                ),
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: Color(0xFF9D4EDD).withOpacity(0.5),
                    blurRadius: 20,
                    spreadRadius: 5,
                  ),
                ],
              ),
              child: Icon(Icons.person_rounded, size: 40, color: Colors.white),
            ),
            const SizedBox(height: 16),
            Text(
              userName,
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 8),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 6),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Color(0xFF9D4EDD).withOpacity(0.3),
                    Color(0xFF7B2CBF).withOpacity(0.3),
                  ],
                ),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: Colors.white.withOpacity(0.3)),
              ),
              child: Text(
                userRole,
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.white.withOpacity(0.9),
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('إغلاق', style: TextStyle(color: Color(0xFF9D4EDD))),
          ),
        ],
      ),
    );
  }

  Widget _buildMenuGrid() {
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
            _buildPremiumCard(
              icon: Icons.inventory_2_rounded,
              title: 'الجرد',
              subtitle: 'إدارة المخزون',
              gradientColors: const [Color(0xFF9D4EDD), Color(0xFF7B2CBF)],
              delay: 0,
              onTap: () {
                if (CacheService.getData(key: CacheKeys.userRole) == 'admin') {
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
            _buildPremiumCard(
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
            _buildPremiumCard(
              icon: Icons.book_rounded,
              title: 'دفتر اليومية',
              subtitle: 'السجلات اليومية',
              gradientColors: const [Color(0xFF4ADE80), Color(0xFF22C55E)],
              // أخضر هادئ وحيوي
              delay: 200,
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
            _buildPremiumCard(
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
            _buildPremiumCard(
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
            _buildPremiumCard(
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
          ],
        );
      },
    );
  }

  Widget _buildPremiumCard({
    required IconData icon,
    required String title,
    required String subtitle,
    required List<Color> gradientColors,
    required int delay,
    required VoidCallback onTap,
  }) {
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0.0, end: 1.0),
      duration: Duration(milliseconds: 600 + delay),
      curve: Curves.easeOutBack,
      builder: (context, value, child) {
        final clampedValue = value.clamp(0.0, 1.0);
        return Transform.scale(
          scale: clampedValue,
          child: Opacity(opacity: clampedValue, child: child),
        );
      },
      child: LayoutBuilder(
        builder: (context, constraints) {
          final maxHeight = constraints.maxHeight;
          final iconSize = maxHeight * 0.20;
          final iconPadding = maxHeight * 0.08;
          final titleSize = maxHeight * 0.12;
          final subtitleSize = maxHeight * 0.08;

          return Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(24),
              boxShadow: [
                BoxShadow(
                  color: gradientColors[0].withOpacity(0.4),
                  blurRadius: 25,
                  offset: const Offset(0, 12),
                  spreadRadius: 2,
                ),
              ],
            ),
            child: Material(
              color: Colors.transparent,
              borderRadius: BorderRadius.circular(24),
              child: InkWell(
                onTap: onTap,
                borderRadius: BorderRadius.circular(24),
                splashColor: Colors.white.withOpacity(0.2),
                highlightColor: Colors.white.withOpacity(0.1),
                child: Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: gradientColors,
                    ),
                    borderRadius: BorderRadius.circular(24),
                    border: Border.all(
                      color: Colors.white.withOpacity(0.2),
                      width: 1.5,
                    ),
                  ),
                  padding: EdgeInsets.symmetric(
                    horizontal: constraints.maxWidth * 0.1,
                    vertical: maxHeight * 0.1,
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        padding: EdgeInsets.all(iconPadding),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.25),
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(
                            color: Colors.white.withOpacity(0.3),
                            width: 1,
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.1),
                              blurRadius: 8,
                              offset: Offset(0, 4),
                            ),
                          ],
                        ),
                        child: Icon(
                          icon,
                          size: iconSize.clamp(28.0, 50.0),
                          color: Colors.white,
                        ),
                      ),
                      SizedBox(height: maxHeight * 0.05),
                      Flexible(
                        child: Text(
                          title,
                          style: getSemiBoldStyle(
                            color: Colors.white,
                            fontSize: titleSize.clamp(16.0, 24.0),
                          ),
                          textAlign: TextAlign.center,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      SizedBox(height: maxHeight * 0.04),
                      Flexible(
                        child: Text(
                          subtitle,
                          style: TextStyle(
                            fontSize: subtitleSize.clamp(11.0, 15.0),
                            color: Colors.white.withOpacity(0.9),
                            fontWeight: FontWeight.w500,
                            letterSpacing: 0.3,
                          ),
                          textAlign: TextAlign.center,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
