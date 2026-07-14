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

class AgentDashboardModel {
  final double todayCollection;
  final double thisMonthCollection;
  final double totalCollection;
  final double monthlyTarget;
  final double targetProgress;
  final List<AgentRecentActivityModel> recentActivity;

  AgentDashboardModel({
    required this.todayCollection,
    required this.thisMonthCollection,
    required this.totalCollection,
    required this.monthlyTarget,
    required this.targetProgress,
    required this.recentActivity,
  });

  factory AgentDashboardModel.fromJson(Map<String, dynamic> json) {
    var activityList = json['recent_activity'] as List? ?? [];
    List<AgentRecentActivityModel> activities = activityList
        .map((e) => AgentRecentActivityModel.fromJson(e as Map<String, dynamic>))
        .toList();

    return AgentDashboardModel(
      todayCollection: _toDouble(json['today_collection']),
      thisMonthCollection: _toDouble(json['this_month_collection']),
      totalCollection: _toDouble(json['total_collection']),
      monthlyTarget: _toDouble(json['monthly_target'] ?? 200000.0),
      targetProgress: _toDouble(json['target_progress']),
      recentActivity: activities,
    );
  }
}

class AgentRecentActivityModel {
  final int id;
  final String memberName;
  final double amount;
  final String date;
  final String status;
  final String type;

  AgentRecentActivityModel({
    required this.id,
    required this.memberName,
    required this.amount,
    required this.date,
    required this.status,
    required this.type,
  });

  factory AgentRecentActivityModel.fromJson(Map<String, dynamic> json) {
    return AgentRecentActivityModel(
      id: _toInt(json['id']),
      memberName: json['member_name'] ?? 'Unknown',
      amount: _toDouble(json['amount']),
      date: json['date'] ?? '',
      status: json['status'] ?? 'Pending',
      type: json['type'] ?? 'Collection',
    );
  }
}
