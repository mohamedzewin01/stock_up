// // lib/features/DateScanner/data/services/date_parser_service.dart
//
// import 'package:hijri/hijri_calendar.dart';
//
// import '../../domain/entities/date_scan_result.dart';
//
// class DateParserService {
//   // تحليل النص واستخراج التواريخ
//   DateScanResult parseText(String text) {
//     final cleanedText = _cleanText(text);
//
//     DateTime? expiryDate;
//     DateTime? mfgDate;
//     DateTime? bestBefore;
//     Duration? validityPeriod;
//
//     // 1. البحث عن تاريخ الانتهاء
//     expiryDate = _findExpiryDate(cleanedText);
//
//     // 2. البحث عن تاريخ الإنتاج
//     mfgDate = _findManufacturingDate(cleanedText);
//
//     // 3. البحث عن "صالح لمدة..."
//     validityPeriod = _findValidityPeriod(cleanedText);
//
//     // 4. حساب تاريخ الانتهاء إذا وُجد تاريخ إنتاج ومدة صلاحية
//     if (expiryDate == null && mfgDate != null && validityPeriod != null) {
//       expiryDate = mfgDate.add(validityPeriod);
//     }
//
//     // 5. البحث عن Best Before
//     bestBefore = _findBestBeforeDate(cleanedText);
//
//     // 6. تحديد التاريخ النهائي للتحقق
//     final dateToCheck = expiryDate ?? bestBefore;
//
//     // 7. تحديد حالة المنتج
//     final status = _determineStatus(dateToCheck);
//     final daysUntilExpiry = dateToCheck != null
//         ? dateToCheck.difference(DateTime.now()).inDays
//         : null;
//
//     return DateScanResult(
//       expiryDate: expiryDate,
//       manufacturingDate: mfgDate,
//       bestBefore: bestBefore,
//       status: status,
//       rawText: text,
//       validityPeriod: validityPeriod,
//       daysUntilExpiry: daysUntilExpiry,
//       detectedTexts: [cleanedText],
//     );
//   }
//
//   // تنظيف النص
//   String _cleanText(String text) {
//     return text
//         .toUpperCase()
//         .replaceAll('\n', ' ')
//         .replaceAll(RegExp(r'\s+'), ' ')
//         .trim();
//   }
//
//   // البحث عن تاريخ الانتهاء
//   DateTime? _findExpiryDate(String text) {
//     // EXP: 10/03/2025
//     final expPattern = RegExp(
//       r'EXP[:\s]*(\d{1,2})[\/\-\.](\d{1,2})[\/\-\.](\d{2,4})',
//       caseSensitive: false,
//     );
//
//     final match = expPattern.firstMatch(text);
//     if (match != null) {
//       return _parseDate(match.group(1)!, match.group(2)!, match.group(3)!);
//     }
//
//     // EXPIRY: 2025-12-05
//     final expiryPattern = RegExp(
//       r'EXPIRY[:\s]*(\d{4})[\/\-\.](\d{1,2})[\/\-\.](\d{1,2})',
//       caseSensitive: false,
//     );
//
//     final match2 = expiryPattern.firstMatch(text);
//     if (match2 != null) {
//       return DateTime(
//         int.parse(match2.group(1)!),
//         int.parse(match2.group(2)!),
//         int.parse(match2.group(3)!),
//       );
//     }
//
//     // OCT 2025 أو OCTOBER 2025
//     final monthYearPattern = RegExp(
//       r'(JAN|FEB|MAR|APR|MAY|JUN|JUL|AUG|SEP|OCT|NOV|DEC|JANUARY|FEBRUARY|MARCH|APRIL|MAY|JUNE|JULY|AUGUST|SEPTEMBER|OCTOBER|NOVEMBER|DECEMBER)\s*(\d{4})',
//       caseSensitive: false,
//     );
//
//     final match3 = monthYearPattern.firstMatch(text);
//     if (match3 != null) {
//       final month = _monthNameToNumber(match3.group(1)!);
//       final year = int.parse(match3.group(2)!);
//       return DateTime(year, month);
//     }
//
//     // تاريخ بدون فواصل: 230612 → 2023/06/12
//     final compactPattern = RegExp(r'(\d{6})');
//     final match4 = compactPattern.firstMatch(text);
//     if (match4 != null) {
//       final dateStr = match4.group(1)!;
//       if (dateStr.length == 6) {
//         final year = int.parse('20${dateStr.substring(0, 2)}');
//         final month = int.parse(dateStr.substring(2, 4));
//         final day = int.parse(dateStr.substring(4, 6));
//         if (month >= 1 && month <= 12 && day >= 1 && day <= 31) {
//           return DateTime(year, month, day);
//         }
//       }
//     }
//
//     // التاريخ الهجري: ٢٥/١١/١٤٤٦
//     final hijriDate = _parseHijriDate(text);
//     if (hijriDate != null) return hijriDate;
//
//     return null;
//   }
//
//   // البحث عن تاريخ الإنتاج
//   DateTime? _findManufacturingDate(String text) {
//     // MFG: 07/09/2023
//     final mfgPattern = RegExp(
//       r'MFG[:\s]*(\d{1,2})[\/\-\.](\d{1,2})[\/\-\.](\d{2,4})',
//       caseSensitive: false,
//     );
//
//     final match = mfgPattern.firstMatch(text);
//     if (match != null) {
//       return _parseDate(match.group(1)!, match.group(2)!, match.group(3)!);
//     }
//
//     return null;
//   }
//
//   // البحث عن Best Before
//   DateTime? _findBestBeforeDate(String text) {
//     // Best Before 2025/06
//     final bbPattern = RegExp(
//       r'BEST\s*BEFORE[:\s]*(\d{4})[\/\-\.](\d{1,2})',
//       caseSensitive: false,
//     );
//
//     final match = bbPattern.firstMatch(text);
//     if (match != null) {
//       final year = int.parse(match.group(1)!);
//       final month = int.parse(match.group(2)!);
//       return DateTime(year, month);
//     }
//
//     return null;
//   }
//
//   // البحث عن مدة الصلاحية
//   Duration? _findValidityPeriod(String text) {
//     // صالح لمدة 3 سنوات
//     final yearPattern = RegExp(
//       r'صالح\s*لمدة\s*(\d+)\s*سنوات?|VALID\s*FOR\s*(\d+)\s*YEARS?',
//       caseSensitive: false,
//     );
//
//     var match = yearPattern.firstMatch(text);
//     if (match != null) {
//       final years = int.parse(match.group(1) ?? match.group(2)!);
//       return Duration(days: years * 365);
//     }
//
//     // صالح لمدة 18 شهر
//     final monthPattern = RegExp(
//       r'صالح\s*لمدة\s*(\d+)\s*شهر|VALID\s*FOR\s*(\d+)\s*MONTHS?',
//       caseSensitive: false,
//     );
//
//     match = monthPattern.firstMatch(text);
//     if (match != null) {
//       final months = int.parse(match.group(1) ?? match.group(2)!);
//       return Duration(days: months * 30);
//     }
//
//     // Best consumed within 6 months
//     final consumePattern = RegExp(
//       r'WITHIN\s*(\d+)\s*MONTHS?',
//       caseSensitive: false,
//     );
//
//     match = consumePattern.firstMatch(text);
//     if (match != null) {
//       final months = int.parse(match.group(1)!);
//       return Duration(days: months * 30);
//     }
//
//     return null;
//   }
//
//   // تحليل تاريخ هجري
//   DateTime? _parseHijriDate(String text) {
//     final hijriPattern = RegExp(r'(\d+)[\/\-](\d+)[\/\-](\d{4})');
//     final match = hijriPattern.firstMatch(text);
//
//     if (match != null) {
//       try {
//         final day = int.parse(match.group(1)!);
//         final month = int.parse(match.group(2)!);
//         final year = int.parse(match.group(3)!);
//
//         // التحقق إذا كان التاريخ هجري (السنة > 1400)
//         if (year >= 1400 && year <= 1500) {
//           final hijri = HijriCalendar()
//             ..hYear = year
//             ..hMonth = month
//             ..hDay = day;
//
//           return hijri.hijriToGregorian(year, month, day);
//         }
//       } catch (e) {
//         return null;
//       }
//     }
//
//     return null;
//   }
//
//   // تحويل اسم الشهر إلى رقم
//   int _monthNameToNumber(String month) {
//     final months = {
//       'JAN': 1,
//       'JANUARY': 1,
//       'FEB': 2,
//       'FEBRUARY': 2,
//       'MAR': 3,
//       'MARCH': 3,
//       'APR': 4,
//       'APRIL': 4,
//       'MAY': 5,
//       'JUN': 6,
//       'JUNE': 6,
//       'JUL': 7,
//       'JULY': 7,
//       'AUG': 8,
//       'AUGUST': 8,
//       'SEP': 9,
//       'SEPTEMBER': 9,
//       'OCT': 10,
//       'OCTOBER': 10,
//       'NOV': 11,
//       'NOVEMBER': 11,
//       'DEC': 12,
//       'DECEMBER': 12,
//     };
//
//     return months[month.toUpperCase()] ?? 1;
//   }
//
//   // تحليل التاريخ
//   DateTime? _parseDate(String day, String month, String year) {
//     try {
//       int y = int.parse(year);
//       if (y < 100) y += 2000; // تحويل 25 إلى 2025
//
//       final m = int.parse(month);
//       final d = int.parse(day);
//
//       if (m >= 1 && m <= 12 && d >= 1 && d <= 31) {
//         return DateTime(y, m, d);
//       }
//     } catch (e) {
//       return null;
//     }
//
//     return null;
//   }
//
//   // تحديد حالة المنتج
//   ProductStatus _determineStatus(DateTime? expiryDate) {
//     if (expiryDate == null) {
//       return ProductStatus.unclear;
//     }
//
//     final now = DateTime.now();
//     final difference = expiryDate.difference(now);
//
//     if (difference.isNegative) {
//       return ProductStatus.expired;
//     } else if (difference.inDays <= 30) {
//       return ProductStatus.nearExpiry;
//     } else {
//       return ProductStatus.valid;
//     }
//   }
// }
// lib/features/DateScanner/data/services/date_parser_service.dart

