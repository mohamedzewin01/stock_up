// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:stock_up/core/di/di.dart';
// import 'package:stock_up/features/AuditItems/presentation/pages/AuditItems_page.dart';
// import 'package:stock_up/features/AuditItems/presentation/pages/audit_products_page.dart';
// import 'package:stock_up/features/Inventory/presentation/bloc/InventoryByUser/inventory_user_cubit.dart';
// import 'package:stock_up/features/Inventory/presentation/pages/create_inventory_page.dart';
// import 'package:stock_up/features/Inventory/presentation/pages/inventory_detail_page.dart';
//
// class InventoryListPage extends StatefulWidget {
//   const InventoryListPage({super.key});
//
//   @override
//   State<InventoryListPage> createState() => _InventoryListPageState();
// }
//
// class _InventoryListPageState extends State<InventoryListPage> {
//   @override
//   Widget build(BuildContext context) {
//     final size = MediaQuery.of(context).size;
//
//     return BlocProvider(
//       create: (context) => getIt<InventoryUserCubit>()..getInventoryByUser(),
//       child: Scaffold(
//         backgroundColor: const Color(0xFFF8F9FD),
//         appBar: _buildAppBar(context),
//         body: BlocBuilder<InventoryUserCubit, InventoryUserState>(
//           builder: (context, state) {
//             if (state is InventoryUserLoading) {
//               return Center(
//                 child: CircularProgressIndicator(
//                   color: const Color(0xFF6C63FF),
//                   strokeWidth: 3,
//                 ),
//               );
//             }
//
//             if (state is InventoryUserFailure) {
//               return _buildErrorWidget(context);
//             }
//
//             if (state is InventoryUserSuccess) {
//               final inventory = state.value?.data;
//
//               if (inventory == null) {
//                 return _buildEmptyState(context);
//               }
//
//               return RefreshIndicator(
//                 onRefresh: () async {
//                   context.read<InventoryUserCubit>().getInventoryByUser();
//                 },
//                 color: const Color(0xFF6C63FF),
//                 child: SingleChildScrollView(
//                   physics: const AlwaysScrollableScrollPhysics(),
//                   padding: EdgeInsets.all(size.width * 0.04),
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.stretch,
//                     children: [_buildInventoryCard(context, inventory)],
//                   ),
//                 ),
//               );
//             }
//
//             return const SizedBox.shrink();
//           },
//         ),
//         floatingActionButton: _buildFloatingActionButton(context),
//       ),
//     );
//   }
//
//   PreferredSizeWidget _buildAppBar(BuildContext context) {
//     return AppBar(
//       elevation: 0,
//       backgroundColor: Colors.white,
//       title: const Text(
//         'الجرد',
//         style: TextStyle(
//           color: Color(0xFF2D3436),
//           fontSize: 22,
//           fontWeight: FontWeight.bold,
//         ),
//       ),
//       centerTitle: true,
//       actions: [
//         Container(
//           margin: const EdgeInsets.only(left: 8),
//           decoration: BoxDecoration(
//             color: const Color(0xFF6C63FF).withOpacity(0.1),
//             borderRadius: BorderRadius.circular(12),
//           ),
//           child: IconButton(
//             icon: const Icon(Icons.refresh_rounded, color: Color(0xFF6C63FF)),
//             onPressed: () {
//               context.read<InventoryUserCubit>().getInventoryByUser();
//             },
//           ),
//         ),
//       ],
//     );
//   }
//
//   Widget _buildInventoryCard(BuildContext context, dynamic inventory) {
//     final status = inventory.status ?? 'pending';
//     final statusColor = _getStatusColor(status);
//     final statusText = _getStatusText(status);
//     final workersCount = (inventory.workers as List?)?.length ?? 0;
//
//     return Container(
//       margin: const EdgeInsets.only(bottom: 16),
//       decoration: BoxDecoration(
//         color: Colors.white,
//         borderRadius: BorderRadius.circular(24),
//         boxShadow: [
//           BoxShadow(
//             color: Colors.black.withOpacity(0.06),
//             blurRadius: 20,
//             offset: const Offset(0, 4),
//           ),
//         ],
//       ),
//       child: Material(
//         color: Colors.transparent,
//         child: InkWell(
//           onTap: () async {
//             final result = await Navigator.push(
//               context,
//               MaterialPageRoute(
//                 builder: (context) => InventoryDetailPage(
//                   inventoryId: inventory.id ?? 0,
//                   inventory: inventory,
//                 ),
//               ),
//             );
//
//             if (result == true) {
//               context.read<InventoryUserCubit>().getInventoryByUser();
//             }
//           },
//           borderRadius: BorderRadius.circular(24),
//           child: Padding(
//             padding: const EdgeInsets.all(20),
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Row(
//                   children: [
//                     Container(
//                       padding: const EdgeInsets.all(16),
//                       decoration: BoxDecoration(
//                         gradient: const LinearGradient(
//                           colors: [Color(0xFF6C63FF), Color(0xFF5A52D5)],
//                           begin: Alignment.topLeft,
//                           end: Alignment.bottomRight,
//                         ),
//                         borderRadius: BorderRadius.circular(16),
//                         boxShadow: [
//                           BoxShadow(
//                             color: const Color(0xFF6C63FF).withOpacity(0.3),
//                             blurRadius: 12,
//                             offset: const Offset(0, 4),
//                           ),
//                         ],
//                       ),
//                       child: const Icon(
//                         Icons.inventory_2_rounded,
//                         color: Colors.white,
//                         size: 28,
//                       ),
//                     ),
//                     const SizedBox(width: 16),
//                     Expanded(
//                       child: Column(
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         children: [
//                           Text(
//                             'جرد #${inventory.notes} ${inventory.id}',
//                             overflow: TextOverflow.ellipsis,
//                             maxLines: 1,
//                             style: const TextStyle(
//                               fontSize: 18,
//                               fontWeight: FontWeight.bold,
//                               color: Color(0xFF2D3436),
//                             ),
//                           ),
//                           const SizedBox(height: 4),
//                           Text(
//                             inventory.auditDate ?? '',
//                             overflow: TextOverflow.ellipsis,
//                             maxLines: 1,
//                             style: TextStyle(
//                               fontSize: 13,
//                               color: const Color(0xFF636E72),
//                             ),
//                           ),
//                         ],
//                       ),
//                     ),
//                     Container(
//                       padding: const EdgeInsets.symmetric(
//                         horizontal: 12,
//                         vertical: 6,
//                       ),
//                       decoration: BoxDecoration(
//                         color: statusColor.withOpacity(0.15),
//                         borderRadius: BorderRadius.circular(12),
//                         border: Border.all(
//                           color: statusColor.withOpacity(0.3),
//                           width: 1.5,
//                         ),
//                       ),
//                       child: Text(
//                         statusText,
//                         style: TextStyle(
//                           fontSize: 12,
//                           fontWeight: FontWeight.bold,
//                           color: statusColor,
//                         ),
//                       ),
//                     ),
//                   ],
//                 ),
//                 if (inventory.notes != null && inventory.notes!.isNotEmpty) ...[
//                   const SizedBox(height: 16),
//                   Container(
//                     padding: const EdgeInsets.all(12),
//                     decoration: BoxDecoration(
//                       color: const Color(0xFFF8F9FD),
//                       borderRadius: BorderRadius.circular(12),
//                     ),
//                     child: Row(
//                       children: [
//                         Icon(
//                           Icons.note_alt_outlined,
//                           size: 18,
//                           color: const Color(0xFF636E72),
//                         ),
//                         const SizedBox(width: 8),
//                         Expanded(
//                           child: Text(
//                             inventory.notes!,
//                             style: const TextStyle(
//                               fontSize: 14,
//                               color: Color(0xFF636E72),
//                             ),
//                             maxLines: 2,
//                             overflow: TextOverflow.ellipsis,
//                           ),
//                         ),
//                       ],
//                     ),
//                   ),
//                 ],
//                 const SizedBox(height: 16),
//                 Container(
//                   padding: const EdgeInsets.all(12),
//                   decoration: BoxDecoration(
//                     gradient: LinearGradient(
//                       colors: [
//                         const Color(0xFF6C63FF).withOpacity(0.1),
//                         const Color(0xFF4ECDC4).withOpacity(0.1),
//                       ],
//                       begin: Alignment.topLeft,
//                       end: Alignment.bottomRight,
//                     ),
//                     borderRadius: BorderRadius.circular(12),
//                   ),
//                   child: Row(
//                     children: [
//                       Container(
//                         padding: const EdgeInsets.all(8),
//                         decoration: BoxDecoration(
//                           color: const Color(0xFF6C63FF).withOpacity(0.2),
//                           borderRadius: BorderRadius.circular(8),
//                         ),
//                         child: const Icon(
//                           Icons.people_rounded,
//                           color: Color(0xFF6C63FF),
//                           size: 20,
//                         ),
//                       ),
//                       const SizedBox(width: 12),
//                       Text(
//                         workersCount == 0
//                             ? 'لم يتم إضافة عمال'
//                             : '$workersCount عامل',
//                         style: const TextStyle(
//                           fontSize: 15,
//                           fontWeight: FontWeight.bold,
//                           color: Color(0xFF6C63FF),
//                         ),
//                       ),
//                       const Spacer(),
//                       Icon(
//                         Icons.arrow_forward_ios_rounded,
//                         size: 16,
//                         color: const Color(0xFF6C63FF),
//                       ),
//                     ],
//                   ),
//                 ),
//
//                 // if (status == _getStatusColor(status) && workersCount == 0)
//                 Row(
//                   children: [
//                     _buildStartAddItemsButton(),
//                     const SizedBox(width: 12),
//                     _buildStartInventoryButton(),
//                   ],
//                 ),
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }
//
//   Widget _buildStartInventoryButton() {
//     return Expanded(
//       child: Container(
//         decoration: BoxDecoration(
//           gradient: const LinearGradient(
//             colors: [Color(0xFF26DE81), Color(0xFF20BF6B)],
//             begin: Alignment.topLeft,
//             end: Alignment.bottomRight,
//           ),
//           borderRadius: BorderRadius.circular(20),
//           boxShadow: [
//             BoxShadow(
//               color: const Color(0xFF26DE81).withOpacity(0.4),
//               blurRadius: 15,
//               offset: const Offset(0, 8),
//             ),
//           ],
//         ),
//         child: ElevatedButton(
//           onPressed: () => _handleStartInventory(),
//           style: ElevatedButton.styleFrom(
//             backgroundColor: Colors.transparent,
//             shadowColor: Colors.transparent,
//             padding: const EdgeInsets.symmetric(vertical: 18),
//             shape: RoundedRectangleBorder(
//               borderRadius: BorderRadius.circular(20),
//             ),
//           ),
//           child: Row(
//             mainAxisAlignment: MainAxisAlignment.center,
//             children: const [
//               Icon(Icons.play_arrow_rounded, color: Colors.white, size: 28),
//               SizedBox(width: 12),
//               Text(
//                 'ادخال الجرد',
//                 style: TextStyle(
//                   fontSize: 18,
//                   fontWeight: FontWeight.bold,
//                   color: Colors.white,
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
//
//   Widget _buildStartAddItemsButton() {
//     return Expanded(
//       child: Container(
//         decoration: BoxDecoration(
//           gradient: const LinearGradient(
//             colors: [Color(0xFF26DE81), Color(0xFF20BF6B)],
//             begin: Alignment.topLeft,
//             end: Alignment.bottomRight,
//           ),
//           borderRadius: BorderRadius.circular(20),
//           boxShadow: [
//             BoxShadow(
//               color: const Color(0xFF26DE81).withOpacity(0.4),
//               blurRadius: 15,
//               offset: const Offset(0, 8),
//             ),
//           ],
//         ),
//         child: ElevatedButton(
//           onPressed: () {
//             Navigator.push(
//               context,
//               MaterialPageRoute(
//                 builder: (context) => const SearchProductsPage(),
//               ),
//             );
//           },
//           style: ElevatedButton.styleFrom(
//             backgroundColor: Colors.transparent,
//             shadowColor: Colors.transparent,
//             padding: const EdgeInsets.symmetric(vertical: 18),
//             shape: RoundedRectangleBorder(
//               borderRadius: BorderRadius.circular(20),
//             ),
//           ),
//           child: Row(
//             mainAxisAlignment: MainAxisAlignment.center,
//             children: const [
//               Icon(Icons.barcode_reader, color: Colors.white, size: 28),
//               SizedBox(width: 12),
//               Text(
//                 'ادخال المنتجات',
//                 style: TextStyle(
//                   fontSize: 18,
//                   fontWeight: FontWeight.bold,
//                   color: Colors.white,
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
//
//   void _handleStartInventory() {
//     showDialog(
//       context: context,
//       builder: (context) => AlertDialog(
//         shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
//         title: Row(
//           children: [
//             Container(
//               padding: const EdgeInsets.all(8),
//               decoration: BoxDecoration(
//                 color: const Color(0xFF26DE81).withOpacity(0.1),
//                 borderRadius: BorderRadius.circular(10),
//               ),
//               child: const Icon(
//                 Icons.play_arrow_rounded,
//                 color: Color(0xFF26DE81),
//               ),
//             ),
//             const SizedBox(width: 12),
//             const Text('البدء في الجرد', style: TextStyle(fontSize: 18)),
//           ],
//         ),
//         content: const Text(
//           'هل تريد البدء في عملية الجرد؟\nسيتم تحديث حالة الجرد إلى "جاري التنفيذ".',
//           style: TextStyle(height: 1.5),
//         ),
//         actions: [
//           TextButton(
//             onPressed: () => Navigator.pop(context),
//             child: const Text(
//               'إلغاء',
//               style: TextStyle(color: Color(0xFF636E72)),
//             ),
//           ),
//           Container(
//             decoration: BoxDecoration(
//               gradient: const LinearGradient(
//                 colors: [Color(0xFF26DE81), Color(0xFF20BF6B)],
//                 begin: Alignment.topLeft,
//                 end: Alignment.bottomRight,
//               ),
//               borderRadius: BorderRadius.circular(12),
//             ),
//             child: TextButton(
//               onPressed: () {
//                 Navigator.pop(context);
//                 _showSnackBar(
//                   context,
//                   'تم البدء في الجرد بنجاح',
//                   const Color(0xFF26DE81),
//                   Icons.check_circle_rounded,
//                 );
//
//                 Navigator.push(
//                   context,
//                   MaterialPageRoute(builder: (context) => AuditProductsPage()),
//                 );
//               },
//               style: TextButton.styleFrom(
//                 padding: const EdgeInsets.symmetric(
//                   horizontal: 20,
//                   vertical: 10,
//                 ),
//               ),
//               child: const Text(
//                 'نعم، ابدأ',
//                 style: TextStyle(
//                   color: Colors.white,
//                   fontWeight: FontWeight.bold,
//                 ),
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
//
//   void _showSnackBar(
//     BuildContext context,
//     String message,
//     Color backgroundColor,
//     IconData icon,
//   ) {
//     ScaffoldMessenger.of(context).showSnackBar(
//       SnackBar(
//         content: Row(
//           children: [
//             Icon(icon, color: Colors.white),
//             const SizedBox(width: 12),
//             Expanded(
//               child: Text(
//                 message,
//                 style: const TextStyle(
//                   fontSize: 15,
//                   fontWeight: FontWeight.w500,
//                 ),
//               ),
//             ),
//           ],
//         ),
//         backgroundColor: backgroundColor,
//         behavior: SnackBarBehavior.floating,
//         shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
//         margin: const EdgeInsets.all(16),
//         padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
//         duration: const Duration(seconds: 3),
//       ),
//     );
//   }
//
//   Widget _buildEmptyState(BuildContext context) {
//     return Center(
//       child: SingleChildScrollView(
//         padding: const EdgeInsets.all(24),
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             Container(
//               padding: const EdgeInsets.all(32),
//               decoration: BoxDecoration(
//                 gradient: LinearGradient(
//                   colors: [
//                     const Color(0xFF6C63FF).withOpacity(0.1),
//                     const Color(0xFF4ECDC4).withOpacity(0.1),
//                   ],
//                   begin: Alignment.topLeft,
//                   end: Alignment.bottomRight,
//                 ),
//                 shape: BoxShape.circle,
//               ),
//               child: Icon(
//                 Icons.inventory_2_outlined,
//                 size: 80,
//                 color: const Color(0xFF6C63FF),
//               ),
//             ),
//             const SizedBox(height: 32),
//             const Text(
//               'لا يوجد جرد حالي',
//               style: TextStyle(
//                 fontSize: 22,
//                 fontWeight: FontWeight.bold,
//                 color: Color(0xFF2D3436),
//               ),
//             ),
//             const SizedBox(height: 12),
//             Text(
//               'ابدأ بإنشاء جرد جديد للمخزون',
//               textAlign: TextAlign.center,
//               style: TextStyle(
//                 fontSize: 15,
//                 color: const Color(0xFF636E72),
//                 height: 1.5,
//               ),
//             ),
//             const SizedBox(height: 40),
//             _buildCreateButton(context),
//           ],
//         ),
//       ),
//     );
//   }
//
//   Widget _buildErrorWidget(BuildContext context) {
//     return Center(
//       child: Padding(
//         padding: const EdgeInsets.all(24),
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             Container(
//               padding: const EdgeInsets.all(24),
//               decoration: BoxDecoration(
//                 color: const Color(0xFFFF6B9D).withOpacity(0.1),
//                 shape: BoxShape.circle,
//               ),
//               child: const Icon(
//                 Icons.error_outline_rounded,
//                 size: 64,
//                 color: Color(0xFFFF6B9D),
//               ),
//             ),
//             const SizedBox(height: 24),
//             const Text(
//               'حدث خطأ أثناء جلب البيانات',
//               textAlign: TextAlign.center,
//               style: TextStyle(
//                 fontSize: 18,
//                 fontWeight: FontWeight.bold,
//                 color: Color(0xFF2D3436),
//               ),
//             ),
//             const SizedBox(height: 32),
//             Container(
//               decoration: BoxDecoration(
//                 gradient: const LinearGradient(
//                   colors: [Color(0xFF6C63FF), Color(0xFF5A52D5)],
//                   begin: Alignment.topLeft,
//                   end: Alignment.bottomRight,
//                 ),
//                 borderRadius: BorderRadius.circular(16),
//                 boxShadow: [
//                   BoxShadow(
//                     color: const Color(0xFF6C63FF).withOpacity(0.3),
//                     blurRadius: 12,
//                     offset: const Offset(0, 6),
//                   ),
//                 ],
//               ),
//               child: ElevatedButton.icon(
//                 onPressed: () {
//                   context.read<InventoryUserCubit>().getInventoryByUser();
//                 },
//                 icon: const Icon(Icons.refresh_rounded),
//                 label: const Text('إعادة المحاولة'),
//                 style: ElevatedButton.styleFrom(
//                   backgroundColor: Colors.transparent,
//                   shadowColor: Colors.transparent,
//                   padding: const EdgeInsets.symmetric(
//                     horizontal: 32,
//                     vertical: 16,
//                   ),
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
//
//   Widget _buildCreateButton(BuildContext context) {
//     return Container(
//       decoration: BoxDecoration(
//         gradient: const LinearGradient(
//           colors: [Color(0xFF6C63FF), Color(0xFF5A52D5)],
//           begin: Alignment.topLeft,
//           end: Alignment.bottomRight,
//         ),
//         borderRadius: BorderRadius.circular(20),
//         boxShadow: [
//           BoxShadow(
//             color: const Color(0xFF6C63FF).withOpacity(0.4),
//             blurRadius: 15,
//             offset: const Offset(0, 8),
//           ),
//         ],
//       ),
//       child: ElevatedButton.icon(
//         onPressed: () async {
//           final result = await Navigator.push(
//             context,
//             MaterialPageRoute(
//               builder: (context) => const CreateInventoryPage(),
//             ),
//           );
//
//           if (result == true) {
//             context.read<InventoryUserCubit>().getInventoryByUser();
//           }
//         },
//         icon: const Icon(Icons.add_rounded, color: Colors.white),
//         label: const Text(
//           'إنشاء جرد جديد',
//           style: TextStyle(
//             fontSize: 17,
//             fontWeight: FontWeight.bold,
//             color: Colors.white,
//           ),
//         ),
//         style: ElevatedButton.styleFrom(
//           backgroundColor: Colors.transparent,
//           shadowColor: Colors.transparent,
//           padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 18),
//           shape: RoundedRectangleBorder(
//             borderRadius: BorderRadius.circular(20),
//           ),
//         ),
//       ),
//     );
//   }
//
//   Widget _buildFloatingActionButton(BuildContext context) {
//     return Container(
//       decoration: BoxDecoration(
//         gradient: const LinearGradient(
//           colors: [Color(0xFF6C63FF), Color(0xFF5A52D5)],
//           begin: Alignment.topLeft,
//           end: Alignment.bottomRight,
//         ),
//         borderRadius: BorderRadius.circular(20),
//         boxShadow: [
//           BoxShadow(
//             color: const Color(0xFF6C63FF).withOpacity(0.4),
//             blurRadius: 15,
//             offset: const Offset(0, 8),
//           ),
//         ],
//       ),
//       child: FloatingActionButton.extended(
//         onPressed: () async {
//           final result = await Navigator.push(
//             context,
//             MaterialPageRoute(
//               builder: (context) => const CreateInventoryPage(),
//             ),
//           );
//
//           if (result == true) {
//             context.read<InventoryUserCubit>().getInventoryByUser();
//           }
//         },
//         backgroundColor: Colors.transparent,
//         elevation: 0,
//         icon: const Icon(Icons.add_rounded),
//         label: const Text(
//           'إنشاء جرد',
//           style: TextStyle(fontWeight: FontWeight.bold),
//         ),
//       ),
//     );
//   }
//
//   Color _getStatusColor(String status) {
//     switch (status.toLowerCase()) {
//       case 'completed':
//         return const Color(0xFF26DE81);
//       case 'in_progress':
//         return const Color(0xFFFEA47F);
//       case 'pending':
//       default:
//         return const Color(0xFF6C63FF);
//     }
//   }
//
//   String _getStatusText(String status) {
//     switch (status.toLowerCase()) {
//       case 'completed':
//         return 'مكتمل';
//       case 'in_progress':
//         return 'جاري التنفيذ';
//       case 'pending':
//       default:
//         return 'قيد الانتظار';
//     }
//   }
// }
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:stock_up/core/di/di.dart';
import 'package:stock_up/features/AuditItems/presentation/pages/AuditItems_page.dart';
import 'package:stock_up/features/AuditItems/presentation/pages/audit_products_page.dart';
import 'package:stock_up/features/Inventory/presentation/bloc/InventoryByUser/inventory_user_cubit.dart';
import 'package:stock_up/features/Inventory/presentation/bloc/update_audit_status/update_audit_status_cubit.dart';
import 'package:stock_up/features/Inventory/presentation/pages/create_inventory_page.dart';
import 'package:stock_up/features/Inventory/presentation/pages/inventory_detail_page.dart';

// ============================================================================
// Constants & Helpers
// ============================================================================
class AppColors {
  static const Color primary = Color(0xFF6C63FF);
  static const Color secondary = Color(0xFF4ECDC4);
  static const Color success = Color(0xFF26DE81);
  static const Color warning = Color(0xFFFEA47F);
  static const Color error = Color(0xFFFF6B9D);
  static const Color background = Color(0xFFF8F9FD);
  static const Color textPrimary = Color(0xFF2D3436);
  static const Color textSecondary = Color(0xFF636E72);
}

class InventoryStatus {
  static Color getColor(String status) {
    switch (status.toLowerCase()) {
      case 'completed':
        return AppColors.success;
      case 'in_progress':
        return AppColors.warning;
      case 'pending':
      default:
        return AppColors.primary;
    }
  }

  static String getText(String status) {
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

class SnackBarHelper {
  static void showSuccess(BuildContext context, String message) {
    _showSnackBar(
      context,
      message,
      AppColors.success,
      Icons.check_circle_rounded,
    );
  }

  static void showError(BuildContext context, String message) {
    _showSnackBar(context, message, AppColors.error, Icons.error_rounded);
  }

  static void showInfo(BuildContext context, String message) {
    _showSnackBar(context, message, AppColors.primary, Icons.info_rounded);
  }

  static void showWarning(BuildContext context, String message) {
    _showSnackBar(context, message, AppColors.warning, Icons.warning_rounded);
  }

  static void _showSnackBar(
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
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        duration: const Duration(seconds: 3),
      ),
    );
  }
}

// ============================================================================
// Main Page
// ============================================================================
class InventoryListPage extends StatefulWidget {
  const InventoryListPage({super.key});

  @override
  State<InventoryListPage> createState() => _InventoryListPageState();
}

class _InventoryListPageState extends State<InventoryListPage> {
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) =>
              getIt<InventoryUserCubit>()..getInventoryByUser(),
        ),
        BlocProvider(create: (context) => getIt<UpdateAuditStatusCubit>()),
      ],
      child: Scaffold(
        backgroundColor: AppColors.background,
        appBar: _InventoryAppBar(),
        body: const _InventoryBody(),
      ),
    );
  }
}

