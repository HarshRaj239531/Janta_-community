import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../constants/agent_colors.dart';

class PaymentModeSelector extends StatelessWidget {
  final String selectedMode; // 'cash' or 'online'
  final ValueChanged<String> onModeChanged;

  const PaymentModeSelector({
    super.key,
    required this.selectedMode,
    required this.onModeChanged,
  });

  @override
  Widget build(BuildContext context) {
    final isCash = selectedMode.toLowerCase() == 'cash';
    final isOnline = selectedMode.toLowerCase() == 'online';

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AgentColors.borderMuted, width: 1),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(6),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: AgentColors.emeraldGreen.withAlpha(25),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Icon(
                  Icons.account_balance_wallet_rounded,
                  color: AgentColors.emeraldGreen,
                  size: 20,
                ),
              ),
              const SizedBox(width: 10),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Payment Mode',
                    style: GoogleFonts.outfit(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                      color: AgentColors.textPrimary,
                    ),
                  ),
                  Text(
                    'Select how customer is paying',
                    style: GoogleFonts.outfit(
                      fontSize: 12,
                      color: AgentColors.textSecondary,
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 16),

          // Two Option Cards Side by Side
          Row(
            children: [
              // Option 1: Cash
              Expanded(
                child: _buildModeOption(
                  isSelected: isCash,
                  icon: Icons.payments_rounded,
                  title: 'Cash',
                  subtitle: 'Physical Notes',
                  onTap: () => onModeChanged('cash'),
                ),
              ),
              const SizedBox(width: 12),

              // Option 2: Online
              Expanded(
                child: _buildModeOption(
                  isSelected: isOnline,
                  icon: Icons.qr_code_2_rounded,
                  title: 'Online',
                  subtitle: 'UPI / QR Code',
                  onTap: () => onModeChanged('online'),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildModeOption({
    required bool isSelected,
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
        decoration: BoxDecoration(
          color: isSelected ? AgentColors.primaryGreen : const Color(0xFFF8FAFC),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isSelected ? AgentColors.primaryGreen : AgentColors.borderMuted,
            width: isSelected ? 2 : 1,
          ),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: AgentColors.primaryGreen.withAlpha(60),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ]
              : null,
        ),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Icon(
                  icon,
                  color: isSelected ? Colors.white : AgentColors.textSecondary,
                  size: 26,
                ),
                Icon(
                  isSelected ? Icons.check_circle_rounded : Icons.radio_button_unchecked,
                  color: isSelected ? Colors.white : AgentColors.borderMuted,
                  size: 18,
                ),
              ],
            ),
            const SizedBox(height: 10),
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                title,
                style: GoogleFonts.outfit(
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                  color: isSelected ? Colors.white : AgentColors.textPrimary,
                ),
              ),
            ),
            const SizedBox(height: 2),
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                subtitle,
                style: GoogleFonts.outfit(
                  fontSize: 11,
                  color: isSelected ? Colors.white.withAlpha(200) : AgentColors.textMuted,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
