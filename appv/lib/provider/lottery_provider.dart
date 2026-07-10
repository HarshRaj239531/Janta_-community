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

  // Settings
  String? _grandDrawTitle;
  String? _grandDrawDescription;
  DateTime? _grandDrawDate;

  List<LotteryModel> get winners => _winners;
  List<LotteryModel> get history => _history;
  bool get isLoading => _isLoading;
  String? get error => _error;
  bool get hasMore => _hasMore;

  String? get grandDrawTitle => _grandDrawTitle;
  String? get grandDrawDescription => _grandDrawDescription;
  DateTime? get grandDrawDate => _grandDrawDate;

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

  /// Fetch lottery configuration settings (countdown target and text details)
  Future<void> fetchLotterySetting() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final data = await LotteryApi.fetchLotterySetting();
      _grandDrawTitle = data['grand_draw_title'];
      _grandDrawDescription = data['grand_draw_description'];
      if (data['grand_draw_date'] != null) {
        _grandDrawDate = DateTime.tryParse(data['grand_draw_date']);
      }
      _isLoading = false;
      notifyListeners();
    } on ApiException catch (e) {
      _error = e.message;
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _error = 'Failed to load lottery settings';
      _isLoading = false;
      notifyListeners();
    }
  }

  void clear() {
    _winners = [];
    _history = [];
    _grandDrawTitle = null;
    _grandDrawDescription = null;
    _grandDrawDate = null;
    _currentPage = 1;
    _hasMore = true;
    _isLoading = false;
    _error = null;
    notifyListeners();
  }
}
