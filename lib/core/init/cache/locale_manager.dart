import 'package:shared_preferences/shared_preferences.dart';
import 'package:smart_city/core/constants/enums/locale_keys_enum.dart';

class LocaleManager {
  static final LocaleManager _instance = LocaleManager._internal();
  late SharedPreferences _preferences;

  static LocaleManager get instance => _instance;

  LocaleManager._internal();

  /// Asenkron başlatma fonksiyonu - uygulama başlangıcında çağrılmalı.
  static Future<void> init() async {
    _instance._preferences = await SharedPreferences.getInstance();
  }

  Future<void> setStringValue(PreferencesKeys key, String value) async {
    await _preferences.setString(key.toString(), value);
  }

  String? getStringValue(PreferencesKeys key) {
    return _preferences.getString(key.toString());
  }

  Future<void> setBoolValue(PreferencesKeys key, bool value) async {
    await _preferences.setBool(key.toString(), value);
  }

  bool getBoolValue(PreferencesKeys key) {
    return _preferences.getBool(key.toString()) ?? false;
  }
}
