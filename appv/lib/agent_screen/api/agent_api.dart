import 'dart:io';
import '../../helpers/api_helper.dart';
import '../models/agent_dashboard_model.dart';
import '../models/agent_client_model.dart';
import '../models/agent_search_member_model.dart';

class AgentApi {
  AgentApi._();

  static Future<AgentDashboardModel> getDashboard() async {
    final response = await ApiHelper.get('/agent/dashboard');
    return AgentDashboardModel.fromJson(response as Map<String, dynamic>);
  }

  static String _cleanSearchQuery(String query) {
    final trimmed = query.trim();
    if (trimmed.isEmpty) return '';

    // Extract numeric ID if user typed #MEM-30, MEM-30, #30, mem 30, etc.
    final memIdRegex = RegExp(
      r'^(?:#|mem|#mem|cust|client|customer|id)?[-\s:#]*(\d+)$',
      caseSensitive: false,
    );
    final match = memIdRegex.firstMatch(trimmed);
    if (match != null) {
      return match.group(1)!;
    }

    // Check if formatted phone number e.g. +91 98765 43210 or 98765-43210
    final digits = trimmed.replaceAll(RegExp(r'\D'), '');
    if (digits.length >= 10 &&
        (trimmed.startsWith('+') ||
            trimmed.contains(' ') ||
            trimmed.contains('-') ||
            trimmed.startsWith('0'))) {
      return digits.length > 10 ? digits.substring(digits.length - 10) : digits;
    }

    return trimmed;
  }

  static Future<AgentClientSummaryModel> getClients({String? search}) async {
    final Map<String, String> queryParams = {};
    if (search != null && search.trim().isNotEmpty) {
      queryParams['search'] = _cleanSearchQuery(search);
    }
    
    final uri = Uri(path: '/agent/clients', queryParameters: queryParams);
    final response = await ApiHelper.get('${uri.path}${uri.query.isNotEmpty ? "?${uri.query}" : ""}');
    return AgentClientSummaryModel.fromJson(response as Map<String, dynamic>);
  }

  static Future<ClientProfileModel> getClientDetails(int id) async {
    final response = await ApiHelper.get('/agent/clients/$id');
    return ClientProfileModel.fromJson(response as Map<String, dynamic>);
  }

  static Future<List<AgentSearchMemberModel>> searchMember(String query) async {
    final trimmed = query.trim();
    if (trimmed.isEmpty) return [];

    final cleanQuery = _cleanSearchQuery(trimmed);

    // 1. Primary attempt with clean query (e.g. numeric ID '30' or clean phone)
    try {
      final response = await ApiHelper.get('/agent/search-member?query=${Uri.encodeComponent(cleanQuery)}');
      if (response is List && response.isNotEmpty) {
        return response
            .map((e) => AgentSearchMemberModel.fromJson(e as Map<String, dynamic>))
            .toList();
      }
    } catch (_) {}

    // 2. Fallback attempt with original trimmed query if different
    if (cleanQuery != trimmed) {
      try {
        final fallbackResponse = await ApiHelper.get('/agent/search-member?query=${Uri.encodeComponent(trimmed)}');
        if (fallbackResponse is List && fallbackResponse.isNotEmpty) {
          return fallbackResponse
              .map((e) => AgentSearchMemberModel.fromJson(e as Map<String, dynamic>))
              .toList();
        }
      } catch (_) {}
    }

    return [];
  }

  static Future<dynamic> createClient({
    required String name,
    required String phone,
    String? email,
  }) async {
    return await ApiHelper.post(
      '/agent/clients',
      body: {
        'name': name,
        'phone': phone,
        if (email != null && email.isNotEmpty) 'email': email,
      },
    );
  }

  static Future<bool> submitCollection({
    required String type,
    required int installmentId,
    required double amount,
    String? notes,
    String paymentMode = 'cash',
  }) async {
    final body = {
      'type': type,
      'installment_id': installmentId,
      'amount': amount,
      'payment_mode': paymentMode,
      'payment_method': paymentMode,
      if (notes != null && notes.isNotEmpty) 'payment_notes': notes,
    };
    await ApiHelper.post('/agent/collections/submit', body: body);
    return true;
  }


  static Future<dynamic> submitKyc({
    required int userId,
    File? aadharFront,
    File? aadharBack,
    File? panFront,
  }) async {
    final Map<String, String> fields = {
      'user_id': userId.toString(),
    };

    final Map<String, File> files = {};
    if (aadharFront != null) {
      files['aadhar_front'] = aadharFront;
    }
    if (aadharBack != null) {
      files['aadhar_back'] = aadharBack;
    }
    if (panFront != null) {
      files['pan_front'] = panFront;
    }

    return await ApiHelper.uploadFiles('/agent/clients/kyc', files: files, fields: fields);
  }
}
