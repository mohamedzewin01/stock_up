import 'package:flutter/material.dart';
import 'package:stock_up/core/resources/color_manager.dart';

class InfoChip extends StatelessWidget {
  final IconData icon;
  final String label;

  const InfoChip({super.key, required this.icon, required this.label});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        gradient: ColorManager.cardGradient,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: ColorManager.purple2.withOpacity(0.2),
          width: 1,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: ColorManager.textSecondary),
          const SizedBox(width: 4),
          Flexible(
            child: Text(
              label,
              style: TextStyle(
                fontSize: 12,
                color: ColorManager.purple2,
                fontWeight: FontWeight.w500,
              ),
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }
}
