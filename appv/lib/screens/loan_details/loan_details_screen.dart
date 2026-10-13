import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../../constants/app_colors.dart';
import '../../provider/loan_provider.dart';
import '../../provider/profile_provider.dart';
import '../../models/loan_model.dart';
import '../home/home_screen.dart';
import 'widgets/loan_detail_tab.dart';
import 'widgets/payment_history_tab.dart';
import 'widgets/documents_tab.dart';
import 'widgets/basic_details_tab.dart';
import 'widgets/apply_loan_bottom_sheet.dart';
import 'widgets/pay_emi_bottom_sheet.dart';
import '../../services/local_notification_service.dart';

class LoanDetailsScreen extends StatefulWidget {
  const LoanDetailsScreen({super.key});

  @override
  State<LoanDetailsScreen> createState() => _LoanDetailsScreenState();
}

class _LoanDetailsScreenState extends State<LoanDetailsScreen> {
  int _activeSwitcherIndex = 0; // 0: Loan Detail, 1: Payment History, 2: Documents, 3: Basic Details

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final lp = Provider.of<LoanProvider>(context, listen: false);
      await lp.fetchLoans();
      await lp.fetchLoanRequests();
      if (mounted) {
        if (lp.loans.isNotEmpty) {
          final activeLoan = lp.loans.firstWhere(
            (l) => l.status == 'active',
            orElse: () => lp.loans.first,
          );
          await lp.fetchLoanDetails(activeLoan.id);
          if (mounted && lp.selectedLoan?.installments != null) {
            LocalNotificationService.scheduleLoanReminders(lp.selectedLoan!.installments!);
          }
        }
      }
      if (mounted) {
        Provider.of<ProfileProvider>(context, listen: false).fetchVault();
      }
    });
  }

  void _showPayEmiBottomSheet() {
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

    // Find pending installments
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

    // Sort chronologically by due date, then by ID
    pendingInstallments.sort((a, b) {
      final aDate = a.dueDate ?? '';
      final bDate = b.dueDate ?? '';
      final dateComp = aDate.compareTo(bDate);
      if (dateComp != 0) return dateComp;
      return a.id.compareTo(b.id);
    });

    final nextInstallment = pendingInstallments.first;

    PayEmiBottomSheet.show(
      context: context,
      loan: loan,
      installment: nextInstallment,
      pendingInstallments: pendingInstallments,
      onPaymentSuccess: () async {
        await loanProvider.fetchLoans();
        await loanProvider.fetchLoanDetails(loan.id);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      backgroundColor: Colors.transparent,
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
          Padding(
            padding: const EdgeInsets.only(right: 12.0),
            child: TextButton.icon(
              onPressed: () => ApplyLoanBottomSheet.show(context),
              icon: const Icon(Icons.add_circle_outline_rounded, size: 16, color: AppColors.primaryGreen),
              label: Text(
                'Apply Loan',
                style: GoogleFonts.outfit(
                  fontWeight: FontWeight.bold,
                  color: AppColors.primaryGreen,
                  fontSize: 12,
                ),
              ),
              style: TextButton.styleFrom(
                backgroundColor: AppColors.primaryGreen.withAlpha(20),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              ),
            ),
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

          final content = Stack(
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
                          const SizedBox(width: 8),
                          _buildSwitcherTab(context, 3, Icons.info_outline_rounded, 'Basic Details'),
                        ],
                      ),
                    ),
                  ),

                  // 2. Dynamic Content Body
                  Expanded(
                    child: SingleChildScrollView(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                      child: _buildDynamicBody(loan, loans.isEmpty),
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
  Widget _buildDynamicBody(LoanModel? loan, bool showBlank) {
    switch (_activeSwitcherIndex) {
      case 0:
        return LoanDetailTab(
          loan: loan,
          onPayEmiPressed: _showPayEmiBottomSheet,
          showBlank: showBlank,
        );
      case 1:
        return PaymentHistoryTab(
          loan: loan,
          onPayEmiPressed: _showPayEmiBottomSheet,
          showBlank: showBlank,
        );
      case 2:
        return const DocumentsTab();
      case 3:
        return const BasicDetailsTab();
      default:
        return LoanDetailTab(
          loan: loan,
          onPayEmiPressed: _showPayEmiBottomSheet,
          showBlank: showBlank,
        );
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
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        curve: Curves.easeInOut,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        decoration: BoxDecoration(
          color: isActive ? theme.colorScheme.primary : Colors.white,
          borderRadius: BorderRadius.circular(30),
          border: Border.all(
            color: isActive ? Colors.transparent : AppColors.borderLight,
          ),
          boxShadow: [
            if (!isActive)
              BoxShadow(
                color: Colors.black.withAlpha(5),
                blurRadius: 4,
                offset: const Offset(0, 2),
              ),
          ],
        ),
        child: Row(
          children: [
            Icon(
              icon,
              color: isActive ? Colors.white : AppColors.textSecondary,
              size: 16,
            ),
            const SizedBox(width: 8),
            AnimatedDefaultTextStyle(
              duration: const Duration(milliseconds: 200),
              curve: Curves.easeInOut,
              style: GoogleFonts.outfit(
                fontSize: 13,
                fontWeight: FontWeight.bold,
                color: isActive ? Colors.white : AppColors.textSecondary,
              ),
              child: Text(label),
            ),
          ],
        ),
      ),
    );
  }
}
