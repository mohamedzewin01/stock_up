import 'dart:ui';

import 'package:flutter/material.dart';

class ColorManager {



  static const Color appBackground = Color(0xFFF3F1FB);
  static const Color cardBackground = Color(0xFFEAE6F9);
  static const Color titleColor = Color(0xFF303046);
  static const Color textSecondary = Color(0xFF6E6D7A);
  static const Color textSecondary2 = Color(0xFF9d9996);
  static const Color textPlaceholder = Color(0xFFBAB9C3);
  static const Color textColors = Color(0xFF4A4A6A);
  static const Color primaryColor = Color(0xFF9B51E0);
  static const Color greenColor = Color(0xFF51E09B);
  static const Color background = Color(0xFFf7f7f7);
  static const Color textMuted = Color(0xFF8A8A9E);
  static const Color feature1Bg = Color(0xFFAEFFD0);
  static const Color feature1Icon = Color(0xFF00A539);
  static const Color feature2Bg = Color(0xFFB3DDFF);//
  static const Color feature2IconColor = Color(0xFF007BFF);
  static const Color feature3Bg = Color(0xFFE6D6FF);
  static const Color feature3Icon = Color(0xFF8234E9);
  static const Color chatAssistantBg = Color(0xFFF0F1F3);
  static const Color chatUserBg = Color(0xFF7B1FA2);
  static const Color chatAssistantText = Color(0xFF333333);
  static const Color inputBorder = Color(0xFFE0E0E0);
  static const Color white = Color(0xFFFFFFFF);
  static const Color red = Color(0xfff44336);
  static const Color color = Color(0xffE8F0F2);
  static const Color darkGrey = Color(0xFF212121); // Dark Grey
  static const Color grey = Color(0xFF9E9E9E); // Grey
  static const Color error = Color(0xFFB00020); // Error (Red for errors)
  static const Color success = Color(0xFF4CAF50); // Success (Green for success messages)


///----------
  static const Color primary = Color(0xFF2E7D32); // Green
  static const Color primaryLight = Color(0xFF66BB6A);
  static const Color primaryDark = Color(0xFF1B5E20);

  // Secondary Colors
  static const Color secondary = Color(0xFF1976D2); // Blue
  static const Color secondaryLight = Color(0xFF64B5F6);
  static const Color secondaryDark = Color(0xFF0D47A1);

  // Accent Colors
  static const Color accent = Color(0xFFFF9800); // Orange
  static const Color accentLight = Color(0xFFFFCC02);
  static const Color accentDark = Color(0xFFE65100);

  // Background Colors
  static const Color scaffoldBackground = Color(0xFFF8F9FA);

  static const Color surfaceBackground = Color(0xFFF5F5F5);

  // Text Colors
  static const Color textPrimary = Color(0xFF212121);

  static const Color textHint = Color(0xFFBDBDBD);
  static const Color textDisabled = Color(0xFFE0E0E0);

  // Status Colors

  static const Color warning = Color(0xFFFF9800);

  static const Color info = Color(0xFF2196F3);

  // Neutral Colors

  static const Color black = Color(0xFF000000);

  static const Color greyLight = Color(0xFFE0E0E0);
  static const Color greyDark = Color(0xFF424242);

  // Story Category Colors
  static const Color categoryEducation = Color(0xFF3F51B5); // Indigo
  static const Color categoryAdventure = Color(0xFF009688); // Teal
  static const Color categoryFantasy = Color(0xFF9C27B0); // Purple
  static const Color categoryFamily = Color(0xFF4CAF50); // Green
  static const Color categoryAnimals = Color(0xFFFF5722); // Deep Orange
  static const Color categoryReligious = Color(0xFF795548); // Brown
  static const Color categoryHistory = Color(0xFF607D8B); // Blue Grey
  static const Color categorySports = Color(0xFFE91E63); // Pink

  // Age Group Colors
  static const Color ageGroup3to5 = Color(0xFFFFEB3B); // Yellow
  static const Color ageGroup6to8 = Color(0xFF4CAF50); // Green
  static const Color ageGroup9to12 = Color(0xFF2196F3); // Blue
  static const Color ageGroup13Plus = Color(0xFF9C27B0); // Purple

