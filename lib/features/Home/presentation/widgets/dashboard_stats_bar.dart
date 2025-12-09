// import 'package:flutter/material.dart';
// import 'package:stock_up/core/resources/style_manager.dart';
//
// class DashboardStatsBar extends StatelessWidget {
//   const DashboardStatsBar({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       height: 105,
//       margin: const EdgeInsets.symmetric(horizontal: 0),
//       child: ListView(
//         scrollDirection: Axis.horizontal,
//         shrinkWrap: true,
//         children: [
//           _buildStatCard(
//             icon: Icons.inventory_2_rounded,
//             title: 'المنتجات',
//             value: '1,234',
//             color: const Color(0xFF6366F1),
//             delay: 0,
//           ),
//           _buildStatCard(
//             icon: Icons.trending_up_rounded,
//             title: 'المبيعات اليوم',
//             value: '45',
//             color: const Color(0xFF10B981),
//             delay: 0,
//           ),
//           _buildStatCard(
//             icon: Icons.people_rounded,
//             title: 'العملاء',
//             value: '892',
//             color: const Color(0xFFF59E0B),
//             delay: 0,
//           ),
//           _buildStatCard(
//             icon: Icons.paid_rounded,
//             title: 'الإيرادات',
//             value: '12.5K',
//             color: const Color(0xFFEC4899),
//             delay: 0,
//           ),
//         ],
//       ),
//     );
//   }
//
//   Widget _buildStatCard({
//     required IconData icon,
//     required String title,
//     required String value,
//     required Color color,
//     required int delay,
//   }) {
//     return Container(
//       width: 90,
//       margin: const EdgeInsets.only(left: 8),
//       padding: const EdgeInsets.all(8),
//       decoration: BoxDecoration(
//         color: const Color(0xFF1E293B),
//         borderRadius: BorderRadius.circular(16),
//         border: Border.all(color: color.withOpacity(0.3), width: 1),
//       ),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//         children: [
//           Container(
//             padding: const EdgeInsets.all(8),
//             decoration: BoxDecoration(
//               color: color.withOpacity(0.15),
//               borderRadius: BorderRadius.circular(10),
//             ),
//             child: Icon(icon, size: 20, color: color),
//           ),
//           Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               Text(
//                 value,
//                 style: getBoldStyle(color: Colors.white, fontSize: 18),
//               ),
//               const SizedBox(height: 2),
//               Text(
//                 title,
//                 style: getRegularStyle(
//                   color: Colors.white.withOpacity(0.6),
//                   fontSize: 11,
//                 ),
//               ),
//             ],
//           ),
//         ],
//       ),
//     );
//   }
// }
///
// import 'package:flutter/material.dart';
// import 'package:intl/intl.dart';
// import 'package:stock_up/core/resources/style_manager.dart';
// import 'package:stock_up/features/Summary/domain/entities/summary_entities.dart';
//
// class DashboardStatsBar extends StatelessWidget {
//   final SummaryEntity? summaryEntity;
//   final bool isLoading;
//   final bool hasError;
//
//   const DashboardStatsBar({
//     super.key,
//     this.summaryEntity,
//     this.isLoading = false,
//     this.hasError = false,
//   });
//
//   @override
//   Widget build(BuildContext context) {
//     if (hasError) {
//       return _buildErrorState();
//     }
//
//     if (isLoading) {
//       return _buildLoadingState();
//     }
//
//     final summary = summaryEntity?.summary;
//     final productsCount = summary?.productsCount ?? 0;
//     final treasuryBalance = summary?.treasury?.finalBalance ?? '0';
//     final bankBalance = summary?.bank?.finalBalance ?? '0';
//
//     // حساب إجمالي الداخل والخارج ديناميكياً من جميع الـ movements
//     double totalIncoming = 0;
//     double totalOutgoing = 0;
//
//     // حساب من الخزينة
//     if (summary?.treasury?.movements != null) {
//       for (var movement in summary!.treasury!.movements!) {
//         final incoming = double.tryParse(movement.totalIncoming ?? '0') ?? 0;
//         final outgoing = double.tryParse(movement.totalOutgoing ?? '0') ?? 0;
//
//         totalIncoming += incoming;
//         totalOutgoing += outgoing;
//       }
//     }
//
//     // حساب صافي الحركة
//     double netMovement = totalIncoming - totalOutgoing;
//
//     return Container(
//       height: 120,
//       margin: const EdgeInsets.symmetric(horizontal: 0),
//       child: ListView(
//         scrollDirection: Axis.horizontal,
//         padding: const EdgeInsets.symmetric(horizontal: 20),
//         children: [
//           _buildStatCard(
//             icon: Icons.inventory_2_rounded,
//             title: 'المنتجات',
//             value: _formatNumber(productsCount),
//             color: const Color(0xFF6366F1),
//             delay: 0,
//           ),
//           _buildStatCard(
//             icon: Icons.arrow_circle_down_rounded,
//             title: 'إجمالي الداخل',
//             value: _formatCurrency(totalIncoming),
//             color: const Color(0xFF10B981),
//             delay: 50,
//           ),
//           _buildStatCard(
//             icon: Icons.arrow_circle_up_rounded,
//             title: 'إجمالي الخارج',
//             value: _formatCurrency(totalOutgoing),
//             color: const Color(0xFFEF4444),
//             delay: 100,
//           ),
//           _buildStatCard(
//             icon: Icons.account_balance_wallet_rounded,
//             title: 'رصيد الخزينة',
//             value: _formatCurrency(double.tryParse(treasuryBalance) ?? 0),
//             color: const Color(0xFFF59E0B),
//             delay: 150,
//           ),
//           _buildStatCard(
//             icon: Icons.account_balance_rounded,
//             title: 'رصيد البنك',
//             value: _formatCurrency(double.tryParse(bankBalance) ?? 0),
//             color: const Color(0xFFEC4899),
//             delay: 200,
//           ),
//         ],
//       ),
//     );
//   }
//
//   Widget _buildStatCard({
//     required IconData icon,
//     required String title,
//     required String value,
//     required Color color,
//     required int delay,
//   }) {
//     return TweenAnimationBuilder<double>(
//       tween: Tween(begin: 0.0, end: 1.0),
//       duration: Duration(milliseconds: 600 + delay),
//       curve: Curves.easeOut,
//       builder: (context, animValue, child) {
//         return Opacity(
//           opacity: animValue,
//           child: Transform.translate(
//             offset: Offset(0, 20 * (1 - animValue)),
//             child: child,
//           ),
//         );
//       },
//       child: Container(
//         // width: 100,
//         margin: const EdgeInsets.only(left: 12),
//         padding: const EdgeInsets.all(16),
//         decoration: BoxDecoration(
//           color: const Color(0xFF1E293B),
//           borderRadius: BorderRadius.circular(16),
//           border: Border.all(color: color.withOpacity(0.3), width: 1),
//           boxShadow: [
//             BoxShadow(
//               color: color.withOpacity(0.15),
//               blurRadius: 10,
//               offset: const Offset(0, 4),
//             ),
//           ],
//         ),
//         child: SingleChildScrollView(
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//             children: [
//               Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                 children: [
//                   Container(
//                     padding: const EdgeInsets.all(8),
//                     decoration: BoxDecoration(
//                       color: color.withOpacity(0.15),
//                       borderRadius: BorderRadius.circular(10),
//                     ),
//                     child: Icon(icon, size: 20, color: color),
//                   ),
//                 ],
//               ),
//               Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Text(
//                     value,
//                     style: getBoldStyle(color: Colors.white, fontSize: 18),
//                     maxLines: 1,
//                     overflow: TextOverflow.ellipsis,
//                   ),
//                   const SizedBox(height: 4),
//                   Text(
//                     title,
//                     style: getRegularStyle(
//                       color: Colors.white.withOpacity(0.6),
//                       fontSize: 12,
//                     ),
//                   ),
//                 ],
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
//
//   Widget _buildLoadingState() {
//     return Container(
//       height: 105,
//       margin: const EdgeInsets.symmetric(horizontal: 0),
//       child: ListView(
//         scrollDirection: Axis.horizontal,
//         padding: const EdgeInsets.symmetric(horizontal: 20),
//         children: List.generate(
//           4,
//           (index) => Container(
//             width: 140,
//             margin: const EdgeInsets.only(left: 12),
//             decoration: BoxDecoration(
//               color: const Color(0xFF1E293B),
//               borderRadius: BorderRadius.circular(16),
//               border: Border.all(
//                 color: Colors.white.withOpacity(0.1),
//                 width: 1,
//               ),
//             ),
//             child: Center(
//               child: SizedBox(
//                 width: 24,
//                 height: 24,
//                 child: CircularProgressIndicator(
//                   strokeWidth: 2,
//                   valueColor: AlwaysStoppedAnimation<Color>(
//                     const Color(0xFF6366F1).withOpacity(0.5),
//                   ),
//                 ),
//               ),
//             ),
//           ),
//         ),
//       ),
//     );
//   }
//
//   Widget _buildErrorState() {
//     return Container(
//       height: 105,
//       margin: const EdgeInsets.symmetric(horizontal: 20),
//       padding: const EdgeInsets.all(16),
//       decoration: BoxDecoration(
//         color: const Color(0xFF1E293B),
//         borderRadius: BorderRadius.circular(16),
//         border: Border.all(
//           color: const Color(0xFFEF4444).withOpacity(0.3),
//           width: 1,
//         ),
//       ),
//       child: Row(
//         mainAxisAlignment: MainAxisAlignment.center,
//         children: [
//           Icon(
//             Icons.error_outline_rounded,
//             color: const Color(0xFFEF4444).withOpacity(0.8),
//             size: 20,
//           ),
//           const SizedBox(width: 12),
//           Text(
//             'فشل تحميل الإحصائيات',
//             style: getMediumStyle(
//               color: Colors.white.withOpacity(0.7),
//               fontSize: 14,
//             ),
//           ),
//         ],
//       ),
//     );
//   }
//
//   String _formatNumber(int number) {
//     if (number >= 1000000) {
//       return '${(number / 1000000).toStringAsFixed(1)}M';
//     } else if (number >= 1000) {
//       return '${(number / 1000).toStringAsFixed(1)}K';
//     }
//     return number.toString();
//   }
//
//   String _formatCurrency(double amount) {
//     if (amount >= 1000000) {
//       return '${(amount / 1000000).toStringAsFixed(1)}M';
//     } else if (amount >= 1000) {
//       return '${(amount / 1000).toStringAsFixed(1)}K';
//     } else if (amount == 0) {
//       return '0';
//     }
//     return NumberFormat('#,##0', 'ar').format(amount);
//   }
// }
///
// import 'package:flutter/material.dart';
// import 'package:stock_up/core/resources/style_manager.dart';
// import 'package:stock_up/features/Summary/domain/entities/summary_entities.dart';
//
// class DashboardStatsBar extends StatelessWidget {
//   final SummaryEntity? summaryEntity;
//   final bool isLoading;
//   final bool hasError;
//
//   const DashboardStatsBar({
//     super.key,
//     this.summaryEntity,
//     this.isLoading = false,
//     this.hasError = false,
//   });
//
//   @override
//   Widget build(BuildContext context) {
//     if (hasError) {
//       return _buildErrorState();
//     }
//
//     if (isLoading) {
//       return _buildLoadingState();
//     }
//
//     final summary = summaryEntity?.summary;
//     final productsCount = summary?.productsCount ?? 0;
//     final treasuryBalance = summary?.treasury?.finalBalance ?? '0';
//     final bankBalance = summary?.bank?.finalBalance ?? '0';
//
//     // بناء قائمة الكروت ديناميكياً
//     List<Widget> statCards = [];
//     int delayCounter = 0;
//
//     // كرت المنتجات (ثابت)
//     statCards.add(
//       _buildStatCard(
//         icon: Icons.inventory_2_rounded,
//         title: 'المنتجات',
//         value: "$productsCount",
//         color: const Color(0xFF6366F1),
//         delay: delayCounter++ * 50,
//       ),
//     );
//
//     // كروت الـ movements ديناميكياً
//     if (summary?.treasury?.movements != null) {
//       for (var movement in summary!.treasury!.movements!) {
//         final movementType = movement.movementType ?? '';
//         final incoming = double.tryParse(movement.totalIncoming ?? '0') ?? 0;
//         final outgoing = double.tryParse(movement.totalOutgoing ?? '0') ?? 0;
//
//         // تحديد القيمة واللون والأيقونة بناءً على النوع
//         double value = incoming > 0 ? incoming : outgoing;
//         Color color;
//         IconData icon;
//
//         if (incoming > 0) {
//           // حركة داخلة
//           color = const Color(0xFF10B981);
//           icon = Icons.arrow_circle_down_rounded;
//         } else {
//           // حركة خارجة
//           color = const Color(0xFFEF4444);
//           icon = Icons.arrow_circle_up_rounded;
//         }
//
//         statCards.add(
//           _buildStatCard(
//             icon: icon,
//             title: movementType,
//             value: "$value",
//             color: color,
//             delay: delayCounter++ * 50,
//           ),
//         );
//       }
//     }
//
//     // كرت رصيد الخزينة
//     statCards.add(
//       _buildStatCard(
//         icon: Icons.account_balance_wallet_rounded,
//         title: 'رصيد الخزينة',
//         value: treasuryBalance,
//         color: const Color(0xFFF59E0B),
//         delay: delayCounter++ * 50,
//       ),
//     );
//
//     // كرت رصيد البنك
//     statCards.add(
//       _buildStatCard(
//         icon: Icons.account_balance_rounded,
//         title: 'رصيد البنك',
//         value: bankBalance,
//         color: const Color(0xFFEC4899),
//         delay: delayCounter++ * 50,
//       ),
//     );
//
//     return Container(
//       height: 120,
//       margin: const EdgeInsets.symmetric(horizontal: 0),
//       child: ListView(
//         scrollDirection: Axis.horizontal,
//         padding: const EdgeInsets.symmetric(horizontal: 20),
//         children: statCards,
//       ),
//     );
//   }
//
//   Widget _buildStatCard({
//     required IconData icon,
//     required String title,
//     required String value,
//     required Color color,
//     required int delay,
//   }) {
//     return TweenAnimationBuilder<double>(
//       tween: Tween(begin: 0.0, end: 1.0),
//       duration: Duration(milliseconds: 600 + delay),
//       curve: Curves.easeOut,
//       builder: (context, animValue, child) {
//         return Opacity(
//           opacity: animValue,
//           child: Transform.translate(
//             offset: Offset(0, 20 * (1 - animValue)),
//             child: child,
//           ),
//         );
//       },
//       child: Container(
//         // width: 140,
//         margin: const EdgeInsets.only(left: 12),
//         padding: const EdgeInsets.all(16),
//         decoration: BoxDecoration(
//           color: const Color(0xFF1E293B),
//           borderRadius: BorderRadius.circular(16),
//           border: Border.all(color: color.withOpacity(0.3), width: 1),
//           boxShadow: [
//             BoxShadow(
//               color: color.withOpacity(0.15),
//               blurRadius: 10,
//               offset: const Offset(0, 4),
//             ),
//           ],
//         ),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           mainAxisAlignment: MainAxisAlignment.spaceBetween,
//           children: [
//             Row(
//               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//               children: [
//                 Container(
//                   padding: const EdgeInsets.all(8),
//                   decoration: BoxDecoration(
//                     color: color.withOpacity(0.15),
//                     borderRadius: BorderRadius.circular(10),
//                   ),
//                   child: Icon(icon, size: 20, color: color),
//                 ),
//               ],
//             ),
//             Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Text(
//                   value,
//                   style: getBoldStyle(color: Colors.white, fontSize: 18),
//                   maxLines: 1,
//                   overflow: TextOverflow.ellipsis,
//                 ),
//                 const SizedBox(height: 4),
//                 Text(
//                   title,
//                   style: getRegularStyle(
//                     color: Colors.white.withOpacity(0.6),
//                     fontSize: 12,
//                   ),
//                 ),
//               ],
//             ),
//           ],
//         ),
//       ),
//     );
//   }
//
//   Widget _buildLoadingState() {
//     return Container(
//       // height: 120,
//       margin: const EdgeInsets.symmetric(horizontal: 0),
//       child: ListView(
//         scrollDirection: Axis.horizontal,
//         padding: const EdgeInsets.symmetric(horizontal: 20),
//         children: List.generate(
//           4,
//           (index) => Container(
//             width: 140,
//             margin: const EdgeInsets.only(left: 12),
//             decoration: BoxDecoration(
//               color: const Color(0xFF1E293B),
//               borderRadius: BorderRadius.circular(16),
//               border: Border.all(
//                 color: Colors.white.withOpacity(0.1),
//                 width: 1,
//               ),
//             ),
//             child: Center(
//               child: SizedBox(
//                 width: 24,
//                 height: 24,
//                 child: CircularProgressIndicator(
//                   strokeWidth: 2,
//                   valueColor: AlwaysStoppedAnimation<Color>(
//                     const Color(0xFF6366F1).withOpacity(0.5),
//                   ),
//                 ),
//               ),
//             ),
//           ),
//         ),
//       ),
//     );
//   }
//
//   Widget _buildErrorState() {
//     return Container(
//       height: 140,
//
//       margin: const EdgeInsets.symmetric(horizontal: 20),
//       padding: const EdgeInsets.all(16),
//       decoration: BoxDecoration(
//         color: const Color(0xFF1E293B),
//         borderRadius: BorderRadius.circular(16),
//         border: Border.all(
//           color: const Color(0xFFEF4444).withOpacity(0.3),
//           width: 1,
//         ),
//       ),
//       child: Row(
//         mainAxisAlignment: MainAxisAlignment.center,
//         children: [
//           Icon(
//             Icons.error_outline_rounded,
//             color: const Color(0xFFEF4444).withOpacity(0.8),
//             size: 20,
//           ),
//           const SizedBox(width: 12),
//           Text(
//             'فشل تحميل الإحصائيات',
//             style: getMediumStyle(
//               color: Colors.white.withOpacity(0.7),
//               fontSize: 14,
//             ),
//           ),
//         ],
//       ),
//     );
//   }
//
//   // String _formatNumber(int number) {
//   //   if (number >= 1000000) {
//   //     return '${(number / 1000000).toStringAsFixed(1)}M';
//   //   } else if (number >= 1000) {
//   //     return '${(number / 1000).toStringAsFixed(1)}K';
//   //   }
//   //   return number.toString();
//   // }
//   //
//   // String _formatCurrency(double amount) {
//   //   if (amount >= 1000000) {
//   //     return '${(amount / 1000000).toStringAsFixed(1)}M';
//   //   } else if (amount >= 1000) {
//   //     return '${(amount / 1000).toStringAsFixed(1)}K';
//   //   } else if (amount == 0) {
//   //     return '0';
//   //   }
//   //   return NumberFormat('#,##0', 'ar').format(amount);
//   // }
// }
///
import 'package:flutter/material.dart';
import 'package:stock_up/core/resources/style_manager.dart';
import 'package:stock_up/features/Summary/domain/entities/summary_entities.dart';

