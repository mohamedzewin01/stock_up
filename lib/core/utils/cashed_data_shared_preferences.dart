import 'package:shared_preferences/shared_preferences.dart';

class CacheService {
  static late SharedPreferences sharedPreferences;

  static cacheInitialization() async {
    sharedPreferences = await SharedPreferences.getInstance();
  }

  static Future<bool> setData(
      {required String key, required dynamic value}) async {
    if (value is int) {
      await sharedPreferences.setInt(key, value);
      return true;
    }
    if (value is String) {
      await sharedPreferences.setString(key, value);
      return true;
    }
    if (value is double) {
      await sharedPreferences.setDouble(key, value);
      return true;
    }
    if (value is bool) {
      await sharedPreferences.setBool(key, value);
      return true;
    }
    return false;
  }

  static dynamic getData({required String key}) {
    return sharedPreferences.get(key);
  }

  static void deleteItem({required String key}) async {
    await sharedPreferences.remove(key);
  }

  static void clearItems() async {
    await sharedPreferences.clear();
  }
}


class CacheKeys {
  static const String defaultLanguage = 'defaultLanguage';
  static const String userId = 'userId';
  static const String userPhoto = 'userPhoto';
  static const String displayName = 'displayName';
  static const String token = 'token';
  static const String refreshToken = 'refreshToken';

  static const String userEmail = 'userEmail';
  static const String userGender = 'userGender';
  static const String userAge = 'userAge';
  static const String userPhone = 'userPhone';
  static const String userActive = 'userActive';



}

