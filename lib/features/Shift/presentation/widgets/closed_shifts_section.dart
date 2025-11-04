// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:intl/intl.dart';
// import 'package:stock_up/features/Shift/data/models/response/get_closed_shift_model.dart';
// import 'package:stock_up/features/Shift/presentation/bloc/closed_shift/closed_shifts_cubit.dart';
//
// class ClosedShiftsSection extends StatelessWidget {
//   const ClosedShiftsSection({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         const Padding(
//           padding: EdgeInsets.only(bottom: 12),
//           child: Text(
//             'الورديات المغلقة',
//             style: TextStyle(
//               fontSize: 20,
//               fontWeight: FontWeight.bold,
//               color: Color(0xFF2C3E50),
//             ),
//           ),
//         ),
//         BlocBuilder<ClosedShiftsCubit, ClosedShiftsState>(
//           builder: (context, state) {
//             if (state is ClosedShiftLoading) {
//               return _buildLoadingState();
//             } else if (state is ClosedShiftSuccess) {
//               if (state.data?.shifts == null || state.data!.shifts!.isEmpty) {
//                 return _buildEmptyState();
//               }
//               return _buildShiftsList(state.data!.shifts!);
//             } else if (state is ClosedShiftFailure) {
//               return _buildErrorState(state.exception.toString());
//             }
//             return _buildEmptyState();
//           },
//         ),
//       ],
//     );
//   }
//
//   Widget _buildLoadingState() {
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
//   Widget _buildEmptyState() {
//     return Container(
//       padding: const EdgeInsets.all(40),
//       decoration: BoxDecoration(
//         color: Colors.white,
//         borderRadius: BorderRadius.circular(16),
//         border: Border.all(color: Colors.grey[300]!, width: 1),
//       ),
//       child: Column(
//         children: [
//           Icon(Icons.history, size: 64, color: Colors.grey[400]),
//           const SizedBox(height: 16),
//           Text(
//             'لا توجد ورديات مغلقة',
//             style: TextStyle(
//               fontSize: 16,
//               fontWeight: FontWeight.bold,
//               color: Colors.grey[600],
//             ),
//           ),
//           const SizedBox(height: 8),
//           Text(
//             'ستظهر هنا الورديات المغلقة السابقة',
//             style: TextStyle(fontSize: 14, color: Colors.grey[500]),
//             textAlign: TextAlign.center,
//           ),
//         ],
//       ),
//     );
//   }
//
//   Widget _buildErrorState(String error) {
//     return Container(
//       padding: const EdgeInsets.all(40),
//       decoration: BoxDecoration(
//         color: Colors.red[50],
//         borderRadius: BorderRadius.circular(16),
//         border: Border.all(color: Colors.red[200]!, width: 1),
//       ),
//       child: Column(
//         children: [
//           Icon(Icons.error_outline, size: 64, color: Colors.red[400]),
//           const SizedBox(height: 16),
//           Text(
//             'حدث خطأ',
//             style: TextStyle(
//               fontSize: 16,
//               fontWeight: FontWeight.bold,
//               color: Colors.red[700],
//             ),
//           ),
//           const SizedBox(height: 8),
//           Text(
//             error,
//             style: TextStyle(fontSize: 14, color: Colors.red[600]),
//             textAlign: TextAlign.center,
//           ),
//         ],
//       ),
//     );
//   }
//
//   Widget _buildShiftsList(List<ShiftsClosed> shifts) {
//     return ListView.separated(
//       shrinkWrap: true,
//       physics: const NeverScrollableScrollPhysics(),
//       itemCount: shifts.length,
//       separatorBuilder: (context, index) => const SizedBox(height: 12),
//       itemBuilder: (context, index) {
//         return _buildShiftCard(context, shifts[index]);
//       },
//     );
//   }
//
//   Widget _buildShiftCard(BuildContext context, ShiftsClosed shift) {
//     final startTime = _parseDateTime(shift.startTime);
//     final endTime = _parseDateTime(shift.endTime);
//     final duration = shift.durationMinutes ?? 0;
//
//     return Container(
//       decoration: BoxDecoration(
//         color: Colors.white,
//         borderRadius: BorderRadius.circular(16),
//         border: Border.all(color: Colors.grey[200]!, width: 1),
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
//           _buildCardHeader(shift, startTime),
//           const Divider(height: 1),
//           _buildCardBody(shift, duration),
//           const Divider(height: 1),
//           _buildCardFooter(context, shift),
//         ],
//       ),
//     );
//   }
//
//   Widget _buildCardHeader(ShiftsClosed shift, String startTime) {
//     return Container(
//       padding: const EdgeInsets.all(16),
//       decoration: BoxDecoration(
//         color: Colors.grey[50],
//         borderRadius: const BorderRadius.only(
//           topLeft: Radius.circular(16),
//           topRight: Radius.circular(16),
//         ),
//       ),
//       child: Row(
//         children: [
//           Container(
//             padding: const EdgeInsets.all(10),
//             decoration: BoxDecoration(
//               color: Colors.grey[200],
//               borderRadius: BorderRadius.circular(10),
//             ),
//             child: Icon(Icons.work_history, color: Colors.grey[700], size: 24),
//           ),
//           const SizedBox(width: 12),
//           Expanded(
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Text(
//                   'وردية #${shift.shiftId}',
//                   style: const TextStyle(
//                     fontSize: 16,
//                     fontWeight: FontWeight.bold,
//                     color: Color(0xFF2C3E50),
//                   ),
//                 ),
//                 const SizedBox(height: 4),
//                 Text(
//                   startTime,
//                   style: TextStyle(fontSize: 13, color: Colors.grey[600]),
//                 ),
//               ],
//             ),
//           ),
//           Container(
//             padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
//             decoration: BoxDecoration(
//               color: Colors.red[50],
//               borderRadius: BorderRadius.circular(20),
//               border: Border.all(color: Colors.red[200]!),
//             ),
//             child: Row(
//               mainAxisSize: MainAxisSize.min,
//               children: [
//                 Container(
//                   width: 6,
//                   height: 6,
//                   decoration: BoxDecoration(
//                     color: Colors.red[400],
//                     shape: BoxShape.circle,
//                   ),
//                 ),
//                 const SizedBox(width: 6),
//                 Text(
//                   'مغلقة',
//                   style: TextStyle(
//                     color: Colors.red[700],
//                     fontWeight: FontWeight.bold,
//                     fontSize: 11,
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
//   Widget _buildCardBody(ShiftsClosed shift, int duration) {
//     return Padding(
//       padding: const EdgeInsets.all(16),
//       child: Column(
//         children: [
//           Row(
//             children: [
//               Expanded(
//                 child: _buildInfoItem(
//                   Icons.login,
//                   'بداية',
//                   _formatTime(shift.startTime),
//                   Colors.green,
//                 ),
//               ),
//               const SizedBox(width: 12),
//               Expanded(
//                 child: _buildInfoItem(
//                   Icons.logout,
//                   'نهاية',
//                   _formatTime(shift.endTime),
//                   Colors.red,
//                 ),
//               ),
//             ],
//           ),
//           const SizedBox(height: 12),
//           Row(
//             children: [
//               Expanded(
//                 child: _buildInfoItem(
//                   Icons.timer,
//                   'المدة',
//                   _formatDuration(duration),
//                   Colors.blue,
//                 ),
//               ),
//               const SizedBox(width: 12),
//               Expanded(
//                 child: _buildInfoItem(
//                   Icons.store,
//                   'المتجر',
//                   '#${shift.storeId}',
//                   Colors.orange,
//                 ),
//               ),
//             ],
//           ),
//           const SizedBox(height: 12),
//           Row(
//             children: [
//               Expanded(
//                 child: _buildBalanceCard(
//                   'افتتاحي',
//                   shift.openingBalance ?? '0',
//                   Colors.green,
//                   Icons.arrow_downward,
//                 ),
//               ),
//               const SizedBox(width: 12),
//               Expanded(
//                 child: _buildBalanceCard(
//                   'ختامي',
//                   shift.closingBalance ?? '0',
//                   Colors.blue,
//                   Icons.arrow_upward,
//                 ),
//               ),
//             ],
//           ),
//         ],
//       ),
//     );
//   }
//
//   Widget _buildInfoItem(
//     IconData icon,
//     String label,
//     String value,
//     Color color,
//   ) {
//     return Container(
//       padding: const EdgeInsets.all(12),
//       decoration: BoxDecoration(
//         color: color.withOpacity(0.05),
//         borderRadius: BorderRadius.circular(10),
//         border: Border.all(color: color.withOpacity(0.2)),
//       ),
//       child: Row(
//         children: [
//           Icon(icon, color: color, size: 18),
//           const SizedBox(width: 8),
//           Expanded(
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Text(
//                   label,
//                   style: TextStyle(fontSize: 11, color: Colors.grey[600]),
//                 ),
//                 Text(
//                   value,
//                   style: TextStyle(
//                     fontSize: 13,
//                     fontWeight: FontWeight.bold,
//                     color: color,
//                   ),
//                   overflow: TextOverflow.ellipsis,
//                 ),
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }
//
//   Widget _buildBalanceCard(
//     String label,
//     String amount,
//     Color color,
//     IconData icon,
//   ) {
//     return Container(
//       padding: const EdgeInsets.all(12),
//       decoration: BoxDecoration(
//         gradient: LinearGradient(
//           colors: [color.withOpacity(0.1), color.withOpacity(0.05)],
//           begin: Alignment.topLeft,
//           end: Alignment.bottomRight,
//         ),
//         borderRadius: BorderRadius.circular(10),
//         border: Border.all(color: color.withOpacity(0.3)),
//       ),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Row(
//             children: [
//               Icon(icon, color: color, size: 16),
//               const SizedBox(width: 6),
//               Text(
//                 label,
//                 style: TextStyle(fontSize: 11, color: Colors.grey[600]),
//               ),
//             ],
//           ),
//           const SizedBox(height: 6),
//           Text(
//             '$amount ر.س',
//             style: TextStyle(
//               fontSize: 15,
//               fontWeight: FontWeight.bold,
//               color: color,
//             ),
//           ),
//         ],
//       ),
//     );
//   }
//
//   Widget _buildCardFooter(BuildContext context, ShiftsClosed shift) {
//     return Container(
//       padding: const EdgeInsets.all(12),
//       child: Row(
//         children: [
//           Expanded(
//             child: TextButton.icon(
//               onPressed: () {
//                 _showShiftDetails(context, shift);
//               },
//               icon: const Icon(Icons.visibility_outlined, size: 18),
//               label: const Text('عرض التفاصيل'),
//               style: TextButton.styleFrom(foregroundColor: Colors.blue[700]),
//             ),
//           ),
//           Container(width: 1, height: 24, color: Colors.grey[300]),
//           Expanded(
//             child: TextButton.icon(
//               onPressed: () {
//                 // TODO: Print report
//               },
//               icon: const Icon(Icons.print, size: 18),
//               label: const Text('طباعة'),
//               style: TextButton.styleFrom(foregroundColor: Colors.grey[700]),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
//
//   void _showShiftDetails(BuildContext context, ShiftsClosed shift) {
//     showModalBottomSheet(
//       context: context,
//       isScrollControlled: true,
//       backgroundColor: Colors.transparent,
//       builder: (context) => Container(
//         height: MediaQuery.of(context).size.height * 0.7,
//         decoration: const BoxDecoration(
//           color: Colors.white,
//           borderRadius: BorderRadius.only(
//             topLeft: Radius.circular(25),
//             topRight: Radius.circular(25),
//           ),
//         ),
//         child: Column(
//           children: [
//             Container(
//               padding: const EdgeInsets.all(20),
//               decoration: BoxDecoration(
//                 color: Colors.grey[100],
//                 borderRadius: const BorderRadius.only(
//                   topLeft: Radius.circular(25),
//                   topRight: Radius.circular(25),
//                 ),
//               ),
//               child: Column(
//                 children: [
//                   Container(
//                     width: 40,
//                     height: 4,
//                     decoration: BoxDecoration(
//                       color: Colors.grey[400],
//                       borderRadius: BorderRadius.circular(2),
//                     ),
//                   ),
//                   const SizedBox(height: 16),
//                   Row(
//                     children: [
//                       Icon(Icons.info_outline, color: Colors.blue[700]),
//                       const SizedBox(width: 12),
//                       const Text(
//                         'تفاصيل الوردية',
//                         style: TextStyle(
//                           fontSize: 20,
//                           fontWeight: FontWeight.bold,
//                         ),
//                       ),
//                       const Spacer(),
//                       IconButton(
//                         icon: const Icon(Icons.close),
//                         onPressed: () => Navigator.pop(context),
//                       ),
//                     ],
//                   ),
//                 ],
//               ),
//             ),
//             Expanded(
//               child: SingleChildScrollView(
//                 padding: const EdgeInsets.all(20),
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     _buildDetailSection('معلومات عامة', [
//                       _buildDetailRow2('رقم الوردية', '#${shift.shiftId}'),
//                       _buildDetailRow2('رقم المتجر', '#${shift.storeId}'),
//                       _buildDetailRow2('الحالة', 'مغلقة'),
//                     ]),
//                     const SizedBox(height: 20),
//                     _buildDetailSection('التوقيت', [
//                       _buildDetailRow2(
//                         'وقت البدء',
//                         _formatDateTime(shift.startTime),
//                       ),
//                       _buildDetailRow2(
//                         'وقت الانتهاء',
//                         _formatDateTime(shift.endTime),
//                       ),
//                       _buildDetailRow2(
//                         'مدة الوردية',
//                         _formatDuration(shift.durationMinutes ?? 0),
//                       ),
//                     ]),
//                     const SizedBox(height: 20),
//                     _buildDetailSection('الأرصدة', [
//                       _buildDetailRow2(
//                         'الرصيد الافتتاحي',
//                         '${shift.openingBalance} ر.س',
//                       ),
//                       _buildDetailRow2(
//                         'الرصيد الختامي',
//                         '${shift.closingBalance} ر.س',
//                       ),
//                       _buildDetailRow2(
//                         'الفرق',
//                         _calculateDifference(
//                           shift.openingBalance,
//                           shift.closingBalance,
//                         ),
//                       ),
//                     ]),
//                   ],
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
//
//   Widget _buildDetailSection(String title, List<Widget> children) {
//     return Container(
//       padding: const EdgeInsets.all(16),
//       decoration: BoxDecoration(
//         color: Colors.grey[50],
//         borderRadius: BorderRadius.circular(12),
//         border: Border.all(color: Colors.grey[200]!),
//       ),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Text(
//             title,
//             style: const TextStyle(
//               fontSize: 16,
//               fontWeight: FontWeight.bold,
//               color: Color(0xFF2C3E50),
//             ),
//           ),
//           const SizedBox(height: 12),
//           ...children,
//         ],
//       ),
//     );
//   }
//
//   Widget _buildDetailRow2(String label, String value) {
//     return Padding(
//       padding: const EdgeInsets.only(bottom: 8),
//       child: Row(
//         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//         children: [
//           Text(label, style: TextStyle(fontSize: 14, color: Colors.grey[600])),
//           Text(
//             value,
//             style: const TextStyle(
//               fontSize: 14,
//               fontWeight: FontWeight.bold,
//               color: Color(0xFF2C3E50),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
//
//   String _parseDateTime(String? dateTime) {
//     if (dateTime == null) return 'غير محدد';
//     try {
//       final date = DateTime.parse(dateTime);
//       return DateFormat('yyyy/MM/dd', 'ar').format(date);
//     } catch (e) {
//       return dateTime;
//     }
//   }
//
//   String _formatDateTime(String? dateTime) {
//     if (dateTime == null) return 'غير محدد';
//     try {
//       final date = DateTime.parse(dateTime);
//       return DateFormat('yyyy/MM/dd - hh:mm a', 'ar').format(date);
//     } catch (e) {
//       return dateTime;
//     }
//   }
//
//   String _formatTime(String? dateTime) {
//     if (dateTime == null) return '--:--';
//     try {
//       final date = DateTime.parse(dateTime);
//       return DateFormat('hh:mm a', 'ar').format(date);
//     } catch (e) {
//       return '--:--';
//     }
//   }
//
//   String _formatDuration(int minutes) {
//     if (minutes == 0) return '0 دقيقة';
//     final hours = minutes ~/ 60;
//     final mins = minutes % 60;
//     if (hours == 0) return '$mins دقيقة';
//     if (mins == 0) return '$hours ساعة';
//     return '$hours ساعة و $mins دقيقة';
//   }
//
//   String _calculateDifference(String? opening, String? closing) {
//     try {
//       final open = double.parse(opening ?? '0');
//       final close = double.parse(closing ?? '0');
//       final diff = close - open;
//       if (diff >= 0) {
//         return '+${diff.toStringAsFixed(2)} ر.س';
//       } else {
//         return '${diff.toStringAsFixed(2)} ر.س';
//       }
//     } catch (e) {
//       return '0 ر.س';
//     }
//   }
// }
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:stock_up/features/Shift/data/models/response/get_closed_shift_model.dart';
import 'package:stock_up/features/Shift/presentation/bloc/closed_shift/closed_shifts_cubit.dart';

class ClosedShiftsSection extends StatelessWidget {
  const ClosedShiftsSection({super.key});

  // ألوان محسنة
  final Color primaryColor = const Color(0xFF6366F1);
  final Color dangerColor = const Color(0xFFEF4444);
  final Color warningColor = const Color(0xFFF59E0B);
  final Color infoColor = const Color(0xFF3B82F6);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ClosedShiftsCubit, ClosedShiftsState>(
      builder: (context, state) {
        if (state is ClosedShiftLoading) {
          return _buildLoadingState();
        } else if (state is ClosedShiftSuccess) {
          if (state.data?.shifts == null || state.data!.shifts!.isEmpty) {
            return _buildEmptyState();
          }
          return _buildShiftsList(state.data!.shifts!);
        } else if (state is ClosedShiftFailure) {
          return _buildErrorState(state.exception.toString());
        }
        return _buildEmptyState();
      },
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

  Widget _buildEmptyState() {
    return Center(
      child: Container(
        padding: const EdgeInsets.all(50),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(24),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
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
                color: Colors.grey[100],
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.history_rounded,
                size: 70,
                color: Colors.grey[400],
              ),
            ),
            const SizedBox(height: 24),
            Text(
              'لا توجد ورديات مغلقة',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.grey[700],
              ),
            ),
            const SizedBox(height: 12),
            Text(
              'ستظهر هنا الورديات المغلقة السابقة',
              style: TextStyle(fontSize: 14, color: Colors.grey[500]),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildErrorState(String error) {
    return Center(
      child: Container(
        padding: const EdgeInsets.all(40),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(24),
          border: Border.all(color: dangerColor.withOpacity(0.3), width: 2),
          boxShadow: [
            BoxShadow(
              color: dangerColor.withOpacity(0.1),
              blurRadius: 20,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.error_outline_rounded, size: 70, color: dangerColor),
            const SizedBox(height: 20),
            Text(
              'حدث خطأ',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: dangerColor,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              error,
              style: TextStyle(fontSize: 14, color: Colors.grey[600]),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildShiftsList(List<ShiftsClosed> shifts) {
    return ListView.separated(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: shifts.length,
      separatorBuilder: (context, index) => const SizedBox(height: 16),
      itemBuilder: (context, index) {
        return _buildShiftCard(context, shifts[index]);
      },
    );
  }

  Widget _buildShiftCard(BuildContext context, ShiftsClosed shift) {
    final duration = shift.durationMinutes ?? 0;

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.grey[200]!, width: 1.5),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 15,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          _buildCardHeader(shift),
          _buildCardBody(context, shift, duration),
          _buildCardFooter(context, shift),
        ],
      ),
    );
  }

  Widget _buildCardHeader(ShiftsClosed shift) {
    final startTime = _parseDateTime(shift.startTime);

    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  primaryColor.withOpacity(0.15),
                  primaryColor.withOpacity(0.05),
                ],
              ),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              Icons.work_history_rounded,
              color: primaryColor,
              size: 26,
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'وردية #${shift.shiftId}',
                  style: const TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF1F2937),
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  startTime,
                  style: TextStyle(fontSize: 13, color: Colors.grey[600]),
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
            decoration: BoxDecoration(
              color: dangerColor.withOpacity(0.1),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: dangerColor.withOpacity(0.3),
                width: 1.5,
              ),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 7,
                  height: 7,
                  decoration: BoxDecoration(
                    color: dangerColor,
                    shape: BoxShape.circle,
                  ),
                ),
                const SizedBox(width: 8),
                Text(
                  'مغلقة',
                  style: TextStyle(
                    color: dangerColor,
                    fontWeight: FontWeight.bold,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCardBody(
    BuildContext context,
    ShiftsClosed shift,
    int duration,
  ) {
    return Padding(
      padding: const EdgeInsets.all(18),
      child: Column(
        children: [
          // صف الأول: البداية والنهاية
          Row(
            children: [
              Expanded(
                child: _buildInfoItem(
                  Icons.login_rounded,
                  'بداية',
                  _formatTime(shift.startTime),
                  const Color(0xFF10B981),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildInfoItem(
                  Icons.logout_rounded,
                  'نهاية',
                  _formatTime(shift.endTime),
                  dangerColor,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          // صف الثاني: المدة والمتجر
          Row(
            children: [
              Expanded(
                child: _buildInfoItem(
                  Icons.timer_rounded,
                  'المدة',
                  _formatDuration(duration),
                  infoColor,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildInfoItem(
                  Icons.store_rounded,
                  'المتجر',
                  '#${shift.storeId}',
                  warningColor,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          // الأرصدة
          _buildBalanceSection(shift),
        ],
      ),
    );
  }

  Widget _buildInfoItem(
    IconData icon,
    String label,
    String value,
    Color color,
  ) {
    return Container(
      padding: const EdgeInsets.all(13),
      decoration: BoxDecoration(
        color: color.withOpacity(0.05),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withOpacity(0.2), width: 1.5),
      ),
      child: Row(
        children: [
          Icon(icon, color: color, size: 20),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: TextStyle(
                    fontSize: 11,
                    color: Colors.grey[600],
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  value,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: color,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBalanceSection(ShiftsClosed shift) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            primaryColor.withOpacity(0.05),
            primaryColor.withOpacity(0.02),
          ],
        ),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: primaryColor.withOpacity(0.15), width: 1.5),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Icon(
                Icons.account_balance_wallet_rounded,
                color: primaryColor,
                size: 22,
              ),
              const SizedBox(width: 10),
              Text(
                'الأرصدة',
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.bold,
                  color: Colors.grey[700],
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: _buildBalanceCard(
                  'افتتاحي',
                  shift.openingBalance ?? '0',
                  const Color(0xFF10B981),
                  Icons.arrow_downward_rounded,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildBalanceCard(
                  'ختامي',
                  shift.closingBalance ?? '0',
                  infoColor,
                  Icons.arrow_upward_rounded,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildBalanceCard(
    String label,
    String amount,
    Color color,
    IconData icon,
  ) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: color.withOpacity(0.3), width: 1.5),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: color, size: 16),
              const SizedBox(width: 6),
              Text(
                label,
                style: TextStyle(
                  fontSize: 11,
                  color: Colors.grey[600],
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          Text(
            '$amount ر.س',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCardFooter(BuildContext context, ShiftsClosed shift) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(20),
          bottomRight: Radius.circular(20),
        ),
      ),
      child: Row(
        children: [
          Expanded(
            child: TextButton.icon(
              onPressed: () {
                _showShiftDetails(context, shift);
              },
              icon: Icon(
                Icons.visibility_off_outlined,
                size: 19,
                color: primaryColor,
              ),
              label: Text(
                'عرض التفاصيل',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: primaryColor,
                ),
              ),
              style: TextButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 10),
              ),
            ),
          ),
          Container(width: 1.5, height: 24, color: Colors.grey[300]),
          Expanded(
            child: TextButton.icon(
              onPressed: () {
                // TODO: Print report
              },
              icon: Icon(
                Icons.print_rounded,
                size: 19,
                color: Colors.grey[600],
              ),
              label: Text(
                'طباعة',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: Colors.grey[700],
                ),
              ),
              style: TextButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 10),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showShiftDetails(BuildContext context, ShiftsClosed shift) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        height: MediaQuery.of(context).size.height * 0.75,
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(28),
            topRight: Radius.circular(28),
          ),
        ),
        child: Column(
          children: [
            // Header
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.grey[50],
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(28),
                  topRight: Radius.circular(28),
                ),
              ),
              child: Column(
                children: [
                  Container(
                    width: 45,
                    height: 5,
                    decoration: BoxDecoration(
                      color: Colors.grey[300],
                      borderRadius: BorderRadius.circular(3),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              primaryColor.withOpacity(0.15),
                              primaryColor.withOpacity(0.05),
                            ],
                          ),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Icon(
                          Icons.info_outline_rounded,
                          color: primaryColor,
                          size: 24,
                        ),
                      ),
                      const SizedBox(width: 12),
                      const Text(
                        'تفاصيل الوردية',
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF1F2937),
                        ),
                      ),
                      const Spacer(),
                      IconButton(
                        icon: const Icon(Icons.close_rounded),
                        onPressed: () => Navigator.pop(context),
                        color: Colors.grey[600],
                      ),
                    ],
                  ),
                ],
              ),
            ),
            // Content
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildDetailSection('معلومات عامة', [
                      _buildDetailRow('رقم الوردية', '#${shift.shiftId}'),
                      _buildDetailRow('رقم المتجر', '#${shift.storeId}'),
                      _buildDetailRow('الحالة', 'مغلقة'),
                    ]),
                    const SizedBox(height: 16),
                    _buildDetailSection('التوقيت', [
                      _buildDetailRow(
                        'وقت البدء',
                        _formatDateTime(shift.startTime),
                      ),
                      _buildDetailRow(
                        'وقت الانتهاء',
                        _formatDateTime(shift.endTime),
                      ),
                      _buildDetailRow(
                        'مدة الوردية',
                        _formatDuration(shift.durationMinutes ?? 0),
                      ),
                    ]),
                    const SizedBox(height: 16),
                    _buildDetailSection('الأرصدة', [
                      _buildDetailRow(
                        'الرصيد الافتتاحي',
                        '${shift.openingBalance} ر.س',
                      ),
                      _buildDetailRow(
                        'الرصيد الختامي',
                        '${shift.closingBalance} ر.س',
                      ),
                      _buildDetailRow(
                        'الفرق',
                        _calculateDifference(
                          shift.openingBalance,
                          shift.closingBalance,
                        ),
                      ),
                    ]),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailSection(String title, List<Widget> children) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey[200]!, width: 1.5),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: primaryColor,
            ),
          ),
          const SizedBox(height: 14),
          ...children,
        ],
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: TextStyle(fontSize: 14, color: Colors.grey[600])),
          const SizedBox(width: 16),
          Flexible(
            child: Text(
              value,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: Color(0xFF1F2937),
              ),
              textAlign: TextAlign.end,
            ),
          ),
        ],
      ),
    );
  }

  String _parseDateTime(String? dateTime) {
    if (dateTime == null) return 'غير محدد';
    try {
      final date = DateTime.parse(dateTime);
      return DateFormat('yyyy/MM/dd', 'ar').format(date);
    } catch (e) {
      return dateTime;
    }
  }

  String _formatDateTime(String? dateTime) {
    if (dateTime == null) return 'غير محدد';
    try {
      final date = DateTime.parse(dateTime);
      return DateFormat('yyyy/MM/dd - hh:mm a', 'ar').format(date);
    } catch (e) {
      return dateTime;
    }
  }

  String _formatTime(String? dateTime) {
    if (dateTime == null) return '--:--';
    try {
      final date = DateTime.parse(dateTime);
      return DateFormat('hh:mm a', 'ar').format(date);
    } catch (e) {
      return '--:--';
    }
  }

  String _formatDuration(int minutes) {
    if (minutes == 0) return '0 دقيقة';
    final hours = minutes ~/ 60;
    final mins = minutes % 60;
    if (hours == 0) return '$mins دقيقة';
    if (mins == 0) return '$hours ساعة';
    return '$hours ساعة و $mins دقيقة';
  }

  String _calculateDifference(String? opening, String? closing) {
    try {
      final open = double.parse(opening ?? '0');
      final close = double.parse(closing ?? '0');
      final diff = close - open;
      if (diff >= 0) {
        return '+${diff.toStringAsFixed(2)} ر.س';
      } else {
        return '${diff.toStringAsFixed(2)} ر.س';
      }
    } catch (e) {
      return '0 ر.س';
    }
  }
}
