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

  static Future<AgentClientSummaryModel> getClients({String? search}) async {
    final Map<String, String> queryParams = {};
    if (search != null && search.isNotEmpty) {
      queryParams['search'] = search;
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
    final response = await ApiHelper.get('/agent/search-member?query=${Uri.encodeComponent(query)}');
    if (response is List) {
      return response
          .map((e) => AgentSearchMemberModel.fromJson(e as Map<String, dynamic>))
          .toList();
    }
    return [];
  }

  static Future<bool> submitCollection({
    required String type,
    required int installmentId,
    required double amount,
    String? notes,
  }) async {
    final body = {
      'type': type,
      'installment_id': installmentId,
      'amount': amount,
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
