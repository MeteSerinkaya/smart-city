import 'package:flutter/material.dart';
import 'package:smart_city/core/init/theme/app_theme.dart';

class AppThemeLight extends AppTheme {
  static final AppThemeLight _instance = AppThemeLight._init();
  static AppThemeLight get instance => _instance;

  AppThemeLight._init();

  @override
  ThemeData get theme => ThemeData.light();
}
