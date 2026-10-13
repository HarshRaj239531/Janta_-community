import '../helpers/api_helper.dart';
import '../helpers/api_constants.dart';
import '../models/agent_model.dart';

class AgentApi {
  /// Fetch list of agents available for collection
  static Future<List<AgentModel>> getAgents() async {
    try {
      final response = await ApiHelper.get(ApiConstants.agents);
      final list = response as List? ?? [];
      return list
          .map((e) => AgentModel.fromJson(e as Map<String, dynamic>))
          .toList();
    } catch (e) {
      return [];
    }
  }
}
