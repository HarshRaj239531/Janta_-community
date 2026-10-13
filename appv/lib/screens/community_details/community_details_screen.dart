import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../../constants/app_colors.dart';
import '../../widgets/custom_bottom_navbar.dart';
import '../../provider/installment_provider.dart';
import '../../models/installment_model.dart';
import '../terms_conditions/terms_conditions_screen.dart';
import 'widgets/pay_committee_installment_bottom_sheet.dart';

class CommunityDetailsScreen extends StatefulWidget {
  final int committeeId;
  final String name;
  final String plan;
  final String goal;
  final String returnRate;
  final String category;
  final String groupId;
  final String? startDate;
  final String? endDate;
  final String? period;
  final bool isJoined;

  const CommunityDetailsScreen({
    super.key,
    required this.committeeId,
    this.name = 'Elite Investors Group',
    this.plan = 'Monthly ₹10,000',
    this.goal = '₹50 Lakhs',
    this.returnRate = '14% p.a.',
    this.category = 'Premium Finance',
    this.groupId = '#EIG-2024',
    this.startDate,
    this.endDate,
    this.period,
    this.isJoined = false,
  });

  @override
  State<CommunityDetailsScreen> createState() => _CommunityDetailsScreenState();
}

class _CommunityDetailsScreenState extends State<CommunityDetailsScreen> {
  final int _selectedNavIndex = 1; // Highlight Community tab
  int _selectedInstallmentFilter = 0; // 0: All, 1: Pending, 2: Paid

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final ip = Provider.of<InstallmentProvider>(context, listen: false);
      ip.fetchPending();
      ip.fetchPaid();
    });
  }

  String _formatCurrency(double amount) {
    final formatter = NumberFormat.currency(
      locale: 'en_IN',
      symbol: '₹',
      decimalDigits: 2,
    );
    return formatter.format(amount);
  }

  String _formatDate(String? dateStr) {
    if (dateStr == null) return 'N/A';
    try {
      final date = DateTime.parse(dateStr);
      return DateFormat('MMM dd, yyyy').format(date);
    } catch (_) {
      return dateStr;
    }
  }

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
          icon: Icon(
            Icons.arrow_back_ios_new_rounded,
            color: theme.colorScheme.primary,
          ),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'Committee Details',
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
                        if (widget.isJoined) ...[
                          const SizedBox(width: 8),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 10,
                              vertical: 5,
                            ),
                            decoration: BoxDecoration(
                              color: const Color(0xFFECFDF5),
                              borderRadius: BorderRadius.circular(16),
                              border: Border.all(
                                color: const Color(0xFFA7F3D0),
                              ),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                const Icon(
                                  Icons.check_circle_rounded,
                                  size: 11,
                                  color: Color(0xFF059669),
                                ),
                                const SizedBox(width: 4),
                                Text(
                                  'MY ACTIVE',
                                  style: GoogleFonts.outfit(
                                    fontSize: 10,
                                    fontWeight: FontWeight.w800,
                                    color: const Color(0xFF065F46),
                                    letterSpacing: 0.5,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
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
                          _buildSummaryRow(
                            context,
                            'Return',
                            widget.returnRate,
                            true,
                          ),
                          if (widget.period != null &&
                              widget.period!.isNotEmpty) ...[
                            const SizedBox(height: 12),
                            _buildSummaryRow(
                              context,
                              'Timeline',
                              widget.period!,
                              false,
                            ),
                          ],
                          if (widget.startDate != null &&
                              widget.endDate != null) ...[
                            const SizedBox(height: 12),
                            _buildSummaryRow(
                              context,
                              'Start Date',
                              widget.startDate!,
                              false,
                            ),
                            const SizedBox(height: 12),
                            _buildSummaryRow(
                              context,
                              'End Date',
                              widget.endDate!,
                              false,
                            ),
                          ],
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),

                    // 4. Statistics row
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

                    // 5. PER-COMMITTEE INSTALLMENT & PAYMENT HISTORY SECTION
                    if (widget.isJoined)
                      Consumer<InstallmentProvider>(
                        builder: (context, ip, _) {
                          // Filter strictly for THIS specific committee ID
                          final committeePending = (ip.pending?.committeeInstallments ?? [])
                              .where((i) => i.committeeId == widget.committeeId)
                              .toList();

                          final committeePaid = (ip.paid?.committeeInstallments ?? [])
                              .where((i) => i.committeeId == widget.committeeId)
                              .toList();

                          // Sort chronologically by due date
                          committeePending.sort(
                            (a, b) => (a.dueDate ?? '').compareTo(b.dueDate ?? ''),
                          );
                          committeePaid.sort(
                            (a, b) => (b.paidDate ?? b.dueDate ?? '').compareTo(
                              a.paidDate ?? a.dueDate ?? '',
                            ),
                          );

                          final allInstallments = [...committeePaid, ...committeePending];
                          allInstallments.sort(
                            (a, b) => (a.dueDate ?? '').compareTo(b.dueDate ?? ''),
                          );

                          final totalCount = allInstallments.length;
                          final paidCount = committeePaid.length;
                          final pendingCount = committeePending.length;

                          final totalPaidAmount = committeePaid.fold<double>(
                            0.0,
                            (sum, i) => sum + (i.amount ?? 0.0),
                          );
                          final totalPendingAmount = committeePending.fold<double>(
                            0.0,
                            (sum, i) => sum + (i.amount ?? 0.0),
                          );

                          final completionRatio = totalCount > 0
                              ? (paidCount / totalCount)
                              : 0.0;

                          // Selected Filter List
                          List<InstallmentModel> displayList;
                          if (_selectedInstallmentFilter == 1) {
                            displayList = committeePending;
                          } else if (_selectedInstallmentFilter == 2) {
                            displayList = committeePaid;
                          } else {
                            displayList = allInstallments;
                          }

                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              // Section Title
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Row(
                                    children: [
                                      Container(
                                        padding: const EdgeInsets.all(8),
                                        decoration: BoxDecoration(
                                          color: theme.colorScheme.primary.withAlpha(20),
                                          borderRadius:
                                              BorderRadius.circular(10),
                                        ),
                                        child: Icon(
                                          Icons.receipt_long_rounded,
                                          color: theme.colorScheme.primary,
                                          size: 18,
                                        ),
                                      ),
                                      const SizedBox(width: 10),
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            'Installment History',
                                            style: GoogleFonts.outfit(
                                              fontSize: 16,
                                              fontWeight: FontWeight.bold,
                                              color: AppColors.textPrimary,
                                            ),
                                          ),
                                          Text(
                                            'Tracking for ${widget.name}',
                                            style: GoogleFonts.outfit(
                                              fontSize: 11,
                                              color: AppColors.textSecondary,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 10,
                                      vertical: 5,
                                    ),
                                    decoration: BoxDecoration(
                                      color: const Color(0xFFECFDF5),
                                      borderRadius: BorderRadius.circular(14),
                                      border: Border.all(
                                        color: const Color(0xFFA7F3D0),
                                      ),
                                    ),
                                    child: Text(
                                      '$paidCount of $totalCount Paid',
                                      style: GoogleFonts.outfit(
                                        fontSize: 10,
                                        fontWeight: FontWeight.bold,
                                        color: const Color(0xFF065F46),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 12),

                              // Progress & Financial Summary Box
                              Container(
                                padding: const EdgeInsets.all(16),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(18),
                                  border: Border.all(
                                    color: AppColors.borderMuted,
                                  ),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black.withAlpha(5),
                                      blurRadius: 10,
                                      offset: const Offset(0, 3),
                                    ),
                                  ],
                                ),
                                child: Column(
                                  crossAxisAlignment:
                                      CrossAxisAlignment.stretch,
                                  children: [
                                    // Paid vs Pending Metric Columns
                                    Row(
                                      children: [
                                        Expanded(
                                          child: Container(
                                            padding: const EdgeInsets.all(12),
                                            decoration: BoxDecoration(
                                              color: const Color(0xFFECFDF5),
                                              borderRadius:
                                                  BorderRadius.circular(12),
                                              border: Border.all(
                                                color: const Color(0xFFA7F3D0),
                                              ),
                                            ),
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Row(
                                                  children: [
                                                    const Icon(
                                                      Icons.check_circle_outline,
                                                      size: 13,
                                                      color: Color(0xFF059669),
                                                    ),
                                                    const SizedBox(width: 4),
                                                    Text(
                                                      'TOTAL PAID',
                                                      style: GoogleFonts.outfit(
                                                        fontSize: 9,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        color: const Color(
                                                          0xFF065F46,
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                                const SizedBox(height: 4),
                                                Text(
                                                  _formatCurrency(
                                                    totalPaidAmount,
                                                  ),
                                                  style: GoogleFonts.outfit(
                                                    fontSize: 16,
                                                    fontWeight:
                                                        FontWeight.bold,
                                                    color: const Color(
                                                      0xFF065F46,
                                                    ),
                                                  ),
                                                ),
                                                Text(
                                                  '$paidCount Installments',
                                                  style: GoogleFonts.outfit(
                                                    fontSize: 10,
                                                    color: const Color(
                                                      0xFF047857,
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                        const SizedBox(width: 12),
                                        Expanded(
                                          child: Container(
                                            padding: const EdgeInsets.all(12),
                                            decoration: BoxDecoration(
                                              color: const Color(0xFFFFFBEB),
                                              borderRadius:
                                                  BorderRadius.circular(12),
                                              border: Border.all(
                                                color: const Color(0xFFFDE68A),
                                              ),
                                            ),
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Row(
                                                  children: [
                                                    const Icon(
                                                      Icons.schedule_rounded,
                                                      size: 13,
                                                      color: Color(0xFFD97706),
                                                    ),
                                                    const SizedBox(width: 4),
                                                    Text(
                                                      'PENDING DUE',
                                                      style: GoogleFonts.outfit(
                                                        fontSize: 9,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        color: const Color(
                                                          0xFF92400E,
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                                const SizedBox(height: 4),
                                                Text(
                                                  _formatCurrency(
                                                    totalPendingAmount,
                                                  ),
                                                  style: GoogleFonts.outfit(
                                                    fontSize: 16,
                                                    fontWeight:
                                                        FontWeight.bold,
                                                    color: const Color(
                                                      0xFF92400E,
                                                    ),
                                                  ),
                                                ),
                                                Text(
                                                  '$pendingCount Installments',
                                                  style: GoogleFonts.outfit(
                                                    fontSize: 10,
                                                    color: const Color(
                                                      0xFFB45309,
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 14),

                                    // Progress Bar
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          'Completion Progress',
                                          style: GoogleFonts.outfit(
                                            fontSize: 11,
                                            fontWeight: FontWeight.w600,
                                            color: AppColors.textSecondary,
                                          ),
                                        ),
                                        Text(
                                          '${(completionRatio * 100).toStringAsFixed(0)}%',
                                          style: GoogleFonts.outfit(
                                            fontSize: 12,
                                            fontWeight: FontWeight.bold,
                                            color: theme.colorScheme.primary,
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 6),
                                    ClipRRect(
                                      borderRadius: BorderRadius.circular(6),
                                      child: LinearProgressIndicator(
                                        value: completionRatio.clamp(0.0, 1.0),
                                        minHeight: 8,
                                        backgroundColor: const Color(0xFFE5E7EB),
                                        valueColor:
                                            AlwaysStoppedAnimation<Color>(
                                          theme.colorScheme.primary,
                                        ),
                                      ),
                                    ),

                                    // Next Due Highlight Banner (if any pending)
                                    if (committeePending.isNotEmpty) ...[
                                      const SizedBox(height: 14),
                                      Container(
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 12,
                                          vertical: 8,
                                        ),
                                        decoration: BoxDecoration(
                                          color: const Color(0xFFF3F4F6),
                                          borderRadius:
                                              BorderRadius.circular(10),
                                        ),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Row(
                                              children: [
                                                const Icon(
                                                  Icons.alarm_on_rounded,
                                                  size: 15,
                                                  color: AppColors.errorAccent,
                                                ),
                                                const SizedBox(width: 6),
                                                Text(
                                                  'Next Due: ${_formatDate(committeePending.first.dueDate)}',
                                                  style: GoogleFonts.outfit(
                                                    fontSize: 11,
                                                    fontWeight: FontWeight.w700,
                                                    color: AppColors.textPrimary,
                                                  ),
                                                ),
                                              ],
                                            ),
                                            Text(
                                              _formatCurrency(
                                                committeePending.first.amount ??
                                                    0,
                                              ),
                                              style: GoogleFonts.outfit(
                                                fontSize: 12,
                                                fontWeight: FontWeight.bold,
                                                color: theme.colorScheme.primary,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ],
                                ),
                              ),
                              const SizedBox(height: 16),

                              // Filter Pills (All, Pending, Paid)
                              Row(
                                children: [
                                  _buildFilterPill(
                                    label: 'All ($totalCount)',
                                    index: 0,
                                  ),
                                  const SizedBox(width: 8),
                                  _buildFilterPill(
                                    label: 'Pending ($pendingCount)',
                                    index: 1,
                                  ),
                                  const SizedBox(width: 8),
                                  _buildFilterPill(
                                    label: 'Paid ($paidCount)',
                                    index: 2,
                                  ),
                                ],
                              ),
                              const SizedBox(height: 12),

                              // Installment Items List
                              if (ip.isLoading && allInstallments.isEmpty)
                                const Center(
                                  child: Padding(
                                    padding: EdgeInsets.all(24),
                                    child: CircularProgressIndicator(),
                                  ),
                                )
                              else if (displayList.isEmpty)
                                Container(
                                  padding: const EdgeInsets.all(24),
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(16),
                                    border: Border.all(
                                      color: AppColors.borderMuted,
                                    ),
                                  ),
                                  child: Center(
                                    child: Column(
                                      children: [
                                        Icon(
                                          _selectedInstallmentFilter == 1
                                              ? Icons.check_circle_outline
                                              : Icons.history_rounded,
                                          color: AppColors.textMuted,
                                          size: 32,
                                        ),
                                        const SizedBox(height: 8),
                                        Text(
                                          _selectedInstallmentFilter == 1
                                              ? 'All installments are paid! No pending dues.'
                                              : (_selectedInstallmentFilter == 2
                                                  ? 'No installments paid yet.'
                                                  : 'No installment records found for this committee.'),
                                          textAlign: TextAlign.center,
                                          style: GoogleFonts.outfit(
                                            fontSize: 13,
                                            color: AppColors.textMuted,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                )
                              else
                                ...displayList.asMap().entries.map((entry) {
                                  final idx = entry.key;
                                  final inst = entry.value;
                                  final isPaid =
                                      (inst.status ?? '').toLowerCase() ==
                                          'paid';

                                  return Container(
                                    margin: const EdgeInsets.only(bottom: 10),
                                    padding: const EdgeInsets.all(14),
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(14),
                                      border: Border.all(
                                        color: isPaid
                                            ? const Color(0xFFA7F3D0)
                                            : AppColors.borderMuted,
                                      ),
                                    ),
                                    child: Row(
                                      children: [
                                        // Installment Sequence Avatar
                                        Container(
                                          width: 36,
                                          height: 36,
                                          decoration: BoxDecoration(
                                            color: isPaid
                                                ? const Color(0xFFECFDF5)
                                                : const Color(0xFFFFFBEB),
                                            shape: BoxShape.circle,
                                            border: Border.all(
                                              color: isPaid
                                                  ? const Color(0xFFA7F3D0)
                                                  : const Color(0xFFFDE68A),
                                            ),
                                          ),
                                          alignment: Alignment.center,
                                          child: Text(
                                            '#${idx + 1}',
                                            style: GoogleFonts.outfit(
                                              fontSize: 11,
                                              fontWeight: FontWeight.bold,
                                              color: isPaid
                                                  ? const Color(0xFF065F46)
                                                  : const Color(0xFF92400E),
                                            ),
                                          ),
                                        ),
                                        const SizedBox(width: 12),

                                        // Title and Date Info
                                        Expanded(
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                'Installment #${inst.id > 0 ? inst.id : (idx + 1)}',
                                                style: GoogleFonts.outfit(
                                                  fontSize: 13,
                                                  fontWeight: FontWeight.bold,
                                                  color: AppColors.textPrimary,
                                                ),
                                              ),
                                              const SizedBox(height: 3),
                                              Row(
                                                children: [
                                                  Icon(
                                                    isPaid
                                                        ? Icons
                                                            .check_circle_outline
                                                        : Icons
                                                            .calendar_today_rounded,
                                                    size: 11,
                                                    color: isPaid
                                                        ? const Color(
                                                            0xFF059669,
                                                          )
                                                        : AppColors
                                                            .textSecondary,
                                                  ),
                                                  const SizedBox(width: 4),
                                                  Text(
                                                    isPaid
                                                        ? 'Paid: ${_formatDate(inst.paidDate ?? inst.dueDate)}'
                                                        : 'Due: ${_formatDate(inst.dueDate)}',
                                                    style: GoogleFonts.outfit(
                                                      fontSize: 11,
                                                      color: isPaid
                                                          ? const Color(
                                                              0xFF059669,
                                                            )
                                                          : AppColors
                                                              .textSecondary,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ],
                                          ),
                                        ),

                                        // Amount and Action/Status Pill
                                        Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.end,
                                          children: [
                                            Text(
                                              _formatCurrency(
                                                inst.amount ?? 0,
                                              ),
                                              style: GoogleFonts.outfit(
                                                fontSize: 14,
                                                fontWeight: FontWeight.bold,
                                                color: AppColors.textPrimary,
                                              ),
                                            ),
                                            const SizedBox(height: 4),
                                            if (isPaid)
                                              Container(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                  horizontal: 8,
                                                  vertical: 3,
                                                ),
                                                decoration: BoxDecoration(
                                                  color:
                                                      const Color(0xFFECFDF5),
                                                  borderRadius:
                                                      BorderRadius.circular(10),
                                                  border: Border.all(
                                                    color:
                                                        const Color(0xFFA7F3D0),
                                                  ),
                                                ),
                                                child: Text(
                                                  'PAID',
                                                  style: GoogleFonts.outfit(
                                                    fontSize: 9,
                                                    fontWeight: FontWeight.bold,
                                                    color:
                                                        const Color(0xFF065F46),
                                                  ),
                                                ),
                                              )
                                            else
                                              GestureDetector(
                                                onTap: () {
                                                  PayCommitteeInstallmentBottomSheet
                                                      .show(
                                                    context: context,
                                                    committeeName: widget.name,
                                                    installment: inst,
                                                    onPaymentSuccess: () {
                                                      ip.fetchPending();
                                                      ip.fetchPaid();
                                                    },
                                                  );
                                                },
                                                child: Container(
                                                  padding: const EdgeInsets
                                                      .symmetric(
                                                    horizontal: 10,
                                                    vertical: 4,
                                                  ),
                                                  decoration: BoxDecoration(
                                                    color: theme
                                                        .colorScheme.primary,
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                      10,
                                                    ),
                                                  ),
                                                  child: Row(
                                                    mainAxisSize:
                                                        MainAxisSize.min,
                                                    children: [
                                                      Text(
                                                        'Pay Now',
                                                        style:
                                                            GoogleFonts.outfit(
                                                          fontSize: 10,
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          color: Colors.white,
                                                        ),
                                                      ),
                                                      const SizedBox(width: 3),
                                                      const Icon(
                                                        Icons
                                                            .arrow_forward_rounded,
                                                        size: 10,
                                                        color: Colors.white,
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  );
                                }),
                              const SizedBox(height: 24),
                            ],
                          );
                        },
                      ),

                    // 6. Monthly Declaration Box
                    Container(
                      decoration: BoxDecoration(
                        color: widget.isJoined
                            ? const Color(0xFFECFDF5)
                            : AppColors.containerBgSoft,
                        borderRadius: const BorderRadius.only(
                          topRight: Radius.circular(12),
                          bottomRight: Radius.circular(12),
                        ),
                        border: Border(
                          left: BorderSide(
                            color: widget.isJoined
                                ? const Color(0xFF059669)
                                : theme.colorScheme.primary,
                            width: 4,
                          ),
                        ),
                      ),
                      padding: const EdgeInsets.all(16),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          if (widget.isJoined) ...[
                            const Icon(
                              Icons.verified_rounded,
                              color: Color(0xFF059669),
                              size: 20,
                            ),
                            const SizedBox(width: 10),
                          ],
                          Expanded(
                            child: Text(
                              widget.isJoined
                                  ? 'You are actively enrolled in ${widget.name}. Your periodic savings installments are tracked above per schedule.'
                                  : 'By confirming, you agree to start your monthly contribution of ${widget.plan.replaceAll('Monthly ', '').replaceAll('Daily ', '')} to the ${widget.name} pool. Your first contribution will be debited within 24 hours.',
                              style: GoogleFonts.outfit(
                                fontSize: 13,
                                color: widget.isJoined
                                    ? const Color(0xFF065F46)
                                    : AppColors.textSecondary,
                                height: 1.4,
                                fontWeight: widget.isJoined
                                    ? FontWeight.w600
                                    : FontWeight.normal,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 24),

                    // 7. Action Button & Terms link
                    if (!widget.isJoined) ...[
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

  // Filter Pill Builder
  Widget _buildFilterPill({required String label, required int index}) {
    final theme = Theme.of(context);
    final isSelected = _selectedInstallmentFilter == index;

    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedInstallmentFilter = index;
        });
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 7),
        decoration: BoxDecoration(
          color: isSelected ? theme.colorScheme.primary : Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isSelected
                ? theme.colorScheme.primary
                : AppColors.borderMuted,
          ),
        ),
        child: Text(
          label,
          style: GoogleFonts.outfit(
            fontSize: 11,
            fontWeight: isSelected ? FontWeight.bold : FontWeight.w600,
            color: isSelected ? Colors.white : AppColors.textSecondary,
          ),
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
          color: isCategory
              ? theme.colorScheme.primary
              : AppColors.textSecondary,
        ),
      ),
    );
  }

  // Summary row builder helper
  Widget _buildSummaryRow(
    BuildContext context,
    String key,
    String value,
    bool isGreen,
  ) {
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
        mainAxisAlignment: isFullWidth
            ? MainAxisAlignment.spaceBetween
            : MainAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: AppColors.primaryGreen, size: 20),
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
