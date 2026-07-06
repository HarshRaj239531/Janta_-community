import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../constants/agent_colors.dart';

class AgentProfileHeader extends StatelessWidget {
  const AgentProfileHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Avatar Stack with Verified Badge
        Stack(
          children: [
            Container(
              padding: const EdgeInsets.all(3.0),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: AgentColors.borderMuted,
                  width: 1.5,
                ),
              ),
              child: const CircleAvatar(
                radius: 46,
                backgroundColor: AgentColors.pillGreenBackground,
                backgroundImage: NetworkImage(
                  'https://images.unsplash.com/photo-1560250097-0b93528c311a?auto=format&fit=crop&q=80&w=200',
                ),
              ),
            ),
            // Verified Badge positioned at bottom-right
            Positioned(
              right: 2,
              bottom: 2,
              child: Container(
                padding: const EdgeInsets.all(2.0),
                decoration: const BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.verified_rounded,
                  color: AgentColors.primaryGreen,
                  size: 22,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        
        // Agent Name
        Text(
          'Agent Rahul Sharma',
          style: GoogleFonts.outfit(
            fontSize: 22,
            fontWeight: FontWeight.bold,
            color: AgentColors.primaryGreen,
          ),
        ),
        const SizedBox(height: 4),
        
        // Credentials subtext
        Text(
          '#AG-99281 • Verified Senior Agent',
          style: GoogleFonts.outfit(
            fontSize: 13,
            fontWeight: FontWeight.w500,
            color: AgentColors.textSecondary,
          ),
        ),
      ],
    );
  }
}
