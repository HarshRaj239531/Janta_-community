import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'api_constants.dart';
import 'shared_prefs_helper.dart';

class ApiException implements Exception {
  final String message;
  final int? statusCode;
  ApiException(this.message, {this.statusCode});
  @override
  String toString() => message;
}

class ApiHelper {
  ApiHelper._();

  static final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

  static Future<Map<String, String>> _getHeaders({bool withAuth = true}) async {
    final headers = <String, String>{
      'Content-Type': 'application/json',
      'Accept': 'application/json',
    };
    if (withAuth) {
      final token = await SharedPrefsHelper.getToken();
      if (token != null && token.isNotEmpty) {
        headers['Authorization'] = 'Bearer $token';
      }
    }
    return headers;
  }

  /// GET request
  static Future<dynamic> get(String endpoint, {bool withAuth = true}) async {
    final url = Uri.parse('${ApiConstants.baseUrl}$endpoint');
    final headers = await _getHeaders(withAuth: withAuth);

    try {
      final response = await http.get(url, headers: headers).timeout(
        const Duration(seconds: 30),
      );
      return _processResponse(response);
    } on SocketException {
      throw ApiException('No internet connection');
    } catch (e) {
      if (e is ApiException) rethrow;
      throw ApiException('Something went wrong: $e');
    }
  }

  /// POST request
  static Future<dynamic> post(
    String endpoint, {
    Map<String, dynamic>? body,
    bool withAuth = true,
  }) async {
    final url = Uri.parse('${ApiConstants.baseUrl}$endpoint');
    final headers = await _getHeaders(withAuth: withAuth);

    try {
      final response = await http
          .post(url, headers: headers, body: body != null ? jsonEncode(body) : null)
          .timeout(const Duration(seconds: 30));
      return _processResponse(response);
    } on SocketException {
      throw ApiException('No internet connection');
    } catch (e) {
      if (e is ApiException) rethrow;
      throw ApiException('Something went wrong: $e');
    }
  }

  /// Multipart POST (for file uploads)
  static Future<dynamic> uploadFiles(
    String endpoint, {
    required Map<String, File> files,
    bool withAuth = true,
  }) async {
    final url = Uri.parse('${ApiConstants.baseUrl}$endpoint');
    final request = http.MultipartRequest('POST', url);

    // Add auth header
    if (withAuth) {
      final token = await SharedPrefsHelper.getToken();
      if (token != null && token.isNotEmpty) {
        request.headers['Authorization'] = 'Bearer $token';
      }
    }
    request.headers['Accept'] = 'application/json';

    // Add files
    for (final entry in files.entries) {
      request.files.add(
        await http.MultipartFile.fromPath(entry.key, entry.value.path),
      );
    }

    try {
      final streamedResponse = await request.send().timeout(
        const Duration(seconds: 60),
      );
      final response = await http.Response.fromStream(streamedResponse);
      return _processResponse(response);
    } on SocketException {
      throw ApiException('No internet connection');
    } catch (e) {
      if (e is ApiException) rethrow;
      throw ApiException('Upload failed: $e');
    }
  }

  static dynamic _processResponse(http.Response response) {
    dynamic body;
    try {
      body = jsonDecode(response.body);
    } catch (_) {
      if (response.statusCode == 401) {
        SharedPrefsHelper.clearAll();
        navigatorKey.currentState?.pushNamedAndRemoveUntil('/login', (route) => false);
        throw ApiException('Unauthenticated', statusCode: 401);
      }
      if (response.statusCode >= 400) {
        throw ApiException('Server error: ${response.statusCode}', statusCode: response.statusCode);
      }
      throw ApiException('Invalid response format');
    }

    if (response.statusCode >= 200 && response.statusCode < 300) {
      if (body['success'] == true) {
        return body['data'];
      } else {
        throw ApiException(body['message'] ?? 'Unknown error');
      }
    } else if (response.statusCode == 401) {
      SharedPrefsHelper.clearAll();
      navigatorKey.currentState?.pushNamedAndRemoveUntil('/login', (route) => false);
      throw ApiException(body['message'] ?? 'Unauthorized', statusCode: 401);
    } else if (response.statusCode == 422) {
      throw ApiException(body['message'] ?? 'Validation error', statusCode: 422);
    } else {
      throw ApiException(
        body['message'] ?? 'Server error',
        statusCode: response.statusCode,
      );
    }
  }
}