// ============================================================================
// App Bar Component
// ============================================================================
class _InventoryAppBar extends StatelessWidget implements PreferredSizeWidget {
  @override
  Widget build(BuildContext context) {
    return AppBar(
      elevation: 0,
      backgroundColor: Colors.white,
      title: const Text(
        'الجرد',
        style: TextStyle(
          color: AppColors.textPrimary,
          fontSize: 22,
          fontWeight: FontWeight.bold,
        ),
      ),
      centerTitle: true,
      actions: [
        Padding(
          padding: const EdgeInsets.only(left: 12),
          child: _RefreshButton(),
        ),
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}

class _RefreshButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.primary.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: IconButton(
        icon: const Icon(Icons.refresh_rounded, color: AppColors.primary),
        onPressed: () {
          context.read<InventoryUserCubit>().getInventoryByUser();
        },
      ),
    );
  }
}

// ============================================================================
// Body Component
// ============================================================================
class _InventoryBody extends StatelessWidget {
  const _InventoryBody();

  @override
  Widget build(BuildContext context) {
    return BlocListener<UpdateAuditStatusCubit, UpdateAuditStatusState>(
      listener: (context, state) {
        if (state is UpdateAuditStatusLoaded) {
          final entity = state.updateAuditStatusEntity;

          if (entity?.status == 'success') {
            SnackBarHelper.showSuccess(
              context,
              entity?.message ?? 'تم إنهاء الجرد بنجاح',
            );
            // تحديث البيانات
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
          SnackBarHelper.showError(context, 'حدث خطأ أثناء إنهاء الجرد');
        }
      },
      child: BlocBuilder<InventoryUserCubit, InventoryUserState>(
        builder: (context, state) {
          if (state is InventoryUserLoading) {
            return const _LoadingWidget();
          }

          if (state is InventoryUserFailure) {
            return const _ErrorWidget();
          }

          if (state is InventoryUserSuccess) {
            final inventory = state.value?.data;

            if (inventory == null) {
              return const _EmptyStateWidget();
            }

            return _InventoryContent(inventory: inventory);
          }

          return const SizedBox.shrink();
        },
      ),
    );
  }

  void _showPendingItemsDialog(
    BuildContext context,
    String message,
    int pendingCount,
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
                color: AppColors.warning.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Icon(
                Icons.warning_rounded,
                color: AppColors.warning,
                size: 32,
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
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              message,
              style: const TextStyle(
                fontSize: 16,
                height: 1.6,
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColors.warning.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: AppColors.warning.withOpacity(0.3),
                  width: 2,
                ),
              ),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: AppColors.warning.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Icon(
                      Icons.inventory_2_rounded,
                      color: AppColors.warning,
                      size: 24,
                    ),
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
                            color: AppColors.textSecondary,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          '$pendingCount منتج',
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: AppColors.warning,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: AppColors.primary.withOpacity(0.05),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                children: [
                  const Icon(
                    Icons.info_outline,
                    color: AppColors.primary,
                    size: 20,
                  ),
                  const SizedBox(width: 8),
                  const Expanded(
                    child: Text(
                      'يرجى إكمال جميع المنتجات قبل إنهاء الجرد',
                      style: TextStyle(
                        fontSize: 13,
                        color: AppColors.textSecondary,
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
            onPressed: () => Navigator.pop(context),
            child: const Text(
              'فهمت',
              style: TextStyle(
                color: AppColors.primary,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ============================================================================
// Inventory Content
// ============================================================================
class _InventoryContent extends StatelessWidget {
  final dynamic inventory;

  const _InventoryContent({required this.inventory});

  @override
  Widget build(BuildContext context) {
    final status = inventory.status ?? 'pending';
    final isCompleted = status.toLowerCase() == 'completed';

    return RefreshIndicator(
      onRefresh: () async {
        context.read<InventoryUserCubit>().getInventoryByUser();
      },
      color: AppColors.primary,
      child: LayoutBuilder(
        builder: (context, constraints) {
          final isTablet = constraints.maxWidth > 600;
          final padding = isTablet ? 32.0 : 20.0;

          return Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  physics: const AlwaysScrollableScrollPhysics(),
                  child: Padding(
                    padding: EdgeInsets.all(padding),
                    child: Center(
                      child: Container(
                        constraints: BoxConstraints(
                          maxWidth: isTablet ? 800 : double.infinity,
                        ),
                        child: _InventoryCard(inventory: inventory),
                      ),
                    ),
                  ),
                ),
              ),
              if (!isCompleted)
                _CompleteInventoryButton(auditId: inventory.id ?? 0),
            ],
          );
        },
      ),
    );
  }
}

// ============================================================================
// Complete Inventory Button
// ============================================================================
class _CompleteInventoryButton extends StatelessWidget {
  final int auditId;

  const _CompleteInventoryButton({required this.auditId});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<UpdateAuditStatusCubit, UpdateAuditStatusState>(
      builder: (context, state) {
        final isLoading = state is UpdateAuditStatusLoading;

        return Container(
          padding: const EdgeInsets.all(20),
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
                gradient: const LinearGradient(
                  colors: [Color(0xFF26DE81), Color(0xFF20BF6B)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.success.withOpacity(0.4),
                    blurRadius: 20,
                    offset: const Offset(0, 8),
                  ),
                ],
              ),
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  onTap: isLoading ? null : () => _showCompleteDialog(context),
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
                                padding: const EdgeInsets.all(8),
                                decoration: BoxDecoration(
                                  color: Colors.white.withOpacity(0.2),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: const Icon(
                                  Icons.check_circle_rounded,
                                  color: Colors.white,
                                  size: 24,
                                ),
                              ),
                              const SizedBox(width: 12),
                              const Text(
                                'إنهاء الجرد',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                  letterSpacing: 0.5,
                                ),
                              ),
                            ],
                          ),
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  void _showCompleteDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        contentPadding: const EdgeInsets.all(10),
        title: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: AppColors.success.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Icon(
                Icons.check_circle_rounded,
                color: AppColors.success,
                size: 32,
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
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'هل أنت متأكد من إنهاء الجرد؟',
              style: TextStyle(
                fontSize: 16,
                height: 1.6,
                fontWeight: FontWeight.w600,
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColors.warning.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: AppColors.warning.withOpacity(0.3),
                  width: 1.5,
                ),
              ),
              child: Row(
                children: [
                  const Icon(
                    Icons.info_outline,
                    color: AppColors.warning,
                    size: 24,
                  ),
                  const SizedBox(width: 12),
                  const Expanded(
                    child: Text(
                      'سيتم إنهاء الجرد وتحويل حالته إلى مكتمل',
                      style: TextStyle(
                        fontSize: 14,
                        color: AppColors.textSecondary,
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
              style: TextStyle(color: AppColors.textSecondary, fontSize: 16),
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
}

// ============================================================================
// Inventory Card (باقي الكود كما هو)
// ============================================================================
class _InventoryCard extends StatelessWidget {
  final dynamic inventory;

  const _InventoryCard({required this.inventory});

  @override
  Widget build(BuildContext context) {
    final status = inventory.status ?? 'pending';
    final statusColor = InventoryStatus.getColor(status);
    final statusText = InventoryStatus.getText(status);
    final workersCount = (inventory.workers as List?)?.length ?? 0;

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(28),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 30,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () => _navigateToDetail(context),
          borderRadius: BorderRadius.circular(28),
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                _InventoryHeader(
                  inventory: inventory,
                  statusColor: statusColor,
                  statusText: statusText,
                ),
                if (inventory.notes != null && inventory.notes!.isNotEmpty) ...[
                  const SizedBox(height: 20),
                  _NotesSection(notes: inventory.notes!),
                ],
                const SizedBox(height: 20),
                _WorkersSection(workersCount: workersCount),
                const SizedBox(height: 24),
                _ActionButtons(inventory: inventory),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _navigateToDetail(BuildContext context) async {
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
  }
}

// ============================================================================
// Inventory Header
// ============================================================================
class _InventoryHeader extends StatelessWidget {
  final dynamic inventory;
  final Color statusColor;
  final String statusText;

  const _InventoryHeader({
    required this.inventory,
    required this.statusColor,
    required this.statusText,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final isSmallScreen = constraints.maxWidth < 400;

        return Column(
          children: [
            Row(
              children: [
                _InventoryIcon(),
                SizedBox(width: isSmallScreen ? 12 : 16),
                Expanded(
                  child: _InventoryInfo(
                    inventory: inventory,
                    isSmallScreen: isSmallScreen,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            _StatusBadge(statusColor: statusColor, statusText: statusText),
          ],
        );
      },
    );
  }
}

class _InventoryIcon extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF6C63FF), Color(0xFF5A52D5)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withOpacity(0.3),
            blurRadius: 15,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: const Icon(
        Icons.inventory_2_rounded,
        color: Colors.white,
        size: 32,
      ),
    );
  }
}

class _InventoryInfo extends StatelessWidget {
  final dynamic inventory;
  final bool isSmallScreen;

  const _InventoryInfo({required this.inventory, required this.isSmallScreen});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'جرد #${inventory.id}',
          overflow: TextOverflow.ellipsis,
          maxLines: 1,
          style: TextStyle(
            fontSize: isSmallScreen ? 20 : 24,
            fontWeight: FontWeight.bold,
            color: AppColors.textPrimary,
            letterSpacing: -0.5,
          ),
        ),
        const SizedBox(height: 6),
        Row(
          children: [
            const Icon(
              Icons.calendar_today_rounded,
              size: 16,
              color: AppColors.textSecondary,
            ),
            const SizedBox(width: 6),
            Expanded(
              child: Text(
                inventory.auditDate ?? 'لم يتم تحديد التاريخ',
                overflow: TextOverflow.ellipsis,
                maxLines: 1,
                style: TextStyle(
                  fontSize: isSmallScreen ? 13 : 14,
                  color: AppColors.textSecondary,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class _StatusBadge extends StatelessWidget {
  final Color statusColor;
  final String statusText;

  const _StatusBadge({required this.statusColor, required this.statusText});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: statusColor.withOpacity(0.15),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: statusColor.withOpacity(0.3), width: 2),
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
                  color: statusColor.withOpacity(0.5),
                  blurRadius: 8,
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
    );
  }
}

// ============================================================================
// Notes Section
// ============================================================================
class _NotesSection extends StatelessWidget {
  final String notes;

  const _NotesSection({required this.notes});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            AppColors.primary.withOpacity(0.05),
            AppColors.secondary.withOpacity(0.05),
          ],
          begin: Alignment.topRight,
          end: Alignment.bottomLeft,
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.primary.withOpacity(0.1), width: 1),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: AppColors.primary.withOpacity(0.1),
              borderRadius: BorderRadius.circular(10),
            ),
            child: const Icon(
              Icons.note_alt_rounded,
              size: 20,
              color: AppColors.primary,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'ملاحظات',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: AppColors.primary,
                    letterSpacing: 0.5,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  notes,
                  style: const TextStyle(
                    fontSize: 14,
                    color: AppColors.textSecondary,
                    height: 1.4,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ============================================================================
// Workers Section
// ============================================================================
class _WorkersSection extends StatelessWidget {
  final int workersCount;

  const _WorkersSection({required this.workersCount});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            AppColors.primary.withOpacity(0.1),
            AppColors.secondary.withOpacity(0.1),
          ],
          begin: Alignment.topRight,
          end: Alignment.bottomLeft,
        ),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: AppColors.primary.withOpacity(0.2),
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(
              Icons.people_rounded,
              color: AppColors.primary,
              size: 24,
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'فريق العمل',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: AppColors.primary,
                    letterSpacing: 0.5,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  workersCount == 0
                      ? 'لم يتم إضافة عمال'
                      : '$workersCount عامل',
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textPrimary,
                  ),
                ),
              ],
            ),
          ),
          const Icon(
            Icons.arrow_back_ios_rounded,
            size: 18,
            color: AppColors.primary,
          ),
        ],
      ),
    );
  }
}

// ============================================================================
// Action Buttons
// ============================================================================
class _ActionButtons extends StatelessWidget {
  final dynamic inventory;

