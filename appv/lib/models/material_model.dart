import '../helpers/api_constants.dart';

class MaterialModel {
  final int id;
  final String name;
  final double price;
  final String unit;
  final String? imageUrl;
  final String status;

  MaterialModel({
    required this.id,
    required this.name,
    required this.price,
    required this.unit,
    this.imageUrl,
    required this.status,
  });

  factory MaterialModel.fromJson(Map<String, dynamic> json) {
    return MaterialModel(
      id: json['id'] ?? 0,
      name: json['name'] ?? '',
      price: double.tryParse(json['price']?.toString() ?? '') ?? 0.0,
      unit: json['unit'] ?? '',
      imageUrl: ApiConstants.resolveImageUrl(json['image_url']),
      status: json['status'] ?? 'active',
    );
  }
}