import 'package:hijri/hijri_calendar.dart';

import '../../domain/entities/date_scan_result.dart';

class DateParserService {
  // تحليل النص واستخراج التواريخ
  DateScanResult parseText(String text) {
    final cleanedText = _cleanText(text);

    DateTime? expiryDate;
    DateTime? mfgDate;
    DateTime? bestBefore;
    Duration? validityPeriod;

    // 1. البحث عن تاريخ الانتهاء (جميع الاحتمالات)
    expiryDate = _findExpiryDate(cleanedText);

    // 2. البحث عن تاريخ الإنتاج (جميع الاحتمالات)
    mfgDate = _findManufacturingDate(cleanedText);

    // 3. البحث عن "صالح لمدة..." (جميع الاحتمالات)
    validityPeriod = _findValidityPeriod(cleanedText);

    // 4. حساب تاريخ الانتهاء إذا وُجد تاريخ إنتاج ومدة صلاحية
    if (expiryDate == null && mfgDate != null && validityPeriod != null) {
      expiryDate = mfgDate.add(validityPeriod);
    }

    // 5. البحث عن Best Before (جميع الاحتمالات)
    bestBefore = _findBestBeforeDate(cleanedText);

    // 6. البحث عن تواريخ إضافية (Sell By, Use By, إلخ)
    if (expiryDate == null) {
      expiryDate = _findAdditionalDates(cleanedText);
    }

    // 7. محاولة استخراج أي تاريخ عام
    if (expiryDate == null && mfgDate == null && bestBefore == null) {
      expiryDate = _findAnyDate(cleanedText);
    }

    // 8. تحديد التاريخ النهائي للتحقق
    final dateToCheck = expiryDate ?? bestBefore;

    // 9. تحديد حالة المنتج
    final status = _determineStatus(dateToCheck);
    final daysUntilExpiry = dateToCheck != null
        ? dateToCheck.difference(DateTime.now()).inDays
        : null;

    return DateScanResult(
      expiryDate: expiryDate,
      manufacturingDate: mfgDate,
      bestBefore: bestBefore,
      status: status,
      rawText: text,
      validityPeriod: validityPeriod,
      daysUntilExpiry: daysUntilExpiry,
      detectedTexts: [cleanedText],
    );
  }

