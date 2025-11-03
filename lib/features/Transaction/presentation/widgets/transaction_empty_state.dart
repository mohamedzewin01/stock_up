// // lib/features/Transaction/presentation/widgets/transaction_empty_state.dart
// import 'package:flutter/material.dart';
//
// class TransactionEmptyState extends StatelessWidget {
//   final bool isTablet;
//   final VoidCallback onAddTransaction;
//
//   const TransactionEmptyState({
//     super.key,
//     required this.isTablet,
//     required this.onAddTransaction,
//   });
//
//   @override
//   Widget build(BuildContext context) {
//     return Center(
//       child: Padding(
//         padding: EdgeInsets.all(isTablet ? 40 : 32),
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             _buildIcon(),
//             SizedBox(height: isTablet ? 24 : 20),
//             _buildTitle(),
//             SizedBox(height: isTablet ? 12 : 8),
//             _buildDescription(),
//             SizedBox(height: isTablet ? 32 : 24),
//             _buildAddButton(),
//           ],
//         ),
//       ),
//     );
//   }
//
//   Widget _buildIcon() {
//     return Container(
//       width: isTablet ? 120 : 100,
//       height: isTablet ? 120 : 100,
//       decoration: BoxDecoration(
//         color: const Color(0xFF007AFF).withOpacity(0.1),
//         shape: BoxShape.circle,
//       ),
//       child: Icon(
//         Icons.receipt_long,
//         size: isTablet ? 60 : 50,
//         color: const Color(0xFF007AFF),
//       ),
//     );
//   }
//
//   Widget _buildTitle() {
//     return Text(
//       'لا توجد معاملات بعد',
//       style: TextStyle(
//         fontSize: isTablet ? 24 : 20,
//         fontWeight: FontWeight.bold,
//         color: const Color(0xFF1A1A1A),
//       ),
//     );
//   }
//
//   Widget _buildDescription() {
//     return Text(
//       'ابدأ بإضافة معاملات الوردية\n(نقدية، فيزا، آجل، مصروفات، مرتجع)',
//       style: TextStyle(
//         fontSize: isTablet ? 16 : 14,
//         color: const Color(0xFF666666),
//         height: 1.5,
//       ),
//       textAlign: TextAlign.center,
//     );
//   }
//
//   Widget _buildAddButton() {
//     return ElevatedButton.icon(
//       onPressed: onAddTransaction,
//       icon: const Icon(Icons.add),
//       label: const Text('إضافة معاملة'),
//       style: ElevatedButton.styleFrom(
//         backgroundColor: const Color(0xFF007AFF),
//         foregroundColor: Colors.white,
//         padding: EdgeInsets.symmetric(
//           horizontal: isTablet ? 32 : 24,
//           vertical: isTablet ? 16 : 12,
//         ),
//         shape: RoundedRectangleBorder(
//           borderRadius: BorderRadius.circular(12),
//         ),
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';

class TransactionEmptyState extends StatefulWidget {
  final bool isTablet;
  final VoidCallback onAddTransaction;

  const TransactionEmptyState({
    super.key,
    required this.isTablet,
    required this.onAddTransaction,
  });

  @override
  State<TransactionEmptyState> createState() => _TransactionEmptyStateState();
}