  // Gender Colors
  static const Color genderBoy = Color(0xFF2196F3); // Blue
  static const Color genderGirl = Color(0xFFE91E63); // Pink
  static const Color genderBoth = Color(0xFF9C27B0); // Purple

  // Gradient Colors
  static const List<Color> primaryGradient = [
    Color(0xFF2E7D32),
    Color(0xFF66BB6A),
  ];

  static const List<Color> secondaryGradient = [
    Color(0xFF1976D2),
    Color(0xFF64B5F6),
  ];

  static const List<Color> accentGradient = [
    Color(0xFFFF9800),
    Color(0xFFFFCC02),
  ];

  // Shimmer Colors
  static const Color shimmerBase = Color(0xFFE0E0E0);
  static const Color shimmerHighlight = Color(0xFFF5F5F5);

  // Shadow Colors
  static const Color shadowLight = Color(0x1A000000);
  static const Color shadowMedium = Color(0x33000000);
  static const Color shadowDark = Color(0x4D000000);

  // Story Status Colors
  static const Color storyActive = Color(0xFF4CAF50);
  static const Color storyInactive = Color(0xFFFF9800);
  static const Color storyArchived = Color(0xFF757575);

  // Rating Colors
  static const Color ratingExcellent = Color(0xFF4CAF50);
  static const Color ratingGood = Color(0xFF8BC34A);
  static const Color ratingAverage = Color(0xFFFF9800);
  static const Color ratingPoor = Color(0xFFFF5722);
  static const Color ratingBad = Color(0xFFF44336);

  // Helper Methods
  static Color getAgeGroupColor(String ageGroup) {
    if (ageGroup.contains('3-5') || ageGroup.contains('3 إلى 5')) {
      return ageGroup3to5;
    } else if (ageGroup.contains('6-8') || ageGroup.contains('6 إلى 8')) {
      return ageGroup6to8;
    } else if (ageGroup.contains('9-12') || ageGroup.contains('9 إلى 12')) {
      return ageGroup9to12;
    } else if (ageGroup.contains('13+') || ageGroup.contains('13 فأكثر')) {
      return ageGroup13Plus;
    }
    return grey;
  }

  static Color getGenderColor(String gender) {
    final genderLower = gender.toLowerCase();
    if (genderLower.contains('boy') || genderLower.contains('ولد')) {
      return genderBoy;
    } else if (genderLower.contains('girl') || genderLower.contains('بنت')) {
      return genderGirl;
    } else if (genderLower.contains('both') || genderLower.contains('الاثنان')) {
      return genderBoth;
    }
    return grey;
  }

  static Color getCategoryColor(String categoryName) {
    final name = categoryName.toLowerCase();

    if (name.contains('تعليم') || name.contains('علم')) {
      return categoryEducation;
    } else if (name.contains('مغامر') || name.contains('مغامرة')) {
      return categoryAdventure;
    } else if (name.contains('خيال') || name.contains('سحر')) {
      return categoryFantasy;
    } else if (name.contains('حيوان') || name.contains('حيوانات')) {
      return categoryAnimals;
    } else if (name.contains('أسرة') || name.contains('عائلة')) {
      return categoryFamily;
    } else if (name.contains('دين') || name.contains('إسلام')) {
      return categoryReligious;
    } else if (name.contains('تاريخ') || name.contains('تراث')) {
      return categoryHistory;
    } else if (name.contains('رياضة') || name.contains('رياضي')) {
      return categorySports;
    }
    return grey;
  }

  static Color getStatusColor(bool isActive) {
    return isActive ? storyActive : storyInactive;
  }

  static MaterialColor createMaterialColor(Color color) {
    List strengths = <double>[.05];
    Map<int, Color> swatch = {};
    final int r = color.red, g = color.green, b = color.blue;

    for (int i = 1; i < 10; i++) {
      strengths.add(0.1 * i);
    }
    for (var strength in strengths) {
      final double ds = 0.5 - strength;
      swatch[(strength * 1000).round()] = Color.fromRGBO(
        r + ((ds < 0 ? r : (255 - r)) * ds).round(),
        g + ((ds < 0 ? g : (255 - g)) * ds).round(),
        b + ((ds < 0 ? b : (255 - b)) * ds).round(),
        1,
      );
    }
    return MaterialColor(color.value, swatch);
  }

}
