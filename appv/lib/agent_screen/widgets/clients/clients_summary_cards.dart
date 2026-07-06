import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../constants/agent_colors.dart';

class ClientsSummaryCards extends StatelessWidget {
  final int totalClients;
  final int activeLoans;

  const ClientsSummaryCards({
    super.key,
    required this.totalClients,
    required this.activeLoans,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // 1. Total Clients Card
        _buildSummaryCard(
          label: 'Total Clients Managed',
          value: totalClients.toString(),
          icon: Icons.people_outline_rounded,
          iconBg: AgentColors.pillGreenBackground,
          iconColor: AgentColors.emeraldGreen,
        ),
        const SizedBox(height: 12),
        
        // 2. Active Loans Card
        _buildSummaryCard(
          label: 'Active Loans',
          value: activeLoans.toString(),
          icon: Icons.account_balance_outlined,
          iconBg: AgentColors.lavenderSoft,
          iconColor: AgentColors.primaryGreen,
        ),
      ],
    );
  }

  Widget _buildSummaryCard({
    required String label,
    required String value,
    required IconData icon,
    required Color iconBg,
    required Color iconColor,
  }) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 16.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AgentColors.borderMuted, width: 1),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(8),
            blurRadius: 10,
            offset: const Offset(0, 4),
          )
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: GoogleFonts.outfit(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  color: AgentColors.textSecondary,
                  letterSpacing: 0.2,
                ),
              ),
              const SizedBox(height: 6),
              Text(
                value,
                style: GoogleFonts.outfit(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: AgentColors.primaryGreen,
                ),
              ),
            ],
          ),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: iconBg,
              shape: BoxShape.circle,
            ),
            child: Icon(
              icon,
              color: iconColor,
              size: 26,
            ),
          ),
        ],
      ),
    );
  }
}
