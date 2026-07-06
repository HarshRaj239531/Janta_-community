import '../helpers/api_helper.dart';
import '../helpers/api_constants.dart';
import '../models/material_model.dart';
import '../models/material_stock_model.dart';

class MaterialApi {
  /// Fetch list of active materials
  static Future<List<MaterialModel>> getMaterials() async {
    final data = await ApiHelper.get(ApiConstants.materials);
    final list = data as List? ?? [];
    return list
        .map((e) => MaterialModel.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  /// Fetch list of recent stock transactions
  static Future<List<MaterialStockModel>> getMaterialStocks() async {
    final data = await ApiHelper.get(ApiConstants.materialStocks);
    final list = data as List? ?? [];
    return list
        .map((e) => MaterialStockModel.fromJson(e as Map<String, dynamic>))
        .toList();
  }
}
