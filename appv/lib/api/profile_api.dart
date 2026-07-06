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
  static Future<Map<String, String?>> getVault() async {
    final data = await ApiHelper.get(ApiConstants.vault);
    final map = data as Map<String, dynamic>;
    return {
      'aadhar_card': map['aadhar_card'] as String?,
      'pan_card': map['pan_card'] as String?,
      'id_proof': map['id_proof'] as String?,
      'photo': map['photo'] as String?,
    };
  }

  /// Upload vault documents
  static Future<dynamic> uploadVault(Map<String, File> files) async {
    return await ApiHelper.uploadFiles(ApiConstants.vaultUpload, files: files);
  }
}
