import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../../../constants/app_colors.dart';
import '../../../models/loan_model.dart';
import '../../../models/loan_request_model.dart';
import '../../../provider/loan_provider.dart';
import 'apply_loan_bottom_sheet.dart';

class LoanDetailTab extends StatelessWidget {
  final LoanModel? loan;
  final VoidCallback onPayEmiPressed;
  final bool showBlank;

  const LoanDetailTab({
    super.key,
    required this.loan,
    required this.onPayEmiPressed,
    this.showBlank = false,
  });

  String _formatCurrency(double amount) {
    final formatter = NumberFormat.currency(locale: 'en_IN', symbol: '₹', decimalDigits: 2);
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

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final lp = Provider.of<LoanProvider>(context);

    // If user has no active loan
    if (showBlank || (loan == null && lp.loans.isEmpty)) {
      if (lp.isLoading && lp.loans.isEmpty && lp.loanRequests.isEmpty) {
        return const Center(
          child: Padding(
            padding: EdgeInsets.all(40.0),
            child: CircularProgressIndicator(),
          ),
        );
      }

      final pendingReq = lp.pendingRequest;
      if (pendingReq != null) {
        return _buildPendingApplicationView(context, pendingReq, theme, lp);
      }

      return _buildNoLoanApplyView(context, theme, lp);
    }

    if (loan == null) {
      return const Center(
        child: Padding(
          padding: EdgeInsets.all(40.0),
          child: CircularProgressIndicator(),
        ),
      );
    }

    final totalAmount = loan!.amount ?? 0;
    final interestRate = loan!.interestRate ?? 0;
    final duration = loan!.installments != null && loan!.installments!.isNotEmpty
        ? loan!.installments!.length
        : (loan!.duration ?? 0);
    final installmentsList = loan!.installments;
    double emi = loan!.monthlyEmi;
    if (installmentsList != null && installmentsList.isNotEmpty) {
      final pendingListForEmi = installmentsList.where((i) => i.status == 'pending').toList();
      if (pendingListForEmi.isNotEmpty) {
        pendingListForEmi.sort((a, b) {
          final aDate = a.dueDate ?? '';
          final bDate = b.dueDate ?? '';
          return aDate.compareTo(bDate);
        });
        emi = pendingListForEmi.first.amount ?? 0.0;
      } else {
        emi = 0.0;
      }
    }
    final paidCount = loan!.installments != null
        ? loan!.installments!.where((i) => i.status == 'paid').length
        : 0;
    final totalRepaid = loan!.installments != null
        ? loan!.installments!.where((i) => i.status == 'paid').map((i) => i.amount ?? 0.0).fold(0.0, (a, b) => a + b)
        : 0.0;
    final outstanding = loan!.installments != null && loan!.installments!.isNotEmpty
        ? loan!.installments!.where((i) => i.status == 'pending').map((i) => i.amount ?? 0.0).fold(0.0, (a, b) => a + b)
        : (totalAmount * (1 + interestRate / 100)) - totalRepaid;
    final progress = duration > 0 ? paidCount / duration : 0.0;

    // Find next due date
    String nextDue = 'N/A';
    if (loan!.installments != null) {
      final pendingList = loan!.installments!.where((i) => i.status == 'pending').toList();
      if (pendingList.isNotEmpty) {
        pendingList.sort((a, b) => (a.dueDate ?? '').compareTo(b.dueDate ?? ''));
        nextDue = _formatDate(pendingList.first.dueDate);
      }
    }

    String startDate = _formatDate(loan!.createdAt);
    String endDate = 'N/A';
    if (loan!.createdAt != null && duration > 0) {
      try {
        final start = DateTime.parse(loan!.createdAt!);
        final end = DateTime(start.year, start.month + duration, start.day);
        endDate = DateFormat('MMM dd, yyyy').format(end);
      } catch (_) {}
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // If user also has a pending request while having an active loan
        if (lp.pendingRequest != null)
          _buildPendingBanner(context, lp.pendingRequest!, theme),

        // Active Loan Status Card
        Container(
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
                  left: BorderSide(
                    color: theme.colorScheme.primary,
                    width: 4,
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
                      Text(
                        'Janta Loan Account',
                        style: GoogleFonts.outfit(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: AppColors.textPrimary,
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: theme.colorScheme.primary.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(30),
                        ),
                        child: Text(
                          (loan!.status ?? 'pending').toUpperCase(),
                          style: GoogleFonts.outfit(
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                            color: theme.colorScheme.primary,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 2),
                  Text(
                    'LOAN NO. #LN-${loan!.id}',
                    style: GoogleFonts.outfit(
                      fontSize: 11,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textMuted,
                      letterSpacing: 0.5,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Loan Amount',
                              style: GoogleFonts.outfit(
                                fontSize: 11,
                                color: AppColors.textSecondary,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              _formatCurrency(totalAmount),
                              style: GoogleFonts.outfit(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: AppColors.textPrimary,
                                  letterSpacing: -0.5),
                            ),
                          ],
                        ),
                      ),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Outstanding Balance',
                              style: GoogleFonts.outfit(
                                fontSize: 11,
                                color: AppColors.textSecondary,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              _formatCurrency(outstanding.clamp(0, double.infinity)),
                              style: GoogleFonts.outfit(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: theme.colorScheme.primary,
                                  letterSpacing: -0.5),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  const Divider(color: AppColors.borderLight, height: 1),
                  const SizedBox(height: 14),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          const Icon(Icons.calendar_today_rounded, color: AppColors.textSecondary, size: 16),
                          const SizedBox(width: 8),
                          Text(
                            'EMI Paid: $paidCount/$duration',
                            style: GoogleFonts.outfit(
                              fontSize: 13,
                              fontWeight: FontWeight.bold,
                              color: AppColors.textSecondary,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        width: 90,
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(4),
                          child: LinearProgressIndicator(
                            value: progress.clamp(0.0, 1.0),
                            backgroundColor: AppColors.lavenderSoft,
                            valueColor: AlwaysStoppedAnimation<Color>(theme.colorScheme.primary),
                            minHeight: 6,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
        const SizedBox(height: 16),

        // Repayment Schedule Section (Lavender background)
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: AppColors.lavenderSoft,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: AppColors.borderLight),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(Icons.access_time_rounded, color: theme.colorScheme.primary, size: 18),
                  const SizedBox(width: 8),
                  Text(
                    'Repayment Schedule',
                    style: GoogleFonts.outfit(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: theme.colorScheme.primary,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: _buildScheduleDateCard('Start Date', startDate, false),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: _buildScheduleDateCard('End Date', endDate, false),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: _buildScheduleDateCard('Next Due', nextDue, true),
                  ),
                ],
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),

        // 2x2 Grid of Status Metrics
        Row(
          children: [
            Expanded(
              child: _buildMetricItem('EMI Paid Amount', _formatCurrency(totalRepaid), false, false),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _buildMetricItem('Upcoming EMI', _formatCurrency(emi), false, true),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: _buildMetricItem('Interest Rate', '$interestRate% p.a.', false, false),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _buildMetricItem('Loan Duration', '$duration Months', false, false),
            ),
          ],
        ),
        const SizedBox(height: 16),

        // Repayment Frequency Card
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          decoration: BoxDecoration(
            color: AppColors.lavenderSoft,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: AppColors.borderLight),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Repayment Frequency',
                style: GoogleFonts.outfit(
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                  color: AppColors.textSecondary,
                ),
              ),
              Row(
                children: [
                  Icon(Icons.sync_rounded, color: theme.colorScheme.primary, size: 16),
                  const SizedBox(width: 6),
                  Text(
                    'Monthly',
                    style: GoogleFonts.outfit(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: theme.colorScheme.primary,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),

        // Additional Loan Card at bottom
        _buildAdditionalLoanCard(context, theme),

        const SizedBox(height: 80),
      ],
    );
  }

  // --- VIEW: User Has Pending Application Under Review ---
  Widget _buildPendingApplicationView(
    BuildContext context,
    LoanRequestModel request,
    ThemeData theme,
    LoanProvider lp,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // Pending Status Hero Card
        Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: Colors.amber.shade200),
            boxShadow: [
              BoxShadow(
                color: Colors.amber.shade50.withValues(alpha: 0.5),
                blurRadius: 16,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                    decoration: BoxDecoration(
                      color: Colors.amber.shade50,
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: Colors.amber.shade300),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.hourglass_top_rounded, size: 14, color: Colors.amber.shade800),
                        const SizedBox(width: 4),
                        Text(
                          'UNDER ADMIN REVIEW',
                          style: GoogleFonts.outfit(
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                            color: Colors.amber.shade900,
                            letterSpacing: 0.5,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Text(
                    '#REQ-${request.id}',
                    style: GoogleFonts.outfit(
                      fontSize: 11,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textMuted,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Text(
                'Loan Application Submitted',
                style: GoogleFonts.outfit(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                'Your loan request has been received and is currently being reviewed by our administration team.',
                style: GoogleFonts.outfit(
                  fontSize: 12,
                  color: AppColors.textSecondary,
                  height: 1.4,
                ),
              ),
              const SizedBox(height: 20),

              // Requested Amount Highlight
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppColors.lavenderSoft,
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Requested Amount',
                          style: GoogleFonts.outfit(
                            fontSize: 11,
                            color: AppColors.textSecondary,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          _formatCurrency(request.amount),
                          style: GoogleFonts.outfit(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                            color: theme.colorScheme.primary,
                          ),
                        ),
                      ],
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          'Tenure / Frequency',
                          style: GoogleFonts.outfit(
                            fontSize: 11,
                            color: AppColors.textSecondary,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          '${request.durationMonths} Mo • ${request.paymentFrequency.toUpperCase()}',
                          style: GoogleFonts.outfit(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: AppColors.textPrimary,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              if (request.purpose != null && request.purpose!.trim().isNotEmpty) ...[
                const SizedBox(height: 14),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Purpose: ',
                      style: GoogleFonts.outfit(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    Expanded(
                      child: Text(
                        request.purpose!,
                        style: GoogleFonts.outfit(
                          fontSize: 12,
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ),
                  ],
                ),
              ],

              const SizedBox(height: 20),
              const Divider(color: AppColors.borderLight, height: 1),
              const SizedBox(height: 16),

              // Status Stepper
              Text(
                'Application Status Tracker',
                style: GoogleFonts.outfit(
                  fontSize: 13,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary,
                ),
              ),
              const SizedBox(height: 14),
              _buildTimelineStep(
                title: 'Application Submitted',
                subtitle: 'Submitted on ${_formatDate(request.createdAt)}',
                isCompleted: true,
                isActive: false,
                isLast: false,
                theme: theme,
              ),
              _buildTimelineStep(
                title: 'Admin Verification',
                subtitle: 'Checking profile & credit eligibility',
                isCompleted: false,
                isActive: true,
                isLast: false,
                theme: theme,
              ),
              _buildTimelineStep(
                title: 'Approval & Loan Activation',
                subtitle: 'Loan will be credited and EMI schedule created',
                isCompleted: false,
                isActive: false,
                isLast: true,
                theme: theme,
              ),

              const SizedBox(height: 18),
              // Refresh button
              SizedBox(
                width: double.infinity,
                child: OutlinedButton.icon(
                  onPressed: () {
                    lp.fetchLoanRequests();
                    lp.fetchLoans();
                  },
                  icon: const Icon(Icons.refresh_rounded, size: 16),
                  label: Text(
                    'Refresh Status',
                    style: GoogleFonts.outfit(
                      fontWeight: FontWeight.bold,
                      fontSize: 13,
                    ),
                  ),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: theme.colorScheme.primary,
                    side: BorderSide(color: theme.colorScheme.primary.withValues(alpha: 0.3)),
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),

        const SizedBox(height: 16),

        // Information banner
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.blue.shade50.withValues(alpha: 0.6),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: Colors.blue.shade100),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(Icons.info_outline_rounded, color: Colors.blue.shade700, size: 20),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'What happens after approval?',
                      style: GoogleFonts.outfit(
                        fontSize: 13,
                        fontWeight: FontWeight.bold,
                        color: Colors.blue.shade900,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Once the admin approves your application, your active loan and complete EMI schedule will appear here automatically with one-tap payment options.',
                      style: GoogleFonts.outfit(
                        fontSize: 11,
                        color: Colors.blue.shade800,
                        height: 1.4,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 60),
      ],
    );
  }

  // --- VIEW: User Has No Active Loan & No Pending Request ---
  Widget _buildNoLoanApplyView(BuildContext context, ThemeData theme, LoanProvider lp) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // Hero Promo Card
        Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                theme.colorScheme.primary,
                theme.colorScheme.primary.withValues(alpha: 0.85),
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(24),
            boxShadow: [
              BoxShadow(
                color: theme.colorScheme.primary.withValues(alpha: 0.25),
                blurRadius: 16,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          padding: const EdgeInsets.all(22),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.2),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      'COMMITTEE FINANCIAL AID',
                      style: GoogleFonts.outfit(
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        letterSpacing: 0.5,
                      ),
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.2),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.account_balance_rounded,
                      color: Colors.white,
                      size: 20,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Text(
                'Get Instant Loan Up To',
                style: GoogleFonts.outfit(
                  fontSize: 14,
                  color: Colors.white.withValues(alpha: 0.9),
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                '₹2,00,000',
                style: GoogleFonts.outfit(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                  letterSpacing: -0.5,
                ),
              ),
              const SizedBox(height: 10),
              Text(
                'Need funds for medical emergencies, business expansion, or personal requirements? Apply online in just 2 minutes.',
                style: GoogleFonts.outfit(
                  fontSize: 12,
                  color: Colors.white.withValues(alpha: 0.85),
                  height: 1.4,
                ),
              ),
              const SizedBox(height: 20),
              ElevatedButton.icon(
                onPressed: () => ApplyLoanBottomSheet.show(context),
                icon: const Icon(Icons.send_rounded, size: 16),
                label: Text(
                  'Apply for Loan Now',
                  style: GoogleFonts.outfit(
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                  foregroundColor: theme.colorScheme.primary,
                  elevation: 0,
                  padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 20),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                ),
              ),
            ],
          ),
        ),

        const SizedBox(height: 20),

        // Key Benefits Section
        Text(
          'Why Choose Janta Loans?',
          style: GoogleFonts.outfit(
            fontSize: 15,
            fontWeight: FontWeight.bold,
            color: AppColors.textPrimary,
          ),
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: _buildBenefitCard(
                icon: Icons.bolt_rounded,
                title: 'Quick Verification',
                desc: 'Fast approval by committee admins',
                theme: theme,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _buildBenefitCard(
                icon: Icons.calendar_month_rounded,
                title: 'Flexible EMIs',
                desc: 'Daily, weekly or monthly tenures',
                theme: theme,
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: _buildBenefitCard(
                icon: Icons.percent_rounded,
                title: 'Transparent Rates',
                desc: 'No hidden charges or deductions',
                theme: theme,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _buildBenefitCard(
                icon: Icons.security_rounded,
                title: 'Safe & Trusted',
                desc: '100% digital & transparent records',
                theme: theme,
              ),
            ),
          ],
        ),

        // Application History (if rejected or previous requests exist)
        if (lp.loanRequests.isNotEmpty) ...[
          const SizedBox(height: 24),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Application History',
                style: GoogleFonts.outfit(
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary,
                ),
              ),
              Text(
                '${lp.loanRequests.length} total',
                style: GoogleFonts.outfit(
                  fontSize: 12,
                  color: AppColors.textMuted,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          ...lp.loanRequests.map((req) => _buildApplicationHistoryTile(req, theme)),
        ],

        const SizedBox(height: 60),
      ],
    );
  }

  Widget _buildTimelineStep({
    required String title,
    required String subtitle,
    required bool isCompleted,
    required bool isActive,
    required bool isLast,
    required ThemeData theme,
  }) {
    Color iconBg;
    Color iconColor;
    IconData icon;

    if (isCompleted) {
      iconBg = AppColors.successGreen;
      iconColor = Colors.white;
      icon = Icons.check_rounded;
    } else if (isActive) {
      iconBg = Colors.amber.shade600;
      iconColor = Colors.white;
      icon = Icons.hourglass_top_rounded;
    } else {
      iconBg = Colors.grey.shade200;
      iconColor = Colors.grey.shade500;
      icon = Icons.circle_outlined;
    }

    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Column(
            children: [
              Container(
                width: 26,
                height: 26,
                decoration: BoxDecoration(
                  color: iconBg,
                  shape: BoxShape.circle,
                ),
                child: Icon(icon, color: iconColor, size: 14),
              ),
              if (!isLast)
                Expanded(
                  child: Container(
                    width: 2,
                    color: isCompleted ? AppColors.successGreen : Colors.grey.shade300,
                    margin: const EdgeInsets.symmetric(vertical: 4),
                  ),
                ),
            ],
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Padding(
              padding: EdgeInsets.only(bottom: isLast ? 0 : 16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: GoogleFonts.outfit(
                      fontSize: 13,
                      fontWeight: isActive || isCompleted ? FontWeight.bold : FontWeight.w600,
                      color: isActive ? Colors.amber.shade900 : (isCompleted ? AppColors.textPrimary : AppColors.textMuted),
                    ),
                  ),
                  const SizedBox(height: 2),
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
          ),
        ],
      ),
    );
  }

  Widget _buildBenefitCard({
    required IconData icon,
    required String title,
    required String desc,
    required ThemeData theme,
  }) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.borderLight),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: theme.colorScheme.primary.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, color: theme.colorScheme.primary, size: 18),
          ),
          const SizedBox(height: 10),
          Text(
            title,
            style: GoogleFonts.outfit(
              fontSize: 12,
              fontWeight: FontWeight.bold,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 3),
          Text(
            desc,
            style: GoogleFonts.outfit(
              fontSize: 10,
              color: AppColors.textMuted,
              height: 1.3,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildApplicationHistoryTile(LoanRequestModel req, ThemeData theme) {
    Color statusBg;
    Color statusColor;
    String statusText;

    if (req.isApproved) {
      statusBg = AppColors.successGreen.withValues(alpha: 0.15);
      statusColor = AppColors.successGreen;
      statusText = 'APPROVED';
    } else if (req.isRejected) {
      statusBg = AppColors.errorAccent.withValues(alpha: 0.15);
      statusColor = AppColors.errorAccent;
      statusText = 'REJECTED';
    } else {
      statusBg = Colors.amber.shade50;
      statusColor = Colors.amber.shade800;
      statusText = 'PENDING';
    }

    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.borderLight),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                _formatCurrency(req.amount),
                style: GoogleFonts.outfit(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary,
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: statusBg,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  statusText,
                  style: GoogleFonts.outfit(
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                    color: statusColor,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '${req.durationMonths} Months • ${req.paymentFrequency.toUpperCase()}',
                style: GoogleFonts.outfit(fontSize: 12, color: AppColors.textSecondary),
              ),
              Text(
                _formatDate(req.createdAt),
                style: GoogleFonts.outfit(fontSize: 11, color: AppColors.textMuted),
              ),
            ],
          ),
          if (req.isRejected && req.adminRemarks != null && req.adminRemarks!.isNotEmpty) ...[
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: AppColors.errorLight,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                'Admin Remark: ${req.adminRemarks}',
                style: GoogleFonts.outfit(fontSize: 11, color: AppColors.errorDark),
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildPendingBanner(BuildContext context, LoanRequestModel pendingReq, ThemeData theme) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.amber.shade50,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: Colors.amber.shade300),
      ),
      child: Row(
        children: [
          Icon(Icons.hourglass_top_rounded, color: Colors.amber.shade800, size: 20),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Additional Loan Request Pending',
                  style: GoogleFonts.outfit(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: Colors.amber.shade900,
                  ),
                ),
                Text(
                  'Your request for ${_formatCurrency(pendingReq.amount)} (#REQ-${pendingReq.id}) is under admin review.',
                  style: GoogleFonts.outfit(
                    fontSize: 11,
                    color: Colors.amber.shade800,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAdditionalLoanCard(BuildContext context, ThemeData theme) {
    return Container(
      margin: const EdgeInsets.only(top: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.borderLight),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: theme.colorScheme.primary.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(Icons.add_card_rounded, color: theme.colorScheme.primary, size: 22),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Need Additional Funds?',
                  style: GoogleFonts.outfit(
                    fontSize: 13,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textPrimary,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  'Apply for a new committee loan easily',
                  style: GoogleFonts.outfit(
                    fontSize: 11,
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
          ElevatedButton(
            onPressed: () => ApplyLoanBottomSheet.show(context),
            style: ElevatedButton.styleFrom(
              backgroundColor: theme.colorScheme.primary,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            child: Text(
              'Apply',
              style: GoogleFonts.outfit(
                fontSize: 12,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildScheduleDateCard(String label, String value, bool isGreen) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: GoogleFonts.outfit(
              fontSize: 10,
              fontWeight: FontWeight.bold,
              color: AppColors.textMuted,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: GoogleFonts.outfit(
              fontSize: 12,
              fontWeight: FontWeight.bold,
              color: isGreen ? AppColors.successGreen : AppColors.textPrimary,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMetricItem(String title, String value, bool isRed, bool isGreen) {
    Color valueColor = AppColors.textPrimary;
    if (isRed) {
      valueColor = AppColors.errorAccent;
    } else if (isGreen) {
      valueColor = AppColors.successGreen;
    }

    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.borderLight),
      ),
      child: Column(
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
          const SizedBox(height: 4),
          Text(
            value,
            style: GoogleFonts.outfit(
              fontSize: 15,
              fontWeight: FontWeight.bold,
              color: valueColor,
            ),
          ),
        ],
      ),
    );
  }
}
