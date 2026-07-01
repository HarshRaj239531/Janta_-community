import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../home_screen.dart';

class OtherTab extends StatelessWidget {
  const OtherTab({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // 1. Welcome Header Section
        Text(
          'WELCOME BACK',
          style: GoogleFonts.outfit(
            fontSize: 11,
            fontWeight: FontWeight.bold,
            color: const Color(0xFF6B7280),
            letterSpacing: 1.0,
          ),
        ),
        const SizedBox(height: 4),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Alexander Vanguard',
              style: GoogleFonts.outfit(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: const Color(0xFF111827),
                letterSpacing: -0.5,
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
                backgroundColor: const Color(0xFF0F4C3A),
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
            border: Border.all(color: const Color(0xFFE5E7EB)),
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
                      color: const Color(0xFF6B7280),
                      letterSpacing: 0.5,
                    ),
                  ),
                  // Green Shield icon
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: const BoxDecoration(
                      color: Color(0xFF0F4C3A), // Dark Green
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
              Row(
                children: [
                  Text(
                    '₹ ',
                    style: GoogleFonts.outfit(
                      fontSize: 26,
                      fontWeight: FontWeight.bold,
                      color: const Color(0xFF0F4C3A), // Green rupee sign
                    ),
                  ),
                  Text(
                    '12,450.00',
                    style: GoogleFonts.outfit(
                      fontSize: 26,
                      fontWeight: FontWeight.bold,
                      color: const Color(0xFF111827),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              // Horizontal status pills
              Row(
                children: [
                  _buildStatusPill(
                    icon: Icons.circle,
                    iconColor: const Color(0xFF10B981), // Green dot
                    label: 'Live Tracking Active',
                  ),
                  const SizedBox(width: 8),
                  _buildStatusPill(
                    icon: Icons.stars_rounded,
                    iconColor: const Color(0xFFFBBF24), // Gold star
                    label: 'Gold Tier Member',
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
              title: 'Total Paid Amount',
              value: '₹8,280.00',
              icon: Icons.payments_outlined,
              iconColor: const Color(0xFF10B981),
            ),
            _buildStatCard(
              title: 'Remaining Balance',
              value: '₹4,250.00',
              icon: Icons.account_balance_wallet_outlined,
              iconColor: const Color(0xFF3B82F6),
            ),
            _buildStatCard(
              title: 'Next Due Date',
              value: 'Oct 24, 2023',
              icon: Icons.calendar_today_outlined,
              iconColor: const Color(0xFFEF4444),
            ),
            _buildStatCard(
              title: 'Active Committees',
              value: '3',
              icon: Icons.groups_outlined,
              iconColor: const Color(0xFF0F4C3A),
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
                color: const Color(0xFF111827),
              ),
            ),
            GestureDetector(
              onTap: () {},
              child: Text(
                'View Community Details',
                style: GoogleFonts.outfit(
                  color: const Color(0xFF0F4C3A),
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),

        // Community Details Card
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: const Color(0xFFE5E7EB)),
          ),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: const Color(0xFFF3F4F6),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(
                  Icons.people_alt_rounded,
                  color: Color(0xFF6B7280),
                  size: 24,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Elite Investors Group',
                      style: GoogleFonts.outfit(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: const Color(0xFF111827),
                      ),
                    ),
                    const SizedBox(height: 6),
                    Row(
                      children: [
                        _buildBadgeChip('ID: #EIG-2024'),
                        const SizedBox(width: 8),
                        _buildBadgeChip('Category: Premium Finance'),
                      ],
                    )
                  ],
                ),
              )
            ],
          ),
        ),
        const SizedBox(height: 24),

        // 5. PAID INSTALLMENT RATIO Card (65% success)
        Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: const Color(0xFFE5E7EB)),
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
                    color: const Color(0xFF6B7280),
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
                            value: 0.65,
                            strokeWidth: 10,
                            backgroundColor: const Color(0xFFE5E7EB),
                            valueColor: const AlwaysStoppedAnimation<Color>(
                              Color(0xFF0F4C3A),
                            ),
                          ),
                        ),
                      ),
                      Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              '65%',
                              style: GoogleFonts.outfit(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                                color: const Color(0xFF111827),
                              ),
                            ),
                            Text(
                              'Success Rate',
                              style: GoogleFonts.outfit(
                                fontSize: 10,
                                color: const Color(0xFF6B7280),
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
                    style: GoogleFonts.outfit(fontSize: 13, color: const Color(0xFF6B7280)),
                  ),
                  Text(
                    '13 Installments',
                    style: GoogleFonts.outfit(
                      fontSize: 13,
                      fontWeight: FontWeight.bold,
                      color: const Color(0xFF065F46),
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
                    style: GoogleFonts.outfit(fontSize: 13, color: const Color(0xFF6B7280)),
                  ),
                  Text(
                    '7 Installments',
                    style: GoogleFonts.outfit(
                      fontSize: 13,
                      fontWeight: FontWeight.bold,
                      color: const Color(0xFF1E40AF),
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
                color: const Color(0xFF111827),
              ),
            ),
            GestureDetector(
              onTap: () {},
              child: Text(
                'View All History',
                style: GoogleFonts.outfit(
                  color: const Color(0xFF0F4C3A),
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),

        // Table Card Container wrapping headers and rows
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: const Color(0xFFE5E7EB)),
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
                          color: const Color(0xFF4B5563),
                        ),
                      ),
                    ),
                    Expanded(
                      flex: 2,
                      child: Text(
                        'Date',
                        style: GoogleFonts.outfit(
                          fontSize: 13,
                          fontWeight: FontWeight.bold,
                          color: const Color(0xFF4B5563),
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
                          color: const Color(0xFF4B5563),
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
                          color: const Color(0xFF4B5563),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const Divider(color: Color(0xFFE5E7EB), height: 1),

              // Item 1
              _buildHistoryTableItem(
                title: 'October Installment',
                date: 'Oct 20, 2023',
                amount: '\$1,200.00',
                status: 'Paid',
                icon: Icons.calendar_month_outlined,
              ),
              const Divider(color: Color(0xFFE5E7EB), height: 1),

              // Item 2
              _buildHistoryTableItem(
                title: 'Elite Committee Fee',
                date: 'Oct 05, 2023',
                amount: '\$2,500.00',
                status: 'Overdue',
                icon: Icons.warning_amber_rounded,
              ),
              const Divider(color: Color(0xFFE5E7EB), height: 1),

              // Item 3
              _buildHistoryTableItem(
                title: 'Maintenance Contribution',
                date: 'Oct 28, 2023',
                amount: '\$450.00',
                status: 'Pending',
                icon: Icons.schedule_rounded,
              ),
            ],
          ),
        ),
        const SizedBox(height: 20),
      ],
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
          color: const Color(0xFFEEF2F6), // Light blue-grey background
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
                  color: const Color(0xFF475569),
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
        border: Border.all(color: const Color(0xFFE5E7EB)),
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
                  color: const Color(0xFF6B7280),
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                value,
                style: GoogleFonts.outfit(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: const Color(0xFF111827),
                ),
              ),
            ],
          )
        ],
      ),
    );
  }

  Widget _buildBadgeChip(String label) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: const Color(0xFFEEF2F6),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Text(
        label,
        style: GoogleFonts.outfit(
          fontSize: 9,
          fontWeight: FontWeight.w600,
          color: const Color(0xFF475569),
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
      statusBgColor = const Color(0xFFD1FAE5);
      statusBorderColor = const Color(0xFF10B981);
      statusTextColor = const Color(0xFF065F46);
    } else if (status.toLowerCase() == 'overdue') {
      statusBgColor = const Color(0xFFFEE2E2);
      statusBorderColor = const Color(0xFFEF4444);
      statusTextColor = const Color(0xFF991B1B);
    } else {
      statusBgColor = const Color(0xFFDBEAFE);
      statusBorderColor = const Color(0xFF3B82F6);
      statusTextColor = const Color(0xFF1E40AF);
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
                    color: Color(0xFFF3F4F6),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    icon,
                    color: status.toLowerCase() == 'overdue'
                        ? const Color(0xFFEF4444)
                        : const Color(0xFF6B7280),
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
                          color: const Color(0xFF111827),
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        date,
                        style: GoogleFonts.outfit(
                          fontSize: 11,
                          color: const Color(0xFF6B7280),
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
                color: const Color(0xFF111827),
              ),
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