  // تنظيف النص وتحويل الأرقام العربية
  String _cleanText(String text) {
    // تحويل الأرقام العربية/الهندية إلى إنجليزية
    final arabicToEnglish = {
      '٠': '0',
      '١': '1',
      '٢': '2',
      '٣': '3',
      '٤': '4',
      '٥': '5',
      '٦': '6',
      '٧': '7',
      '٨': '8',
      '٩': '9',
      '۰': '0',
      '۱': '1',
      '۲': '2',
      '۳': '3',
      '۴': '4',
      '۵': '5',
      '۶': '6',
      '۷': '7',
      '۸': '8',
      '۹': '9',
    };

    String converted = text;
    arabicToEnglish.forEach((arabic, english) {
      converted = converted.replaceAll(arabic, english);
    });

    return converted
        .toUpperCase()
        .replaceAll('\n', ' ')
        .replaceAll(RegExp(r'\s+'), ' ')
        .trim();
  }

  // ==========================================
  // البحث عن تاريخ الانتهاء - جميع الاحتمالات
  // ==========================================
  DateTime? _findExpiryDate(String text) {
    // 1️⃣ EXP / EXPIRY / EXPIRE / EXPIRATION (إنجليزي)
    final expPatterns = [
      r'EXP[IRY]*[ATION]*[:\s]*(\d{1,2})[\/\-\.](\d{1,2})[\/\-\.](\d{2,4})',
      r'EXPIRE[SD]*[:\s]*(\d{1,2})[\/\-\.](\d{1,2})[\/\-\.](\d{2,4})',
      r'EXPIRATION[:\s]*(\d{1,2})[\/\-\.](\d{1,2})[\/\-\.](\d{2,4})',
    ];

    for (final pattern in expPatterns) {
      final match = RegExp(pattern, caseSensitive: false).firstMatch(text);
      if (match != null) {
        final date = _parseDate(
          match.group(1)!,
          match.group(2)!,
          match.group(3)!,
        );
        if (date != null) return date;
      }
    }

    // 2️⃣ انتهاء الصلاحية / تاريخ الانتهاء / ينتهي في (عربي)
    final arabicExpPatterns = [
      r'انتهاء[:\s]*(\d{1,2})[\/\-\.](\d{1,2})[\/\-\.](\d{2,4})',
      r'تاريخ\s*الانتهاء[:\s]*(\d{1,2})[\/\-\.](\d{1,2})[\/\-\.](\d{2,4})',
      r'ينتهي\s*في[:\s]*(\d{1,2})[\/\-\.](\d{1,2})[\/\-\.](\d{2,4})',
      r'صالح\s*حتى[:\s]*(\d{1,2})[\/\-\.](\d{1,2})[\/\-\.](\d{2,4})',
      r'صلاحية[:\s]*(\d{1,2})[\/\-\.](\d{1,2})[\/\-\.](\d{2,4})',
    ];

    for (final pattern in arabicExpPatterns) {
      final match = RegExp(pattern).firstMatch(text);
      if (match != null) {
        final date = _parseDate(
          match.group(1)!,
          match.group(2)!,
          match.group(3)!,
        );
        if (date != null) return date;
      }
    }

    // 3️⃣ YYYY-MM-DD أو YYYY/MM/DD (تنسيق دولي)
    final isoPattern = RegExp(
      r'EXP[IRY]*[:\s]*(\d{4})[\/\-\.](\d{1,2})[\/\-\.](\d{1,2})',
      caseSensitive: false,
    );

    final isoMatch = isoPattern.firstMatch(text);
    if (isoMatch != null) {
      return DateTime(
        int.parse(isoMatch.group(1)!),
        int.parse(isoMatch.group(2)!),
        int.parse(isoMatch.group(3)!),
      );
    }

    // 4️⃣ الأشهر بالاسم (إنجليزي) - OCT 2025, OCTOBER 2025
    final monthYearPatterns = [
      r'(JAN|FEB|MAR|APR|MAY|JUN|JUL|AUG|SEP|OCT|NOV|DEC)[UARY]*[:\s]*(\d{4})',
      r'(JANUARY|FEBRUARY|MARCH|APRIL|MAY|JUNE|JULY|AUGUST|SEPTEMBER|OCTOBER|NOVEMBER|DECEMBER)[:\s]*(\d{4})',
    ];

    for (final pattern in monthYearPatterns) {
      final match = RegExp(pattern, caseSensitive: false).firstMatch(text);
      if (match != null) {
        final month = _monthNameToNumber(match.group(1)!);
        final year = int.parse(match.group(2)!);
        return DateTime(year, month);
      }
    }

    // 5️⃣ الأشهر بالاسم (عربي) - يناير 2025, كانون الثاني 2025
    final arabicMonths = {
      'يناير': 1,
      'كانون الثاني': 1,
      'جانفي': 1,
      'فبراير': 2,
      'شباط': 2,
      'فيفري': 2,
      'مارس': 3,
      'آذار': 3,
      'مارص': 3,
      'أبريل': 4,
      'نيسان': 4,
      'ابريل': 4,
      'مايو': 5,
      'أيار': 5,
      'ماي': 5,
      'يونيو': 6,
      'حزيران': 6,
      'جوان': 6,
      'يوليو': 7,
      'تموز': 7,
      'جويلية': 7,
      'أغسطس': 8,
      'آب': 8,
      'اوت': 8,
      'سبتمبر': 9,
      'أيلول': 9,
      'سبتمبر': 9,
      'أكتوبر': 10,
      'تشرين الأول': 10,
      'اكتوبر': 10,
      'نوفمبر': 11,
      'تشرين الثاني': 11,
      'نوفمبر': 11,
      'ديسمبر': 12,
      'كانون الأول': 12,
      'ديسمبر': 12,
    };

    for (final entry in arabicMonths.entries) {
      final pattern = RegExp('${entry.key}[:\s]*(\d{4})');
      final match = pattern.firstMatch(text);
      if (match != null) {
        final year = int.parse(match.group(1)!);
        return DateTime(year, entry.value);
      }
    }

    // 6️⃣ تاريخ مدمج بدون فواصل
    final compactPatterns = [
      r'EXP[:\s]*(\d{6})', // EXP: 250612
      r'(\d{6})', // 250612 مباشرة
    ];

    for (final pattern in compactPatterns) {
      final match = RegExp(pattern, caseSensitive: false).firstMatch(text);
      if (match != null) {
        final dateStr = match.group(1)!;
        if (dateStr.length == 6) {
          // محاولة YYMMDD
          final year = int.parse('20${dateStr.substring(0, 2)}');
          final month = int.parse(dateStr.substring(2, 4));
          final day = int.parse(dateStr.substring(4, 6));
          if (month >= 1 && month <= 12 && day >= 1 && day <= 31) {
            return DateTime(year, month, day);
          }

          // محاولة DDMMYY
          final day2 = int.parse(dateStr.substring(0, 2));
          final month2 = int.parse(dateStr.substring(2, 4));
          final year2 = int.parse('20${dateStr.substring(4, 6)}');
          if (month2 >= 1 && month2 <= 12 && day2 >= 1 && day2 <= 31) {
            return DateTime(year2, month2, day2);
          }
        }
      }
    }

    // 7️⃣ تاريخ هجري
    final hijriDate = _parseHijriDate(text);
    if (hijriDate != null) return hijriDate;

    // 8️⃣ شهر/سنة فقط MM/YYYY
    final monthYear = RegExp(r'(\d{1,2})[\/\-\.](\d{4})').firstMatch(text);
    if (monthYear != null) {
      final month = int.parse(monthYear.group(1)!);
      final year = int.parse(monthYear.group(2)!);
      if (month >= 1 && month <= 12) {
        return DateTime(year, month);
      }
    }

    return null;
  }

