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
                          child: Column(
                            children: [
                              FinancialSummaryCard(
                                title: 'النقدية',
                                icon: Icons.account_balance_wallet,
                                color: const Color(0xFF10B981),
                                finalBalance:
                                    summary?.treasury?.finalBalance ?? '0',
                                movements: summary?.treasury?.movements ?? [],
                              ),
                              const SizedBox(height: 12),
                              FinancialSummaryCard(
                                title: 'البنك',
                                icon: Icons.account_balance,
                                color: const Color(0xFF3B82F6),
                                finalBalance:
                                    summary?.bank?.finalBalance ?? '0',
                                movements: summary?.bank?.movements ?? [],
                              ),
                            ],
                          ),
                        );
                      } else if (state is SummaryLoading) {
                        return const SummaryLoadingCard();
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

                // Accounts List
                BlocBuilder<SummaryAccountsCubit, SummaryAccountsState>(
                  builder: (context, state) {
                    if (state is SummaryAccountsSuccess) {
                      final accounts =
                          state.summaryAccountsEntity?.results ?? [];
                      if (accounts.isEmpty) {
                        return const SliverToBoxAdapter(
                          child: EmptyAccountsPlaceholder(),
                        );
                      }
                      return SliverPadding(
                        padding: const EdgeInsets.fromLTRB(16, 0, 16, 20),
                        sliver: SliverList(
                          delegate: SliverChildBuilderDelegate((
                            context,
                            index,
                          ) {
                            return AccountCard(account: accounts[index]);
                          }, childCount: accounts.length),
                        ),
                      );
                    } else if (state is SummaryAccountsLoading) {
                      return const SliverToBoxAdapter(
                        child: SummaryLoadingCard(),
                      );
                    }
                    return const SliverToBoxAdapter(child: SizedBox.shrink());
                  },
                ),

                // Bottom Padding
                const SliverToBoxAdapter(child: SizedBox(height: 20)),
              ],
            ),
          ),
        ),
      ),
    );
  }
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
                        child: Column(
                          children: [
                            FinancialSummaryCard(
                              title: 'النقدية',
                              icon: Icons.account_balance_wallet,
                              color: const Color(0xFF10B981),
                              finalBalance:
                                  summary?.treasury?.finalBalance ?? '0',
                              movements: summary?.treasury?.movements ?? [],
                            ),
                            const SizedBox(height: 12),
                            FinancialSummaryCard(
                              title: 'البنك',
                              icon: Icons.account_balance,
                              color: const Color(0xFF3B82F6),
                              finalBalance: summary?.bank?.finalBalance ?? '0',
                              movements: summary?.bank?.movements ?? [],
                            ),
                          ],
                        ),
                      );
                    } else if (state is SummaryLoading) {
                      return const SummaryLoadingCard();
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

              // Accounts List
              BlocBuilder<SummaryAccountsCubit, SummaryAccountsState>(
                builder: (context, state) {
                  if (state is SummaryAccountsSuccess) {
                    final accounts = state.summaryAccountsEntity?.results ?? [];
                    if (accounts.isEmpty) {
                      return const SliverToBoxAdapter(
                        child: EmptyAccountsPlaceholder(),
                      );
                    }
                    return SliverPadding(
                      padding: const EdgeInsets.fromLTRB(16, 0, 16, 20),
                      sliver: SliverList(
                        delegate: SliverChildBuilderDelegate((context, index) {
                          return AccountCard(account: accounts[index]);
                        }, childCount: accounts.length),
                      ),
                    );
                  } else if (state is SummaryAccountsLoading) {
                    return const SliverToBoxAdapter(
                      child: SummaryLoadingCard(),
                    );
                  }
                  return const SliverToBoxAdapter(child: SizedBox.shrink());
                },
              ),

              // Bottom Padding
              const SliverToBoxAdapter(child: SizedBox(height: 20)),
            ],
          ),
        ),
      ),
    ),
  );
}

Widget _buildFinancialSummary(Summary? summary) {
  return Padding(
    padding: const EdgeInsets.all(16),
    child: Column(
      children: [
        // Treasury Card
        _buildFinancialCard(
          title: 'النقدية',
          icon: Icons.account_balance_wallet,
          color: const Color(0xFF10B981),
          finalBalance: summary?.treasury?.finalBalance ?? '0',
          movements: summary?.treasury?.movements ?? [],
        ),
        const SizedBox(height: 12),
        // Bank Card
        _buildFinancialCard(
          title: 'البنك',
          icon: Icons.account_balance,
          color: const Color(0xFF3B82F6),
          finalBalance: summary?.bank?.finalBalance ?? '0',
          movements: summary?.bank?.movements ?? [],
        ),
      ],
    ),
  );
}

