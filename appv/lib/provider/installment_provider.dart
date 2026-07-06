import 'package:flutter/material.dart';
import '../api/installment_api.dart';
import '../api/payment_api.dart';
import '../models/installment_model.dart';
import '../helpers/api_helper.dart';

class InstallmentProvider with ChangeNotifier {
  InstallmentsResponse? _pending;
  InstallmentsResponse? _paid;
  bool _isLoading = false;
  bool _isPaying = false;
  String? _error;

  InstallmentsResponse? get pending => _pending;
  InstallmentsResponse? get paid => _paid;
  bool get isLoading => _isLoading;
  bool get isPaying => _isPaying;
  String? get error => _error;

  /// All pending installments (committee + loan)
  List<InstallmentModel> get allPending => _pending?.all ?? [];
  List<InstallmentModel> get allPaid => _paid?.all ?? [];

  /// Fetch pending installments
  Future<void> fetchPending() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      _pending = await InstallmentApi.getPending();
      _isLoading = false;
      notifyListeners();
    } on ApiException catch (e) {
      _error = e.message;
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _error = 'Failed to load pending installments';
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Fetch paid installments
  Future<void> fetchPaid() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      _paid = await InstallmentApi.getPaid();
      _isLoading = false;
      notifyListeners();
    } on ApiException catch (e) {
      _error = e.message;
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _error = 'Failed to load paid installments';
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Pay an installment
  Future<bool> payInstallment({
    required String type,
    required int installmentId,
    required double amount,
  }) async {
    _isPaying = true;
    _error = null;
    notifyListeners();

    try {
      await PaymentApi.payInstallment(
        type: type,
        installmentId: installmentId,
        amount: amount,
      );
      _isPaying = false;
      // Refresh both lists
      await fetchPending();
      await fetchPaid();
      return true;
    } on ApiException catch (e) {
      _error = e.message;
      _isPaying = false;
      notifyListeners();
      return false;
    } catch (e) {
      _error = 'Payment failed';
      _isPaying = false;
      notifyListeners();
      return false;
    }
  }

  void clear() {
    _pending = null;
    _paid = null;
    _isLoading = false;
    _error = null;
    notifyListeners();
  }
}
