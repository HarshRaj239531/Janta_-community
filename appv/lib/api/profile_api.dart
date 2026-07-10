import 'dart:io';
import '../helpers/api_helper.dart';
import '../helpers/api_constants.dart';
import '../models/user_model.dart';

class ProfileApi {
  /// Get user profile
  static Future<UserModel> getProfile() async {
    final data = await ApiHelper.get(ApiConstants.profile);
    return UserModel.fromJson(data as Map<String, dynamic>);
  }

  /// Update profile fields
  static Future<UserModel> updateProfile(Map<String, dynamic> fields) async {
    final data = await ApiHelper.post(ApiConstants.profileUpdate, body: fields);
    return UserModel.fromJson(data as Map<String, dynamic>);
  }

  /// Get vault (KYC documents)
  static Future<Map<String, dynamic>> getVault() async {
    final data = await ApiHelper.get(ApiConstants.vault);
    return data as Map<String, dynamic>;
  }

  /// Upload vault documents
  static Future<dynamic> uploadVault(Map<String, File> files, {Map<String, String>? fields}) async {
    return await ApiHelper.uploadFiles(ApiConstants.vaultUpload, files: files, fields: fields);
  }
}
