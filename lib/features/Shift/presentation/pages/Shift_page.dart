import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:stock_up/core/di/di.dart';
import 'package:stock_up/features/Shift/presentation/bloc/Shift_cubit.dart';
import 'package:stock_up/features/Shift/presentation/bloc/closed_shift/closed_shifts_cubit.dart';
import 'package:stock_up/features/Shift/presentation/bloc/open_shift/open_shift_cubit.dart';
import 'package:stock_up/features/Shift/presentation/widgets/add_shift_dialog.dart';
import 'package:stock_up/features/Shift/presentation/widgets/closed_shifts_section.dart';
import 'package:stock_up/features/Shift/presentation/widgets/open_shift_card.dart';

class ShiftPage extends StatefulWidget {
  const ShiftPage({super.key});

  @override
  State<ShiftPage> createState() => _ShiftPageState();
}

class _ShiftPageState extends State<ShiftPage> {
  late ShiftCubit shiftCubit;
  late OpenShiftCubit openShiftCubit;
  late ClosedShiftsCubit closedShiftsCubit;

  @override
  void initState() {
    super.initState();
    shiftCubit = getIt.get<ShiftCubit>();
    openShiftCubit = getIt.get<OpenShiftCubit>();
    closedShiftsCubit = getIt.get<ClosedShiftsCubit>();

    // Load initial data
    openShiftCubit.getOpenUserShift();
    closedShiftsCubit.getClosedUserShift();
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider.value(value: shiftCubit),
        BlocProvider.value(value: openShiftCubit),
        BlocProvider.value(value: closedShiftsCubit),
      ],
      child: Scaffold(
        backgroundColor: Colors.grey[50],
        appBar: _buildAppBar(context),
        body: RefreshIndicator(
          onRefresh: _onRefresh,
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildPageHeader(context),
                  const SizedBox(height: 24),
                  _buildOpenShiftSection(context),
                  const SizedBox(height: 24),
                  const ClosedShiftsSection(),
                ],
              ),
            ),
          ),
        ),
        floatingActionButton: _buildFloatingActionButton(context),
      ),
    );
  }

  PreferredSizeWidget _buildAppBar(BuildContext context) {
    return AppBar(
      elevation: 0,
      backgroundColor: Theme.of(context).primaryColor,
      title: const Text(
        'إدارة الورديات',
        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 22),
      ),
      centerTitle: true,
      actions: [
        IconButton(
          icon: const Icon(Icons.refresh),
          onPressed: _onRefresh,
          tooltip: 'تحديث',
        ),
      ],
    );
  }

  Widget _buildPageHeader(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Theme.of(context).primaryColor,
            Theme.of(context).primaryColor.withOpacity(0.8),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Theme.of(context).primaryColor.withOpacity(0.3),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.2),
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(Icons.access_time, color: Colors.white, size: 32),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'نظام الورديات',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'إدارة وتتبع الورديات بسهولة',
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.9),
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildOpenShiftSection(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.only(bottom: 12),
          child: Text(
            'الوردية الحالية',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Color(0xFF2C3E50),
            ),
          ),
        ),
        BlocConsumer<OpenShiftCubit, OpenShiftState>(
          listener: (context, state) {
            if (state is UserShiftFailure) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(state.exception.toString()),
                  backgroundColor: Colors.red,
                ),
              );
            }
          },
          builder: (context, state) {
            if (state is UserShiftLoading) {
              return _buildLoadingCard();
            } else if (state is UserShiftSuccess) {
              if (state.data?.shift != null) {
                return OpenShiftCard(data: state.data!);
              } else {
                return _buildNoOpenShiftCard(context);
              }
            } else if (state is UserShiftFailure) {
              return _buildNoOpenShiftCard(context);
            }
            return _buildNoOpenShiftCard(context);
          },
        ),
      ],
    );
  }

  Widget _buildLoadingCard() {
    return Container(
      height: 200,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: const Center(child: CircularProgressIndicator()),
    );
  }

  Widget _buildNoOpenShiftCard(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(32),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: Colors.grey[300]!,
          width: 2,
          strokeAlign: BorderSide.strokeAlignInside,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.grey[100],
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.work_off_outlined,
              size: 64,
              color: Colors.grey[400],
            ),
          ),
          const SizedBox(height: 20),
          Text(
            'لا توجد وردية مفتوحة حالياً',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.grey[700],
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'ابدأ وردية جديدة للعمل',
            style: TextStyle(fontSize: 14, color: Colors.grey[500]),
          ),
          const SizedBox(height: 24),
          ElevatedButton.icon(
            onPressed: () => _showAddShiftDialog(context),
            icon: const Icon(Icons.add_circle_outline),
            label: const Text('فتح وردية جديدة'),
            style: ElevatedButton.styleFrom(
              backgroundColor: Theme.of(context).primaryColor,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              elevation: 2,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFloatingActionButton(BuildContext context) {
    return BlocBuilder<OpenShiftCubit, OpenShiftState>(
      builder: (context, state) {
        if (state is UserShiftSuccess && state.data?.shift != null) {
          return const SizedBox.shrink();
        }
        return FloatingActionButton.extended(
          onPressed: () => _showAddShiftDialog(context),
          icon: const Icon(Icons.add),
          label: const Text('وردية جديدة'),
          backgroundColor: Theme.of(context).primaryColor,
        );
      },
    );
  }

  void _showAddShiftDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (dialogContext) => MultiBlocProvider(
        providers: [
          BlocProvider.value(value: shiftCubit),
          BlocProvider.value(value: openShiftCubit),
        ],
        child: const AddShiftDialog(),
      ),
    );
  }

  Future<void> _onRefresh() async {
    await Future.wait([
      openShiftCubit.getOpenUserShift(),
      closedShiftsCubit.getClosedUserShift(),
    ]);
  }
}
