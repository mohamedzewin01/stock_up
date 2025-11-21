// lib/features/DateScanner/presentation/widgets/scan_frame_widget.dart

import 'package:flutter/material.dart';

class ScanFrameWidget extends StatefulWidget {
  const ScanFrameWidget({super.key});

  @override
  State<ScanFrameWidget> createState() => _ScanFrameWidgetState();
}

class _ScanFrameWidgetState extends State<ScanFrameWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    )..repeat(reverse: true);

    _animation = Tween<double>(begin: 0, end: 1).animate(_animationController);
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final frameWidth = size.width * 0.85;
    final frameHeight = size.height * 0.3;

    return Center(
      child: Stack(
        children: [
          // إطار المسح
          Container(
            width: frameWidth,
            height: frameHeight,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: const Color(0xFF6C63FF), width: 3),
              boxShadow: [
                BoxShadow(
                  color: const Color(0xFF6C63FF).withOpacity(0.5),
                  blurRadius: 20,
                  spreadRadius: 2,
                ),
              ],
            ),
            child: Stack(
              children: [
                // زوايا مزخرفة
                _buildCorner(Alignment.topLeft),
                _buildCorner(Alignment.topRight),
                _buildCorner(Alignment.bottomLeft),
                _buildCorner(Alignment.bottomRight),

                // خط المسح المتحرك
                AnimatedBuilder(
                  animation: _animation,
                  builder: (context, child) {
                    return Positioned(
                      top: frameHeight * _animation.value,
                      left: 0,
                      right: 0,
                      child: Container(
                        height: 3,
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              Colors.transparent,
                              const Color(0xFF6C63FF),
                              Colors.transparent,
                            ],
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: const Color(0xFF6C63FF).withOpacity(0.8),
                              blurRadius: 10,
                              spreadRadius: 2,
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ],
            ),
          ),

          // نص الإرشادات
          Positioned(
            bottom: -60,
            left: 0,
            right: 0,
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 20),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Colors.black.withOpacity(0.8),
                    Colors.black.withOpacity(0.6),
                  ],
                ),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: Colors.white.withOpacity(0.2),
                  width: 1,
                ),
              ),
              child: const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.calendar_today_rounded,
                    color: Color(0xFF6C63FF),
                    size: 20,
                  ),
                  SizedBox(width: 12),
                  Text(
                    'وجّه الكاميرا نحو تاريخ الصلاحية',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCorner(Alignment alignment) {
    return Align(
      alignment: alignment,
      child: Container(
        width: 30,
        height: 30,
        decoration: BoxDecoration(
          border: Border(
            top:
                alignment == Alignment.topLeft ||
                    alignment == Alignment.topRight
                ? const BorderSide(color: Color(0xFFFF6B9D), width: 4)
                : BorderSide.none,
            bottom:
                alignment == Alignment.bottomLeft ||
                    alignment == Alignment.bottomRight
                ? const BorderSide(color: Color(0xFFFF6B9D), width: 4)
                : BorderSide.none,
            left:
                alignment == Alignment.topLeft ||
                    alignment == Alignment.bottomLeft
                ? const BorderSide(color: Color(0xFFFF6B9D), width: 4)
                : BorderSide.none,
            right:
                alignment == Alignment.topRight ||
                    alignment == Alignment.bottomRight
                ? const BorderSide(color: Color(0xFFFF6B9D), width: 4)
                : BorderSide.none,
          ),
          borderRadius: BorderRadius.only(
            topLeft: alignment == Alignment.topLeft
                ? const Radius.circular(20)
                : Radius.zero,
            topRight: alignment == Alignment.topRight
                ? const Radius.circular(20)
                : Radius.zero,
            bottomLeft: alignment == Alignment.bottomLeft
                ? const Radius.circular(20)
                : Radius.zero,
            bottomRight: alignment == Alignment.bottomRight
                ? const Radius.circular(20)
                : Radius.zero,
          ),
        ),
      ),
    );
  }
}
