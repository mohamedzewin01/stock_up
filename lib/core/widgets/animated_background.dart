import 'package:flutter/material.dart';

/// Widget خلفية متحركة بتدرج لوني ديناميكي
/// يمكن استخدامها في أي صفحة في التطبيق
class AnimatedGradientBackground extends StatefulWidget {
  /// مدة الأنيميشن الكاملة (الافتراضي: 20 ثانية)
  final Duration duration;

  /// الألوان المستخدمة في التدرج
  /// إذا لم تُحدد، ستُستخدم الألوان الافتراضية البريميوم
  final List<Color>? colors;

  /// نقاط توقف التدرج
  final List<double>? stops;

  /// اتجاه بداية التدرج
  final AlignmentGeometry begin;

  /// اتجاه نهاية التدرج
  final AlignmentGeometry end;

  const AnimatedGradientBackground({
    super.key,
    this.duration = const Duration(seconds: 20),
    this.colors,
    this.stops,
    this.begin = Alignment.topLeft,
    this.end = Alignment.bottomRight,
  });

  @override
  State<AnimatedGradientBackground> createState() =>
      _AnimatedGradientBackgroundState();
}

class _AnimatedGradientBackgroundState extends State<AnimatedGradientBackground>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: widget.duration)
      ..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // الألوان الافتراضية البريميوم
    final defaultColors = [
      const Color(0xFF1A1A2E),
      const Color(0xFF16213E),
      const Color(0xFF0F3460),
      const Color(0xFF16213E),
      const Color(0xFF533483),
      const Color(0xFF7B2CBF),
    ];

    final colors = widget.colors ?? defaultColors;
    final stops = widget.stops ?? const [0.0, 0.5, 1.0];

    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: widget.begin,
              end: widget.end,
              colors: [
                Color.lerp(colors[0], colors[1], (_controller.value * 2) % 1)!,
                Color.lerp(
                  colors[2],
                  colors[3],
                  (_controller.value * 2 + 0.5) % 1,
                )!,
                Color.lerp(
                  colors[4],
                  colors[5],
                  (_controller.value * 2 + 0.7) % 1,
                )!,
              ],
              stops: stops,
            ),
          ),
        );
      },
    );
  }
}
