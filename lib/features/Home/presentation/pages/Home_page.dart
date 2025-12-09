// import 'package:flutter/material.dart';
// import 'package:stock_up/core/resources/style_manager.dart';
// import 'package:stock_up/core/utils/cashed_data_shared_preferences.dart';
// import 'package:stock_up/core/widgets/animated_background.dart';
// import 'package:stock_up/features/Home/presentation/widgets/menu_grid.dart';
// import 'package:stock_up/features/Home/presentation/widgets/premium_header.dart';
//
// class HomePage extends StatefulWidget {
//   const HomePage({super.key});
//
//   @override
//   State<HomePage> createState() => _HomePageState();
// }
//
// class _HomePageState extends State<HomePage>
//     with SingleTickerProviderStateMixin {
//   late AnimationController _controller;
//   late Animation<double> _fadeAnimation;
//   bool _isFirstLoad = true;
//
//   @override
//   void initState() {
//     super.initState();
//     _controller = AnimationController(
//       duration: const Duration(milliseconds: 1000),
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
//           const AnimatedGradientBackground(),
//           SafeArea(
//             child: Column(
//               children: [
//                 PremiumHeader(),
//                 Expanded(
//                   child: FadeTransition(
//                     opacity: _fadeAnimation,
//                     child: MenuGrid(),
//                   ),
//                 ),
//                 ShaderMask(
//                   shaderCallback: (bounds) => const LinearGradient(
//                     colors: [Color(0xFFFFFFFF), Color(0xFFE0AAFF)],
//                   ).createShader(bounds),
//                   child: Text(
//                     CacheService.getData(key: CacheKeys.storeName),
//                     style: getBoldStyle(color: Colors.white, fontSize: 20),
//                   ),
//                 ),
//                 SizedBox(height: 20),
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:stock_up/features/Home/presentation/widgets/dashboard_header_section.dart';
import 'package:stock_up/features/Home/presentation/widgets/dashboard_menu_section.dart';
import 'package:stock_up/features/Home/presentation/widgets/dashboard_stats_bar.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>
    with SingleTickerProviderStateMixin {
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0F172A),
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            // Header Section
            SliverToBoxAdapter(child: DashboardHeaderSection()),

            // Stats Bar
            SliverToBoxAdapter(child: DashboardStatsBar()),

            // Menu Section
            SliverToBoxAdapter(child: DashboardMenuSection()),

            // Bottom padding
            SliverToBoxAdapter(child: SizedBox(height: 20)),
          ],
        ),
      ),
    );
  }
}
