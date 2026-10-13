class InstallmentModel {
  final int id;
  final int? userId;
  final int? committeeId;
  final int? loanId;
  final double? amount;
  final String? dueDate;
  final String? status;
  final String? paidDate;
  final String? createdAt;

  // Relationships
  final Map<String, dynamic>? committee;
  final Map<String, dynamic>? loan;

  InstallmentModel({
    required this.id,
    this.userId,
    this.committeeId,
    this.loanId,
    this.amount,
    this.dueDate,
    this.status,
    this.paidDate,
    this.createdAt,
    this.committee,
    this.loan,
  });

  factory InstallmentModel.fromJson(Map<String, dynamic> json) {
    return InstallmentModel(
      id: int.tryParse(json['id']?.toString() ?? '') ??
          int.tryParse(json['installment_id']?.toString() ?? '') ??
          0,
      userId: int.tryParse(json['user_id']?.toString() ?? ''),
      committeeId: int.tryParse(json['committee_id']?.toString() ?? ''),
      loanId: int.tryParse(json['loan_id']?.toString() ?? ''),
      amount: double.tryParse(json['amount']?.toString() ?? '') ??
              double.tryParse(json['total_amount']?.toString() ?? '') ??
              double.tryParse(json['emi']?.toString() ?? '') ??
              0.0,
      dueDate: json['due_date']?.toString(),
      status: json['status']?.toString(),
      paidDate: json['paid_date']?.toString(),
      createdAt: json['created_at']?.toString(),
      committee: json['committee'] as Map<String, dynamic>?,
      loan: json['loan'] as Map<String, dynamic>?,
    );
  }

  bool get isPaid => status == 'paid';
  bool get isPending => status == 'pending';

  String get committeeName {
    return committee?['name'] ?? 'N/A';
  }

  String get loanLabel {
    if (loan != null) {
      return 'Loan #${loan!['id']}';
    }
    return 'N/A';
  }
}

/// Container for the pending/paid installments API response
class InstallmentsResponse {
  final List<InstallmentModel> committeeInstallments;
  final List<InstallmentModel> loanInstallments;

  InstallmentsResponse({
    required this.committeeInstallments,
    required this.loanInstallments,
  });

  factory InstallmentsResponse.fromJson(Map<String, dynamic> json) {
    return InstallmentsResponse(
      committeeInstallments: (json['committee_installments'] as List? ?? [])
          .map((e) => InstallmentModel.fromJson(e as Map<String, dynamic>))
          .toList(),
      loanInstallments: (json['loan_installments'] as List? ?? [])
          .map((e) => InstallmentModel.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }

  List<InstallmentModel> get all => [...committeeInstallments, ...loanInstallments];
}
