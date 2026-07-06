import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../constants/agent_colors.dart';
import 'sparkline_painter.dart';

class ClientListCard extends StatelessWidget {
  final String name;
  final String id;
  final String status; // 'Active', 'Pending KYC', 'Overdue'
  final String lastCollectionAmount;
  final List<double> sparklineData;
  final VoidCallback onViewProfile;

  const ClientListCard({
    super.key,
    required this.name,
    required this.id,
    required this.status,
    required this.lastCollectionAmount,
    required this.sparklineData,
    required this.onViewProfile,
  });

  @override
  Widget build(BuildContext context) {
    // Get colors matching the status badge
    Color badgeText;
    Color badgeBg;

    if (status == 'Active') {
      badgeText = AgentColors.successDark;
      badgeBg = AgentColors.successLight;
    } else if (status == 'Pending KYC') {
      badgeText = AgentColors.warningAmber.darken(); // custom darken or amber dark
      badgeBg = AgentColors.warningAmber.withAlpha(50);
    } else {
      // Overdue
      badgeText = AgentColors.errorDark;
      badgeBg = AgentColors.errorLight;
    }

    // Generate initials for avatar
    final initials = name.trim().split(' ').map((e) => e[0]).take(2).join().toUpperCase();

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20.0),
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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header Row (Avatar, Name, ID, Badge)
          Row(
            children: [
              CircleAvatar(
                radius: 22,
                backgroundColor: AgentColors.lavenderSoft,
                child: Text(
                  initials,
                  style: GoogleFonts.outfit(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                    color: AgentColors.primaryGreen,
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      name,
                      style: GoogleFonts.outfit(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: AgentColors.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      'ID $id',
                      style: GoogleFonts.outfit(
                        fontSize: 12,
                        color: AgentColors.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
              // Status Badge
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: badgeBg,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  status,
                  style: GoogleFonts.outfit(
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                    color: badgeText,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          
          // Collection info & trend row
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Last Collection',
                    style: GoogleFonts.outfit(
                      fontSize: 12,
                      color: AgentColors.textSecondary,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    lastCollectionAmount,
                    style: GoogleFonts.outfit(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: AgentColors.textPrimary,
                    ),
                  ),
                ],
              ),
              
              // Sparkline chart
              Sparkline(
                data: sparklineData,
                color: status == 'Active'
                    ? AgentColors.successGreen
                    : status == 'Pending KYC'
                        ? AgentColors.textMuted
                        : AgentColors.errorAccent,
              ),
            ],
          ),
          const SizedBox(height: 20),
          
          // Divider
          Container(
            height: 1,
            color: AgentColors.borderMuted,
          ),
          const SizedBox(height: 14),
          
          // View Profile Link Button
          GestureDetector(
            onTap: onViewProfile,
            child: Row(
              children: [
                Text(
                  'View Profile',
                  style: GoogleFonts.outfit(
                    fontSize: 13,
                    fontWeight: FontWeight.bold,
                    color: AgentColors.primaryGreen,
                  ),
                ),
                const SizedBox(width: 4),
                const Icon(
                  Icons.chevron_right_rounded,
                  color: AgentColors.primaryGreen,
                  size: 16,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// Extension to darken custom colors
extension _ColorDarken on Color {
  Color darken([double amount = .1]) {
    assert(amount >= 0 && amount <= 1);
    final hsl = HSLColor.fromColor(this);
    final hslDark = hsl.withLightness((hsl.lightness - amount).clamp(0.0, 1.0));
    return hslDark.toColor();
  }
}
