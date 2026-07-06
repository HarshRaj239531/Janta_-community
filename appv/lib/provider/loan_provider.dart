import 'package:flutter/material.dart';
import '../api/loan_api.dart';
import '../models/loan_model.dart';
import '../helpers/api_helper.dart';

class LoanProvider with ChangeNotifier {
  List<LoanModel> _loans = [];
  LoanModel? _selectedLoan;
  bool _isLoading = false;
  String? _error;

  List<LoanModel> get loans => _loans;
  LoanModel? get selectedLoan => _selectedLoan;
  bool get isLoading => _isLoading;
  String? get error => _error;

  /// Active loans only
  List<LoanModel> get activeLoans =>
      _loans.where((l) => l.status == 'active').toList();

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
    _isLoading = false;
    _error = null;
    notifyListeners();
  }
}
