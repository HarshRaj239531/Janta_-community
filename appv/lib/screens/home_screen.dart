import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../constants/app_colors.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0F1113), // Deep premium dark background
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Welcome back,',
                        style: GoogleFonts.outfit(
                          fontSize: 14,
                          color: Colors.white54,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Alex Carter',
                        style: GoogleFonts.outfit(
                          fontSize: 20,
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                  Container(
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(color: AppColors.goldStart.withAlpha(128), width: 1.5),
                    ),
                    child: const CircleAvatar(
                      radius: 22,
                      backgroundColor: Colors.grey,
                      backgroundImage: NetworkImage('https://images.unsplash.com/photo-1535713875002-d1d0cf377fde?w=150'),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 32),

              // Balance Card (Premium Gold/Green Glassmorphic look)
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(24.0),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(24),
                  gradient: LinearGradient(
                    colors: [
                      const Color(0xFF1E2229),
                      const Color(0xFF121418),
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  border: Border.all(color: Colors.white.withAlpha(20)),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withAlpha(102),
                      blurRadius: 20,
                      offset: const Offset(0, 10),
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
                          'Total Balance',
                          style: GoogleFonts.outfit(
                            fontSize: 15,
                            color: Colors.white54,
                          ),
                        ),
                        // Small gold chip logo
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                          decoration: BoxDecoration(
                            gradient: const LinearGradient(
                              colors: AppColors.goldGradient,
                            ),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            'PRO',
                            style: GoogleFonts.outfit(
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Text(
                      '\$48,250.80',
                      style: GoogleFonts.outfit(
                        fontSize: 36,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        letterSpacing: -0.5,
                      ),
                    ),
                    const SizedBox(height: 24),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        _buildBalanceStat(
                          label: 'Monthly Income',
                          value: '+\$8,420.00',
                          valueColor: AppColors.emeraldGreen,
                        ),
                        _buildBalanceStat(
                          label: 'Monthly Expense',
                          value: '-\$3,150.20',
                          valueColor: const Color(0xFFEF5350),
                        ),
                      ],
                    )
                  ],
                ),
              ),
              const SizedBox(height: 32),

              // Quick Actions
              Text(
                'Quick Actions',
                style: GoogleFonts.outfit(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _buildActionButton(Icons.send_rounded, 'Send'),
                  _buildActionButton(Icons.call_received_rounded, 'Request'),
                  _buildActionButton(Icons.bar_chart_rounded, 'Analytics'),
                  _buildActionButton(Icons.grid_view_rounded, 'More'),
                ],
              ),
              const SizedBox(height: 32),

              // Transactions Section
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Recent Transactions',
                    style: GoogleFonts.outfit(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
                  TextButton(
                    onPressed: () {},
                    child: Text(
                      'See All',
                      style: GoogleFonts.outfit(
                        color: AppColors.goldStart,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),

              // Transaction List
              _buildTransactionItem(
                title: 'Stripe Payout',
                subtitle: 'Sales Revenue',
                amount: '+\$2,450.00',
                date: 'Today, 10:24 AM',
                icon: Icons.monetization_on_rounded,
                isCredit: true,
              ),
              _buildTransactionItem(
                title: 'Figma Subscription',
                subtitle: 'Software License',
                amount: '-\$15.00',
                date: 'Yesterday, 8:45 PM',
                icon: Icons.design_services_rounded,
                isCredit: false,
              ),
              _buildTransactionItem(
                title: 'Uber Eats',
                subtitle: 'Food & Dining',
                amount: '-\$34.50',
                date: 'June 28, 1:15 PM',
                icon: Icons.fastfood_rounded,
                isCredit: false,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBalanceStat({
    required String label,
    required String value,
    required Color valueColor,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: GoogleFonts.outfit(
            fontSize: 12,
            color: Colors.white38,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: GoogleFonts.outfit(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: valueColor,
          ),
        ),
      ],
    );
  }

  Widget _buildActionButton(IconData icon, String label) {
    return Column(
      children: [
        Container(
          width: 60,
          height: 60,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: const Color(0xFF1E2229),
            border: Border.all(color: Colors.white.withAlpha(13)),
          ),
          child: Icon(
            icon,
            color: AppColors.goldStart,
            size: 26,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          label,
          style: GoogleFonts.outfit(
            fontSize: 13,
            fontWeight: FontWeight.w500,
            color: Colors.white70,
          ),
        ),
      ],
    );
  }

  Widget _buildTransactionItem({
    required String title,
    required String subtitle,
    required String amount,
    required String date,
    required IconData icon,
    required bool isCredit,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF171A1E),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.white.withAlpha(8)),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: isCredit
                  ? AppColors.emeraldGreen.withAlpha(26)
                  : const Color(0xFFEF5350).withAlpha(26),
              shape: BoxShape.circle,
            ),
            child: Icon(
              icon,
              color: isCredit ? AppColors.emeraldGreen : const Color(0xFFEF5350),
              size: 20,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: GoogleFonts.outfit(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  subtitle,
                  style: GoogleFonts.outfit(
                    fontSize: 12,
                    color: Colors.white38,
                  ),
                ),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                amount,
                style: GoogleFonts.outfit(
                  fontSize: 15,
                  fontWeight: FontWeight.w700,
                  color: isCredit ? AppColors.emeraldGreen : Colors.white,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                date,
                style: GoogleFonts.outfit(
                  fontSize: 11,
                  color: Colors.white38,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
