import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../constants/agent_colors.dart';

class ClientsHeader extends StatelessWidget {
  const ClientsHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'My Clients',
          style: GoogleFonts.outfit(
            fontSize: 28,
            fontWeight: FontWeight.bold,
            color: AgentColors.primaryGreen,
            letterSpacing: -0.5,
          ),
        ),
        const SizedBox(height: 6),
        Text(
          'Manage your portfolio and track client activity.',
          style: GoogleFonts.outfit(
            fontSize: 14,
            fontWeight: FontWeight.w400,
            color: AgentColors.textSecondary,
          ),
        ),
      ],
    );
  }
}
