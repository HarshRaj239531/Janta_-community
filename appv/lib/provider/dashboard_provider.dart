import 'package:flutter/material.dart';
import '../api/dashboard_api.dart';
import '../models/dashboard_model.dart';
import '../helpers/api_helper.dart';
import '../helpers/shared_prefs_helper.dart';

class DashboardProvider with ChangeNotifier {
  DashboardModel? _dashboard;
  bool _isLoading = false;
  String? _error;
  String? _cachedUserName; // Loaded from SharedPrefs immediately on init

  DashboardProvider() {
    _loadCachedUserName();
  }

  Future<void> _loadCachedUserName() async {
    _cachedUserName = await SharedPrefsHelper.getUserName();
    notifyListeners();
  }

  DashboardModel? get dashboard => _dashboard;
  bool get isLoading => _isLoading;
  String? get error => _error;

  // Quick accessors
  WalletModel? get wallet => _dashboard?.wallet;
  DashboardStatsModel? get stats => _dashboard?.stats;
  DashboardUserModel? get userInfo => _dashboard?.user;

  /// Returns user name — prefers live API data, falls back to SharedPrefs cached name
  String get userName {
    final apiName = _dashboard?.user.name;
    if (apiName != null && apiName.isNotEmpty) return apiName;
    if (_cachedUserName != null && _cachedUserName!.isNotEmpty) return _cachedUserName!;
    return 'User';
  }

  Future<void> fetchDashboard() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      _dashboard = await DashboardApi.getDashboard();
      _isLoading = false;
      notifyListeners();
    } on ApiException catch (e) {
      _error = e.message;
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _error = 'Failed to load dashboard';
      _isLoading = false;
      notifyListeners();
    }
  }

  void clear() {
    _dashboard = null;
    _isLoading = false;
    _error = null;
    notifyListeners();
  }
}
