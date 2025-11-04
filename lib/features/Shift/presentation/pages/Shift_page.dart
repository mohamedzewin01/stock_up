// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:stock_up/core/di/di.dart';
// import 'package:stock_up/features/Shift/presentation/bloc/Shift_cubit.dart';
// import 'package:stock_up/features/Shift/presentation/bloc/closed_shift/closed_shifts_cubit.dart';
// import 'package:stock_up/features/Shift/presentation/bloc/open_shift/open_shift_cubit.dart';
// import 'package:stock_up/features/Shift/presentation/widgets/add_shift_dialog.dart';
// import 'package:stock_up/features/Shift/presentation/widgets/closed_shifts_section.dart';
// import 'package:stock_up/features/Shift/presentation/widgets/open_shift_card.dart';
//
// class ShiftPage extends StatefulWidget {
//   const ShiftPage({super.key});
//
//   @override
//   State<ShiftPage> createState() => _ShiftPageState();
// }
//
// class _ShiftPageState extends State<ShiftPage> {
//   late ShiftCubit shiftCubit;
//   late OpenShiftCubit openShiftCubit;
//   late ClosedShiftsCubit closedShiftsCubit;
//
//   @override
//   void initState() {
//     super.initState();
//     shiftCubit = getIt.get<ShiftCubit>();
//     openShiftCubit = getIt.get<OpenShiftCubit>();
//     closedShiftsCubit = getIt.get<ClosedShiftsCubit>();
//
//     // Load initial data
//     openShiftCubit.getOpenUserShift();
//     closedShiftsCubit.getClosedUserShift();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return MultiBlocProvider(
//       providers: [
//         BlocProvider.value(value: shiftCubit),
//         BlocProvider.value(value: openShiftCubit),
//         BlocProvider.value(value: closedShiftsCubit),
//       ],
//       child: Scaffold(
//         backgroundColor: Colors.grey[50],
//         appBar: _buildAppBar(context),
//         body: RefreshIndicator(
//           onRefresh: _onRefresh,
//           child: SingleChildScrollView(
//             physics: const AlwaysScrollableScrollPhysics(),
//             child: Padding(
//               padding: const EdgeInsets.all(16.0),
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   _buildPageHeader(context),
//                   const SizedBox(height: 24),
//                   _buildOpenShiftSection(context),
//                   const SizedBox(height: 24),
//                   const ClosedShiftsSection(),
//                 ],
//               ),
//             ),
//           ),
//         ),
//         floatingActionButton: _buildFloatingActionButton(context),
//       ),
//     );
//   }
//
//   PreferredSizeWidget _buildAppBar(BuildContext context) {
//     return AppBar(
//       elevation: 0,
//       backgroundColor: Theme.of(context).primaryColor,
//       title: const Text(
//         'إدارة الورديات',
//         style: TextStyle(fontWeight: FontWeight.bold, fontSize: 22),
//       ),
//       centerTitle: true,
//       actions: [
//         IconButton(
//           icon: const Icon(Icons.refresh),
//           onPressed: _onRefresh,
//           tooltip: 'تحديث',
//         ),
//       ],
//     );
//   }
//
//   Widget _buildPageHeader(BuildContext context) {
//     return Container(
//       padding: const EdgeInsets.all(20),
//       decoration: BoxDecoration(
//         gradient: LinearGradient(
//           colors: [
//             Theme.of(context).primaryColor,
//             Theme.of(context).primaryColor.withOpacity(0.8),
//           ],
//           begin: Alignment.topLeft,
//           end: Alignment.bottomRight,
//         ),
//         borderRadius: BorderRadius.circular(16),
//         boxShadow: [
//           BoxShadow(
//             color: Theme.of(context).primaryColor.withOpacity(0.3),
//             blurRadius: 12,
//             offset: const Offset(0, 4),
//           ),
//         ],
//       ),
//       child: Row(
//         children: [
//           Container(
//             padding: const EdgeInsets.all(12),
//             decoration: BoxDecoration(
//               color: Colors.white.withOpacity(0.2),
//               borderRadius: BorderRadius.circular(12),
//             ),
//             child: const Icon(Icons.access_time, color: Colors.white, size: 32),
//           ),
//           const SizedBox(width: 16),
//           Expanded(
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 const Text(
//                   'نظام الورديات',
//                   style: TextStyle(
//                     color: Colors.white,
//                     fontSize: 20,
//                     fontWeight: FontWeight.bold,
//                   ),
//                 ),
//                 const SizedBox(height: 4),
//                 Text(
//                   'إدارة وتتبع الورديات بسهولة',
//                   style: TextStyle(
//                     color: Colors.white.withOpacity(0.9),
//                     fontSize: 14,
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }
//
//   Widget _buildOpenShiftSection(BuildContext context) {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         const Padding(
//           padding: EdgeInsets.only(bottom: 12),
//           child: Text(
//             'الوردية الحالية',
//             style: TextStyle(
//               fontSize: 20,
//               fontWeight: FontWeight.bold,
//               color: Color(0xFF2C3E50),
//             ),
//           ),
//         ),
//         BlocConsumer<OpenShiftCubit, OpenShiftState>(
//           listener: (context, state) {
//             if (state is UserShiftFailure) {
//               ScaffoldMessenger.of(context).showSnackBar(
//                 SnackBar(
//                   content: Text(state.exception.toString()),
//                   backgroundColor: Colors.red,
//                 ),
//               );
//             }
//           },
//           builder: (context, state) {
//             if (state is UserShiftLoading) {
//               return _buildLoadingCard();
//             } else if (state is UserShiftSuccess) {
//               if (state.data?.shift != null) {
//                 return OpenShiftCard(data: state.data!);
//               } else {
//                 return _buildNoOpenShiftCard(context);
//               }
//             } else if (state is UserShiftFailure) {
//               return _buildNoOpenShiftCard(context);
//             }
//             return _buildNoOpenShiftCard(context);
//           },
//         ),
//       ],
//     );
//   }
//
//   Widget _buildLoadingCard() {
//     return Container(
//       height: 200,
//       decoration: BoxDecoration(
//         color: Colors.white,
//         borderRadius: BorderRadius.circular(16),
//         boxShadow: [
//           BoxShadow(
//             color: Colors.black.withOpacity(0.05),
//             blurRadius: 10,
//             offset: const Offset(0, 2),
//           ),
//         ],
//       ),
//       child: const Center(child: CircularProgressIndicator()),
//     );
//   }
//
//   Widget _buildNoOpenShiftCard(BuildContext context) {
//     return Container(
//       padding: const EdgeInsets.all(32),
//       decoration: BoxDecoration(
//         color: Colors.white,
//         borderRadius: BorderRadius.circular(16),
//         border: Border.all(
//           color: Colors.grey[300]!,
//           width: 2,
//           strokeAlign: BorderSide.strokeAlignInside,
//         ),
//         boxShadow: [
//           BoxShadow(
//             color: Colors.black.withOpacity(0.05),
//             blurRadius: 10,
//             offset: const Offset(0, 2),
//           ),
//         ],
//       ),
//       child: Column(
//         children: [
//           Container(
//             padding: const EdgeInsets.all(20),
//             decoration: BoxDecoration(
//               color: Colors.grey[100],
//               shape: BoxShape.circle,
//             ),
//             child: Icon(
//               Icons.work_off_outlined,
//               size: 64,
//               color: Colors.grey[400],
//             ),
//           ),
//           const SizedBox(height: 20),
//           Text(
//             'لا توجد وردية مفتوحة حالياً',
//             style: TextStyle(
//               fontSize: 18,
//               fontWeight: FontWeight.bold,
//               color: Colors.grey[700],
//             ),
//           ),
//           const SizedBox(height: 8),
//           Text(
//             'ابدأ وردية جديدة للعمل',
//             style: TextStyle(fontSize: 14, color: Colors.grey[500]),
//           ),
//           const SizedBox(height: 24),
//           ElevatedButton.icon(
//             onPressed: () => _showAddShiftDialog(context),
//             icon: const Icon(Icons.add_circle_outline),
//             label: const Text('فتح وردية جديدة'),
//             style: ElevatedButton.styleFrom(
//               backgroundColor: Theme.of(context).primaryColor,
//               foregroundColor: Colors.white,
//               padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
//               shape: RoundedRectangleBorder(
//                 borderRadius: BorderRadius.circular(12),
//               ),
//               elevation: 2,
//             ),
//           ),
//         ],
//       ),
//     );
//   }
//
//   Widget _buildFloatingActionButton(BuildContext context) {
//     return BlocBuilder<OpenShiftCubit, OpenShiftState>(
//       builder: (context, state) {
//         if (state is UserShiftSuccess && state.data?.shift != null) {
//           return const SizedBox.shrink();
//         }
//         return FloatingActionButton.extended(
//           onPressed: () => _showAddShiftDialog(context),
//           icon: const Icon(Icons.add),
//           label: const Text('وردية جديدة'),
//           backgroundColor: Theme.of(context).primaryColor,
//         );
//       },
//     );
//   }
//
//   void _showAddShiftDialog(BuildContext context) {
//     showDialog(
//       context: context,
//       builder: (dialogContext) => MultiBlocProvider(
//         providers: [
//           BlocProvider.value(value: shiftCubit),
//           BlocProvider.value(value: openShiftCubit),
//         ],
//         child: const AddShiftDialog(),
//       ),
//     );
//   }
//
//   Future<void> _onRefresh() async {
//     await Future.wait([
//       openShiftCubit.getOpenUserShift(),
//       closedShiftsCubit.getClosedUserShift(),
//     ]);
//   }
// }
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