  // ==========================================
  // البحث عن تاريخ الإنتاج - جميع الاحتمالات
  // ==========================================
  DateTime? _findManufacturingDate(String text) {
    // 1️⃣ MFG / MANUFACTURING / MANUFACTURED / PRODUCTION (إنجليزي)
    final mfgPatterns = [
      r'MFG[:\s]*(\d{1,2})[\/\-\.](\d{1,2})[\/\-\.](\d{2,4})',
      r'MANUFACTUR[ED|ING]*[:\s]*(\d{1,2})[\/\-\.](\d{1,2})[\/\-\.](\d{2,4})',
      r'PROD[UCTION]*[:\s]*(\d{1,2})[\/\-\.](\d{1,2})[\/\-\.](\d{2,4})',
      r'MADE[:\s]*(\d{1,2})[\/\-\.](\d{1,2})[\/\-\.](\d{2,4})',
      r'MFD[:\s]*(\d{1,2})[\/\-\.](\d{1,2})[\/\-\.](\d{2,4})',
    ];

    for (final pattern in mfgPatterns) {
      final match = RegExp(pattern, caseSensitive: false).firstMatch(text);
      if (match != null) {
        final date = _parseDate(
          match.group(1)!,
          match.group(2)!,
          match.group(3)!,
        );
        if (date != null) return date;
      }
    }

    // 2️⃣ تاريخ الإنتاج / أُنتج في / صُنع في (عربي)
    final arabicMfgPatterns = [
      r'تاريخ\s*الإنتاج[:\s]*(\d{1,2})[\/\-\.](\d{1,2})[\/\-\.](\d{2,4})',
      r'أُنتج\s*في[:\s]*(\d{1,2})[\/\-\.](\d{1,2})[\/\-\.](\d{2,4})',
      r'صُنع\s*في[:\s]*(\d{1,2})[\/\-\.](\d{1,2})[\/\-\.](\d{2,4})',
      r'انتاج[:\s]*(\d{1,2})[\/\-\.](\d{1,2})[\/\-\.](\d{2,4})',
      r'تصنيع[:\s]*(\d{1,2})[\/\-\.](\d{1,2})[\/\-\.](\d{2,4})',
    ];

    for (final pattern in arabicMfgPatterns) {
      final match = RegExp(pattern).firstMatch(text);
      if (match != null) {
        final date = _parseDate(
          match.group(1)!,
          match.group(2)!,
          match.group(3)!,
        );
        if (date != null) return date;
      }
    }

    // 3️⃣ PACKED ON / PACKAGED ON (تاريخ التعبئة)
    final packedPatterns = [
      r'PACK[ED|AGED]*\s*ON[:\s]*(\d{1,2})[\/\-\.](\d{1,2})[\/\-\.](\d{2,4})',
      r'تاريخ\s*التعبئة[:\s]*(\d{1,2})[\/\-\.](\d{1,2})[\/\-\.](\d{2,4})',
    ];

    for (final pattern in packedPatterns) {
      final match = RegExp(pattern, caseSensitive: false).firstMatch(text);
      if (match != null) {
        final date = _parseDate(
          match.group(1)!,
          match.group(2)!,
          match.group(3)!,
        );
        if (date != null) return date;
      }
    }

    return null;
  }

