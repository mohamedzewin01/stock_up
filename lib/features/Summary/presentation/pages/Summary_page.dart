// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:intl/intl.dart';
// import 'package:stock_up/core/utils/cashed_data_shared_preferences.dart';
// import 'package:stock_up/features/Home/presentation/widgets/dashboard_header_section.dart';
// import 'package:stock_up/features/Home/presentation/widgets/dashboard_stats_bar.dart';
// import 'package:stock_up/features/Stores/presentation/bloc/Stores_cubit.dart';
// import 'package:stock_up/features/Summary/presentation/bloc/Summary_cubit.dart';
//
// import '../../../../core/di/di.dart';
//
// class SummaryPage extends StatefulWidget {
//   const SummaryPage({super.key});
//
//   @override
//   State<SummaryPage> createState() => _SummaryPageState();
// }
//
// class _SummaryPageState extends State<SummaryPage>
//     with SingleTickerProviderStateMixin {
//   late SummaryCubit summaryCubit;
//   late StoresCubit storesCubit;
//
//   DateTime selectedDate = DateTime.now();
//
//   @override
//   void initState() {
//     super.initState();
//     summaryCubit = getIt.get<SummaryCubit>();
//     storesCubit = getIt.get<StoresCubit>();
//
//     storesCubit.getAllStores();
//     _loadSummary();
//   }
//
//   void _loadSummary() {
//     // جلب storeId من الكاش
//     final storeId = CacheService.getData(key: CacheKeys.storeId) ?? 1;
//
//     // تنسيق التاريخ المحدد
//     final operationDate = DateFormat('yyyy-MM-dd').format(selectedDate);
//
//     summaryCubit.summary(storeId, operationDate);
//   }
//
//   // دالة لتحديث التاريخ
//   void _onDateChanged(DateTime newDate) {
//     setState(() {
//       selectedDate = newDate;
//     });
//     _loadSummary();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return MultiBlocProvider(
//       providers: [
//         BlocProvider.value(value: summaryCubit),
//         BlocProvider.value(value: storesCubit),
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
//                 // Header Section with Date Picker
//                 SliverToBoxAdapter(
//                   child: DashboardHeaderSection(
//                     onStoreChanged: _loadSummary,
//                     selectedDate: selectedDate,
//                     onDateChanged: _onDateChanged,
//                   ),
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
import 'package:stock_up/core/utils/cashed_data_shared_preferences.dart';
import 'package:stock_up/features/Home/presentation/widgets/dashboard_header_section.dart';
import 'package:stock_up/features/Stores/presentation/bloc/Stores_cubit.dart';
import 'package:stock_up/features/Summary/presentation/bloc/Summary_cubit.dart';
import 'package:stock_up/features/Summary/presentation/bloc/summary_accounts_cubit.dart';
import 'package:stock_up/features/Summary/presentation/widgets/summary_accounts_page.dart';
import 'package:stock_up/features/Summary/presentation/widgets/summary_widgets.dart';

import '../../../../core/di/di.dart';

class SummaryPage extends StatefulWidget {
  const SummaryPage({super.key});

  @override
  State<SummaryPage> createState() => _SummaryPageState();
}

class _SummaryPageState extends State<SummaryPage> {
  late SummaryCubit summaryCubit;
  late SummaryAccountsCubit summaryAccountsCubit;
  late StoresCubit storesCubit;

  DateTime selectedDate = DateTime.now();
  String selectedAccountType = 'الكل';

  @override
  void initState() {
    super.initState();
    summaryCubit = getIt.get<SummaryCubit>();
    summaryAccountsCubit = getIt.get<SummaryAccountsCubit>();
    storesCubit = getIt.get<StoresCubit>();

    storesCubit.getAllStores();
    _loadData();
  }

  void _loadData() {
    final storeId = CacheService.getData(key: CacheKeys.storeId) ?? 1;
    final operationDate = DateFormat('yyyy-MM-dd').format(selectedDate);

    summaryCubit.summary(storeId, operationDate);
    summaryAccountsCubit.summaryAccounts(
      storeId,
      selectedAccountType == 'الكل' ? null : selectedAccountType,
      null,
      1,
      20,
      true,
    );
  }

