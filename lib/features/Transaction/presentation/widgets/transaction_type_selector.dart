// lib/features/Transaction/presentation/widgets/transaction_type_selector.dart
import 'package:flutter/material.dart';
import 'transaction_types.dart';

class TransactionTypeSelector extends StatelessWidget {
  final ShiftTransactionType selectedType;
  final bool isTablet;
  final Function(ShiftTransactionType) onTypeSelected;

  const TransactionTypeSelector({
    super.key,
    required this.selectedType,
    required this.isTablet,
    required this.onTypeSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'نوع المعاملة',
          style: TextStyle(
            fontSize: isTablet ? 16 : 14,
            fontWeight: FontWeight.w600,
            color: const Color(0xFF1A1A1A),
          ),
        ),

        const SizedBox(height: 12),

        // شبكة أنواع المعاملات
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: isTablet ? 5 : 3,
            mainAxisExtent: 120,

            crossAxisSpacing: 8,
            mainAxisSpacing: 8,
          ),
          itemCount: ShiftTransactionType.values.length,
          itemBuilder: (context, index) {
            final type = ShiftTransactionType.values[index];
            final isSelected = type == selectedType;

            return GestureDetector(
              onTap: () => onTypeSelected(type),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                padding: EdgeInsets.all(isTablet ? 12 : 8),
                decoration: BoxDecoration(
                  color: isSelected ? type.color.withOpacity(0.1) : const Color(0xFFF8F9FA),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: isSelected ? type.color : const Color(0xFFE5E5E5),
                    width: isSelected ? 2 : 1,
                  ),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      type.icon,
                      color: isSelected ? type.color : const Color(0xFF666666),
                      size: isTablet ? 24 : 20,
                    ),
                    SizedBox(height: isTablet ? 6 : 4),
                    Text(
                      type.displayName,
                      style: TextStyle(
                        fontSize: isTablet ? 12 : 10,
                        fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                        color: isSelected ? type.color : const Color(0xFF666666),
                      ),
                      textAlign: TextAlign.center,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ],
    );
  }
}