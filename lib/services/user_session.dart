import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class UserSession {
  static const String _userKey = 'logged_in_user';
  static const String _tokenKey = 'auth_token';
  
  static Map<String, dynamic>? _currentUser;
  static String? _currentToken;

  // Save user session after login
  static Future<void> saveUserSession({
    required Map<String, dynamic> userData,
    required String token,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_userKey, jsonEncode(userData));
    await prefs.setString(_tokenKey, token);
    
    _currentUser = userData;
    _currentToken = token;
  }

  // Get current user data
  static Future<Map<String, dynamic>?> getCurrentUser() async {
    if (_currentUser != null) return _currentUser;
    
    final prefs = await SharedPreferences.getInstance();
    final userJson = prefs.getString(_userKey);
    
    if (userJson != null) {
      _currentUser = jsonDecode(userJson);
      return _currentUser;
    }
    
    return null;
  }

  // Get current user ID
  static Future<int?> getCurrentUserId() async {
    final user = await getCurrentUser();
    return user?['id'];
  }

  // Get current token
  static Future<String?> getCurrentToken() async {
    if (_currentToken != null) return _currentToken;
    
    final prefs = await SharedPreferences.getInstance();
    _currentToken = prefs.getString(_tokenKey);
    return _currentToken;
  }

  // Check if user is logged in
  static Future<bool> isLoggedIn() async {
    final user = await getCurrentUser();
    final token = await getCurrentToken();
    return user != null && token != null;
  }

  // Clear user session (logout)
  static Future<void> clearSession() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_userKey);
    await prefs.remove(_tokenKey);
    
    _currentUser = null;
    _currentToken = null;
  }
}