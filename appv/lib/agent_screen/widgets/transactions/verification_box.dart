import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../constants/agent_colors.dart';

class VerificationBox extends StatelessWidget {
  const VerificationBox({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 20.0),
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
        children: [
          // Circular cash icon in light green
          Container(
            padding: const EdgeInsets.all(12),
            decoration: const BoxDecoration(
              color: AgentColors.pillGreenBackground,
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.payments_outlined,
              color: AgentColors.emeraldGreen,
              size: 26,
            ),
          ),
          const SizedBox(height: 12),
          
          // Instruction Text
          Text(
            'Ensure you count the physical cash twice before submitting.',
            textAlign: TextAlign.center,
            style: GoogleFonts.outfit(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: AgentColors.textPrimary,
              height: 1.4,
            ),
          ),
        ],
      ),
    );
  }
}
