import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:stock_up/core/resources/color_manager.dart';
import 'package:stock_up/core/resources/style_manager.dart';
import 'package:stock_up/core/widgets/gradient_button.dart';
import 'package:stock_up/features/Inventory/presentation/bloc/InventoryByUser/inventory_user_cubit.dart';
import 'package:stock_up/features/Inventory/presentation/pages/create_inventory_page.dart';

class EmptyState extends StatelessWidget {
  const EmptyState({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(40),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: ColorManager.cardGradient,
                boxShadow: ColorManager.primaryShadow,
              ),
              child: Icon(
                Icons.inventory_2_outlined,
                size: 100,
                color: ColorManager.white,
              ),
            ),
            const SizedBox(height: 40),
            Text(
              'لا يوجد جرد حالي',
              style: getSemiBoldStyle(fontSize: 26, color: Colors.white),
            ),
            const SizedBox(height: 12),
            Text(
              'ابدأ بإنشاء جرد جديد للمخزون\nلمتابعة وإدارة المنتجات بكفاءة',
              textAlign: TextAlign.center,
              style: getSemiBoldStyle(
                fontSize: 16,
                color: ColorManager.textSecondary,
              ),
            ),
            const SizedBox(height: 48),
            GradientButton(
              onPressed: () async {
                final result = await Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const CreateInventoryPage(),
                  ),
                );
                if (result == true && context.mounted) {
                  context.read<InventoryUserCubit>().getInventoryByUser();
                }
              },
              icon: Icons.add_rounded,
              label: 'إنشاء جرد جديد',
            ),
          ],
        ),
      ),
    );
  }
}
