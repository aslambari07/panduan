import 'package:flutter/material.dart';
import 'package:anekapanduan/utils/shared_prefs.dart';

class AppSettingsManager extends ChangeNotifier {
  bool _isDark = AppSharedPrefs.getAppThemeMode();
  bool _isNotificationsEnabled = AppSharedPrefs.isNotificationEnabled();
  Locale appLocale = Locale(AppSharedPrefs.getAppLocale());

  ThemeMode _themeMode =
      AppSharedPrefs.getAppThemeMode() ? ThemeMode.dark : ThemeMode.light;

  bool get isDarkMode => _isDark;
  bool get isNotificationEnabled => _isNotificationsEnabled;

  ThemeMode get themeMode => _themeMode;

  updateAppLocale(Locale locale) {
    appLocale = locale;
    AppSharedPrefs.updateAppLocale(locale.languageCode);
    notifyListeners();
  }

  updateTheme(value) {
    _isDark = value;
    _themeMode = value ? ThemeMode.dark : ThemeMode.light;
    AppSharedPrefs.updateAppThemeMode(value);
    notifyListeners();
  }

  updateNotifications(value) {
    _isNotificationsEnabled = value;
    AppSharedPrefs.updateNotificationState(value);
    notifyListeners();
  }
}