class _ShiftPageState extends State<ShiftPage>
    with SingleTickerProviderStateMixin {
  late ShiftCubit shiftCubit;
  late OpenShiftCubit openShiftCubit;
  late ClosedShiftsCubit closedShiftsCubit;
  late TabController _tabController;

  // ألوان محسنة
  final Color primaryColor = const Color(0xFF6366F1); // Indigo
  final Color secondaryColor = const Color(0xFF8B5CF6); // Purple
  final Color accentColor = const Color(0xFF10B981); // Green
  final Color backgroundColor = const Color(0xFFF8FAFC);

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    shiftCubit = getIt.get<ShiftCubit>();
    openShiftCubit = getIt.get<OpenShiftCubit>();
    closedShiftsCubit = getIt.get<ClosedShiftsCubit>();

    // Load initial data
    openShiftCubit.getOpenUserShift();
    closedShiftsCubit.getClosedUserShift();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
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
        backgroundColor: backgroundColor,
        body: NestedScrollView(
          headerSliverBuilder: (context, innerBoxIsScrolled) {
            return [_buildSliverAppBar(context, innerBoxIsScrolled)];
          },
          body: Column(
            children: [
              _buildTabBar(),
              Expanded(
                child: TabBarView(
                  controller: _tabController,
                  children: [_buildOpenShiftTab(), _buildClosedShiftsTab()],
                ),
              ),
            ],
          ),
        ),
        floatingActionButton: _buildFloatingActionButton(context),
      ),
    );
  }

  Widget _buildSliverAppBar(BuildContext context, bool innerBoxIsScrolled) {
    return SliverAppBar(
      expandedHeight: 200,
      floating: false,
      pinned: true,
      elevation: 0,
      backgroundColor: primaryColor,
      flexibleSpace: FlexibleSpaceBar(
        centerTitle: true,
        title: AnimatedOpacity(
          opacity: innerBoxIsScrolled ? 1.0 : 0.0,
          duration: const Duration(milliseconds: 200),
          child: const Text(
            'إدارة الورديات',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 18,
              color: Colors.white,
            ),
          ),
        ),
        background: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [primaryColor, secondaryColor],
            ),
          ),
          child: SafeArea(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(height: 20),
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.2),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.access_time_rounded,
                    size: 50,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 12),
                const Text(
                  'نظام الورديات',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'إدارة وتتبع الورديات بسهولة',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.white.withOpacity(0.9),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      actions: [
        IconButton(
          icon: const Icon(Icons.refresh_rounded, color: Colors.white),
          onPressed: _onRefresh,
          tooltip: 'تحديث',
        ),
        const SizedBox(width: 8),
      ],
    );
  }

  Widget _buildTabBar() {
    return Container(
      margin: const EdgeInsets.all(16),
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
      child: TabBar(
        controller: _tabController,
        indicator: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          gradient: LinearGradient(colors: [primaryColor, secondaryColor]),
        ),
        labelColor: Colors.white,
        unselectedLabelColor: Colors.grey[600],
        labelStyle: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
        unselectedLabelStyle: const TextStyle(
          fontWeight: FontWeight.w500,
          fontSize: 15,
        ),
        tabs: const [
          Tab(icon: Icon(Icons.work_outline_rounded), text: 'الوردية الحالية'),
          Tab(icon: Icon(Icons.history_rounded), text: 'الورديات السابقة'),
        ],
      ),
    );
  }

  Widget _buildOpenShiftTab() {
    return RefreshIndicator(
      onRefresh: () => openShiftCubit.getOpenUserShift(),
      color: primaryColor,
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: const EdgeInsets.fromLTRB(16, 0, 16, 100),
        child: BlocConsumer<OpenShiftCubit, OpenShiftState>(
          listener: (context, state) {
            if (state is UserShiftFailure) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Row(
                    children: [
                      const Icon(Icons.error_outline, color: Colors.white),
                      const SizedBox(width: 12),
                      Expanded(child: Text(state.exception.toString())),
                    ],
                  ),
                  backgroundColor: Colors.red[400],
                  behavior: SnackBarBehavior.floating,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              );
            }
          },
          builder: (context, state) {
            if (state is UserShiftLoading) {
              return _buildLoadingState();
            } else if (state is UserShiftSuccess) {
              if (state.data?.shift != null) {
                return Column(
                  children: [
                    const SizedBox(height: 16),
                    OpenShiftCard(data: state.data!),
                  ],
                );
              } else {
                return _buildNoOpenShiftCard(context);
              }
            }
            return _buildNoOpenShiftCard(context);
          },
        ),
      ),
    );
  }

  Widget _buildClosedShiftsTab() {
    return RefreshIndicator(
      onRefresh: () => closedShiftsCubit.getClosedUserShift(),
      color: primaryColor,
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 100),
        child: const ClosedShiftsSection(),
      ),
    );
  }

  Widget _buildLoadingState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(60),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(primaryColor),
              strokeWidth: 3,
            ),
            const SizedBox(height: 16),
            Text(
              'جاري التحميل...',
              style: TextStyle(color: Colors.grey[600], fontSize: 14),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNoOpenShiftCard(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 40),
        child: Container(
          margin: const EdgeInsets.symmetric(horizontal: 20),
          padding: const EdgeInsets.all(40),
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
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      primaryColor.withOpacity(0.1),
                      secondaryColor.withOpacity(0.1),
                    ],
                  ),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.work_off_outlined,
                  size: 70,
                  color: primaryColor,
                ),
              ),
              const SizedBox(height: 24),
              Text(
                'لا توجد وردية مفتوحة',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Colors.grey[800],
                ),
              ),
              const SizedBox(height: 12),
              Text(
                'ابدأ وردية جديدة للبدء في العمل',
                style: TextStyle(fontSize: 15, color: Colors.grey[600]),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 32),
              ElevatedButton.icon(
                onPressed: () => _showAddShiftDialog(context),
                icon: const Icon(Icons.add_circle_outline_rounded, size: 24),
                label: const Text(
                  'فتح وردية جديدة',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: accentColor,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 32,
                    vertical: 16,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  elevation: 4,
                  shadowColor: accentColor.withOpacity(0.4),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFloatingActionButton(BuildContext context) {
    return BlocBuilder<OpenShiftCubit, OpenShiftState>(
      builder: (context, state) {
        // إظهار الزر فقط في تبويب الوردية الحالية وعندما لا توجد وردية مفتوحة
        if (_tabController.index == 0 &&
            (state is! UserShiftSuccess || state.data?.shift == null)) {
          return FloatingActionButton.extended(
            onPressed: () => _showAddShiftDialog(context),
            icon: const Icon(Icons.add_rounded, size: 26),
            label: const Text(
              'وردية جديدة',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            backgroundColor: accentColor,
            elevation: 6,
          );
        }
        return const SizedBox.shrink();
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
