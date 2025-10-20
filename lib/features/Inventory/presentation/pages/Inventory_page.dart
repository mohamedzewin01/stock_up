// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:stock_up/features/Inventory/data/models/response/get_all_users_model.dart';
// import 'package:stock_up/features/Inventory/data/models/response/get_inventory_by_user_model.dart';
// import 'package:stock_up/features/Inventory/presentation/bloc/AddInventory/add_inventory_cubit.dart';
// import 'package:stock_up/features/Inventory/presentation/bloc/InventoryByUser/inventory_user_cubit.dart';
// import 'package:stock_up/features/Inventory/presentation/bloc/createInventory/create_inventory_cubit.dart';
// import 'package:stock_up/features/Inventory/presentation/bloc/users/users_inventory_cubit.dart';
//
// import '../../../../core/di/di.dart';
//
// // ============================================================
// // الصفحة الرئيسية - Inventory Management Page
// // ============================================================
//
// class InventoryManagementPage extends StatelessWidget {
//   const InventoryManagementPage({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     return BlocProvider(
//       create: (context) => getIt<InventoryUserCubit>()..getInventoryByUser(),
//       child: const _InventoryPageView(),
//     );
//   }
// }
//
// class _InventoryPageView extends StatelessWidget {
//   const _InventoryPageView();
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.grey[50],
//       appBar: AppBar(
//         elevation: 0,
//         backgroundColor: Colors.white,
//         title: const Text(
//           'الجرد النشط',
//           style: TextStyle(
//             color: Colors.black87,
//             fontSize: 20,
//             fontWeight: FontWeight.bold,
//           ),
//         ),
//         centerTitle: true,
//         actions: [
//           IconButton(
//             icon: const Icon(Icons.refresh, color: Colors.black87),
//             onPressed: () {
//               context.read<InventoryUserCubit>().getInventoryByUser();
//             },
//           ),
//         ],
//       ),
//       body: BlocBuilder<InventoryUserCubit, InventoryUserState>(
//         builder: (context, state) {
//           if (state is InventoryUserLoading) {
//             return const Center(child: CircularProgressIndicator());
//           }
//
//           if (state is InventoryUserFailure) {
//             return _ErrorWidget(
//               onRetry: () =>
//                   context.read<InventoryUserCubit>().getInventoryByUser(),
//             );
//           }
//
//           if (state is InventoryUserSuccess) {
//             final data = state.value?.data;
//             if (data == null) {
//               return const _EmptyInventoryWidget();
//             }
//             return SingleChildScrollView(
//               padding: const EdgeInsets.all(16),
//               child: _InventoryCard(data: data),
//             );
//           }
//
//           return const SizedBox.shrink();
//         },
//       ),
//       floatingActionButton: FloatingActionButton.extended(
//         onPressed: () => _navigateToCreateInventory(context),
//         icon: const Icon(Icons.add),
//         label: const Text(
//           'إنشاء جرد جديد',
//           style: TextStyle(fontWeight: FontWeight.bold),
//         ),
//         backgroundColor: Theme.of(context).primaryColor,
//       ),
//     );
//   }
//
//   void _navigateToCreateInventory(BuildContext context) {
//     Navigator.push(
//       context,
//       MaterialPageRoute(builder: (context) => const CreateInventoryPage()),
//     ).then((created) {
//       if (created == true) {
//         context.read<InventoryUserCubit>().getInventoryByUser();
//       }
//     });
//   }
// }
//
// // ============================================================
// // صفحة إنشاء الجرد - Create Inventory Page
// // ============================================================
//
// class CreateInventoryPage extends StatefulWidget {
//   const CreateInventoryPage({super.key});
//
//   @override
//   State<CreateInventoryPage> createState() => _CreateInventoryPageState();
// }
//
// class _CreateInventoryPageState extends State<CreateInventoryPage> {
//   final _formKey = GlobalKey<FormState>();
//   final _notesController = TextEditingController();
//   bool _isCreating = false;
//
//   @override
//   void dispose() {
//     _notesController.dispose();
//     super.dispose();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return BlocProvider(
//       create: (context) => getIt<CreateInventoryCubit>(),
//       child: Scaffold(
//         backgroundColor: Colors.grey[50],
//         appBar: AppBar(
//           elevation: 0,
//           backgroundColor: Colors.white,
//           leading: IconButton(
//             icon: const Icon(Icons.arrow_back, color: Colors.black87),
//             onPressed: () => Navigator.pop(context),
//           ),
//           title: const Text(
//             'إنشاء جرد جديد',
//             style: TextStyle(
//               color: Colors.black87,
//               fontSize: 20,
//               fontWeight: FontWeight.bold,
//             ),
//           ),
//           centerTitle: true,
//         ),
//         body: BlocListener<CreateInventoryCubit, CreateInventoryState>(
//           listener: (context, state) {
//             if (state is CreateInventoryLoading) {
//               setState(() => _isCreating = true);
//             } else {
//               setState(() => _isCreating = false);
//             }
//
//             if (state is CreateInventorySuccess) {
//               final auditId = state.value?.audit?.id;
//               if (auditId != null) {
//                 Navigator.pushReplacement(
//                   context,
//                   MaterialPageRoute(
//                     builder: (context) => SelectWorkersPage(auditId: auditId),
//                   ),
//                 );
//               } else {
//                 _showSnackBar(context, 'حدث خطأ في إنشاء الجرد', Colors.red);
//               }
//             }
//
//             if (state is CreateInventoryFailure) {
//               _showSnackBar(
//                 context,
//                 'فشل إنشاء الجرد، حاول مرة أخرى',
//                 Colors.red,
//               );
//             }
//           },
//           child: SingleChildScrollView(
//             padding: const EdgeInsets.all(20),
//             child: Form(
//               key: _formKey,
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.stretch,
//                 children: [
//                   _buildHeaderSection(context),
//                   const SizedBox(height: 32),
//                   _buildNotesSection(context),
//                   const SizedBox(height: 40),
//                   _buildCreateButton(context),
//                 ],
//               ),
//             ),
//           ),
//         ),
//       ),
//     );
//   }
//
//   Widget _buildHeaderSection(BuildContext context) {
//     return Container(
//       padding: const EdgeInsets.all(20),
//       decoration: BoxDecoration(
//         color: Colors.white,
//         borderRadius: BorderRadius.circular(16),
//         boxShadow: [
//           BoxShadow(
//             color: Colors.black.withOpacity(0.05),
//             blurRadius: 10,
//             offset: const Offset(0, 4),
//           ),
//         ],
//       ),
//       child: Column(
//         children: [
//           Container(
//             padding: const EdgeInsets.all(16),
//             decoration: BoxDecoration(
//               color: Theme.of(context).primaryColor.withOpacity(0.1),
//               shape: BoxShape.circle,
//             ),
//             child: Icon(
//               Icons.inventory_2,
//               size: 48,
//               color: Theme.of(context).primaryColor,
//             ),
//           ),
//           const SizedBox(height: 16),
//           const Text(
//             'ابدأ بإنشاء جرد جديد',
//             style: TextStyle(
//               fontSize: 18,
//               fontWeight: FontWeight.bold,
//               color: Colors.black87,
//             ),
//           ),
//           const SizedBox(height: 8),
//           Text(
//             'قم بإضافة ملاحظات اختيارية ثم اختر العمال المشاركين',
//             textAlign: TextAlign.center,
//             style: TextStyle(fontSize: 14, color: Colors.grey[600]),
//           ),
//         ],
//       ),
//     );
//   }
//
//   Widget _buildNotesSection(BuildContext context) {
//     return Container(
//       padding: const EdgeInsets.all(20),
//       decoration: BoxDecoration(
//         color: Colors.white,
//         borderRadius: BorderRadius.circular(16),
//         boxShadow: [
//           BoxShadow(
//             color: Colors.black.withOpacity(0.05),
//             blurRadius: 10,
//             offset: const Offset(0, 4),
//           ),
//         ],
//       ),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Row(
//             children: [
//               Icon(Icons.note_alt_outlined, color: Colors.grey[700], size: 24),
//               const SizedBox(width: 12),
//               const Text(
//                 'الملاحظات',
//                 style: TextStyle(
//                   fontSize: 16,
//                   fontWeight: FontWeight.bold,
//                   color: Colors.black87,
//                 ),
//               ),
//               const SizedBox(width: 8),
//               Text(
//                 '(اختياري)',
//                 style: TextStyle(fontSize: 14, color: Colors.grey[500]),
//               ),
//             ],
//           ),
//           const SizedBox(height: 16),
//           TextFormField(
//             controller: _notesController,
//             maxLines: 4,
//             textAlign: TextAlign.right,
//             style: const TextStyle(fontSize: 15),
//             decoration: InputDecoration(
//               hintText: 'أضف ملاحظات حول الجرد...',
//               hintStyle: TextStyle(color: Colors.grey[400]),
//               filled: true,
//               fillColor: Colors.grey[50],
//               border: OutlineInputBorder(
//                 borderRadius: BorderRadius.circular(12),
//                 borderSide: BorderSide(color: Colors.grey[300]!),
//               ),
//               enabledBorder: OutlineInputBorder(
//                 borderRadius: BorderRadius.circular(12),
//                 borderSide: BorderSide(color: Colors.grey[300]!),
//               ),
//               focusedBorder: OutlineInputBorder(
//                 borderRadius: BorderRadius.circular(12),
//                 borderSide: BorderSide(
//                   color: Theme.of(context).primaryColor,
//                   width: 2,
//                 ),
//               ),
//               contentPadding: const EdgeInsets.all(16),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
//
//   Widget _buildCreateButton(BuildContext context) {
//     return ElevatedButton(
//       onPressed: _isCreating ? null : () => _handleCreateInventory(context),
//       style: ElevatedButton.styleFrom(
//         padding: const EdgeInsets.symmetric(vertical: 16),
//         shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
//         elevation: 2,
//       ),
//       child: _isCreating
//           ? const SizedBox(
//               height: 20,
//               width: 20,
//               child: CircularProgressIndicator(
//                 strokeWidth: 2,
//                 color: Colors.white,
//               ),
//             )
//           : const Text(
//               'التالي - اختيار العمال',
//               style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
//             ),
//     );
//   }
//
//   void _handleCreateInventory(BuildContext context) {
//     if (_formKey.currentState!.validate()) {
//       final notes = _notesController.text.trim().isEmpty
//           ? null
//           : _notesController.text.trim();
//       context.read<CreateInventoryCubit>().createInventory(notes: notes);
//     }
//   }
// }
//
// // ============================================================
// // صفحة اختيار العمال - Select Workers Page
// // ============================================================
//
// class SelectWorkersPage extends StatefulWidget {
//   final int auditId;
//
//   const SelectWorkersPage({super.key, required this.auditId});
//
//   @override
//   State<SelectWorkersPage> createState() => _SelectWorkersPageState();
// }
//
// class _SelectWorkersPageState extends State<SelectWorkersPage> {
//   final Set<int> _selectedWorkerIds = {};
//   bool _isAdding = false;
//   String _searchQuery = '';
//
//   @override
//   Widget build(BuildContext context) {
//     return MultiBlocProvider(
//       providers: [
//         BlocProvider(
//           create: (context) => getIt<UsersInventoryCubit>()..getAllUsers(),
//         ),
//         BlocProvider(create: (context) => getIt<AddInventoryCubit>()),
//       ],
//       child: Scaffold(
//         backgroundColor: Colors.grey[50],
//         appBar: AppBar(
//           elevation: 0,
//           backgroundColor: Colors.white,
//           leading: IconButton(
//             icon: const Icon(Icons.arrow_back, color: Colors.black87),
//             onPressed: () => _handleBackPress(context),
//           ),
//           title: const Text(
//             'اختيار العمال',
//             style: TextStyle(
//               color: Colors.black87,
//               fontSize: 20,
//               fontWeight: FontWeight.bold,
//             ),
//           ),
//           centerTitle: true,
//         ),
//         body: BlocListener<AddInventoryCubit, AddInventoryState>(
//           listener: (context, state) {
//             if (state is AddInventoryLoading) {
//               setState(() => _isAdding = true);
//             } else {
//               setState(() => _isAdding = false);
//             }
//
//             if (state is AddInventorySuccess) {
//               _showSnackBar(context, 'تم إضافة العمال بنجاح', Colors.green);
//               Navigator.pop(context, true);
//             }
//
//             if (state is AddInventoryFailure) {
//               _showSnackBar(
//                 context,
//                 'فشل إضافة العمال، حاول مرة أخرى',
//                 Colors.red,
//               );
//             }
//           },
//           child: Column(
//             children: [
//               _buildSearchBar(),
//               _buildSelectedCount(),
//               Expanded(child: _buildWorkersList()),
//               _buildBottomButton(context),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
//
//   Widget _buildSearchBar() {
//     return Container(
//       margin: const EdgeInsets.all(16),
//       padding: const EdgeInsets.symmetric(horizontal: 16),
//       decoration: BoxDecoration(
//         color: Colors.white,
//         borderRadius: BorderRadius.circular(12),
//         boxShadow: [
//           BoxShadow(
//             color: Colors.black.withOpacity(0.05),
//             blurRadius: 10,
//             offset: const Offset(0, 2),
//           ),
//         ],
//       ),
//       child: TextField(
//         textAlign: TextAlign.right,
//         onChanged: (value) => setState(() => _searchQuery = value),
//         decoration: InputDecoration(
//           hintText: 'بحث عن عامل...',
//           hintStyle: TextStyle(color: Colors.grey[400]),
//           border: InputBorder.none,
//           icon: Icon(Icons.search, color: Colors.grey[400]),
//         ),
//       ),
//     );
//   }
//
//   Widget _buildSelectedCount() {
//     return Container(
//       margin: const EdgeInsets.symmetric(horizontal: 16),
//       padding: const EdgeInsets.all(12),
//       decoration: BoxDecoration(
//         color: Theme.of(context).primaryColor.withOpacity(0.1),
//         borderRadius: BorderRadius.circular(8),
//       ),
//       child: Row(
//         mainAxisAlignment: MainAxisAlignment.center,
//         children: [
//           Icon(Icons.people, color: Theme.of(context).primaryColor, size: 20),
//           const SizedBox(width: 8),
//           Text(
//             'تم اختيار ${_selectedWorkerIds.length} عامل',
//             style: TextStyle(
//               color: Theme.of(context).primaryColor,
//               fontWeight: FontWeight.bold,
//               fontSize: 15,
//             ),
//           ),
//         ],
//       ),
//     );
//   }
//
//   Widget _buildWorkersList() {
//     return BlocBuilder<UsersInventoryCubit, UsersInventoryState>(
//       builder: (context, state) {
//         if (state is UsersInventoryLoading) {
//           return const Center(child: CircularProgressIndicator());
//         }
//
//         if (state is UsersInventoryFailure) {
//           return _ErrorWidget(
//             onRetry: () => context.read<UsersInventoryCubit>().getAllUsers(),
//           );
//         }
//
//         if (state is UsersInventorySuccess) {
//           final users = state.value?.users ?? [];
//           final filteredUsers = users.where((user) {
//             if (_searchQuery.isEmpty) return true;
//             final fullName = '${user.firstName ?? ''} ${user.lastName ?? ''}'
//                 .toLowerCase();
//             return fullName.contains(_searchQuery.toLowerCase());
//           }).toList();
//
//           if (filteredUsers.isEmpty) {
//             return Center(
//               child: Column(
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 children: [
//                   Icon(Icons.search_off, size: 64, color: Colors.grey[400]),
//                   const SizedBox(height: 16),
//                   Text(
//                     'لا توجد نتائج',
//                     style: TextStyle(fontSize: 16, color: Colors.grey[600]),
//                   ),
//                 ],
//               ),
//             );
//           }
//
//           return ListView.builder(
//             padding: const EdgeInsets.all(16),
//             itemCount: filteredUsers.length,
//             itemBuilder: (context, index) {
//               final user = filteredUsers[index];
//               return _WorkerCard(
//                 user: user,
//                 isSelected: _selectedWorkerIds.contains(user.id),
//                 onTap: () => _toggleWorkerSelection(user.id),
//               );
//             },
//           );
//         }
//
//         return const SizedBox.shrink();
//       },
//     );
//   }
//
//   Widget _buildBottomButton(BuildContext context) {
//     return Container(
//       padding: const EdgeInsets.all(16),
//       decoration: BoxDecoration(
//         color: Colors.white,
//         boxShadow: [
//           BoxShadow(
//             color: Colors.black.withOpacity(0.1),
//             blurRadius: 10,
//             offset: const Offset(0, -2),
//           ),
//         ],
//       ),
//       child: SafeArea(
//         child: ElevatedButton(
//           onPressed: _selectedWorkerIds.isEmpty || _isAdding
//               ? null
//               : () => _handleAddWorkers(context),
//           style: ElevatedButton.styleFrom(
//             padding: const EdgeInsets.symmetric(vertical: 16),
//             shape: RoundedRectangleBorder(
//               borderRadius: BorderRadius.circular(12),
//             ),
//             elevation: 0,
//           ),
//           child: _isAdding
//               ? const SizedBox(
//                   height: 20,
//                   width: 20,
//                   child: CircularProgressIndicator(
//                     strokeWidth: 2,
//                     color: Colors.white,
//                   ),
//                 )
//               : Text(
//                   _selectedWorkerIds.isEmpty
//                       ? 'اختر العمال للمتابعة'
//                       : 'إضافة ${_selectedWorkerIds.length} عامل',
//                   style: const TextStyle(
//                     fontSize: 16,
//                     fontWeight: FontWeight.bold,
//                   ),
//                 ),
//         ),
//       ),
//     );
//   }
//
//   void _toggleWorkerSelection(int? workerId) {
//     if (workerId == null) return;
//     setState(() {
//       if (_selectedWorkerIds.contains(workerId)) {
//         _selectedWorkerIds.remove(workerId);
//       } else {
//         _selectedWorkerIds.add(workerId);
//       }
//     });
//   }
//
//   void _handleAddWorkers(BuildContext context) {
//     context.read<AddInventoryCubit>().addInventoryAuditUsers(
//       userIds: _selectedWorkerIds.toList(),
//     );
//   }
//
//   void _handleBackPress(BuildContext context) {
//     showDialog(
//       context: context,
//       builder: (context) => AlertDialog(
//         shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
//         title: const Text('تأكيد الإلغاء'),
//         content: const Text('هل تريد إلغاء عملية إضافة العمال؟'),
//         actions: [
//           TextButton(
//             onPressed: () => Navigator.pop(context),
//             child: const Text('لا'),
//           ),
//           TextButton(
//             onPressed: () {
//               Navigator.pop(context);
//               Navigator.pop(context, false);
//             },
//             child: const Text('نعم', style: TextStyle(color: Colors.red)),
//           ),
//         ],
//       ),
//     );
//   }
// }
//
// // ============================================================
// // Widgets - العناصر المشتركة
// // ============================================================
//
// class _InventoryCard extends StatelessWidget {
//   final Data data;
//
//   const _InventoryCard({required this.data});
//
//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       decoration: BoxDecoration(
//         color: Colors.white,
//         borderRadius: BorderRadius.circular(16),
//         boxShadow: [
//           BoxShadow(
//             color: Colors.black.withOpacity(0.08),
//             blurRadius: 15,
//             offset: const Offset(0, 4),
//           ),
//         ],
//       ),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           _buildHeader(context),
//           const Divider(height: 1),
//           _buildInfoSection(),
//           if (data.workers != null && data.workers!.isNotEmpty) ...[
//             const Divider(height: 1),
//             _buildWorkersSection(),
//           ],
//         ],
//       ),
//     );
//   }
//
//   Widget _buildHeader(BuildContext context) {
//     return Container(
//       padding: const EdgeInsets.all(20),
//       decoration: BoxDecoration(
//         gradient: LinearGradient(
//           colors: [
//             Theme.of(context).primaryColor,
//             Theme.of(context).primaryColor.withOpacity(0.8),
//           ],
//         ),
//         borderRadius: const BorderRadius.only(
//           topLeft: Radius.circular(16),
//           topRight: Radius.circular(16),
//         ),
//       ),
//       child: Row(
//         children: [
//           Container(
//             padding: const EdgeInsets.all(12),
//             decoration: BoxDecoration(
//               color: Colors.white.withOpacity(0.2),
//               borderRadius: BorderRadius.circular(12),
//             ),
//             child: const Icon(Icons.inventory_2, color: Colors.white, size: 28),
//           ),
//           const SizedBox(width: 16),
//           Expanded(
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 const Text(
//                   'جرد نشط',
//                   style: TextStyle(
//                     color: Colors.white,
//                     fontSize: 14,
//                     fontWeight: FontWeight.w500,
//                   ),
//                 ),
//                 const SizedBox(height: 4),
//                 Text(
//                   'رقم الجرد: #${data.id}',
//                   style: const TextStyle(
//                     color: Colors.white,
//                     fontSize: 18,
//                     fontWeight: FontWeight.bold,
//                   ),
//                 ),
//               ],
//             ),
//           ),
//           _buildStatusBadge(data.status),
//         ],
//       ),
//     );
//   }
//
//   Widget _buildStatusBadge(String? status) {
//     final statusText = status ?? 'غير معروف';
//     final color = status == 'active' ? Colors.greenAccent : Colors.orangeAccent;
//
//     return Container(
//       padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
//       decoration: BoxDecoration(
//         color: Colors.white,
//         borderRadius: BorderRadius.circular(20),
//       ),
//       child: Text(
//         statusText,
//         style: TextStyle(
//           color: color,
//           fontSize: 12,
//           fontWeight: FontWeight.bold,
//         ),
//       ),
//     );
//   }
//
//   Widget _buildInfoSection() {
//     return Padding(
//       padding: const EdgeInsets.all(20),
//       child: Column(
//         children: [
//           if (data.auditDate != null)
//             _InfoRow(
//               icon: Icons.calendar_today,
//               label: 'تاريخ الجرد',
//               value: data.auditDate!,
//             ),
//           if (data.notes != null && data.notes!.isNotEmpty) ...[
//             const SizedBox(height: 16),
//             _InfoRow(
//               icon: Icons.note_alt_outlined,
//               label: 'الملاحظات',
//               value: data.notes!,
//             ),
//           ],
//         ],
//       ),
//     );
//   }
//
//   Widget _buildWorkersSection() {
//     return Padding(
//       padding: const EdgeInsets.all(20),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Row(
//             children: [
//               const Icon(Icons.people, size: 20),
//               const SizedBox(width: 8),
//               Text(
//                 'العمال المشاركين (${data.workers!.length})',
//                 style: const TextStyle(
//                   fontSize: 16,
//                   fontWeight: FontWeight.bold,
//                 ),
//               ),
//             ],
//           ),
//           const SizedBox(height: 16),
//           ...data.workers!.map((worker) => _WorkerListItem(worker: worker)),
//         ],
//       ),
//     );
//   }
// }
//
// class _InfoRow extends StatelessWidget {
//   final IconData icon;
//   final String label;
//   final String value;
//
//   const _InfoRow({
//     required this.icon,
//     required this.label,
//     required this.value,
//   });
//
//   @override
//   Widget build(BuildContext context) {
//     return Row(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         Icon(icon, size: 20, color: Colors.grey[600]),
//         const SizedBox(width: 12),
//         Expanded(
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               Text(
//                 label,
//                 style: TextStyle(
//                   fontSize: 13,
//                   color: Colors.grey[600],
//                   fontWeight: FontWeight.w500,
//                 ),
//               ),
//               const SizedBox(height: 4),
//               Text(
//                 value,
//                 style: const TextStyle(fontSize: 15, color: Colors.black87),
//               ),
//             ],
//           ),
//         ),
//       ],
//     );
//   }
// }
//
// class _WorkerListItem extends StatelessWidget {
//   final Workers worker;
//
//   const _WorkerListItem({required this.worker});
//
//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       margin: const EdgeInsets.only(bottom: 8),
//       padding: const EdgeInsets.all(12),
//       decoration: BoxDecoration(
//         color: Colors.grey[50],
//         borderRadius: BorderRadius.circular(10),
//         border: Border.all(color: Colors.grey[200]!),
//       ),
//       child: Row(
//         children: [
//           CircleAvatar(
//             radius: 20,
//             backgroundColor: Theme.of(context).primaryColor.withOpacity(0.1),
//             child: Text(
//               (worker.firstName?[0] ?? 'ع').toUpperCase(),
//               style: TextStyle(
//                 color: Theme.of(context).primaryColor,
//                 fontWeight: FontWeight.bold,
//               ),
//             ),
//           ),
//           const SizedBox(width: 12),
//           Expanded(
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Text(
//                   '${worker.firstName ?? ''} ${worker.lastName ?? ''}',
//                   style: const TextStyle(
//                     fontSize: 14,
//                     fontWeight: FontWeight.bold,
//                   ),
//                 ),
//                 if (worker.role != null)
//                   Text(
//                     worker.role!,
//                     style: TextStyle(fontSize: 12, color: Colors.grey[600]),
//                   ),
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
//
// class _WorkerCard extends StatelessWidget {
//   final User user;
//   final bool isSelected;
//   final VoidCallback onTap;
//
//   const _WorkerCard({
//     required this.user,
//     required this.isSelected,
//     required this.onTap,
//   });
//
//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       margin: const EdgeInsets.only(bottom: 12),
//       decoration: BoxDecoration(
//         color: Colors.white,
//         borderRadius: BorderRadius.circular(12),
//         border: Border.all(
//           color: isSelected
//               ? Theme.of(context).primaryColor
//               : Colors.grey[300]!,
//           width: isSelected ? 2 : 1,
//         ),
//         boxShadow: [
//           if (isSelected)
//             BoxShadow(
//               color: Theme.of(context).primaryColor.withOpacity(0.2),
//               blurRadius: 8,
//               offset: const Offset(0, 2),
//             ),
//         ],
//       ),
//       child: Material(
//         color: Colors.transparent,
//         child: InkWell(
//           onTap: onTap,
//           borderRadius: BorderRadius.circular(12),
//           child: Padding(
//             padding: const EdgeInsets.all(16),
//             child: Row(
//               children: [
//                 CircleAvatar(
//                   radius: 28,
//                   backgroundColor: isSelected
//                       ? Theme.of(context).primaryColor
//                       : Colors.grey[300],
//                   child: Text(
//                     (user.firstName?[0] ?? 'ع').toUpperCase(),
//                     style: TextStyle(
//                       color: isSelected ? Colors.white : Colors.grey[700],
//                       fontSize: 20,
//                       fontWeight: FontWeight.bold,
//                     ),
//                   ),
//                 ),
//                 const SizedBox(width: 16),
//                 Expanded(
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       Text(
//                         '${user.firstName ?? ''} ${user.lastName ?? ''}',
//                         style: const TextStyle(
//                           fontSize: 16,
//                           fontWeight: FontWeight.bold,
//                           color: Colors.black87,
//                         ),
//                       ),
//                       const SizedBox(height: 4),
//                       Row(
//                         children: [
//                           if (user.role != null) ...[
//                             Icon(
//                               Icons.work_outline,
//                               size: 14,
//                               color: Colors.grey[600],
//                             ),
//                             const SizedBox(width: 4),
//                             Text(
//                               user.role!,
//                               style: TextStyle(
//                                 fontSize: 13,
//                                 color: Colors.grey[600],
//                               ),
//                             ),
//                           ],
//                           if (user.phoneNumber != null) ...[
//                             const SizedBox(width: 12),
//                             Icon(
//                               Icons.phone_outlined,
//                               size: 14,
//                               color: Colors.grey[600],
//                             ),
//                             const SizedBox(width: 4),
//                             Flexible(
//                               child: Text(
//                                 user.phoneNumber!,
//                                 style: TextStyle(
//                                   fontSize: 13,
//                                   color: Colors.grey[600],
//                                 ),
//                                 overflow: TextOverflow.ellipsis,
//                               ),
//                             ),
//                           ],
//                         ],
//                       ),
//                     ],
//                   ),
//                 ),
//                 const SizedBox(width: 12),
//                 if (isSelected)
//                   Container(
//                     padding: const EdgeInsets.all(8),
//                     decoration: BoxDecoration(
//                       color: Theme.of(context).primaryColor,
//                       shape: BoxShape.circle,
//                     ),
//                     child: const Icon(
//                       Icons.check,
//                       color: Colors.white,
//                       size: 20,
//                     ),
//                   )
//                 else
//                   Container(
//                     width: 36,
//                     height: 36,
//                     decoration: BoxDecoration(
//                       border: Border.all(color: Colors.grey[400]!, width: 2),
//                       shape: BoxShape.circle,
//                     ),
//                   ),
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }
//
// class _EmptyInventoryWidget extends StatelessWidget {
//   const _EmptyInventoryWidget();
//
//   @override
//   Widget build(BuildContext context) {
//     return Center(
//       child: Column(
//         mainAxisAlignment: MainAxisAlignment.center,
//         children: [
//           Container(
//             padding: const EdgeInsets.all(24),
//             decoration: BoxDecoration(
//               color: Colors.grey[100],
//               shape: BoxShape.circle,
//             ),
//             child: Icon(
//               Icons.inventory_2_outlined,
//               size: 80,
//               color: Colors.grey[400],
//             ),
//           ),
//           const SizedBox(height: 24),
//           const Text(
//             'لا توجد جرود نشطة',
//             style: TextStyle(
//               fontSize: 20,
//               fontWeight: FontWeight.bold,
//               color: Colors.black87,
//             ),
//           ),
//           const SizedBox(height: 8),
//           Text(
//             'ابدأ بإنشاء جرد جديد',
//             style: TextStyle(fontSize: 15, color: Colors.grey[600]),
//           ),
//         ],
//       ),
//     );
//   }
// }
//
// class _ErrorWidget extends StatelessWidget {
//   final VoidCallback onRetry;
//
//   const _ErrorWidget({required this.onRetry});
//
//   @override
//   Widget build(BuildContext context) {
//     return Center(
//       child: Column(
//         mainAxisAlignment: MainAxisAlignment.center,
//         children: [
//           Icon(Icons.error_outline, size: 64, color: Colors.red[300]),
//           const SizedBox(height: 16),
//           Text(
//             'حدث خطأ أثناء جلب البيانات',
//             style: TextStyle(fontSize: 16, color: Colors.grey[600]),
//           ),
//           const SizedBox(height: 24),
//           ElevatedButton.icon(
//             onPressed: onRetry,
//             icon: const Icon(Icons.refresh),
//             label: const Text('إعادة المحاولة'),
//             style: ElevatedButton.styleFrom(
//               padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
//
// // ============================================================
// // Helper Functions - الدوال المساعدة
// // ============================================================
//
// void _showSnackBar(
//   BuildContext context,
//   String message,
//   Color backgroundColor,
// ) {
//   ScaffoldMessenger.of(context).showSnackBar(
//     SnackBar(
//       content: Text(message),
//       backgroundColor: backgroundColor,
//       behavior: SnackBarBehavior.floating,
//       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
//       duration: const Duration(seconds: 3),
//     ),
//   );
// }

///--------------------
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:stock_up/core/di/di.dart';
import 'package:stock_up/features/Inventory/data/models/response/get_inventory_by_user_model.dart';
import 'package:stock_up/features/Inventory/presentation/bloc/InventoryByUser/inventory_user_cubit.dart';

import 'create_inventory_page.dart';

class InventoryManagementPage extends StatelessWidget {
  const InventoryManagementPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => getIt<InventoryUserCubit>()..getInventoryByUser(),
      child: Builder(builder: (context) => const _InventoryPageView()),
    );
  }
}

class _InventoryPageView extends StatelessWidget {
  const _InventoryPageView();

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FD),
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        title: const Text(
          'الجرد النشط',
          style: TextStyle(
            color: Color(0xFF2D3436),
            fontSize: 20,
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
      ),
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
            return _ErrorWidget(
              onRetry: () =>
                  context.read<InventoryUserCubit>().getInventoryByUser(),
            );
          }

          if (state is InventoryUserSuccess) {
            final data = state.value?.data;
            if (data == null) {
              return const _EmptyInventoryWidget();
            }
            return SingleChildScrollView(
              padding: EdgeInsets.all(size.width * 0.04),
              child: _InventoryCard(data: data),
            );
          }

          return const SizedBox.shrink();
        },
      ),
      floatingActionButton: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          gradient: const LinearGradient(
            colors: [Color(0xFF6C63FF), Color(0xFF5A52D5)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          boxShadow: [
            BoxShadow(
              color: const Color(0xFF6C63FF).withOpacity(0.4),
              blurRadius: 12,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: FloatingActionButton.extended(
          onPressed: () => _navigateToCreateInventory(context),
          icon: const Icon(Icons.add_rounded, size: 24),
          label: const Text(
            'إنشاء جرد جديد',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
          ),
          backgroundColor: Colors.transparent,
          elevation: 0,
        ),
      ),
    );
  }

  void _navigateToCreateInventory(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const CreateInventoryPage()),
    ).then((created) {
      if (created == true) {
        context.read<InventoryUserCubit>().getInventoryByUser();
      }
    });
  }
}

