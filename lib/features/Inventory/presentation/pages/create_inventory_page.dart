// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:stock_up/core/di/di.dart';
// import 'package:stock_up/features/Inventory/presentation/bloc/createInventory/create_inventory_cubit.dart';
//
// import 'select_workers_page.dart';
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
//     final size = MediaQuery.of(context).size;
//
//     return BlocProvider(
//       create: (context) => getIt<CreateInventoryCubit>(),
//       child: Builder(
//         builder: (context) => Scaffold(
//           backgroundColor: const Color(0xFFF8F9FD),
//           appBar: _buildAppBar(context),
//           body: BlocListener<CreateInventoryCubit, CreateInventoryState>(
//             listener: _handleBlocListener,
//             child: SingleChildScrollView(
//               padding: EdgeInsets.all(size.width * 0.05),
//               child: Form(
//                 key: _formKey,
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.stretch,
//                   children: [
//                     _buildHeaderSection(context),
//                     SizedBox(height: size.height * 0.04),
//                     _buildNotesSection(context),
//                     SizedBox(height: size.height * 0.05),
//                     _buildCreateButton(context),
//                   ],
//                 ),
//               ),
//             ),
//           ),
//         ),
//       ),
//     );
//   }
//
//   PreferredSizeWidget _buildAppBar(BuildContext context) {
//     return AppBar(
//       elevation: 0,
//       backgroundColor: Colors.white,
//       leading: Container(
//         margin: const EdgeInsets.all(8),
//         decoration: BoxDecoration(
//           color: const Color(0xFF6C63FF).withOpacity(0.1),
//           borderRadius: BorderRadius.circular(12),
//         ),
//         child: IconButton(
//           icon: const Icon(Icons.arrow_back_rounded, color: Color(0xFF6C63FF)),
//           onPressed: () => Navigator.pop(context),
//         ),
//       ),
//       title: const Text(
//         'إنشاء جرد جديد',
//         style: TextStyle(
//           color: Color(0xFF2D3436),
//           fontSize: 20,
//           fontWeight: FontWeight.bold,
//         ),
//       ),
//       centerTitle: true,
//     );
//   }
//
//   Widget _buildHeaderSection(BuildContext context) {
//     return Container(
//       padding: const EdgeInsets.all(28),
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
//       child: Column(
//         children: [
//           Container(
//             padding: const EdgeInsets.all(20),
//             decoration: BoxDecoration(
//               gradient: const LinearGradient(
//                 colors: [Color(0xFF6C63FF), Color(0xFF5A52D5)],
//                 begin: Alignment.topLeft,
//                 end: Alignment.bottomRight,
//               ),
//               borderRadius: BorderRadius.circular(20),
//               boxShadow: [
//                 BoxShadow(
//                   color: const Color(0xFF6C63FF).withOpacity(0.3),
//                   blurRadius: 15,
//                   offset: const Offset(0, 8),
//                 ),
//               ],
//             ),
//             child: const Icon(
//               Icons.inventory_2_rounded,
//               size: 56,
//               color: Colors.white,
//             ),
//           ),
//           const SizedBox(height: 24),
//           const Text(
//             'ابدأ بإنشاء جرد جديد',
//             style: TextStyle(
//               fontSize: 22,
//               fontWeight: FontWeight.bold,
//               color: Color(0xFF2D3436),
//             ),
//           ),
//           const SizedBox(height: 12),
//           Text(
//             'قم بإضافة ملاحظات اختيارية ثم اختر العمال المشاركين',
//             textAlign: TextAlign.center,
//             style: TextStyle(
//               fontSize: 15,
//               color: const Color(0xFF636E72),
//               height: 1.5,
//             ),
//           ),
//         ],
//       ),
//     );
//   }
//
//   Widget _buildNotesSection(BuildContext context) {
//     return Container(
//       padding: const EdgeInsets.all(24),
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
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Row(
//             children: [
//               Container(
//                 padding: const EdgeInsets.all(10),
//                 decoration: BoxDecoration(
//                   color: const Color(0xFFFF6584).withOpacity(0.1),
//                   borderRadius: BorderRadius.circular(12),
//                 ),
//                 child: const Icon(
//                   Icons.note_alt_rounded,
//                   color: Color(0xFFFF6584),
//                   size: 24,
//                 ),
//               ),
//               const SizedBox(width: 12),
//               const Text(
//                 'الملاحظات',
//                 style: TextStyle(
//                   fontSize: 18,
//                   fontWeight: FontWeight.bold,
//                   color: Color(0xFF2D3436),
//                 ),
//               ),
//               const SizedBox(width: 8),
//               Container(
//                 padding: const EdgeInsets.symmetric(
//                   horizontal: 10,
//                   vertical: 4,
//                 ),
//                 decoration: BoxDecoration(
//                   color: const Color(0xFF4ECDC4).withOpacity(0.1),
//                   borderRadius: BorderRadius.circular(8),
//                 ),
//                 child: const Text(
//                   'اختياري',
//                   style: TextStyle(
//                     fontSize: 12,
//                     color: Color(0xFF4ECDC4),
//                     fontWeight: FontWeight.bold,
//                   ),
//                 ),
//               ),
//             ],
//           ),
//           const SizedBox(height: 20),
//           TextFormField(
//             controller: _notesController,
//             maxLines: 5,
//             textAlign: TextAlign.right,
//             style: const TextStyle(fontSize: 15, height: 1.6),
//             decoration: InputDecoration(
//               hintText:
//                   'أضف ملاحظات حول الجرد...\nمثال: جرد المخزن الرئيسي - الربع الأول',
//               hintStyle: TextStyle(
//                 color: Colors.grey[400],
//                 fontSize: 14,
//                 height: 1.5,
//               ),
//               filled: true,
//               fillColor: const Color(0xFFF8F9FD),
//               border: OutlineInputBorder(
//                 borderRadius: BorderRadius.circular(16),
//                 borderSide: BorderSide(color: Colors.grey[300]!),
//               ),
//               enabledBorder: OutlineInputBorder(
//                 borderRadius: BorderRadius.circular(16),
//                 borderSide: BorderSide(color: Colors.grey[300]!),
//               ),
//               focusedBorder: OutlineInputBorder(
//                 borderRadius: BorderRadius.circular(16),
//                 borderSide: const BorderSide(
//                   color: Color(0xFF6C63FF),
//                   width: 2,
//                 ),
//               ),
//               contentPadding: const EdgeInsets.all(20),
//             ),
//           ),
//         ],
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
//       child: ElevatedButton(
//         onPressed: _isCreating ? null : () => _handleCreateInventory(context),
//         style: ElevatedButton.styleFrom(
//           backgroundColor: Colors.transparent,
//           shadowColor: Colors.transparent,
//           padding: const EdgeInsets.symmetric(vertical: 18),
//           shape: RoundedRectangleBorder(
//             borderRadius: BorderRadius.circular(20),
//           ),
//         ),
//         child: _isCreating
//             ? const SizedBox(
//                 height: 24,
//                 width: 24,
//                 child: CircularProgressIndicator(
//                   strokeWidth: 3,
//                   color: Colors.white,
//                 ),
//               )
//             : Row(
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 children: [
//                   const Text(
//                     'التالي - اختيار العمال',
//                     style: TextStyle(
//                       fontSize: 17,
//                       fontWeight: FontWeight.bold,
//                       color: Colors.white,
//                     ),
//                   ),
//                   const SizedBox(width: 8),
//                   const Icon(Icons.arrow_forward_rounded, color: Colors.white),
//                 ],
//               ),
//       ),
//     );
//   }
//
//   void _handleBlocListener(BuildContext context, CreateInventoryState state) {
//     if (state is CreateInventoryLoading) {
//       setState(() => _isCreating = true);
//     } else {
//       setState(() => _isCreating = false);
//     }
//
//     if (state is CreateInventorySuccess) {
//       final auditId = state.value?.audit?.id;
//       if (auditId != null) {
//         Navigator.pushReplacement(
//           context,
//           MaterialPageRoute(
//             builder: (context) => SelectWorkersPage(auditId: auditId),
//           ),
//         );
//       } else {
//         _showSnackBar(
//           context,
//           'حدث خطأ في إنشاء الجرد',
//           const Color(0xFFFF6B9D),
//           Icons.error_rounded,
//         );
//       }
//     }
//
//     if (state is CreateInventoryFailure) {
//       _showSnackBar(
//         context,
//         'فشل إنشاء الجرد، حاول مرة أخرى',
//         const Color(0xFFFF6B9D),
//         Icons.error_rounded,
//       );
//     }
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
// }
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:stock_up/core/di/di.dart';
import 'package:stock_up/features/Inventory/presentation/bloc/createInventory/create_inventory_cubit.dart';

class CreateInventoryPage extends StatefulWidget {
  const CreateInventoryPage({super.key});

  @override
  State<CreateInventoryPage> createState() => _CreateInventoryPageState();
}

class _CreateInventoryPageState extends State<CreateInventoryPage> {
  final _formKey = GlobalKey<FormState>();
  final _notesController = TextEditingController();
  bool _isCreating = false;

  @override
  void dispose() {
    _notesController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return BlocProvider(
      create: (context) => getIt<CreateInventoryCubit>(),
      child: Builder(
        builder: (context) => Scaffold(
          backgroundColor: const Color(0xFFF8F9FD),
          appBar: _buildAppBar(context),
          body: BlocListener<CreateInventoryCubit, CreateInventoryState>(
            listener: _handleBlocListener,
            child: SingleChildScrollView(
              padding: EdgeInsets.all(size.width * 0.05),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    _buildHeaderSection(context),
                    SizedBox(height: size.height * 0.04),
                    _buildNotesSection(context),
                    SizedBox(height: size.height * 0.05),
                    _buildCreateButton(context),
                  ],
                ),
              ),
            ),
          ),
        ),
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
          color: const Color(0xFF6C63FF).withOpacity(0.1),
          borderRadius: BorderRadius.circular(12),
        ),
        child: IconButton(
          icon: const Icon(Icons.arrow_back_rounded, color: Color(0xFF6C63FF)),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      title: const Text(
        'إنشاء جرد جديد',
        style: TextStyle(
          color: Color(0xFF2D3436),
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ),
      ),
      centerTitle: true,
    );
  }

  Widget _buildHeaderSection(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(28),
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
        children: [
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFF6C63FF), Color(0xFF5A52D5)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: const Color(0xFF6C63FF).withOpacity(0.3),
                  blurRadius: 15,
                  offset: const Offset(0, 8),
                ),
              ],
            ),
            child: const Icon(
              Icons.inventory_2_rounded,
              size: 56,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 24),
          const Text(
            'ابدأ بإنشاء جرد جديد',
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: Color(0xFF2D3436),
            ),
          ),
          const SizedBox(height: 12),
          Text(
            'قم بإضافة ملاحظات اختيارية للجرد',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 15,
              color: const Color(0xFF636E72),
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNotesSection(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
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
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: const Color(0xFFFF6584).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(
                  Icons.note_alt_rounded,
                  color: Color(0xFFFF6584),
                  size: 24,
                ),
              ),
              const SizedBox(width: 12),
              const Text(
                'الملاحظات',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF2D3436),
                ),
              ),
              const SizedBox(width: 8),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 4,
                ),
                decoration: BoxDecoration(
                  color: const Color(0xFF4ECDC4).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Text(
                  'اختياري',
                  style: TextStyle(
                    fontSize: 12,
                    color: Color(0xFF4ECDC4),
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          TextFormField(
            controller: _notesController,
            maxLines: 5,
            textAlign: TextAlign.right,
            style: const TextStyle(fontSize: 15, height: 1.6),
            decoration: InputDecoration(
              hintText:
                  'أضف ملاحظات حول الجرد...\nمثال: جرد المخزن الرئيسي - الربع الأول',
              hintStyle: TextStyle(
                color: Colors.grey[400],
                fontSize: 14,
                height: 1.5,
              ),
              filled: true,
              fillColor: const Color(0xFFF8F9FD),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(16),
                borderSide: BorderSide(color: Colors.grey[300]!),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(16),
                borderSide: BorderSide(color: Colors.grey[300]!),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(16),
                borderSide: const BorderSide(
                  color: Color(0xFF6C63FF),
                  width: 2,
                ),
              ),
              contentPadding: const EdgeInsets.all(20),
            ),
          ),
        ],
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
      child: ElevatedButton(
        onPressed: _isCreating ? null : () => _handleCreateInventory(context),
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.transparent,
          shadowColor: Colors.transparent,
          padding: const EdgeInsets.symmetric(vertical: 18),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
        ),
        child: _isCreating
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
                children: const [
                  Icon(Icons.add_circle_rounded, color: Colors.white),
                  SizedBox(width: 12),
                  Text(
                    'إنشاء الجرد',
                    style: TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
      ),
    );
  }

  void _handleBlocListener(BuildContext context, CreateInventoryState state) {
    if (state is CreateInventoryLoading) {
      setState(() => _isCreating = true);
    } else {
      setState(() => _isCreating = false);
    }

    if (state is CreateInventorySuccess) {
      _showSnackBar(
        context,
        'تم إنشاء الجرد بنجاح',
        const Color(0xFF26DE81),
        Icons.check_circle_rounded,
      );

      // العودة إلى صفحة القائمة مع تحديث البيانات
      Future.delayed(const Duration(milliseconds: 500), () {
        Navigator.pop(context, true);
      });
    }

    if (state is CreateInventoryFailure) {
      _showSnackBar(
        context,
        'فشل إنشاء الجرد، حاول مرة أخرى',
        const Color(0xFFFF6B9D),
        Icons.error_rounded,
      );
    }
  }

  void _handleCreateInventory(BuildContext context) {
    if (_formKey.currentState!.validate()) {
      final notes = _notesController.text.trim().isEmpty
          ? null
          : _notesController.text.trim();
      context.read<CreateInventoryCubit>().createInventory(notes: notes);
    }
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
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        duration: const Duration(seconds: 3),
      ),
    );
  }
}
