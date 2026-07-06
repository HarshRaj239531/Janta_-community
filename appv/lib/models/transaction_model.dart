class TransactionModel {
  final int id;
  final int? userId;
  final String? type; // 'credit' or 'debit'
  final double? amount;
  final String? description;
  final String? referenceType;
  final int? referenceId;
  final String? createdAt;

  TransactionModel({
    required this.id,
    this.userId,
    this.type,
    this.amount,
    this.description,
    this.referenceType,
    this.referenceId,
    this.createdAt,
  });

  factory TransactionModel.fromJson(Map<String, dynamic> json) {
    return TransactionModel(
      id: json['id'] ?? 0,
      userId: json['user_id'],
      type: json['type'],
      amount: double.tryParse(json['amount']?.toString() ?? ''),
      description: json['description'],
      referenceType: json['reference_type'],
      referenceId: json['reference_id'],
      createdAt: json['created_at'],
    );
  }

  bool get isCredit => type == 'credit';
  bool get isDebit => type == 'debit';
}
