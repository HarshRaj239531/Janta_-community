import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../constants/agent_colors.dart';
import '../../widgets/settings/agent_profile_header.dart';
import '../../widgets/settings/settings_tile.dart';
import '../../widgets/settings/settings_logout_button.dart';
import 'support_admin_screen.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool _isDarkMode = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AgentColors.backgroundSoft,
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 20),
              
              // 1. Profile Header
              const AgentProfileHeader(),
              const SizedBox(height: 36),
              
              // 2. APP PREFERENCES Section
              _buildSectionHeader('APP PREFERENCES'),
              const SizedBox(height: 8),
              SettingsTile(
                leadingIcon: Icons.nights_stay_outlined,
                title: 'Dark Mode',
                trailing: Switch(
                  value: _isDarkMode,
                  activeThumbColor: AgentColors.primaryGreen,
                  activeTrackColor: AgentColors.primaryGreen.withAlpha(100),
                  onChanged: (bool value) {
                    setState(() {
                      _isDarkMode = value;
                    });
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                          _isDarkMode ? 'Dark Mode Enabled' : 'Light Mode Enabled',
                          style: GoogleFonts.outfit(),
                        ),
                        duration: const Duration(seconds: 1),
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(height: 24),
              
              // 3. SUPPORT Section
              _buildSectionHeader('SUPPORT'),
              const SizedBox(height: 8),
              SettingsTile(
                leadingIcon: Icons.help_outline_rounded,
                title: 'Contact Admin',
                trailing: const Icon(
                  Icons.chevron_right_rounded,
                  color: AgentColors.textSecondary,
                  size: 20,
                ),
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => const SupportAdminScreen(),
                    ),
                  );
                },
              ),
              const SizedBox(height: 36),
              
              // 4. Logout Button
              const SettingsLogoutButton(),
              const SizedBox(height: 48),
              
              // 5. Version Info Footer
              Text(
                'App Version 4.12.0 (Build 220)',
                textAlign: TextAlign.center,
                style: GoogleFonts.outfit(
                  fontSize: 12,
                  color: AgentColors.textMuted,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.only(left: 4.0),
      child: Text(
        title,
        style: GoogleFonts.outfit(
          fontSize: 12,
          fontWeight: FontWeight.bold,
          color: AgentColors.textSecondary,
          letterSpacing: 0.5,
        ),
      ),
    );
  }}
