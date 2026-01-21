import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:stock_up/features/Summary/data/models/response/summary_accounts_model.dart';
import 'package:stock_up/features/Summary/presentation/bloc/summary_accounts_cubit.dart';

class AccountsTab extends StatelessWidget {
  final SummaryAccountsCubit summaryAccountsCubit;
  final String selectedAccountType;
  final ValueChanged<String> onAccountTypeChanged;
  final bool isMobile;

  const AccountsTab({
    super.key,
    required this.summaryAccountsCubit,
    required this.selectedAccountType,
    required this.onAccountTypeChanged,
    required this.isMobile,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SummaryAccountsCubit, SummaryAccountsState>(
      bloc: summaryAccountsCubit,
      builder: (context, state) {
        if (state is SummaryAccountsSuccess) {
          final accounts = state.summaryAccountsEntity?.results ?? [];
          return _buildAccountsContent(context, accounts);
        } else if (state is SummaryAccountsLoading) {
          return _buildLoadingState();
        } else if (state is SummaryAccountsError) {
          return _buildErrorState();
        }
        return const SizedBox.shrink();
      },
    );
  }

  Widget _buildAccountsContent(
    BuildContext context,
    List<ResultsAccounts> accounts,
  ) {
    final formatter = NumberFormat('#,##0.00', 'en_US');

    // حساب الإحصائيات
    double totalDebit = 0;
    double totalCredit = 0;
    for (var account in accounts) {
      totalDebit += double.tryParse(account.balanceDebit ?? '0') ?? 0.0;
      totalCredit += double.tryParse(account.balanceCredit ?? '0') ?? 0.0;
    }
    final netBalance = totalDebit - totalCredit;

    // تصنيف الحسابات
    final clients = accounts.where((a) => a.accountType == 'عميل').toList();
    final suppliers = accounts.where((a) => a.accountType == 'مورد').toList();
    final others = accounts
        .where((a) => a.accountType != 'عميل' && a.accountType != 'مورد')
        .toList();

    return CustomScrollView(
      slivers: [
        // Filter Section
        SliverToBoxAdapter(
          child: Padding(
            padding: EdgeInsets.all(isMobile ? 12 : 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Stats Summary
                _buildStatsCard(
                  accounts.length,
                  totalDebit,
                  totalCredit,
                  netBalance,
                  formatter,
                ),

                const SizedBox(height: 14),

                // Filter Chips
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: [
                    _buildFilterChip('الكل', accounts.length, null),
                    _buildFilterChip(
                      'عميل',
                      clients.length,
                      const Color(0xFFA78BFA),
                    ),
                    _buildFilterChip(
                      'مورد',
                      suppliers.length,
                      const Color(0xFFFBBF24),
                    ),
                    _buildFilterChip(
                      'أخرى',
                      others.length,
                      const Color(0xFF818CF8),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),

        // Accounts List
        if (accounts.isEmpty)
          SliverFillRemaining(child: _buildEmptyState())
        else
          SliverPadding(
            padding: EdgeInsets.fromLTRB(
              isMobile ? 12 : 16,
              0,
              isMobile ? 12 : 16,
              20,
            ),
            sliver: SliverList(
              delegate: SliverChildBuilderDelegate((context, index) {
                return _buildAccountCard(accounts[index], formatter, index);
              }, childCount: accounts.length),
            ),
          ),
      ],
    );
  }

  Widget _buildStatsCard(
    int count,
    double totalDebit,
    double totalCredit,
    double netBalance,
    NumberFormat formatter,
  ) {
    return Container(
      padding: EdgeInsets.all(isMobile ? 14 : 16),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF2D3748), Color(0xFF1A202C)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: const Color(0xFF4A5568).withOpacity(0.5),
          width: 1.5,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.15),
            blurRadius: 16,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0xFF667EEA), Color(0xFF764BA2)],
                  ),
                  borderRadius: BorderRadius.circular(10),
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xFF667EEA).withOpacity(0.3),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: const Icon(
                  Icons.analytics_rounded,
                  color: Colors.white,
                  size: 20,
                ),
              ),
              const SizedBox(width: 10),
              const Text(
                'ملخص الحسابات',
                style: TextStyle(
                  color: Color(0xFFE2E8F0),
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          Row(
            children: [
              Expanded(
                child: _buildStatItem(
                  'العدد',
                  count.toString(),
                  Icons.people_rounded,
                  const Color(0xFF818CF8),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: _buildStatItem(
                  'مدين',
                  formatter.format(totalDebit),
                  Icons.arrow_upward_rounded,
                  const Color(0xFF34D399),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: _buildStatItem(
                  'دائن',
                  formatter.format(totalCredit),
                  Icons.arrow_downward_rounded,
                  const Color(0xFFF87171),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: netBalance >= 0
                  ? const Color(0xFF34D399).withOpacity(0.1)
                  : const Color(0xFFF87171).withOpacity(0.1),
              borderRadius: BorderRadius.circular(10),
              border: Border.all(
                color: netBalance >= 0
                    ? const Color(0xFF34D399).withOpacity(0.3)
                    : const Color(0xFFF87171).withOpacity(0.3),
                width: 1.5,
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Icon(
                      netBalance >= 0
                          ? Icons.trending_up_rounded
                          : Icons.trending_down_rounded,
                      color: netBalance >= 0
                          ? const Color(0xFF10B981)
                          : const Color(0xFFEF4444),
                      size: 18,
                    ),
                    const SizedBox(width: 6),
                    Text(
                      'صافي الرصيد',
                      style: TextStyle(
                        color: netBalance >= 0
                            ? const Color(0xFF10B981)
                            : const Color(0xFFEF4444),
                        fontSize: 11,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                Row(
                  children: [
                    Text(
                      formatter.format(netBalance.abs()),
                      style: TextStyle(
                        color: netBalance >= 0
                            ? const Color(0xFF10B981)
                            : const Color(0xFFEF4444),
                        fontSize: isMobile ? 14 : 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(width: 4),
                    Text(
                      'ر.س',
                      style: TextStyle(
                        color: netBalance >= 0
                            ? const Color(0xFF10B981).withOpacity(0.7)
                            : const Color(0xFFEF4444).withOpacity(0.7),
                        fontSize: 9,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatItem(
    String label,
    String value,
    IconData icon,
    Color color,
  ) {
    return Container(
      padding: EdgeInsets.all(isMobile ? 10 : 12),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [color.withOpacity(0.15), color.withOpacity(0.05)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: color.withOpacity(0.3), width: 1.5),
      ),
      child: Column(
        children: [
          Icon(icon, color: color, size: 18),
          const SizedBox(height: 6),
          Text(
            value,
            style: TextStyle(
              color: color,
              fontSize: 11,
              fontWeight: FontWeight.bold,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 2),
          Text(
            label,
            style: const TextStyle(color: Color(0xFFA0AEC0), fontSize: 9),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterChip(String label, int count, Color? color) {
    final isSelected = selectedAccountType == label;
    final chipColor = color ?? const Color(0xFF667EEA);

    return InkWell(
      onTap: () => onAccountTypeChanged(label),
      borderRadius: BorderRadius.circular(10),
      child: Container(
        padding: EdgeInsets.symmetric(
          horizontal: isMobile ? 12 : 14,
          vertical: isMobile ? 8 : 10,
        ),
        decoration: BoxDecoration(
          gradient: isSelected
              ? LinearGradient(colors: [chipColor, chipColor.withOpacity(0.7)])
              : const LinearGradient(
                  colors: [Color(0xFF2D3748), Color(0xFF1A202C)],
                ),
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: isSelected ? chipColor : const Color(0xFF4A5568),
            width: isSelected ? 2 : 1.5,
          ),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: chipColor.withOpacity(0.3),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ]
              : null,
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              _getIconForType(label),
              color: isSelected ? Colors.white : chipColor.withOpacity(0.9),
              size: 16,
            ),
            const SizedBox(width: 6),
            Text(
              label,
              style: TextStyle(
                color: isSelected ? Colors.white : const Color(0xFFCBD5E1),
                fontSize: 11,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.w600,
              ),
            ),
            const SizedBox(width: 5),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
              decoration: BoxDecoration(
                color: isSelected
                    ? Colors.white.withOpacity(0.25)
                    : chipColor.withOpacity(0.2),
                borderRadius: BorderRadius.circular(6),
              ),
              child: Text(
                '$count',
                style: TextStyle(
                  color: isSelected ? Colors.white : chipColor,
                  fontSize: 9,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  IconData _getIconForType(String type) {
    switch (type) {
      case 'عميل':
        return Icons.person_rounded;
      case 'مورد':
        return Icons.local_shipping_rounded;
      case 'أخرى':
        return Icons.category_rounded;
      default:
        return Icons.filter_list_rounded;
    }
  }

  Widget _buildAccountCard(
    ResultsAccounts account,
    NumberFormat formatter,
    int index,
  ) {
    final debit = double.tryParse(account.balanceDebit ?? '0') ?? 0.0;
    final credit = double.tryParse(account.balanceCredit ?? '0') ?? 0.0;
    final balance = debit - credit;

    final accountColors = _getAccountColors(account.accountType);

    return TweenAnimationBuilder<double>(
      duration: Duration(milliseconds: 300 + (index * 50)),
      tween: Tween(begin: 0.0, end: 1.0),
      builder: (context, value, child) {
        return Opacity(
          opacity: value,
          child: Transform.translate(
            offset: Offset(0, 20 * (1 - value)),
            child: child,
          ),
        );
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 10),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [const Color(0xFF2D3748), const Color(0xFF1A202C)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: accountColors['border'], width: 1.5),
          boxShadow: [
            BoxShadow(
              color: accountColors['color'].withOpacity(0.15),
              blurRadius: 12,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Padding(
          padding: EdgeInsets.all(isMobile ? 12 : 14),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          accountColors['color'].withOpacity(0.15),
                          accountColors['color'].withOpacity(0.05),
                        ],
                      ),
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(
                        color: accountColors['border'],
                        width: 1.5,
                      ),
                    ),
                    child: Icon(
                      accountColors['icon'],
                      color: accountColors['color'],
                      size: 20,
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          account.accountName ?? '',
                          style: const TextStyle(
                            color: Color(0xFFE2E8F0),
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        if (account.accountNumber?.isNotEmpty == true) ...[
                          const SizedBox(height: 3),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 6,
                              vertical: 2,
                            ),
                            decoration: BoxDecoration(
                              color: const Color(0xFF1A202C),
                              borderRadius: BorderRadius.circular(4),
                              border: Border.all(
                                color: const Color(0xFF4A5568),
                                width: 1,
                              ),
                            ),
                            child: Text(
                              '#${account.accountNumber}',
                              style: const TextStyle(
                                color: Color(0xFFA0AEC0),
                                fontSize: 9,
                                fontFamily: 'monospace',
                              ),
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: accountColors['bg'],
                      borderRadius: BorderRadius.circular(6),
                      border: Border.all(
                        color: accountColors['border'],
                        width: 1,
                      ),
                    ),
                    child: Text(
                      accountColors['text'],
                      style: TextStyle(
                        color: accountColors['color'],
                        fontSize: 9,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 12),

              // Balance Display
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: balance >= 0
                        ? [
                            const Color(0xFF48BB78).withOpacity(0.2),
                            const Color(0xFF48BB78).withOpacity(0.05),
                          ]
                        : [
                            const Color(0xFFF56565).withOpacity(0.2),
                            const Color(0xFFF56565).withOpacity(0.05),
                          ],
                  ),
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(
                    color: balance >= 0
                        ? const Color(0xFF48BB78).withOpacity(0.4)
                        : const Color(0xFFF56565).withOpacity(0.4),
                    width: 1.5,
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          balance >= 0 ? 'رصيد دائن' : 'رصيد مدين',
                          style: TextStyle(
                            color: balance >= 0
                                ? const Color(0xFF68D391)
                                : const Color(0xFFFC8181),
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 2),
                        const Text(
                          'الرصيد الحالي',
                          style: TextStyle(
                            color: Color(0xFFA0AEC0),
                            fontSize: 8,
                          ),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        Text(
                          formatter.format(balance.abs()),
                          style: TextStyle(
                            color: balance >= 0
                                ? const Color(0xFF68D391)
                                : const Color(0xFFFC8181),
                            fontSize: isMobile ? 16 : 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(width: 4),
                        Text(
                          'ر.س',
                          style: TextStyle(
                            color: balance >= 0
                                ? const Color(0xFF68D391).withOpacity(0.7)
                                : const Color(0xFFFC8181).withOpacity(0.7),
                            fontSize: 9,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 10),

              // Details
              Row(
                children: [
                  Expanded(
                    child: _buildDetailItem(
                      'مدين',
                      debit,
                      Icons.arrow_upward_rounded,
                      const Color(0xFF34D399),
                      formatter,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: _buildDetailItem(
                      'دائن',
                      credit,
                      Icons.arrow_downward_rounded,
                      const Color(0xFFF87171),
                      formatter,
                    ),
                  ),
                ],
              ),

              // Additional Info
              if (account.mobile?.isNotEmpty == true ||
                  account.lastSaleDate != null) ...[
                const SizedBox(height: 10),
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: const Color(0xFF1A202C),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                      color: const Color(0xFF4A5568),
                      width: 1,
                    ),
                  ),
                  child: Row(
                    children: [
                      if (account.mobile?.isNotEmpty == true) ...[
                        const Icon(
                          Icons.phone_rounded,
                          color: Color(0xFF9F7AEA),
                          size: 13,
                        ),
                        const SizedBox(width: 5),
                        Text(
                          account.mobile!,
                          style: const TextStyle(
                            color: Color(0xFFCBD5E1),
                            fontSize: 10,
                          ),
                        ),
                      ],
                      const Spacer(),
                      if (account.lastSaleDate != null) ...[
                        const Icon(
                          Icons.event_rounded,
                          color: Color(0xFF667EEA),
                          size: 13,
                        ),
                        const SizedBox(width: 5),
                        Text(
                          _formatDate(account.lastSaleDate),
                          style: const TextStyle(
                            color: Color(0xFFCBD5E1),
                            fontSize: 9,
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDetailItem(
    String label,
    double value,
    IconData icon,
    Color color,
    NumberFormat formatter,
  ) {
    return Container(
      padding: EdgeInsets.all(isMobile ? 8 : 10),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [color.withOpacity(0.15), color.withOpacity(0.05)],
        ),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: color.withOpacity(0.4), width: 1.5),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, color: color, size: 12),
              const SizedBox(width: 4),
              Text(
                label,
                style: TextStyle(
                  color: color,
                  fontSize: 9,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 5),
          Text(
            formatter.format(value),
            style: TextStyle(
              color: color,
              fontSize: 11,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Map<String, dynamic> _getAccountColors(String? accountType) {
    switch (accountType) {
      case 'عميل':
        return {
          'color': const Color(0xFF9F7AEA),
          'bg': const Color(0xFF9F7AEA).withOpacity(0.15),
          'border': const Color(0xFF9F7AEA).withOpacity(0.4),
          'text': 'عميل',
          'icon': Icons.person_rounded,
        };
      case 'مورد':
        return {
          'color': const Color(0xFFECC94B),
          'bg': const Color(0xFFECC94B).withOpacity(0.15),
          'border': const Color(0xFFECC94B).withOpacity(0.4),
          'text': 'مورد',
          'icon': Icons.local_shipping_rounded,
        };
      default:
        return {
          'color': const Color(0xFF667EEA),
          'bg': const Color(0xFF667EEA).withOpacity(0.15),
          'border': const Color(0xFF667EEA).withOpacity(0.4),
          'text': 'أخرى',
          'icon': Icons.category_rounded,
        };
    }
  }

  String _formatDate(dynamic date) {
    if (date == null) return '-';
    try {
      final dateTime = DateTime.parse(date.toString());
      return DateFormat('dd/MM/yyyy').format(dateTime);
    } catch (e) {
      return '-';
    }
  }

  Widget _buildLoadingState() {
    return const Center(
      child: CircularProgressIndicator(color: Color(0xFF667EEA)),
    );
  }

  Widget _buildErrorState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  const Color(0xFFF56565).withOpacity(0.2),
                  const Color(0xFFF56565).withOpacity(0.05),
                ],
              ),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: const Color(0xFFF56565).withOpacity(0.4),
                width: 1.5,
              ),
            ),
            child: const Icon(
              Icons.error_outline_rounded,
              color: Color(0xFFFC8181),
              size: 48,
            ),
          ),
          const SizedBox(height: 16),
          const Text(
            'حدث خطأ في تحميل الحسابات',
            style: TextStyle(
              color: Color(0xFFA0AEC0),
              fontSize: 14,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFF667EEA), Color(0xFF764BA2)],
              ),
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: const Color(0xFF667EEA).withOpacity(0.3),
                  blurRadius: 16,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: const Icon(
              Icons.account_balance_wallet_outlined,
              color: Colors.white,
              size: 56,
            ),
          ),
          const SizedBox(height: 20),
          const Text(
            'لا توجد حسابات',
            style: TextStyle(
              color: Color(0xFFE2E8F0),
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'لم يتم العثور على حسابات مطابقة',
            style: TextStyle(color: Color(0xFFA0AEC0), fontSize: 12),
          ),
        ],
      ),
    );
  }
}
