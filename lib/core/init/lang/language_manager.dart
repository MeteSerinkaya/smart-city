import 'dart:ui';

class LanguageManager {
  static final LanguageManager _instance = LanguageManager._init();
  static LanguageManager get instance => _instance;

  LanguageManager._init();

  final enLocale = Locale("en", "US");
  List<Locale> get supportedLocales => [enLocale];
}
