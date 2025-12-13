import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:stock_up/core/utils/cashed_data_shared_preferences.dart';
import 'package:stock_up/features/Home/presentation/widgets/dashboard_header_section.dart';
import 'package:stock_up/features/Home/presentation/widgets/dashboard_stats_bar.dart';
import 'package:stock_up/features/Stores/presentation/bloc/Stores_cubit.dart';
import 'package:stock_up/features/Summary/presentation/bloc/Summary_cubit.dart';

import '../../../../core/di/di.dart';

class SummaryPage extends StatefulWidget {
  const SummaryPage({super.key});

  @override
  State<SummaryPage> createState() => _SummaryPageState();
}

class _SummaryPageState extends State<SummaryPage>
    with SingleTickerProviderStateMixin {
  late SummaryCubit summaryCubit;
  late StoresCubit storesCubit;

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
