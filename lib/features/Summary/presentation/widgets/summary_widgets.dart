import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:stock_up/features/Summary/data/models/response/summary_accounts_model.dart';
import 'package:stock_up/features/Summary/data/models/response/summary_model.dart';

class FinancialSummaryCard extends StatelessWidget {
  final String title;
  final IconData icon;
  final Color color;
  final String finalBalance;
  final List<Movements> movements;

  const FinancialSummaryCard({
    super.key,
    required this.title,
    required this.icon,
    required this.color,
    required this.finalBalance,
    required this.movements,
  });

  @override
  Widget build(BuildContext context) {
    final formatter = NumberFormat('#,##0.00', 'en_US');
    final balance = double.tryParse(finalBalance) ?? 0.0;

    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFF1E293B),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: color.withOpacity(0.2), width: 1),
        boxShadow: [
          BoxShadow(
            color: color.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          // Header with Balance
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [color.withOpacity(0.15), color.withOpacity(0.05)],
                begin: Alignment.topRight,
                end: Alignment.bottomLeft,
              ),
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(16),
                topRight: Radius.circular(16),
              ),
            ),
            child: Column(
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
                    const Text(
                      'الرصيد النهائي',
                      style: TextStyle(color: Color(0xFF64748B), fontSize: 10),
                    ),
                  ],
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      formatter.format(balance),
                      style: TextStyle(
                        color: color,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      'ر.س',
                      style: TextStyle(
                        color: color.withOpacity(0.7),
                        fontSize: 10,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          // Movements
          if (movements.isNotEmpty)
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  const Divider(color: Color(0xFF334155), height: 1),
                  const SizedBox(height: 12),
                  ...movements.map((movement) {
                    return _buildMovementRow(movement, formatter);
                  }).toList(),
                ],
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildMovementRow(Movements movement, NumberFormat formatter) {
    final incoming = double.tryParse(movement.totalIncoming ?? '0') ?? 0.0;
    final outgoing = double.tryParse(movement.totalOutgoing ?? '0') ?? 0.0;

    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
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
          Expanded(
            child: Text(
              movement.movementType ?? '',
              style: const TextStyle(color: Color(0xFF94A3B8), fontSize: 11),
            ),
          ),
          if (incoming > 0) ...[
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 3),
              decoration: BoxDecoration(
                color: const Color(0xFF10B981).withOpacity(0.1),
                borderRadius: BorderRadius.circular(6),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(
                    Icons.arrow_downward,
                    color: Color(0xFF10B981),
                    size: 11,
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
                ],
              ),
            ),
            const SizedBox(width: 8),
          ],
          if (outgoing > 0)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 3),
              decoration: BoxDecoration(
                color: const Color(0xFFEF4444).withOpacity(0.1),
                borderRadius: BorderRadius.circular(6),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(
                    Icons.arrow_upward,
                    color: Color(0xFFEF4444),
                    size: 11,
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
              ),
            ),
        ],
      ),
    );
  }
}

class AccountCard extends StatelessWidget {
  final ResultsAccounts account;
  final VoidCallback? onTap;

  const AccountCard({super.key, required this.account, this.onTap});

