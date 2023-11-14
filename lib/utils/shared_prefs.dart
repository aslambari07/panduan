import 'package:anekapanduan/utils/constants.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AppSharedPrefs {
  static late SharedPreferences _sharedPreferences;
  static const String themeModePrefKey = 'APP_THEME_MODE';
  static const String notificationPrefsKey = 'APP-NOTIFICATIONS';
  static const String appLocaleKey = 'APP-LOCALE';
  static const String appLoginSkippedKey = 'APP-LOGIN';

  static Future<void> initSharedPrefs() async {
    _sharedPreferences = await SharedPreferences.getInstance();
  }

  static bool getAppThemeMode() {
    return _sharedPreferences.getBool(themeModePrefKey) ?? false;
  }

  static updateAppThemeMode(bool value) {
    _sharedPreferences.setBool(themeModePrefKey, value);
  }

  static bool isNotificationEnabled() {
    return _sharedPreferences.getBool(notificationPrefsKey) ?? true;
  }

  static updateNotificationState(bool value) {
    _sharedPreferences.setBool(notificationPrefsKey, value);
  }

  static String getAppLocale() {
    return _sharedPreferences.getString(appLocaleKey) ??
        defaultAppLanguage.languageCode;
  }

  static updateAppLocale(String value) {
    _sharedPreferences.setString(appLocaleKey, value);
  }

  static updateAppLoginSkipped(value) {
    _sharedPreferences.setBool(appLoginSkippedKey, value);
  }

  static bool isLoginSkipped() {
    return _sharedPreferences.getBool(appLoginSkippedKey) ?? false;
  }
}
