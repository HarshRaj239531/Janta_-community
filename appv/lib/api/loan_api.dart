import '../helpers/api_helper.dart';
import '../helpers/api_constants.dart';
import '../models/loan_model.dart';
import '../models/loan_request_model.dart';

class LoanApi {
  /// Fetch user's loans
  static Future<List<LoanModel>> getLoans() async {
    final data = await ApiHelper.get(ApiConstants.loans);
    final list = data as List? ?? [];
    return list
        .map((e) => LoanModel.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  /// Fetch single loan details with installments
  static Future<LoanModel> getLoanDetails(int id) async {
    final data = await ApiHelper.get(ApiConstants.loanDetails(id));
    return LoanModel.fromJson(data as Map<String, dynamic>);
  }

  /// Fetch user's loan applications
  static Future<List<LoanRequestModel>> getLoanRequests() async {
    final data = await ApiHelper.get(ApiConstants.loanRequests);
    final list = data as List? ?? [];
    return list
        .map((e) => LoanRequestModel.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  /// Submit a loan application
  static Future<LoanRequestModel> applyForLoan({
    required double amount,
    required int durationMonths,
    required String paymentFrequency,
    String? purpose,
  }) async {
    final data = await ApiHelper.post(
      ApiConstants.loanRequests,
      body: {
        'amount': amount,
        'duration_months': durationMonths,
        'payment_frequency': paymentFrequency,
        if (purpose != null && purpose.trim().isNotEmpty) 'purpose': purpose.trim(),
      },
    );
    return LoanRequestModel.fromJson(data as Map<String, dynamic>);
  }
}
