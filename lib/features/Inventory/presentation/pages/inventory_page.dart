import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:stock_up/core/di/di.dart';
import 'package:stock_up/core/resources/color_manager.dart';
import 'package:stock_up/core/widgets/animated_background.dart';
import 'package:stock_up/features/Inventory/presentation/bloc/InventoryByUser/inventory_user_cubit.dart';
import 'package:stock_up/features/Inventory/presentation/bloc/update_audit_status/update_audit_status_cubit.dart';
import 'package:stock_up/features/Inventory/presentation/widgets/inventory_body.dart';

class InventoryPage extends StatefulWidget {
  const InventoryPage({super.key});

  @override
  State<InventoryPage> createState() => _InventoryPageState();
}

class _InventoryPageState extends State<InventoryPage> {
  late InventoryUserCubit inventoryUserCubit;

  @override
  void initState() {
    inventoryUserCubit = getIt<InventoryUserCubit>();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => inventoryUserCubit..getInventoryByUser(),
        ),
        BlocProvider(create: (context) => getIt<UpdateAuditStatusCubit>()),
      ],
      child: Stack(
        children: [
          AnimatedGradientBackground(),
          Scaffold(
            backgroundColor: Colors.transparent,
            appBar: buildAppBar(inventoryUserCubit: inventoryUserCubit),
            body: const InventoryBody(),
          ),
        ],
      ),
    );
  }

  PreferredSizeWidget buildAppBar({
    required InventoryUserCubit inventoryUserCubit,
  }) {
    return AppBar(
      elevation: 0,
      backgroundColor: Colors.transparent,
      leading: IconButton(
        icon: Icon(Icons.arrow_back_ios_new, color: ColorManager.purple2),
        onPressed: () {
          Navigator.pop(context);
        },
      ),
      title: ShaderMask(
        shaderCallback: (bounds) =>
            ColorManager.primaryGradient.createShader(bounds),
        child: const Text(
          'الجرد',
          style: TextStyle(
            color: Colors.white,
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      centerTitle: true,
      actions: [
        Container(
          margin: const EdgeInsets.only(left: 12),
          decoration: BoxDecoration(
            gradient: ColorManager.cardGradient,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: ColorManager.purple2.withOpacity(0.3),
              width: 1,
            ),
          ),
          child: IconButton(
            icon: Icon(Icons.refresh_rounded, color: ColorManager.purple2),
            onPressed: () {
              inventoryUserCubit.getInventoryByUser();
            },
          ),
        ),
      ],
    );
  }
}
