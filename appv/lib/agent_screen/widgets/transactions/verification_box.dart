import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../constants/agent_colors.dart';

class VerificationBox extends StatelessWidget {
  final String paymentMode;

  const VerificationBox({
    super.key,
    this.paymentMode = 'cash',
  });

  @override
  Widget build(BuildContext context) {
    final bool isOnline = paymentMode.toLowerCase() == 'online';

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
          // Circular icon
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: isOnline ? const Color(0xFFE0F2FE) : AgentColors.pillGreenBackground,
              shape: BoxShape.circle,
            ),
            child: Icon(
              isOnline ? Icons.qr_code_scanner_rounded : Icons.payments_outlined,
              color: isOnline ? const Color(0xFF0284C7) : AgentColors.emeraldGreen,
              size: 26,
            ),
          ),
          const SizedBox(height: 12),

          // Instruction Text
          Text(
            isOnline
                ? 'Ensure the customer\'s online QR transaction is confirmed before submitting.'
                : 'Ensure you count the physical cash twice before submitting.',
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