class _TransactionEmptyStateState extends State<TransactionEmptyState>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _floatAnimation;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 2000),
      vsync: this,
    )..repeat(reverse: true);

    _floatAnimation = Tween<double>(
      begin: -10,
      end: 10,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));

    _scaleAnimation = Tween<double>(
      begin: 0.98,
      end: 1.02,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SingleChildScrollView(
        padding: EdgeInsets.all(widget.isTablet ? 40 : 32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _buildAnimatedIcon(),
            SizedBox(height: widget.isTablet ? 32 : 28),
            _buildTitle(),
            SizedBox(height: widget.isTablet ? 16 : 12),
            _buildDescription(),
            SizedBox(height: widget.isTablet ? 40 : 32),
            _buildTransactionTypes(),
            SizedBox(height: widget.isTablet ? 32 : 24),
            _buildAddButton(),
          ],
        ),
      ),
    );
  }

  Widget _buildAnimatedIcon() {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return Transform.translate(
          offset: Offset(0, _floatAnimation.value),
          child: Transform.scale(scale: _scaleAnimation.value, child: child),
        );
      },
      child: Container(
        width: widget.isTablet ? 140 : 120,
        height: widget.isTablet ? 140 : 120,
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Color(0xFF667EEA), Color(0xFF764BA2)],
          ),
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: const Color(0xFF667EEA).withOpacity(0.3),
              blurRadius: 30,
              offset: const Offset(0, 15),
            ),
          ],
        ),
        child: Stack(
          children: [
            // Animated circles inside
            Positioned.fill(
              child: AnimatedBuilder(
                animation: _controller,
                builder: (context, child) {
                  return CustomPaint(
                    painter: _CirclePainter(_controller.value),
                  );
                },
              ),
            ),
            Center(
              child: Icon(
                Icons.receipt_long_rounded,
                size: widget.isTablet ? 70 : 60,
                color: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTitle() {
    return Text(
      'لا توجد معاملات بعد',
      style: TextStyle(
        fontSize: widget.isTablet ? 28 : 24,
        fontWeight: FontWeight.w800,
        color: const Color(0xFF2D3748),
        letterSpacing: -0.5,
      ),
    );
  }

  Widget _buildDescription() {
    return Text(
      'ابدأ بإضافة معاملات الوردية الخاصة بك\nلتتبع جميع العمليات المالية',
      style: TextStyle(
        fontSize: widget.isTablet ? 16 : 14,
        color: const Color(0xFF718096),
        height: 1.6,
        fontWeight: FontWeight.w500,
      ),
      textAlign: TextAlign.center,
    );
  }

  Widget _buildTransactionTypes() {
    final types = [
      {'icon': Icons.money, 'label': 'نقدية', 'color': const Color(0xFF48BB78)},
      {
        'icon': Icons.credit_card,
        'label': 'فيزا',
        'color': const Color(0xFF667EEA),
      },
      {
        'icon': Icons.schedule,
        'label': 'آجل',
        'color': const Color(0xFFFBD38D),
      },
      {
        'icon': Icons.remove_circle,
        'label': 'مصروف',
        'color': const Color(0xFFFC8181),
      },
      {'icon': Icons.undo, 'label': 'مرتجع', 'color': const Color(0xFF9CA3AF)},
    ];

    return Wrap(
      spacing: widget.isTablet ? 16 : 12,
      runSpacing: widget.isTablet ? 16 : 12,
      alignment: WrapAlignment.center,
      children: types.map((type) {
        return TweenAnimationBuilder<double>(
          duration: Duration(milliseconds: 400 + (types.indexOf(type) * 100)),
          tween: Tween(begin: 0.0, end: 1.0),
          curve: Curves.easeOutBack,
          builder: (context, value, child) {
            return Transform.scale(
              scale: value,
              child: Opacity(opacity: value, child: child),
            );
          },
          child: Container(
            padding: EdgeInsets.symmetric(
              horizontal: widget.isTablet ? 16 : 12,
              vertical: widget.isTablet ? 12 : 10,
            ),
            decoration: BoxDecoration(
              color: (type['color'] as Color).withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: (type['color'] as Color).withOpacity(0.3),
              ),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  type['icon'] as IconData,
                  color: type['color'] as Color,
                  size: widget.isTablet ? 20 : 18,
                ),
                const SizedBox(width: 8),
                Text(
                  type['label'] as String,
                  style: TextStyle(
                    fontSize: widget.isTablet ? 13 : 12,
                    fontWeight: FontWeight.w600,
                    color: type['color'] as Color,
                  ),
                ),
              ],
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildAddButton() {
    return TweenAnimationBuilder<double>(
      duration: const Duration(milliseconds: 600),
      tween: Tween(begin: 0.0, end: 1.0),
      curve: Curves.easeOutBack,
      builder: (context, value, child) {
        return Transform.scale(scale: value, child: child);
      },
      child: Container(
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Color(0xFF667EEA), Color(0xFF764BA2)],
          ),
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: const Color(0xFF667EEA).withOpacity(0.4),
              blurRadius: 20,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: widget.onAddTransaction,
            borderRadius: BorderRadius.circular(16),
            child: Padding(
              padding: EdgeInsets.symmetric(
                horizontal: widget.isTablet ? 40 : 32,
                vertical: widget.isTablet ? 18 : 16,
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    padding: const EdgeInsets.all(6),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Icon(
                      Icons.add_rounded,
                      color: Colors.white,
                      size: widget.isTablet ? 24 : 20,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Text(
                    'إضافة معاملة جديدة',
                    style: TextStyle(
                      fontSize: widget.isTablet ? 16 : 15,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      letterSpacing: 0.2,
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
}

// Custom painter for animated circles
class _CirclePainter extends CustomPainter {
  final double animationValue;

  _CirclePainter(this.animationValue);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white.withOpacity(0.1)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;

    final center = Offset(size.width / 2, size.height / 2);
    final maxRadius = size.width / 2;

    // Draw multiple animated circles
    for (int i = 0; i < 3; i++) {
      final radius = maxRadius * ((animationValue + i / 3) % 1);
      final opacity = 1 - ((animationValue + i / 3) % 1);
      paint.color = Colors.white.withOpacity(opacity * 0.3);
      canvas.drawCircle(center, radius, paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
