import '../helpers/api_helper.dart';
import '../helpers/api_constants.dart';
import '../models/dashboard_model.dart';

class DashboardApi {
  /// Fetch dashboard data (wallet, stats, recent activity)
  static Future<DashboardModel> getDashboard() async {
    final data = await ApiHelper.get(ApiConstants.dashboard);
    return DashboardModel.fromJson(data as Map<String, dynamic>);
  }
}
