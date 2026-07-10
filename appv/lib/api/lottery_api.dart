import '../helpers/api_helper.dart';
import '../helpers/api_constants.dart';
import '../models/lottery_model.dart';

class LotteryApi {
  /// Fetch recent winners
  static Future<List<LotteryModel>> getWinners() async {
    final data = await ApiHelper.get(ApiConstants.lotteryWinners);
    final list = data as List? ?? [];
    return list
        .map((e) => LotteryModel.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  /// Fetch lottery history (paginated)
  static Future<List<LotteryModel>> getHistory({int page = 1}) async {
    final data = await ApiHelper.get('${ApiConstants.lotteryHistory}?page=$page');
    // Laravel paginate returns { data: [...], ... }
    if (data is Map<String, dynamic> && data.containsKey('data')) {
      final list = data['data'] as List? ?? [];
      return list
          .map((e) => LotteryModel.fromJson(e as Map<String, dynamic>))
          .toList();
    }
    // Fallback: if it's already a list
    if (data is List) {
      return data
          .map((e) => LotteryModel.fromJson(e as Map<String, dynamic>))
          .toList();
    }
    return [];
  }

  /// Fetch lottery countdown / promotional setting
  static Future<Map<String, dynamic>> fetchLotterySetting() async {
    final response = await ApiHelper.get(ApiConstants.lotterySetting);
    return Map<String, dynamic>.from(response);
  }
}
