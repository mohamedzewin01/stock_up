// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:qassimha/core/utils/cashed_data_shared_preferences.dart';
//
//
//
// class LocaleCubit extends Cubit<Locale> {
//   LocaleCubit() : super(const Locale('ar')) {
//     _loadSavedLanguage();
//   }
//
// static LocaleCubit get(context) => BlocProvider.of(context);
//
//   void changeLanguage(String languageCode) async {
//     emit(Locale(languageCode));
//     await CacheService.setData(
//         key: CacheKeys.defaultLanguage, value: languageCode);
//   }
//
//   String changeFontFamily() {
//     return state.languageCode == 'ar' ? 'NotoSansArabic' : 'Roboto';
//   }
//
//   void _loadSavedLanguage() {
//     final savedLanguage =
//         CacheService.getData(key: CacheKeys.defaultLanguage) ?? 'en';
//     emit(Locale(savedLanguage));
//   }
// }


// تأكد من أن LocaleCubit محدد بشكل صحيح
// lib/localization/locale_cubit.dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LocaleCubit extends Cubit<Locale> {
  LocaleCubit() : super(const Locale('ar'));

  static LocaleCubit get(context) => BlocProvider.of(context);

  void changeLanguage(String languageCode) async {
    print('Changing language to: $languageCode'); // للتدبيق

    final newLocale = Locale(languageCode);
    emit(newLocale);

    // حفظ اللغة في SharedPreferences
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('language_code', languageCode);

    print('Language saved: $languageCode'); // للتدبيق
  }

  void loadSavedLanguage() async {
    final prefs = await SharedPreferences.getInstance();
    final savedLanguage = prefs.getString('language_code') ?? 'ar';

    print('Loading saved language: $savedLanguage'); // للتدبيق
    emit(Locale(savedLanguage));
  }
}