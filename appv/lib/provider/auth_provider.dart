import 'package:flutter/material.dart';
import '../api/auth_api.dart';
import '../models/user_model.dart';
import '../helpers/shared_prefs_helper.dart';
import '../helpers/api_helper.dart';

class AuthProvider with ChangeNotifier {
  UserModel? _user;
  bool _isLoading = false;
  String? _error;
  bool _isLoggedIn = false;

  UserModel? get user => _user;
  bool get isLoading => _isLoading;
  String? get error => _error;
  bool get isLoggedIn => _isLoggedIn;

  /// Check if user is already logged in (has saved token)
  Future<bool> checkLoginStatus() async {
    _isLoggedIn = await SharedPrefsHelper.isLoggedIn();
    notifyListeners();
    return _isLoggedIn;
  }

  /// Login with email/phone + password
  Future<bool> login(String loginId, String password) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final result = await AuthApi.login(loginId, password);
      _user = result['user'] as UserModel;
      final token = result['token'] as String;

      // Save token and user info
      await SharedPrefsHelper.saveToken(token);
      await SharedPrefsHelper.saveUserInfo(
        id: _user!.id,
        name: _user!.name,
        email: _user!.email,
        phone: _user!.phone,
        role: _user!.roleName,
      );

      _isLoggedIn = true;
      _isLoading = false;
      notifyListeners();
      return true;
    } on ApiException catch (e) {
      _error = e.message;
      _isLoading = false;
      notifyListeners();
      return false;
    } catch (e) {
      _error = 'Something went wrong. Please try again.';
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  /// Logout — clear token and user data
  Future<void> logout() async {
    _isLoading = true;
    notifyListeners();

    try {
      await AuthApi.logout();
    } catch (_) {
      // Logout even if API call fails
    }

    await SharedPrefsHelper.clearAll();
    _user = null;
    _isLoggedIn = false;
    _isLoading = false;
    _error = null;
    notifyListeners();
  }

  void clearError() {
    _error = null;
    notifyListeners();
  }
}
