import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../data/services/auth_service.dart';

class AuthProvider extends ChangeNotifier {
  final AuthService _authService = AuthService();
  String? _token;

  bool get isLoggedIn => _token != null;

  Future<bool> autoLogin() async {
    final prefs = await SharedPreferences.getInstance();
    if (!prefs.containsKey('token')) return false;
    _token = prefs.getString('token');
    notifyListeners();
    return true;
  }

  Future<bool> login(String email, String password) async {
    final result = await _authService.login(email, password);

    if (result != null) {
      // بنجيب التوكن سواء كان راجع باسم accessToken أو token
      final token = result['accessToken'] ?? result['token'];

      if (token != null) {
        _token = token;
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('token', _token!);
        notifyListeners();
        return true;
      }
    }
    return false;
  }

  Future<void> logout() async {
    _token = null;
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('token');
    notifyListeners();
  }
}