  // ==========================================
  // البحث عن Best Before - جميع الاحتمالات
  // ==========================================
  DateTime? _findBestBeforeDate(String text) {
    // 1️⃣ BEST BEFORE / BEST BY / BB (إنجليزي)
    final bbPatterns = [
      r'BEST\s*BEFORE[:\s]*(\d{1,2})[\/\-\.](\d{1,2})[\/\-\.](\d{2,4})',
      r'BEST\s*BY[:\s]*(\d{1,2})[\/\-\.](\d{1,2})[\/\-\.](\d{2,4})',
      r'BB[:\s]*(\d{1,2})[\/\-\.](\d{1,2})[\/\-\.](\d{2,4})',
      r'BEST\s*BEFORE[:\s]*(\d{4})[\/\-\.](\d{1,2})',
    ];

    for (final pattern in bbPatterns) {
      final match = RegExp(pattern, caseSensitive: false).firstMatch(text);
      if (match != null) {
        if (match.groupCount == 3) {
          final date = _parseDate(
            match.group(1)!,
            match.group(2)!,
            match.group(3)!,
          );
          if (date != null) return date;
        } else if (match.groupCount == 2) {
          final year = int.parse(match.group(1)!);
          final month = int.parse(match.group(2)!);
          return DateTime(year, month);
        }
      }
    }

    // 2️⃣ يُفضل قبل / الأفضل قبل (عربي)
    final arabicBBPatterns = [
      r'يُفضل\s*قبل[:\s]*(\d{1,2})[\/\-\.](\d{1,2})[\/\-\.](\d{2,4})',
      r'الأفضل\s*قبل[:\s]*(\d{1,2})[\/\-\.](\d{1,2})[\/\-\.](\d{2,4})',
      r'يفضل\s*استخدامه\s*قبل[:\s]*(\d{1,2})[\/\-\.](\d{1,2})[\/\-\.](\d{2,4})',
    ];

    for (final pattern in arabicBBPatterns) {
      final match = RegExp(pattern).firstMatch(text);
      if (match != null) {
        final date = _parseDate(
          match.group(1)!,
          match.group(2)!,
          match.group(3)!,
        );
        if (date != null) return date;
      }
    }

    return null;
  }

