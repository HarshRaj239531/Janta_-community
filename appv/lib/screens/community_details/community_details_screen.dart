import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../constants/app_colors.dart';
import '../../widgets/custom_bottom_navbar.dart';
import '../terms_conditions/terms_conditions_screen.dart';

class CommunityDetailsScreen extends StatefulWidget {
  final int committeeId;
  final String name;
  final String plan;
  final String goal;
  final String returnRate;
  final String category;
  final String groupId;

  const CommunityDetailsScreen({
    super.key,
    required this.committeeId,
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
          committeeId: widget.committeeId,
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
    final theme = Theme.of(context);
    return Scaffold(
      backgroundColor: AppColors.backgroundSoft,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0.5,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios_new_rounded, color: theme.colorScheme.primary),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'Community Details',
          style: GoogleFonts.outfit(
            fontWeight: FontWeight.bold,
            color: theme.colorScheme.primary,
            fontSize: 20,
          ),
        ),
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
                          color: theme.colorScheme.primary,
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
                          color: AppColors.textPrimary,
                          letterSpacing: -0.5,
                        ),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        _buildGroupBadge(context, widget.groupId, false),
                        const SizedBox(width: 8),
                        _buildGroupBadge(context, widget.category, true),
                      ],
                    ),
                    const SizedBox(height: 24),

                    // 3. Investment Summary Card
                    Container(
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(color: AppColors.borderMuted),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'INVESTMENT SUMMARY',
                            style: GoogleFonts.outfit(
                              fontSize: 11,
                              fontWeight: FontWeight.bold,
                              color: AppColors.textMuted,
                              letterSpacing: 0.5,
                            ),
                          ),
                          const SizedBox(height: 16),
                          _buildSummaryRow(context, 'Plan', widget.plan, true),
                          const SizedBox(height: 12),
                          _buildSummaryRow(context, 'Goal', widget.goal, false),
                          const SizedBox(height: 12),
                          _buildSummaryRow(context, 'Return', widget.returnRate, true),
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
                      decoration: BoxDecoration(
                        color: AppColors.containerBgSoft,
                        borderRadius: const BorderRadius.only(
                          topRight: Radius.circular(12),
                          bottomRight: Radius.circular(12),
                        ),
                        border: Border(
                          left: BorderSide(
                            color: theme.colorScheme.primary,
                            width: 4,
                          ),
                        ),
                      ),
                      padding: const EdgeInsets.all(16),
                      child: Text(
                        'By confirming, you agree to start your monthly contribution of ${widget.plan.replaceAll('Monthly ', '').replaceAll('Daily ', '')} to the ${widget.name} pool. Your first contribution will be debited within 24 hours.',
                        style: GoogleFonts.outfit(
                          fontSize: 13,
                          color: AppColors.textSecondary,
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
                          backgroundColor: theme.colorScheme.primary,
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
                          color: AppColors.textSecondary,
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
              showAllTabs: true,
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
  Widget _buildGroupBadge(BuildContext context, String label, bool isCategory) {
    final theme = Theme.of(context);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: isCategory ? AppColors.successLight : AppColors.lavenderSoft,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Text(
        label,
        style: GoogleFonts.outfit(
          fontSize: 11,
          fontWeight: FontWeight.bold,
          color: isCategory ? theme.colorScheme.primary : AppColors.textSecondary,
        ),
      ),
    );
  }

  // Summary row builder helper
  Widget _buildSummaryRow(BuildContext context, String key, String value, bool isGreen) {
    final theme = Theme.of(context);
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          key,
          style: GoogleFonts.outfit(
            fontSize: 14,
            color: AppColors.textSecondary,
            fontWeight: FontWeight.w500,
          ),
        ),
        Text(
          value,
          style: GoogleFonts.outfit(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: isGreen ? theme.colorScheme.primary : AppColors.textPrimary,
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
        color: AppColors.lavenderSoft, // Light blue tint
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.borderLight),
      ),
      child: Row(
        mainAxisAlignment: isFullWidth ? MainAxisAlignment.spaceBetween : MainAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                icon,
                color: AppColors.primaryGreen,
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
                      color: AppColors.textSecondary,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    value,
                    style: GoogleFonts.outfit(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textPrimary,
                    ),
                  ),
                ],
              ),
            ],
          ),
          if (isFullWidth)
            const Icon(
              Icons.info_outline_rounded,
              color: AppColors.textMuted,
              size: 18,
            ),
        ],
      ),
    );
  }
}
