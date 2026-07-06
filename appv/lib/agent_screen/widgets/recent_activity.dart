import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../constants/agent_colors.dart';

class RecentActivity extends StatelessWidget {
  final VoidCallback onViewAll;

  const RecentActivity({
    super.key,
    required this.onViewAll,
  });

  @override
  Widget build(BuildContext context) {
    // Transaction model data
    final transactions = [
      _ActivityItem(
        name: 'Arjun Mehta',
        time: 'Today • 11:30 AM',
        amount: '₹12,000',
        isSuccess: true,
      ),
      _ActivityItem(
        name: 'Priya Sharma',
        time: 'Today • 09:15 AM',
        amount: '₹8,500',
        isSuccess: true,
      ),
      _ActivityItem(
        name: 'Rohan Das',
        time: 'Yesterday • 04:45 PM',
        amount: '₹25,000',
        isSuccess: true,
      ),
    ];

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 12.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header Row
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Recent Activity',
                style: GoogleFonts.outfit(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: AgentColors.primaryGreen,
                ),
              ),
              GestureDetector(
                onTap: onViewAll,
                child: Text(
                  'View All',
                  style: GoogleFonts.outfit(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: AgentColors.textSecondary,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          
          // List Container Card
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: AgentColors.borderMuted,
                width: 1,
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withAlpha(8),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                )
              ],
            ),
            child: ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: transactions.length,
              separatorBuilder: (context, index) => const Divider(
                color: AgentColors.borderMuted,
                height: 1,
                indent: 16,
                endIndent: 16,
              ),
              itemBuilder: (context, index) {
                final item = transactions[index];
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 14.0),
                  child: Row(
                    children: [
                      // Avatar placeholder with person icon
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: const BoxDecoration(
                          color: AgentColors.backgroundSoft,
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.person_outline_rounded,
                          color: AgentColors.primaryGreen,
                          size: 24,
                        ),
                      ),
                      const SizedBox(width: 12),
                      
                      // Name and Date
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              item.name,
                              style: GoogleFonts.outfit(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: AgentColors.textPrimary,
                              ),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              item.time,
                              style: GoogleFonts.outfit(
                                fontSize: 12,
                                color: AgentColors.textSecondary,
                              ),
                            ),
                          ],
                        ),
                      ),
                      
                      // Amount & Success Badge
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text(
                            item.amount,
                            style: GoogleFonts.outfit(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: AgentColors.textPrimary,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                            decoration: BoxDecoration(
                              color: AgentColors.successLight,
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: Text(
                              item.isSuccess ? 'SUCCESS' : 'PENDING',
                              style: GoogleFonts.outfit(
                                fontSize: 10,
                                fontWeight: FontWeight.bold,
                                color: AgentColors.successDark,
                                letterSpacing: 0.2,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

// Internal helper class for holding transaction item mock data
class _ActivityItem {
  final String name;
  final String time;
  final String amount;
  final bool isSuccess;

  _ActivityItem({
    required this.name,
    required this.time,
    required this.amount,
    required this.isSuccess,
  });
}
