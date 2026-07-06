import 'installment_model.dart';

class LoanModel {
  final int id;
  final int? userId;
  final double? amount;
  final double? interestRate;
  final int? duration;
  final String? status;
  final int? installmentsCount;
  final List<InstallmentModel>? installments;
  final String? createdAt;
  final String? updatedAt;

  LoanModel({
    required this.id,
    this.userId,
    this.amount,
    this.interestRate,
    this.duration,
    this.status,
    this.installmentsCount,
    this.installments,
    this.createdAt,
    this.updatedAt,
  });

  factory LoanModel.fromJson(Map<String, dynamic> json) {
    List<InstallmentModel>? installmentList;
    if (json['installments'] != null) {
      installmentList = (json['installments'] as List)
          .map((e) => InstallmentModel.fromJson(e as Map<String, dynamic>))
          .toList();
    }
    return LoanModel(
      id: json['id'] ?? 0,
      userId: json['user_id'],
      amount: double.tryParse(json['amount']?.toString() ?? '') ?? 0.0,
      interestRate: double.tryParse(json['interest_rate']?.toString() ?? ''),
      duration: json['duration'],
      status: json['status'],
      installmentsCount: json['installments_count'],
      installments: installmentList,
      createdAt: json['created_at'],
      updatedAt: json['updated_at'],
    );
  }

  /// Monthly EMI calculation (simple)
  double get monthlyEmi {
    if (amount != null && duration != null && duration! > 0) {
      final totalWithInterest = amount! * (1 + (interestRate ?? 0) / 100);
      return totalWithInterest / duration!;
    }
    return 0;
  }

  /// Paid installments count
  int get paidCount {
    if (installments == null) return 0;
    return installments!.where((i) => i.status == 'paid').length;
  }

  /// Pending installments count
  int get pendingCount {
    if (installments == null) return installmentsCount ?? 0;
    return installments!.where((i) => i.status == 'pending').length;
  }
}
