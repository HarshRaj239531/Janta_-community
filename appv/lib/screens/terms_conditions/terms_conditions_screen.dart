import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../constants/app_colors.dart';
import 'package:provider/provider.dart';
import '../../provider/committee_provider.dart';
import '../membership_status/membership_status_screen.dart';

class TermsConditionsScreen extends StatefulWidget {
  final int committeeId;
  final String name;
  final String plan;
  final String returnRate;

  const TermsConditionsScreen({
    super.key,
    required this.committeeId,
    required this.name,
    required this.plan,
    required this.returnRate,
  });

  @override
  State<TermsConditionsScreen> createState() => _TermsConditionsScreenState();
}

class _TermsConditionsScreenState extends State<TermsConditionsScreen> {
  bool _isAgreed = false;
  bool _isLoading = false;

  void _acceptAndContinue() async {
    setState(() {
      _isLoading = true;
    });

    final committeeProvider = Provider.of<CommitteeProvider>(context, listen: false);
    final success = await committeeProvider.joinCommittee(widget.committeeId);

    if (!mounted) return;

    setState(() {
      _isLoading = false;
    });

    if (success) {
      final selectedIndex = await Navigator.push<int>(
        context,
        MaterialPageRoute(
          builder: (context) => MembershipStatusScreen(
            name: widget.name,
            plan: widget.plan,
            returnRate: widget.returnRate,
          ),
        ),
      );

      if (selectedIndex != null && mounted) {
        Navigator.pop(context, selectedIndex);
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            committeeProvider.error ?? 'Failed to join committee. Please try again.',
            style: GoogleFonts.outfit(),
          ),
          backgroundColor: AppColors.errorAccent,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final cleanPlanValue = widget.plan.replaceAll('Monthly ', '').replaceAll('Daily ', '');
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0.5,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios_new_rounded, color: theme.colorScheme.primary),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'Terms & Conditions',
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
            // Scrollable Terms Document
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'LAST UPDATED: JUNE 2024',
                      style: GoogleFonts.outfit(
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                        color: AppColors.textMuted,
                        letterSpacing: 0.5,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Welcome to ${widget.name}',
                      style: GoogleFonts.outfit(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      'By joining the ${widget.name} within the Janta Trader ecosystem, you agree to comply with and be bound by the following terms and conditions. These terms ensure a secure and profitable environment for all members of our exclusive circle.',
                      style: GoogleFonts.outfit(
                        fontSize: 13,
                        color: AppColors.textSecondary,
                        height: 1.4,
                      ),
                    ),
                    const SizedBox(height: 28),

                    // 1. Membership Eligibility
                    _buildSectionHeader(context, '1', 'Membership Eligibility', false),
                    const SizedBox(height: 8),
                    _buildSectionContent(
                      'Membership is restricted to individuals who have reached the legal age of majority in their jurisdiction. All applicants must undergo a mandatory identity verification (KYC) process and provide proof of financial standing to maintain the group\'s accreditation status.',
                    ),
                    const SizedBox(height: 24),

                    // 2. Investment Contributions (Bordered Box)
                    _buildSectionHeader(context, '2', 'Investment Contributions', false),
                    const SizedBox(height: 12),
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: AppColors.backgroundAlt,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: AppColors.borderLight),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'To maintain active status, members must adhere to the following contribution schedule:',
                            style: GoogleFonts.outfit(
                              fontSize: 13,
                              color: AppColors.textSecondary,
                              height: 1.4,
                            ),
                          ),
                          const SizedBox(height: 16),
                          _buildContributionBullet(
                            icon: Icons.check_circle_outline_rounded,
                            iconColor: AppColors.successGreen,
                            text: 'A mandatory Monthly commitment of $cleanPlanValue.',
                          ),
                          const SizedBox(height: 12),
                          _buildContributionBullet(
                            icon: Icons.access_time_rounded,
                            iconColor: AppColors.successGreen,
                            text: 'Contributions must be made by the 5th of every month.',
                          ),
                          const SizedBox(height: 12),
                          _buildContributionBullet(
                            icon: Icons.error_outline_rounded,
                            iconColor: AppColors.errorAccent,
                            text: 'Late fees of 2% apply to any contribution delayed beyond the 10th.',
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 24),

                    // 3. Withdrawal Policy
                    _buildSectionHeader(context, '3', 'Withdrawal Policy', false),
                    const SizedBox(height: 8),
                    _buildSectionContent(
                      'Elite funds are subject to a 12-month initial lock-in period to ensure capital stability. Subsequent withdrawals require a written notice of at least 30 business days. Early withdrawals may be subject to a 5% liquidity adjustment fee.',
                    ),
                    const SizedBox(height: 24),

