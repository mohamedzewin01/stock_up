import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:stock_up/core/utils/cashed_data_shared_preferences.dart';
import 'package:stock_up/features/Home/presentation/widgets/dashboard_header_section.dart';
import 'package:stock_up/features/Stores/presentation/bloc/Stores_cubit.dart';
import 'package:stock_up/features/Summary/presentation/bloc/Summary_cubit.dart';
import 'package:stock_up/features/Summary/presentation/bloc/summary_accounts_cubit.dart';
import 'package:stock_up/features/Summary/presentation/widgets/accounts_tab.dart';
import 'package:stock_up/features/Summary/presentation/widgets/financial_tab.dart';

import '../../../../core/di/di.dart';

class SummaryPage extends StatefulWidget {
  const SummaryPage({super.key});

  @override
  State<SummaryPage> createState() => _SummaryPageState();
}

class _SummaryPageState extends State<SummaryPage>
    with SingleTickerProviderStateMixin {
  late SummaryCubit summaryCubit;
  late SummaryAccountsCubit summaryAccountsCubit;
  late StoresCubit storesCubit;
  late TabController _tabController;

  DateTime selectedDate = DateTime.now();
  String selectedAccountType = 'الكل';

  @override
  void initState() {
    super.initState();
    summaryCubit = getIt.get<SummaryCubit>();
    summaryAccountsCubit = getIt.get<SummaryAccountsCubit>();
    storesCubit = getIt.get<StoresCubit>();

    _tabController = TabController(length: 2, vsync: this);

    storesCubit.getAllStores();
    _loadAllData();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  void _loadAllData() {
    _loadFinancialSummary();
    _loadAccounts();
  }

  void _loadFinancialSummary() {
    final storeId = CacheService.getData(key: CacheKeys.storeId) ?? 1;
    final operationDate = DateFormat('yyyy-MM-dd').format(selectedDate);
    summaryCubit.summary(storeId, operationDate);
  }

  void _loadAccounts() {
    final storeId = CacheService.getData(key: CacheKeys.storeId) ?? 1;
    summaryAccountsCubit.summaryAccounts(
      storeId,
      selectedAccountType == 'الكل' ? null : selectedAccountType,
      null,
      1,
      300,
      true,
    );
  }

  void _onDateChanged(DateTime newDate) {
    setState(() {
      selectedDate = newDate;
    });
    _loadAllData();
  }

  void _onAccountTypeChanged(String newType) {
    setState(() {
      selectedAccountType = newType;
    });
    _loadAccounts();
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isMobile = screenWidth < 600;

    return MultiBlocProvider(
      providers: [
        BlocProvider.value(value: summaryCubit),
        BlocProvider.value(value: summaryAccountsCubit),
        BlocProvider.value(value: storesCubit),
      ],
      child: Scaffold(
        backgroundColor: const Color(0xFF0F172A),
        body: SafeArea(
          child: Column(
            children: [
              // Header
              DashboardHeaderSection(
                onStoreChanged: _loadAllData,
                selectedDate: selectedDate,
                onDateChanged: _onDateChanged,
              ),

              // Custom Tab Bar
              Container(
                margin: EdgeInsets.symmetric(horizontal: isMobile ? 12 : 16),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0xFF1E293B), Color(0xFF0F172A)],
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                  ),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: const Color(0xFF334155),
                    width: 1.5,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.2),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: TabBar(
                  controller: _tabController,
                  indicator: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [Color(0xFF6366F1), Color(0xFF8B5CF6)],
                      begin: Alignment.topRight,
                      end: Alignment.bottomLeft,
                    ),
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: const Color(0xFF6366F1).withOpacity(0.3),
                        blurRadius: 8,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  indicatorSize: TabBarIndicatorSize.tab,
                  dividerColor: Colors.transparent,
                  labelColor: Colors.white,
                  unselectedLabelColor: const Color(0xFF94A3B8),
                  labelStyle: TextStyle(
                    fontSize: isMobile ? 10 : 12,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 0.3,
                  ),
                  unselectedLabelStyle: TextStyle(
                    fontSize: isMobile ? 10 : 12,
                    fontWeight: FontWeight.w600,
                  ),
                  tabs: [
                    Tab(
                      icon: Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: _tabController.index == 0
                              ? Colors.white.withOpacity(0.2)
                              : Colors.transparent,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Icon(
                          Icons.account_balance_wallet_rounded,
                          size: isMobile ? 16 : 20,
                        ),
                      ),
                      text: 'الملخص المالي',
                    ),
                    Tab(
                      icon: Container(
                        padding: const EdgeInsets.all(2),
                        decoration: BoxDecoration(
                          color: _tabController.index == 1
                              ? Colors.white.withOpacity(0.2)
                              : Colors.transparent,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Icon(
                          Icons.people_rounded,
                          size: isMobile ? 16 : 20,
                        ),
                      ),
                      text: 'الحسابات',
                    ),
                  ],
                ),
              ),

              // Tab Views
              Expanded(
                child: RefreshIndicator(
                  onRefresh: () async {
                    _loadAllData();
                  },
                  color: const Color(0xFF6366F1),
                  child: TabBarView(
                    controller: _tabController,

                    children: [
                      // Tab 1: Financial Summary
                      FinancialTab(
                        summaryCubit: summaryCubit,
                        isMobile: isMobile,
                      ),

                      // Tab 2: Accounts
                      AccountsTab(
                        summaryAccountsCubit: summaryAccountsCubit,
                        selectedAccountType: selectedAccountType,
                        onAccountTypeChanged: _onAccountTypeChanged,
                        isMobile: isMobile,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
