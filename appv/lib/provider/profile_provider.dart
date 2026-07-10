import 'dart:io';
import 'package:flutter/material.dart';
import '../api/profile_api.dart';
import '../models/user_model.dart';
import '../helpers/api_helper.dart';

class ProfileProvider with ChangeNotifier {
  UserModel? _profile;
  Map<String, dynamic>? _vault;
  bool _isLoading = false;
  bool _isUploading = false;
  String? _error;

  UserModel? get profile => _profile;
  Map<String, dynamic>? get vault => _vault;
  bool get isLoading => _isLoading;
  bool get isUploading => _isUploading;
  String? get error => _error;

  /// Fetch user profile
  Future<void> fetchProfile() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      _profile = await ProfileApi.getProfile();
      _isLoading = false;
      notifyListeners();
    } on ApiException catch (e) {
      _error = e.message;
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _error = 'Failed to load profile';
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Update profile fields
  Future<bool> updateProfile(Map<String, dynamic> fields) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      _profile = await ProfileApi.updateProfile(fields);
      _isLoading = false;
      notifyListeners();
      return true;
    } on ApiException catch (e) {
      _error = e.message;
      _isLoading = false;
      notifyListeners();
      return false;
    } catch (e) {
      _error = 'Failed to update profile';
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  /// Fetch vault documents
  Future<void> fetchVault() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      _vault = await ProfileApi.getVault();
      _isLoading = false;
      notifyListeners();
    } on ApiException catch (e) {
      _error = e.message;
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _error = 'Failed to load vault';
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Upload documents to vault
  Future<bool> uploadVault(Map<String, File> files, {Map<String, String>? fields}) async {
    _isUploading = true;
    _error = null;
    notifyListeners();

    try {
      await ProfileApi.uploadVault(files, fields: fields);
      _isUploading = false;
      // Refresh vault
      await fetchVault();
      return true;
    } on ApiException catch (e) {
      _error = e.message;
      _isUploading = false;
      notifyListeners();
      return false;
    } catch (e) {
      _error = 'Upload failed';
      _isUploading = false;
      notifyListeners();
      return false;
    }
  }

  void clear() {
    _profile = null;
    _vault = null;
    _isLoading = false;
    _error = null;
    notifyListeners();
  }
}