                    // 4. Risk Disclosure (Red Alert Box)
                    _buildSectionHeader(context, '4', 'Risk Disclosure', true),
                    const SizedBox(height: 12),
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: AppColors.errorLight,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: AppColors.errorBorder),
                      ),
                      child: RichText(
                        text: TextSpan(
                          style: GoogleFonts.outfit(
                            fontSize: 13,
                            color: AppColors.errorDark,
                            height: 1.4,
                          ),
                          children: [
                            const TextSpan(text: 'Investments are subject to market risks. While our managed portfolio targets a benchmark return of '),
                            TextSpan(
                              text: widget.returnRate,
                              style: const TextStyle(fontWeight: FontWeight.bold),
                            ),
                            const TextSpan(text: ', these returns are '),
                            const TextSpan(
                              text: 'not guaranteed',
                              style: TextStyle(decoration: TextDecoration.underline),
                            ),
                            const TextSpan(text: '. Past performance is not indicative of future results.'),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),

                    // 5. Data Privacy & Security
                    _buildSectionHeader(context, '5', 'Data Privacy & Security', false),
                    const SizedBox(height: 8),
                    _buildSectionContent(
                      'Your financial data is protected using AES-256 encryption. We do not share your personal information with third-party marketers. For a detailed breakdown, please refer to our Global Privacy Policy.',
                    ),
                    const SizedBox(height: 28),

                    // Disclaimer block
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: AppColors.backgroundAlt,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        '“Janta Trader acts solely as an intermediary platform. The ${widget.name} is a self-governed body, and Janta Trader assumes no liability for internal group disputes or investment decisions made by the group council.”',
                        style: GoogleFonts.outfit(
                          fontSize: 12,
                          fontStyle: FontStyle.italic,
                          color: AppColors.textSecondary,
                          height: 1.4,
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),
                  ],
                ),
              ),
            ),

            // Consent Sticky Footer
            Container(
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
              padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Consent Checkbox
                  Row(
                    children: [
                      Checkbox(
                        value: _isAgreed,
                        activeColor: theme.colorScheme.primary,
                        onChanged: (value) {
                          setState(() {
                            _isAgreed = value ?? false;
                          });
                        },
                      ),
                      Expanded(
                        child: Text(
                          'I have read and agree to the Terms of Service.',
                          style: GoogleFonts.outfit(
                            fontSize: 13,
                            fontWeight: FontWeight.w500,
                            color: AppColors.textPrimary,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  // Action Button
                  SizedBox(
                    height: 50,
                    child: ElevatedButton(
                      onPressed: (_isAgreed && !_isLoading) ? _acceptAndContinue : null,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: theme.colorScheme.primary,
                        disabledBackgroundColor: Colors.grey.shade300,
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: _isLoading
                          ? SizedBox(
                              width: 24,
                              height: 24,
                              child: CircularProgressIndicator(
                                color: Colors.white,
                                strokeWidth: 2,
                              ),
                            )
                          : Text(
                              'Accept & Continue',
                              style: GoogleFonts.outfit(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: _isAgreed ? Colors.white : Colors.grey.shade500,
                              ),
                            ),
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  // Header Builder helper for Number tag + title
  Widget _buildSectionHeader(BuildContext context, String index, String title, bool isRed) {
    final theme = Theme.of(context);
    return Row(
      children: [
        Container(
          width: 24,
          height: 24,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: AppColors.lavenderSoft,
            borderRadius: BorderRadius.circular(6),
          ),
          child: Text(
            index,
            style: GoogleFonts.outfit(
              fontSize: 12,
              fontWeight: FontWeight.bold,
              color: isRed ? AppColors.errorAccent : theme.colorScheme.primary,
            ),
          ),
        ),
        const SizedBox(width: 10),
        Text(
          title,
          style: GoogleFonts.outfit(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: isRed ? AppColors.errorAccent : theme.colorScheme.primary,
          ),
        ),
      ],
    );
  }

  // Section content paragraph helper
  Widget _buildSectionContent(String text) {
    return Text(
      text,
      style: GoogleFonts.outfit(
        fontSize: 13,
        color: AppColors.textSecondary,
        height: 1.4,
      ),
    );
  }

  // Bullet point builder for Item 2
  Widget _buildContributionBullet({
    required IconData icon,
    required Color iconColor,
    required String text,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(
          icon,
          color: iconColor,
          size: 18,
        ),
        const SizedBox(width: 10),
        Expanded(
          child: Text(
            text,
            style: GoogleFonts.outfit(
              fontSize: 13,
              color: AppColors.textSecondary,
              height: 1.3,
            ),
          ),
        ),
      ],
    );
  }
}
