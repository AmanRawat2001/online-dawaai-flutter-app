import 'package:shared_preferences/shared_preferences.dart';

class TokenStorage {
  static const String _tokenKey = 'token';

  // Save token
  static Future<void> saveToken(String token) async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    await pref.setString(_tokenKey, token);
  }

  // Retrieve token
  static Future<String?> getToken() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    return pref.getString(_tokenKey);
  }

  // Clear token
  static Future<void> clearToken() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    await pref.remove(_tokenKey);
  }

  // Check if token exists
  static Future<bool> hasToken() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    return pref.containsKey(_tokenKey);
  }
}
