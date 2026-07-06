class MaterialStockModel {
  final int id;
  final int? materialId;
  final String title;
  final double amount;
  final String status;
  final String type; // 'credit' or 'debit'
  final String? createdAt;

  MaterialStockModel({
    required this.id,
    this.materialId,
    required this.title,
    required this.amount,
    required this.status,
    required this.type,
    this.createdAt,
  });

  factory MaterialStockModel.fromJson(Map<String, dynamic> json) {
    return MaterialStockModel(
      id: json['id'] ?? 0,
      materialId: json['material_id'],
      title: json['title'] ?? '',
      amount: double.tryParse(json['amount']?.toString() ?? '') ?? 0.0,
      status: json['status'] ?? 'success',
      type: json['type'] ?? 'credit',
      createdAt: json['created_at'],
    );
  }

  bool get isSuccess => status.toLowerCase() == 'success';
  bool get isCredit => type.toLowerCase() == 'credit';
}
