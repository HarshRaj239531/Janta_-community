import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class PaymentHistoryTab extends StatelessWidget {
  final VoidCallback onPayEmiPressed;

  const PaymentHistoryTab({
    super.key,
    required this.onPayEmiPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // Total Repaid progress card
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: const Color(0xFFE2E8F0)),
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(16),
            child: Container(
              decoration: const BoxDecoration(
                border: Border(
                  left: BorderSide(
                    color: Color(0xFF0F4C3A),
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
                      color: const Color(0xFF94A3B8),
                      letterSpacing: 0.5,
                    ),
                  ),
                  const SizedBox(height: 8),
                  RichText(
                    text: TextSpan(
                      style: GoogleFonts.outfit(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: const Color(0xFF1E293B),
                      ),
                      children: [
                        const TextSpan(text: '₹ 4,52,000'),
                        TextSpan(
                          text: '  /  ₹ 12,00,000',
                          style: GoogleFonts.outfit(
                            fontSize: 13,
                            color: const Color(0xFF64748B),
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
                    child: const LinearProgressIndicator(
                      value: 0.38, // 4.52L / 12L ~37.6%
                      backgroundColor: Color(0xFFEEF2FA),
                      valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF0F4C3A)),
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
                              color: const Color(0xFF64748B),
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            '12  /  36',
                            style: GoogleFonts.outfit(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              color: const Color(0xFF1E293B),
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
                              color: const Color(0xFF64748B),
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            '₹ 38,450',
                            style: GoogleFonts.outfit(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              color: const Color(0xFF0F4C3A),
                            ),
                          ),
                        ],
                      ),
                      ElevatedButton(
                        onPressed: onPayEmiPressed,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF0F4C3A),
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
            color: const Color(0xFFEEF2FA),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: const Color(0xFFE2E8F0)),
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
                child: const Icon(Icons.account_balance_rounded, color: Color(0xFF0F4C3A), size: 20),
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
                            color: const Color(0xFF64748B),
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                          decoration: BoxDecoration(
                            color: const Color(0xFFD1FAE5),
                            borderRadius: BorderRadius.circular(30),
                          ),
                          child: Text(
                            'Active Loan',
                            style: GoogleFonts.outfit(
                              fontSize: 9,
                              fontWeight: FontWeight.bold,
                              color: const Color(0xFF0F4C3A),
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
                        color: const Color(0xFF1E293B),
                      ),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      'Last Payment Date',
                      style: GoogleFonts.outfit(
                        fontSize: 11,
                        color: const Color(0xFF64748B),
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      'Oct 15, 2023',
                      style: GoogleFonts.outfit(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: const Color(0xFF1E293B),
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
            color: const Color(0xFF1E293B),
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
          title: 'EMI Installment #12',
          date: 'Oct 15, 2023 • 14:22',
          amount: '₹ 38,458',
          status: 'Success',
          icon: Icons.account_balance_rounded,
        ),
        const SizedBox(height: 10),
        _buildTransactionItem(
          title: 'EMI Installment #11',
          date: 'Sep 15, 2023 • 09:45',
          amount: '₹ 38,450',
          status: 'Pending',
          icon: Icons.payment_rounded,
        ),
        const SizedBox(height: 10),
        _buildTransactionItem(
          title: 'EMI Installment #10',
          date: 'Aug 15, 2023 • 11:15',
          amount: '₹ 38,458',
          status: 'Success',
          icon: Icons.account_balance_rounded,
        ),
        const SizedBox(height: 10),
        _buildTransactionItem(
          title: 'EMI Installment #9',
          date: 'Jul 15, 2023 • 10:02',
          amount: '₹ 38,458',
          status: 'Success',
          icon: Icons.account_balance_rounded,
        ),
        const SizedBox(height: 10),
        _buildTransactionItem(
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
                color: const Color(0xFF64748B),
              ),
            ),
            label: const Icon(Icons.keyboard_arrow_down_rounded, color: Color(0xFF64748B), size: 16),
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
        border: Border.all(color: const Color(0xFFE2E8F0)),
      ),
      child: Row(
        children: [
          Icon(icon, color: const Color(0xFF64748B), size: 14),
          const SizedBox(width: 6),
          Text(
            label,
            style: GoogleFonts.outfit(
              fontSize: 11,
              fontWeight: FontWeight.bold,
              color: const Color(0xFF64748B),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTransactionItem({
    required String title,
    required String date,
    required String amount,
    required String status,
    required IconData icon,
  }) {
    Color statusBgColor;
    Color statusTextColor;
    Color amountColor;

    if (status == 'Success') {
      statusBgColor = const Color(0xFFD1FAE5);
      statusTextColor = const Color(0xFF0F4C3A);
      amountColor = const Color(0xFF0F4C3A);
    } else if (status == 'Pending') {
      statusBgColor = const Color(0xFFEEF2FA);
      statusTextColor = const Color(0xFF3B82F6);
      amountColor = const Color(0xFF1E293B);
    } else {
      statusBgColor = const Color(0xFFFEF2F2);
      statusTextColor = const Color(0xFFEF4444);
      amountColor = const Color(0xFF94A3B8); // Gray for failed
    }

    final isFailed = status == 'Failed';

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFE2E8F0)),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: isFailed ? const Color(0xFFFEF2F2) : const Color(0xFFEEF2FA),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(
              icon,
              color: isFailed ? const Color(0xFFEF4444) : const Color(0xFF0F4C3A),
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
                    color: const Color(0xFF1E293B),
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  date,
                  style: GoogleFonts.outfit(
                    fontSize: 10,
                    color: const Color(0xFF94A3B8),
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
