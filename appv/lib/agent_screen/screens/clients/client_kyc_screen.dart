import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../constants/agent_colors.dart';

class ClientKycScreen extends StatefulWidget {
  const ClientKycScreen({super.key});

  @override
  State<ClientKycScreen> createState() => _ClientKycScreenState();
}

class _ClientKycScreenState extends State<ClientKycScreen> {
  String _selectedClient = 'Arjun Mehta (#88219)';
  String _selectedSource = 'Aadhar';
  
  bool _frontUploaded = false;
  bool _backUploaded = false;
  bool _isUploadingFront = false;
  bool _isUploadingBack = false;

  bool _biometricCaptured = false;
  bool _isScanning = false;
  double _scanProgress = 0.0;

  final List<String> _clients = [
    'Arjun Mehta (#88219)',
    'Sara Khan (#41120)',
    'Rohan Verma (#90821)',
    'Priya Nair (#88320)',
  ];

  void _uploadFile(bool isFront) {
    setState(() {
      if (isFront) {
        _isUploadingFront = true;
      } else {
        _isUploadingBack = true;
      }
    });

    Future.delayed(const Duration(milliseconds: 1200), () {
      if (mounted) {
        setState(() {
          if (isFront) {
            _isUploadingFront = false;
            _frontUploaded = true;
          } else {
            _isUploadingBack = false;
            _backUploaded = true;
          }
        });
      }
    });
  }

  void _startBiometricScan() {
    if (_biometricCaptured) return;
    
    setState(() {
      _isScanning = true;
      _scanProgress = 0.0;
    });

    // Simulate scanning progress
    const duration = Duration(milliseconds: 100);
    int count = 0;
    
    Future.doWhile(() async {
      await Future.delayed(duration);
      if (!mounted) return false;
      count++;
      setState(() {
        _scanProgress = count / 15.0; // 1.5 seconds total
      });
      if (count >= 15) {
        setState(() {
          _isScanning = false;
          _biometricCaptured = true;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            backgroundColor: AgentColors.successGreen,
            content: Text('Biometric face match verification successful!'),
          ),
        );
        return false;
      }
      return true;
    });
  }

