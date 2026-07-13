import 'package:flutter/material.dart';
import '../helpers/api_helper.dart';
import '../helpers/api_constants.dart';
import '../models/notification_model.dart';

class NotificationProvider with ChangeNotifier {
  List<NotificationModel> _notifications = [];
  bool _isLoading = false;
  String? _error;

  List<NotificationModel> get notifications => _notifications;
  bool get isLoading => _isLoading;
  String? get error => _error;

  Future<void> fetchNotifications() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final res = await ApiHelper.get(ApiConstants.notifications);
      if (res is List) {
        _notifications = res.map((e) => NotificationModel.fromJson(e as Map<String, dynamic>)).toList();
      } else {
        _error = 'Failed to load notifications';
      }
    } catch (e) {
      _error = 'Failed to fetch notifications';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
