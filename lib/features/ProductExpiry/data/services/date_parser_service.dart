// lib/features/ProductExpiry/data/services/date_parser_service.dart

import 'package:flutter/foundation.dart';
import 'package:hijri/hijri_calendar.dart';

import '../../domain/entities/date_scan_result.dart';

class DateParserService {
  DateScanResult parseText(String text) {
    debugPrint('🔍 === بدء تحليل النص ===');
    debugPrint('📄 النص الأصلي: $text');

    final cleanedText = _cleanText(text);
    debugPrint('🧹 النص بعد التنظيف: $cleanedText');

    DateTime? expiryDate;
    DateTime? mfgDate;
    DateTime? bestBefore;
    Duration? validityPeriod;

    // 1️⃣ البحث عن تاريخ الانتهاء (أعلى أولوية)
    expiryDate = _findExpiryDate(cleanedText, text);
    if (expiryDate != null) {
      debugPrint('✅ تاريخ الانتهاء: $expiryDate');
    }

    // 2️⃣ البحث عن تاريخ الإنتاج
    if (expiryDate == null) {
      mfgDate = _findManufacturingDate(cleanedText, text);
      if (mfgDate != null) {
        debugPrint('✅ تاريخ الإنتاج: $mfgDate');
      }
    }

    // 3️⃣ البحث عن مدة الصلاحية
    validityPeriod = _findValidityPeriod(cleanedText, text);
    if (validityPeriod != null) {
      debugPrint('✅ مدة الصلاحية: ${validityPeriod.inDays} يوم');
    }

    // 4️⃣ حساب تاريخ الانتهاء من الإنتاج
    if (expiryDate == null && mfgDate != null && validityPeriod != null) {
      expiryDate = mfgDate.add(validityPeriod);
      debugPrint('✅ تاريخ الانتهاء المحسوب: $expiryDate');
    }

    // 5️⃣ البحث عن Best Before
    if (expiryDate == null) {
      bestBefore = _findBestBeforeDate(cleanedText, text);
      if (bestBefore != null) {
        debugPrint('✅ Best Before: $bestBefore');
      }
    }

    // 6️⃣ محاولة أخيرة: أي تاريخ
    if (expiryDate == null && mfgDate == null && bestBefore == null) {
      expiryDate = _findAnyDate(cleanedText, text);
      if (expiryDate != null) {
        debugPrint('✅ تاريخ عام: $expiryDate');
      }
    }

    final dateToCheck = expiryDate ?? bestBefore;
    final status = _determineStatus(dateToCheck);
    final daysUntilExpiry = dateToCheck != null
        ? dateToCheck.difference(DateTime.now()).inDays
        : null;

    debugPrint('📊 الحالة: ${status.label}');
    debugPrint('🔍 === انتهى التحليل ===\n');

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

  // ✅ تنظيف النص - نسخة محسّنة
  String _cleanText(String text) {
    // تحويل الأرقام العربية
    final arabicMap = {
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

    String result = text;
    arabicMap.forEach((k, v) => result = result.replaceAll(k, v));

    // تحويل إلى uppercase
    result = result.toUpperCase();

    // استبدال الفواصل بمسافات (لكن احتفظ بنسخة أصلية للأنماط المحددة)
    result = result
        .replaceAll('\n', ' ')
        .replaceAll(RegExp(r'[\/\-\.\:]'), ' ')
        .replaceAll(RegExp(r'\s+'), ' ')
        .trim();

    return result;
  }

  // ✅ البحث عن تاريخ الانتهاء - نسخة شاملة
  DateTime? _findExpiryDate(String cleaned, String original) {
    // 1️⃣ EXP مع أرقام متصلة: EXP100325, EXP10032025
    final expCompact = RegExp(r'EXP\s*(\d{6,8})', caseSensitive: false);
    var match = expCompact.firstMatch(cleaned);
    if (match != null) {
      final date = _parseCompactDate(match.group(1)!);
      if (date != null) {
        debugPrint('🎯 نمط: EXP مدمج');
        return date;
      }
    }

    // 2️⃣ EXP مع فواصل: EXP 10 03 2025, EXP:10/03/2025
    final expSeparated = RegExp(
      r'EXP\w*\s*(\d{1,2})\s+(\d{1,2})\s+(\d{2,4})',
      caseSensitive: false,
    );
    match = expSeparated.firstMatch(cleaned);
    if (match != null) {
      final date = _parseDate(
        match.group(1)!,
        match.group(2)!,
        match.group(3)!,
      );
      if (date != null) {
        debugPrint('🎯 نمط: EXP مع مسافات');
        return date;
      }
    }

    // 3️⃣ نفس الشيء لكن في النص الأصلي (قبل إزالة الفواصل)
    final expOriginal = RegExp(
      r'EXP\w*[:\s]*(\d{1,2})[\/\-\.](\d{1,2})[\/\-\.](\d{2,4})',
      caseSensitive: false,
    );
    match = expOriginal.firstMatch(original);
    if (match != null) {
      final date = _parseDate(
        match.group(1)!,
        match.group(2)!,
        match.group(3)!,
      );
      if (date != null) {
        debugPrint('🎯 نمط: EXP مع فواصل أصلية');
        return date;
      }
    }

    // 4️⃣ EXPIRY / EXPIRATION
    final expiryPatterns = [
      r'EXPIR[YED]*\s+(\d{1,2})\s+(\d{1,2})\s+(\d{2,4})',
      r'EXPIRATION\s+(\d{1,2})\s+(\d{1,2})\s+(\d{2,4})',
    ];

    for (final pattern in expiryPatterns) {
      match = RegExp(pattern, caseSensitive: false).firstMatch(cleaned);
      if (match != null) {
        final date = _parseDate(
          match.group(1)!,
          match.group(2)!,
          match.group(3)!,
        );
        if (date != null) {
          debugPrint('🎯 نمط: EXPIRY');
          return date;
        }
      }
    }

    // 5️⃣ أنماط عربية
    final arabicPatterns = [
      r'انتهاء\s+(\d{1,2})\s+(\d{1,2})\s+(\d{2,4})',
      r'صالح\s+حتى\s+(\d{1,2})\s+(\d{1,2})\s+(\d{2,4})',
      r'صلاحية\s+(\d{1,2})\s+(\d{1,2})\s+(\d{2,4})',
    ];

    for (final pattern in arabicPatterns) {
      match = RegExp(pattern).firstMatch(cleaned);
      if (match != null) {
        final date = _parseDate(
          match.group(1)!,
          match.group(2)!,
          match.group(3)!,
        );
        if (date != null) {
          debugPrint('🎯 نمط: عربي');
          return date;
        }
      }
    }

    // 6️⃣ شهر بالاسم + سنة: OCT 2025, OCTOBER 2025
    final monthYear = _findMonthYearDate(cleaned, original);
    if (monthYear != null) {
      debugPrint('🎯 نمط: شهر/سنة بالاسم');
      return monthYear;
    }

    // 7️⃣ تاريخ هجري
    final hijri = _parseHijriDate(cleaned, original);
    if (hijri != null) {
      debugPrint('🎯 نمط: هجري');
      return hijri;
    }

    debugPrint('⚠️ لم يتم العثور على تاريخ انتهاء');
    return null;
  }

  // ✅ تحليل تاريخ مدمج
  DateTime? _parseCompactDate(String compact) {
    if (compact.length == 6) {
      // DDMMYY: 100325
      int day = int.parse(compact.substring(0, 2));
      int month = int.parse(compact.substring(2, 4));
      int year = 2000 + int.parse(compact.substring(4, 6));

      if (_isValidDate(day, month, year)) {
        return DateTime(year, month, day);
      }

      // YYMMDD: 250310
      int year2 = 2000 + int.parse(compact.substring(0, 2));
      int month2 = int.parse(compact.substring(2, 4));
      int day2 = int.parse(compact.substring(4, 6));

      if (_isValidDate(day2, month2, year2)) {
        return DateTime(year2, month2, day2);
      }
    } else if (compact.length == 8) {
      // DDMMYYYY: 10032025
      int day = int.parse(compact.substring(0, 2));
      int month = int.parse(compact.substring(2, 4));
      int year = int.parse(compact.substring(4, 8));

      if (_isValidDate(day, month, year)) {
        return DateTime(year, month, day);
      }

      // YYYYMMDD: 20250310
      int year2 = int.parse(compact.substring(0, 4));
      int month2 = int.parse(compact.substring(4, 6));
      int day2 = int.parse(compact.substring(6, 8));

      if (_isValidDate(day2, month2, year2)) {
        return DateTime(year2, month2, day2);
      }
    }

    return null;
  }

  // ✅ شهر/سنة بالاسم
  DateTime? _findMonthYearDate(String cleaned, String original) {
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

    for (final entry in months.entries) {
      // بحث في النص المنظف
      var pattern = RegExp('${entry.key}\\s+(\\d{4})', caseSensitive: false);
      var match = pattern.firstMatch(cleaned);
      if (match != null) {
        return DateTime(int.parse(match.group(1)!), entry.value);
      }

      // بحث في النص الأصلي
      match = pattern.firstMatch(original);
      if (match != null) {
        return DateTime(int.parse(match.group(1)!), entry.value);
      }
    }

    return null;
  }

  // ✅ تحليل تاريخ عادي
  DateTime? _parseDate(String d, String m, String y) {
    try {
      int day = int.parse(d);
      int month = int.parse(m);
      int year = int.parse(y);

      if (year < 100) year += 2000;

      // DD/MM/YYYY
      if (_isValidDate(day, month, year)) {
        return DateTime(year, month, day);
      }

      // MM/DD/YYYY
      if (_isValidDate(month, day, year)) {
        return DateTime(year, day, month);
      }
    } catch (e) {
      return null;
    }

    return null;
  }

  // ✅ التحقق من صحة التاريخ
  bool _isValidDate(int day, int month, int year) {
    if (month < 1 || month > 12) return false;
    if (day < 1 || day > 31) return false;
    if (year < 2020 || year > 2050) return false;

    // التحقق من الشهور ذات 30 يوم
    if ([4, 6, 9, 11].contains(month) && day > 30) return false;

    // فبراير
    if (month == 2) {
      final isLeap = (year % 4 == 0 && year % 100 != 0) || (year % 400 == 0);
      if (day > (isLeap ? 29 : 28)) return false;
    }

    return true;
  }

  // ✅ البحث عن تاريخ الإنتاج
  DateTime? _findManufacturingDate(String cleaned, String original) {
    final patterns = [
      r'MFG\s+(\d{1,2})\s+(\d{1,2})\s+(\d{2,4})',
      r'MFD\s+(\d{1,2})\s+(\d{1,2})\s+(\d{2,4})',
      r'انتاج\s+(\d{1,2})\s+(\d{1,2})\s+(\d{2,4})',
    ];

    for (final pattern in patterns) {
      final match = RegExp(pattern, caseSensitive: false).firstMatch(cleaned);
      if (match != null) {
        return _parseDate(match.group(1)!, match.group(2)!, match.group(3)!);
      }
    }

    return null;
  }

  // ✅ Best Before
  DateTime? _findBestBeforeDate(String cleaned, String original) {
    final patterns = [
      r'BEST\s+BEFORE\s+(\d{1,2})\s+(\d{1,2})\s+(\d{2,4})',
      r'BEST\s+BY\s+(\d{1,2})\s+(\d{1,2})\s+(\d{2,4})',
      r'BB\s+(\d{1,2})\s+(\d{1,2})\s+(\d{2,4})',
    ];

    for (final pattern in patterns) {
      final match = RegExp(pattern, caseSensitive: false).firstMatch(cleaned);
      if (match != null) {
        return _parseDate(match.group(1)!, match.group(2)!, match.group(3)!);
      }
    }

    return null;
  }

  // ✅ البحث عن أي تاريخ
  DateTime? _findAnyDate(String cleaned, String original) {
    // محاولة في النص المنظف
    var pattern = RegExp(r'(\d{1,2})\s+(\d{1,2})\s+(\d{4})');
    var match = pattern.firstMatch(cleaned);

    if (match != null) {
      final date = _parseDate(
        match.group(1)!,
        match.group(2)!,
        match.group(3)!,
      );
      if (date != null) return date;
    }

    // محاولة في النص الأصلي
    pattern = RegExp(r'(\d{1,2})[\/\-\.](\d{1,2})[\/\-\.](\d{2,4})');
    match = pattern.firstMatch(original);

    if (match != null) {
      final date = _parseDate(
        match.group(1)!,
        match.group(2)!,
        match.group(3)!,
      );
      if (date != null && date.isAfter(DateTime.now())) {
        return date;
      }
    }

    // MM/YYYY أو MM YYYY
    pattern = RegExp(r'(\d{1,2})\s+(\d{4})');
    match = pattern.firstMatch(cleaned);

    if (match != null) {
      final month = int.parse(match.group(1)!);
      final year = int.parse(match.group(2)!);
      if (month >= 1 && month <= 12) {
        return DateTime(year, month);
      }
    }

    return null;
  }

  // ✅ مدة الصلاحية
  Duration? _findValidityPeriod(String cleaned, String original) {
    // سنوات
    var pattern = RegExp(r'(\d+)\s*(?:سنة|سنوات|YEARS?)', caseSensitive: false);
    var match = pattern.firstMatch(cleaned);
    if (match != null) {
      return Duration(days: int.parse(match.group(1)!) * 365);
    }

    // شهور
    pattern = RegExp(r'(\d+)\s*(?:شهر|شهور|MONTHS?)', caseSensitive: false);
    match = pattern.firstMatch(cleaned);
    if (match != null) {
      return Duration(days: int.parse(match.group(1)!) * 30);
    }

    return null;
  }

  // ✅ تاريخ هجري
  DateTime? _parseHijriDate(String cleaned, String original) {
    final pattern = RegExp(r'(\d{1,2})\s+(\d{1,2})\s+(\d{4})');
    final match = pattern.firstMatch(cleaned);

    if (match != null) {
      try {
        final day = int.parse(match.group(1)!);
        final month = int.parse(match.group(2)!);
        final year = int.parse(match.group(3)!);

        if (year >= 1440 && year <= 1500 && month >= 1 && month <= 12) {
          return HijriCalendar.fromDate(
            DateTime.now(),
          ).hijriToGregorian(year, month, day);
        }
      } catch (e) {
        return null;
      }
    }

    return null;
  }

  // تحديد الحالة
  ProductStatus _determineStatus(DateTime? expiryDate) {
    if (expiryDate == null) return ProductStatus.unclear;

    final difference = expiryDate.difference(DateTime.now());

    if (difference.isNegative) {
      return ProductStatus.expired;
    } else if (difference.inDays <= 30) {
      return ProductStatus.nearExpiry;
    } else {
      return ProductStatus.valid;
    }
  }
}
