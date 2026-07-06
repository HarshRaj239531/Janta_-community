import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../constants/agent_colors.dart';

class PaymentNotes extends StatelessWidget {
  final TextEditingController controller;

  const PaymentNotes({
    super.key,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
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
          Text(
            'Payment Notes (Optional)',
            style: GoogleFonts.outfit(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: AgentColors.textSecondary,
            ),
          ),
          const SizedBox(height: 10),
          
          // TextArea remarks input
          TextFormField(
            controller: controller,
            maxLines: 3,
            decoration: InputDecoration(
              hintText: 'Add any collection remarks...',
              hintStyle: GoogleFonts.outfit(
                color: AgentColors.textMuted,
                fontSize: 14,
              ),
              filled: true,
              fillColor: AgentColors.backgroundSoft,
              contentPadding: const EdgeInsets.all(12),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide.none,
              ),
            ),
            style: GoogleFonts.outfit(
              fontSize: 15,
              color: AgentColors.textPrimary,
            ),
          ),
        ],
      ),
    );
  }
}
