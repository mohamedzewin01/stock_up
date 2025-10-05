class DateFormatter {
  static String formatDate(String dateString, {String languageCode = 'ar'}) {
    if (dateString.isEmpty) return _getNotSpecifiedText(languageCode);

    try {
      final date = DateTime.parse(dateString);
      if (languageCode == 'ar') {
        return '${_formatNumber(date.day)}/${_formatNumber(date.month)}/${_formatNumber(date.year)}';
      } else {
        return '${date.day}/${date.month}/${date.year}';
      }
    } catch (e) {
      return dateString;
    }
  }

  static String formatDateWithDayName(
    String dateString, {
    String languageCode = 'ar',
  }) {
    if (dateString.isEmpty) return _getNotSpecifiedText(languageCode);

    try {
      final date = DateTime.parse(dateString);
      final dayNames = _getDayNames(languageCode);
      final monthNames = _getMonthNames(languageCode);

      if (languageCode == 'ar') {
        return '${dayNames[date.weekday - 1]}، ${_formatNumber(date.day)} ${monthNames[date.month - 1]} ${_formatNumber(date.year)}';
      } else {
        return '${dayNames[date.weekday - 1]}, ${date.day} ${monthNames[date.month - 1]} ${date.year}';
      }
    } catch (e) {
      return dateString;
    }
  }

  /// تنسيق التاريخ بالأرقام العربية والشهر بالاسم
  static String formatDateArabic(
    String dateString, {
    String languageCode = 'ar',
  }) {
    if (dateString.isEmpty) return _getNotSpecifiedText(languageCode);

    try {
      final date = DateTime.parse(dateString);
      final monthNames = _getMonthNames(languageCode);

      if (languageCode == 'ar') {
        return '${_formatNumber(date.day)} ${monthNames[date.month - 1]} ${_formatNumber(date.year)}';
      } else {
        return '${date.day} ${monthNames[date.month - 1]} ${date.year}';
      }
    } catch (e) {
      return dateString;
    }
  }

  /// تنسيق التاريخ المختصر بالعربية
  static String formatDateShort(
    String dateString, {
    String languageCode = 'ar',
  }) {
    if (dateString.isEmpty) return _getNotSpecifiedText(languageCode);

    try {
      final date = DateTime.parse(dateString);
      final monthNames = _getMonthNames(languageCode);

      if (languageCode == 'ar') {
        return '${_formatNumber(date.day)} ${monthNames[date.month - 1]}';
      } else {
        return '${date.day} ${monthNames[date.month - 1]}';
      }
    } catch (e) {
      return dateString;
    }
  }

  /// تنسيق التاريخ للعرض في واجهة المستخدم (الأفضل للاستخدام)
  static String formatDateDisplay(
    String dateString, {
    String languageCode = 'ar',
  }) {
    if (dateString.isEmpty) return _getNotSpecifiedText(languageCode);

    try {
      final date = DateTime.parse(dateString);
      final monthNames = _getMonthNames(languageCode);

      if (languageCode == 'ar') {
        return '${_formatNumber(date.day)} ${monthNames[date.month - 1]} ${_formatNumber(date.year)}';
      } else {
        return '${date.day} ${monthNames[date.month - 1]} ${date.year}';
      }
    } catch (e) {
      return dateString;
    }
  }

  /// حساب العمر من تاريخ الميلاد
  static String calculateAge(
    String birthDateString, {
    String languageCode = 'ar',
  }) {
    if (birthDateString.isEmpty) return _getNotSpecifiedText(languageCode);

    try {
      final birthDate = DateTime.parse(birthDateString);
      final now = DateTime.now();

      int years = now.year - birthDate.year;
      int months = now.month - birthDate.month;

      if (months < 0) {
        years--;
        months += 12;
      }

      if (now.day < birthDate.day) {
        months--;
        if (months < 0) {
          years--;
          months += 12;
        }
      }

      return _formatAge(years, months, languageCode);
    } catch (e) {
      return _getNotSpecifiedText(languageCode);
    }
  }

  /// تنسيق الوقت مع التاريخ
  static String formatDateTime(
    String dateTimeString, {
    String languageCode = 'ar',
  }) {
    if (dateTimeString.isEmpty) return _getNotSpecifiedText(languageCode);

    try {
      final dateTime = DateTime.parse(dateTimeString);
      final monthNames = _getMonthNames(languageCode);

      final hour = dateTime.hour > 12 ? dateTime.hour - 12 : dateTime.hour;
      final period = _getPeriod(dateTime.hour, languageCode);

      if (languageCode == 'ar') {
        return '${_formatNumber(dateTime.day)} ${monthNames[dateTime.month - 1]} ${_formatNumber(dateTime.year)} - ${_formatNumber(hour == 0 ? 12 : hour)}:${_formatNumber(dateTime.minute).padLeft(2, '٠')} $period';
      } else {
        return '${dateTime.day} ${monthNames[dateTime.month - 1]} ${dateTime.year} - ${hour == 0 ? 12 : hour}:${dateTime.minute.toString().padLeft(2, '0')} $period';
      }
    } catch (e) {
      return dateTimeString;
    }
  }

  // ===== Helper Methods =====

  /// الحصول على أسماء الأيام حسب اللغة
  static List<String> _getDayNames(String languageCode) {
    if (languageCode == 'ar') {
      return [
        'الإثنين',
        'الثلاثاء',
        'الأربعاء',
        'الخميس',
        'الجمعة',
        'السبت',
        'الأحد',
      ];
    } else {
      return [
        'Monday',
        'Tuesday',
        'Wednesday',
        'Thursday',
        'Friday',
        'Saturday',
        'Sunday',
      ];
    }
  }

  /// الحصول على أسماء الشهور حسب اللغة
  static List<String> _getMonthNames(String languageCode) {
    if (languageCode == 'ar') {
      return [
        'يناير',
        'فبراير',
        'مارس',
        'أبريل',
        'مايو',
        'يونيو',
        'يوليو',
        'أغسطس',
        'سبتمبر',
        'أكتوبر',
        'نوفمبر',
        'ديسمبر',
      ];
    } else {
      return [
        'January',
        'February',
        'March',
        'April',
        'May',
        'June',
        'July',
        'August',
        'September',
        'October',
        'November',
        'December',
      ];
    }
  }

  /// الحصول على نص "غير محدد" حسب اللغة
  static String _getNotSpecifiedText(String languageCode) {
    if (languageCode == 'ar') {
      return 'غير محدد';
    } else {
      return 'Not specified';
    }
  }

  /// تنسيق العمر حسب اللغة
  static String _formatAge(int years, int months, String languageCode) {
    if (languageCode == 'ar') {
      if (years > 0 && months > 0) {
        return '${_formatNumber(years)} سنة و ${_formatNumber(months)} شهر';
      } else if (years > 0) {
        return '${_formatNumber(years)} سنة';
      } else if (months > 0) {
        return '${_formatNumber(months)} شهر';
      } else {
        return 'أقل من شهر';
      }
    } else {
      if (years > 0 && months > 0) {
        return '$years ${years == 1 ? 'year' : 'years'} - $months ${months == 1 ? 'month' : 'months'}';
      } else if (years > 0) {
        return '$years ${years == 1 ? 'year' : 'years'}';
      } else if (months > 0) {
        return '$months ${months == 1 ? 'month' : 'months'}';
      } else {
        return 'Less than a month';
      }
    }
  }

  /// الحصول على فترة الوقت (صباحاً/مساءً) حسب اللغة
  static String _getPeriod(int hour, String languageCode) {
    if (languageCode == 'ar') {
      return hour >= 12 ? 'مساءً' : 'صباحاً';
    } else {
      return hour >= 12 ? 'PM' : 'AM';
    }
  }

  /// تحويل الأرقام الإنجليزية إلى عربية
  static String _formatNumber(int number) {
    const arabicNumbers = ['٠', '١', '٢', '٣', '٤', '٥', '٦', '٧', '٨', '٩'];
    String result = '';

    for (int i = 0; i < number.toString().length; i++) {
      int digit = int.parse(number.toString()[i]);
      result += arabicNumbers[digit];
    }

    return result;
  }

  /// تحويل نص يحتوي على أرقام إنجليزية إلى عربية
  static String convertToArabicNumbers(String text) {
    const englishNumbers = ['0', '1', '2', '3', '4', '5', '6', '7', '8', '9'];
    const arabicNumbers = ['٠', '١', '٢', '٣', '٤', '٥', '٦', '٧', '٨', '٩'];

    String result = text;
    for (int i = 0; i < englishNumbers.length; i++) {
      result = result.replaceAll(englishNumbers[i], arabicNumbers[i]);
    }

    return result;
  }

  /// التحقق من صحة صيغة التاريخ
  static bool isValidDate(String dateString) {
    if (dateString.isEmpty) return false;

    try {
      DateTime.parse(dateString);
      return true;
    } catch (e) {
      return false;
    }
  }

  /// تنسيق التاريخ الهجري (إذا كان مطلوباً)
  static String formatHijriDate(
    String dateString, {
    String languageCode = 'ar',
  }) {
    // يمكن إضافة تحويل للتاريخ الهجري هنا إذا كان مطلوباً
    // باستخدام مكتبة خاصة بالتقويم الهجري
    return formatDateDisplay(dateString, languageCode: languageCode);
  }
}
