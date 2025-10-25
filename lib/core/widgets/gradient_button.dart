import 'package:flutter/material.dart';
import 'package:stock_up/core/resources/color_manager.dart';
import 'package:stock_up/core/resources/style_manager.dart';

class GradientButton extends StatelessWidget {
  const GradientButton({
    super.key,
    required this.onPressed,
    required this.icon,
    required this.label,
    this.gradient,
  });

  final VoidCallback onPressed;
  final IconData icon;
  final String label;
  final Gradient? gradient;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 56,
      decoration: BoxDecoration(
        gradient: gradient ?? ColorManager.primaryGradient,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: ColorManager.purple2.withOpacity(0.4),
            blurRadius: 15,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.transparent,
          shadowColor: Colors.transparent,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Expanded(child: Icon(icon, color: Colors.white, size: 24)),
            const SizedBox(width: 8),
            Expanded(
              flex: 2,
              child: Text(
                label,
                style: getSemiBoldStyle(fontSize: 16, color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
