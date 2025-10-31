import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:stock_up/core/resources/color_manager.dart';
import 'package:stock_up/core/resources/style_manager.dart';
import 'package:stock_up/core/utils/cashed_data_shared_preferences.dart';
import 'package:stock_up/core/widgets/gradient_button.dart';
import 'package:stock_up/features/AuditItems/presentation/pages/AuditItems_page.dart';
import 'package:stock_up/features/AuditItems/presentation/pages/audit_products_page.dart';
import 'package:stock_up/features/Inventory/presentation/bloc/InventoryByUser/inventory_user_cubit.dart';
import 'package:stock_up/features/Inventory/presentation/bloc/update_audit_status/update_audit_status_cubit.dart';
import 'package:stock_up/features/Inventory/presentation/pages/inventory_detail_page.dart';
import 'package:stock_up/features/Inventory/presentation/widgets/empty_state.dart';
import 'package:stock_up/features/Inventory/presentation/widgets/error_widget.dart';
import 'package:stock_up/features/Inventory/presentation/widgets/loading_widget.dart';

class InventoryBody extends StatelessWidget {
  const InventoryBody({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocListener<UpdateAuditStatusCubit, UpdateAuditStatusState>(
      listener: (context, state) {
        if (state is UpdateAuditStatusLoaded) {
          final entity = state.updateAuditStatusEntity;
          if (entity?.status == 'success') {
            _showSnackBar(
              context,
              entity?.message ?? 'تم إنهاء الجرد بنجاح',
              ColorManager.success,
              Icons.check_circle_rounded,
            );
            context.read<InventoryUserCubit>().getInventoryByUser();
          } else if (entity?.status == 'error') {
            _showPendingItemsDialog(
              context,
              entity?.message ?? 'حدث خطأ',
              entity?.pendingItemsCount ?? 0,
            );
          }
        }
        if (state is UpdateAuditStatusError) {
          _showSnackBar(
            context,
            'حدث خطأ أثناء إنهاء الجرد',
            ColorManager.error,
            Icons.error_rounded,
          );
        }
      },
      child: BlocBuilder<InventoryUserCubit, InventoryUserState>(
        builder: (context, state) {
          if (state is InventoryUserLoading) {
            return LoadingWidget();
          }
          if (state is InventoryUserFailure) {
            return ErrorStateWidget();
          }
          if (state is InventoryUserSuccess) {
            final inventory = state.value?.data;
            if (inventory == null) {
              return EmptyState();
            }
            return _buildInventoryContent(context, inventory);
          }
          return const SizedBox.shrink();
        },
      ),
    );
  }

  Widget _buildInventoryContent(BuildContext context, dynamic inventory) {
    final isCompleted =
        (inventory.status ?? 'pending').toLowerCase() == 'completed';

    return Column(
      children: [
        Expanded(
          child: RefreshIndicator(
            onRefresh: () async {
              context.read<InventoryUserCubit>().getInventoryByUser();
            },
            color: ColorManager.purple2,
            child: SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              padding: const EdgeInsets.all(20),
              child: _buildInventoryCard(context, inventory),
            ),
          ),
        ),
        if (!isCompleted)
          _buildCompleteInventoryButton(context, inventory.id ?? 0),
      ],
    );
  }