class DashboardStatsBar extends StatelessWidget {
  final SummaryEntity? summaryEntity;
  final bool isLoading;
  final bool hasError;

  const DashboardStatsBar({
    super.key,
    this.summaryEntity,
    this.isLoading = false,
    this.hasError = false,
  });

  @override
  Widget build(BuildContext context) {
    if (hasError) {
      return _buildErrorState();
    }

    if (isLoading) {
      return _buildLoadingState();
    }

    final summary = summaryEntity?.summary;
    final productsCount = summary?.productsCount ?? 0;
    final treasuryBalance = summary?.treasury?.finalBalance ?? '0';
    final bankBalance = summary?.bank?.finalBalance ?? '0';

    // بناء قائمة الكروت ديناميكياً
    List<Widget> statCards = [];
    int delayCounter = 0;
    statCards.add(
      _buildStatCard(
        icon: Icons.account_balance_wallet_rounded,
        title: 'رصيد الخزينة',
        value: treasuryBalance,
        color: const Color(0xFFF59E0B),
        delay: delayCounter++ * 50,
      ),
    );

    // كرت رصيد البنك
    statCards.add(
      _buildStatCard(
        icon: Icons.account_balance_rounded,
        title: 'رصيد البنك',
        value: bankBalance,
        color: const Color(0xFFEC4899),
        delay: delayCounter++ * 50,
      ),
    );

    // كرت المنتجات (ثابت)
    statCards.add(
      _buildStatCard(
        icon: Icons.inventory_2_rounded,
        title: 'المنتجات',
        value: "$productsCount",
        color: const Color(0xFF6366F1),
        delay: delayCounter++ * 50,
      ),
    );

    // كروت الـ movements ديناميكياً
    if (summary?.treasury?.movements != null) {
      for (var movement in summary!.treasury!.movements!) {
        final movementType = movement.movementType ?? '';
        final incoming = double.tryParse(movement.totalIncoming ?? '0') ?? 0;
        final outgoing = double.tryParse(movement.totalOutgoing ?? '0') ?? 0;

        // تحديد القيمة واللون والأيقونة بناءً على النوع
        double value = incoming > 0 ? incoming : outgoing;
        Color color;
        IconData icon;

        if (incoming > 0) {
          // حركة داخلة
          color = const Color(0xFF10B981);
          icon = Icons.arrow_circle_down_rounded;
        } else {
          // حركة خارجة
          color = const Color(0xFFEF4444);
          icon = Icons.arrow_circle_up_rounded;
        }

        statCards.add(
          _buildStatCard(
            icon: icon,
            title: movementType,
            value: "$value",
            color: color,
            delay: delayCounter++ * 50,
          ),
        );
      }
    }

    // كرت رصيد الخزينة

    return Container(
      height: 120,
      margin: const EdgeInsets.symmetric(horizontal: 0),
      child: ListView(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 20),
        children: statCards,
      ),
    );
  }

  Widget _buildStatCard({
    required IconData icon,
    required String title,
    required String value,
    required Color color,
    required int delay,
  }) {
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0.0, end: 1.0),
      duration: Duration(milliseconds: 600 + delay),
      curve: Curves.easeOut,
      builder: (context, animValue, child) {
        return Opacity(
          opacity: animValue,
          child: Transform.translate(
            offset: Offset(0, 20 * (1 - animValue)),
            child: child,
          ),
        );
      },
      child: Container(
        margin: const EdgeInsets.only(left: 12),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: const Color(0xFF1E293B),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: color.withOpacity(0.3), width: 1),
          boxShadow: [
            BoxShadow(
              color: color.withOpacity(0.15),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: color.withOpacity(0.15),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Icon(icon, size: 20, color: color),
                ),
              ],
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  value,
                  style: getBoldStyle(color: Colors.white, fontSize: 18),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 4),
                Text(
                  title,
                  style: getRegularStyle(
                    color: Colors.white.withOpacity(0.6),
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLoadingState() {
    return Container(
      height: 120,
      margin: const EdgeInsets.symmetric(horizontal: 0),
      child: ListView(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 20),
        children: List.generate(
          4,
              (index) =>
              Container(
                width: 140,
                margin: const EdgeInsets.only(left: 12),
                decoration: BoxDecoration(
                  color: const Color(0xFF1E293B),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: Colors.white.withOpacity(0.1),
                    width: 1,
                  ),
                ),
                child: Center(
                  child: SizedBox(
                    width: 24,
                    height: 24,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      valueColor: AlwaysStoppedAnimation<Color>(
                        const Color(0xFF6366F1).withOpacity(0.5),
                      ),
                    ),
                  ),
                ),
              ),
        ),
      ),
    );
  }

  Widget _buildErrorState() {
    return Container(
      height: 120,
      margin: const EdgeInsets.symmetric(horizontal: 20),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF1E293B),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: const Color(0xFFEF4444).withOpacity(0.3),
          width: 1,
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.error_outline_rounded,
            color: const Color(0xFFEF4444).withOpacity(0.8),
            size: 20,
          ),
          const SizedBox(width: 12),
          Text(
            'فشل تحميل الإحصائيات',
            style: getMediumStyle(
              color: Colors.white.withOpacity(0.7),
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }
}
