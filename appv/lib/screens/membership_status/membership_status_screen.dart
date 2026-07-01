import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../home/home_screen.dart';

class MembershipStatusScreen extends StatelessWidget {
  final String name;
  final String plan;
  final String returnRate;

  const MembershipStatusScreen({
    super.key,
    required this.name,
    required this.plan,
    required this.returnRate,
  });

  @override
  Widget build(BuildContext context) {
    final cleanPlanValue = plan.replaceAll('Monthly ', '').replaceAll('Daily ', '');

    return Scaffold(
      backgroundColor: const Color(0xFFF3F5F8),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0.5,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, color: Color(0xFF0F4C3A)),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'Membership Status',
          style: GoogleFonts.outfit(
            fontWeight: FontWeight.bold,
            color: const Color(0xFF0F4C3A),
            fontSize: 20,
          ),
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // 1. Group Icon Banner & Subtitle
                    Center(
                      child: Container(
                        width: 70,
                        height: 70,
                        decoration: BoxDecoration(
                          color: const Color(0xFF0F4C3A),
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: const Icon(
                          Icons.groups_rounded,
                          color: Colors.white,
                          size: 36,
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      name,
                      textAlign: TextAlign.center,
                      style: GoogleFonts.outfit(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: const Color(0xFF1E293B),
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Join an exclusive circle of high-yield strategic partners and financial experts.',
                      textAlign: TextAlign.center,
                      style: GoogleFonts.outfit(
                        fontSize: 12,
                        color: const Color(0xFF6B7280),
                      ),
                    ),
                    const SizedBox(height: 20),

                    // 2. Timeline Status Card
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(color: const Color(0xFFE5E7EB)),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Verification in Progress',
                            style: GoogleFonts.outfit(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              color: const Color(0xFF0F4C3A),
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'We are currently reviewing your documents. This usually takes 24–48 hours.',
                            style: GoogleFonts.outfit(
                              fontSize: 12,
                              color: const Color(0xFF6B7280),
                            ),
                          ),
                          const SizedBox(height: 24),

                          // Custom Timeline Stepper
                          _buildTimelineStep(
                            isCompleted: true,
                            isActive: false,
                            title: 'Application Submitted',
                            description: 'October 24, 2023 • 10:45 AM',
                            icon: Icons.check_circle_rounded,
                            showLine: true,
                          ),
                          _buildTimelineStep(
                            isCompleted: false,
                            isActive: true,
                            title: 'Document Verification',
                            description: 'Currently being processed by our compliance team.',
                            icon: Icons.lens_blur_rounded,
                            showLine: true,
                          ),
                          _buildTimelineStep(
                            isCompleted: false,
                            isActive: false,
                            title: 'Final Approval',
                            description: 'Estimated completion by October 26, 2023.',
                            icon: Icons.lock_outline_rounded,
                            showLine: false,
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),

                    // 3. Group Details Section
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: const Color(0xFFEEF2FA), // Lavender tint
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(color: const Color(0xFFE2E8F0)),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              const Icon(Icons.info_outline_rounded, color: Color(0xFF64748B), size: 18),
                              const SizedBox(width: 8),
                              Text(
                                'GROUP DETAILS',
                                style: GoogleFonts.outfit(
                                  fontSize: 11,
                                  fontWeight: FontWeight.bold,
                                  color: const Color(0xFF64748B),
                                  letterSpacing: 0.5,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 12),
                          // Card 1
                          _buildDetailsCard('Monthly Contribution', cleanPlanValue),
                          const SizedBox(height: 8),
                          // Card 2
                          _buildDetailsCard('Expected Return', returnRate),
                          const SizedBox(height: 12),
                          // Guard Protocol alert
                          Container(
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: const Color(0xFFE2E8F0),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Row(
                              children: [
                                const Icon(Icons.shield_outlined, color: Color(0xFF0F4C3A), size: 18),
                                const SizedBox(width: 10),
                                Expanded(
                                  child: Text(
                                    'Your funds are protected by our Group Guarantee Protocol.',
                                    style: GoogleFonts.outfit(
                                      fontSize: 11,
                                      fontWeight: FontWeight.w600,
                                      color: const Color(0xFF334155),
                                    ),
                                  ),
                                )
                              ],
                            ),
                          )
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),

                    // 4. Emerald Gem Image Banner
                    ClipRRect(
                      borderRadius: BorderRadius.circular(16),
                      child: SizedBox(
                        height: 110,
                        child: Image.network(
                          'https://images.unsplash.com/photo-1617038260897-41a1f14a8ca0?w=600',
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) {
                            return Container(
                              decoration: const BoxDecoration(
                                gradient: LinearGradient(
                                  colors: [Color(0xFF0F4C3A), Color(0xFF0A3427)],
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                ),
                              ),
                              child: const Icon(
                                Icons.diamond_outlined,
                                color: Colors.white60,
                                size: 40,
                              ),
                            );
                          },
                          loadingBuilder: (context, child, progress) {
                            if (progress == null) return child;
                            return Container(
                              color: Colors.grey.shade100,
                              alignment: Alignment.center,
                              child: const SizedBox(
                                width: 20,
                                height: 20,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF0F4C3A)),
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                  ],
                ),
              ),
            ),

            // Fixed bottom Explore button panel
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
              decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withAlpha(6),
                    blurRadius: 10,
                    offset: const Offset(0, -4),
                  )
                ],
              ),
              child: SizedBox(
                height: 50,
                child: ElevatedButton.icon(
                  onPressed: () {
                    HomeScreen.activeTabNotifier.value = 1; // Switch to Community tab
                    Navigator.of(context).popUntil((route) => route.isFirst);
                  },
                  icon: const Icon(Icons.explore_rounded, color: Colors.white, size: 18),
                  label: Text(
                    'Explore Other Communities',
                    style: GoogleFonts.outfit(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF0F4C3A),
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  // Inner Details Card builder
  Widget _buildDetailsCard(String label, String value) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: GoogleFonts.outfit(
              fontSize: 13,
              fontWeight: FontWeight.w500,
              color: const Color(0xFF64748B),
            ),
          ),
          Text(
            value,
            style: GoogleFonts.outfit(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: const Color(0xFF1E293B),
            ),
          ),
        ],
      ),
    );
  }

  // Timeline Stepper builder helper
  Widget _buildTimelineStep({
    required bool isCompleted,
    required bool isActive,
    required String title,
    required String description,
    required IconData icon,
    required bool showLine,
  }) {
    Color iconColor;
    Color titleColor;

    if (isCompleted) {
      iconColor = const Color(0xFF0F4C3A);
      titleColor = const Color(0xFF1F2937);
    } else if (isActive) {
      iconColor = const Color(0xFF10B981);
      titleColor = const Color(0xFF0F4C3A);
    } else {
      iconColor = const Color(0xFFCBD5E1);
      titleColor = const Color(0xFF94A3B8);
    }

    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Timeline indicator (left)
          Column(
            children: [
              Icon(
                icon,
                color: iconColor,
                size: 20,
              ),
              if (showLine)
                Expanded(
                  child: Container(
                    width: 2,
                    color: isCompleted ? const Color(0xFF0F4C3A) : const Color(0xFFE2E8F0),
                    margin: const EdgeInsets.symmetric(vertical: 4),
                  ),
                ),
            ],
          ),
          const SizedBox(width: 16),
          // Content description (right)
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: GoogleFonts.outfit(
                    fontSize: 13,
                    fontWeight: FontWeight.bold,
                    color: titleColor,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  description,
                  style: GoogleFonts.outfit(
                    fontSize: 11,
                    color: const Color(0xFF64748B),
                    height: 1.3,
                  ),
                ),
                const SizedBox(height: 20),
              ],
            ),
          )
        ],
      ),
    );
  }
}
