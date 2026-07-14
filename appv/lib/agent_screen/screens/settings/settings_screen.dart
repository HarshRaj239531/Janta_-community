import 'dart:io';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import '../../constants/agent_colors.dart';
import '../../widgets/settings/agent_profile_header.dart';
import '../../widgets/settings/settings_tile.dart';
import '../../widgets/settings/settings_logout_button.dart';
import '../../../provider/profile_provider.dart';
import 'support_admin_screen.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool _isUploading = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<ProfileProvider>(context, listen: false).fetchProfile();
    });
  }

  Future<void> _pickAndUploadProfileImage() async {
    if (_isUploading) return;
    
    try {
      final picker = ImagePicker();
      final pickedFile = await picker.pickImage(
        source: ImageSource.gallery,
        imageQuality: 70,
      );

      if (pickedFile != null && mounted) {
        setState(() {
          _isUploading = true;
        });

        final pp = Provider.of<ProfileProvider>(context, listen: false);
        final file = File(pickedFile.path);
        final success = await pp.uploadVault({'photo': file});
        
        if (mounted) {
          await pp.fetchProfile();
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(
                  success ? 'Profile photo updated successfully!' : (pp.error ?? 'Upload failed'),
                  style: GoogleFonts.outfit(),
                ),
                backgroundColor: success ? Colors.green : Colors.redAccent,
              ),
            );
          }
        }
      }
    } catch (e) {
      debugPrint('Error picking image: $e');
    } finally {
      if (mounted) {
        setState(() {
          _isUploading = false;
        });
      }
    }
  }

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
              
              // 2. PROFILE SETTINGS Section
              _buildSectionHeader('PROFILE SETTINGS'),
              const SizedBox(height: 8),
              SettingsTile(
                leadingIcon: Icons.camera_alt_outlined,
                title: 'Update Profile Photo',
                trailing: _isUploading
                    ? const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: AgentColors.primaryGreen,
                        ),
                      )
                    : const Icon(
                        Icons.chevron_right_rounded,
                        color: AgentColors.textSecondary,
                        size: 20,
                      ),
                onTap: _pickAndUploadProfileImage,
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
  }
}
