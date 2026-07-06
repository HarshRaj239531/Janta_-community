import 'package:flutter/material.dart';
import '../api/committee_api.dart';
import '../models/committee_model.dart';
import '../helpers/api_helper.dart';

class CommitteeProvider with ChangeNotifier {
  List<CommitteeModel> _committees = [];
  List<CommitteeModel> _myCommittees = [];
  CommitteeModel? _selectedCommittee;
  bool _isLoading = false;
  bool _isJoining = false;
  String? _error;

  List<CommitteeModel> get committees => _committees;
  List<CommitteeModel> get myCommittees => _myCommittees;
  CommitteeModel? get selectedCommittee => _selectedCommittee;
  bool get isLoading => _isLoading;
  bool get isJoining => _isJoining;
  String? get error => _error;

  /// Fetch all active committees
  Future<void> fetchCommittees() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      _committees = await CommitteeApi.getCommittees();
      _isLoading = false;
      notifyListeners();
    } on ApiException catch (e) {
      _error = e.message;
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _error = 'Failed to load committees';
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Fetch user's own committees
  Future<void> fetchMyCommittees() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      _myCommittees = await CommitteeApi.getMyCommittees();
      _isLoading = false;
      notifyListeners();
    } on ApiException catch (e) {
      _error = e.message;
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _error = 'Failed to load your committees';
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Fetch single committee details
  Future<void> fetchCommitteeDetails(int id) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      _selectedCommittee = await CommitteeApi.getCommitteeDetails(id);
      _isLoading = false;
      notifyListeners();
    } on ApiException catch (e) {
      _error = e.message;
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _error = 'Failed to load committee details';
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Join a committee
  Future<bool> joinCommittee(int id) async {
    _isJoining = true;
    _error = null;
    notifyListeners();

    try {
      await CommitteeApi.joinCommittee(id);
      _isJoining = false;
      // Refresh both lists
      await fetchCommittees();
      await fetchMyCommittees();
      return true;
    } on ApiException catch (e) {
      _error = e.message;
      _isJoining = false;
      notifyListeners();
      return false;
    } catch (e) {
      _error = 'Failed to join committee';
      _isJoining = false;
      notifyListeners();
      return false;
    }
  }

  void clear() {
    _committees = [];
    _myCommittees = [];
    _selectedCommittee = null;
    _isLoading = false;
    _error = null;
    notifyListeners();
  }
}
