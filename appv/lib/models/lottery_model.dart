class LotteryModel {
  final int id;
  final int? committeeId;
  final int? winnerId;
  final String? drawDate;
  final double? prizeAmount;
  final String? createdAt;

  // Relationships
  final Map<String, dynamic>? winner;
  final Map<String, dynamic>? committee;

  LotteryModel({
    required this.id,
    this.committeeId,
    this.winnerId,
    this.drawDate,
    this.prizeAmount,
    this.createdAt,
    this.winner,
    this.committee,
  });

  factory LotteryModel.fromJson(Map<String, dynamic> json) {
    return LotteryModel(
      id: json['id'] ?? 0,
      committeeId: json['committee_id'],
      winnerId: json['winner_id'],
      drawDate: json['draw_date'],
      prizeAmount: json['prize_amount'] != null
          ? (json['prize_amount']).toDouble()
          : null,
      createdAt: json['created_at'],
      winner: json['winner'] as Map<String, dynamic>?,
      committee: json['committee'] as Map<String, dynamic>?,
    );
  }

  String get winnerName => winner?['name'] ?? 'Unknown';
  String get winnerPhoto => winner?['photo'] ?? '';
  String get committeeName => committee?['name'] ?? 'N/A';
}