  void _onDateChanged(DateTime newDate) {
    setState(() {
      selectedDate = newDate;
    });
    _loadData();
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider.value(value: summaryCubit),
        BlocProvider.value(value: summaryAccountsCubit),
        BlocProvider.value(value: storesCubit),
      ],
      child: Scaffold(
        backgroundColor: const Color(0xFF0F172A),
        body: SafeArea(
          child: RefreshIndicator(
            onRefresh: () async {
              _loadData();
            },
            color: const Color(0xFF6366F1),
            child: CustomScrollView(
              slivers: [
                // Header
                SliverToBoxAdapter(
                  child: DashboardHeaderSection(
                    onStoreChanged: _loadData,
                    selectedDate: selectedDate,
                    onDateChanged: _onDateChanged,
                  ),
                ),

                // Financial Summary Section
                SliverToBoxAdapter(
                  child: BlocBuilder<SummaryCubit, SummaryState>(
                    builder: (context, state) {
                      if (state is SummarySuccess) {
                        final summary = state.summary?.summary;
                        return Padding(
                          padding: const EdgeInsets.all(16),
                          child: Row(
                            children: [
                              Expanded(
                                child: FinancialSummaryCard(
                                  title: 'النقدية',
                                  icon: Icons.account_balance_wallet,
                                  color: const Color(0xFF10B981),
                                  finalBalance:
                                      summary?.treasury?.finalBalance ?? '0',
                                  movements: summary?.treasury?.movements ?? [],
                                ),
                              ),
                              const SizedBox(height: 12),
                              Expanded(
                                child: FinancialSummaryCard(
                                  title: 'البنك',
                                  icon: Icons.account_balance,
                                  color: const Color(0xFF3B82F6),
                                  finalBalance:
                                      summary?.bank?.finalBalance ?? '0',
                                  movements: summary?.bank?.movements ?? [],
                                ),
                              ),
                            ],
                          ),
                        );
                      } else if (state is SummaryLoading) {
                        return const SummaryLoadingCard();
                      } else if (state is SummaryFailure) {
                        return Container(
                          margin: const EdgeInsets.all(16),
                          padding: const EdgeInsets.all(32),
                          decoration: BoxDecoration(
                            color: const Color(0xFF1E293B),
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(
                              color: const Color(0xFFEF4444).withOpacity(0.3),
                              width: 1,
                            ),
                          ),
                          child: Column(
                            children: [
                              Icon(
                                Icons.error_outline,
                                color: const Color(0xFFEF4444).withOpacity(0.5),
                                size: 48,
                              ),
                              const SizedBox(height: 12),
                              const Text(
                                'حدث خطأ في تحميل البيانات',
                                style: TextStyle(
                                  color: Color(0xFF64748B),
                                  fontSize: 14,
                                ),
                              ),
                            ],
                          ),
                        );
                      }
                      return const SizedBox.shrink();
                    },
                  ),
                ),

                // Account Type Filter Header
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(16, 20, 16, 12),
                    child: Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: const Color(0xFF6366F1).withOpacity(0.1),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: const Icon(
                            Icons.account_balance_wallet,
                            color: Color(0xFF6366F1),
                            size: 20,
                          ),
                        ),
                        const SizedBox(width: 12),
                        const Text(
                          'قائمة الحسابات',
                          style: TextStyle(
                            color: Color(0xFFF1F5F9),
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const Spacer(),
                        AccountTypeFilter(
                          selectedType: selectedAccountType,
                          onChanged: (newType) {
                            setState(() {
                              selectedAccountType = newType;
                            });
                            _loadData();
                          },
                        ),
                      ],
                    ),
                  ),
                ),

                SummaryAccountsPage(),

                const SliverToBoxAdapter(child: SizedBox(height: 20)),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