  // ==========================================
  // البحث عن تواريخ إضافية (USE BY, SELL BY, إلخ)
  // ==========================================
  DateTime? _findAdditionalDates(String text) {
    // 1️⃣ USE BY / USE BEFORE / CONSUME BY
    final usePatterns = [
      r'USE\s*BY[:\s]*(\d{1,2})[\/\-\.](\d{1,2})[\/\-\.](\d{2,4})',
      r'USE\s*BEFORE[:\s]*(\d{1,2})[\/\-\.](\d{1,2})[\/\-\.](\d{2,4})',
      r'CONSUME\s*BY[:\s]*(\d{1,2})[\/\-\.](\d{1,2})[\/\-\.](\d{2,4})',
      r'CONSUME\s*BEFORE[:\s]*(\d{1,2})[\/\-\.](\d{1,2})[\/\-\.](\d{2,4})',
    ];

    for (final pattern in usePatterns) {
      final match = RegExp(pattern, caseSensitive: false).firstMatch(text);
      if (match != null) {
        final date = _parseDate(
          match.group(1)!,
          match.group(2)!,
          match.group(3)!,
        );
        if (date != null) return date;
      }
    }

    // 2️⃣ يُستخدم قبل / يُستهلك قبل (عربي)
    final arabicUsePatterns = [
      r'يُستخدم\s*قبل[:\s]*(\d{1,2})[\/\-\.](\d{1,2})[\/\-\.](\d{2,4})',
      r'يُستهلك\s*قبل[:\s]*(\d{1,2})[\/\-\.](\d{1,2})[\/\-\.](\d{2,4})',
      r'استخدام\s*قبل[:\s]*(\d{1,2})[\/\-\.](\d{1,2})[\/\-\.](\d{2,4})',
    ];

    for (final pattern in arabicUsePatterns) {
      final match = RegExp(pattern).firstMatch(text);
      if (match != null) {
        final date = _parseDate(
          match.group(1)!,
          match.group(2)!,
          match.group(3)!,
        );
        if (date != null) return date;
      }
    }

    // 3️⃣ SELL BY / DISPLAY UNTIL
    final sellPatterns = [
      r'SELL\s*BY[:\s]*(\d{1,2})[\/\-\.](\d{1,2})[\/\-\.](\d{2,4})',
      r'DISPLAY\s*UNTIL[:\s]*(\d{1,2})[\/\-\.](\d{1,2})[\/\-\.](\d{2,4})',
    ];

    for (final pattern in sellPatterns) {
      final match = RegExp(pattern, caseSensitive: false).firstMatch(text);
      if (match != null) {
        final date = _parseDate(
          match.group(1)!,
          match.group(2)!,
          match.group(3)!,
        );
        if (date != null) return date;
      }
    }

    return null;
  }

