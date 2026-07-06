import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../constants/agent_colors.dart';

class ClientsSearch extends StatelessWidget {
  final ValueChanged<String> onChanged;

  const ClientsSearch({
    super.key,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AgentColors.backgroundSoft,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: AgentColors.borderMuted,
          width: 1,
        ),
      ),
      child: TextField(
        onChanged: onChanged,
        style: GoogleFonts.outfit(
          fontSize: 15,
          color: AgentColors.textPrimary,
        ),
        decoration: InputDecoration(
          prefixIcon: const Icon(
            Icons.search_rounded,
            color: AgentColors.textSecondary,
            size: 22,
          ),
          hintText: 'Find members by name or ID...',
          hintStyle: GoogleFonts.outfit(
            color: AgentColors.textMuted,
            fontSize: 15,
          ),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        ),
      ),
    );
  }
}
