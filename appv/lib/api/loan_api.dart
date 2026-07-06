import '../helpers/api_helper.dart';
import '../helpers/api_constants.dart';
import '../models/loan_model.dart';

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
}
