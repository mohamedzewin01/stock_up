import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:stock_up/core/di/di.dart';
import 'package:stock_up/features/Inventory/presentation/bloc/InventoryByUser/inventory_user_cubit.dart';
import 'package:stock_up/features/Inventory/presentation/pages/create_inventory_page.dart';
import 'package:stock_up/features/Inventory/presentation/pages/inventory_detail_page.dart';

class InventoryListPage extends StatefulWidget {
  const InventoryListPage({super.key});

  @override
  State<InventoryListPage> createState() => _InventoryListPageState();
}

class _InventoryListPageState extends State<InventoryListPage> {
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return BlocProvider(
      create: (context) => getIt<InventoryUserCubit>()..getInventoryByUser(),
      child: Scaffold(
        backgroundColor: const Color(0xFFF8F9FD),
        appBar: _buildAppBar(context),
        body: BlocBuilder<InventoryUserCubit, InventoryUserState>(
          builder: (context, state) {
            if (state is InventoryUserLoading) {
              return Center(
                child: CircularProgressIndicator(
                  color: const Color(0xFF6C63FF),
                  strokeWidth: 3,
                ),
              );
            }

            if (state is InventoryUserFailure) {
              return _buildErrorWidget(context);
            }

            if (state is InventoryUserSuccess) {
              final inventory = state.value?.data;

              if (inventory == null) {
                return _buildEmptyState(context);
              }

              return RefreshIndicator(
                onRefresh: () async {
                  context.read<InventoryUserCubit>().getInventoryByUser();
                },
                color: const Color(0xFF6C63FF),
                child: SingleChildScrollView(
                  physics: const AlwaysScrollableScrollPhysics(),
                  padding: EdgeInsets.all(size.width * 0.04),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [_buildInventoryCard(context, inventory)],
                  ),
                ),
              );
            }

            return const SizedBox.shrink();
          },
        ),
        floatingActionButton: _buildFloatingActionButton(context),
      ),
    );
  }

  PreferredSizeWidget _buildAppBar(BuildContext context) {
    return AppBar(
      elevation: 0,
      backgroundColor: Colors.white,
      title: const Text(
        'الجرد',
        style: TextStyle(
          color: Color(0xFF2D3436),
          fontSize: 22,
          fontWeight: FontWeight.bold,
        ),
      ),
      centerTitle: true,
      actions: [
        Container(
          margin: const EdgeInsets.only(left: 8),
          decoration: BoxDecoration(
            color: const Color(0xFF6C63FF).withOpacity(0.1),
            borderRadius: BorderRadius.circular(12),
          ),
          child: IconButton(
            icon: const Icon(Icons.refresh_rounded, color: Color(0xFF6C63FF)),
            onPressed: () {
              context.read<InventoryUserCubit>().getInventoryByUser();
            },
          ),
        ),
      ],
    );
  }

  Widget _buildInventoryCard(BuildContext context, dynamic inventory) {
    final status = inventory.status ?? 'pending';
    final statusColor = _getStatusColor(status);
    final statusText = _getStatusText(status);
    final workersCount = (inventory.workers as List?)?.length ?? 0;

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.06),
            blurRadius: 20,
            offset: const Offset(0, 4),
          ),
        ],
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

            if (result == true) {
              context.read<InventoryUserCubit>().getInventoryByUser();
            }
          },
          borderRadius: BorderRadius.circular(24),
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          colors: [Color(0xFF6C63FF), Color(0xFF5A52D5)],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [
                          BoxShadow(
                            color: const Color(0xFF6C63FF).withOpacity(0.3),
                            blurRadius: 12,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: const Icon(
                        Icons.inventory_2_rounded,
                        color: Colors.white,
                        size: 28,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'جرد #${inventory.id}',
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF2D3436),
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            inventory.auditDate ?? '',
                            style: TextStyle(
                              fontSize: 13,
                              color: const Color(0xFF636E72),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: statusColor.withOpacity(0.15),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: statusColor.withOpacity(0.3),
                          width: 1.5,
                        ),
                      ),
                      child: Text(
                        statusText,
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          color: statusColor,
                        ),
                      ),
                    ),
                  ],
                ),
                if (inventory.notes != null && inventory.notes!.isNotEmpty) ...[
                  const SizedBox(height: 16),
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: const Color(0xFFF8F9FD),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      children: [
                        Icon(
                          Icons.note_alt_outlined,
                          size: 18,
                          color: const Color(0xFF636E72),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            inventory.notes!,
                            style: const TextStyle(
                              fontSize: 14,
                              color: Color(0xFF636E72),
                            ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
                const SizedBox(height: 16),
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        const Color(0xFF6C63FF).withOpacity(0.1),
                        const Color(0xFF4ECDC4).withOpacity(0.1),
                      ],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: const Color(0xFF6C63FF).withOpacity(0.2),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: const Icon(
                          Icons.people_rounded,
                          color: Color(0xFF6C63FF),
                          size: 20,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Text(
                        workersCount == 0
                            ? 'لم يتم إضافة عمال'
                            : '$workersCount عامل',
                        style: const TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF6C63FF),
                        ),
                      ),
                      const Spacer(),
                      Icon(
                        Icons.arrow_forward_ios_rounded,
                        size: 16,
                        color: const Color(0xFF6C63FF),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    return Center(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(32),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    const Color(0xFF6C63FF).withOpacity(0.1),
                    const Color(0xFF4ECDC4).withOpacity(0.1),
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.inventory_2_outlined,
                size: 80,
                color: const Color(0xFF6C63FF),
              ),
            ),
            const SizedBox(height: 32),
            const Text(
              'لا يوجد جرد حالي',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Color(0xFF2D3436),
              ),
            ),
            const SizedBox(height: 12),
            Text(
              'ابدأ بإنشاء جرد جديد للمخزون',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 15,
                color: const Color(0xFF636E72),
                height: 1.5,
              ),
            ),
            const SizedBox(height: 40),
            _buildCreateButton(context),
          ],
        ),
      ),
    );
  }

  Widget _buildErrorWidget(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: const Color(0xFFFF6B9D).withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.error_outline_rounded,
                size: 64,
                color: Color(0xFFFF6B9D),
              ),
            ),
            const SizedBox(height: 24),
            const Text(
              'حدث خطأ أثناء جلب البيانات',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Color(0xFF2D3436),
              ),
            ),
            const SizedBox(height: 32),
            Container(
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFF6C63FF), Color(0xFF5A52D5)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFF6C63FF).withOpacity(0.3),
                    blurRadius: 12,
                    offset: const Offset(0, 6),
                  ),
                ],
              ),
              child: ElevatedButton.icon(
                onPressed: () {
                  context.read<InventoryUserCubit>().getInventoryByUser();
                },
                icon: const Icon(Icons.refresh_rounded),
                label: const Text('إعادة المحاولة'),
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

  Widget _buildCreateButton(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF6C63FF), Color(0xFF5A52D5)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF6C63FF).withOpacity(0.4),
            blurRadius: 15,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: ElevatedButton.icon(
        onPressed: () async {
          final result = await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const CreateInventoryPage(),
            ),
          );

          if (result == true) {
            context.read<InventoryUserCubit>().getInventoryByUser();
          }
        },
        icon: const Icon(Icons.add_rounded, color: Colors.white),
        label: const Text(
          'إنشاء جرد جديد',
          style: TextStyle(
            fontSize: 17,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.transparent,
          shadowColor: Colors.transparent,
          padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 18),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
        ),
      ),
    );
  }

  Widget _buildFloatingActionButton(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF6C63FF), Color(0xFF5A52D5)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF6C63FF).withOpacity(0.4),
            blurRadius: 15,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: FloatingActionButton.extended(
        onPressed: () async {
          final result = await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const CreateInventoryPage(),
            ),
          );

          if (result == true) {
            context.read<InventoryUserCubit>().getInventoryByUser();
          }
        },
        backgroundColor: Colors.transparent,
        elevation: 0,
        icon: const Icon(Icons.add_rounded),
        label: const Text(
          'إنشاء جرد',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
    );
  }

  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'completed':
        return const Color(0xFF26DE81);
      case 'in_progress':
        return const Color(0xFFFEA47F);
      case 'pending':
      default:
        return const Color(0xFF6C63FF);
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