  const _ActionButtons({required this.inventory});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final isSmallScreen = constraints.maxWidth < 400;

        if (isSmallScreen) {
          return Column(
            children: [
              _AddProductsButton(),
              const SizedBox(height: 12),
              _StartInventoryButton(inventory: inventory),
            ],
          );
        }

        return Row(
          children: [
            Expanded(child: _AddProductsButton()),
            const SizedBox(width: 12),
            Expanded(child: _StartInventoryButton(inventory: inventory)),
          ],
        );
      },
    );
  }
}

class _AddProductsButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return _GradientButton(
      onPressed: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const SearchProductsPage()),
        );
      },
      icon: Icons.add_shopping_cart_rounded,
      label: 'إضافة منتجات',
      gradient: const LinearGradient(
        colors: [Color(0xFF667EEA), Color(0xFF764BA2)],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      ),
    );
  }
}

class _StartInventoryButton extends StatelessWidget {
  final dynamic inventory;

  const _StartInventoryButton({required this.inventory});

  @override
  Widget build(BuildContext context) {
    return _GradientButton(
      onPressed: () => _handleStartInventory(context),
      icon: Icons.play_arrow_rounded,
      label: 'بدء الجرد',
      gradient: const LinearGradient(
        colors: [Color(0xFF26DE81), Color(0xFF20BF6B)],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      ),
    );
  }

