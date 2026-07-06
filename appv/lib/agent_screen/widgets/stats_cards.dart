import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../constants/agent_colors.dart';

class StatsCards extends StatelessWidget {
  const StatsCards({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      child: Column(
        children: [
          // 1. TODAY'S COLLECTION CARD
          _buildCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // Cash Icon in light green tint
                    Container(
                      padding: const EdgeInsets.all(8.0),
                      decoration: const BoxDecoration(
                        color: AgentColors.pillGreenBackground,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.payments_outlined,
                        color: AgentColors.emeraldGreen,
                        size: 24,
                      ),
                    ),
                    // +12% Badge
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: AgentColors.successLight,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Row(
                        children: [
                          const Icon(
                            Icons.trending_up_rounded,
                            color: AgentColors.successDark,
                            size: 14,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            '+12%',
                            style: GoogleFonts.outfit(
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                              color: AgentColors.successDark,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Text(
                  "TODAY'S COLLECTION",
                  style: GoogleFonts.outfit(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: AgentColors.textSecondary,
                    letterSpacing: 0.5,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  "₹45,500",
                  style: GoogleFonts.outfit(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: AgentColors.primaryGreen,
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  "Last updated: 5 mins ago",
                  style: GoogleFonts.outfit(
                    fontSize: 12,
                    color: AgentColors.textMuted,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),

          // 2. THIS MONTH CARD
          _buildCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Chart Icon
                Container(
                  padding: const EdgeInsets.all(8.0),
                  decoration: const BoxDecoration(
                    color: AgentColors.lavenderSoft,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.insert_chart_outlined,
                    color: AgentColors.infoBlueDark,
                    size: 24,
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  "THIS MONTH",
                  style: GoogleFonts.outfit(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: AgentColors.textSecondary,
                    letterSpacing: 0.5,
                  ),
                ),
                const SizedBox(height: 4),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.baseline,
                  textBaseline: TextBaseline.alphabetic,
                  children: [
                    Text(
                      "₹1,25,000",
                      style: GoogleFonts.outfit(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: AgentColors.textPrimary,
                      ),
                    ),
                    Text(
                      " / ₹2.0L",
                      style: GoogleFonts.outfit(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: AgentColors.textSecondary,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                // Progress Bar
                ClipRRect(
                  borderRadius: BorderRadius.circular(4),
                  child: const LinearProgressIndicator(
                    value: 0.625,
                    minHeight: 6,
                    backgroundColor: AgentColors.backgroundSoft,
                    valueColor: AlwaysStoppedAnimation<Color>(AgentColors.primaryGreen),
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  "62.5% of monthly target achieved",
                  style: GoogleFonts.outfit(
                    fontSize: 12,
                    color: AgentColors.textMuted,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),

          // 3. TOTAL COLLECTION CARD (Dark Green Gradient Card with Trophy & Seal Watermark)
          Container(
            width: double.infinity,
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [
                  AgentColors.primaryGreen,
                  AgentColors.primaryDark,
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: AgentColors.primaryDark.withAlpha(50),
                  blurRadius: 12,
                  offset: const Offset(0, 6),
                )
              ],
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: Stack(
                children: [
                  // Star seal Watermark decoration in bottom right corner
                  Positioned(
                    right: -30,
                    bottom: -30,
                    child: Opacity(
                      opacity: 0.08,
                      child: Container(
                        width: 140,
                        height: 140,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: Colors.white,
                            width: 12,
                          ),
                        ),
                        child: const Center(
                          child: Icon(
                            Icons.star_rounded,
                            color: Colors.white,
                            size: 80,
                          ),
                        ),
                      ),
                    ),
                  ),
                  
                  // Content
                  Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Trophy Icon Outline
                        Container(
                          padding: const EdgeInsets.all(8.0),
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: Colors.white.withAlpha(50),
                              width: 1.5,
                            ),
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            Icons.emoji_events_outlined,
                            color: Colors.white,
                            size: 20,
                          ),
                        ),
                        const SizedBox(height: 24),
                        Text(
                          "TOTAL COLLECTION",
                          style: GoogleFonts.outfit(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            color: AgentColors.accentMint.withAlpha(200),
                            letterSpacing: 0.5,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          "₹12,45,000",
                          style: GoogleFonts.outfit(
                            fontSize: 30,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(height: 12),
                        Text(
                          "Lifetime agent achievement.",
                          style: GoogleFonts.outfit(
                            fontSize: 12,
                            color: Colors.white.withAlpha(150),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Helper method for standard cards
  Widget _buildCard({required Widget child}) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20.0),
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
      child: child,
    );
  }
}
