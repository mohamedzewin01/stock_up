import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:stock_up/features/Summary/presentation/bloc/summary_accounts_cubit.dart';
import 'package:stock_up/features/Summary/presentation/widgets/summary_widgets.dart';

class SummaryAccountsPage extends StatefulWidget {
  const SummaryAccountsPage({super.key});

  @override
  State<SummaryAccountsPage> createState() => _SummaryAccountsPageState();
}

class _SummaryAccountsPageState extends State<SummaryAccountsPage> {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SummaryAccountsCubit, SummaryAccountsState>(
      builder: (context, state) {
        if (state is SummaryAccountsSuccess) {
          final accounts = state.summaryAccountsEntity?.results ?? [];
          if (accounts.isEmpty) {
            return const SliverToBoxAdapter(child: EmptyAccountsPlaceholder());
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
          return const SliverToBoxAdapter(child: SummaryLoadingCard());
        } else if (state is SummaryAccountsError) {
          return SliverToBoxAdapter(
            child: Container(
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
                    'حدث خطأ في تحميل الحسابات',
                    style: TextStyle(color: Color(0xFF64748B), fontSize: 14),
                  ),
                ],
              ),
            ),
          );
        }
        return const SliverToBoxAdapter(child: SizedBox.shrink());
      },
    );
  }
}