  Widget _buildInventoryCard(BuildContext context, dynamic inventory) {
    final status = inventory.status ?? 'pending';
    final statusColor = _getStatusColor(status);
    final statusText = _getStatusText(status);
    final workersCount = (inventory.workers as List?)?.length ?? 0;

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(28),
        boxShadow: ColorManager.cardShadow,
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () async {
            final result = await Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => InventoryDetailPage(
                  inventoryId: inventory.id ?? 0,
                  inventory: inventory,
                ),
              ),
            );
            if (result == true && context.mounted) {
              context.read<InventoryUserCubit>().getInventoryByUser();
            }
          },
          borderRadius: BorderRadius.circular(28),
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Center(
                  child: ShaderMask(
                    shaderCallback: (bounds) => const LinearGradient(
                      colors: [Color(0xFF8B54BF), Color(0xFF7505B3)],
                    ).createShader(bounds),
                    child: Text(
                      CacheService.getData(key: CacheKeys.storeName),
                      style: getBoldStyle(color: Colors.white, fontSize: 20),
                    ),
                  ),
                ),
                SizedBox(height: 8),
                _buildCardHeader(inventory, statusColor, statusText),
                if (inventory.notes != null && inventory.notes!.isNotEmpty) ...[
                  const SizedBox(height: 20),
                  _buildNotesSection(inventory.notes!),
                ],
                const SizedBox(height: 20),
                _buildWorkersSection(workersCount),
                const SizedBox(height: 24),
                _buildActionButtons(context, inventory),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildCardHeader(
    dynamic inventory,
    Color statusColor,
    String statusText,
  ) {
    return Column(
      children: [
        Row(
          children: [
            Container(
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(
                gradient: ColorManager.primaryGradient,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: ColorManager.purple2.withOpacity(0.5),
                    blurRadius: 20,
                    offset: const Offset(0, 8),
                  ),
                ],
              ),
              child: const Icon(
                Icons.inventory_2_rounded,
                color: Colors.white,
                size: 32,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  ShaderMask(
                    shaderCallback: (bounds) =>
                        ColorManager.primaryGradient.createShader(bounds),
                    child: Text(
                      'جرد #${inventory.id}',
                      overflow: TextOverflow.ellipsis,
                      maxLines: 1,
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  const SizedBox(height: 6),
                  Row(
                    children: [
                      Icon(
                        Icons.calendar_today_rounded,
                        size: 16,
                        color: ColorManager.textSecondary,
                      ),
                      const SizedBox(width: 6),
                      Expanded(
                        child: Text(
                          inventory.auditDate ?? 'لم يتم تحديد التاريخ',
                          overflow: TextOverflow.ellipsis,
                          style: getSemiBoldStyle(
                            fontSize: 14,
                            color: ColorManager.textSecondary,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                statusColor.withOpacity(0.2),
                statusColor.withOpacity(0.1),
              ],
            ),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: statusColor.withOpacity(0.5), width: 2),
            boxShadow: [
              BoxShadow(
                color: statusColor.withOpacity(0.3),
                blurRadius: 15,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 10,
                height: 10,
                decoration: BoxDecoration(
                  color: statusColor,
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: statusColor.withOpacity(0.6),
                      blurRadius: 10,
                      spreadRadius: 2,
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 10),
              Text(
                statusText,
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                  color: statusColor,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildNotesSection(String notes) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: ColorManager.cardGradient,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: ColorManager.purple2.withOpacity(0.2),
          width: 1,
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                ShaderMask(
                  shaderCallback: (bounds) =>
                      ColorManager.primaryGradient.createShader(bounds),
                  child: Text(
                    'ملاحظات',
                    style: getSemiBoldStyle(fontSize: 12, color: Colors.white),
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  notes,
                  style: const TextStyle(
                    fontSize: 14,
                    color: ColorManager.textSecondary,
                    height: 1.4,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 12),
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  ColorManager.purple2.withOpacity(0.2),
                  ColorManager.purple3.withOpacity(0.2),
                ],
              ),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(
              Icons.note_alt_rounded,
              size: 20,
              color: ColorManager.purple2,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildWorkersSection(int workersCount) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: ColorManager.cardGradient,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: ColorManager.purple2.withOpacity(0.2),
          width: 1,
        ),
      ),
      child: Row(
        children: [
          Icon(
            Icons.arrow_back_ios_rounded,
            size: 18,
            color: ColorManager.purple2,
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                ShaderMask(
                  shaderCallback: (bounds) =>
                      ColorManager.primaryGradient.createShader(bounds),
                  child: const Text(
                    'فريق العمل',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  workersCount == 0
                      ? 'لم يتم إضافة عمال'
                      : '$workersCount عامل',
                  style: getSemiBoldStyle(
                    fontSize: 14,
                    color: ColorManager.textPrimary,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 14),
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  ColorManager.purple2.withOpacity(0.3),
                  ColorManager.purple3.withOpacity(0.3),
                ],
              ),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              Icons.people_rounded,
              color: ColorManager.purple2,
              size: 24,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionButtons(BuildContext context, dynamic inventory) {
    return Row(
      children: [
        Expanded(
          child: GradientButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const SearchProductsPage(),
                ),
              );
            },
            icon: Icons.qr_code_2,
            label: 'إضافة منتجات',
            gradient: LinearGradient(
              colors: [ColorManager.purple3, ColorManager.purple2],
            ),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: GradientButton(
            onPressed: () {
              _showStartDialog(context);
            },
            icon: Icons.play_arrow_rounded,
            label: 'بدء الجرد',
            gradient: const LinearGradient(
              colors: [Color(0xFF26DE81), Color(0xFF20BF6B)],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildCompleteInventoryButton(BuildContext context, int auditId) {
    return BlocBuilder<UpdateAuditStatusCubit, UpdateAuditStatusState>(
      builder: (context, state) {
        final isLoading = state is UpdateAuditStatusLoading;

        return Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.transparent,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 20,
                offset: const Offset(0, -4),
              ),
            ],
          ),
          child: Container(
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFF26DE81), Color(0xFF20BF6B)],
              ),
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: ColorManager.success.withOpacity(0.4),
                  blurRadius: 20,
                  offset: const Offset(0, 8),
                ),
              ],
            ),
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                onTap: isLoading
                    ? null
                    : () => _showCompleteDialog(context, auditId),
                borderRadius: BorderRadius.circular(20),
                child: Container(
                  padding: const EdgeInsets.symmetric(vertical: 18),
                  child: isLoading
                      ? const Center(
                          child: SizedBox(
                            height: 28,
                            width: 28,
                            child: CircularProgressIndicator(
                              strokeWidth: 3,
                              color: Colors.white,
                            ),
                          ),
                        )
                      : Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                              // padding: const EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                color: Colors.white.withOpacity(0.2),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: const Icon(
                                Icons.check_circle_rounded,
                                color: Colors.white,
                                size: 18,
                              ),
                            ),
                            const SizedBox(width: 12),
                            const Text(
                              'إنهاء الجرد',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                          ],
                        ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  // Widget _buildGradientButton({
  //   required VoidCallback onPressed,
  //   required IconData icon,
  //   required String label,
  //   Gradient? gradient,
  // }) {
  //   return Container(
  //     height: 56,
  //     decoration: BoxDecoration(
  //       gradient: gradient ?? ColorManager.primaryGradient,
  //       borderRadius: BorderRadius.circular(16),
  //       boxShadow: [
  //         BoxShadow(
  //           color: ColorManager.purple2.withOpacity(0.4),
  //           blurRadius: 15,
  //           offset: const Offset(0, 8),
  //         ),
  //       ],
  //     ),
  //     child: ElevatedButton(
  //       onPressed: onPressed,
  //       style: ElevatedButton.styleFrom(
  //         backgroundColor: Colors.transparent,
  //         shadowColor: Colors.transparent,
  //         shape: RoundedRectangleBorder(
  //           borderRadius: BorderRadius.circular(16),
  //         ),
  //       ),
  //       child: Row(
  //         mainAxisAlignment: MainAxisAlignment.center,
  //         children: [
  //           Expanded(child: Icon(icon, color: Colors.white, size: 24)),
  //           const SizedBox(width: 8),
  //           Expanded(
  //             flex: 2,
  //             child: Text(
  //               label,
  //               style: getSemiBoldStyle(fontSize: 16, color: Colors.white),
  //             ),
  //           ),
  //         ],
  //       ),
  //     ),
  //   );
  // }

  void _showStartDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        contentPadding: const EdgeInsets.all(24),
        title: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    ColorManager.success.withOpacity(0.2),
                    ColorManager.success.withOpacity(0.1),
                  ],
                ),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(
                Icons.play_arrow_rounded,
                color: ColorManager.success,
                size: 28,
              ),
            ),
            const SizedBox(width: 12),
            const Expanded(
              child: Text(
                'البدء في الجرد',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
        content: const Text(
          'هل تريد البدء في عملية الجرد؟\nسيتم تحديث حالة الجرد إلى "جاري التنفيذ".',
          style: TextStyle(height: 1.6, fontSize: 15),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: const Text(
              'إلغاء',
              style: TextStyle(color: ColorManager.textSecondary, fontSize: 16),
            ),
          ),
          Container(
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFF26DE81), Color(0xFF20BF6B)],
              ),
              borderRadius: BorderRadius.circular(12),
            ),
            child: TextButton(
              onPressed: () {
                Navigator.pop(dialogContext);
                _showSnackBar(
                  context,
                  'تم البدء في الجرد بنجاح',
                  ColorManager.success,
                  Icons.check_circle_rounded,
                );
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => AuditProductsPage()),
                );
              },
              style: TextButton.styleFrom(
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 12,
                ),
              ),
              child: const Text(
                'نعم، ابدأ',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showCompleteDialog(BuildContext context, int auditId) {
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        contentPadding: const EdgeInsets.all(24),
        title: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    ColorManager.success.withOpacity(0.2),
                    ColorManager.success.withOpacity(0.1),
                  ],
                ),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(
                Icons.check_circle_rounded,
                color: ColorManager.success,
                size: 28,
              ),
            ),
            const SizedBox(width: 12),
            const Expanded(
              child: Text(
                'إنهاء الجرد',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              'هل أنت متأكد من إنهاء الجرد؟',
              style: TextStyle(
                fontSize: 16,
                height: 1.6,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    ColorManager.warning.withOpacity(0.2),
                    ColorManager.warning.withOpacity(0.1),
                  ],
                ),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: ColorManager.warning.withOpacity(0.3),
                  width: 1.5,
                ),
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.info_outline,
                    color: ColorManager.warning,
                    size: 24,
                  ),
                  const SizedBox(width: 12),
                  const Expanded(
                    child: Text(
                      'سيتم إنهاء الجرد وتحويل حالته إلى مكتمل',
                      style: TextStyle(
                        fontSize: 14,
                        color: ColorManager.textSecondary,
                        height: 1.4,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: const Text(
              'إلغاء',
              style: TextStyle(color: ColorManager.textSecondary, fontSize: 16),
            ),
          ),
          Container(
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFF26DE81), Color(0xFF20BF6B)],
              ),
              borderRadius: BorderRadius.circular(12),
            ),
            child: TextButton(
              onPressed: () {
                Navigator.pop(dialogContext);
                context.read<UpdateAuditStatusCubit>().updateAuditStatus(
                  auditId: auditId,
                );
              },
              style: TextButton.styleFrom(
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 12,
                ),
              ),
              child: const Text(
                'نعم، إنهاء',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showPendingItemsDialog(
    BuildContext context,
    String message,
    int count,
  ) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        contentPadding: const EdgeInsets.all(24),
        title: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    ColorManager.warning.withOpacity(0.2),
                    ColorManager.warning.withOpacity(0.1),
                  ],
                ),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(
                Icons.warning_rounded,
                color: ColorManager.warning,
                size: 28,
              ),
            ),
            const SizedBox(width: 12),
            const Expanded(
              child: Text(
                'تنبيه',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(message, style: const TextStyle(fontSize: 16, height: 1.6)),
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    ColorManager.warning.withOpacity(0.2),
                    ColorManager.warning.withOpacity(0.1),
                  ],
                ),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: ColorManager.warning.withOpacity(0.5),
                  width: 2,
                ),
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.inventory_2_rounded,
                    color: ColorManager.warning,
                    size: 24,
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'عدد المنتجات المعلقة',
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w500,
                            color: ColorManager.textSecondary,
                          ),
                        ),
                        Text(
                          '$count منتج',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: ColorManager.warning,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        actions: [
          Container(
            decoration: BoxDecoration(
              gradient: ColorManager.primaryGradient,
              borderRadius: BorderRadius.circular(12),
            ),
            child: TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text(
                'فهمت',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showSnackBar(
    BuildContext context,
    String message,
    Color color,
    IconData icon,
  ) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            Icon(icon, color: Colors.white),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                message,
                style: const TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ],
        ),
        backgroundColor: color,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        margin: const EdgeInsets.all(16),
        duration: const Duration(seconds: 3),
      ),
    );
  }

  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'completed':
        return ColorManager.success;
      case 'in_progress':
        return ColorManager.warning;
      case 'pending':
      default:
        return ColorManager.purple2;
    }
  }

  String _getStatusText(String status) {
    switch (status.toLowerCase()) {
      case 'completed':
        return 'مكتمل';
      case 'in_progress':
        return 'جاري التنفيذ';
      case 'pending':
      default:
        return 'قيد الانتظار';
    }
  }
}