  void _authorizeKyc() {
    if (!_frontUploaded || !_backUploaded) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          backgroundColor: AgentColors.errorDark,
          content: Text('Please upload both Front and Back sides of your ID.'),
        ),
      );
      return;
    }
    if (!_biometricCaptured) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          backgroundColor: AgentColors.errorDark,
          content: Text('Please perform biometric capture to verify live identity.'),
        ),
      );
      return;
    }

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        title: Column(
          children: [
            const Icon(Icons.verified_user_rounded, color: AgentColors.successGreen, size: 48),
            const SizedBox(height: 12),
            Text(
              'KYC Authorized',
              style: GoogleFonts.outfit(fontWeight: FontWeight.bold, color: AgentColors.primaryGreen),
            ),
          ],
        ),
        content: Text(
          'Verification for $_selectedClient has been authorized. The compliance certificate is now being synced with the secure network registry.',
          textAlign: TextAlign.center,
          style: GoogleFonts.outfit(fontSize: 14, color: AgentColors.textSecondary, height: 1.4),
        ),
        actions: [
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {
                Navigator.pop(context); // close dialog
                Navigator.pop(context); // return to dashboard
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

              // Verification Source Toggle
              _buildLabel('VERIFICATION SOURCE'),
              _buildSourceToggles(),
              const SizedBox(height: 20),

              // Upload Evidence dashed cards
              _buildLabel('UPLOAD EVIDENCE'),
              _buildUploadSection(),
              const SizedBox(height: 24),

              // Biometric Capture
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _buildLabel('BIOMETRIC CAPTURE'),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: AgentColors.successLight,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Row(
                      children: [
                        const Icon(Icons.circle, size: 6, color: AgentColors.successGreen),
                        const SizedBox(width: 4),
                        Text(
                          'LIVE ACTIVE',
                          style: GoogleFonts.outfit(
                            fontSize: 9,
                            fontWeight: FontWeight.bold,
                            color: AgentColors.successDark,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              _buildBiometricViewfinder(),
              const SizedBox(height: 24),

              // Verification Summary Box
              _buildSummaryCard(),
              const SizedBox(height: 20),

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
    return DropdownButtonFormField<String>(
      initialValue: _selectedClient,
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
      items: _clients.map((String client) {
        return DropdownMenuItem<String>(
          value: client,
          child: Text(client),
        );
      }).toList(),
      onChanged: (String? value) {
        if (value != null) {
          setState(() {
            _selectedClient = value;
          });
        }
      },
    );
  }

  Widget _buildSourceToggles() {
    final sources = ['Aadhar', 'PAN Card', 'Other ID'];
    final sourceIcons = {
      'Aadhar': Icons.badge_outlined,
      'PAN Card': Icons.credit_card_outlined,
      'Other ID': Icons.assignment_ind_outlined,
    };

    return Row(
      children: sources.map((src) {
        final isSelected = _selectedSource == src;
        return Expanded(
          child: Padding(
            padding: EdgeInsets.only(
              right: src != sources.last ? 10.0 : 0.0,
            ),
            child: InkWell(
              onTap: () {
                setState(() {
                  _selectedSource = src;
                });
              },
              borderRadius: BorderRadius.circular(12),
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 14),
                decoration: BoxDecoration(
                  color: isSelected ? AgentColors.primaryGreen : Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: isSelected ? AgentColors.primaryGreen : AgentColors.borderMuted,
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      sourceIcons[src],
                      size: 18,
                      color: isSelected ? Colors.white : AgentColors.textPrimary,
                    ),
                    const SizedBox(width: 6),
                    Text(
                      src,
                      style: GoogleFonts.outfit(
                        fontSize: 13,
                        fontWeight: FontWeight.bold,
                        color: isSelected ? Colors.white : AgentColors.textPrimary,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildUploadSection() {
    return Row(
      children: [
        Expanded(
          child: _buildUploadCard(
            title: 'Front Side',
            isUploaded: _frontUploaded,
            isUploading: _isUploadingFront,
            onTap: () => _uploadFile(true),
          ),
        ),
        const SizedBox(width: 14),
        Expanded(
          child: _buildUploadCard(
            title: 'Back Side',
            isUploaded: _backUploaded,
            isUploading: _isUploadingBack,
            onTap: () => _uploadFile(false),
          ),
        ),
      ],
    );
  }

  Widget _buildUploadCard({
    required String title,
    required bool isUploaded,
    required bool isUploading,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: isUploading || isUploaded ? null : onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        height: 120,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
        ),
        child: CustomPaint(
          painter: DashedBorderPainter(
            color: isUploaded ? AgentColors.successGreen : AgentColors.borderMuted,
            borderRadius: 16,
          ),
          child: Center(
            child: isUploading
                ? const SizedBox(
                    width: 24,
                    height: 24,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      valueColor: AlwaysStoppedAnimation<Color>(AgentColors.primaryGreen),
                    ),
                  )
                : isUploaded
                    ? Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(Icons.check_circle_rounded, color: AgentColors.successGreen, size: 28),
                          const SizedBox(height: 6),
                          Text(
                            'Uploaded',
                            style: GoogleFonts.outfit(
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                              color: AgentColors.successDark,
                            ),
                          ),
                        ],
                      )
                    : Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: AgentColors.backgroundSoft,
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(
                              Icons.camera_alt_outlined,
                              color: AgentColors.textSecondary,
                              size: 18,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            title,
                            style: GoogleFonts.outfit(
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                              color: AgentColors.textPrimary,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            'High-res JPEG',
                            style: GoogleFonts.outfit(
                              fontSize: 10,
                              color: AgentColors.textMuted,
                            ),
                          ),
                        ],
                      ),
          ),
        ),
      ),
    );
  }

  Widget _buildBiometricViewfinder() {
    return Container(
      height: 230,
      decoration: BoxDecoration(
        color: Colors.black87,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: _biometricCaptured ? AgentColors.successGreen : Colors.transparent,
          width: 2,
        ),
      ),
      child: Stack(
        fit: StackFit.expand,
        children: [
          // Background Camera mockup
          ClipRRect(
            borderRadius: BorderRadius.circular(22),
            child: Opacity(
              opacity: _biometricCaptured ? 0.35 : 0.65,
              child: Image.network(
                'https://images.unsplash.com/photo-1516035069371-29a1b244cc32?auto=format&fit=crop&q=80&w=400',
                fit: BoxFit.cover,
              ),
            ),
          ),

          // Custom oval scanner guide overlay
          if (!_biometricCaptured)
            Center(
              child: Container(
                width: 140,
                height: 170,
                decoration: BoxDecoration(
                  border: Border.all(
                    color: _isScanning ? AgentColors.primaryGreen : Colors.white54,
                    style: BorderStyle.solid,
                    width: 2,
                  ),
                  borderRadius: BorderRadius.all(
                    Radius.elliptical(140, 170),
                  ),
                ),
              ),
            ),

          // Scanning Line Animation overlay
          if (_isScanning)
            AnimatedAlign(
              alignment: Alignment(0.0, -1.0 + (_scanProgress * 2.0)),
              duration: const Duration(milliseconds: 100),
              child: Container(
                height: 3,
                width: 140,
                decoration: const BoxDecoration(
                  color: AgentColors.primaryGreen,
                  boxShadow: [
                    BoxShadow(
                      color: AgentColors.primaryGreen,
                      blurRadius: 8,
                      spreadRadius: 2,
                    )
                  ],
                ),
              ),
            ),

          // Central text
          Center(
            child: Padding(
              padding: const EdgeInsets.only(bottom: 70),
              child: Text(
                _biometricCaptured
                    ? 'BIOMETRIC RECORDED'
                    : _isScanning
                        ? 'SCANNING FACE... ${( _scanProgress * 100).toInt()}%'
                        : 'CENTER FACE IN FRAME',
                style: GoogleFonts.outfit(
                  color: _biometricCaptured ? AgentColors.successLight : Colors.white,
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 0.5,
                ),
              ),
            ),
          ),

          // Verified Tick Overlay
          if (_biometricCaptured)
            Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(
                    Icons.check_circle_rounded,
                    color: AgentColors.successGreen,
                    size: 48,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Verified',
                    style: GoogleFonts.outfit(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),

          // Viewfinder corners
          if (!_biometricCaptured) ...[
            Positioned(top: 16, left: 16, child: _buildCorner(true, true)),
            Positioned(top: 16, right: 16, child: _buildCorner(true, false)),
            Positioned(bottom: 16, left: 16, child: _buildCorner(false, true)),
            Positioned(bottom: 16, right: 16, child: _buildCorner(false, false)),
          ],

          // Shutter button at the bottom
          if (!_biometricCaptured && !_isScanning)
            Positioned(
              bottom: 14,
              left: 0,
              right: 0,
              child: Center(
                child: GestureDetector(
                  onTap: _startBiometricScan,
                  child: Container(
                    width: 48,
                    height: 48,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.white, width: 3),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(4.0),
                      child: Container(
                        decoration: const BoxDecoration(
                          color: Colors.white,
                          shape: BoxShape.circle,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildCorner(bool isTop, bool isLeft) {
    const len = 12.0;
    const thick = 2.0;
    return SizedBox(
      width: len,
      height: len,
      child: Stack(
        children: [
          Positioned(
            top: isTop ? 0 : null,
            bottom: !isTop ? 0 : null,
            left: 0,
            right: 0,
            child: Container(height: thick, color: Colors.white),
          ),
          Positioned(
            top: 0,
            bottom: 0,
            left: isLeft ? 0 : null,
            right: !isLeft ? 0 : null,
            child: Container(width: thick, color: Colors.white),
          ),
        ],
      ),
    );
  }

  Widget _buildSummaryCard() {
    return Container(
      padding: const EdgeInsets.all(20.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AgentColors.borderMuted, width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            'Verification Summary',
            style: GoogleFonts.outfit(
              fontSize: 15,
              fontWeight: FontWeight.bold,
              color: AgentColors.textPrimary,
            ),
          ),
          const SizedBox(height: 14),
          _buildSummaryRow('Identity Processing', '₹99.00', false),
          const SizedBox(height: 8),
          _buildSummaryRow('Biometric Verification', '₹50.00', false),
          const Divider(height: 24, color: AgentColors.borderMuted),
          _buildSummaryRow('Total Amount', '₹149.00', true),
        ],
      ),
    );
  }

  Widget _buildSummaryRow(String label, String value, bool isTotal) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: GoogleFonts.outfit(
            fontSize: isTotal ? 14 : 13,
            fontWeight: isTotal ? FontWeight.bold : FontWeight.w500,
            color: isTotal ? AgentColors.textPrimary : AgentColors.textSecondary,
          ),
        ),
        Text(
          value,
          style: GoogleFonts.outfit(
            fontSize: isTotal ? 18 : 13,
            fontWeight: FontWeight.bold,
            color: isTotal ? AgentColors.primaryGreen : AgentColors.textPrimary,
          ),
        ),
      ],
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