// ============================================================
// Inventory Card Widget
// ============================================================

class _InventoryCard extends StatelessWidget {
  final Data data;

  const _InventoryCard({required this.data});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 20,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildHeader(context),
          const Divider(height: 1, color: Color(0xFFE8ECEF)),
          _buildInfoSection(),
          if (data.workers != null && data.workers!.isNotEmpty) ...[
            const Divider(height: 1, color: Color(0xFFE8ECEF)),
            _buildWorkersSection(),
          ],
        ],
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xFF6C63FF), Color(0xFF5A52D5)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(24),
          topRight: Radius.circular(24),
        ),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.2),
              borderRadius: BorderRadius.circular(16),
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
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'جرد نشط',
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.9),
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  'رقم الجرد: #${data.id}',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
          _buildStatusBadge(data.status),
        ],
      ),
    );
  }

  Widget _buildStatusBadge(String? status) {
    final statusText = status ?? 'غير معروف';
    final isActive = status == 'active';

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 8,
            height: 8,
            decoration: BoxDecoration(
              color: isActive
                  ? const Color(0xFF26DE81)
                  : const Color(0xFFFEA47F),
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: 6),
          Text(
            statusText,
            style: TextStyle(
              color: isActive
                  ? const Color(0xFF26DE81)
                  : const Color(0xFFFEA47F),
              fontSize: 13,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoSection() {
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        children: [
          if (data.auditDate != null)
            _InfoRow(
              icon: Icons.calendar_today_rounded,
              label: 'تاريخ الجرد',
              value: data.auditDate!,
              color: const Color(0xFF4ECDC4),
            ),
          if (data.notes != null && data.notes!.isNotEmpty) ...[
            const SizedBox(height: 20),
            _InfoRow(
              icon: Icons.note_alt_rounded,
              label: 'الملاحظات',
              value: data.notes!,
              color: const Color(0xFFFF6584),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildWorkersSection() {
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: const Color(0xFF6C63FF).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Icon(
                  Icons.people_rounded,
                  size: 20,
                  color: Color(0xFF6C63FF),
                ),
              ),
              const SizedBox(width: 12),
              Text(
                'العمال المشاركين (${data.workers!.length})',
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF2D3436),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          ...data.workers!.map((worker) => _WorkerListItem(worker: worker)),
        ],
      ),
    );
  }
}

// ============================================================
// Info Row Widget
// ============================================================

class _InfoRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final Color color;

  const _InfoRow({
    required this.icon,
    required this.label,
    required this.value,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(icon, size: 20, color: color),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: const TextStyle(
                  fontSize: 13,
                  color: Color(0xFF636E72),
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 6),
              Text(
                value,
                style: const TextStyle(
                  fontSize: 15,
                  color: Color(0xFF2D3436),
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

// ============================================================
// Worker List Item Widget
// ============================================================

class _WorkerListItem extends StatelessWidget {
  final Workers worker;

  const _WorkerListItem({required this.worker});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            const Color(0xFF6C63FF).withOpacity(0.05),
            const Color(0xFF4ECDC4).withOpacity(0.05),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFE8ECEF), width: 1),
      ),
      child: Row(
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFF6C63FF), Color(0xFF5A52D5)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(14),
              boxShadow: [
                BoxShadow(
                  color: const Color(0xFF6C63FF).withOpacity(0.3),
                  blurRadius: 8,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Center(
              child: Text(
                (worker.firstName?[0] ?? 'ع').toUpperCase(),
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
              ),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '${worker.firstName ?? ''} ${worker.lastName ?? ''}',
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF2D3436),
                  ),
                ),
                if (worker.role != null) ...[
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      Icon(
                        Icons.work_outline_rounded,
                        size: 14,
                        color: const Color(0xFF636E72),
                      ),
                      const SizedBox(width: 4),
                      Text(
                        worker.role!,
                        style: const TextStyle(
                          fontSize: 13,
                          color: Color(0xFF636E72),
                        ),
                      ),
                    ],
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ============================================================
// Empty Inventory Widget
// ============================================================

class _EmptyInventoryWidget extends StatelessWidget {
  const _EmptyInventoryWidget();

  @override
  Widget build(BuildContext context) {
    return Center(
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
              color: const Color(0xFF6C63FF).withOpacity(0.5),
            ),
          ),
          const SizedBox(height: 32),
          const Text(
            'لا توجد جرود نشطة',
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: Color(0xFF2D3436),
            ),
          ),
          const SizedBox(height: 12),
          Text(
            'ابدأ بإنشاء جرد جديد للبدء',
            style: TextStyle(fontSize: 15, color: const Color(0xFF636E72)),
          ),
        ],
      ),
    );
  }
}

// ============================================================
// Error Widget
// ============================================================

class _ErrorWidget extends StatelessWidget {
  final VoidCallback onRetry;

  const _ErrorWidget({required this.onRetry});

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
                color: const Color(0xFFFF6B9D).withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.error_outline_rounded,
                size: 64,
                color: const Color(0xFFFF6B9D),
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
            const SizedBox(height: 8),
            Text(
              'يرجى المحاولة مرة أخرى',
              style: TextStyle(fontSize: 14, color: const Color(0xFF636E72)),
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
                onPressed: onRetry,
                icon: const Icon(Icons.refresh_rounded),
                label: const Text(
                  'إعادة المحاولة',
                  style: TextStyle(fontWeight: FontWeight.bold),
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
