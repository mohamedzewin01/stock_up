import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:stock_up/core/di/di.dart';
import 'package:stock_up/core/resources/color_manager.dart';
import 'package:stock_up/features/Inventory/presentation/bloc/AddInventory/add_inventory_cubit.dart';
import 'package:stock_up/features/Inventory/presentation/bloc/users/users_inventory_cubit.dart';
import 'package:stock_up/features/Inventory/presentation/widgets/worker_card.dart';

class SelectWorkersPage extends StatefulWidget {
  final int auditId;

  const SelectWorkersPage({super.key, required this.auditId});

  @override
  State<SelectWorkersPage> createState() => _SelectWorkersPageState();
}

class _SelectWorkersPageState extends State<SelectWorkersPage>
    with SingleTickerProviderStateMixin {
  final Set<int> _selectedWorkerIds = {};
  bool _isAdding = false;
  String _searchQuery = '';
  late AnimationController _animationController;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => getIt<UsersInventoryCubit>()..getAllUsers(),
        ),
        BlocProvider(create: (context) => getIt<AddInventoryCubit>()),
      ],
      child: Builder(
        builder: (context) {
          return Scaffold(
            backgroundColor: ColorManager.lightBackground,
            appBar: _buildAppBar(context),
            body: BlocListener<AddInventoryCubit, AddInventoryState>(
              listener: _handleBlocListener,
              child: Column(
                children: [
                  _buildSearchBar(),
                  _buildSelectedCount(),
                  Expanded(child: _buildWorkersList()),
                  _buildBottomButton(context),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  PreferredSizeWidget _buildAppBar(BuildContext context) {
    return AppBar(
      elevation: 0,
      backgroundColor: Colors.white,
      leading: Container(
        margin: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          gradient: ColorManager.cardGradient,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: ColorManager.purple2.withOpacity(0.3),
            width: 1,
          ),
        ),
        child: IconButton(
          icon: Icon(Icons.arrow_back_rounded, color: ColorManager.purple2),
          onPressed: () => _handleBackPress(context),
        ),
      ),
      title: ShaderMask(
        shaderCallback: (bounds) =>
            ColorManager.primaryGradient.createShader(bounds),
        child: const Text(
          'اختيار العمال',
          style: TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      centerTitle: true,
    );
  }

  Widget _buildSearchBar() {
    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: ColorManager.cardShadow,
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              gradient: ColorManager.cardGradient,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(
              Icons.search_rounded,
              color: ColorManager.purple2,
              size: 22,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: TextField(
              textAlign: TextAlign.right,
              onChanged: (value) => setState(() => _searchQuery = value),
              style: const TextStyle(fontSize: 15),
              decoration: InputDecoration(
                hintText: 'بحث عن عامل...',
                hintStyle: TextStyle(color: Colors.grey[400], fontSize: 15),
                border: InputBorder.none,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSelectedCount() {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      margin: const EdgeInsets.symmetric(horizontal: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: _selectedWorkerIds.isEmpty
            ? ColorManager.cardGradient
            : LinearGradient(
                colors: [
                  ColorManager.purple2.withOpacity(0.2),
                  ColorManager.purple3.withOpacity(0.2),
                ],
              ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: _selectedWorkerIds.isEmpty
              ? ColorManager.purple2.withOpacity(0.2)
              : ColorManager.purple2.withOpacity(0.5),
          width: 2,
        ),
        boxShadow: _selectedWorkerIds.isEmpty
            ? []
            : [
                BoxShadow(
                  color: ColorManager.purple2.withOpacity(0.3),
                  blurRadius: 20,
                  offset: const Offset(0, 8),
                ),
              ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  ColorManager.purple2.withOpacity(0.3),
                  ColorManager.purple3.withOpacity(0.3),
                ],
              ),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(
              Icons.people_rounded,
              color: ColorManager.purple2,
              size: 20,
            ),
          ),
          const SizedBox(width: 12),
          ShaderMask(
            shaderCallback: (bounds) =>
                ColorManager.primaryGradient.createShader(bounds),
            child: Text(
              _selectedWorkerIds.isEmpty
                  ? 'لم يتم اختيار أي عامل'
                  : 'تم اختيار ${_selectedWorkerIds.length} عامل',
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildWorkersList() {
    return BlocBuilder<UsersInventoryCubit, UsersInventoryState>(
      builder: (context, state) {
        if (state is UsersInventoryLoading) {
          return Center(
            child: CircularProgressIndicator(
              color: ColorManager.purple2,
              strokeWidth: 3,
            ),
          );
        }

        if (state is UsersInventoryFailure) {
          return _buildErrorWidget();
        }

        if (state is UsersInventorySuccess) {
          final users = state.value?.users ?? [];
          final filteredUsers = users.where((user) {
            if (_searchQuery.isEmpty) return true;
            final fullName = '${user.firstName ?? ''} ${user.lastName ?? ''}'
                .toLowerCase();
            return fullName.contains(_searchQuery.toLowerCase());
          }).toList();

          if (filteredUsers.isEmpty) {
            return _buildEmptyState();
          }

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: filteredUsers.length,
            itemBuilder: (context, index) {
              final user = filteredUsers[index];
              return WorkerCard(
                user: user,
                isSelected: _selectedWorkerIds.contains(user.id),
                onTap: () => _toggleWorkerSelection(user.id),
              );
            },
          );
        }

        return const SizedBox.shrink();
      },
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: ColorManager.cardGradient,
            ),
            child: Icon(
              Icons.search_off_rounded,
              size: 64,
              color: ColorManager.purple2,
            ),
          ),
          const SizedBox(height: 20),
          ShaderMask(
            shaderCallback: (bounds) =>
                ColorManager.primaryGradient.createShader(bounds),
            child: const Text(
              'لا توجد نتائج',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'جرب البحث بكلمات مختلفة',
            style: TextStyle(fontSize: 14, color: ColorManager.textSecondary),
          ),
        ],
      ),
    );
  }

  Widget _buildErrorWidget() {
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
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 32),
            _buildGradientButton(
              onPressed: () =>
                  context.read<UsersInventoryCubit>().getAllUsers(),
              icon: Icons.refresh_rounded,
              label: 'إعادة المحاولة',
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBottomButton(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 20,
            offset: const Offset(0, -4),
          ),
        ],
      ),
      child: SafeArea(
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          decoration: BoxDecoration(
            gradient: _selectedWorkerIds.isEmpty
                ? LinearGradient(colors: [Colors.grey[400]!, Colors.grey[400]!])
                : ColorManager.primaryGradient,
            borderRadius: BorderRadius.circular(20),
            boxShadow: _selectedWorkerIds.isEmpty
                ? []
                : [
                    BoxShadow(
                      color: ColorManager.purple2.withOpacity(0.5),
                      blurRadius: 30,
                      offset: const Offset(0, 10),
                    ),
                  ],
          ),
          child: ElevatedButton(
            onPressed: _selectedWorkerIds.isEmpty || _isAdding
                ? null
                : () => _handleAddWorkers(context),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.transparent,
              shadowColor: Colors.transparent,
              padding: const EdgeInsets.symmetric(vertical: 18),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
            ),
            child: _isAdding
                ? const SizedBox(
                    height: 24,
                    width: 24,
                    child: CircularProgressIndicator(
                      strokeWidth: 3,
                      color: Colors.white,
                    ),
                  )
                : Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        padding: const EdgeInsets.all(6),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Icon(
                          _selectedWorkerIds.isEmpty
                              ? Icons.people_outline_rounded
                              : Icons.check_circle_rounded,
                          color: Colors.white,
                          size: 20,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Text(
                        _selectedWorkerIds.isEmpty
                            ? 'اختر العمال للمتابعة'
                            : 'إضافة ${_selectedWorkerIds.length} عامل',
                        style: const TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
          ),
        ),
      ),
    );
  }

  Widget _buildGradientButton({
    required VoidCallback onPressed,
    required IconData icon,
    required String label,
  }) {
    return Container(
      decoration: BoxDecoration(
        gradient: ColorManager.primaryGradient,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: ColorManager.purple2.withOpacity(0.4),
            blurRadius: 15,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: ElevatedButton.icon(
        onPressed: onPressed,
        icon: Icon(icon, color: Colors.white),
        label: Text(label, style: const TextStyle(color: Colors.white)),
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.transparent,
          shadowColor: Colors.transparent,
          padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
        ),
      ),
    );
  }

  void _toggleWorkerSelection(int? workerId) {
    if (workerId == null) return;
    setState(() {
      if (_selectedWorkerIds.contains(workerId)) {
        _selectedWorkerIds.remove(workerId);
      } else {
        _selectedWorkerIds.add(workerId);
        _animationController.forward().then((_) {
          _animationController.reverse();
        });
      }
    });
  }

  void _handleAddWorkers(BuildContext context) {
    context.read<AddInventoryCubit>().addInventoryAuditUsers(
      userIds: _selectedWorkerIds.toList(),
    );
  }

  void _handleBlocListener(BuildContext context, AddInventoryState state) {
    if (state is AddInventoryLoading) {
      setState(() => _isAdding = true);
    } else {
      setState(() => _isAdding = false);
    }

    if (state is AddInventorySuccess) {
      _showSnackBar(
        context,
        'تم إضافة العمال بنجاح',
        ColorManager.success,
        Icons.check_circle_rounded,
      );
      Future.delayed(const Duration(milliseconds: 500), () {
        Navigator.pop(context, true);
      });
    }

    if (state is AddInventoryFailure) {
      _showSnackBar(
        context,
        'فشل إضافة العمال، حاول مرة أخرى',
        ColorManager.error,
        Icons.error_rounded,
      );
    }
  }

  void _handleBackPress(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        contentPadding: const EdgeInsets.all(24),
        title: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    ColorManager.warning.withOpacity(0.2),
                    ColorManager.warning.withOpacity(0.1),
                  ],
                ),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(Icons.warning_rounded, color: ColorManager.warning),
            ),
            const SizedBox(width: 12),
            const Text('تأكيد الإلغاء', style: TextStyle(fontSize: 18)),
          ],
        ),
        content: const Text(
          'هل تريد إلغاء عملية إضافة العمال؟\nسيتم فقدان البيانات المدخلة.',
          style: TextStyle(height: 1.5),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              'إلغاء',
              style: TextStyle(color: ColorManager.textSecondary),
            ),
          ),
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [ColorManager.error, ColorManager.error],
              ),
              borderRadius: BorderRadius.circular(12),
            ),
            child: TextButton(
              onPressed: () {
                Navigator.pop(context);
                Navigator.pop(context, false);
              },
              style: TextButton.styleFrom(
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 10,
                ),
              ),
              child: const Text(
                'نعم، إلغاء',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
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
    Color backgroundColor,
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
        backgroundColor: backgroundColor,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        margin: const EdgeInsets.all(16),
        duration: const Duration(seconds: 3),
      ),
    );
  }
}
