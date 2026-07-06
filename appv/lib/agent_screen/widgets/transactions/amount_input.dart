import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../constants/agent_colors.dart';

class AmountInput extends StatelessWidget {
  final TextEditingController controller;
  final Function(double increment) onIncrementPressed;

  const AmountInput({
    super.key,
    required this.controller,
    required this.onIncrementPressed,
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
        children: [
          Text(
            'Amount Received',
            style: GoogleFonts.outfit(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: AgentColors.textSecondary,
            ),
          ),
          const SizedBox(height: 16),
          
          // Big Amount Row (Rupee symbol + numeric input)
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                '₹',
                style: GoogleFonts.outfit(
                  fontSize: 38,
                  fontWeight: FontWeight.bold,
                  color: AgentColors.primaryGreen,
                ),
              ),
              const SizedBox(width: 12),
              IntrinsicWidth(
                child: TextField(
                  controller: controller,
                  keyboardType: const TextInputType.numberWithOptions(decimal: true),
                  textAlign: TextAlign.left,
                  style: GoogleFonts.outfit(
                    fontSize: 40,
                    fontWeight: FontWeight.bold,
                    color: AgentColors.textPrimary,
                  ),
                  decoration: InputDecoration(
                    hintText: '0.00',
                    hintStyle: GoogleFonts.outfit(
                      fontSize: 40,
                      fontWeight: FontWeight.bold,
                      color: AgentColors.textMuted,
                    ),
                    border: InputBorder.none,
                    isDense: true,
                    contentPadding: EdgeInsets.zero,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          
          // Quick Action Adders Row
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _buildQuickAdderButton(500),
              _buildQuickAdderButton(1000),
              _buildQuickAdderButton(5000),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildQuickAdderButton(double amount) {
    final amountString = amount.toInt().toString();

    return Expanded(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 6.0),
        child: OutlinedButton(
          onPressed: () {
            onIncrementPressed(amount);
          },
          style: OutlinedButton.styleFrom(
            backgroundColor: Colors.white,
            foregroundColor: AgentColors.textPrimary,
            side: const BorderSide(color: AgentColors.borderMuted, width: 1),
            padding: const EdgeInsets.symmetric(vertical: 12),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
          child: Text(
            '+ $amountString',
            style: GoogleFonts.outfit(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: AgentColors.textPrimary,
            ),
          ),
        ),
      ),
    );
  }
}
