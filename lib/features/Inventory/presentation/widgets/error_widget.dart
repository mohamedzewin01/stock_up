import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:stock_up/core/resources/color_manager.dart';
import 'package:stock_up/features/Inventory/presentation/bloc/users/users_inventory_cubit.dart';

class ErrorStateWidget extends StatelessWidget {
  const ErrorStateWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: LinearGradient(
                  colors: [
                    ColorManager.error.withOpacity(0.2),
                    ColorManager.error.withOpacity(0.1),
                  ],
                ),
                boxShadow: [
                  BoxShadow(
                    color: ColorManager.error.withOpacity(0.3),
                    blurRadius: 20,
                  ),
                ],
              ),
              child: Icon(
                Icons.error_outline_rounded,
                size: 64,
                color: ColorManager.error,
              ),
            ),
            const SizedBox(height: 24),
            const Text(
              'حدث خطأ أثناء جلب البيانات',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: ColorManager.textPrimary,
              ),
            ),
            const SizedBox(height: 32),
            Container(
              decoration: BoxDecoration(
                gradient: ColorManager.primaryGradient,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: ColorManager.purple2.withOpacity(0.4),
                    blurRadius: 20,
                    offset: const Offset(0, 8),
                  ),
                ],
              ),
              child: ElevatedButton.icon(
                onPressed: () =>
                    context.read<UsersInventoryCubit>().getAllUsers(),
                icon: const Icon(Icons.refresh_rounded, color: Colors.white),
                label: const Text(
                  'إعادة المحاولة',
                  style: TextStyle(color: Colors.white),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.transparent,
                  shadowColor: Colors.transparent,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 32,
                    vertical: 16,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
