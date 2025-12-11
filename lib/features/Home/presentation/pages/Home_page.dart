// // import 'package:flutter/material.dart';
// // import 'package:stock_up/core/resources/style_manager.dart';
// // import 'package:stock_up/core/utils/cashed_data_shared_preferences.dart';
// // import 'package:stock_up/core/widgets/animated_background.dart';
// // import 'package:stock_up/features/Home/presentation/widgets/menu_grid.dart';
// // import 'package:stock_up/features/Home/presentation/widgets/premium_header.dart';
// //
// // class HomePage extends StatefulWidget {
// //   const HomePage({super.key});
// //
// //   @override
// //   State<HomePage> createState() => _HomePageState();
// // }
// //
// // class _HomePageState extends State<HomePage>
// //     with SingleTickerProviderStateMixin {
// //   late AnimationController _controller;
// //   late Animation<double> _fadeAnimation;
// //   bool _isFirstLoad = true;
// //
// //   @override
// //   void initState() {
// //     super.initState();
// //     _controller = AnimationController(
// //       duration: const Duration(milliseconds: 1000),
// //       vsync: this,
// //     );
// //     _fadeAnimation = Tween<double>(
// //       begin: 0.0,
// //       end: 1.0,
// //     ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));
// //     _controller.forward();
// //   }
// //
// //   @override
// //   void dispose() {
// //     _controller.dispose();
// //     super.dispose();
// //   }
// //
// //   @override
// //   Widget build(BuildContext context) {
// //     return Scaffold(
// //       backgroundColor: Colors.transparent,
// //       body: Stack(
// //         children: [
// //           const AnimatedGradientBackground(),
// //           SafeArea(
// //             child: Column(
// //               children: [
// //                 PremiumHeader(),
// //                 Expanded(
// //                   child: FadeTransition(
// //                     opacity: _fadeAnimation,
// //                     child: MenuGrid(),
// //                   ),
// //                 ),
// //                 ShaderMask(
// //                   shaderCallback: (bounds) => const LinearGradient(
// //                     colors: [Color(0xFFFFFFFF), Color(0xFFE0AAFF)],
// //                   ).createShader(bounds),
// //                   child: Text(
// //                     CacheService.getData(key: CacheKeys.storeName),
// //                     style: getBoldStyle(color: Colors.white, fontSize: 20),
// //                   ),
// //                 ),
// //                 SizedBox(height: 20),
// //               ],
// //             ),
// //           ),
// //         ],
// //       ),
// //     );
// //   }
// // }
//
// import 'package:flutter/material.dart';
// import 'package:stock_up/features/Home/presentation/widgets/dashboard_header_section.dart';
// import 'package:stock_up/features/Home/presentation/widgets/dashboard_menu_section.dart';
// import 'package:stock_up/features/Home/presentation/widgets/dashboard_stats_bar.dart';
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
//   @override
//   void initState() {
//     super.initState();
//   }
//
//   @override
//   void dispose() {
//     super.dispose();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: const Color(0xFF0F172A),
//       body: SafeArea(
//         child: CustomScrollView(
//           slivers: [
//             // Header Section
//             SliverToBoxAdapter(child: DashboardHeaderSection()),
//
//             // Stats Bar
//             SliverToBoxAdapter(child: DashboardStatsBar()),
//
//             // Menu Section
//             SliverToBoxAdapter(child: DashboardMenuSection()),
//
//             // Bottom padding
//             SliverToBoxAdapter(child: SizedBox(height: 20)),
//           ],
//         ),
//       ),
//     );
//   }
// }

// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:intl/intl.dart';
// import 'package:stock_up/core/di/di.dart';
// import 'package:stock_up/core/utils/cashed_data_shared_preferences.dart';
// import 'package:stock_up/features/Home/presentation/widgets/dashboard_header_section.dart';
// import 'package:stock_up/features/Home/presentation/widgets/dashboard_menu_section.dart';
// import 'package:stock_up/features/Home/presentation/widgets/dashboard_stats_bar.dart';
// import 'package:stock_up/features/Summary/presentation/bloc/Summary_cubit.dart';
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
//   late SummaryCubit summaryCubit;
//
//   @override
//   void initState() {
//     super.initState();
//     summaryCubit = getIt.get<SummaryCubit>();
//     _loadSummary();
//   }
//
//   void _loadSummary() {
//     // جلب storeId من الكاش
//     final storeId = CacheService.getData(key: CacheKeys.storeId) ?? 1;
//
//     // تحديد تواريخ الشهر الحالي
//     final now = DateTime.now();
//     final startDate = DateTime(now.year, now.month, 1);
//     final endDate = DateTime(now.year, now.month + 1, 0);
//
//     final startStr = DateFormat('2025-12-07').format(startDate);
//     final endStr = DateFormat('2025-12-07').format(endDate);
//
//     summaryCubit.summary(storeId, startStr, endStr);
//   }
//
//   @override
//   void dispose() {
//     super.dispose();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return BlocProvider.value(
//       value: summaryCubit,
//       child: Scaffold(
//         backgroundColor: const Color(0xFF0F172A),
//         body: SafeArea(
//           child: RefreshIndicator(
//             onRefresh: () async {
//               _loadSummary();
//             },
//             color: const Color(0xFF6366F1),
//             child: CustomScrollView(
//               slivers: [
//                 // Header Section
//                 const SliverToBoxAdapter(child: DashboardHeaderSection()),
//
//                 // Stats Bar - Dynamic Data
//                 SliverToBoxAdapter(
//                   child: BlocBuilder<SummaryCubit, SummaryState>(
//                     builder: (context, state) {
//                       if (state is SummarySuccess) {
//                         return DashboardStatsBar(summaryEntity: state.summary);
//                       } else if (state is SummaryLoading) {
//                         return const DashboardStatsBar(isLoading: true);
//                       } else if (state is SummaryFailure) {
//                         return const DashboardStatsBar(hasError: true);
//                       }
//                       return const DashboardStatsBar();
//                     },
//                   ),
//                 ),
//
//                 // Menu Section
//                 const SliverToBoxAdapter(child: DashboardMenuSection()),
//
//                 // Bottom padding
//                 const SliverToBoxAdapter(child: SizedBox(height: 20)),
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:stock_up/core/di/di.dart';
import 'package:stock_up/core/utils/cashed_data_shared_preferences.dart';
import 'package:stock_up/features/Home/presentation/widgets/dashboard_header_section.dart';
import 'package:stock_up/features/Home/presentation/widgets/dashboard_menu_section.dart';
import 'package:stock_up/features/Home/presentation/widgets/dashboard_stats_bar.dart';
import 'package:stock_up/features/Stores/presentation/bloc/Stores_cubit.dart';
import 'package:stock_up/features/Summary/presentation/bloc/Summary_cubit.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>
    with SingleTickerProviderStateMixin {
  late SummaryCubit summaryCubit;
  late StoresCubit storesCubit; // ✅ إضافة

  @override
  void initState() {
    super.initState();
    summaryCubit = getIt.get<SummaryCubit>();
    storesCubit = getIt.get<StoresCubit>(); // ✅ إضافة

    storesCubit.getAllStores(); // ✅ جلب المتاجر
    _loadSummary();
  }

  void _loadSummary() {
    // جلب storeId من الكاش
    final storeId = CacheService.getData(key: CacheKeys.storeId) ?? 1;

    // تحديد تواريخ الشهر الحالي
    final now = DateTime.now();
    final date = DateTime(now.year, now.month, 1);

    final operationDate = DateFormat('2025-12-10').format(date);

    summaryCubit.summary(storeId, operationDate);
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider.value(value: summaryCubit),
        BlocProvider.value(value: storesCubit), // الحل هنا!
      ],
      child: Scaffold(
        backgroundColor: const Color(0xFF0F172A),
        body: SafeArea(
          child: RefreshIndicator(
            onRefresh: () async {
              _loadSummary();
            },
            color: const Color(0xFF6366F1),
            child: CustomScrollView(
              slivers: [
                // Header Section
                // ✅ صحيح
                SliverToBoxAdapter(
                  child: DashboardHeaderSection(onStoreChanged: _loadSummary),
                ),

                // Stats Bar - Dynamic Data
                SliverToBoxAdapter(
                  child: BlocBuilder<SummaryCubit, SummaryState>(
                    builder: (context, state) {
                      if (state is SummarySuccess) {
                        return DashboardStatsBar(summaryEntity: state.summary);
                      } else if (state is SummaryLoading) {
                        return const DashboardStatsBar(isLoading: true);
                      } else if (state is SummaryFailure) {
                        return const DashboardStatsBar(hasError: true);
                      }
                      return const DashboardStatsBar();
                    },
                  ),
                ),

                // Menu Section
                const SliverToBoxAdapter(child: DashboardMenuSection()),

                // Bottom padding
                const SliverToBoxAdapter(child: SizedBox(height: 20)),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
