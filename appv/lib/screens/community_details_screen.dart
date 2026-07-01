import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../widgets/custom_bottom_navbar.dart';
import 'terms_conditions_screen.dart';

class CommunityDetailsScreen extends StatefulWidget {
  final String name;
  final String plan;
  final String goal;
  final String returnRate;
  final String category;
  final String groupId;

  const CommunityDetailsScreen({
    super.key,
    this.name = 'Elite Investors Group',
    this.plan = 'Monthly ₹10,000',
    this.goal = '₹50 Lakhs',
    this.returnRate = '14% p.a.',
    this.category = 'Premium Finance',
    this.groupId = '#EIG-2024',
  });

  @override
  State<CommunityDetailsScreen> createState() => _CommunityDetailsScreenState();
}

class _CommunityDetailsScreenState extends State<CommunityDetailsScreen> {
  final int _selectedNavIndex = 1; // Highlight Community tab

  void _confirmMembership() async {
    final selectedIndex = await Navigator.push<int>(
      context,
      MaterialPageRoute(
        builder: (context) => TermsConditionsScreen(
          name: widget.name,
          plan: widget.plan,
          returnRate: widget.returnRate,
        ),
      ),
    );

    if (selectedIndex != null && mounted) {
      Navigator.pop(context, selectedIndex);
    }
  }

  @override
  Widget build(BuildContext context) {
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
          'Community Details',
          style: GoogleFonts.outfit(
            fontWeight: FontWeight.bold,
            color: const Color(0xFF0F4C3A),
            fontSize: 20,
          ),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16.0),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(18),
              child: Image.network(
                'https://images.unsplash.com/photo-1472099645785-5658abf4ff4e?w=150',
                width: 36,
                height: 36,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) => Container(
                  width: 36,
                  height: 36,
                  color: const Color(0xFF0F4C3A),
                  child: const Icon(Icons.person, color: Colors.white, size: 18),
                ),
              ),
            ),
          ),
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            // Scrollable Content
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const SizedBox(height: 12),

                    // 1. Group Icon Banner
                    Center(
                      child: Container(
                        width: 80,
                        height: 80,
                        decoration: BoxDecoration(
                          color: const Color(0xFF0F4C3A),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: const Icon(
                          Icons.groups_rounded,
                          color: Colors.white,
                          size: 40,
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),

                    // 2. Group Name & Badges
                    Center(
                      child: Text(
                        widget.name,
                        textAlign: TextAlign.center,
                        style: GoogleFonts.outfit(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: const Color(0xFF1E293B),
                          letterSpacing: -0.5,
                        ),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        _buildGroupBadge(widget.groupId, false),
                        const SizedBox(width: 8),
                        _buildGroupBadge(widget.category, true),
                      ],
                    ),
                    const SizedBox(height: 24),

                    // 3. Investment Summary Card
                    Container(
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(color: const Color(0xFFE5E7EB)),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'INVESTMENT SUMMARY',
                            style: GoogleFonts.outfit(
                              fontSize: 11,
                              fontWeight: FontWeight.bold,
                              color: const Color(0xFF9CA3AF),
                              letterSpacing: 0.5,
                            ),
                          ),
                          const SizedBox(height: 16),
                          _buildSummaryRow('Plan', widget.plan, true),
                          const SizedBox(height: 12),
                          _buildSummaryRow('Goal', widget.goal, false),
                          const SizedBox(height: 12),
                          _buildSummaryRow('Return', widget.returnRate, true),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),

                    // 4. Statistics row (2x cards + 1x full width card)
                    Row(
                      children: [
                        Expanded(
                          child: _buildMetricCard(
                            icon: Icons.eco_outlined,
                            title: 'Total Members',
                            value: '1,250+',
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: _buildMetricCard(
                            icon: Icons.account_balance_outlined,
                            title: 'Total AUM',
                            value: '₹42.8M',
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    _buildMetricCard(
                      icon: Icons.shield_outlined,
                      title: 'Risk Profile',
                      value: 'Moderate',
                      isFullWidth: true,
                    ),
                    const SizedBox(height: 24),

                    // 5. Monthly Declaration Box
                    Container(
                      decoration: const BoxDecoration(
                        color: Color(0xFFF3F5FC),
                        borderRadius: BorderRadius.only(
                          topRight: Radius.circular(12),
                          bottomRight: Radius.circular(12),
                        ),
                        border: Border(
                          left: BorderSide(
                            color: Color(0xFF0F4C3A),
                            width: 4,
                          ),
                        ),
                      ),
                      padding: const EdgeInsets.all(16),
                      child: Text(
                        'By confirming, you agree to start your monthly contribution of ${widget.plan.replaceAll('Monthly ', '').replaceAll('Daily ', '')} to the ${widget.name} pool. Your first contribution will be debited within 24 hours.',
                        style: GoogleFonts.outfit(
                          fontSize: 13,
                          color: const Color(0xFF475569),
                          height: 1.4,
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),

                    // 6. Action Button & Terms link
                    SizedBox(
                      height: 52,
                      child: ElevatedButton(
                        onPressed: _confirmMembership,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF0F4C3A),
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: Text(
                          'Confirm Membership',
                          style: GoogleFonts.outfit(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    Center(
                      child: Text(
                        'View Terms & Conditions',
                        style: GoogleFonts.outfit(
                          fontSize: 12,
                          color: const Color(0xFF6B7280),
                          decoration: TextDecoration.underline,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                  ],
                ),
              ),
            ),
            // Custom Bottom Navigation Footer
            CustomBottomNavBar(
              selectedIndex: _selectedNavIndex,
              onTabSelected: (index) {
                // Return to HomeScreen while passing target index
                Navigator.pop(context, index);
              },
            ),
          ],
        ),
      ),
    );
  }

  // Group Badges builder helper
  Widget _buildGroupBadge(String label, bool isCategory) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: isCategory ? const Color(0xFFD1FAE5) : const Color(0xFFEEF2F6),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Text(
        label,
        style: GoogleFonts.outfit(
          fontSize: 11,
          fontWeight: FontWeight.bold,
          color: isCategory ? const Color(0xFF0F4C3A) : const Color(0xFF6B7280),
        ),
      ),
    );
  }

  // Summary row builder helper
  Widget _buildSummaryRow(String key, String value, bool isGreen) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          key,
          style: GoogleFonts.outfit(
            fontSize: 14,
            color: const Color(0xFF6B7280),
            fontWeight: FontWeight.w500,
          ),
        ),
        Text(
          value,
          style: GoogleFonts.outfit(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: isGreen ? const Color(0xFF0F4C3A) : const Color(0xFF1E293B),
          ),
        ),
      ],
    );
  }

  // Stat / Metric card builder helper
  Widget _buildMetricCard({
    required IconData icon,
    required String title,
    required String value,
    bool isFullWidth = false,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFEEF2FA), // Light blue tint
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFE2E8F0)),
      ),
      child: Row(
        mainAxisAlignment: isFullWidth ? MainAxisAlignment.spaceBetween : MainAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                icon,
                color: const Color(0xFF0F4C3A),
                size: 20,
              ),
              const SizedBox(width: 12),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: GoogleFonts.outfit(
                      fontSize: 11,
                      color: const Color(0xFF6B7280),
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    value,
                    style: GoogleFonts.outfit(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: const Color(0xFF1E293B),
                    ),
                  ),
                ],
              ),
            ],
          ),
          if (isFullWidth)
            const Icon(
              Icons.info_outline_rounded,
              color: Color(0xFF94A3B8),
              size: 18,
            ),
        ],
      ),
    );
  }
}
