import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../../constants/app_colors.dart';
import '../../provider/installment_provider.dart';
import '../../models/installment_model.dart';

class InstallmentHistoryScreen extends StatefulWidget {
  const InstallmentHistoryScreen({super.key});

  @override
  State<InstallmentHistoryScreen> createState() => _InstallmentHistoryScreenState();
}

class _InstallmentHistoryScreenState extends State<InstallmentHistoryScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final ip = Provider.of<InstallmentProvider>(context, listen: false);
      ip.fetchPending();
      ip.fetchPaid();
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
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
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Installment History',
          style: GoogleFonts.outfit(
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        backgroundColor: const Color(0xFF0F4C3A),
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
        bottom: TabBar(
          controller: _tabController,
          labelColor: Colors.white,
          unselectedLabelColor: Colors.white70,
          indicatorColor: Colors.white,
          indicatorWeight: 3,
          labelStyle: GoogleFonts.outfit(fontWeight: FontWeight.bold),
          unselectedLabelStyle: GoogleFonts.outfit(fontWeight: FontWeight.normal),
          tabs: const [
            Tab(text: 'All'),
            Tab(text: 'Paid'),
            Tab(text: 'Pending'),
          ],
        ),
      ),
      body: Consumer<InstallmentProvider>(
        builder: (context, ip, child) {
          if (ip.isLoading && ip.allPending.isEmpty && ip.allPaid.isEmpty) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          final allPending = ip.allPending;
          final allPaid = ip.allPaid;
          final allList = [...allPaid, ...allPending];

          // Sort by date
          allPaid.sort((a, b) => (b.paidDate ?? '').compareTo(a.paidDate ?? ''));
          allPending.sort((a, b) => (a.dueDate ?? '').compareTo(b.dueDate ?? ''));
          allList.sort((a, b) {
            final dateA = a.paidDate ?? a.dueDate ?? '';
            final dateB = b.paidDate ?? b.dueDate ?? '';
            return dateB.compareTo(dateA);
          });

          return TabBarView(
            controller: _tabController,
            children: [
              _buildList(allList),
              _buildList(allPaid),
              _buildList(allPending),
            ],
          );
        },
      ),
    );
  }

  Widget _buildList(List<InstallmentModel> items) {
    if (items.isEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(40),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(
                Icons.history_toggle_off_rounded,
                size: 64,
                color: AppColors.textMuted,
              ),
              const SizedBox(height: 16),
              Text(
                'No installments found',
                style: GoogleFonts.outfit(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textSecondary,
                ),
              ),
            ],
          ),
        ),
      );
    }

    return ListView.separated(
      padding: const EdgeInsets.all(16),
      itemCount: items.length,
      separatorBuilder: (context, index) => const SizedBox(height: 12),
      itemBuilder: (context, index) {
        final item = items[index];
        final isPaid = item.isPaid;

        return Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: AppColors.borderMuted),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withAlpha(5),
                blurRadius: 10,
                offset: const Offset(0, 4),
              )
            ],
          ),
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: isPaid
                      ? AppColors.successGreen.withAlpha(20)
                      : AppColors.errorAccent.withAlpha(20),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  isPaid ? Icons.check_circle_rounded : Icons.pending_rounded,
                  color: isPaid ? AppColors.successDark : AppColors.errorDark,
                  size: 24,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      item.loanId != null ? item.loanLabel : item.committeeName,
                      style: GoogleFonts.outfit(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: AppColors.textDark,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      isPaid
                          ? 'Paid on ${_formatDate(item.paidDate)}'
                          : 'Due by ${_formatDate(item.dueDate)}',
                      style: GoogleFonts.outfit(
                        fontSize: 12,
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 16),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    _formatCurrency(item.amount ?? 0.0),
                    style: GoogleFonts.outfit(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textDark,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: isPaid
                          ? AppColors.successGreen.withAlpha(20)
                          : AppColors.errorAccent.withAlpha(20),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      item.status?.toUpperCase() ?? 'PENDING',
                      style: GoogleFonts.outfit(
                        fontSize: 9,
                        fontWeight: FontWeight.bold,
                        color: isPaid ? AppColors.successDark : AppColors.errorDark,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}
