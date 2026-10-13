import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../../constants/app_colors.dart';
import '../../provider/committee_provider.dart';
import '../../provider/installment_provider.dart';
import '../../models/committee_model.dart';
import '../community_details/community_details_screen.dart';

class CommunityScreen extends StatefulWidget {
  final bool showAppBar;
  final ValueChanged<int>? onTabSelected;

  const CommunityScreen({
    super.key,
    this.showAppBar = false,
    this.onTabSelected,
  });

  @override
  State<CommunityScreen> createState() => _CommunityScreenState();
}

class _CommunityScreenState extends State<CommunityScreen> {
  // 0: Live Committee (Available to join), 1: My Active (Joined by user)
  int _activeFilterIndex = 0;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _refreshData();
    });
  }

  Future<void> _refreshData() async {
    final cp = Provider.of<CommitteeProvider>(context, listen: false);
    final ip = Provider.of<InstallmentProvider>(context, listen: false);
    await Future.wait([
      cp.fetchCommittees(),
      cp.fetchMyCommittees(),
      ip.fetchPending(),
      ip.fetchPaid(),
    ]);
  }

  String _formatCurrency(double amount) {
    final formatter = NumberFormat.currency(
      locale: 'en_IN',
      symbol: '₹',
      decimalDigits: 0,
    );
    return formatter.format(amount);
  }

  void _openCommunityDetails(CommitteeModel committee, {required bool isEnrolled}) async {
    final selectedIndex = await Navigator.push<int>(
      context,
      MaterialPageRoute(
        builder: (context) => CommunityDetailsScreen(
          committeeId: committee.id,
          name: committee.name ?? 'Committee',
          plan: '${committee.frequencyLabel} ${_formatCurrency(committee.monthlyAmount)}',
          goal: _formatCurrency(committee.amount ?? 0),
          returnRate: '${committee.returnPercentage ?? 0}%',
          groupId: '#${committee.id}',
          category: committee.paymentFrequency ?? 'N/A',
          startDate: committee.startDateFormatted,
          endDate: committee.endDateFormatted,
          period: committee.periodLabel,
          isJoined: isEnrolled,
        ),
      ),
    );

    if (selectedIndex != null && mounted) {
      if (widget.onTabSelected != null) {
        widget.onTabSelected!(selectedIndex);
      } else {
        Navigator.pop(context, selectedIndex);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    final body = Consumer<CommitteeProvider>(
      builder: (context, cp, child) {
        if (cp.isLoading && cp.committees.isEmpty && cp.myCommittees.isEmpty) {
          return const Center(
            child: Padding(
              padding: EdgeInsets.all(40),
              child: CircularProgressIndicator(),
            ),
          );
        }

        final error = cp.error;
        final liveCommittees = cp.committees;
        final myCommittees = cp.myCommittees;

        // Current list based on active tab
        final isLiveTab = _activeFilterIndex == 0;
        final currentList = isLiveTab ? liveCommittees : myCommittees;

        return RefreshIndicator(
          onRefresh: _refreshData,
          color: theme.colorScheme.primary,
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Error banner if any
                if (error != null)
                  Container(
                    margin: const EdgeInsets.only(bottom: 12),
                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                    decoration: BoxDecoration(
                      color: AppColors.errorLight,
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(color: AppColors.errorBorder),
                    ),
                    child: Row(
                      children: [
                        Icon(Icons.error_outline_rounded, color: AppColors.errorAccent, size: 20),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Text(
                            'Sync failed: $error',
                            style: GoogleFonts.outfit(
                              color: AppColors.errorDark,
                              fontSize: 12,
                            ),
                          ),
                        ),
                        IconButton(
                          icon: const Icon(Icons.refresh_rounded, size: 18, color: AppColors.errorDark),
                          padding: EdgeInsets.zero,
                          constraints: const BoxConstraints(),
                          onPressed: _refreshData,
                        ),
                      ],
                    ),
                  ),

                // Modern Segmented Tab Switcher: [ Live Committee ] [ My Active ]
                Container(
                  height: 46,
                  decoration: BoxDecoration(
                    color: const Color(0xFFE5E7EB),
                    borderRadius: BorderRadius.circular(24),
                  ),
                  padding: const EdgeInsets.all(4),
                  child: Row(
                    children: [
                      Expanded(
                        child: _buildFilterTab(
                          index: 0,
                          label: 'Live Committee',
                          icon: Icons.groups_rounded,
                          count: liveCommittees.length,
                        ),
                      ),
                      const SizedBox(width: 4),
                      Expanded(
                        child: _buildFilterTab(
                          index: 1,
                          label: 'My Active',
                          icon: Icons.verified_user_rounded,
                          count: myCommittees.length,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 12),

                // Subtitle context header
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      isLiveTab ? 'Available Pools to Join' : 'My Enrolled Committees',
                      style: GoogleFonts.outfit(
                        fontSize: 13,
                        fontWeight: FontWeight.w700,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    Text(
                      '${currentList.length} ${currentList.length == 1 ? 'Plan' : 'Plans'}',
                      style: GoogleFonts.outfit(
                        fontSize: 11,
                        fontWeight: FontWeight.bold,
                        color: theme.colorScheme.primary,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),

                // Dynamic Content Section
                if (currentList.isEmpty)
                  isLiveTab
                      ? _buildEmptyLiveState()
                      : _buildEmptyMyActiveState()
                else ...[
                  ...currentList.asMap().entries.map((entry) {
                    final index = entry.key;
                    final committee = entry.value;
                    final isEnrolled = myCommittees.any((m) => m.id == committee.id);

                    return TweenAnimationBuilder<double>(
                      tween: Tween<double>(begin: 0.0, end: 1.0),
                      duration: Duration(milliseconds: 250 + (index * 60)),
                      curve: Curves.easeOutCubic,
                      builder: (context, value, child) {
                        return Transform.translate(
                          offset: Offset(0, 16 * (1 - value)),
                          child: Opacity(opacity: value, child: child),
                        );
                      },
                      child: Padding(
                        padding: const EdgeInsets.only(bottom: 16),
                        child: _buildCommitteeCard(
                          context,
                          committee: committee,
                          isMyActiveTab: !isLiveTab,
                          isEnrolled: isEnrolled,
                        ),
                      ),
                    );
                  }),
                  // Trust & Benefits Information Section
                  _buildTrustBanner(theme),
                ],
                const SizedBox(height: 20),
              ],
            ),
          ),
        );
      },
    );

    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0.5,
        automaticallyImplyLeading: widget.showAppBar,
        leading: widget.showAppBar
            ? IconButton(
                icon: const Icon(
                  Icons.arrow_back_ios_new_rounded,
                  color: AppColors.textDark,
                ),
                onPressed: () => Navigator.pop(context),
              )
            : null,
        title: Row(
          children: [
            Icon(
              Icons.groups_rounded,
              color: theme.colorScheme.primary,
              size: 24,
            ),
            const SizedBox(width: 8),
            Text(
              'Available Committee',
              style: GoogleFonts.outfit(
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimary,
                fontSize: 20,
              ),
            ),
          ],
        ),
        actions: [
          Consumer<CommitteeProvider>(
            builder: (context, cp, _) {
              final isLiveTab = _activeFilterIndex == 0;
              final count = isLiveTab ? cp.committees.length : cp.myCommittees.length;
              return Padding(
                padding: const EdgeInsets.only(right: 14.0),
                child: Center(
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                    decoration: BoxDecoration(
                      color: isLiveTab ? const Color(0xFFECFDF5) : const Color(0xFFEFF6FF),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                        color: isLiveTab ? const Color(0xFFA7F3D0) : const Color(0xFFBFDBFE),
                      ),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                          width: 7,
                          height: 7,
                          decoration: BoxDecoration(
                            color: isLiveTab ? const Color(0xFF10B981) : const Color(0xFF3B82F6),
                            shape: BoxShape.circle,
                          ),
                        ),
                        const SizedBox(width: 5),
                        Text(
                          isLiveTab ? '$count LIVE' : '$count ACTIVE',
                          style: GoogleFonts.outfit(
                            fontSize: 10,
                            fontWeight: FontWeight.w800,
                            color: isLiveTab ? const Color(0xFF065F46) : const Color(0xFF1E40AF),
                            letterSpacing: 0.5,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        ],
      ),
      body: body,
    );
  }

  // --- WIDGET: Trust & Benefits Information Section ---
  Widget _buildTrustBanner(ThemeData theme) {
    return Container(
      margin: const EdgeInsets.only(top: 4, bottom: 8),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: const Color(0xFFE5E7EB)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(5),
            blurRadius: 10,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.shield_outlined, color: theme.colorScheme.primary, size: 18),
              const SizedBox(width: 8),
              Text(
                'Why Join Janta Committee?',
                style: GoogleFonts.outfit(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          _buildBenefitItem(
            Icons.verified_user_outlined,
            '100% Verified Committee',
            'Safe, collaborative peer-to-peer savings plans.',
          ),
          const SizedBox(height: 8),
          _buildBenefitItem(
            Icons.trending_up_rounded,
            'Guaranteed Return & Draw',
            'Transparent lottery allotment and scheduled payout.',
          ),
          const SizedBox(height: 8),
          _buildBenefitItem(
            Icons.support_agent_rounded,
            'Doorstep & QR Collection',
            'Pay contributions smoothly via Cash or UPI QR with authorized agents.',
          ),
        ],
      ),
    );
  }

  Widget _buildBenefitItem(IconData icon, String title, String subtitle) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: 16, color: const Color(0xFF059669)),
        const SizedBox(width: 10),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: GoogleFonts.outfit(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary,
                ),
              ),
              Text(
                subtitle,
                style: GoogleFonts.outfit(
                  fontSize: 11,
                  color: AppColors.textSecondary,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  // --- WIDGET: Segmented Filter Tab Button ---
  Widget _buildFilterTab({
    required int index,
    required String label,
    required IconData icon,
    required int count,
  }) {
    final theme = Theme.of(context);
    final isActive = _activeFilterIndex == index;

    return GestureDetector(
      onTap: () {
        if (_activeFilterIndex != index) {
          setState(() {
            _activeFilterIndex = index;
          });
        }
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        curve: Curves.easeInOut,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: isActive ? theme.colorScheme.primary : Colors.transparent,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            if (isActive)
              BoxShadow(
                color: theme.colorScheme.primary.withAlpha(50),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              size: 15,
              color: isActive ? Colors.white : const Color(0xFF4B5563),
            ),
            const SizedBox(width: 6),
            Text(
              label,
              style: GoogleFonts.outfit(
                fontSize: 13,
                fontWeight: FontWeight.bold,
                color: isActive ? Colors.white : const Color(0xFF4B5563),
              ),
            ),
            if (count > 0) ...[
              const SizedBox(width: 6),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: BoxDecoration(
                  color: isActive ? Colors.white.withAlpha(50) : const Color(0xFFD1D5DB),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text(
                  '$count',
                  style: GoogleFonts.outfit(
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                    color: isActive ? Colors.white : const Color(0xFF374151),
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  // --- WIDGET: High-End Dynamic Committee Card ---
  Widget _buildCommitteeCard(
    BuildContext context, {
    required CommitteeModel committee,
    required bool isMyActiveTab,
    required bool isEnrolled,
  }) {
    final theme = Theme.of(context);
    final hasEnrolled = isEnrolled || isMyActiveTab;

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: hasEnrolled ? theme.colorScheme.primary.withAlpha(60) : AppColors.borderMuted,
          width: hasEnrolled ? 1.5 : 1.0,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(6),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(20),
        child: InkWell(
          borderRadius: BorderRadius.circular(20),
          onTap: () => _openCommunityDetails(committee, isEnrolled: hasEnrolled),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
          // Top Bar Header inside Card
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 12),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // Icon Box
                Container(
                  width: 46,
                  height: 46,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        theme.colorScheme.primary,
                        const Color(0xFF1E3A2F),
                      ],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(14),
                    boxShadow: [
                      BoxShadow(
                        color: theme.colorScheme.primary.withAlpha(30),
                        blurRadius: 8,
                        offset: const Offset(0, 3),
                      ),
                    ],
                  ),
                  alignment: Alignment.center,
                  child: const Icon(
                    Icons.groups_rounded,
                    color: Colors.white,
                    size: 22,
                  ),
                ),
                const SizedBox(width: 14),

                // Name & Code
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        committee.name ?? 'Committee',
                        style: GoogleFonts.outfit(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: AppColors.textPrimary,
                          letterSpacing: -0.3,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 2),
                      Row(
                        children: [
                          Text(
                            'REF #COM-${committee.id}',
                            style: GoogleFonts.outfit(
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                              color: AppColors.textMuted,
                              letterSpacing: 0.5,
                            ),
                          ),
                          const SizedBox(width: 6),
                          Container(
                            width: 3,
                            height: 3,
                            decoration: const BoxDecoration(
                              color: AppColors.textMuted,
                              shape: BoxShape.circle,
                            ),
                          ),
                          const SizedBox(width: 6),
                          Text(
                            committee.frequencyLabel.toUpperCase(),
                            style: GoogleFonts.outfit(
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                              color: theme.colorScheme.primary,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

                // Status Badge Pill
                if (isEnrolled || isMyActiveTab)
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: const Color(0xFFECFDF5),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: const Color(0xFFA7F3D0)),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(Icons.check_circle_rounded, size: 11, color: Color(0xFF059669)),
                        const SizedBox(width: 4),
                        Text(
                          'MY ACTIVE',
                          style: GoogleFonts.outfit(
                            fontSize: 9,
                            fontWeight: FontWeight.w800,
                            color: const Color(0xFF065F46),
                            letterSpacing: 0.5,
                          ),
                        ),
                      ],
                    ),
                  )
                else
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: theme.colorScheme.primary.withAlpha(15),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                          width: 6,
                          height: 6,
                          decoration: const BoxDecoration(
                            color: Color(0xFF10B981),
                            shape: BoxShape.circle,
                          ),
                        ),
                        const SizedBox(width: 5),
                        Text(
                          'OPEN TO JOIN',
                          style: GoogleFonts.outfit(
                            fontSize: 9,
                            fontWeight: FontWeight.bold,
                            color: theme.colorScheme.primary,
                            letterSpacing: 0.5,
                          ),
                        ),
                      ],
                    ),
                  ),
              ],
            ),
          ),

          // Details Block with high-contrast data
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: const Color(0xFFF9FAFB),
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: const Color(0xFFE5E7EB)),
              ),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      _buildDetailItem(
                        'CONTRIBUTION PLAN',
                        '${committee.frequencyLabel} ${_formatCurrency(committee.monthlyAmount)}',
                        isHighlight: true,
                        theme: theme,
                      ),
                      _buildDetailItem(
                        'TOTAL SAVINGS POOL',
                        _formatCurrency(committee.amount ?? 0),
                        isHighlight: false,
                        theme: theme,
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  const Divider(color: Color(0xFFE5E7EB), height: 1),
                  const SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      _buildDetailItem(
                        'DURATION',
                        '${committee.duration ?? 0} Months',
                        isHighlight: false,
                        theme: theme,
                      ),
                      _buildDetailItem(
                        'ANNUAL RETURN',
                        '${committee.returnPercentage ?? 0}% p.a.',
                        isReturn: true,
                        theme: theme,
                      ),
                      _buildDetailItem(
                        'STATUS',
                        (committee.status ?? 'active').toUpperCase(),
                        isHighlight: false,
                        theme: theme,
                      ),
                    ],
                  ),
                  if (committee.periodLabel.isNotEmpty) ...[
                    const SizedBox(height: 10),
                    const Divider(color: Color(0xFFE5E7EB), height: 1),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Icon(
                          Icons.calendar_month_rounded,
                          size: 13,
                          color: theme.colorScheme.primary,
                        ),
                        const SizedBox(width: 6),
                        Text(
                          'TIMELINE:',
                          style: GoogleFonts.outfit(
                            fontSize: 9,
                            fontWeight: FontWeight.bold,
                            color: AppColors.textMuted,
                            letterSpacing: 0.5,
                          ),
                        ),
                        const SizedBox(width: 6),
                        Expanded(
                          child: Text(
                            committee.periodLabel,
                            style: GoogleFonts.outfit(
                              fontSize: 11,
                              fontWeight: FontWeight.bold,
                              color: theme.colorScheme.primary,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                  ],
                  if (hasEnrolled) ...[
                    const SizedBox(height: 10),
                    const Divider(color: Color(0xFFE5E7EB), height: 1),
                    const SizedBox(height: 10),
                    Consumer<InstallmentProvider>(
                      builder: (context, ip, _) {
                        final pendingList = (ip.pending?.committeeInstallments ?? [])
                            .where((i) => i.committeeId == committee.id)
                            .toList();
                        final paidList = (ip.paid?.committeeInstallments ?? [])
                            .where((i) => i.committeeId == committee.id)
                            .toList();

                        return Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                          decoration: BoxDecoration(
                            color: const Color(0xFFF0FDF4),
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(color: const Color(0xFFBBF7D0)),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: [
                                  const Icon(
                                    Icons.receipt_long_rounded,
                                    size: 14,
                                    color: Color(0xFF15803D),
                                  ),
                                  const SizedBox(width: 6),
                                  Text(
                                    'Installments:',
                                    style: GoogleFonts.outfit(
                                      fontSize: 11,
                                      fontWeight: FontWeight.bold,
                                      color: const Color(0xFF166534),
                                    ),
                                  ),
                                ],
                              ),
                              Row(
                                children: [
                                  Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 2),
                                    decoration: BoxDecoration(
                                      color: const Color(0xFFDCFCE7),
                                      borderRadius: BorderRadius.circular(6),
                                    ),
                                    child: Text(
                                      '${paidList.length} Paid',
                                      style: GoogleFonts.outfit(
                                        fontSize: 10,
                                        fontWeight: FontWeight.w700,
                                        color: const Color(0xFF15803D),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 6),
                                  Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 2),
                                    decoration: BoxDecoration(
                                      color: pendingList.isNotEmpty
                                          ? const Color(0xFFFEF3C7)
                                          : const Color(0xFFE5E7EB),
                                      borderRadius: BorderRadius.circular(6),
                                    ),
                                    child: Text(
                                      '${pendingList.length} Pending',
                                      style: GoogleFonts.outfit(
                                        fontSize: 10,
                                        fontWeight: FontWeight.w700,
                                        color: pendingList.isNotEmpty
                                            ? const Color(0xFFB45309)
                                            : const Color(0xFF6B7280),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  ],
                ],
              ),
            ),
          ),
          // Bottom Action Button
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: SizedBox(
              height: 46,
              child: ElevatedButton(
                onPressed: () => _openCommunityDetails(committee, isEnrolled: hasEnrolled),
                style: ElevatedButton.styleFrom(
                  backgroundColor: hasEnrolled
                      ? const Color(0xFF0F4C3A)
                      : theme.colorScheme.primary,
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      hasEnrolled
                          ? Icons.receipt_long_rounded
                          : Icons.login_rounded,
                      color: Colors.white,
                      size: 16,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      hasEnrolled
                          ? 'View Committee Details & History'
                          : 'Join Committee',
                      style: GoogleFonts.outfit(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    ),
  ),
);
}

  // --- WIDGET: Key-Value Metric Item ---
  Widget _buildDetailItem(
    String key,
    String value, {
    bool isHighlight = false,
    bool isReturn = false,
    required ThemeData theme,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          key,
          style: GoogleFonts.outfit(
            fontSize: 9,
            fontWeight: FontWeight.bold,
            color: AppColors.textMuted,
            letterSpacing: 0.5,
          ),
        ),
        const SizedBox(height: 3),
        Text(
          value,
          style: GoogleFonts.outfit(
            fontSize: 13,
            fontWeight: FontWeight.bold,
            color: isReturn
                ? const Color(0xFF059669)
                : isHighlight
                    ? theme.colorScheme.primary
                    : AppColors.textPrimary,
          ),
        ),
      ],
    );
  }

  // --- WIDGET: Empty State for Live Committees ---
  Widget _buildEmptyLiveState() {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 24),
      padding: const EdgeInsets.all(32),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.borderMuted),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppColors.lavenderSoft,
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.group_off_rounded,
              size: 40,
              color: AppColors.textMuted,
            ),
          ),
          const SizedBox(height: 16),
          Text(
            'No Live Committees Right Now',
            style: GoogleFonts.outfit(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            'Admin is currently setting up upcoming committee savings plans. Please check back shortly.',
            textAlign: TextAlign.center,
            style: GoogleFonts.outfit(
              fontSize: 12,
              color: AppColors.textSecondary,
              height: 1.4,
            ),
          ),
        ],
      ),
    );
  }

  // --- WIDGET: Empty State for My Active Committees ---
  Widget _buildEmptyMyActiveState() {
    final theme = Theme.of(context);
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 24),
      padding: const EdgeInsets.all(28),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.borderMuted),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(5),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(18),
            decoration: BoxDecoration(
              color: theme.colorScheme.primary.withAlpha(15),
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.account_balance_wallet_outlined,
              size: 44,
              color: theme.colorScheme.primary,
            ),
          ),
          const SizedBox(height: 18),
          Text(
            'No Active Committees Joined Yet',
            style: GoogleFonts.outfit(
              fontSize: 17,
              fontWeight: FontWeight.bold,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            'You haven\'t enrolled in any savings committee yet. Explore available live committees and join an active group plan now!',
            textAlign: TextAlign.center,
            style: GoogleFonts.outfit(
              fontSize: 12,
              color: AppColors.textSecondary,
              height: 1.4,
            ),
          ),
          const SizedBox(height: 20),
          ElevatedButton.icon(
            onPressed: () {
              setState(() {
                _activeFilterIndex = 0; // Switch to Live Committee tab
              });
            },
            icon: const Icon(Icons.explore_rounded, size: 16, color: Colors.white),
            label: Text(
              'Explore Live Committees',
              style: GoogleFonts.outfit(
                fontSize: 13,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            style: ElevatedButton.styleFrom(
              backgroundColor: theme.colorScheme.primary,
              foregroundColor: Colors.white,
              elevation: 0,
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