  void _handleStartInventory(BuildContext context) {
    showDialog(context: context, builder: (context) => _StartInventoryDialog());
  }
}

class _GradientButton extends StatelessWidget {
  final VoidCallback onPressed;
  final IconData icon;
  final String label;
  final Gradient gradient;

  const _GradientButton({
    required this.onPressed,
    required this.icon,
    required this.label,
    required this.gradient,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 56,
      decoration: BoxDecoration(
        gradient: gradient,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: (gradient as LinearGradient).colors.first.withOpacity(0.4),
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
            Icon(icon, color: Colors.white, size: 24),
            const SizedBox(width: 8),
            Text(
              label,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ============================================================================
// Start Inventory Dialog
// ============================================================================
class _StartInventoryDialog extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
      contentPadding: const EdgeInsets.all(24),
      title: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: AppColors.success.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(
              Icons.play_arrow_rounded,
              color: AppColors.success,
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
          onPressed: () => Navigator.pop(context),
          child: const Text(
            'إلغاء',
            style: TextStyle(color: AppColors.textSecondary, fontSize: 16),
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
              Navigator.pop(context);
              _navigateToAudit(context);
            },
            style: TextButton.styleFrom(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
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
    );
  }

  void _navigateToAudit(BuildContext context) {
    SnackBarHelper.showSuccess(context, 'تم البدء في الجرد بنجاح');

    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => AuditProductsPage()),
    );
  }
}

// ============================================================================
// Loading Widget
// ============================================================================
class _LoadingWidget extends StatelessWidget {
  const _LoadingWidget();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: AppColors.primary.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: const CircularProgressIndicator(
              color: AppColors.primary,
              strokeWidth: 3,
            ),
          ),
          const SizedBox(height: 24),
          const Text(
            'جاري تحميل البيانات...',
            style: TextStyle(
              fontSize: 16,
              color: AppColors.textSecondary,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}

// ============================================================================
// Empty State Widget
// ============================================================================
class _EmptyStateWidget extends StatelessWidget {
  const _EmptyStateWidget();

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
                gradient: LinearGradient(
                  colors: [
                    AppColors.primary.withOpacity(0.1),
                    AppColors.secondary.withOpacity(0.1),
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.inventory_2_outlined,
                size: 100,
                color: AppColors.primary,
              ),
            ),
            const SizedBox(height: 40),
            const Text(
              'لا يوجد جرد حالي',
              style: TextStyle(
                fontSize: 26,
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: 12),
            const Text(
              'ابدأ بإنشاء جرد جديد للمخزون\nلمتابعة وإدارة المنتجات بكفاءة',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 16,
                color: AppColors.textSecondary,
                height: 1.6,
              ),
            ),
            const SizedBox(height: 48),
            const _CreateInventoryButton(),
          ],
        ),
      ),
    );
  }
}

