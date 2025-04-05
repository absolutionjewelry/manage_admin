import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/token.dart';

enum AuthKeys { token }

class AuthStorage {
  static Future<void> setToken(Token token) async {
    var prefs = await SharedPreferences.getInstance();
    var tokenJson = jsonEncode(token.toJson());
    await prefs.setString(AuthKeys.token.name, tokenJson);
  }

  static Future<Token?> getToken() async {
    var prefs = await SharedPreferences.getInstance();
    var tokenJson = prefs.getString(AuthKeys.token.name);
    if (tokenJson == null) {
      return null;
    }
    return Token.fromJson(jsonDecode(tokenJson));
  }

  static Future<void> clearToken() async {
    var prefs = await SharedPreferences.getInstance();
    await prefs.remove(AuthKeys.token.name);
  }
}
