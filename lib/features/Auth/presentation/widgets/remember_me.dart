import 'package:flutter/material.dart';
import 'package:stock_up/core/utils/cashed_data_shared_preferences.dart';

class RememberMe extends StatelessWidget {
  final bool value;
  final ValueChanged<bool> onChanged;

  const RememberMe({super.key, required this.value, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        SizedBox(
          width: 24,
          height: 24,
          child: Checkbox(
            value: value,
            onChanged: (newValue) {
              onChanged(newValue ?? false);
              CacheService.setData(key: CacheKeys.rememberMe, value: newValue);
            },
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(4),
            ),
            activeColor: Colors.blue[700],
          ),
        ),
        const SizedBox(width: 8),
        Text('تذكرني', style: TextStyle(fontSize: 14, color: Colors.grey[700])),
      ],
    );
  }
}
