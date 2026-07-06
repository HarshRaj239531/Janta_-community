import 'package:flutter/material.dart';
import '../api/lottery_api.dart';
import '../models/lottery_model.dart';
import '../helpers/api_helper.dart';

class LotteryProvider with ChangeNotifier {
  List<LotteryModel> _winners = [];
  List<LotteryModel> _history = [];
  bool _isLoading = false;
  String? _error;
  int _currentPage = 1;
  bool _hasMore = true;

  List<LotteryModel> get winners => _winners;
  List<LotteryModel> get history => _history;
  bool get isLoading => _isLoading;
  String? get error => _error;
  bool get hasMore => _hasMore;

  /// Fetch recent winners
  Future<void> fetchWinners() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      _winners = await LotteryApi.getWinners();
      _isLoading = false;
      notifyListeners();
    } on ApiException catch (e) {
      _error = e.message;
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _error = 'Failed to load winners';
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Fetch lottery history (paginated)
  Future<void> fetchHistory({bool refresh = false}) async {
    if (refresh) {
      _currentPage = 1;
      _history = [];
      _hasMore = true;
    }
    if (!_hasMore) return;

    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final newItems = await LotteryApi.getHistory(page: _currentPage);
      if (newItems.isEmpty) {
        _hasMore = false;
      } else {
        _history.addAll(newItems);
        _currentPage++;
      }
      _isLoading = false;
      notifyListeners();
    } on ApiException catch (e) {
      _error = e.message;
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _error = 'Failed to load history';
      _isLoading = false;
      notifyListeners();
    }
  }

  void clear() {
    _winners = [];
    _history = [];
    _currentPage = 1;
    _hasMore = true;
    _isLoading = false;
    _error = null;
    notifyListeners();
  }
}
