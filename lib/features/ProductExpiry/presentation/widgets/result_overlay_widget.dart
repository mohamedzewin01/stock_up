// lib/features/DateScanner/presentation/widgets/result_overlay_widget.dart

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../domain/entities/date_scan_result.dart';

class ResultOverlayWidget extends StatelessWidget {
  final DateScanResult result;

  const ResultOverlayWidget({super.key, required this.result});

  @override
  Widget build(BuildContext context) {
    return Positioned(
      bottom: 40,
      left: 16,
      right: 16,
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              result.status.color.withOpacity(0.95),
              result.status.color.withOpacity(0.85),
            ],
          ),
          borderRadius: BorderRadius.circular(24),
          boxShadow: [
            BoxShadow(
              color: result.status.color.withOpacity(0.5),
              blurRadius: 20,
              offset: const Offset(0, 10),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // أيقونة الحالة والرسالة
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(
                    result.status.icon,
                    color: Colors.white,
                    size: 28,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        result.status.label,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        result.statusMessage,
                        style: TextStyle(
                          color: Colors.white.withOpacity(0.9),
                          fontSize: 13,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),

            const SizedBox(height: 16),
            const Divider(color: Colors.white30, height: 1),
            const SizedBox(height: 16),

            // تفاصيل التواريخ
            _buildDateDetails(),
          ],
        ),
      ),
    );
  }

  Widget _buildDateDetails() {
    return Column(
      children: [
        if (result.expiryDate != null)
          _buildDateRow(
            icon: Icons.event_busy_rounded,
            label: 'تاريخ الانتهاء',
            date: result.expiryDate!,
          ),
        if (result.manufacturingDate != null) ...[
          const SizedBox(height: 12),
          _buildDateRow(
            icon: Icons.factory_rounded,
            label: 'تاريخ الإنتاج',
            date: result.manufacturingDate!,
          ),
        ],
        if (result.validityPeriod != null) ...[
          const SizedBox(height: 12),
          _buildInfoRow(
            icon: Icons.timer_rounded,
            label: 'مدة الصلاحية',
            value: _formatDuration(result.validityPeriod!),
          ),
        ],
        if (result.daysUntilExpiry != null && result.daysUntilExpiry! > 0) ...[
          const SizedBox(height: 12),
          _buildInfoRow(
            icon: Icons.access_time_rounded,
            label: 'المتبقي',
            value: '${result.daysUntilExpiry} يوم',
          ),
        ],
      ],
    );
  }

  Widget _buildDateRow({
    required IconData icon,
    required String label,
    required DateTime date,
  }) {
    final formatter = DateFormat('dd/MM/yyyy', 'ar');
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.15),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Icon(icon, color: Colors.white, size: 20),
          const SizedBox(width: 12),
          Text(
            label,
            style: TextStyle(
              color: Colors.white.withOpacity(0.8),
              fontSize: 13,
            ),
          ),
          const Spacer(),
          Text(
            formatter.format(date),
            style: const TextStyle(
              color: Colors.white,
              fontSize: 15,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoRow({
    required IconData icon,
    required String label,
    required String value,
  }) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.15),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Icon(icon, color: Colors.white, size: 20),
          const SizedBox(width: 12),
          Text(
            label,
            style: TextStyle(
              color: Colors.white.withOpacity(0.8),
              fontSize: 13,
            ),
          ),
          const Spacer(),
          Text(
            value,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 15,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  String _formatDuration(Duration duration) {
    if (duration.inDays >= 365) {
      final years = (duration.inDays / 365).floor();
      return '$years سنة${years > 1 ? '' : ''}';
    } else if (duration.inDays >= 30) {
      final months = (duration.inDays / 30).floor();
      return '$months شهر${months > 1 ? '' : ''}';
    } else {
      return '${duration.inDays} يوم';
    }
  }
}
