import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../constants/agent_colors.dart';
import '../../../../screens/login/login_screen.dart';

class SettingsLogoutButton extends StatelessWidget {
  const SettingsLogoutButton({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 56,
      decoration: BoxDecoration(
        color: AgentColors.errorLight,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: AgentColors.errorBorder,
          width: 1.2,
        ),
      ),
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(16),
        child: InkWell(
          onTap: () {
            _showLogoutConfirmationDialog(context);
          },
          borderRadius: BorderRadius.circular(16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(
                Icons.logout_rounded,
                color: AgentColors.errorDark,
                size: 20,
              ),
              const SizedBox(width: 8),
              Text(
                'Logout',
                style: GoogleFonts.outfit(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: AgentColors.errorDark,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showLogoutConfirmationDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          title: Text(
            'Logout',
            style: GoogleFonts.outfit(fontWeight: FontWeight.bold, color: AgentColors.primaryGreen),
          ),
          content: Text(
            'Are you sure you want to log out of your session?',
            style: GoogleFonts.outfit(fontSize: 15),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text(
                'Cancel',
                style: GoogleFonts.outfit(color: AgentColors.textSecondary),
              ),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close dialog
                Navigator.of(context).pushReplacement(
                  MaterialPageRoute(builder: (context) => const LoginScreen()),
                );
              },
              child: Text(
                'Logout',
                style: GoogleFonts.outfit(
                  color: AgentColors.errorAccent,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