// ============================================================================
// Error Widget
// ============================================================================
class _ErrorWidget extends StatelessWidget {
  const _ErrorWidget();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(32),
              decoration: BoxDecoration(
                color: AppColors.error.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.error_outline_rounded,
                size: 80,
                color: AppColors.error,
              ),
            ),
            const SizedBox(height: 32),
            const Text(
              'حدث خطأ أثناء جلب البيانات',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: 12),
            const Text(
              'يرجى المحاولة مرة أخرى',
              style: TextStyle(fontSize: 15, color: AppColors.textSecondary),
            ),
            const SizedBox(height: 40),
            Container(
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFF6C63FF), Color(0xFF5A52D5)],
                ),
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.primary.withOpacity(0.3),
                    blurRadius: 15,
                    offset: const Offset(0, 8),
                  ),
                ],
              ),
              child: ElevatedButton.icon(
                onPressed: () {
                  context.read<InventoryUserCubit>().getInventoryByUser();
                },
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
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
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

// ============================================================================
// Create Inventory Button
// ============================================================================
class _CreateInventoryButton extends StatelessWidget {
  const _CreateInventoryButton();

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF6C63FF), Color(0xFF5A52D5)],
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withOpacity(0.4),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: ElevatedButton.icon(
        onPressed: () => _navigateToCreate(context),
        icon: const Icon(Icons.add_rounded, color: Colors.white, size: 28),
        label: const Text(
          'إنشاء جرد جديد',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.transparent,
          shadowColor: Colors.transparent,
          padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 20),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
        ),
      ),
    );
  }

  Future<void> _navigateToCreate(BuildContext context) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const CreateInventoryPage()),
    );

    if (result == true && context.mounted) {
      context.read<InventoryUserCubit>().getInventoryByUser();
    }
  }
}
