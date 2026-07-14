double _toDouble(dynamic value) {
  if (value == null) return 0.0;
  if (value is num) return value.toDouble();
  if (value is String) {
    return double.tryParse(value) ?? 0.0;
  }
  return 0.0;
}

int _toInt(dynamic value) {
  if (value == null) return 0;
  if (value is num) return value.toInt();
  if (value is String) {
    return int.tryParse(value) ?? 0;
  }
  return 0;
}

class AgentSearchMemberModel {
  final int id;
  final String name;
  final String? phone;
  final List<AgentSearchInstallment> installments;
  final List<AgentSearchLoan> loans;

  AgentSearchMemberModel({
    required this.id,
    required this.name,
    this.phone,
    required this.installments,
    required this.loans,
  });

  factory AgentSearchMemberModel.fromJson(Map<String, dynamic> json) {
    return AgentSearchMemberModel(
      id: _toInt(json['id']),
      name: json['name'] ?? '',
      phone: json['phone'],
      installments: (json['installments'] as List? ?? [])
          .map((e) => AgentSearchInstallment.fromJson(e as Map<String, dynamic>))
          .toList(),
      loans: (json['loans'] as List? ?? [])
          .map((e) => AgentSearchLoan.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }
}

class AgentSearchInstallment {
  final int id; // installment id
  final int committeeId;
  final int installmentNumber;
  final double amount;
  final String? dueDate;
  final String committeeName;

  AgentSearchInstallment({
    required this.id,
    required this.committeeId,
    required this.installmentNumber,
    required this.amount,
    this.dueDate,
    required this.committeeName,
  });

  factory AgentSearchInstallment.fromJson(Map<String, dynamic> json) {
    var committeeJson = json['committee'] as Map<String, dynamic>? ?? {};
    return AgentSearchInstallment(
      id: _toInt(json['id']),
      committeeId: _toInt(json['committee_id']),
      installmentNumber: _toInt(json['installment_number']),
      amount: _toDouble(json['amount']),
      dueDate: json['due_date'],
      committeeName: committeeJson['name'] ?? 'Committee',
    );
  }
}

class AgentSearchLoan {
  final int id; // loan id
  final double amount;
  final double interestRate;
  final List<AgentSearchLoanInstallment> installments;

  AgentSearchLoan({
    required this.id,
    required this.amount,
    required this.interestRate,
    required this.installments,
  });

  factory AgentSearchLoan.fromJson(Map<String, dynamic> json) {
    return AgentSearchLoan(
      id: _toInt(json['id']),
      amount: _toDouble(json['amount']),
      interestRate: _toDouble(json['interest_rate']),
      installments: (json['installments'] as List? ?? [])
          .map((e) => AgentSearchLoanInstallment.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }
}

class AgentSearchLoanInstallment {
  final int id; // loan installment id
  final int installmentNumber;
  final double amountToPay;
  final String? dueDate;

  AgentSearchLoanInstallment({
    required this.id,
    required this.installmentNumber,
    required this.amountToPay,
    this.dueDate,
  });

  factory AgentSearchLoanInstallment.fromJson(Map<String, dynamic> json) {
    return AgentSearchLoanInstallment(
      id: _toInt(json['id']),
      installmentNumber: _toInt(json['installment_number']),
      amountToPay: _toDouble(json['total_amount'] ?? json['amount']),
      dueDate: json['due_date'],
    );
  }
}
