import 'package:flutter/material.dart';
import 'package:stock_up/core/resources/style_manager.dart';

class PremiumCard extends StatelessWidget {
  const PremiumCard({
    super.key,
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.gradientColors,
    required this.delay,
    required this.onTap,
  });

  final IconData icon;
  final String title;
  final String subtitle;
  final List<Color> gradientColors;
  final int delay;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0.0, end: 1.0),
      duration: Duration(milliseconds: 600 + delay),
      curve: Curves.easeOutBack,
      builder: (context, value, child) {
        final clampedValue = value.clamp(0.0, 1.0);
        return Transform.scale(
          scale: clampedValue,
          child: Opacity(opacity: clampedValue, child: child),
        );
      },
      child: LayoutBuilder(
        builder: (context, constraints) {
          final maxHeight = constraints.maxHeight;
          final iconSize = maxHeight * 0.20;
          final iconPadding = maxHeight * 0.08;
          final titleSize = maxHeight * 0.12;
          final subtitleSize = maxHeight * 0.08;

          return Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(24),
              boxShadow: [
                BoxShadow(
                  color: gradientColors[0].withOpacity(0.4),
                  blurRadius: 25,
                  offset: const Offset(0, 12),
                  spreadRadius: 2,
                ),
              ],
            ),
            child: Material(
              color: Colors.transparent,
              borderRadius: BorderRadius.circular(24),
              child: InkWell(
                onTap: onTap,
                borderRadius: BorderRadius.circular(24),
                splashColor: Colors.white.withOpacity(0.2),
                highlightColor: Colors.white.withOpacity(0.1),
                child: Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: gradientColors,
                    ),
                    borderRadius: BorderRadius.circular(24),
                    border: Border.all(
                      color: Colors.white.withOpacity(0.2),
                      width: 1.5,
                    ),
                  ),
                  padding: EdgeInsets.symmetric(
                    horizontal: constraints.maxWidth * 0.1,
                    vertical: maxHeight * 0.1,
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        padding: EdgeInsets.all(iconPadding),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.25),
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(
                            color: Colors.white.withOpacity(0.3),
                            width: 1,
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.1),
                              blurRadius: 8,
                              offset: Offset(0, 4),
                            ),
                          ],
                        ),
                        child: Icon(
                          icon,
                          size: iconSize.clamp(28.0, 50.0),
                          color: Colors.white,
                        ),
                      ),
                      SizedBox(height: maxHeight * 0.05),
                      Flexible(
                        child: Text(
                          title,
                          style: getSemiBoldStyle(
                            color: Colors.white,
                            fontSize: titleSize.clamp(16.0, 24.0),
                          ),
                          textAlign: TextAlign.center,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      SizedBox(height: maxHeight * 0.04),
                      Flexible(
                        child: Text(
                          subtitle,
                          style: TextStyle(
                            fontSize: subtitleSize.clamp(11.0, 15.0),
                            color: Colors.white.withOpacity(0.9),
                            fontWeight: FontWeight.w500,
                            letterSpacing: 0.3,
                          ),
                          textAlign: TextAlign.center,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
