import 'package:flutter/material.dart';

class FloatingParticle extends StatefulWidget {
  final double size;
  final Duration duration;
  final Duration delay;

  const FloatingParticle({
    super.key,
    required this.size,
    required this.duration,
    required this.delay,
  });

  @override
  State<FloatingParticle> createState() => FloatingParticleState();
}

class FloatingParticleState extends State<FloatingParticle>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<Offset> _animation;
  late double _startX;
  late double _startY;

  @override
  void initState() {
    super.initState();
    _startX = (DateTime.now().millisecondsSinceEpoch % 100) / 100;
    _startY = (DateTime.now().microsecondsSinceEpoch % 100) / 100;

    _controller = AnimationController(vsync: this, duration: widget.duration);

    _animation = Tween<Offset>(
      begin: Offset(_startX, _startY + 1),
      end: Offset(_startX + 0.2, -0.5),
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.linear));

    Future.delayed(widget.delay, () {
      if (mounted) {
        _controller.repeat();
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        return Positioned(
          left: _animation.value.dx * size.width,
          top: _animation.value.dy * size.height,
          child: Container(
            width: widget.size,
            height: widget.size,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: RadialGradient(
                colors: [
                  Colors.white.withOpacity(0.6),
                  Colors.white.withOpacity(0.0),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
