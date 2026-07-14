import 'dart:io';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:image_picker/image_picker.dart';
import '../../constants/agent_colors.dart';
import '../../provider/agent_provider.dart';
import '../../../helpers/shared_prefs_helper.dart';

class ClientKycScreen extends StatefulWidget {
  final int? clientId;
  final String? clientName;

  const ClientKycScreen({
    super.key,
    this.clientId,
    this.clientName,
  });

  @override
  State<ClientKycScreen> createState() => _ClientKycScreenState();
}

class _ClientKycScreenState extends State<ClientKycScreen> {
  int? _selectedClientId;
  String? _selectedClientName;
  
  File? _aadharFrontImage;
  File? _aadharBackImage;
  File? _panFrontImage;

  @override
  void initState() {
    super.initState();
    if (widget.clientId != null) {
      _selectedClientId = widget.clientId;
      _selectedClientName = widget.clientName;
    }
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final ap = Provider.of<AgentProvider>(context, listen: false);
      if (ap.clientsSummary == null) {
        ap.fetchClients();
      }
      
      if (widget.clientId != null) {
        ap.fetchClientDetails(widget.clientId!);
      } else {
        // If none passed, default selection to first client if available
        if (ap.clientsSummary?.recentClients.isNotEmpty == true) {
          final firstClient = ap.clientsSummary!.recentClients.first;
          setState(() {
            _selectedClientId = firstClient.id;
            _selectedClientName = firstClient.name;
          });
          ap.fetchClientDetails(firstClient.id);
        }
      }
    });
  }

  Future<void> _pickImage(String type) async {
    final picker = ImagePicker();
    final source = await showModalBottomSheet<ImageSource>(
      context: context,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(16))),
      backgroundColor: Colors.white,
      builder: (context) => SafeArea(
        child: Wrap(
          children: [
            ListTile(
              leading: const Icon(Icons.camera_alt_outlined, color: AgentColors.primaryGreen),
              title: Text('Take Photo', style: GoogleFonts.outfit(fontWeight: FontWeight.w500)),
              onTap: () => Navigator.pop(context, ImageSource.camera),
            ),
            ListTile(
              leading: const Icon(Icons.photo_library_outlined, color: AgentColors.primaryGreen),
              title: Text('Choose from Gallery', style: GoogleFonts.outfit(fontWeight: FontWeight.w500)),
              onTap: () => Navigator.pop(context, ImageSource.gallery),
            ),
          ],
        ),
      ),
    );

    if (source == null) return;

    final pickedFile = await picker.pickImage(
      source: source,
      imageQuality: 70,
    );

    if (pickedFile != null) {
      setState(() {
        if (type == 'aadhar_front') {
          _aadharFrontImage = File(pickedFile.path);
        } else if (type == 'aadhar_back') {
          _aadharBackImage = File(pickedFile.path);
        } else if (type == 'pan_front') {
          _panFrontImage = File(pickedFile.path);
        }
      });
    }
  }


  Future<void> _authorizeKyc() async {
    if (_selectedClientId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          backgroundColor: AgentColors.errorDark,
          content: Text('Please select a client for KYC verification.'),
        ),
      );
      return;
    }
    if (_aadharFrontImage == null && _panFrontImage == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          backgroundColor: AgentColors.errorDark,
          content: Text('Please upload at least Aadhaar Front or PAN Front document.'),
        ),
      );
      return;
    }

    // Show loading spinner dialog
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => const Center(
        child: CircularProgressIndicator(
          valueColor: AlwaysStoppedAnimation<Color>(AgentColors.primaryGreen),
        ),
      ),
    );

    try {
      final ap = Provider.of<AgentProvider>(context, listen: false);
      await ap.submitClientKyc(
        userId: _selectedClientId!,
        aadharFront: _aadharFrontImage,
        aadharBack: _aadharBackImage,
        panFront: _panFrontImage,
      );

      if (mounted) {
        Navigator.pop(context); // pop loading dialog
        
        // Show success confirmation dialog
        showDialog(
          context: context,
          barrierDismissible: false,
          builder: (context) => AlertDialog(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
            title: Column(
              children: [
                const Icon(Icons.verified_user_rounded, color: AgentColors.successGreen, size: 48),
                const SizedBox(height: 12),
                Text(
                  'KYC Submitted',
                  style: GoogleFonts.outfit(fontWeight: FontWeight.bold, color: AgentColors.primaryGreen),
                ),
              ],
            ),
            content: Text(
              'KYC documents for $_selectedClientName have been successfully submitted to the server.',
              textAlign: TextAlign.center,
              style: GoogleFonts.outfit(fontSize: 14, color: AgentColors.textSecondary, height: 1.4),
            ),
            actions: [
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context); // close dialog
                    Navigator.pop(context); // return to previous screen
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AgentColors.primaryGreen,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    padding: const EdgeInsets.symmetric(vertical: 14),
                  ),
                  child: Text(
                    'Done',
                    style: GoogleFonts.outfit(fontWeight: FontWeight.bold, color: Colors.white),
                  ),
                ),
              ),
            ],
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        Navigator.pop(context); // pop loading dialog
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            backgroundColor: AgentColors.errorDark,
            content: Text('Failed to upload KYC: $e'),
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AgentColors.backgroundSoft,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded, color: AgentColors.primaryGreen),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text(
          'Client KYC',
          style: GoogleFonts.outfit(
            fontWeight: FontWeight.bold,
            color: AgentColors.primaryGreen,
            fontSize: 20,
          ),
        ),
        shape: Border(
          bottom: BorderSide(
            color: AgentColors.borderMuted.withAlpha(120),
            width: 1.5,
          ),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Intro
              Text(
                'Client KYC',
                style: GoogleFonts.outfit(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: AgentColors.textPrimary,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                'Verify client identity and secure high-value compliance.',
                style: GoogleFonts.outfit(
                  fontSize: 13,
                  color: AgentColors.textSecondary,
                ),
              ),
              const SizedBox(height: 20),

              // Stepper Progress bar
              _buildStepper(),
              const SizedBox(height: 24),

              // Client Selection Dropdown
              _buildLabel('CLIENT SELECTION'),
              _buildClientSelector(),
              const SizedBox(height: 20),

              // Document list items (User App style!)
              Consumer<AgentProvider>(
                builder: (context, ap, child) {
                  if (ap.isProfileLoading) {
                    return const Center(
                      child: Padding(
                        padding: EdgeInsets.all(30),
                        child: CircularProgressIndicator(
                          valueColor: AlwaysStoppedAnimation<Color>(AgentColors.primaryGreen),
                        ),
                      ),
                    );
                  }

                  final personalDetails = ap.clientProfile?.personalDetails;
                  
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      _buildDocumentDetailCard(
                        title: 'Aadhar Front Side',
                        description: 'Primary Identity Proof Front',
                        icon: Icons.badge_outlined,
                        serverUrl: personalDetails?.aadharCard,
                        localFile: _aadharFrontImage,
                        onUpload: () => _pickImage('aadhar_front'),
                        onClear: () => setState(() => _aadharFrontImage = null),
                      ),
                      _buildDocumentDetailCard(
                        title: 'Aadhar Back Side',
                        description: 'Primary Identity Proof Back',
                        icon: Icons.badge_outlined,
                        serverUrl: personalDetails?.idProof,
                        localFile: _aadharBackImage,
                        onUpload: () => _pickImage('aadhar_back'),
                        onClear: () => setState(() => _aadharBackImage = null),
                      ),
                      _buildDocumentDetailCard(
                        title: 'PAN Card Front Side',
                        description: 'Tax Identifier Document',
                        icon: Icons.credit_card_outlined,
                        serverUrl: personalDetails?.panCard,
                        localFile: _panFrontImage,
                        onUpload: () => _pickImage('pan_front'),
                        onClear: () => setState(() => _panFrontImage = null),
                      ),
                    ],
                  );
                },
              ),
              const SizedBox(height: 32),

              // Authorize Button
              SizedBox(
                height: 52,
                child: ElevatedButton(
                  onPressed: _authorizeKyc,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AgentColors.primaryGreen,
                    foregroundColor: Colors.white,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.verified_user_outlined, size: 18),
                      const SizedBox(width: 8),
                      Text(
                        'Authorize Verification',
                        style: GoogleFonts.outfit(fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 14),

              // Footer Secure Hub Text
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.lock_outline_rounded, size: 12, color: AgentColors.textMuted),
                  const SizedBox(width: 4),
                  Text(
                    'END-TO-END ENCRYPTED SECURE HUB',
                    style: GoogleFonts.outfit(
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                      color: AgentColors.textMuted,
                      letterSpacing: 0.5,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLabel(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Text(
        text,
        style: GoogleFonts.outfit(
          fontSize: 11,
          fontWeight: FontWeight.bold,
          color: AgentColors.textSecondary,
          letterSpacing: 0.3,
        ),
      ),
    );
  }

  Widget _buildStepper() {
    return Row(
      children: [
        _buildStepNode(Icons.person_rounded, 'Identity', true),
        _buildStepLine(true),
        _buildStepNode(Icons.description_rounded, 'Documents', true),
        _buildStepLine(false),
        _buildStepNode(Icons.check_circle_outline_rounded, 'Verification', false),
      ],
    );
  }

  Widget _buildStepNode(IconData icon, String label, bool isActive) {
    return Column(
      children: [
        Container(
          width: 38,
          height: 38,
          decoration: BoxDecoration(
            color: isActive ? AgentColors.primaryGreen : Colors.white,
            shape: BoxShape.circle,
            border: Border.all(
              color: isActive ? AgentColors.primaryGreen : AgentColors.borderMuted,
              width: 1.5,
            ),
          ),
          child: Icon(
            icon,
            color: isActive ? Colors.white : AgentColors.textSecondary,
            size: 18,
          ),
        ),
        const SizedBox(height: 6),
        Text(
          label,
          style: GoogleFonts.outfit(
            fontSize: 11,
            fontWeight: isActive ? FontWeight.bold : FontWeight.w500,
            color: isActive ? AgentColors.primaryGreen : AgentColors.textSecondary,
          ),
        ),
      ],
    );
  }

  Widget _buildStepLine(bool isActive) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.only(bottom: 16.0),
        child: Container(
          height: 2,
          color: isActive ? AgentColors.primaryGreen : AgentColors.borderMuted,
        ),
      ),
    );
  }

  Widget _buildClientSelector() {
    if (widget.clientId != null) {
      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: AgentColors.borderMuted),
        ),
        child: Row(
          children: [
            const Icon(Icons.person_outline_rounded, color: AgentColors.primaryGreen, size: 20),
            const SizedBox(width: 10),
            Text(
              widget.clientName ?? '',
              style: GoogleFonts.outfit(
                color: AgentColors.textPrimary,
                fontSize: 15,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      );
    }

    final ap = Provider.of<AgentProvider>(context);
    final clientsList = ap.clientsSummary?.recentClients ?? [];

    if (clientsList.isEmpty) {
      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: AgentColors.borderMuted),
        ),
        child: Text(
          'No clients found',
          style: GoogleFonts.outfit(color: AgentColors.textMuted, fontSize: 15),
        ),
      );
    }

    return DropdownButtonFormField<int>(
      value: _selectedClientId,
      decoration: InputDecoration(
        filled: true,
        fillColor: Colors.white,
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AgentColors.borderMuted),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AgentColors.primaryGreen),
        ),
      ),
      icon: const Icon(Icons.unfold_more_rounded, color: AgentColors.textSecondary),
      style: GoogleFonts.outfit(color: AgentColors.textPrimary, fontSize: 15, fontWeight: FontWeight.w500),
      dropdownColor: Colors.white,
      items: clientsList.map((client) {
        return DropdownMenuItem<int>(
          value: client.id,
          child: Text('${client.name} (#${client.id})'),
        );
      }).toList(),
      onChanged: (int? value) {
        if (value != null) {
          final chosen = clientsList.firstWhere((c) => c.id == value);
          setState(() {
            _selectedClientId = value;
            _selectedClientName = chosen.name;
          });
          Provider.of<AgentProvider>(context, listen: false).fetchClientDetails(value);
        }
      },
    );
  }





  Widget _buildDocumentDetailCard({
    required String title,
    required String description,
    required IconData icon,
    required String? serverUrl,
    required File? localFile,
    required VoidCallback onUpload,
    required VoidCallback onClear,
  }) {
    final hasDoc = localFile != null || (serverUrl != null && serverUrl.isNotEmpty);
    final isLocal = localFile != null;

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AgentColors.borderMuted),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: Container(
          decoration: const BoxDecoration(
            border: Border(
              top: BorderSide(color: AgentColors.primaryGreen, width: 3),
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
                    decoration: BoxDecoration(
                      color: AgentColors.primaryGreen.withAlpha(20),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      icon,
                      color: AgentColors.primaryGreen,
                      size: 20,
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: hasDoc
                          ? AgentColors.successLight
                          : AgentColors.errorLight,
                      borderRadius: BorderRadius.circular(30),
                    ),
                    child: Row(
                      children: [
                        Icon(
                          hasDoc
                              ? Icons.check_circle_rounded
                              : Icons.pending_actions_rounded,
                          color: hasDoc
                              ? AgentColors.successGreen
                              : AgentColors.errorDark,
                          size: 12,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          hasDoc 
                              ? (isLocal ? 'SELECTED (LOCAL)' : 'VERIFIED') 
                              : 'PENDING UPLOAD',
                          style: GoogleFonts.outfit(
                            fontSize: 9,
                            fontWeight: FontWeight.bold,
                            color: hasDoc
                                ? AgentColors.successDark
                                : AgentColors.errorDark,
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
                  color: AgentColors.textPrimary,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                description,
                style: GoogleFonts.outfit(
                  fontSize: 12,
                  color: AgentColors.textSecondary,
                ),
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  if (hasDoc) ...[
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () {
                          showDialog(
                            context: context,
                            builder: (context) {
                              return Dialog(
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                                child: Container(
                                  padding: const EdgeInsets.all(16),
                                  child: isLocal
                                      ? Column(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            ClipRRect(
                                              borderRadius: BorderRadius.circular(12),
                                              child: Image.file(
                                                localFile,
                                                fit: BoxFit.contain,
                                              ),
                                            ),
                                            const SizedBox(height: 12),
                                            TextButton(
                                              onPressed: () => Navigator.pop(context),
                                              child: Text('Close', style: GoogleFonts.outfit(fontWeight: FontWeight.bold)),
                                            ),
                                          ],
                                        )
                                      : FutureBuilder<String?>(
                                          future: SharedPrefsHelper.getToken(),
                                          builder: (context, snapshot) {
                                            if (snapshot.connectionState == ConnectionState.waiting) {
                                              return const SizedBox(
                                                height: 100,
                                                child: Center(
                                                  child: CircularProgressIndicator(
                                                    valueColor: AlwaysStoppedAnimation<Color>(AgentColors.primaryGreen),
                                                  ),
                                                ),
                                              );
                                            }
                                            final token = snapshot.data;
                                            return Column(
                                              mainAxisSize: MainAxisSize.min,
                                              children: [
                                                ClipRRect(
                                                  borderRadius: BorderRadius.circular(12),
                                                  child: Image.network(
                                                    serverUrl!,
                                                    fit: BoxFit.contain,
                                                    headers: token != null ? {
                                                      'Authorization': 'Bearer $token',
                                                    } : null,
                                                    errorBuilder: (c, e, s) => const Icon(
                                                      Icons.broken_image_rounded,
                                                      color: AgentColors.textMuted,
                                                      size: 100,
                                                    ),
                                                  ),
                                                ),
                                                const SizedBox(height: 12),
                                                TextButton(
                                                  onPressed: () => Navigator.pop(context),
                                                  child: Text('Close', style: GoogleFonts.outfit(fontWeight: FontWeight.bold)),
                                                ),
                                              ],
                                            );
                                          },
                                        ),
                                ),
                              );
                            },
                          );
                        },
                        style: OutlinedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          side: const BorderSide(color: AgentColors.borderMuted),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        child: Text(
                          'View',
                          style: GoogleFonts.outfit(
                            fontWeight: FontWeight.bold,
                            color: AgentColors.textPrimary,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: OutlinedButton(
                        onPressed: onUpload,
                        style: OutlinedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          side: const BorderSide(color: AgentColors.borderMuted),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        child: Text(
                          'Change',
                          style: GoogleFonts.outfit(
                            fontWeight: FontWeight.bold,
                            color: AgentColors.textPrimary,
                          ),
                        ),
                      ),
                    ),
                  ] else ...[
                    Expanded(
                      child: ElevatedButton(
                        onPressed: onUpload,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AgentColors.primaryGreen,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        child: Text(
                          'Upload Document',
                          style: GoogleFonts.outfit(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ],
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class DashedBorderPainter extends CustomPainter {
  final Color color;
  final double strokeWidth;
  final double dashWidth;
  final double dashSpace;
  final double borderRadius;

  DashedBorderPainter({
    required this.color,
    this.strokeWidth = 1.2,
    this.dashWidth = 5.0,
    this.dashSpace = 3.0,
    this.borderRadius = 12.0,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = strokeWidth
      ..style = PaintingStyle.stroke;

    final RRect rrect = RRect.fromRectAndRadius(
      Rect.fromLTWH(0, 0, size.width, size.height),
      Radius.circular(borderRadius),
    );

    final Path path = Path()..addRRect(rrect);
    final Path dashPath = Path();

    double distance = 0.0;
    for (PathMetric measurePath in path.computeMetrics()) {
      while (distance < measurePath.length) {
        dashPath.addPath(
          measurePath.extractPath(distance, distance + dashWidth),
          Offset.zero,
        );
        distance += dashWidth + dashSpace;
      }
    }
    canvas.drawPath(dashPath, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
