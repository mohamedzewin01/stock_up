// lib/features/Groups/presentation/widgets/group_type_selector_widget.dart
import 'package:flutter/material.dart';

class GroupTypeSelectorWidget extends StatelessWidget {
  final String selectedType;
  final Function(String) onTypeChanged;

  const GroupTypeSelectorWidget({
    Key? key,
    required this.selectedType,
    required this.onTypeChanged,
  }) : super(key: key);

  final List<Map<String, dynamic>> groupTypes = const [
    {
      'value': 'work',
      'label': 'عمل',
      'icon': Icons.work,
      'color': Color(0xFF3B82F6),
      'description': 'مجموعة للعمل والمهام المهنية',
    },
    {
      'value': 'friends',
      'label': 'أصدقاء',
      'icon': Icons.people,
      'color': Color(0xFF10B981),
      'description': 'مجموعة للأصدقاء والأنشطة الاجتماعية',
    },
    {
      'value': 'family',
      'label': 'عائلة',
      'icon': Icons.family_restroom,
      'color': Color(0xFFF59E0B),
      'description': 'مجموعة لأفراد العائلة',
    },
    {
      'value': 'other',
      'label': 'أخرى',
      'icon': Icons.group,
      'color': Color(0xFF8B5CF6),
      'description': 'مجموعة عامة لاستخدامات متنوعة',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'نوع المجموعة',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: Color(0xFF374151),
          ),
        ),
        const SizedBox(height: 12),
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 12,
            mainAxisSpacing: 12,
            childAspectRatio: 1.2,
          ),
          itemCount: groupTypes.length,
          itemBuilder: (context, index) {
            final type = groupTypes[index];
            final isSelected = selectedType == type['value'];

            return GestureDetector(
              onTap: () => onTypeChanged(type['value']),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                decoration: BoxDecoration(
                  color: isSelected
                      ? type['color'].withOpacity(0.1)
                      : Colors.grey[50],
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: isSelected
                        ? type['color']
                        : Colors.grey[300]!,
                    width: isSelected ? 2 : 1,
                  ),
                  boxShadow: isSelected
                      ? [
                    BoxShadow(
                      color: type['color'].withOpacity(0.2),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ]
                      : [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.05),
                      blurRadius: 4,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: isSelected
                              ? type['color']
                              : type['color'].withOpacity(0.1),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Icon(
                          type['icon'],
                          color: isSelected
                              ? Colors.white
                              : type['color'],
                          size: 24,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        type['label'],
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: isSelected
                              ? type['color']
                              : const Color(0xFF374151),
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        type['description'],
                        style: TextStyle(
                          fontSize: 10,
                          color: Colors.grey[600],
                        ),
                        textAlign: TextAlign.center,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ],
    );
  }
}