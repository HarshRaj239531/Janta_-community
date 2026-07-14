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

class AgentClientSummaryModel {
  final int totalClientsManaged;
  final int activeLoans;
  final List<AgentClientModel> recentClients;

  AgentClientSummaryModel({
    required this.totalClientsManaged,
    required this.activeLoans,
    required this.recentClients,
  });

  factory AgentClientSummaryModel.fromJson(Map<String, dynamic> json) {
    var clientsJson = json['recent_clients'];
    List<AgentClientModel> clients = [];
    if (clientsJson != null) {
      var dataList = clientsJson['data'] as List? ?? [];
      clients = dataList
          .map((e) => AgentClientModel.fromJson(e as Map<String, dynamic>))
          .toList();
    }

    return AgentClientSummaryModel(
      totalClientsManaged: _toInt(json['total_clients_managed']),
      activeLoans: _toInt(json['active_loans']),
      recentClients: clients,
    );
  }
}

class AgentClientModel {
  final int id;
  final String name;
  final String status;
  final double lastCollectionAmount;
  final String? lastCollectionDate;

  AgentClientModel({
    required this.id,
    required this.name,
    required this.status,
    required this.lastCollectionAmount,
    this.lastCollectionDate,
  });

  factory AgentClientModel.fromJson(Map<String, dynamic> json) {
    return AgentClientModel(
      id: _toInt(json['id']),
      name: json['name'] ?? '',
      status: json['status'] ?? 'Active',
      lastCollectionAmount: _toDouble(json['last_collection_amount']),
      lastCollectionDate: json['last_collection_date'],
    );
  }
}

class ClientProfileModel {
  final ClientPersonalDetails personalDetails;
  final List<ClientActiveLoanModel> activeLoans;
  final List<ClientTransactionModel> recentTransactions;

  ClientProfileModel({
    required this.personalDetails,
    required this.activeLoans,
    required this.recentTransactions,
  });

  factory ClientProfileModel.fromJson(Map<String, dynamic> json) {
    return ClientProfileModel(
      personalDetails: ClientPersonalDetails.fromJson(
        json['personal_details'] as Map<String, dynamic>? ?? {},
      ),
      activeLoans: (json['active_loans'] as List? ?? [])
          .map((e) => ClientActiveLoanModel.fromJson(e as Map<String, dynamic>))
          .toList(),
      recentTransactions: (json['recent_transactions'] as List? ?? [])
          .map((e) => ClientTransactionModel.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }
}

class ClientPersonalDetails {
  final int clientId;
  final String name;
  final String? phone;
  final String? email;
  final String? address;
  final String? aadharCard;
  final String? idProof;
  final String? panCard;

  ClientPersonalDetails({
    required this.clientId,
    required this.name,
    this.phone,
    this.email,
    this.address,
    this.aadharCard,
    this.idProof,
    this.panCard,
  });

  factory ClientPersonalDetails.fromJson(Map<String, dynamic> json) {
    return ClientPersonalDetails(
      clientId: _toInt(json['client_id']),
      name: json['name'] ?? '',
      phone: json['phone'],
      email: json['email'],
      address: json['address'],
      aadharCard: json['aadhar_card'],
      idProof: json['id_proof'],
      panCard: json['pan_card'],
    );
  }
}

class ClientActiveLoanModel {
  final int loanId;
  final double totalLoanAmount;
  final double outstanding;
  final double totalPaid;
  final String emiProgress;

  ClientActiveLoanModel({
    required this.loanId,
    required this.totalLoanAmount,
    required this.outstanding,
    required this.totalPaid,
    required this.emiProgress,
  });

  factory ClientActiveLoanModel.fromJson(Map<String, dynamic> json) {
    return ClientActiveLoanModel(
      loanId: _toInt(json['loan_id']),
      totalLoanAmount: _toDouble(json['total_loan_amount']),
      outstanding: _toDouble(json['outstanding']),
      totalPaid: _toDouble(json['total_paid']),
      emiProgress: json['emi_progress'] ?? 'in_progress',
    );
  }
}

class ClientTransactionModel {
  final int id;
  final String type;
  final double amount;
  final String date;
  final String status;

  ClientTransactionModel({
    required this.id,
    required this.type,
    required this.amount,
    required this.date,
    required this.status,
  });

  factory ClientTransactionModel.fromJson(Map<String, dynamic> json) {
    return ClientTransactionModel(
      id: _toInt(json['id']),
      type: json['type'] ?? '',
      amount: _toDouble(json['amount']),
      date: json['date'] ?? '',
      status: json['status'] ?? '',
    );
  }
}
