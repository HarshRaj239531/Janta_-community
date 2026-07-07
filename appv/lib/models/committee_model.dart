class CommitteeModel {
  final int id;
  final String? name;
  final double? amount;
  final double? returnPercentage;
  final int? duration;
  final String? paymentFrequency;
  final String? status;
  final String? createdAt;
  final String? updatedAt;

  // Pivot data (from committee_user)
  final String? pivotStatus;
  final String? joinedAt;

  CommitteeModel({
    required this.id,
    this.name,
    this.amount,
    this.returnPercentage,
    this.duration,
    this.paymentFrequency,
    this.status,
    this.createdAt,
    this.updatedAt,
    this.pivotStatus,
    this.joinedAt,
  });

  factory CommitteeModel.fromJson(Map<String, dynamic> json) {
    final pivot = json['pivot'] as Map<String, dynamic>?;
    return CommitteeModel(
      id: json['id'] ?? 0,
      name: json['name'],
      amount: double.tryParse(json['amount']?.toString() ?? '') ?? 0.0,
      returnPercentage: double.tryParse(json['return_percentage']?.toString() ?? '') ?? 0.0,
      duration: json['duration'],
      paymentFrequency: json['payment_frequency'],
      status: json['status'],
      createdAt: json['created_at'],
      updatedAt: json['updated_at'],
      pivotStatus: pivot?['status'],
      joinedAt: pivot?['joined_at'],
    );
  }

  /// Monthly installment amount
  double get monthlyAmount {
    if (amount != null && duration != null && duration! > 0) {
      return amount! / duration!;
    }
    return 0;
  }

  /// Frequency display text
  String get frequencyLabel {
    switch (paymentFrequency) {
      case 'monthly':
        return 'Monthly';
      case 'weekly':
        return 'Weekly';
      case 'daily':
        return 'Daily';
      default:
        return paymentFrequency ?? 'N/A';
    }
  }
}
