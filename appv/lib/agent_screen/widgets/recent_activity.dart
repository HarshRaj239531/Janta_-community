import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../constants/agent_colors.dart';
import '../provider/agent_provider.dart';

class RecentActivity extends StatelessWidget {
  final VoidCallback onViewAll;

  const RecentActivity({
    super.key,
    required this.onViewAll,
  });

  String _formatDate(String dateStr) {
    if (dateStr.isEmpty) return '';
    try {
      DateTime dt = DateTime.parse(dateStr);
      final months = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];
      int h = dt.hour > 12 ? dt.hour - 12 : (dt.hour == 0 ? 12 : dt.hour);
      String hour = h.toString().padLeft(2, '0');
      String min = dt.minute.toString().padLeft(2, '0');
      String ampm = dt.hour >= 12 ? 'PM' : 'AM';
      
      // Check if it's today
      final now = DateTime.now();
      if (dt.day == now.day && dt.month == now.month && dt.year == now.year) {
        return "Today • $hour:$min $ampm";
      }
      return "${dt.day} ${months[dt.month - 1]} • $hour:$min $ampm";
    } catch (_) {
      return dateStr;
    }
  }

  String _formatCurrency(double amount) {
    final RegExp reg = RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))');
    String str = amount.toStringAsFixed(0);
    return "₹${str.replaceAllMapped(reg, (Match match) => '${match[1]},')}";
  }

  @override
  Widget build(BuildContext context) {
    final agentProvider = Provider.of<AgentProvider>(context);
    final activities = agentProvider.dashboard?.recentActivity ?? [];

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
            child: activities.isEmpty
                ? Padding(
                    padding: const EdgeInsets.all(24.0),
                    child: Center(
                      child: Text(
                        'No recent collection activity found.',
                        style: GoogleFonts.outfit(
                          color: AgentColors.textSecondary,
                          fontSize: 14,
                        ),
                      ),
                    ),
                  )
                : ListView.separated(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: activities.length,
                    separatorBuilder: (context, index) => const Divider(
                      color: AgentColors.borderMuted,
                      height: 1,
                      indent: 16,
                      endIndent: 16,
                    ),
                    itemBuilder: (context, index) {
                      final item = activities[index];
                      final isSuccess = item.status.toLowerCase() == 'approved';
                      
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
                                    item.memberName,
                                    style: GoogleFonts.outfit(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                      color: AgentColors.textPrimary,
                                    ),
                                  ),
                                  const SizedBox(height: 2),
                                  Text(
                                    _formatDate(item.date),
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
                                  _formatCurrency(item.amount),
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
                                    color: isSuccess ? AgentColors.successLight : AgentColors.alertOrangeBackground,
                                    borderRadius: BorderRadius.circular(6),
                                  ),
                                  child: Text(
                                    item.status.toUpperCase(),
                                    style: GoogleFonts.outfit(
                                      fontSize: 10,
                                      fontWeight: FontWeight.bold,
                                      color: isSuccess ? AgentColors.successDark : AgentColors.alertOrange,
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
