import '../helpers/api_helper.dart';
import '../helpers/api_constants.dart';
import '../models/committee_model.dart';

class CommitteeApi {
  /// Fetch all active committees
  static Future<List<CommitteeModel>> getCommittees() async {
    final data = await ApiHelper.get(ApiConstants.committees);
    final list = data as List? ?? [];
    return list
        .map((e) => CommitteeModel.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  /// Fetch single committee details
  static Future<CommitteeModel> getCommitteeDetails(int id) async {
    final data = await ApiHelper.get(ApiConstants.committeeDetails(id));
    return CommitteeModel.fromJson(data as Map<String, dynamic>);
  }

  /// Join a committee
  static Future<void> joinCommittee(int id) async {
    await ApiHelper.post(ApiConstants.joinCommittee(id));
  }

  /// Fetch user's own committees
  static Future<List<CommitteeModel>> getMyCommittees() async {
    final data = await ApiHelper.get(ApiConstants.myCommittees);
    final list = data as List? ?? [];
    return list
        .map((e) => CommitteeModel.fromJson(e as Map<String, dynamic>))
        .toList();
  }
}
