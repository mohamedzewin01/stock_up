import 'package:flutter/material.dart';

class ColorManager {
  static const Color darkBackground1 = Color(0xFF1A1A2E);
  static const Color background = Color(0xFF1A1A2E);
  static const Color primary = Color(0xFF1A1A2E);
  static const Color darkBackground2 = Color(0xFF16213E);
  static const Color secondary = Color(0xFF16213E);
  static const Color secondaryLight = Color(0xFF374C81);
  static const Color textMuted = Color(0xFF16213E);

  static const Color deepBlue = Color(0xFF0F3460);
  static const Color purple1 = Color(0xFF533483);
  static const Color accent = Color(0xFF533483);
  static const Color purple2 = Color(0xFF7B2CBF);
  static const Color accentLight = Color(0xFF7B2CBF);
  static const Color shadowMedium = Color(0xFF7B2CBF);
  static const Color purple3 = Color(0xFF9D4EDD);
  static const Color primaryLight = Color(0xFF9D4EDD);
  static const Color purple4 = Color(0xFF5A189A);

  // ألوان إضافية
  static const Color lightBackground = Color(0xFFF5F7FA);
  static const Color shadowLight = Color(0xFFF5F7FA);
  static const Color cardBackground = Colors.white;
  static const Color white = Colors.white;
  static const Color textPrimary = Color(0xFF2D3436);
  static const Color textSecondary = Color(0xFF636E72);
  static const Color grey = Color(0xFF636E72);
  static const Color greyLight = Color(0xFF919698);
  static const Color success = Color(0xFF26DE81);
  static const Color greenColor = Color(0xFF26DE81);
  static const Color warning = Color(0xFFFEA47F);
  static const Color error = Color(0xFFFF6B9D);
  static const Color red = Color(0xFFFF6B9D);

  // Gradients متماشية مع splash screen
  static const LinearGradient primaryGradient = LinearGradient(
    colors: [purple3, purple2, purple4],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient backgroundGradient = LinearGradient(
    colors: [darkBackground1, darkBackground2, purple1],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static LinearGradient cardGradient = LinearGradient(
    colors: [purple2.withOpacity(0.1), purple3.withOpacity(0.05)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  // Shadow متماشي مع splash screen
  static List<BoxShadow> primaryShadow = [
    BoxShadow(
      color: purple2.withOpacity(0.5),
      blurRadius: 40,
      spreadRadius: 10,
    ),
    BoxShadow(
      color: purple3.withOpacity(0.3),
      blurRadius: 60,
      spreadRadius: 20,
    ),
  ];

  static List<BoxShadow> cardShadow = [
    BoxShadow(
      color: purple2.withOpacity(0.15),
      blurRadius: 30,
      offset: const Offset(0, 10),
    ),
  ];
}
