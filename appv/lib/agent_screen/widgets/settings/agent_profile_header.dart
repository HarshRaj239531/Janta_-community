import 'dart:io';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import '../../constants/agent_colors.dart';
import '../../../provider/profile_provider.dart';

class AgentProfileHeader extends StatefulWidget {
  const AgentProfileHeader({super.key});

  @override
  State<AgentProfileHeader> createState() => _AgentProfileHeaderState();
}

class _AgentProfileHeaderState extends State<AgentProfileHeader> {
  bool _isUploading = false;

  Future<void> _pickAndUploadPhoto(BuildContext context) async {
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
    final profileProvider = Provider.of<ProfileProvider>(context);
    final user = profileProvider.profile;
    
    final name = user?.name ?? 'Loading...';
    final photoUrl = user?.photo;
    final agentIdSubtext = user != null ? '#AG-${user.id} • Verified Field Agent' : 'Loading Profile...';

    return Column(
      children: [
        GestureDetector(
          onTap: () => _pickAndUploadPhoto(context),
          child: Stack(
            children: [
              Container(
                padding: const EdgeInsets.all(3.0),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: AgentColors.borderMuted,
                    width: 1.5,
                  ),
                ),
                child: CircleAvatar(
                  radius: 46,
                  backgroundColor: AgentColors.pillGreenBackground,
                  backgroundImage: photoUrl != null && photoUrl.isNotEmpty
                      ? NetworkImage(photoUrl)
                      : const NetworkImage(
                          'https://images.unsplash.com/photo-1560250097-0b93528c311a?auto=format&fit=crop&q=80&w=200',
                        ),
                  child: _isUploading
                      ? const CircularProgressIndicator(
                          color: AgentColors.primaryGreen,
                        )
                      : null,
                ),
              ),
              // Camera Edit Badge positioned at bottom-right instead of verified check
              Positioned(
                right: 2,
                bottom: 2,
                child: Container(
                  padding: const EdgeInsets.all(4.0),
                  decoration: const BoxDecoration(
                    color: AgentColors.primaryGreen,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.camera_alt_rounded,
                    color: Colors.white,
                    size: 16,
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        
        // Agent Name
        Text(
          name,
          style: GoogleFonts.outfit(
            fontSize: 22,
            fontWeight: FontWeight.bold,
            color: AgentColors.primaryGreen,
          ),
        ),
        const SizedBox(height: 4),
        
        // Credentials subtext
        Text(
          agentIdSubtext,
          style: GoogleFonts.outfit(
            fontSize: 13,
            fontWeight: FontWeight.w500,
            color: AgentColors.textSecondary,
          ),
        ),
      ],
    );
  }
}
