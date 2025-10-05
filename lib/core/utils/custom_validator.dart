class CustomValidator {

  static String? validateAge(String? value, {String? emptyMessage, String? invalidMessage}) {
    emptyMessage ??= "Please enter your age.";
    invalidMessage ??= "Age must be between 1 and 20.";

    if (value == null || value.isEmpty) {
      return emptyMessage;
    }

    final parsedValue = int.tryParse(value.trim());
    if (parsedValue == null || parsedValue > 20 || parsedValue <= 0) {
      return invalidMessage;
    }

    return null;
  }

  static String? arabicNameValidator(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'الرجاء إدخال الاسم';
    }

    // تحقق من الحروف العربية فقط بدون مسافات
    final regex = RegExp(r'^[\u0600-\u06FF]+$');

    if (!regex.hasMatch(value.trim())) {
      return 'الاسم يجب أن يحتوي على حروف عربية فقط وبدون مسافات';
    }

    return null;
  }


}

