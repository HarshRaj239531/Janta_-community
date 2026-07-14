import 'dart:io';
import 'package:flutter/material.dart';
import '../api/agent_api.dart';
import '../models/agent_dashboard_model.dart';
import '../models/agent_client_model.dart';
import '../models/agent_search_member_model.dart';
import '../../helpers/api_helper.dart';

class AgentProvider with ChangeNotifier {
  AgentDashboardModel? _dashboard;
  AgentClientSummaryModel? _clientsSummary;
  ClientProfileModel? _clientProfile;
  List<AgentSearchMemberModel> _searchResults = [];

  bool _isDashboardLoading = false;
  bool _isClientsLoading = false;
  bool _isProfileLoading = false;
  bool _isSearchLoading = false;
  bool _isSubmitting = false;

  String? _dashboardError;
  String? _clientsError;
  String? _profileError;
  String? _searchError;
  String? _submitError;

  // Getters
  AgentDashboardModel? get dashboard => _dashboard;
  AgentClientSummaryModel? get clientsSummary => _clientsSummary;
  ClientProfileModel? get clientProfile => _clientProfile;
  List<AgentSearchMemberModel> get searchResults => _searchResults;

  bool get isDashboardLoading => _isDashboardLoading;
  bool get isClientsLoading => _isClientsLoading;
  bool get isProfileLoading => _isProfileLoading;
  bool get isSearchLoading => _isSearchLoading;
  bool get isSubmitting => _isSubmitting;

  String? get dashboardError => _dashboardError;
  String? get clientsError => _clientsError;
  String? get profileError => _profileError;
  String? get searchError => _searchError;
  String? get submitError => _submitError;

  Future<void> fetchDashboard() async {
    _isDashboardLoading = true;
    _dashboardError = null;
    notifyListeners();

    try {
      _dashboard = await AgentApi.getDashboard();
      _isDashboardLoading = false;
      notifyListeners();
    } on ApiException catch (e) {
      _dashboardError = e.message;
      _isDashboardLoading = false;
      notifyListeners();
    } catch (e) {
      _dashboardError = 'Failed to load dashboard data: $e';
      _isDashboardLoading = false;
      notifyListeners();
    }
  }

  Future<void> fetchClients({String? search}) async {
    _isClientsLoading = true;
    _clientsError = null;
    notifyListeners();

    try {
      _clientsSummary = await AgentApi.getClients(search: search);
      _isClientsLoading = false;
      notifyListeners();
    } on ApiException catch (e) {
      _clientsError = e.message;
      _isClientsLoading = false;
      notifyListeners();
    } catch (e) {
      _clientsError = 'Failed to load clients: $e';
      _isClientsLoading = false;
      notifyListeners();
    }
  }

  Future<void> fetchClientDetails(int id) async {
    _isProfileLoading = true;
    _profileError = null;
    notifyListeners();

    try {
      _clientProfile = await AgentApi.getClientDetails(id);
      _isProfileLoading = false;
      notifyListeners();
    } on ApiException catch (e) {
      _profileError = e.message;
      _isProfileLoading = false;
      notifyListeners();
    } catch (e) {
      _profileError = 'Failed to load client details: $e';
      _isProfileLoading = false;
      notifyListeners();
    }
  }

  Future<void> searchMembers(String query) async {
    if (query.trim().isEmpty) {
      _searchResults = [];
      notifyListeners();
      return;
    }

    _isSearchLoading = true;
    _searchError = null;
    notifyListeners();

    try {
      _searchResults = await AgentApi.searchMember(query);
      _isSearchLoading = false;
      notifyListeners();
    } on ApiException catch (e) {
      _searchError = e.message;
      _isSearchLoading = false;
      notifyListeners();
    } catch (e) {
      _searchError = 'Search failed: $e';
      _isSearchLoading = false;
      notifyListeners();
    }
  }

  void clearSearchResults() {
    _searchResults = [];
    _searchError = null;
    notifyListeners();
  }

  Future<bool> submitCollection({
    required String type,
    required int installmentId,
    required double amount,
    String? notes,
  }) async {
    _isSubmitting = true;
    _submitError = null;
    notifyListeners();

    try {
      final success = await AgentApi.submitCollection(
        type: type,
        installmentId: installmentId,
        amount: amount,
        notes: notes,
      );
      _isSubmitting = false;
      notifyListeners();
      return success;
    } on ApiException catch (e) {
      _submitError = e.message;
      _isSubmitting = false;
      notifyListeners();
      return false;
    } catch (e) {
      _submitError = 'Submission failed: $e';
      _isSubmitting = false;
      notifyListeners();
      return false;
    }
  }

  void clear() {
    _dashboard = null;
    _clientsSummary = null;
    _clientProfile = null;
    _searchResults = [];
    _isDashboardLoading = false;
    _isClientsLoading = false;
    _isProfileLoading = false;
    _isSearchLoading = false;
    _isSubmitting = false;
    _dashboardError = null;
    _clientsError = null;
    _profileError = null;
    _searchError = null;
    _submitError = null;
    notifyListeners();
  }

  Future<void> submitClientKyc({
    required int userId,
    File? aadharFront,
    File? aadharBack,
    File? panFront,
  }) async {
    _isSubmitting = true;
    _submitError = null;
    notifyListeners();

    try {
      await AgentApi.submitKyc(
        userId: userId,
        aadharFront: aadharFront,
        aadharBack: aadharBack,
        panFront: panFront,
      );
      _isSubmitting = false;
      notifyListeners();
      
      // Reload lists
      fetchClients();
      fetchClientDetails(userId);
    } on ApiException catch (e) {
      _submitError = e.message;
      _isSubmitting = false;
      notifyListeners();
      rethrow;
    } catch (e) {
      _submitError = 'Failed to submit KYC: $e';
      _isSubmitting = false;
      notifyListeners();
      rethrow;
    }
  }
}