Widget _buildFinancialCard({
  required String title,
  required IconData icon,
  required Color color,
  required String finalBalance,
  required List<Movements> movements,
}) {
  final formatter = NumberFormat('#,##0.00', 'en_US');
  final balance = double.tryParse(finalBalance) ?? 0.0;

  return Container(
    decoration: BoxDecoration(
      color: const Color(0xFF1E293B),
      borderRadius: BorderRadius.circular(16),
      border: Border.all(color: color.withOpacity(0.2), width: 1),
    ),
    child: Column(
      children: [
        // Header
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(16),
              topRight: Radius.circular(16),
            ),
          ),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(icon, color: color, size: 24),
              ),
              const SizedBox(width: 12),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      color: color,
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    'الرصيد النهائي',
                    style: const TextStyle(
                      color: Color(0xFF64748B),
                      fontSize: 10,
                    ),
                  ),
                ],
              ),
              const Spacer(),
              Text(
                formatter.format(balance),
                style: TextStyle(
                  color: color,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
        // Movements
        Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: movements.map((movement) {
              final incoming =
                  double.tryParse(movement.totalIncoming ?? '0') ?? 0.0;
              final outgoing =
                  double.tryParse(movement.totalOutgoing ?? '0') ?? 0.0;

              return Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: Row(
                  children: [
                    Container(
                      width: 4,
                      height: 4,
                      decoration: BoxDecoration(
                        color: const Color(0xFF64748B),
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      movement.movementType ?? '',
                      style: const TextStyle(
                        color: Color(0xFF94A3B8),
                        fontSize: 11,
                      ),
                    ),
                    const Spacer(),
                    if (incoming > 0) ...[
                      const Icon(
                        Icons.arrow_downward,
                        color: Color(0xFF10B981),
                        size: 12,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        formatter.format(incoming),
                        style: const TextStyle(
                          color: Color(0xFF10B981),
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(width: 12),
                    ],
                    if (outgoing > 0) ...[
                      const Icon(
                        Icons.arrow_upward,
                        color: Color(0xFFEF4444),
                        size: 12,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        formatter.format(outgoing),
                        style: const TextStyle(
                          color: Color(0xFFEF4444),
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ],
                ),
              );
            }).toList(),
          ),
        ),
      ],
    ),
  );
}

Widget _buildAccountTypeFilter() {
  return Container(
    decoration: BoxDecoration(
      color: const Color(0xFF1E293B),
      borderRadius: BorderRadius.circular(8),
      border: Border.all(color: const Color(0xFF334155), width: 1),
    ),
    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
    child: DropdownButton<String>(
      value: selectedAccountType,
      underline: const SizedBox(),
      dropdownColor: const Color(0xFF1E293B),
      icon: const Icon(
        Icons.arrow_drop_down,
        color: Color(0xFF94A3B8),
        size: 20,
      ),
      style: const TextStyle(color: Color(0xFFF1F5F9), fontSize: 12),
      items: ['الكل', 'عميل', 'مورد', 'اخرى'].map((String value) {
        return DropdownMenuItem<String>(value: value, child: Text(value));
      }).toList(),
      onChanged: (String? newValue) {
        if (newValue != null) {
          setState(() {
            selectedAccountType = newValue;
          });
          _loadData();
        }
      },
    ),
  );
}

Widget _buildAccountCard(Results account) {
  final formatter = NumberFormat('#,##0.00', 'en_US');
  final debit = double.tryParse(account.balanceDebit ?? '0') ?? 0.0;
  final credit = double.tryParse(account.balanceCredit ?? '0') ?? 0.0;
  final balance = debit - credit;

  Color accountColor;
  String accountTypeText;
  switch (account.accountType) {
    case 'عميل':
      accountColor = const Color(0xFF8B5CF6);
      accountTypeText = 'عميل';
      break;
    case 'مورد':
      accountColor = const Color(0xFFF59E0B);
      accountTypeText = 'مورد';
      break;
    default:
      accountColor = const Color(0xFF6366F1);
      accountTypeText = 'أخرى';
  }

  return Container(
    margin: const EdgeInsets.only(bottom: 8),
    decoration: BoxDecoration(
      color: const Color(0xFF1E293B),
      borderRadius: BorderRadius.circular(12),
      border: Border.all(color: const Color(0xFF334155), width: 1),
    ),
    child: Padding(
      padding: const EdgeInsets.all(14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: accountColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(6),
                  border: Border.all(
                    color: accountColor.withOpacity(0.3),
                    width: 1,
                  ),
                ),
                child: Text(
                  accountTypeText,
                  style: TextStyle(
                    color: accountColor,
                    fontSize: 10,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  account.accountName ?? '',
                  style: const TextStyle(
                    color: Color(0xFFF1F5F9),
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              Text(
                formatter.format(balance.abs()),
                style: TextStyle(
                  color: balance >= 0
                      ? const Color(0xFF10B981)
                      : const Color(0xFFEF4444),
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              _buildBalanceItem('مدين', debit, const Color(0xFF10B981)),
              const SizedBox(width: 16),
              _buildBalanceItem('دائن', credit, const Color(0xFFEF4444)),
            ],
          ),
          if (account.mobile?.isNotEmpty == true) ...[
            const SizedBox(height: 8),
            Row(
              children: [
                const Icon(Icons.phone, color: Color(0xFF64748B), size: 12),
                const SizedBox(width: 4),
                Text(
                  account.mobile ?? '',
                  style: const TextStyle(
                    color: Color(0xFF64748B),
                    fontSize: 10,
                  ),
                ),
              ],
            ),
          ],
        ],
      ),
    ),
  );
}

Widget _buildBalanceItem(String label, double value, Color color) {
  final formatter = NumberFormat('#,##0.00', 'en_US');
  return Row(
    children: [
      Container(
        width: 6,
        height: 6,
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(3),
        ),
      ),
      const SizedBox(width: 6),
      Text(
        label,
        style: const TextStyle(color: Color(0xFF64748B), fontSize: 10),
      ),
      const SizedBox(width: 6),
      Text(
        formatter.format(value),
        style: TextStyle(
          color: color,
          fontSize: 11,
          fontWeight: FontWeight.w600,
        ),
      ),
    ],
  );
}

Widget _buildLoadingCard() {
  return Container(
    margin: const EdgeInsets.all(16),
    padding: const EdgeInsets.all(32),
    decoration: BoxDecoration(
      color: const Color(0xFF1E293B),
      borderRadius: BorderRadius.circular(16),
    ),
    child: const Center(
      child: CircularProgressIndicator(
        color: Color(0xFF6366F1),
        strokeWidth: 2,
      ),
    ),
  );
}
