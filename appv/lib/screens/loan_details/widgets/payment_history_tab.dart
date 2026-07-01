import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../constants/app_colors.dart';

class PaymentHistoryTab extends StatelessWidget {
  final VoidCallback onPayEmiPressed;

  const PaymentHistoryTab({
    super.key,
    required this.onPayEmiPressed,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // Total Repaid progress card
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
                  Text(
                    'TOTAL REPAID AMOUNT',
                    style: GoogleFonts.outfit(
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textMuted,
                      letterSpacing: 0.5,
                    ),
                  ),
                  const SizedBox(height: 8),
                  RichText(
                    text: TextSpan(
                      style: GoogleFonts.outfit(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: AppColors.textPrimary,
                      ),
                      children: [
                        const TextSpan(text: '₹ 4,52,000'),
                        TextSpan(
                          text: '  /  ₹ 12,00,000',
                          style: GoogleFonts.outfit(
                            fontSize: 13,
                            color: AppColors.textSecondary,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 14),
                  // Progress bar
                  ClipRRect(
                    borderRadius: BorderRadius.circular(4),
                    child: LinearProgressIndicator(
                      value: 0.38, // 4.52L / 12L ~37.6%
                      backgroundColor: AppColors.lavenderSoft,
                      valueColor: AlwaysStoppedAnimation<Color>(theme.colorScheme.primary),
                      minHeight: 6,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Installments Paid',
                            style: GoogleFonts.outfit(
                              fontSize: 10,
                              color: AppColors.textSecondary,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            '12  /  36',
                            style: GoogleFonts.outfit(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              color: AppColors.textPrimary,
                            ),
                          ),
                        ],
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Next Due',
                            style: GoogleFonts.outfit(
                              fontSize: 10,
                              color: AppColors.textSecondary,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            '₹ 38,450',
                            style: GoogleFonts.outfit(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              color: theme.colorScheme.primary,
                            ),
                          ),
                        ],
                      ),
                      ElevatedButton(
                        onPressed: onPayEmiPressed,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: theme.colorScheme.primary,
                          elevation: 0,
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                        ),
                        child: Text(
                          'Pay EMI',
                          style: GoogleFonts.outfit(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
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

        // Loan Reference Box
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: AppColors.lavenderSoft,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: AppColors.borderLight),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: const BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                ),
                child: Icon(Icons.account_balance_rounded, color: theme.colorScheme.primary, size: 20),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Loan Reference',
                          style: GoogleFonts.outfit(
                            fontSize: 11,
                            color: AppColors.textSecondary,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                          decoration: BoxDecoration(
                            color: AppColors.successLight,
                            borderRadius: BorderRadius.circular(30),
                          ),
                          child: Text(
                            'Active Loan',
                            style: GoogleFonts.outfit(
                              fontSize: 9,
                              fontWeight: FontWeight.bold,
                              color: theme.colorScheme.primary,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 2),
                    Text(
                      'LX-EM-2024-9981',
                      style: GoogleFonts.outfit(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      'Last Payment Date',
                      style: GoogleFonts.outfit(
                        fontSize: 11,
                        color: AppColors.textSecondary,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      'Oct 15, 2023',
                      style: GoogleFonts.outfit(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: AppColors.textPrimary,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 20),

        // Transaction History Header
        Text(
          'Transaction History',
          style: GoogleFonts.outfit(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: AppColors.textPrimary,
          ),
        ),
        const SizedBox(height: 12),

        // Quick Filters row
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: [
              _buildFilterChip(Icons.calendar_today_rounded, 'Date Range'),
              const SizedBox(width: 8),
              _buildFilterChip(Icons.filter_list_rounded, 'Status'),
              const SizedBox(width: 8),
              _buildFilterChip(Icons.download_rounded, 'Statement'),
            ],
          ),
        ),
        const SizedBox(height: 16),

        // Transactions list items
        _buildTransactionItem(
          context,
          title: 'EMI Installment #12',
          date: 'Oct 15, 2023 • 14:22',
          amount: '₹ 38,458',
          status: 'Success',
          icon: Icons.account_balance_rounded,
        ),
        const SizedBox(height: 10),
        _buildTransactionItem(
          context,
          title: 'EMI Installment #11',
          date: 'Sep 15, 2023 • 09:45',
          amount: '₹ 38,450',
          status: 'Pending',
          icon: Icons.payment_rounded,
        ),
        const SizedBox(height: 10),
        _buildTransactionItem(
          context,
          title: 'EMI Installment #10',
          date: 'Aug 15, 2023 • 11:15',
          amount: '₹ 38,458',
          status: 'Success',
          icon: Icons.account_balance_rounded,
        ),
        const SizedBox(height: 10),
        _buildTransactionItem(
          context,
          title: 'EMI Installment #9',
          date: 'Jul 15, 2023 • 10:02',
          amount: '₹ 38,458',
          status: 'Success',
          icon: Icons.account_balance_rounded,
        ),
        const SizedBox(height: 10),
        _buildTransactionItem(
          context,
          title: 'EMI Installment #8',
          date: 'Jun 15, 2023 • 16:40',
          amount: '₹ 38,450',
          status: 'Failed',
          icon: Icons.error_outline_rounded,
        ),
        const SizedBox(height: 16),

        // Load older transactions
        Center(
          child: TextButton.icon(
            onPressed: () {},
            icon: Text(
              'Load older transactions',
              style: GoogleFonts.outfit(
                fontSize: 13,
                fontWeight: FontWeight.bold,
                color: AppColors.textSecondary,
              ),
            ),
            label: const Icon(Icons.keyboard_arrow_down_rounded, color: AppColors.textSecondary, size: 16),
          ),
        ),
        const SizedBox(height: 80),
      ],
    );
  }

  Widget _buildFilterChip(IconData icon, String label) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(30),
        border: Border.all(color: AppColors.borderLight),
      ),
      child: Row(
        children: [
          Icon(icon, color: AppColors.textSecondary, size: 14),
          const SizedBox(width: 6),
          Text(
            label,
            style: GoogleFonts.outfit(
              fontSize: 11,
              fontWeight: FontWeight.bold,
              color: AppColors.textSecondary,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTransactionItem(
    BuildContext context, {
    required String title,
    required String date,
    required String amount,
    required String status,
    required IconData icon,
  }) {
    final theme = Theme.of(context);
    Color statusBgColor;
    Color statusTextColor;
    Color amountColor;

    if (status == 'Success') {
      statusBgColor = AppColors.successLight;
      statusTextColor = theme.colorScheme.primary;
      amountColor = theme.colorScheme.primary;
    } else if (status == 'Pending') {
      statusBgColor = AppColors.lavenderSoft;
      statusTextColor = AppColors.infoBlue;
      amountColor = AppColors.textPrimary;
    } else {
      statusBgColor = AppColors.errorLight;
      statusTextColor = AppColors.errorAccent;
      amountColor = AppColors.textMuted; // Gray for failed
    }

    final isFailed = status == 'Failed';

    return Container(
      padding: const EdgeInsets.all(12),
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
              color: isFailed ? AppColors.errorLight : AppColors.lavenderSoft,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(
              icon,
              color: isFailed ? AppColors.errorAccent : theme.colorScheme.primary,
              size: 20,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: GoogleFonts.outfit(
                    fontSize: 13,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textPrimary,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  date,
                  style: GoogleFonts.outfit(
                    fontSize: 10,
                    color: AppColors.textMuted,
                  ),
                ),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: statusBgColor,
                  borderRadius: BorderRadius.circular(30),
                ),
                child: Text(
                  status,
                  style: GoogleFonts.outfit(
                    fontSize: 9,
                    fontWeight: FontWeight.bold,
                    color: statusTextColor,
                  ),
                ),
              ),
              const SizedBox(height: 6),
              Text(
                amount,
                style: GoogleFonts.outfit(
                  fontSize: 13,
                  fontWeight: FontWeight.bold,
                  color: amountColor,
                  decoration: isFailed ? TextDecoration.lineThrough : TextDecoration.none,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
