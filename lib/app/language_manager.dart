import 'package:shared_preferences/shared_preferences.dart';

class LanguageManager {
  static const String _languageKey = 'language';

  Future<void> setLanguage(String lang) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString(_languageKey, lang);
  }

  Future<String?> getLanguage() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(_languageKey);
  }
}
