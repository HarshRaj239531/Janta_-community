import '../helpers/api_helper.dart';
import '../helpers/api_constants.dart';
import '../models/user_model.dart';

class AuthApi {
  /// Login with email/phone + password
  /// Returns { 'user': UserModel, 'token': String }
  static Future<Map<String, dynamic>> login(String loginId, String password) async {
    final data = await ApiHelper.post(
      ApiConstants.login,
      body: {'login_id': loginId, 'password': password},
      withAuth: false,
    );
    return {
      'user': UserModel.fromJson(data['user'] as Map<String, dynamic>),
      'token': data['token'] as String,
    };
  }

  /// Logout — invalidate current token
  static Future<void> logout() async {
    await ApiHelper.post(ApiConstants.logout);
  }
}
