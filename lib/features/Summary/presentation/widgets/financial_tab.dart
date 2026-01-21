import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:stock_up/features/Summary/data/models/response/summary_model.dart';
import 'package:stock_up/features/Summary/presentation/bloc/Summary_cubit.dart';

class FinancialTab extends StatefulWidget {
  final SummaryCubit summaryCubit;
  final bool isMobile;

  const FinancialTab({
    super.key,
    required this.summaryCubit,
    required this.isMobile,
  });

  @override
  State<FinancialTab> createState() => _FinancialTabState();
}

class _FinancialTabState extends State<FinancialTab> {
  bool _isTreasuryExpanded = false;
  bool _isBankExpanded = false;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SummaryCubit, SummaryState>(
      bloc: widget.summaryCubit,
      builder: (context, state) {
        if (state is SummarySuccess) {
          final summary = state.summary?.summary;
          return _buildFinancialContent(context, summary);
        } else if (state is SummaryLoading) {
          return _buildLoadingState();
        } else if (state is SummaryFailure) {
          return _buildErrorState();
        }
        return const SizedBox.shrink();
      },
    );
  }

  Widget _buildFinancialContent(BuildContext context, Summary? summary) {
    final formatter = NumberFormat('#,##0.00', 'en_US');
    final treasuryBalance =
        double.tryParse(summary?.treasury?.finalBalance ?? '0') ?? 0.0;
    final bankBalance =
        double.tryParse(summary?.bank?.finalBalance ?? '0') ?? 0.0;
    final totalBalance = treasuryBalance + bankBalance;

    return SingleChildScrollView(
      padding: EdgeInsets.all(widget.isMobile ? 12 : 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // عنوان القسم
          _buildSectionTitle(
            'تفاصيل الأرصدة',
            Icons.monetization_on_rounded,
            const Color(0xFF6366F1),
          ),

          const SizedBox(height: 16),

          // النقدية والبنك بجوار بعض
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // النقدية
              Expanded(
                child: _buildCompactFinancialCard(
                  title: 'النقدية',
                  icon: Icons.account_balance_wallet_rounded,
                  color: const Color(0xFF10B981),
                  balance: treasuryBalance,
                  movements: summary?.treasury?.movements ?? [],
                  isExpanded: _isTreasuryExpanded,
                  onTap: () {
                    setState(() {
                      _isTreasuryExpanded = !_isTreasuryExpanded;
                      if (_isTreasuryExpanded) _isBankExpanded = false;
                    });
                  },
                  formatter: formatter,
                ),
              ),

              SizedBox(width: widget.isMobile ? 8 : 12),

              // البنك
              Expanded(
                child: _buildCompactFinancialCard(
                  title: 'البنك',
                  icon: Icons.account_balance_rounded,
                  color: const Color(0xFF3B82F6),
                  balance: bankBalance,
                  movements: summary?.bank?.movements ?? [],
                  isExpanded: _isBankExpanded,
                  onTap: () {
                    setState(() {
                      _isBankExpanded = !_isBankExpanded;
                      if (_isBankExpanded) _isTreasuryExpanded = false;
                    });
                  },
                  formatter: formatter,
                ),
              ),
            ],
          ),

          const SizedBox(height: 20),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String title, IconData icon, Color color) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            gradient: LinearGradient(colors: [color, color.withOpacity(0.7)]),
            borderRadius: BorderRadius.circular(10),
            boxShadow: [
              BoxShadow(
                color: color.withOpacity(0.3),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Icon(icon, color: Colors.white, size: 18),
        ),
        const SizedBox(width: 10),
        Text(
          title,
          style: const TextStyle(
            color: Color(0xFFF1F5F9),
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }

  Widget _buildCompactFinancialCard({
    required String title,
    required IconData icon,
    required Color color,
    required double balance,
    required List<Movements> movements,
    required bool isExpanded,
    required VoidCallback onTap,
    required NumberFormat formatter,
  }) {
    return GestureDetector(
      onTap: movements.isNotEmpty ? onTap : null,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [const Color(0xFF1E293B), color.withOpacity(0.05)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
          borderRadius: BorderRadius.circular(18),
          border: Border.all(
            color: isExpanded ? color : color.withOpacity(0.3),
            width: isExpanded ? 2 : 1.5,
          ),
          boxShadow: [
            BoxShadow(
              color: isExpanded
                  ? color.withOpacity(0.3)
                  : Colors.black.withOpacity(0.1),
              blurRadius: isExpanded ? 16 : 8,
              offset: Offset(0, isExpanded ? 6 : 2),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Header
            Container(
              padding: EdgeInsets.all(widget.isMobile ? 12 : 14),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [color, color.withOpacity(0.8)],
                  begin: Alignment.topRight,
                  end: Alignment.bottomLeft,
                ),
                borderRadius: BorderRadius.only(
                  topLeft: const Radius.circular(16),
                  topRight: const Radius.circular(16),
                  bottomLeft: isExpanded
                      ? Radius.zero
                      : const Radius.circular(16),
                  bottomRight: isExpanded
                      ? Radius.zero
                      : const Radius.circular(16),
                ),
              ),
              child: Column(
                children: [
                  // أيقونة واسم
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.25),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: Colors.white.withOpacity(0.4),
                        width: 2,
                      ),
                    ),
                    child: Icon(
                      icon,
                      color: Colors.white,
                      size: widget.isMobile ? 24 : 28,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    title,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: widget.isMobile ? 14 : 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'الرصيد الحالي',
                    style: TextStyle(
                      color: Colors.white.withOpacity(0.8),
                      fontSize: widget.isMobile ? 9 : 10,
                    ),
                  ),
                  const SizedBox(height: 12),
                  // الرصيد
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 8,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: Colors.white.withOpacity(0.3),
                        width: 1,
                      ),
                    ),
                    child: Column(
                      children: [
                        Text(
                          formatter.format(balance),
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: widget.isMobile ? 18 : 22,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 0.5,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          'ر.س',
                          style: TextStyle(
                            color: Colors.white.withOpacity(0.8),
                            fontSize: widget.isMobile ? 9 : 10,
                          ),
                        ),
                      ],
                    ),
                  ),
                  // زر التوسيع
                  if (movements.isNotEmpty) ...[
                    const SizedBox(height: 10),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            '${movements.length} حركة',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: widget.isMobile ? 9 : 10,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(width: 4),
                          Icon(
                            isExpanded
                                ? Icons.keyboard_arrow_up_rounded
                                : Icons.keyboard_arrow_down_rounded,
                            color: Colors.white,
                            size: 16,
                          ),
                        ],
                      ),
                    ),
                  ],
                ],
              ),
            ),

            // الحركات المالية (تظهر عند التوسيع)
            AnimatedSize(
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeInOut,
              child: isExpanded && movements.isNotEmpty
                  ? Container(
                      padding: EdgeInsets.all(widget.isMobile ? 10 : 12),
                      decoration: BoxDecoration(
                        color: const Color(0xFF0F172A).withOpacity(0.5),
                        borderRadius: const BorderRadius.only(
                          bottomLeft: Radius.circular(16),
                          bottomRight: Radius.circular(16),
                        ),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(bottom: 8),
                            child: Row(
                              children: [
                                Container(
                                  width: 3,
                                  height: 16,
                                  decoration: BoxDecoration(
                                    color: color,
                                    borderRadius: BorderRadius.circular(2),
                                  ),
                                ),
                                const SizedBox(width: 6),
                                Text(
                                  'الحركات المالية',
                                  style: TextStyle(
                                    color: color,
                                    fontSize: widget.isMobile ? 11 : 12,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          ...movements.map((movement) {
                            return _buildCompactMovementItem(
                              movement,
                              formatter,
                              color,
                            );
                          }).toList(),
                        ],
                      ),
                    )
                  : const SizedBox.shrink(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCompactMovementItem(
    Movements movement,
    NumberFormat formatter,
    Color mainColor,
  ) {
    final incoming = double.tryParse(movement.totalIncoming ?? '0') ?? 0.0;
    final outgoing = double.tryParse(movement.totalOutgoing ?? '0') ?? 0.0;

    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: EdgeInsets.all(widget.isMobile ? 8 : 10),
      decoration: BoxDecoration(
        color: const Color(0xFF1E293B).withOpacity(0.6),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: mainColor.withOpacity(0.2), width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // نوع الحركة
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(5),
                decoration: BoxDecoration(
                  color: mainColor.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Icon(
                  Icons.swap_horiz_rounded,
                  color: mainColor,
                  size: 12,
                ),
              ),
              const SizedBox(width: 6),
              Expanded(
                child: Text(
                  movement.movementType ?? '',
                  style: TextStyle(
                    color: const Color(0xFFE2E8F0),
                    fontSize: widget.isMobile ? 10 : 11,
                    fontWeight: FontWeight.w600,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),

          if (incoming > 0 || outgoing > 0) ...[
            const SizedBox(height: 8),
            Row(
              children: [
                if (incoming > 0)
                  Expanded(
                    child: _buildCompactValue(
                      'وارد',
                      incoming,
                      Icons.arrow_downward_rounded,
                      const Color(0xFF10B981),
                      formatter,
                    ),
                  ),
                if (incoming > 0 && outgoing > 0) const SizedBox(width: 6),
                if (outgoing > 0)
                  Expanded(
                    child: _buildCompactValue(
                      'صادر',
                      outgoing,
                      Icons.arrow_upward_rounded,
                      const Color(0xFFEF4444),
                      formatter,
                    ),
                  ),
              ],
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildCompactValue(
    String label,
    double value,
    IconData icon,
    Color color,
    NumberFormat formatter,
  ) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: widget.isMobile ? 6 : 8,
        vertical: widget.isMobile ? 6 : 8,
      ),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [color.withOpacity(0.25), color.withOpacity(0.08)],
        ),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: color.withOpacity(0.5), width: 1),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(icon, color: color, size: 11),
              const SizedBox(width: 3),
              Text(
                label,
                style: TextStyle(
                  color: color,
                  fontSize: widget.isMobile ? 9 : 10,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 3),
          Text(
            formatter.format(value),
            style: TextStyle(
              color: color,
              fontSize: widget.isMobile ? 11 : 12,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLoadingState() {
    return const Center(
      child: CircularProgressIndicator(color: Color(0xFF6366F1)),
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
              color: const Color(0xFFEF4444).withOpacity(0.1),
              borderRadius: BorderRadius.circular(16),
            ),
            child: const Icon(
              Icons.error_outline_rounded,
              color: Color(0xFFEF4444),
              size: 48,
            ),
          ),
          const SizedBox(height: 16),
          const Text(
            'حدث خطأ في تحميل البيانات',
            style: TextStyle(
              color: Color(0xFF94A3B8),
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}
