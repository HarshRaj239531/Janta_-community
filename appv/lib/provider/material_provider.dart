import 'package:flutter/material.dart';
import '../api/material_api.dart';
import '../models/material_model.dart';
import '../models/material_stock_model.dart';
import '../helpers/api_helper.dart';

class MaterialProvider with ChangeNotifier {
  List<MaterialModel> _materials = [];
  List<MaterialStockModel> _stocks = [];
  bool _isLoading = false;
  String? _error;

  List<MaterialModel> get materials => _materials;
  List<MaterialStockModel> get stocks => _stocks;
  bool get isLoading => _isLoading;
  String? get error => _error;

  /// Fetch both materials and stock transactions
  Future<void> fetchMaterialsAndStocks() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final results = await Future.wait([
        MaterialApi.getMaterials(),
        MaterialApi.getMaterialStocks(),
      ]);

      _materials = results[0] as List<MaterialModel>;
      _stocks = results[1] as List<MaterialStockModel>;
      _isLoading = false;
      notifyListeners();
    } on ApiException catch (e) {
      _error = e.message;
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _error = 'Failed to load materials and stocks';
      _isLoading = false;
      notifyListeners();
    }
  }

  void clear() {
    _materials = [];
    _stocks = [];
    _isLoading = false;
    _error = null;
    notifyListeners();
  }
}