  // ==========================================
  // البحث عن أي تاريخ عام (آخر محاولة)
  // ==========================================
  DateTime? _findAnyDate(String text) {
    // 1️⃣ DD/MM/YYYY أو MM/DD/YYYY
    final datePatterns = [
      r'(\d{1,2})[\/\-\.](\d{1,2})[\/\-\.](\d{4})',
      r'(\d{1,2})[\/\-\.](\d{1,2})[\/\-\.](\d{2})',
    ];

    for (final pattern in datePatterns) {
      final match = RegExp(pattern).firstMatch(text);
      if (match != null) {
        final date = _parseDate(
          match.group(1)!,
          match.group(2)!,
          match.group(3)!,
        );
        if (date != null && date.isAfter(DateTime(2020, 1, 1))) {
          return date;
        }
      }
    }

    return null;
  }

  // ==========================================
  // البحث عن مدة الصلاحية - جميع الاحتمالات
  // ==========================================
  Duration? _findValidityPeriod(String text) {
    // 1️⃣ سنوات (عربي + إنجليزي)
    final yearPatterns = [
      r'صالح\s*لمدة\s*(\d+)\s*سنة',
      r'صالح\s*لمدة\s*(\d+)\s*سنوات',
      r'صالح\s*(\d+)\s*سنة',
      r'VALID\s*FOR\s*(\d+)\s*YEARS?',
      r'SHELF\s*LIFE\s*(\d+)\s*YEARS?',
      r'عمر\s*افتراضي\s*(\d+)\s*سنة',
    ];

    for (final pattern in yearPatterns) {
      final match = RegExp(pattern, caseSensitive: false).firstMatch(text);
      if (match != null) {
        final years = int.parse(match.group(1)!);
        return Duration(days: years * 365);
      }
    }

    // 2️⃣ شهور (عربي + إنجليزي)
    final monthPatterns = [
      r'صالح\s*لمدة\s*(\d+)\s*شهر',
      r'صالح\s*لمدة\s*(\d+)\s*شهور',
      r'صالح\s*(\d+)\s*شهر',
      r'VALID\s*FOR\s*(\d+)\s*MONTHS?',
      r'SHELF\s*LIFE\s*(\d+)\s*MONTHS?',
      r'WITHIN\s*(\d+)\s*MONTHS?',
      r'BEST\s*CONSUMED\s*WITHIN\s*(\d+)\s*MONTHS?',
      r'عمر\s*افتراضي\s*(\d+)\s*شهر',
    ];

    for (final pattern in monthPatterns) {
      final match = RegExp(pattern, caseSensitive: false).firstMatch(text);
      if (match != null) {
        final months = int.parse(match.group(1)!);
        return Duration(days: months * 30);
      }
    }

    // 3️⃣ أيام (عربي + إنجليزي)
    final dayPatterns = [
      r'صالح\s*لمدة\s*(\d+)\s*يوم',
      r'صالح\s*لمدة\s*(\d+)\s*أيام',
      r'VALID\s*FOR\s*(\d+)\s*DAYS?',
      r'SHELF\s*LIFE\s*(\d+)\s*DAYS?',
    ];

    for (final pattern in dayPatterns) {
      final match = RegExp(pattern, caseSensitive: false).firstMatch(text);
      if (match != null) {
        final days = int.parse(match.group(1)!);
        return Duration(days: days);
      }
    }

    // 4️⃣ أسابيع (عربي + إنجليزي)
    final weekPatterns = [
      r'صالح\s*لمدة\s*(\d+)\s*أسبوع',
      r'صالح\s*لمدة\s*(\d+)\s*أسابيع',
      r'VALID\s*FOR\s*(\d+)\s*WEEKS?',
    ];

    for (final pattern in weekPatterns) {
      final match = RegExp(pattern, caseSensitive: false).firstMatch(text);
      if (match != null) {
        final weeks = int.parse(match.group(1)!);
        return Duration(days: weeks * 7);
      }
    }

    return null;
  }

