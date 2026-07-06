import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../constants/agent_colors.dart';

class PerformanceBanner extends StatelessWidget {
  const PerformanceBanner({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 12.0),
      child: Container(
        width: double.infinity,
        height: 180,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          image: const DecorationImage(
            image: AssetImage('assets/images/agent_performance.png'),
            fit: BoxFit.cover,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withAlpha(20),
              blurRadius: 12,
              offset: const Offset(0, 6),
            )
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(20),
          child: Container(
            // Use a dark teal gradient overlay to ensure text contrast and premium glassmorphic feel
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  AgentColors.primaryGreen.withAlpha(200),
                  Colors.black.withAlpha(80),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            padding: const EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Top Tag
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'AGENT PERFORMANCE',
                      style: GoogleFonts.outfit(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: AgentColors.accentMint,
                        letterSpacing: 1.5,
                      ),
                    ),
                    const SizedBox(height: 8),
                    // Main Heading
                    Text(
                      "You're in the top 5% of\nagents this week!",
                      style: GoogleFonts.outfit(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        height: 1.2,
                      ),
                    ),
                  ],
                ),
                
                // Learn More Button
                ElevatedButton(
                  onPressed: () {
                    // Show details dialog
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                          title: Text(
                            'Performance Metrics',
                            style: GoogleFonts.outfit(fontWeight: FontWeight.bold, color: AgentColors.primaryGreen),
                          ),
                          content: SingleChildScrollView(
                            child: ListBody(
                              children: [
                                Text(
                                  'Congratulations!',
                                  style: GoogleFonts.outfit(fontWeight: FontWeight.bold, fontSize: 16),
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  'Your collection rate is 98% this week, placing you among the top performing agents in the region.',
                                  style: GoogleFonts.outfit(),
                                ),
                                const SizedBox(height: 12),
                                Text(
                                  'Rewards:',
                                  style: GoogleFonts.outfit(fontWeight: FontWeight.bold),
                                ),
                                Text('• 1.5x Multiplier on next payout\n• Elite Agent badge on portal', style: GoogleFonts.outfit()),
                              ],
                            ),
                          ),
                          actions: [
                            TextButton(
                              child: Text('Close', style: GoogleFonts.outfit(color: AgentColors.primaryGreen, fontWeight: FontWeight.bold)),
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                            ),
                          ],
                        );
                      },
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    foregroundColor: AgentColors.primaryGreen,
                    elevation: 0,
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                  child: Text(
                    'Learn More',
                    style: GoogleFonts.outfit(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
