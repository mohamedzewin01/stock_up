//
// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:intl/intl.dart';
// import 'package:stock_up/core/di/di.dart';
// import 'package:stock_up/core/utils/cashed_data_shared_preferences.dart';
// import 'package:stock_up/features/Home/presentation/widgets/dashboard_header_section.dart';
// import 'package:stock_up/features/Home/presentation/widgets/dashboard_menu_section.dart';
// import 'package:stock_up/features/Home/presentation/widgets/dashboard_stats_bar.dart';
// import 'package:stock_up/features/Stores/presentation/bloc/Stores_cubit.dart';
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
//   late StoresCubit storesCubit; // ✅ إضافة
//
//   @override
//   void initState() {
//     super.initState();
//     summaryCubit = getIt.get<SummaryCubit>();
//     storesCubit = getIt.get<StoresCubit>(); // ✅ إضافة
//
//     storesCubit.getAllStores(); // ✅ جلب المتاجر
//     _loadSummary();
//   }
//
//   void _loadSummary() {
//     // جلب storeId من الكاش
//     final storeId = CacheService.getData(key: CacheKeys.storeId) ?? 1;
//
//     // تحديد تواريخ الشهر الحالي
//     final now = DateTime.now();
//     final date = DateTime(now.year, now.month, 1);
//
//     final operationDate = DateFormat('2025-12-10').format(date);
//
//     summaryCubit.summary(storeId, operationDate);
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return MultiBlocProvider(
//       providers: [
//         BlocProvider.value(value: summaryCubit),
//         BlocProvider.value(value: storesCubit), // الحل هنا!
//       ],
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
//                 // ✅ صحيح
//                 SliverToBoxAdapter(
//                   child: DashboardHeaderSection(onStoreChanged: _loadSummary),
//                 ),
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

///
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
  late StoresCubit storesCubit;

  // التاريخ المحدد - القيمة الافتراضية هي اليوم
  DateTime selectedDate = DateTime.now();

  @override
  void initState() {
    super.initState();
    summaryCubit = getIt.get<SummaryCubit>();
    storesCubit = getIt.get<StoresCubit>();

    storesCubit.getAllStores();
    _loadSummary();
  }

  void _loadSummary() {
    // جلب storeId من الكاش
    final storeId = CacheService.getData(key: CacheKeys.storeId) ?? 1;

    // تنسيق التاريخ المحدد
    final operationDate = DateFormat('yyyy-MM-dd').format(selectedDate);

    summaryCubit.summary(storeId, operationDate);
  }

  // دالة لتحديث التاريخ
  void _onDateChanged(DateTime newDate) {
    setState(() {
      selectedDate = newDate;
    });
    _loadSummary();
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider.value(value: summaryCubit),
        BlocProvider.value(value: storesCubit),
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
                // Header Section with Date Picker
                SliverToBoxAdapter(
                  child: DashboardHeaderSection(
                    onStoreChanged: _loadSummary,
                    selectedDate: selectedDate,
                    onDateChanged: _onDateChanged,
                  ),
                ),

                // Stats Bar - Dynamic Data
                if (CacheService.getData(key: CacheKeys.userRole) == 'super')
                  SliverToBoxAdapter(
                    child: BlocBuilder<SummaryCubit, SummaryState>(
                      builder: (context, state) {
                        if (state is SummarySuccess) {
                          return DashboardStatsBar(
                            summaryEntity: state.summary,
                          );
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
