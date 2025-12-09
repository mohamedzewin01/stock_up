import 'package:flutter/material.dart';
import 'package:stock_up/core/resources/style_manager.dart';

class DashboardStatsBar extends StatelessWidget {
  const DashboardStatsBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 105,
      margin: const EdgeInsets.symmetric(horizontal: 0),
      child: ListView(
        scrollDirection: Axis.horizontal,
        shrinkWrap: true,
        children: [
          _buildStatCard(
            icon: Icons.inventory_2_rounded,
            title: 'المنتجات',
            value: '1,234',
            color: const Color(0xFF6366F1),
            delay: 0,
          ),
          _buildStatCard(
            icon: Icons.trending_up_rounded,
            title: 'المبيعات اليوم',
            value: '45',
            color: const Color(0xFF10B981),
            delay: 0,
          ),
          _buildStatCard(
            icon: Icons.people_rounded,
            title: 'العملاء',
            value: '892',
            color: const Color(0xFFF59E0B),
            delay: 0,
          ),
          _buildStatCard(
            icon: Icons.paid_rounded,
            title: 'الإيرادات',
            value: '12.5K',
            color: const Color(0xFFEC4899),
            delay: 0,
          ),
        ],
      ),
    );
  }

  Widget _buildStatCard({
    required IconData icon,
    required String title,
    required String value,
    required Color color,
    required int delay,
  }) {
    return Container(
      width: 90,
      margin: const EdgeInsets.only(left: 8),
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: const Color(0xFF1E293B),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: color.withOpacity(0.3), width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: color.withOpacity(0.15),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, size: 20, color: color),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                value,
                style: getBoldStyle(color: Colors.white, fontSize: 18),
              ),
              const SizedBox(height: 2),
              Text(
                title,
                style: getRegularStyle(
                  color: Colors.white.withOpacity(0.6),
                  fontSize: 11,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
