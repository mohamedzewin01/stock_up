// // lib/features/Transaction/presentation/widgets/transaction_card.dart
// import 'package:flutter/material.dart';
// import 'transaction_types.dart';
//
// class TransactionCard extends StatelessWidget {
//   final TransactionItem transaction;
//   final int index;
//   final bool isTablet;
//   final VoidCallback onEdit;
//   final VoidCallback onRemove;
//
//   const TransactionCard({
//     super.key,
//     required this.transaction,
//     required this.index,
//     required this.isTablet,
//     required this.onEdit,
//     required this.onRemove,
//   });
//
//   @override
//   Widget build(BuildContext context) {
//     final isPositive = transaction.type.isPositive;
//     final color = transaction.type.color;
//
//     return Dismissible(
//       key: Key('transaction_$index'),
//       direction: DismissDirection.endToStart,
//       background: _buildDismissBackground(),
//       onDismissed: (direction) => onRemove(),
//       child: Container(
//         padding: EdgeInsets.all(isTablet ? 20 : 16),
//         decoration: BoxDecoration(
//           color: Colors.white,
//           borderRadius: BorderRadius.circular(16),
//           border: Border.all(
//             color: color.withOpacity(0.2),
//             width: 1.5,
//           ),
//           boxShadow: [
//             BoxShadow(
//               color: color.withOpacity(0.1),
//               blurRadius: 10,
//               offset: const Offset(0, 2),
//             ),
//           ],
//         ),
//         child: Row(
//           children: [
//             _buildTypeIcon(color),
//             const SizedBox(width: 16),
//             _buildTransactionDetails(),
//             _buildAmountSection(isPositive, color),
//             const SizedBox(width: 8),
//             _buildEditButton(),
//           ],
//         ),
//       ),
//     );
//   }
//
//   Widget _buildDismissBackground() {
//     return Container(
//       decoration: BoxDecoration(
//         color: const Color(0xFFFF3B30),
//         borderRadius: BorderRadius.circular(16),
//       ),
//       alignment: Alignment.centerLeft,
//       padding: const EdgeInsets.symmetric(horizontal: 20),
//       child: const Icon(
//         Icons.delete,
//         color: Colors.white,
//         size: 24,
//       ),
//     );
//   }
//
//   Widget _buildTypeIcon(Color color) {
//     return Container(
//       width: isTablet ? 56 : 48,
//       height: isTablet ? 56 : 48,
//       decoration: BoxDecoration(
//         color: color.withOpacity(0.1),
//         borderRadius: BorderRadius.circular(14),
//       ),
//       child: Icon(
//         transaction.type.icon,
//         color: color,
//         size: isTablet ? 28 : 24,
//       ),
//     );
//   }
//
//   Widget _buildTransactionDetails() {
//     return Expanded(
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Text(
//             transaction.description,
//             style: TextStyle(
//               fontSize: isTablet ? 16 : 14,
//               fontWeight: FontWeight.w600,
//               color: const Color(0xFF1A1A1A),
//             ),
//             maxLines: 2,
//             overflow: TextOverflow.ellipsis,
//           ),
//           const SizedBox(height: 4),
//           Row(
//             children: [
//               Container(
//                 padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
//                 decoration: BoxDecoration(
//                   color: transaction.type.color.withOpacity(0.1),
//                   borderRadius: BorderRadius.circular(8),
//                 ),
//                 child: Text(
//                   transaction.type.displayName,
//                   style: TextStyle(
//                     fontSize: isTablet ? 10 : 8,
//                     fontWeight: FontWeight.w600,
//                     color: transaction.type.color,
//                   ),
//                 ),
//               ),
//               const SizedBox(width: 8),
//               Icon(
//                 Icons.access_time,
//                 size: isTablet ? 14 : 12,
//                 color: const Color(0xFF666666),
//               ),
//               const SizedBox(width: 4),
//               Text(
//                 TransactionUtils.formatTime(transaction.timestamp),
//                 style: TextStyle(
//                   fontSize: isTablet ? 12 : 10,
//                   color: const Color(0xFF666666),
//                 ),
//               ),
//             ],
//           ),
//         ],
//       ),
//     );
//   }
//
//   Widget _buildAmountSection(bool isPositive, Color color) {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.end,
//       children: [
//         Text(
//           '${isPositive ? '+' : '-'}${transaction.amount.toStringAsFixed(2)}',
//           style: TextStyle(
//             fontSize: isTablet ? 18 : 16,
//             fontWeight: FontWeight.bold,
//             color: color,
//           ),
//         ),
//         Text(
//           'ريال سعودي',
//           style: TextStyle(
//             fontSize: isTablet ? 10 : 8,
//             color: const Color(0xFF666666),
//           ),
//         ),
//       ],
//     );
//   }
//
//   Widget _buildEditButton() {
//     return GestureDetector(
//       onTap: onEdit,
//       child: Container(
//         padding: const EdgeInsets.all(8),
//         decoration: BoxDecoration(
//           color: const Color(0xFFF8F9FA),
//           borderRadius: BorderRadius.circular(8),
//         ),
//         child: Icon(
//           Icons.edit,
//           size: isTablet ? 18 : 16,
//           color: const Color(0xFF666666),
//         ),
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';

import 'transaction_types.dart';

class TransactionCard extends StatefulWidget {
  final TransactionItem transaction;
  final int index;
  final bool isTablet;
  final VoidCallback onEdit;
  final VoidCallback onRemove;

  const TransactionCard({
    super.key,
    required this.transaction,
    required this.index,
    required this.isTablet,
    required this.onEdit,
    required this.onRemove,
  });

  @override
  State<TransactionCard> createState() => _TransactionCardState();
}

class _TransactionCardState extends State<TransactionCard>
    with SingleTickerProviderStateMixin {
  bool _isPressed = false;

  @override
  Widget build(BuildContext context) {
    final isPositive = widget.transaction.type.isPositive;
    final color = widget.transaction.type.color;

    return GestureDetector(
      onTapDown: (_) => setState(() => _isPressed = true),
      onTapUp: (_) => setState(() => _isPressed = false),
      onTapCancel: () => setState(() => _isPressed = false),
      child: AnimatedScale(
        scale: _isPressed ? 0.98 : 1.0,
        duration: const Duration(milliseconds: 100),
        child: Dismissible(
          key: Key('transaction_${widget.index}'),
          direction: DismissDirection.endToStart,
          background: _buildDismissBackground(),
          confirmDismiss: (direction) async {
            return await _showDeleteConfirmation(context);
          },
          onDismissed: (direction) => widget.onRemove(),
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: color.withOpacity(0.15),
                  blurRadius: 15,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: Stack(
                children: [
                  // Gradient accent on the side
                  Positioned(
                    right: 0,
                    top: 0,
                    bottom: 0,
                    child: Container(
                      width: 5,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [color, color.withOpacity(0.6)],
                        ),
                      ),
                    ),
                  ),

                  Padding(
                    padding: EdgeInsets.all(widget.isTablet ? 20 : 16),
                    child: Row(
                      children: [
                        _buildTypeIcon(color),
                        const SizedBox(width: 16),
                        _buildTransactionDetails(),
                        const SizedBox(width: 12),
                        _buildAmountSection(isPositive, color),
                        const SizedBox(width: 8),
                        _buildEditButton(),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildDismissBackground() {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFFFC8181), Color(0xFFF56565)],
        ),
        borderRadius: BorderRadius.circular(20),
      ),
      alignment: Alignment.centerLeft,
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.2),
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(
              Icons.delete_outline,
              color: Colors.white,
              size: 28,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'اسحب للحذف',
            style: TextStyle(
              color: Colors.white,
              fontSize: 12,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTypeIcon(Color color) {
    return Container(
      width: widget.isTablet ? 60 : 52,
      height: widget.isTablet ? 60 : 52,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [color.withOpacity(0.15), color.withOpacity(0.05)],
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: color.withOpacity(0.2), width: 1.5),
      ),
      child: Center(
        child: Icon(
          widget.transaction.type.icon,
          color: color,
          size: widget.isTablet ? 28 : 24,
        ),
      ),
    );
  }

  Widget _buildTransactionDetails() {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            widget.transaction.description,
            style: TextStyle(
              fontSize: widget.isTablet ? 16 : 15,
              fontWeight: FontWeight.w700,
              color: const Color(0xFF2D3748),
              letterSpacing: -0.2,
            ),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 6),
          Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 4,
                ),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      widget.transaction.type.color.withOpacity(0.15),
                      widget.transaction.type.color.withOpacity(0.05),
                    ],
                  ),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    color: widget.transaction.type.color.withOpacity(0.2),
                  ),
                ),
                child: Text(
                  widget.transaction.type.displayName,
                  style: TextStyle(
                    fontSize: widget.isTablet ? 11 : 10,
                    fontWeight: FontWeight.w700,
                    color: widget.transaction.type.color,
                    letterSpacing: 0.2,
                  ),
                ),
              ),
              const SizedBox(width: 10),
              Container(
                padding: const EdgeInsets.all(4),
                decoration: BoxDecoration(
                  color: const Color(0xFFF7FAFC),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Icon(
                  Icons.access_time_rounded,
                  size: widget.isTablet ? 14 : 12,
                  color: const Color(0xFF718096),
                ),
              ),
              const SizedBox(width: 4),
              Text(
                TransactionUtils.formatTime(widget.transaction.timestamp),
                style: TextStyle(
                  fontSize: widget.isTablet ? 12 : 11,
                  color: const Color(0xFF718096),
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildAmountSection(bool isPositive, Color color) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: widget.isTablet ? 16 : 12,
        vertical: widget.isTablet ? 12 : 10,
      ),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [color.withOpacity(0.1), color.withOpacity(0.05)],
        ),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: color.withOpacity(0.2), width: 1.5),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                isPositive
                    ? Icons.arrow_upward_rounded
                    : Icons.arrow_downward_rounded,
                color: color,
                size: widget.isTablet ? 18 : 16,
              ),
              const SizedBox(width: 4),
              Text(
                widget.transaction.amount.toStringAsFixed(2),
                style: TextStyle(
                  fontSize: widget.isTablet ? 20 : 18,
                  fontWeight: FontWeight.w800,
                  color: color,
                  letterSpacing: -0.5,
                ),
              ),
            ],
          ),
          const SizedBox(height: 2),
          Text(
            'ريال',
            style: TextStyle(
              fontSize: widget.isTablet ? 11 : 10,
              color: color.withOpacity(0.7),
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEditButton() {
    return GestureDetector(
      onTap: widget.onEdit,
      child: Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: const Color(0xFFF7FAFC),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: const Color(0xFFE2E8F0)),
        ),
        child: Icon(
          Icons.edit_outlined,
          size: widget.isTablet ? 20 : 18,
          color: const Color(0xFF718096),
        ),
      ),
    );
  }

  Future<bool?> _showDeleteConfirmation(BuildContext context) {
    return showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: const Color(0xFFFC8181).withOpacity(0.1),
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Icon(
                Icons.warning_rounded,
                color: Color(0xFFFC8181),
                size: 24,
              ),
            ),
            const SizedBox(width: 12),
            const Text(
              'تأكيد الحذف',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ],
        ),
        content: const Text(
          'هل أنت متأكد من حذف هذه المعاملة؟',
          style: TextStyle(fontSize: 15),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('إلغاء'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, true),
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFFC8181),
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            child: const Text('حذف'),
          ),
        ],
      ),
    );
  }
}
