import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../../constants/app_colors.dart';
import '../../provider/loan_provider.dart';
import '../../provider/profile_provider.dart';
import '../../provider/installment_provider.dart';
import '../../models/loan_model.dart';
import '../home/home_screen.dart';
import 'widgets/loan_detail_tab.dart';
import 'widgets/payment_history_tab.dart';
import 'widgets/documents_tab.dart';

class LoanDetailsScreen extends StatefulWidget {
  const LoanDetailsScreen({super.key});

  @override
  State<LoanDetailsScreen> createState() => _LoanDetailsScreenState();
}

class _LoanDetailsScreenState extends State<LoanDetailsScreen> {
  int _activeSwitcherIndex = 0; // 0: Loan Detail, 1: Payment History, 2: Documents

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final lp = Provider.of<LoanProvider>(context, listen: false);
      await lp.fetchLoans();
      if (lp.loans.isNotEmpty && mounted) {
        final activeLoan = lp.loans.firstWhere(
          (l) => l.status == 'active',
          orElse: () => lp.loans.first,
        );
        await lp.fetchLoanDetails(activeLoan.id);
      }
      if (mounted) {
        Provider.of<ProfileProvider>(context, listen: false).fetchVault();
      }
    });
  }

  void _showPayEmiBottomSheet() {
    final theme = Theme.of(context);
    final loanProvider = Provider.of<LoanProvider>(context, listen: false);
    final loan = loanProvider.selectedLoan;

    if (loan == null || loan.installments == null || loan.installments!.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'No active loan installments to pay',
            style: GoogleFonts.outfit(),
          ),
          backgroundColor: AppColors.errorAccent,
        ),
      );
      return;
    }

    // Find first pending installment
    final pendingInstallments = loan.installments!.where((i) => i.status == 'pending').toList();
    if (pendingInstallments.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'All installments are already paid!',
            style: GoogleFonts.outfit(),
          ),
          backgroundColor: AppColors.successGreen,
        ),
      );
      return;
    }

    final nextInstallment = pendingInstallments.first;
    String dueDateText = 'N/A';
    if (nextInstallment.dueDate != null) {
      try {
        dueDateText = DateFormat('dd MMM, yyyy').format(DateTime.parse(nextInstallment.dueDate!));
      } catch (_) {
        dueDateText = nextInstallment.dueDate!;
      }
    }

    final amountFormatter = NumberFormat.currency(
      locale: 'en_IN',
      symbol: '₹',
      decimalDigits: 2,
    );

    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) {
        bool isPayingLocal = false;
        return StatefulBuilder(
          builder: (context, setModalState) {
            return SafeArea(
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Center(
                      child: Container(
                        width: 50,
                        height: 5,
                        decoration: BoxDecoration(
                          color: Colors.grey.shade300,
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: theme.colorScheme.primary.withAlpha(25),
                            shape: BoxShape.circle,
                          ),
                          child: Icon(
                            Icons.payments_rounded,
                            color: theme.colorScheme.primary,
                            size: 24,
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Repay Upcoming EMI',
                                style: GoogleFonts.outfit(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: AppColors.textPrimary,
                                ),
                              ),
                              Text(
                                'Loan Ref #${loan.id} • Due $dueDateText',
                                style: GoogleFonts.outfit(
                                  fontSize: 12,
                                  color: AppColors.textSecondary,
                                ),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: AppColors.backgroundAlt,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: AppColors.borderLight),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Amount Due',
                            style: GoogleFonts.outfit(
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                              color: AppColors.textSecondary,
                            ),
                          ),
                          Text(
                            amountFormatter.format(nextInstallment.amount ?? 0),
                            style: GoogleFonts.outfit(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: theme.colorScheme.primary,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 24),
                    Row(
                      children: [
                        Expanded(
                          child: OutlinedButton(
                            onPressed: isPayingLocal ? null : () => Navigator.pop(context),
                            style: OutlinedButton.styleFrom(
                              padding: const EdgeInsets.symmetric(vertical: 14),
                              side: const BorderSide(color: AppColors.borderLight),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            child: Text(
                              'Cancel',
                              style: GoogleFonts.outfit(
                                fontSize: 15,
                                fontWeight: FontWeight.bold,
                                color: AppColors.textSecondary,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: ElevatedButton(
                            onPressed: isPayingLocal
                                ? null
                                : () async {
                                    setModalState(() {
                                      isPayingLocal = true;
                                    });
                                    final ip = Provider.of<InstallmentProvider>(
                                      context,
                                      listen: false,
                                    );
                                    final paid = await ip.payInstallment(
                                      type: 'loan',
                                      installmentId: nextInstallment.id,
                                      amount: nextInstallment.amount ?? 0,
                                    );
                                    if (context.mounted) {
                                      Navigator.pop(context);
                                      if (paid) {
                                        // Refresh loan details
                                        await loanProvider.fetchLoanDetails(loan.id);
                                        _showEmiPaymentSuccess(
                                          amountFormatter.format(nextInstallment.amount ?? 0),
                                        );
                                      } else {
                                        ScaffoldMessenger.of(context).showSnackBar(
                                          SnackBar(
                                            content: Text(
                                              ip.error ?? 'Payment failed',
                                              style: GoogleFonts.outfit(),
                                            ),
                                            backgroundColor: AppColors.errorAccent,
                                          ),
                                        );
                                      }
                                    }
                                  },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: theme.colorScheme.primary,
                              padding: const EdgeInsets.symmetric(vertical: 14),
                              elevation: 0,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            child: isPayingLocal
                                ? const SizedBox(
                                    width: 20,
                                    height: 20,
                                    child: CircularProgressIndicator(
                                      color: Colors.white,
                                      strokeWidth: 2,
                                    ),
                                  )
                                : Text(
                                    'Pay EMI',
                                    style: GoogleFonts.outfit(
                                      fontSize: 15,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                    ),
                                  ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  void _showEmiPaymentSuccess(String amountFormatted) {
    final theme = Theme.of(context);
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: Colors.white,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          title: Row(
            children: [
              Icon(Icons.check_circle_rounded, color: theme.colorScheme.primary, size: 28),
              const SizedBox(width: 8),
              Text(
                'EMI Paid Successfully!',
                style: GoogleFonts.outfit(
                  fontWeight: FontWeight.bold,
                  color: AppColors.textDark,
                ),
              ),
            ],
          ),
          content: Text(
            'Your monthly EMI payment of $amountFormatted has been debited successfully.',
            style: GoogleFonts.outfit(fontSize: 14, color: AppColors.textSecondary),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text(
                'Awesome',
                style: GoogleFonts.outfit(
                  color: theme.colorScheme.primary,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        );
      },
    );
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
          icon: const Icon(Icons.arrow_back_ios_new_rounded, color: AppColors.textPrimary),
          onPressed: () {
            HomeScreen.activeTabNotifier.value = 0; // Return to Home dashboard
          },
        ),
        title: Text(
          'Loan Details',
          style: GoogleFonts.outfit(
            fontWeight: FontWeight.bold,
            color: AppColors.textPrimary,
            fontSize: 20,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.more_vert_rounded, color: AppColors.textPrimary),
            onPressed: () {},
          ),
        ],
      ),
      body: Consumer<LoanProvider>(
        builder: (context, lp, child) {
          if (lp.isLoading && lp.loans.isEmpty) {
            return const Center(child: CircularProgressIndicator());
          }

          final error = lp.error;
          final loans = lp.loans;
          final loan = lp.selectedLoan;

          Widget content;
          if (loans.isEmpty) {
            content = Center(
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.monetization_on_outlined, size: 64, color: theme.colorScheme.primary.withAlpha(80)),
                    const SizedBox(height: 16),
                    Text(
                      'No loans found',
                      style: GoogleFonts.outfit(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'You do not have any active loans at this moment.',
                      textAlign: TextAlign.center,
                      style: GoogleFonts.outfit(
                        fontSize: 14,
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
            );
          } else {
            content = Stack(
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // 1. Horizontal Switcher Tabs bar
                    Padding(
                      padding: const EdgeInsets.fromLTRB(16.0, 16.0, 16.0, 8.0),
                      child: SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Row(
                          children: [
                            _buildSwitcherTab(context, 0, Icons.account_balance_wallet_rounded, 'Loan Detail'),
                            const SizedBox(width: 8),
                            _buildSwitcherTab(context, 1, Icons.history_rounded, 'Payment History'),
                            const SizedBox(width: 8),
                            _buildSwitcherTab(context, 2, Icons.description_outlined, 'Documents'),
                          ],
                        ),
                      ),
                    ),

                    // 2. Dynamic Content Body
                    Expanded(
                      child: SingleChildScrollView(
                        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                        child: _buildDynamicBody(loan),
                      ),
                    ),
                  ],
                ),
                // Floating Action Button
                if (loan != null && loan.status == 'active')
                  Positioned(
                    bottom: 16,
                    right: 16,
                    child: FloatingActionButton(
                      onPressed: _showPayEmiBottomSheet,
                      backgroundColor: theme.colorScheme.primary,
                      elevation: 4,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                      child: const Icon(
                        Icons.payments_outlined,
                        color: Colors.white,
                        size: 24,
                      ),
                    ),
                  ),
              ],
            );
          }

          if (error != null) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Container(
                  margin: const EdgeInsets.fromLTRB(16, 16, 16, 0),
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
                        onPressed: () => lp.fetchLoans(),
                      ),
                    ],
                  ),
                ),
                Expanded(child: content),
              ],
            );
          }

          return content;
        },
      ),
    );
  }

  // Returns body content depending on switcher index
  Widget _buildDynamicBody(LoanModel? loan) {
    switch (_activeSwitcherIndex) {
      case 0:
        return LoanDetailTab(loan: loan, onPayEmiPressed: _showPayEmiBottomSheet);
      case 1:
        return PaymentHistoryTab(loan: loan, onPayEmiPressed: _showPayEmiBottomSheet);
      case 2:
        return const DocumentsTab();
      default:
        return LoanDetailTab(loan: loan, onPayEmiPressed: _showPayEmiBottomSheet);
    }
  }

  // Switcher Tab button helper
  Widget _buildSwitcherTab(BuildContext context, int index, IconData icon, String label) {
    final theme = Theme.of(context);
    final isActive = _activeSwitcherIndex == index;
    return GestureDetector(
      onTap: () {
        setState(() {
          _activeSwitcherIndex = index;
        });
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        decoration: BoxDecoration(
          color: isActive ? theme.colorScheme.primary : Colors.transparent,
          borderRadius: BorderRadius.circular(30),
          border: Border.all(
            color: isActive ? Colors.transparent : AppColors.borderLight,
          ),
        ),
        child: Row(
          children: [
            Icon(
              icon,
              color: isActive ? Colors.white : AppColors.textSecondary,
              size: 16,
            ),
            const SizedBox(width: 8),
            Text(
              label,
              style: GoogleFonts.outfit(
                fontSize: 13,
                fontWeight: FontWeight.bold,
                color: isActive ? Colors.white : AppColors.textSecondary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
