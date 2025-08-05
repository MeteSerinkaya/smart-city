import 'package:flutter/material.dart';
import 'package:smart_city/core/init/theme/app_theme.dart';

class ThemeNotifier extends ChangeNotifier {
  bool _isDarkMode = false;
  bool get isDarkMode => _isDarkMode;

  ThemeData get currentTheme => AppTheme.getTheme(_isDarkMode);

  void toggleTheme() {
    _isDarkMode = !_isDarkMode;
    notifyListeners();
  }

  void setTheme(bool isDark) {
    _isDarkMode = isDark;
    notifyListeners();
  }

  void setLightTheme() {
    _isDarkMode = false;
    notifyListeners();
  }

  void setDarkTheme() {
    _isDarkMode = true;
    notifyListeners();
  }
}
