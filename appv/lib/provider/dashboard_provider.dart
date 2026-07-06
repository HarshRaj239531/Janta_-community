import 'package:flutter/material.dart';
import '../api/dashboard_api.dart';
import '../models/dashboard_model.dart';
import '../helpers/api_helper.dart';

class DashboardProvider with ChangeNotifier {
  DashboardModel? _dashboard;
  bool _isLoading = false;
  String? _error;

  DashboardModel? get dashboard => _dashboard;
  bool get isLoading => _isLoading;
  String? get error => _error;

  // Quick accessors
  WalletModel? get wallet => _dashboard?.wallet;
  DashboardStatsModel? get stats => _dashboard?.stats;
  DashboardUserModel? get userInfo => _dashboard?.user;

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
