import 'package:shared_preferences/shared_preferences.dart';

class StorageService {
  static Future<void> saveToken(String token) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('jwt_token', token);
  }

  static Future<String> getSavedToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('jwt_token') ?? '';
  }

  static Future<void> clearToken() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('jwt_token');
  }

  static Future<void> saveUserLogin(String login) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('user_login', login);
  }

  static Future<String?> getUserLogin() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('user_login');
  }
}
