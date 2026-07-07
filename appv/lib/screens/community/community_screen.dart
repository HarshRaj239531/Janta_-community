import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../../constants/app_colors.dart';
import '../../provider/committee_provider.dart';
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
  int _activeFilterIndex = 0; // 0: All, 1: Trending

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<CommitteeProvider>(context, listen: false).fetchCommittees();
    });
  }

  String _formatCurrency(double amount) {
    final formatter = NumberFormat.currency(locale: 'en_IN', symbol: '₹', decimalDigits: 0);
    return formatter.format(amount);
  }

  void _joinCommunity(CommitteeModel committee) async {
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
        if (cp.isLoading && cp.committees.isEmpty) {
          return const Center(child: Padding(
            padding: EdgeInsets.all(40),
            child: CircularProgressIndicator(),
          ));
        }

        final error = cp.error;
        final committees = cp.committees;

        return SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              if (error != null)
                Container(
                  margin: const EdgeInsets.only(bottom: 16),
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  decoration: BoxDecoration(
                    color: AppColors.errorLight,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: AppColors.errorBorder),
                  ),
                  child: Row(
                    children: [
                      Icon(Icons.error_outline, color: AppColors.errorAccent, size: 18),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          'Sync failed: $error',
                          style: GoogleFonts.outfit(color: AppColors.errorDark, fontSize: 12),
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.refresh_rounded, size: 18, color: AppColors.errorDark),
                        padding: EdgeInsets.zero,
                        constraints: const BoxConstraints(),
                        onPressed: () => cp.fetchCommittees(),
                      ),
                    ],
                  ),
                ),
              // Header Row: Title & All/Trending filter pills
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Available\nCommunities',
                    style: GoogleFonts.outfit(
                      fontSize: 26,
                      fontWeight: FontWeight.w800,
                      color: theme.colorScheme.primary,
                      height: 1.15,
                    ),
                  ),
                  // Filter Switcher
                  Container(
                    decoration: BoxDecoration(
                      color: AppColors.borderMuted,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    padding: const EdgeInsets.all(2),
                    child: Row(
                      children: [
                        _buildFilterPill(context, 0, 'All'),
                        _buildFilterPill(context, 1, 'Trending'),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),

              // Community List Cards from API
              if (committees.isEmpty)
                Center(
                  child: Padding(
                    padding: const EdgeInsets.all(40),
                    child: Text(
                      'No communities available',
                      style: GoogleFonts.outfit(
                        fontSize: 14,
                        color: AppColors.textMuted,
                      ),
                    ),
                  ),
                )
              else
                ...committees.map((committee) => Padding(
                  padding: const EdgeInsets.only(bottom: 16),
                  child: _buildCommunityCard(context, committee: committee),
                )),
            ],
          ),
        );
      },
    );

    if (widget.showAppBar) {
      return Scaffold(
        backgroundColor: AppColors.backgroundSoft,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_ios_new_rounded, color: AppColors.textDark),
            onPressed: () => Navigator.pop(context),
          ),
        ),
        body: body,
      );
    } else {
      return Container(
        color: AppColors.backgroundSoft,
        child: body,
      );
    }
  }

  // Filter Pill Button builder
  Widget _buildFilterPill(BuildContext context, int index, String label) {
    final theme = Theme.of(context);
    final isActive = _activeFilterIndex == index;
    return GestureDetector(
      onTap: () {
        setState(() {
          _activeFilterIndex = index;
        });
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: isActive ? theme.colorScheme.primary : Colors.transparent,
          borderRadius: BorderRadius.circular(18),
        ),
        child: Text(
          label,
          style: GoogleFonts.outfit(
            fontSize: 12,
            fontWeight: FontWeight.bold,
            color: isActive ? Colors.white : AppColors.textSecondary,
          ),
        ),
      ),
    );
  }

  // Community list card item builder — uses CommitteeModel
  Widget _buildCommunityCard(BuildContext context, {required CommitteeModel committee}) {
    final theme = Theme.of(context);
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.borderMuted),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(6),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Title Section
          Row(
            children: [
              Container(
                width: 50,
                height: 50,
                decoration: BoxDecoration(
                  color: theme.colorScheme.primary,
                  borderRadius: BorderRadius.circular(12),
                ),
                alignment: Alignment.center,
                child: const Icon(
                  Icons.people_alt_rounded,
                  color: Colors.white,
                  size: 24,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Text(
                  committee.name ?? 'Committee',
                  style: GoogleFonts.outfit(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: theme.colorScheme.primary,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),

          // Details Block
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppColors.containerBgSoft,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _buildDetailItem('PLAN', '${committee.frequencyLabel} ${_formatCurrency(committee.monthlyAmount)}', false),
                    _buildDetailItem('TOTAL AMOUNT', _formatCurrency(committee.amount ?? 0), false),
                  ],
                ),
                const SizedBox(height: 12),
                const Divider(color: AppColors.borderMuted, height: 1),
                const SizedBox(height: 12),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _buildDetailItem('DURATION', '${committee.duration ?? 0} months', false),
                    _buildDetailItem('RETURN', '${committee.returnPercentage ?? 0}%', true),
                    _buildDetailItem('STATUS', (committee.status ?? 'active').toUpperCase(), false),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),

          // Join Community Button
          SizedBox(
            height: 48,
            child: ElevatedButton(
              onPressed: () => _joinCommunity(committee),
              style: ElevatedButton.styleFrom(
                backgroundColor: theme.colorScheme.primary,
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              child: Text(
                'Join Community',
                style: GoogleFonts.outfit(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Helper builder for detail key-value items
  Widget _buildDetailItem(String key, String value, bool isReturn) {
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
        const SizedBox(height: 4),
        Text(
          value,
          style: GoogleFonts.outfit(
            fontSize: 14,
            fontWeight: FontWeight.bold,
            color: isReturn ? AppColors.successGreen : AppColors.textPrimary,
          ),
        ),
      ],
    );
  }
}
