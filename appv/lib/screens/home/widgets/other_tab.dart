import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../../../constants/app_colors.dart';
import '../../../provider/dashboard_provider.dart';
import '../../../provider/committee_provider.dart';
import '../../../provider/installment_provider.dart';
import '../home_screen.dart';

class OtherTab extends StatefulWidget {
  const OtherTab({super.key});

  @override
  State<OtherTab> createState() => _OtherTabState();
}

class _OtherTabState extends State<OtherTab> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<CommitteeProvider>(context, listen: false).fetchMyCommittees();
      Provider.of<InstallmentProvider>(context, listen: false).fetchPending();
      Provider.of<InstallmentProvider>(context, listen: false).fetchPaid();
    });
  }

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
    return Consumer3<DashboardProvider, CommitteeProvider, InstallmentProvider>(
      builder: (context, dp, cp, ip, child) {
        final wallet = dp.wallet;
        final stats = dp.stats;
        final userName = dp.userInfo?.name ?? 'User';
        final totalBalance = wallet?.totalBalance ?? 0;
        final credits = wallet?.credits ?? 0;
        final debits = wallet?.debits ?? 0;
        final activeCommittees = stats?.activeCommittees ?? 0;
        final activeLoans = stats?.activeLoans ?? 0;
        final myCommittees = cp.myCommittees;

        final allPending = ip.allPending;
        final allPaid = ip.allPaid;
        final totalInstallments = allPending.length + allPaid.length;
        final paidRatio = totalInstallments > 0
            ? allPaid.length / totalInstallments
            : 0.0;

        // Find next due date
        String nextDueDate = 'N/A';
        if (allPending.isNotEmpty) {
          allPending.sort((a, b) => (a.dueDate ?? '').compareTo(b.dueDate ?? ''));
          nextDueDate = _formatDate(allPending.first.dueDate);
        }

        return Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // 1. Welcome Header Section
            Text(
              'WELCOME BACK',
              style: GoogleFonts.outfit(
                fontSize: 11,
                fontWeight: FontWeight.bold,
                color: AppColors.textSecondary,
                letterSpacing: 1.0,
              ),
            ),
            const SizedBox(height: 4),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    userName,
                    style: GoogleFonts.outfit(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textDark,
                      letterSpacing: -0.5,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                // Join Community Button
                ElevatedButton.icon(
                  onPressed: () {
                    HomeScreen.activeTabNotifier.value = 1; // Switch to Community tab
                  },
                  icon: const Icon(Icons.add, size: 14, color: Colors.white),
                  label: Text(
                    'Join Community',
                    style: GoogleFonts.outfit(
                      fontSize: 11,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primaryGreen,
                    elevation: 0,
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),

            // 2. White Digital Passbook Balance Card
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: AppColors.borderMuted),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withAlpha(6),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  )
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'DIGITAL PASSBOOK\nBALANCE',
                        style: GoogleFonts.outfit(
                          fontSize: 11,
                          fontWeight: FontWeight.bold,
                          color: AppColors.textSecondary,
                          letterSpacing: 0.5,
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: const BoxDecoration(
                          color: AppColors.primaryGreen,
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.shield_outlined,
                          color: Colors.white,
                          size: 20,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    _formatCurrency(totalBalance),
                    style: GoogleFonts.outfit(
                      fontSize: 26,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textDark,
                    ),
                  ),
                  const SizedBox(height: 16),
                  // Horizontal status pills
                  Row(
                    children: [
                      _buildStatusPill(
                        icon: Icons.circle,
                        iconColor: AppColors.successGreen,
                        label: 'Live Tracking Active',
                      ),
                      const SizedBox(width: 8),
                      _buildStatusPill(
                        icon: Icons.groups_rounded,
                        iconColor: AppColors.primaryGreen,
                        label: '$activeCommittees Committees',
                      ),
                    ],
                  )
                ],
              ),
            ),
            const SizedBox(height: 16),

            // 3. Grid of 4 statistic cards
            GridView.count(
              crossAxisCount: 2,
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              childAspectRatio: 1.6,
              children: [
                _buildStatCard(
                  title: 'Total Credits',
                  value: _formatCurrency(credits),
                  icon: Icons.payments_outlined,
                  iconColor: AppColors.successGreen,
                ),
                _buildStatCard(
                  title: 'Total Debits',
                  value: _formatCurrency(debits),
                  icon: Icons.account_balance_wallet_outlined,
                  iconColor: AppColors.infoBlue,
                ),
                _buildStatCard(
                  title: 'Next Due Date',
                  value: nextDueDate,
                  icon: Icons.calendar_today_outlined,
                  iconColor: AppColors.errorAccent,
                ),
                _buildStatCard(
                  title: 'Active Loans',
                  value: '$activeLoans',
                  icon: Icons.monetization_on_outlined,
                  iconColor: AppColors.primaryGreen,
                ),
              ],
            ),
            const SizedBox(height: 24),

            // 4. Your Community Section
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Your Community',
                  style: GoogleFonts.outfit(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textDark,
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    HomeScreen.activeTabNotifier.value = 1;
                  },
                  child: Text(
                    'View Community Details',
                    style: GoogleFonts.outfit(
                      color: AppColors.primaryGreen,
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),

            // Community Details Cards from API
            if (myCommittees.isEmpty)
              Container(
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: AppColors.borderMuted),
                ),
                child: Center(
                  child: Text(
                    'No communities joined yet',
                    style: GoogleFonts.outfit(fontSize: 14, color: AppColors.textMuted),
                  ),
                ),
              )
            else
              ...myCommittees.take(2).map((committee) => Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: AppColors.borderMuted),
                  ),
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: AppColors.backgroundSoft,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: const Icon(
                          Icons.people_alt_rounded,
                          color: AppColors.textSecondary,
                          size: 24,
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              committee.name ?? 'Committee',
                              style: GoogleFonts.outfit(
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                                color: AppColors.textDark,
                              ),
                            ),
                            const SizedBox(height: 6),
                            Row(
                              children: [
                                _buildBadgeChip('ID: #${committee.id}'),
                                const SizedBox(width: 8),
                                _buildBadgeChip('${committee.frequencyLabel} • ${_formatCurrency(committee.monthlyAmount)}/inst'),
                              ],
                            )
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              )),
            const SizedBox(height: 24),

            // 5. PAID INSTALLMENT RATIO Card
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: AppColors.borderMuted),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Center(
                    child: Text(
                      'PAID INSTALLMENT RATIO',
                      style: GoogleFonts.outfit(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: AppColors.textSecondary,
                        letterSpacing: 0.5,
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  // Circular Chart
                  Center(
                    child: SizedBox(
                      width: 130,
                      height: 130,
                      child: Stack(
                        children: [
                          Center(
                            child: SizedBox(
                              width: 120,
                              height: 120,
                              child: CircularProgressIndicator(
                                value: paidRatio.clamp(0.0, 1.0),
                                strokeWidth: 10,
                                backgroundColor: AppColors.borderMuted,
                                valueColor: const AlwaysStoppedAnimation<Color>(
                                  AppColors.primaryGreen,
                                ),
                              ),
                            ),
                          ),
                          Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  '${(paidRatio * 100).toStringAsFixed(0)}%',
                                  style: GoogleFonts.outfit(
                                    fontSize: 24,
                                    fontWeight: FontWeight.bold,
                                    color: AppColors.textDark,
                                  ),
                                ),
                                Text(
                                  'Success Rate',
                                  style: GoogleFonts.outfit(
                                    fontSize: 10,
                                    color: AppColors.textSecondary,
                                  ),
                                ),
                              ],
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  // Completed / Remaining layout
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Completed',
                        style: GoogleFonts.outfit(fontSize: 13, color: AppColors.textSecondary),
                      ),
                      Text(
                        '${allPaid.length} Installments',
                        style: GoogleFonts.outfit(
                          fontSize: 13,
                          fontWeight: FontWeight.bold,
                          color: AppColors.successDark,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Remaining',
                        style: GoogleFonts.outfit(fontSize: 13, color: AppColors.textSecondary),
                      ),
                      Text(
                        '${allPending.length} Installments',
                        style: GoogleFonts.outfit(
                          fontSize: 13,
                          fontWeight: FontWeight.bold,
                          color: AppColors.infoBlueDark,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // 6. Installment History Header
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Installment History',
                  style: GoogleFonts.outfit(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textDark,
                  ),
                ),
                GestureDetector(
                  onTap: () {},
                  child: Text(
                    'View All History',
                    style: GoogleFonts.outfit(
                      color: AppColors.primaryGreen,
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),

            // Installment history from API
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: AppColors.borderMuted),
              ),
              padding: const EdgeInsets.symmetric(vertical: 8),
              child: Column(
                children: [
                  // Header Row
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    child: Row(
                      children: [
                        Expanded(
                          flex: 3,
                          child: Text(
                            'Description',
                            style: GoogleFonts.outfit(
                              fontSize: 13,
                              fontWeight: FontWeight.bold,
                              color: AppColors.textSecondary,
                            ),
                          ),
                        ),
                        Expanded(
                          flex: 2,
                          child: Text(
                            'Amount',
                            textAlign: TextAlign.center,
                            style: GoogleFonts.outfit(
                              fontSize: 13,
                              fontWeight: FontWeight.bold,
                              color: AppColors.textSecondary,
                            ),
                          ),
                        ),
                        Expanded(
                          flex: 2,
                          child: Text(
                            'Status',
                            textAlign: TextAlign.right,
                            style: GoogleFonts.outfit(
                              fontSize: 13,
                              fontWeight: FontWeight.bold,
                              color: AppColors.textSecondary,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const Divider(color: AppColors.borderMuted, height: 1),

                  if (allPaid.isEmpty && allPending.isEmpty)
                    Padding(
                      padding: const EdgeInsets.all(24),
                      child: Text(
                        'No installment history',
                        style: GoogleFonts.outfit(color: AppColors.textMuted),
                      ),
                    )
                  else
                    ...[
                      // Show recent paid installments
                      ...allPaid.take(3).map((inst) {
                        return Column(
                          children: [
                            _buildHistoryTableItem(
                              title: inst.committeeName != 'N/A'
                                  ? inst.committeeName
                                  : inst.loanLabel,
                              date: _formatDate(inst.paidDate ?? inst.dueDate),
                              amount: _formatCurrency(inst.amount ?? 0),
                              status: 'Paid',
                              icon: Icons.check_circle_outline,
                            ),
                            const Divider(color: AppColors.borderMuted, height: 1),
                          ],
                        );
                      }),
                      // Show recent pending
                      ...allPending.take(2).map((inst) {
                        return Column(
                          children: [
                            _buildHistoryTableItem(
                              title: inst.committeeName != 'N/A'
                                  ? inst.committeeName
                                  : inst.loanLabel,
                              date: _formatDate(inst.dueDate),
                              amount: _formatCurrency(inst.amount ?? 0),
                              status: 'Pending',
                              icon: Icons.schedule_rounded,
                            ),
                            const Divider(color: AppColors.borderMuted, height: 1),
                          ],
                        );
                      }),
                    ],
                ],
              ),
            ),
            const SizedBox(height: 20),
          ],
        );
      },
    );
  }

  Widget _buildStatusPill({
    required IconData icon,
    required Color iconColor,
    required String label,
  }) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
        decoration: BoxDecoration(
          color: AppColors.lavenderSoft,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              color: iconColor,
              size: icon == Icons.circle ? 6 : 12,
            ),
            const SizedBox(width: 6),
            Expanded(
              child: Text(
                label,
                overflow: TextOverflow.ellipsis,
                style: GoogleFonts.outfit(
                  fontSize: 10,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textSecondary,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatCard({
    required String title,
    required String value,
    required IconData icon,
    required Color iconColor,
  }) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.borderMuted),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Icon(icon, color: iconColor, size: 20),
              Container(
                width: 6,
                height: 6,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.grey.shade300,
                ),
              )
            ],
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: GoogleFonts.outfit(
                  fontSize: 10,
                  color: AppColors.textSecondary,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                value,
                style: GoogleFonts.outfit(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textDark,
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ],
          )
        ],
      ),
    );
  }

  Widget _buildBadgeChip(String label) {
    return Flexible(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        decoration: BoxDecoration(
          color: AppColors.lavenderSoft,
          borderRadius: BorderRadius.circular(6),
        ),
        child: Text(
          label,
          style: GoogleFonts.outfit(
            fontSize: 9,
            fontWeight: FontWeight.w600,
            color: AppColors.textSecondary,
          ),
          overflow: TextOverflow.ellipsis,
        ),
      ),
    );
  }

  Widget _buildHistoryTableItem({
    required String title,
    required String date,
    required String amount,
    required String status,
    required IconData icon,
  }) {
    Color statusBgColor;
    Color statusBorderColor;
    Color statusTextColor;

    if (status.toLowerCase() == 'paid') {
      statusBgColor = AppColors.successLight;
      statusBorderColor = AppColors.successGreen;
      statusTextColor = AppColors.successDark;
    } else if (status.toLowerCase() == 'overdue') {
      statusBgColor = AppColors.errorLight;
      statusBorderColor = AppColors.errorAccent;
      statusTextColor = AppColors.errorDark;
    } else {
      statusBgColor = AppColors.infoBlueLight;
      statusBorderColor = AppColors.infoBlue;
      statusTextColor = AppColors.infoBlueDark;
    }

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        children: [
          Expanded(
            flex: 3,
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: const BoxDecoration(
                    color: AppColors.backgroundSoft,
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    icon,
                    color: status.toLowerCase() == 'overdue'
                        ? AppColors.errorAccent
                        : AppColors.textSecondary,
                    size: 18,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        title,
                        style: GoogleFonts.outfit(
                          fontSize: 13,
                          fontWeight: FontWeight.bold,
                          color: AppColors.textDark,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 4),
                      Text(
                        date,
                        style: GoogleFonts.outfit(
                          fontSize: 11,
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            flex: 2,
            child: Text(
              amount,
              textAlign: TextAlign.center,
              style: GoogleFonts.outfit(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: AppColors.textDark,
              ),
              overflow: TextOverflow.ellipsis,
            ),
          ),
          Expanded(
            flex: 2,
            child: Align(
              alignment: Alignment.centerRight,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                decoration: BoxDecoration(
                  color: statusBgColor,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: statusBorderColor, width: 1),
                ),
                child: Text(
                  status,
                  style: GoogleFonts.outfit(
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                    color: statusTextColor,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
