class LoanRequestModel {
  final int id;
  final int userId;
  final double amount;
  final int durationMonths;
  final String paymentFrequency;
  final String? purpose;
  final String status; // 'pending', 'approved', 'rejected'
  final String? adminRemarks;
  final int? approvedLoanId;
  final String? createdAt;
  final String? updatedAt;

  LoanRequestModel({
    required this.id,
    required this.userId,
    required this.amount,
    required this.durationMonths,
    required this.paymentFrequency,
    this.purpose,
    required this.status,
    this.adminRemarks,
    this.approvedLoanId,
    this.createdAt,
    this.updatedAt,
  });

  factory LoanRequestModel.fromJson(Map<String, dynamic> json) {
    return LoanRequestModel(
      id: json['id'] is int ? json['id'] : int.tryParse(json['id'].toString()) ?? 0,
      userId: json['user_id'] is int ? json['user_id'] : int.tryParse(json['user_id'].toString()) ?? 0,
      amount: (json['amount'] is num)
          ? (json['amount'] as num).toDouble()
          : double.tryParse(json['amount']?.toString() ?? '0') ?? 0.0,
      durationMonths: json['duration_months'] is int
          ? json['duration_months']
          : int.tryParse(json['duration_months']?.toString() ?? '1') ?? 1,
      paymentFrequency: json['payment_frequency']?.toString() ?? 'monthly',
      purpose: json['purpose']?.toString(),
      status: json['status']?.toString() ?? 'pending',
      adminRemarks: json['admin_remarks']?.toString(),
      approvedLoanId: json['approved_loan_id'] != null
          ? int.tryParse(json['approved_loan_id'].toString())
          : null,
      createdAt: json['created_at']?.toString(),
      updatedAt: json['updated_at']?.toString(),
    );
  }

  bool get isPending => status == 'pending';
  bool get isApproved => status == 'approved';
  bool get isRejected => status == 'rejected';
}
