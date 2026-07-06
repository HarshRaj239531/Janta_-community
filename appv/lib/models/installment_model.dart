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
      id: json['id'] ?? 0,
      userId: json['user_id'],
      committeeId: json['committee_id'],
      loanId: json['loan_id'],
      amount: double.tryParse(json['amount']?.toString() ?? '') ?? 0.0,
      dueDate: json['due_date'],
      status: json['status'],
      paidDate: json['paid_date'],
      createdAt: json['created_at'],
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