  // ==========================================
  // تحليل تاريخ هجري (جميع الأشهر الهجرية)
  // ==========================================
  DateTime? _parseHijriDate(String text) {
    // 1️⃣ تاريخ رقمي هجري
    final hijriPattern = RegExp(r'(\d+)[\/\-](\d+)[\/\-](\d{4})');
    final match = hijriPattern.firstMatch(text);

    if (match != null) {
      try {
        final day = int.parse(match.group(1)!);
        final month = int.parse(match.group(2)!);
        final year = int.parse(match.group(3)!);

        // التحقق إذا كان التاريخ هجري (السنة > 1400)
        if (year >= 1400 && year <= 1500) {
          return HijriCalendar.fromDate(
            DateTime.now(),
          ).hijriToGregorian(year, month, day);
        }
      } catch (e) {
        return null;
      }
    }

    // 2️⃣ الأشهر الهجرية بالاسم
    final hijriMonths = {
      'محرم': 1,
      'المحرم': 1,
      'صفر': 2,
      'الصفر': 2,
      'ربيع الأول': 3,
      'ربيع الاول': 3,
      'ربيع أول': 3,
      'ربيع الثاني': 4,
      'ربيع الآخر': 4,
      'ربيع ثاني': 4,
      'جمادى الأولى': 5,
      'جمادى الاولى': 5,
      'جمادى أولى': 5,
      'جمادى الثانية': 6,
      'جمادى الآخرة': 6,
      'جمادى ثانية': 6,
      'رجب': 7,
      'الرجب': 7,
      'شعبان': 8,
      'الشعبان': 8,
      'رمضان': 9,
      'الرمضان': 9,
      'شوال': 10,
      'الشوال': 10,
      'ذو القعدة': 11,
      'ذي القعدة': 11,
      'القعدة': 11,
      'ذو الحجة': 12,
      'ذي الحجة': 12,
      'الحجة': 12,
    };

    for (final entry in hijriMonths.entries) {
      final pattern = RegExp('(\\d+)[\\s]*${entry.key}[\\s]*(\\d{4})');
      final match = pattern.firstMatch(text);
      if (match != null) {
        try {
          final day = int.parse(match.group(1)!);
          final year = int.parse(match.group(2)!);
          return HijriCalendar.fromDate(
            DateTime.now(),
          ).hijriToGregorian(year, entry.value, day);
        } catch (e) {
          return null;
        }
      }
    }

    return null;
  }

  // تحويل اسم الشهر إلى رقم (إنجليزي + اختصارات)
  int _monthNameToNumber(String month) {
    final months = {
      'JAN': 1,
      'JANUARY': 1,
      'FEB': 2,
      'FEBRUARY': 2,
      'MAR': 3,
      'MARCH': 3,
      'APR': 4,
      'APRIL': 4,
      'MAY': 5,
      'JUN': 6,
      'JUNE': 6,
      'JUL': 7,
      'JULY': 7,
      'AUG': 8,
      'AUGUST': 8,
      'SEP': 9,
      'SEPT': 9,
      'SEPTEMBER': 9,
      'OCT': 10,
      'OCTOBER': 10,
      'NOV': 11,
      'NOVEMBER': 11,
      'DEC': 12,
      'DECEMBER': 12,
    };

    return months[month.toUpperCase()] ?? 1;
  }

  // تحليل التاريخ (يدعم جميع التنسيقات)
  DateTime? _parseDate(String day, String month, String year) {
    try {
      int y = int.parse(year);
      if (y < 100) y += 2000; // تحويل 25 إلى 2025

      final m = int.parse(month);
      final d = int.parse(day);

      // محاولة DD/MM/YYYY
      if (m >= 1 && m <= 12 && d >= 1 && d <= 31) {
        return DateTime(y, m, d);
      }

      // محاولة MM/DD/YYYY
      if (d >= 1 && d <= 12 && m >= 1 && m <= 31) {
        return DateTime(y, d, m);
      }
    } catch (e) {
      return null;
    }

    return null;
  }

  // تحديد حالة المنتج
  ProductStatus _determineStatus(DateTime? expiryDate) {
    if (expiryDate == null) {
      return ProductStatus.unclear;
    }

    final now = DateTime.now();
    final difference = expiryDate.difference(now);

    if (difference.isNegative) {
      return ProductStatus.expired;
    } else if (difference.inDays <= 30) {
      return ProductStatus.nearExpiry;
    } else {
      return ProductStatus.valid;
    }
  }
}
