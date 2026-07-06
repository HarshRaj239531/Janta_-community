import 'transaction_model.dart';

class WalletModel {
  final double totalBalance;
  final double credits;
  final double debits;

  WalletModel({
    required this.totalBalance,
    required this.credits,
    required this.debits,
  });

  factory WalletModel.fromJson(Map<String, dynamic> json) {
    return WalletModel(
      totalBalance: (json['total_balance'] ?? 0).toDouble(),
      credits: (json['credits'] ?? 0).toDouble(),
      debits: (json['debits'] ?? 0).toDouble(),
    );
  }
}

class DashboardStatsModel {
  final int activeCommittees;
  final int activeLoans;

  DashboardStatsModel({
    required this.activeCommittees,
    required this.activeLoans,
  });

  factory DashboardStatsModel.fromJson(Map<String, dynamic> json) {
    return DashboardStatsModel(
      activeCommittees: json['active_committees'] ?? 0,
      activeLoans: json['active_loans'] ?? 0,
    );
  }
}

class DashboardUserModel {
  final String name;
  final String? email;
  final String? phone;
  final String? photo;

  DashboardUserModel({
    required this.name,
    this.email,
    this.phone,
    this.photo,
  });

  factory DashboardUserModel.fromJson(Map<String, dynamic> json) {
    return DashboardUserModel(
      name: json['name'] ?? '',
      email: json['email'],
      phone: json['phone'],
      photo: json['photo'],
    );
  }
}

class DashboardModel {
  final DashboardUserModel user;
  final WalletModel wallet;
  final DashboardStatsModel stats;
  final List<TransactionModel> recentActivity;

  DashboardModel({
    required this.user,
    required this.wallet,
    required this.stats,
    required this.recentActivity,
  });

  factory DashboardModel.fromJson(Map<String, dynamic> json) {
    final activityList = json['recent_activity'] as List? ?? [];
    return DashboardModel(
      user: DashboardUserModel.fromJson(json['user'] ?? {}),
      wallet: WalletModel.fromJson(json['wallet'] ?? {}),
      stats: DashboardStatsModel.fromJson(json['stats'] ?? {}),
      recentActivity: activityList
          .map((e) => TransactionModel.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }
}
