// import 'package:flutter/material.dart';
// import 'package:intl/intl.dart';
// import 'package:stock_up/features/Shift/domain/entities/shift_entity.dart';
// import 'package:stock_up/features/Transaction/presentation/pages/Transaction_page.dart';
//
// class OpenShiftCard extends StatelessWidget {
//   final GetOpenShiftEntity data;
//
//   const OpenShiftCard({super.key, required this.data});
//
//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       decoration: BoxDecoration(
//         gradient: LinearGradient(
//           colors: [Colors.green[400]!, Colors.green[600]!],
//           begin: Alignment.topLeft,
//           end: Alignment.bottomRight,
//         ),
//         borderRadius: BorderRadius.circular(20),
//         boxShadow: [
//           BoxShadow(
//             color: Colors.green.withOpacity(0.4),
//             blurRadius: 15,
//             offset: const Offset(0, 5),
//           ),
//         ],
//       ),
//       child: Column(
//         children: [
//           _buildHeader(context),
//           Container(
//             padding: const EdgeInsets.all(20),
//             decoration: const BoxDecoration(
//               color: Colors.white,
//               borderRadius: BorderRadius.only(
//                 bottomLeft: Radius.circular(20),
//                 bottomRight: Radius.circular(20),
//               ),
//             ),
//             child: Column(
//               children: [
//                 _buildUserInfo(),
//                 const SizedBox(height: 16),
//                 _buildShiftDetails(),
//                 const SizedBox(height: 20),
//                 _buildActionButtons(context),
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }
//
//   Widget _buildHeader(BuildContext context) {
//     return Container(
//       padding: const EdgeInsets.all(20),
//       child: Row(
//         children: [
//           Container(
//             padding: const EdgeInsets.all(12),
//             decoration: BoxDecoration(
//               color: Colors.white.withOpacity(0.2),
//               borderRadius: BorderRadius.circular(12),
//             ),
//             child: const Icon(
//               Icons.check_circle,
//               color: Colors.white,
//               size: 28,
//             ),
//           ),
//           const SizedBox(width: 16),
//           const Expanded(
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Text(
//                   'وردية نشطة',
//                   style: TextStyle(
//                     color: Colors.white,
//                     fontSize: 20,
//                     fontWeight: FontWeight.bold,
//                   ),
//                 ),
//                 SizedBox(height: 4),
//                 Text(
//                   'جارية الآن',
//                   style: TextStyle(color: Colors.white, fontSize: 14),
//                 ),
//               ],
//             ),
//           ),
//           Container(
//             padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
//             decoration: BoxDecoration(
//               color: Colors.white,
//               borderRadius: BorderRadius.circular(20),
//             ),
//             child: Row(
//               mainAxisSize: MainAxisSize.min,
//               children: [
//                 Container(
//                   width: 8,
//                   height: 8,
//                   decoration: const BoxDecoration(
//                     color: Colors.green,
//                     shape: BoxShape.circle,
//                   ),
//                 ),
//                 const SizedBox(width: 6),
//                 const Text(
//                   'مفتوحة',
//                   style: TextStyle(
//                     color: Colors.green,
//                     fontWeight: FontWeight.bold,
//                     fontSize: 12,
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
//   Widget _buildUserInfo() {
//     return Container(
//       padding: const EdgeInsets.all(16),
//       decoration: BoxDecoration(
//         color: Colors.grey[50],
//         borderRadius: BorderRadius.circular(12),
//         border: Border.all(color: Colors.grey[200]!),
//       ),
//       child: Row(
//         children: [
//           CircleAvatar(
//             radius: 30,
//             backgroundColor: Colors.green[100],
//             backgroundImage: data.user?.profileImage != null
//                 ? NetworkImage(data.user!.profileImage.toString())
//                 : null,
//             child: data.user?.profileImage == null
//                 ? Text(
//                     _getInitials(),
//                     style: TextStyle(
//                       color: Colors.green[700],
//                       fontWeight: FontWeight.bold,
//                       fontSize: 18,
//                     ),
//                   )
//                 : null,
//           ),
//           const SizedBox(width: 16),
//           Expanded(
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Text(
//                   '${data.user?.firstName ?? ''} ${data.user?.lastName ?? ''}',
//                   style: const TextStyle(
//                     fontSize: 18,
//                     fontWeight: FontWeight.bold,
//                     color: Color(0xFF2C3E50),
//                   ),
//                 ),
//                 const SizedBox(height: 4),
//                 Container(
//                   padding: const EdgeInsets.symmetric(
//                     horizontal: 8,
//                     vertical: 4,
//                   ),
//                   decoration: BoxDecoration(
//                     color: Colors.blue[50],
//                     borderRadius: BorderRadius.circular(6),
//                   ),
//                   child: Text(
//                     data.user?.role ?? 'موظف',
//                     style: TextStyle(
//                       fontSize: 12,
//                       color: Colors.blue[700],
//                       fontWeight: FontWeight.w600,
//                     ),
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
//   Widget _buildShiftDetails() {
//     return Column(
//       children: [
//         _buildDetailRow(
//           Icons.access_time,
//           'وقت البداية',
//           _formatDateTime(data.shift?.startTime),
//           Colors.blue,
//         ),
//         const SizedBox(height: 12),
//         _buildDetailRow(
//           Icons.account_balance_wallet,
//           'الرصيد الافتتاحي',
//           '${data.shift?.openingBalance ?? '0'} ر.س',
//           Colors.green,
//         ),
//         const SizedBox(height: 12),
//         _buildDetailRow(
//           Icons.store,
//           'المتجر',
//           'متجر #${data.shift?.storeId ?? 'N/A'}',
//           Colors.orange,
//         ),
//       ],
//     );
//   }
//
//   Widget _buildDetailRow(
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
//           Container(
//             padding: const EdgeInsets.all(8),
//             decoration: BoxDecoration(
//               color: color.withOpacity(0.1),
//               borderRadius: BorderRadius.circular(8),
//             ),
//             child: Icon(icon, color: color, size: 20),
//           ),
//           const SizedBox(width: 12),
//           Expanded(
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Text(
//                   label,
//                   style: TextStyle(fontSize: 12, color: Colors.grey[600]),
//                 ),
//                 const SizedBox(height: 2),
//                 Text(
//                   value,
//                   style: const TextStyle(
//                     fontSize: 16,
//                     fontWeight: FontWeight.bold,
//                     color: Color(0xFF2C3E50),
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
//   Widget _buildActionButtons(BuildContext context) {
//     return Row(
//       children: [
//         Expanded(
//           child: OutlinedButton.icon(
//             onPressed: () {
//               // Navigate to shift details
//             },
//             icon: const Icon(Icons.visibility_outlined, size: 20),
//             label: const Text('التفاصيل'),
//             style: OutlinedButton.styleFrom(
//               foregroundColor: Colors.green[700],
//               side: BorderSide(color: Colors.green[300]!),
//               padding: const EdgeInsets.symmetric(vertical: 12),
//               shape: RoundedRectangleBorder(
//                 borderRadius: BorderRadius.circular(10),
//               ),
//             ),
//           ),
//         ),
//         const SizedBox(width: 12),
//         Expanded(
//           child: ElevatedButton.icon(
//             onPressed: () {
//               Navigator.push(
//                 context,
//                 MaterialPageRoute(
//                   builder: (context) => TransactionPage(shift: data.shift!),
//                 ),
//               );
//               // _showCloseShiftDialog(context);
//             },
//             icon: const Icon(Icons.exit_to_app, size: 20),
//             label: const Text('إغلاق الوردية'),
//             style: ElevatedButton.styleFrom(
//               backgroundColor: Colors.red[400],
//               foregroundColor: Colors.white,
//               padding: const EdgeInsets.symmetric(vertical: 12),
//               shape: RoundedRectangleBorder(
//                 borderRadius: BorderRadius.circular(10),
//               ),
//               elevation: 2,
//             ),
//           ),
//         ),
//       ],
//     );
//   }
//
//   void _showCloseShiftDialog(BuildContext context) {
//     showDialog(
//       context: context,
//       builder: (context) => AlertDialog(
//         shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
//         title: const Row(
//           children: [
//             Icon(Icons.warning_amber, color: Colors.orange, size: 28),
//             SizedBox(width: 12),
//             Text('إغلاق الوردية'),
//           ],
//         ),
//         content: const Text(
//           'هل أنت متأكد من إغلاق الوردية الحالية؟',
//           style: TextStyle(fontSize: 16),
//         ),
//         actions: [
//           TextButton(
//             onPressed: () => Navigator.push(
//               context,
//               MaterialPageRoute(
//                 builder: (context) => TransactionPage(shift: data.shift!),
//               ),
//             ),
//             child: const Text('إلغاء'),
//           ),
//           ElevatedButton(
//             onPressed: () {
//               Navigator.pop(context);
//               // TODO: Implement close shift logic
//             },
//             style: ElevatedButton.styleFrom(
//               backgroundColor: Colors.red,
//               shape: RoundedRectangleBorder(
//                 borderRadius: BorderRadius.circular(10),
//               ),
//             ),
//             child: const Text('إغلاق'),
//           ),
//         ],
//       ),
//     );
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
//   String _getInitials() {
//     final firstName = data.user?.firstName ?? '';
//     final lastName = data.user?.lastName ?? '';
//     return '${firstName.isNotEmpty ? firstName[0] : ''}${lastName.isNotEmpty ? lastName[0] : ''}'
//         .toUpperCase();
//   }
// }
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:stock_up/features/Shift/domain/entities/shift_entity.dart';
import 'package:stock_up/features/Transaction/presentation/pages/Transaction_page.dart';

class OpenShiftCard extends StatefulWidget {
  final GetOpenShiftEntity data;

  const OpenShiftCard({super.key, required this.data});

  @override
  State<OpenShiftCard> createState() => _OpenShiftCardState();
}

class _OpenShiftCardState extends State<OpenShiftCard> {
  late Timer _timer;
  Duration _duration = Duration.zero;

  // ألوان محسنة
  final Color primaryColor = const Color(0xFF6366F1);
  final Color accentColor = const Color(0xFF10B981);
  final Color warningColor = const Color(0xFFF59E0B);
  final Color dangerColor = const Color(0xFFEF4444);

  @override
  void initState() {
    super.initState();
    _startTimer();
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  void _startTimer() {
    if (widget.data.shift?.startTime != null) {
      final startTime = DateTime.parse(widget.data.shift!.startTime!);
      _duration = DateTime.now().difference(startTime);
    }

    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (mounted) {
        setState(() {
          _duration = _duration + const Duration(seconds: 1);
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(24),
            boxShadow: [
              BoxShadow(
                color: accentColor.withOpacity(0.15),
                blurRadius: 20,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: Column(
            children: [
              _buildHeader(context),
              _buildContent(context, constraints),
            ],
          ),
        );
      },
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [accentColor, accentColor.withOpacity(0.8)],
        ),
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(24),
          topRight: Radius.circular(24),
        ),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.25),
              borderRadius: BorderRadius.circular(14),
            ),
            child: const Icon(
              Icons.check_circle_rounded,
              color: Colors.white,
              size: 32,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'وردية نشطة',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    Container(
                      width: 8,
                      height: 8,
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      _formatDuration(_duration),
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 8,
                  height: 8,
                  decoration: BoxDecoration(
                    color: accentColor,
                    shape: BoxShape.circle,
                  ),
                ),
                const SizedBox(width: 8),
                Text(
                  'جارية',
                  style: TextStyle(
                    color: accentColor,
                    fontWeight: FontWeight.bold,
                    fontSize: 13,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildContent(BuildContext context, BoxConstraints constraints) {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          _buildUserInfo(),
          const SizedBox(height: 20),
          _buildShiftDetails(constraints),
          const SizedBox(height: 24),
          _buildActionButtons(context, constraints),
        ],
      ),
    );
  }

  Widget _buildUserInfo() {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            primaryColor.withOpacity(0.05),
            primaryColor.withOpacity(0.02),
          ],
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: primaryColor.withOpacity(0.1), width: 1.5),
      ),
      child: Row(
        children: [
          Container(
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(
                color: primaryColor.withOpacity(0.2),
                width: 3,
              ),
            ),
            child: CircleAvatar(
              radius: 32,
              backgroundColor: primaryColor.withOpacity(0.1),
              backgroundImage: widget.data.user?.profileImage != null
                  ? NetworkImage(widget.data.user!.profileImage.toString())
                  : null,
              child: widget.data.user?.profileImage == null
                  ? Text(
                      _getInitials(),
                      style: TextStyle(
                        color: primaryColor,
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                      ),
                    )
                  : null,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '${widget.data.user?.firstName ?? ''} ${widget.data.user?.lastName ?? ''}',
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF1F2937),
                  ),
                ),
                const SizedBox(height: 6),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 5,
                  ),
                  decoration: BoxDecoration(
                    color: primaryColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    widget.data.user?.role ?? 'موظف',
                    style: TextStyle(
                      fontSize: 12,
                      color: primaryColor,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
          ),
          Icon(
            Icons.person_rounded,
            color: primaryColor.withOpacity(0.3),
            size: 28,
          ),
        ],
      ),
    );
  }

  Widget _buildShiftDetails(BoxConstraints constraints) {
    final isSmallScreen = constraints.maxWidth < 400;

    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: _buildDetailCard(
                Icons.access_time_rounded,
                'وقت البداية',
                _formatTime(widget.data.shift?.startTime),
                primaryColor,
              ),
            ),
            SizedBox(width: isSmallScreen ? 8 : 12),
            Expanded(
              child: _buildDetailCard(
                Icons.store_rounded,
                'المتجر',
                '#${widget.data.shift?.storeId ?? 'N/A'}',
                warningColor,
              ),
            ),
          ],
        ),
        SizedBox(height: isSmallScreen ? 8 : 12),
        _buildDetailCard(
          Icons.account_balance_wallet_rounded,
          'الرصيد الافتتاحي',
          '${widget.data.shift?.openingBalance ?? '0'} ر.س',
          accentColor,
          isFullWidth: true,
        ),
      ],
    );
  }

  Widget _buildDetailCard(
    IconData icon,
    String label,
    String value,
    Color color, {
    bool isFullWidth = false,
  }) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: color.withOpacity(0.05),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: color.withOpacity(0.2), width: 1.5),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: color.withOpacity(0.15),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: color, size: 22),
          ),
          const SizedBox(width: 12),
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
                const SizedBox(height: 4),
                Text(
                  value,
                  style: TextStyle(
                    fontSize: isFullWidth ? 18 : 15,
                    fontWeight: FontWeight.bold,
                    color: const Color(0xFF1F2937),
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

  Widget _buildActionButtons(BuildContext context, BoxConstraints constraints) {
    final isSmallScreen = constraints.maxWidth < 400;

    if (isSmallScreen) {
      return Column(
        children: [
          SizedBox(
            width: double.infinity,
            child: _buildViewDetailsButton(context),
          ),
          const SizedBox(height: 10),
          SizedBox(
            width: double.infinity,
            child: _buildCloseShiftButton(context),
          ),
        ],
      );
    }

    return Row(
      children: [
        Expanded(child: _buildViewDetailsButton(context)),
        const SizedBox(width: 12),
        Expanded(child: _buildCloseShiftButton(context)),
      ],
    );
  }

  Widget _buildViewDetailsButton(BuildContext context) {
    return OutlinedButton.icon(
      onPressed: () {
        // Navigate to shift details
      },
      icon: Icon(Icons.visibility_off_outlined, size: 20, color: primaryColor),
      label: Text(
        'التفاصيل',
        style: TextStyle(
          fontSize: 15,
          fontWeight: FontWeight.bold,
          color: primaryColor,
        ),
      ),
      style: OutlinedButton.styleFrom(
        side: BorderSide(color: primaryColor, width: 2),
        padding: const EdgeInsets.symmetric(vertical: 14),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      ),
    );
  }

  Widget _buildCloseShiftButton(BuildContext context) {
    return ElevatedButton.icon(
      onPressed: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => TransactionPage(shift: widget.data.shift!),
          ),
        );
      },
      icon: const Icon(Icons.exit_to_app_rounded, size: 20),
      label: const Text(
        'إغلاق الوردية',
        style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
      ),
      style: ElevatedButton.styleFrom(
        backgroundColor: dangerColor,
        foregroundColor: Colors.white,
        padding: const EdgeInsets.symmetric(vertical: 14),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
        elevation: 2,
        shadowColor: dangerColor.withOpacity(0.3),
      ),
    );
  }

  String _formatTime(String? dateTime) {
    if (dateTime == null) return 'غير محدد';
    try {
      final date = DateTime.parse(dateTime);
      return DateFormat('hh:mm a', 'ar').format(date);
    } catch (e) {
      return '--:--';
    }
  }

  String _formatDuration(Duration duration) {
    final hours = duration.inHours;
    final minutes = duration.inMinutes % 60;
    final seconds = duration.inSeconds % 60;

    if (hours > 0) {
      return '${hours.toString().padLeft(2, '0')}:${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
    }
    return '${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
  }

  String _getInitials() {
    final firstName = widget.data.user?.firstName ?? '';
    final lastName = widget.data.user?.lastName ?? '';
    return '${firstName.isNotEmpty ? firstName[0] : ''}${lastName.isNotEmpty ? lastName[0] : ''}'
        .toUpperCase();
  }
}
