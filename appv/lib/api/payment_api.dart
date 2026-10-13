import '../helpers/api_helper.dart';
import '../helpers/api_constants.dart';

class PaymentApi {
  /// Pay an installment (committee or loan)
  /// type: 'committee' or 'loan'
  static Future<void> payInstallment({
    required String type,
    required int installmentId,
    required double amount,
    int? agentId,
    String paymentMode = 'cash',
  }) async {
    final payload = <String, dynamic>{
      'type': type,
      'installment_id': installmentId,
      'amount': amount,
      'payment_mode': paymentMode,
    };
    if (agentId != null) {
      payload['agent_id'] = agentId;
    }
    await ApiHelper.post(
      ApiConstants.pay,
      body: payload,
    );
  }

  /// Fetch payment setting (QR Code URL and Admin Phone)
  static Future<Map<String, dynamic>> fetchPaymentSetting() async {
    final response = await ApiHelper.get(ApiConstants.paymentSetting);
    return Map<String, dynamic>.from(response);
  }
}
