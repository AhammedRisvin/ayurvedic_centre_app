import 'package:shared_preferences/shared_preferences.dart';

class Store {
  static const _userToken = "userToken";

  static late SharedPreferences _preference;

  static DateTime now = DateTime.now();

  void reloadPreference() async {
    await _preference.reload();
  }

  static Future<void> init() async {
    _preference = await SharedPreferences.getInstance();
  }

  static Future<void> clear() async {
    await _preference.clear();
  }

  static String get userToken => _preference.getString(_userToken) ?? '';
  static set userToken(String value) => _preference.setString(_userToken, value);
}