  @override
  Widget build(BuildContext context) {
    final formatter = NumberFormat('#,##0.00', 'en_US');
    final debit = double.tryParse(account.balanceDebit ?? '0') ?? 0.0;
    final credit = double.tryParse(account.balanceCredit ?? '0') ?? 0.0;
    final balance = debit - credit;

    final accountColors = _getAccountColors(account.accountType);

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        margin: const EdgeInsets.only(bottom: 8),
        decoration: BoxDecoration(
          color: const Color(0xFF1E293B),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: accountColors['border'] ?? const Color(0xFF334155),
            width: 1,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(14),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header Row
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: accountColors['bg'],
                      borderRadius: BorderRadius.circular(6),
                      border: Border.all(
                        color: accountColors['border']!,
                        width: 1,
                      ),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          accountColors['icon'] as IconData,
                          color: accountColors['color'],
                          size: 12,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          accountColors['text'] as String,
                          style: TextStyle(
                            color: accountColors['color'],
                            fontSize: 10,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
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
                            color: Color(0xFFF1F5F9),
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        if (account.accountNumber?.isNotEmpty == true)
                          Text(
                            '#${account.accountNumber}',
                            style: const TextStyle(
                              color: Color(0xFF64748B),
                              fontSize: 9,
                            ),
                          ),
                      ],
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: balance >= 0
                          ? const Color(0xFF10B981).withOpacity(0.1)
                          : const Color(0xFFEF4444).withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      formatter.format(balance.abs()),
                      style: TextStyle(
                        color: balance >= 0
                            ? const Color(0xFF10B981)
                            : const Color(0xFFEF4444),
                        fontSize: 13,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 12),

              // Balance Details
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: const Color(0xFF0F172A),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: _buildBalanceItem(
                        'مدين',
                        debit,
                        const Color(0xFF10B981),
                        Icons.arrow_upward,
                      ),
                    ),
                    Container(
                      width: 1,
                      height: 20,
                      color: const Color(0xFF334155),
                    ),
                    Expanded(
                      child: _buildBalanceItem(
                        'دائن',
                        credit,
                        const Color(0xFFEF4444),
                        Icons.arrow_downward,
                      ),
                    ),
                  ],
                ),
              ),

              // Additional Info
              if (account.mobile?.isNotEmpty == true ||
                  account.lastSaleDate != null) ...[
                const SizedBox(height: 10),
                Row(
                  children: [
                    if (account.mobile?.isNotEmpty == true) ...[
                      const Icon(
                        Icons.phone,
                        color: Color(0xFF64748B),
                        size: 11,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        account.mobile ?? '',
                        style: const TextStyle(
                          color: Color(0xFF64748B),
                          fontSize: 10,
                        ),
                      ),
                    ],
                    const Spacer(),
                    if (account.lastSaleDate != null) ...[
                      const Icon(
                        Icons.shopping_cart,
                        color: Color(0xFF64748B),
                        size: 11,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        'آخر عملية: ${_formatDate(account.lastSaleDate)}',
                        style: const TextStyle(
                          color: Color(0xFF64748B),
                          fontSize: 9,
                        ),
                      ),
                    ],
                  ],
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBalanceItem(
    String label,
    double value,
    Color color,
    IconData icon,
  ) {
    final formatter = NumberFormat('#,##0.00', 'en_US');
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: color, size: 10),
            const SizedBox(width: 4),
            Text(
              label,
              style: const TextStyle(color: Color(0xFF64748B), fontSize: 9),
            ),
          ],
        ),
        const SizedBox(height: 4),
        Text(
          formatter.format(value),
          style: TextStyle(
            color: color,
            fontSize: 12,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }

  Map<String, dynamic> _getAccountColors(String? accountType) {
    switch (accountType) {
      case 'عميل':
        return {
          'color': const Color(0xFF8B5CF6),
          'bg': const Color(0xFF8B5CF6).withOpacity(0.1),
          'border': const Color(0xFF8B5CF6).withOpacity(0.3),
          'text': 'عميل',
          'icon': Icons.person,
        };
      case 'مورد':
        return {
          'color': const Color(0xFFF59E0B),
          'bg': const Color(0xFFF59E0B).withOpacity(0.1),
          'border': const Color(0xFFF59E0B).withOpacity(0.3),
          'text': 'مورد',
          'icon': Icons.local_shipping,
        };
      default:
        return {
          'color': const Color(0xFF6366F1),
          'bg': const Color(0xFF6366F1).withOpacity(0.1),
          'border': const Color(0xFF6366F1).withOpacity(0.3),
          'text': 'أخرى',
          'icon': Icons.account_balance_wallet,
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
}

class AccountTypeFilter extends StatelessWidget {
  final String selectedType;
  final ValueChanged<String> onChanged;

  const AccountTypeFilter({
    super.key,
    required this.selectedType,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFF1E293B),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: const Color(0xFF334155), width: 1),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      child: DropdownButton<String>(
        value: selectedType,
        underline: const SizedBox(),
        dropdownColor: const Color(0xFF1E293B),
        icon: const Icon(
          Icons.arrow_drop_down,
          color: Color(0xFF94A3B8),
          size: 20,
        ),
        style: const TextStyle(color: Color(0xFFF1F5F9), fontSize: 12),
        items: [
          const DropdownMenuItem(value: 'الكل', child: Text('الكل')),
          const DropdownMenuItem(value: 'عميل', child: Text('عميل')),
          const DropdownMenuItem(value: 'مورد', child: Text('مورد')),
          const DropdownMenuItem(value: 'اخرى', child: Text('أخرى')),
        ],
        onChanged: (value) {
          if (value != null) onChanged(value);
        },
      ),
    );
  }
}

class SummaryLoadingCard extends StatelessWidget {
  const SummaryLoadingCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(32),
      decoration: BoxDecoration(
        color: const Color(0xFF1E293B),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFF334155), width: 1),
      ),
      child: const Center(
        child: CircularProgressIndicator(
          color: Color(0xFF6366F1),
          strokeWidth: 2,
        ),
      ),
    );
  }
}

class EmptyAccountsPlaceholder extends StatelessWidget {
  const EmptyAccountsPlaceholder({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(32),
      decoration: BoxDecoration(
        color: const Color(0xFF1E293B),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFF334155), width: 1),
      ),
      child: Column(
        children: [
          Icon(
            Icons.account_balance_wallet_outlined,
            color: const Color(0xFF64748B).withOpacity(0.5),
            size: 48,
          ),
          const SizedBox(height: 12),
          const Text(
            'لا توجد حسابات',
            style: TextStyle(color: Color(0xFF64748B), fontSize: 14),
          ),
        ],
      ),
    );
  }
}
