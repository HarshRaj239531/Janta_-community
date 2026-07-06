import 'dart:io';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:image_picker/image_picker.dart';
import '../../../constants/app_colors.dart';
import '../../../provider/profile_provider.dart';

class DocumentsTab extends StatelessWidget {
  const DocumentsTab({super.key});

  Future<void> _pickAndUpload(BuildContext context, String key) async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery, imageQuality: 70);

    if (pickedFile != null && context.mounted) {
      final pp = Provider.of<ProfileProvider>(context, listen: false);
      final file = File(pickedFile.path);
      final success = await pp.uploadVault({key: file});
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              success ? 'Document uploaded successfully!' : (pp.error ?? 'Upload failed'),
              style: GoogleFonts.outfit(),
            ),
            backgroundColor: success ? AppColors.successGreen : AppColors.errorAccent,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Consumer<ProfileProvider>(
      builder: (context, pp, child) {
        if (pp.isLoading && pp.vault == null) {
          return const Center(child: Padding(
            padding: EdgeInsets.all(40),
            child: CircularProgressIndicator(),
          ));
        }

        final vault = pp.vault ?? {};
        final aadhar = vault['aadhar_card'];
        final pan = vault['pan_card'];
        final photo = vault['photo'];
        final idProof = vault['id_proof'];

        return Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Secure Storage Banner
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColors.containerBgSoft,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Secure Storage',
                    style: GoogleFonts.outfit(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: theme.colorScheme.primary,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    'Your financial documents are encrypted and verified with institutional-grade security.',
                    style: GoogleFonts.outfit(
                      fontSize: 12,
                      color: AppColors.textSecondary,
                      height: 1.4,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // Document list items
            _buildDocumentDetailCard(
              context,
              title: 'Aadhar Card',
              description: 'Primary Identity Proof',
              icon: Icons.badge_outlined,
              fileUrl: aadhar,
              onUpload: () => _pickAndUpload(context, 'aadhar_card'),
              isUploading: pp.isUploading,
            ),
            const SizedBox(height: 12),
            _buildDocumentDetailCard(
              context,
              title: 'PAN Card',
              description: 'Tax Identifier Document',
              icon: Icons.credit_card_outlined,
              fileUrl: pan,
              onUpload: () => _pickAndUpload(context, 'pan_card'),
              isUploading: pp.isUploading,
            ),
            const SizedBox(height: 12),
            _buildDocumentDetailCard(
              context,
              title: 'Profile Photo',
              description: 'Official User Photograph',
              icon: Icons.account_circle_rounded,
              fileUrl: photo,
              onUpload: () => _pickAndUpload(context, 'photo'),
              isUploading: pp.isUploading,
            ),
            const SizedBox(height: 12),
            _buildDocumentDetailCard(
              context,
              title: 'Other ID Proof',
              description: 'Passport/Driving License',
              icon: Icons.description_rounded,
              fileUrl: idProof,
              onUpload: () => _pickAndUpload(context, 'id_proof'),
              isUploading: pp.isUploading,
            ),
            const SizedBox(height: 20),

            // Encryption Warning Panel
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColors.backgroundAlt,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(
                    Icons.shield_outlined,
                    color: theme.colorScheme.primary,
                    size: 20,
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      'Your data is stored using AES-256 encryption. Only authorized personnel can verify your identity during loan processing.',
                      style: GoogleFonts.outfit(
                        fontSize: 11,
                        color: AppColors.textSecondary,
                        height: 1.4,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 80),
          ],
        );
      },
    );
  }

  Widget _buildDocumentDetailCard(
    BuildContext context, {
    required String title,
    required String description,
    required IconData icon,
    required String? fileUrl,
    required VoidCallback onUpload,
    required bool isUploading,
  }) {
    final theme = Theme.of(context);
    final hasDoc = fileUrl != null && fileUrl.isNotEmpty;

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.borderLight),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: Container(
          decoration: BoxDecoration(
            border: Border(
              top: BorderSide(
                color: theme.colorScheme.primary,
                width: 3,
              ),
            ),
          ),
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: const BoxDecoration(
                      color: AppColors.lavenderSoft,
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      icon,
                      color: theme.colorScheme.primary,
                      size: 20,
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: hasDoc ? AppColors.successLight : AppColors.errorLight,
                      borderRadius: BorderRadius.circular(30),
                    ),
                    child: Row(
                      children: [
                        Icon(
                          hasDoc ? Icons.check_circle_rounded : Icons.pending_actions_rounded,
                          color: hasDoc ? theme.colorScheme.primary : AppColors.errorAccent,
                          size: 12,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          hasDoc ? 'VERIFIED' : 'PENDING UPLOAD',
                          style: GoogleFonts.outfit(
                            fontSize: 9,
                            fontWeight: FontWeight.bold,
                            color: hasDoc ? theme.colorScheme.primary : AppColors.errorDark,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Text(
                title,
                style: GoogleFonts.outfit(
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                description,
                style: GoogleFonts.outfit(
                  fontSize: 12,
                  color: AppColors.textSecondary,
                ),
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  if (hasDoc) ...[
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () {
                          // Preview Document URL (can be opened in a browser or webview dialog)
                          showDialog(
                            context: context,
                            builder: (context) {
                              return Dialog(
                                child: Container(
                                  padding: const EdgeInsets.all(8),
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Image.network(
                                        fileUrl,
                                        fit: BoxFit.contain,
                                        errorBuilder: (c, e, s) => const Icon(Icons.broken_image, size: 100),
                                      ),
                                      const SizedBox(height: 8),
                                      TextButton(
                                        onPressed: () => Navigator.pop(context),
                                        child: const Text('Close'),
                                      )
                                    ],
                                  ),
                                ),
                              );
                            },
                          );
                        },
                        style: OutlinedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          side: const BorderSide(color: AppColors.borderLight),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        child: Text(
                          'View',
                          style: GoogleFonts.outfit(
                            fontSize: 13,
                            fontWeight: FontWeight.bold,
                            color: AppColors.textSecondary,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                  ],
                  Expanded(
                    child: ElevatedButton(
                      onPressed: isUploading ? null : onUpload,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: theme.colorScheme.primary,
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: Text(
                        hasDoc ? 'Re-upload' : 'Upload File',
                        style: GoogleFonts.outfit(
                          fontSize: 13,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
