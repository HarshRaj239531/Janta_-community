import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../constants/agent_colors.dart';
import '../../screens/login/login_screen.dart';

class AgentHeader extends StatelessWidget {
  const AgentHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 12.0),
      child: Row(
        children: [
          // Avatar with a subtle premium border
          Container(
            padding: const EdgeInsets.all(2.0),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(
                color: AgentColors.accentMint.withAlpha(150),
                width: 2.0,
              ),
            ),
            child: const CircleAvatar(
              radius: 20,
              backgroundColor: AgentColors.pillGreenBackground,
              backgroundImage: NetworkImage(
                'https://images.unsplash.com/photo-1534528741775-53994a69daeb?auto=format&fit=crop&q=80&w=200',
              ),
            ),
          ),
          const SizedBox(width: 12),
          
          // User Greetings
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Welcome back, Agent',
                  style: GoogleFonts.outfit(
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                    color: AgentColors.textSecondary,
                  ),
                ),
                Text(
                  'Home Dashboard',
                  style: GoogleFonts.outfit(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: AgentColors.primaryGreen,
                    letterSpacing: -0.5,
                  ),
                ),
              ],
            ),
          ),
          
          // Notification Bell
          Stack(
            children: [
              IconButton(
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                        'No new notifications',
                        style: GoogleFonts.outfit(),
                      ),
                    ),
                  );
                },
                icon: const Icon(
                  Icons.notifications_none_outlined,
                  color: AgentColors.primaryGreen,
                  size: 26,
                ),
              ),
              Positioned(
                right: 12,
                top: 12,
                child: Container(
                  width: 8,
                  height: 8,
                  decoration: const BoxDecoration(
                    color: AgentColors.errorAccent,
                    shape: BoxShape.circle,
                  ),
                ),
              )
            ],
          ),
          
          // Logout Button
          IconButton(
            onPressed: () {
              // Log out and return to Login screen
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    title: Text(
                      'Logout',
                      style: GoogleFonts.outfit(fontWeight: FontWeight.bold),
                    ),
                    content: Text(
                      'Are you sure you want to log out?',
                      style: GoogleFonts.outfit(),
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
            },
            icon: const Icon(
              Icons.logout_rounded,
              color: AgentColors.primaryGreen,
              size: 24,
            ),
          ),
        ],
      ),
    );
  }
}
