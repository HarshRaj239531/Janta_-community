import 'package:flutter/material.dart';
import '../api/loan_api.dart';
import '../models/loan_model.dart';
import '../models/loan_request_model.dart';
import '../helpers/api_helper.dart';

class LoanProvider with ChangeNotifier {
  List<LoanModel> _loans = [];
  LoanModel? _selectedLoan;
  List<LoanRequestModel> _loanRequests = [];
  bool _isLoading = false;
  bool _isApplying = false;
  String? _error;

  List<LoanModel> get loans => _loans;
  LoanModel? get selectedLoan => _selectedLoan;
  List<LoanRequestModel> get loanRequests => _loanRequests;
  bool get isLoading => _isLoading;
  bool get isApplying => _isApplying;
  String? get error => _error;

  /// Active loans only
  List<LoanModel> get activeLoans =>
      _loans.where((l) => l.status == 'active').toList();

  /// Get pending loan request if any
  LoanRequestModel? get pendingRequest {
    for (final r in _loanRequests) {
      if (r.status == 'pending') return r;
    }
    return null;
  }

  /// Latest request
  LoanRequestModel? get latestRequest =>
      _loanRequests.isNotEmpty ? _loanRequests.first : null;

  /// Fetch user's loans
  Future<void> fetchLoans() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      _loans = await LoanApi.getLoans();
      _isLoading = false;
      notifyListeners();
    } on ApiException catch (e) {
      _error = e.message;
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _error = 'Failed to load loans';
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Fetch user's loan applications
  Future<void> fetchLoanRequests() async {
    try {
      _loanRequests = await LoanApi.getLoanRequests();
      notifyListeners();
    } catch (e) {
      // Non-blocking background fetch
    }
  }

  /// Submit a new loan application
  Future<bool> applyForLoan({
    required double amount,
    required int durationMonths,
    required String paymentFrequency,
    String? purpose,
  }) async {
    _isApplying = true;
    _error = null;
    notifyListeners();

    try {
      final newReq = await LoanApi.applyForLoan(
        amount: amount,
        durationMonths: durationMonths,
        paymentFrequency: paymentFrequency,
        purpose: purpose,
      );
      _loanRequests.insert(0, newReq);
      _isApplying = false;
      notifyListeners();
      return true;
    } on ApiException catch (e) {
      _error = e.message;
      _isApplying = false;
      notifyListeners();
      rethrow;
    } catch (e) {
      _error = 'Failed to submit loan application: $e';
      _isApplying = false;
      notifyListeners();
      rethrow;
    }
  }

  /// Fetch single loan details with installments
  Future<void> fetchLoanDetails(int id) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      _selectedLoan = await LoanApi.getLoanDetails(id);
      _isLoading = false;
      notifyListeners();
    } on ApiException catch (e) {
      _error = e.message;
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _error = 'Failed to load loan details';
      _isLoading = false;
      notifyListeners();
    }
  }

  void clear() {
    _loans = [];
    _selectedLoan = null;
    _loanRequests = [];
    _isLoading = false;
    _isApplying = false;
    _error = null;
    notifyListeners();
  }
}
