import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../../../constants/app_colors.dart';
import '../../../models/loan_model.dart';
import '../../../models/installment_model.dart';
import '../../../models/agent_model.dart';
import '../../../api/agent_api.dart';
import '../../../api/payment_api.dart';
import '../../../helpers/api_constants.dart';
import '../../../provider/installment_provider.dart';

class PayEmiBottomSheet extends StatefulWidget {
  final LoanModel loan;
  final InstallmentModel installment;
  final List<InstallmentModel> pendingInstallments;
  final VoidCallback onPaymentSuccess;

  const PayEmiBottomSheet({
    super.key,
    required this.loan,
    required this.installment,
    required this.pendingInstallments,
    required this.onPaymentSuccess,
  });

  static Future<void> show({
    required BuildContext context,
    required LoanModel loan,
    required InstallmentModel installment,
    required List<InstallmentModel> pendingInstallments,
    required VoidCallback onPaymentSuccess,
  }) {
    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) {
        return PayEmiBottomSheet(
          loan: loan,
          installment: installment,
          pendingInstallments: pendingInstallments,
          onPaymentSuccess: onPaymentSuccess,
        );
      },
    );
  }

  @override
  State<PayEmiBottomSheet> createState() => _PayEmiBottomSheetState();
}

class _PayEmiBottomSheetState extends State<PayEmiBottomSheet> {
  bool _isLoadingAgents = true;
  List<AgentModel> _agents = [];
  AgentModel? _selectedAgent;

  // Payment mode: 'cash' or 'qr'
  String _selectedPaymentMode = 'cash';
  bool _isSubmitting = false;

  // QR Details
  String? _qrCodeUrl;
  String? _adminPhone;
  bool _isLoadingQr = true;

  @override
  void initState() {
    super.initState();
    _loadInitialData();
  }

  Future<void> _loadInitialData() async {
    // 1. Fetch Agents
    try {
      final fetchedAgents = await AgentApi.getAgents();
      if (mounted) {
        setState(() {
          if (fetchedAgents.isNotEmpty) {
            _agents = fetchedAgents;
            _selectedAgent = _agents.first;
          } else {
            // Fallback default representative
            _agents = [
              AgentModel(
                id: 1,
                name: 'Head Office Collector',
                phone: ApiConstants.supportPhone,
              ),
            ];
            _selectedAgent = _agents.first;
          }
          _isLoadingAgents = false;
        });
      }
    } catch (_) {
      if (mounted) {
        setState(() {
          _agents = [
            AgentModel(
              id: 1,
              name: 'Head Office Collector',
              phone: ApiConstants.supportPhone,
            ),
          ];
          _selectedAgent = _agents.first;
          _isLoadingAgents = false;
        });
      }
    }

    // 2. Fetch Payment QR Settings
    try {
      final settings = await PaymentApi.fetchPaymentSetting();
      if (mounted) {
        setState(() {
          _qrCodeUrl = ApiConstants.resolveImageUrl(settings['qr_code']);
          _adminPhone = settings['admin_phone']?.toString().trim();
          if (_adminPhone == null || _adminPhone!.isEmpty) {
            _adminPhone = ApiConstants.supportPhone;
          }
          _isLoadingQr = false;
        });
      }
    } catch (_) {
      if (mounted) {
        setState(() {
          _adminPhone = ApiConstants.supportPhone;
          _isLoadingQr = false;
        });
      }
    }
  }

