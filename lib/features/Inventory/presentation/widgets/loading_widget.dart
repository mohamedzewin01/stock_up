import 'package:flutter/material.dart';
import 'package:stock_up/core/resources/color_manager.dart';

class LoadingWidget extends StatelessWidget {
  const LoadingWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(30),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: ColorManager.cardGradient,
              boxShadow: [
                BoxShadow(
                  color: ColorManager.purple2.withOpacity(0.3),
                  blurRadius: 30,
                  spreadRadius: 10,
                ),
              ],
            ),
            child: CircularProgressIndicator(
              color: ColorManager.purple2,
              strokeWidth: 4,
            ),
          ),
          const SizedBox(height: 24),
          Text(
            'جاري تحميل البيانات...',
            style: TextStyle(
              fontSize: 16,
              color: ColorManager.textSecondary,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}
