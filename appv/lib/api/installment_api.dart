import '../helpers/api_helper.dart';
import '../helpers/api_constants.dart';
import '../models/installment_model.dart';

class InstallmentApi {
  /// Fetch pending installments (committee + loan)
  static Future<InstallmentsResponse> getPending() async {
    final data = await ApiHelper.get(ApiConstants.pendingInstallments);
    return InstallmentsResponse.fromJson(data as Map<String, dynamic>);
  }

  /// Fetch paid installments (committee + loan)
  static Future<InstallmentsResponse> getPaid() async {
    final data = await ApiHelper.get(ApiConstants.paidInstallments);
    return InstallmentsResponse.fromJson(data as Map<String, dynamic>);
  }
}