  void _submitPayment() async {
    if (_selectedAgent == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Please select an agent to proceed',
            style: GoogleFonts.outfit(),
          ),
          backgroundColor: AppColors.errorAccent,
        ),
      );
      return;
    }

    setState(() {
      _isSubmitting = true;
    });

    final ip = Provider.of<InstallmentProvider>(context, listen: false);
    final installmentId = widget.installment.id > 0
        ? widget.installment.id
        : widget.loan.id;

    final paid = await ip.payInstallment(
      type: 'loan',
      installmentId: installmentId,
      amount: widget.installment.amount ?? 0,
      agentId: _selectedAgent?.id,
      paymentMode: _selectedPaymentMode,
    );

    if (!mounted) return;

    if (paid) {
      Navigator.pop(context); // Close bottom sheet
      widget.onPaymentSuccess();
      _showSuccessDialog(
        amount: widget.installment.amount ?? 0,
        mode: _selectedPaymentMode,
        agentName: _selectedAgent?.name ?? 'Assigned Agent',
      );
    } else {
      setState(() {
        _isSubmitting = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            ip.error ?? 'Payment submission failed. Please try again.',
            style: GoogleFonts.outfit(),
          ),
          backgroundColor: AppColors.errorAccent,
        ),
      );
    }
  }

  void _showSuccessDialog({
    required double amount,
    required String mode,
    required String agentName,
  }) {
    final theme = Theme.of(context);
    final formatter = NumberFormat.currency(
      locale: 'en_IN',
      symbol: '₹',
      decimalDigits: 2,
    );

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
                  fontSize: 18,
                ),
              ),
            ],
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Your monthly EMI payment of ${formatter.format(amount)} has been recorded successfully.',
                style: GoogleFonts.outfit(fontSize: 13, color: AppColors.textSecondary),
              ),
              const SizedBox(height: 16),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: AppColors.lavenderSoft,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: AppColors.borderLight),
                ),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Payment Mode:',
                          style: GoogleFonts.outfit(fontSize: 12, color: AppColors.textSecondary),
                        ),
                        Text(
                          mode == 'qr' ? 'UPI QR Code' : 'Cash In-Hand',
                          style: GoogleFonts.outfit(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            color: AppColors.textPrimary,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Collection Agent:',
                          style: GoogleFonts.outfit(fontSize: 12, color: AppColors.textSecondary),
                        ),
                        Text(
                          agentName,
                          style: GoogleFonts.outfit(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            color: theme.colorScheme.primary,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text(
                'Done',
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
    final amountFormatter = NumberFormat.currency(
      locale: 'en_IN',
      symbol: '₹',
      decimalDigits: 2,
    );

    final totalPendingAmount = widget.pendingInstallments.fold<double>(
      0.0,
      (sum, item) => sum + (item.amount ?? 0.0),
    );
    final remainingAfterPayment = totalPendingAmount - (widget.installment.amount ?? 0.0);

    String dueDateText = 'N/A';
    if (widget.installment.dueDate != null) {
      try {
        dueDateText = DateFormat('dd MMM, yyyy').format(
          DateTime.parse(widget.installment.dueDate!),
        );
      } catch (_) {
        dueDateText = widget.installment.dueDate!;
      }
    }

    return ConstrainedBox(
      constraints: BoxConstraints(
        maxHeight: MediaQuery.of(context).size.height * 0.9,
      ),
      child: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.only(
            left: 20.0,
            right: 20.0,
            top: 16.0,
            bottom: MediaQuery.of(context).viewInsets.bottom + 20.0,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // 1. Drag bar
              Center(
                child: Container(
                  width: 48,
                  height: 5,
                  decoration: BoxDecoration(
                    color: Colors.grey.shade300,
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
              const SizedBox(height: 16),

              // 2. Header
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
                      size: 22,
                    ),
                  ),
                  const SizedBox(width: 14),
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
                          'Loan Ref #${widget.loan.id} • Due $dueDateText',
                          style: GoogleFonts.outfit(
                            fontSize: 12,
                            color: AppColors.textSecondary,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                  IconButton(
                    onPressed: () => Navigator.pop(context),
                    icon: const Icon(Icons.close_rounded, color: AppColors.textMuted),
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              // 3. EMI Amount Highlight Card
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0xFF0F4C3A), Color(0xFF1E3A2F)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xFF0F4C3A).withValues(alpha: 0.25),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    )
                  ],
                ),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'EMI Installment',
                          style: GoogleFonts.outfit(
                            fontSize: 12,
                            color: Colors.white70,
                          ),
                        ),
                        Text(
                          '#${widget.loan.paidCount + 1} of ${widget.loan.installments?.length ?? widget.loan.duration ?? 0}',
                          style: GoogleFonts.outfit(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    const Divider(color: Colors.white24, height: 1),
                    const SizedBox(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Amount Due',
                          style: GoogleFonts.outfit(
                            fontSize: 13,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        Text(
                          amountFormatter.format(widget.installment.amount ?? 0),
                          style: GoogleFonts.outfit(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                            color: const Color(0xFF68D391),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.08),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Remaining Balance Later',
                            style: GoogleFonts.outfit(
                              fontSize: 11,
                              color: Colors.white70,
                            ),
                          ),
                          Text(
                            amountFormatter.format(remainingAfterPayment),
                            style: GoogleFonts.outfit(
                              fontSize: 11,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 18),

              // 4. STEP 1: Select Field Agent
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(6),
                        decoration: BoxDecoration(
                          color: theme.colorScheme.primary.withAlpha(20),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Icon(
                          Icons.person_pin_circle_rounded,
                          color: theme.colorScheme.primary,
                          size: 16,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        '1. Select Collection Agent',
                        style: GoogleFonts.outfit(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: AppColors.textPrimary,
                        ),
                      ),
                    ],
                  ),
                  Text(
                    'Required',
                    style: GoogleFonts.outfit(
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                      color: theme.colorScheme.primary,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),

              if (_isLoadingAgents)
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: AppColors.lavenderSoft,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: AppColors.borderLight),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const SizedBox(
                        width: 16,
                        height: 16,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      ),
                      const SizedBox(width: 10),
                      Text(
                        'Loading available agents...',
                        style: GoogleFonts.outfit(
                          fontSize: 12,
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ],
                  ),
                )
              else
                _buildAgentDropdown(),
              const SizedBox(height: 18),

              // 5. STEP 2: Choose Payment Mode
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(6),
                    decoration: BoxDecoration(
                      color: theme.colorScheme.primary.withAlpha(20),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Icon(
                      Icons.account_balance_wallet_rounded,
                      color: theme.colorScheme.primary,
                      size: 16,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    '2. Select Payment Method',
                    style: GoogleFonts.outfit(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textPrimary,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),

              // Payment Mode Selection Cards (Cash vs QR)
              Row(
                children: [
                  Expanded(
                    child: _buildPaymentModeCard(
                      mode: 'cash',
                      title: 'Cash In-Hand',
                      subtitle: 'Pay cash to agent',
                      icon: Icons.payments_outlined,
                      isSelected: _selectedPaymentMode == 'cash',
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _buildPaymentModeCard(
                      mode: 'qr',
                      title: 'QR Code / UPI',
                      subtitle: 'Instant online scan',
                      icon: Icons.qr_code_2_rounded,
                      isSelected: _selectedPaymentMode == 'qr',
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 14),

              // 6. Contextual Section (Based on chosen mode)
              if (_selectedPaymentMode == 'cash')
                _buildCashModeDetails()
              else
                _buildQrModeDetails(),

              const SizedBox(height: 20),

              // 7. Action Buttons
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: _isSubmitting ? null : () => Navigator.pop(context),
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
                    flex: 2,
                    child: ElevatedButton(
                      onPressed: _isSubmitting ? null : _submitPayment,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: theme.colorScheme.primary,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: _isSubmitting
                          ? const SizedBox(
                              width: 20,
                              height: 20,
                              child: CircularProgressIndicator(
                                color: Colors.white,
                                strokeWidth: 2,
                              ),
                            )
                          : Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  _selectedPaymentMode == 'cash'
                                      ? Icons.check_circle_rounded
                                      : Icons.qr_code_scanner_rounded,
                                  color: Colors.white,
                                  size: 18,
                                ),
                                const SizedBox(width: 8),
                                Text(
                                  _selectedPaymentMode == 'cash'
                                      ? 'Submit Cash Payment'
                                      : 'Confirm & Pay QR',
                                  style: GoogleFonts.outfit(
                                    fontSize: 15,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                ),
                              ],
                            ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  // --- WIDGET: Agent Dropdown Selector ---
  Widget _buildAgentDropdown() {
    final theme = Theme.of(context);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.borderLight, width: 1.5),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(5),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<AgentModel>(
          value: _selectedAgent,
          isExpanded: true,
          icon: Icon(Icons.arrow_drop_down_rounded, color: theme.colorScheme.primary, size: 28),
          items: _agents.map((agent) {
            final isCurrent = _selectedAgent?.id == agent.id;
            return DropdownMenuItem<AgentModel>(
              value: agent,
              child: Row(
                children: [
                  Container(
                    width: 36,
                    height: 36,
                    decoration: BoxDecoration(
                      color: isCurrent
                          ? theme.colorScheme.primary
                          : theme.colorScheme.primary.withAlpha(20),
                      shape: BoxShape.circle,
                    ),
                    alignment: Alignment.center,
                    child: Text(
                      agent.name.isNotEmpty ? agent.name[0].toUpperCase() : 'A',
                      style: GoogleFonts.outfit(
                        fontWeight: FontWeight.bold,
                        color: isCurrent ? Colors.white : theme.colorScheme.primary,
                        fontSize: 14,
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          agent.name,
                          style: GoogleFonts.outfit(
                            fontSize: 13,
                            fontWeight: FontWeight.bold,
                            color: AppColors.textPrimary,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                        if (agent.phone != null && agent.phone!.isNotEmpty)
                          Text(
                            agent.phone!,
                            style: GoogleFonts.outfit(
                              fontSize: 11,
                              color: AppColors.textSecondary,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                      ],
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                    decoration: BoxDecoration(
                      color: AppColors.successLight,
                      borderRadius: BorderRadius.circular(4),
                      border: Border.all(color: AppColors.successGreen.withAlpha(40)),
                    ),
                    child: Text(
                      'AGENT',
                      style: GoogleFonts.outfit(
                        fontSize: 9,
                        fontWeight: FontWeight.bold,
                        color: AppColors.successDark,
                      ),
                    ),
                  ),
                ],
              ),
            );
          }).toList(),
          onChanged: (newAgent) {
            if (newAgent != null) {
              setState(() {
                _selectedAgent = newAgent;
              });
            }
          },
        ),
      ),
    );
  }

  // --- WIDGET: Payment Mode Tile ---
  Widget _buildPaymentModeCard({
    required String mode,
    required String title,
    required String subtitle,
    required IconData icon,
    required bool isSelected,
  }) {
    final theme = Theme.of(context);
    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedPaymentMode = mode;
        });
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: isSelected
              ? theme.colorScheme.primary.withAlpha(15)
              : Colors.white,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: isSelected ? theme.colorScheme.primary : AppColors.borderLight,
            width: isSelected ? 2 : 1,
          ),
          boxShadow: [
            if (isSelected)
              BoxShadow(
                color: theme.colorScheme.primary.withAlpha(25),
                blurRadius: 8,
                offset: const Offset(0, 3),
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
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: isSelected
                        ? theme.colorScheme.primary
                        : AppColors.lavenderSoft,
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    icon,
                    size: 18,
                    color: isSelected ? Colors.white : AppColors.textSecondary,
                  ),
                ),
                Icon(
                  isSelected ? Icons.check_circle_rounded : Icons.radio_button_off_rounded,
                  color: isSelected ? theme.colorScheme.primary : AppColors.borderLight,
                  size: 20,
                ),
              ],
            ),
            const SizedBox(height: 10),
            Text(
              title,
              style: GoogleFonts.outfit(
                fontSize: 13,
                fontWeight: FontWeight.bold,
                color: isSelected ? theme.colorScheme.primary : AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: 2),
            Text(
              subtitle,
              style: GoogleFonts.outfit(
                fontSize: 10,
                color: AppColors.textSecondary,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // --- WIDGET: Cash Mode Details Box ---
  Widget _buildCashModeDetails() {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: const Color(0xFFECFDF5), // light green
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: const Color(0xFFA7F3D0)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(
            Icons.verified_user_rounded,
            color: Color(0xFF059669),
            size: 22,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'In-Hand Cash Collection',
                  style: GoogleFonts.outfit(
                    fontSize: 13,
                    fontWeight: FontWeight.bold,
                    color: const Color(0xFF065F46),
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Please hand over the exact EMI amount to Agent "${_selectedAgent?.name ?? 'Assigned Agent'}". Upon submitting, your payment is registered immediately with official verification.',
                  style: GoogleFonts.outfit(
                    fontSize: 11,
                    color: const Color(0xFF047857),
                    height: 1.4,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // --- WIDGET: QR Mode Details Box ---
  Widget _buildQrModeDetails() {
    final theme = Theme.of(context);
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.borderLight),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(4),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            children: [
              Icon(Icons.qr_code_scanner_rounded, color: theme.colorScheme.primary, size: 20),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  'Scan Official QR Code with any UPI App',
                  style: GoogleFonts.outfit(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textPrimary,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          if (_isLoadingQr)
            const Padding(
              padding: EdgeInsets.all(20.0),
              child: Center(child: CircularProgressIndicator(strokeWidth: 2)),
            )
          else if (_qrCodeUrl != null && _qrCodeUrl!.isNotEmpty)
            Center(
              child: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: AppColors.borderLight),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Image.network(
                    _qrCodeUrl!,
                    width: 170,
                    height: 170,
                    fit: BoxFit.contain,
                    errorBuilder: (context, error, stackTrace) {
                      return _buildQrFallback();
                    },
                  ),
                ),
              ),
            )
          else
            _buildQrFallback(),
          const SizedBox(height: 10),
          Text(
            'Supported: Google Pay • PhonePe • Paytm • BHIM',
            style: GoogleFonts.outfit(
              fontSize: 10,
              fontWeight: FontWeight.w600,
              color: AppColors.textSecondary,
            ),
          ),
          if (_adminPhone != null && _adminPhone!.isNotEmpty) ...[
            const SizedBox(height: 4),
            Text(
              'Helpline / UPI ID contact: $_adminPhone',
              style: GoogleFonts.outfit(
                fontSize: 10,
                color: theme.colorScheme.primary,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildQrFallback() {
    return Container(
      width: 170,
      height: 170,
      decoration: BoxDecoration(
        color: AppColors.backgroundAlt,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.borderLight),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.qr_code_2_rounded, size: 54, color: AppColors.textMuted),
          const SizedBox(height: 8),
          Text(
            'UPI QR Code Ready',
            style: GoogleFonts.outfit(
              fontSize: 11,
              fontWeight: FontWeight.bold,
              color: AppColors.textPrimary,
            ),
          ),
          Text(
            'Contact admin for direct UPI',
            style: GoogleFonts.outfit(fontSize: 9, color: AppColors.textSecondary),
          ),
        ],
      ),
    );
  }
}
