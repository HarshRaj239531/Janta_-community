import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../../../constants/app_colors.dart';
import '../../../models/installment_model.dart';
import '../../../models/agent_model.dart';
import '../../../api/agent_api.dart';
import '../../../api/payment_api.dart';
import '../../../helpers/api_constants.dart';
import '../../../provider/installment_provider.dart';

class PayCommitteeInstallmentBottomSheet extends StatefulWidget {
  final String committeeName;
  final InstallmentModel installment;
  final VoidCallback onPaymentSuccess;

  const PayCommitteeInstallmentBottomSheet({
    super.key,
    required this.committeeName,
    required this.installment,
    required this.onPaymentSuccess,
  });

  static Future<void> show({
    required BuildContext context,
    required String committeeName,
    required InstallmentModel installment,
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
        return PayCommitteeInstallmentBottomSheet(
          committeeName: committeeName,
          installment: installment,
          onPaymentSuccess: onPaymentSuccess,
        );
      },
    );
  }

  @override
  State<PayCommitteeInstallmentBottomSheet> createState() =>
      _PayCommitteeInstallmentBottomSheetState();
}

class _PayCommitteeInstallmentBottomSheetState
    extends State<PayCommitteeInstallmentBottomSheet> {
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

  String _formatCurrency(double amount) {
    final formatter = NumberFormat.currency(
      locale: 'en_IN',
      symbol: '₹',
      decimalDigits: 2,
    );
    return formatter.format(amount);
  }

  String _formatDate(String? dateStr) {
    if (dateStr == null) return 'N/A';
    try {
      final date = DateTime.parse(dateStr);
      return DateFormat('dd MMM, yyyy').format(date);
    } catch (_) {
      return dateStr;
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

    final paid = await ip.payInstallment(
      type: 'committee',
      installmentId: widget.installment.id,
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
            ip.error ?? 'Payment recording failed. Please try again.',
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
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        contentPadding: const EdgeInsets.all(24),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: const BoxDecoration(
                color: Color(0xFFECFDF5),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.check_circle_rounded,
                color: Color(0xFF059669),
                size: 48,
              ),
            ),
            const SizedBox(height: 16),
            Text(
              'Payment Received!',
              style: GoogleFonts.outfit(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              '${_formatCurrency(amount)} for ${widget.committeeName} installment #${widget.installment.id} has been recorded successfully via ${mode.toUpperCase()} ($agentName).',
              textAlign: TextAlign.center,
              style: GoogleFonts.outfit(
                fontSize: 13,
                color: AppColors.textSecondary,
                height: 1.4,
              ),
            ),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              height: 48,
              child: ElevatedButton(
                onPressed: () => Navigator.pop(ctx),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primaryGreen,
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: Text(
                  'Done',
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
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final amount = widget.installment.amount ?? 0.0;
    final dueDateFormatted = _formatDate(widget.installment.dueDate);

    return Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
      ),
      child: Container(
        constraints: BoxConstraints(
          maxHeight: MediaQuery.of(context).size.height * 0.88,
        ),
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisSize: MainAxisSize.min,
            children: [
              // 1. Drag Handle
              Center(
                child: Container(
                  width: 44,
                  height: 4,
                  decoration: BoxDecoration(
                    color: Colors.grey.shade300,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              const SizedBox(height: 16),

              // 2. Title & Close Button
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Pay Committee Installment',
                          style: GoogleFonts.outfit(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: AppColors.textPrimary,
                          ),
                        ),
                        Text(
                          widget.committeeName,
                          style: GoogleFonts.outfit(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            color: AppColors.primaryGreen,
                          ),
                        ),
                      ],
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close, color: AppColors.textMuted),
                    onPressed: () => Navigator.pop(context),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              // 3. Amount & Due Date Highlight Card
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0xFF0F4C3A), Color(0xFF1B6B52)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'INSTALLMENT AMOUNT',
                          style: GoogleFonts.outfit(
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                            color: Colors.white70,
                            letterSpacing: 0.5,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          _formatCurrency(amount),
                          style: GoogleFonts.outfit(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white.withAlpha(26),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text(
                            'DUE DATE',
                            style: GoogleFonts.outfit(
                              fontSize: 9,
                              fontWeight: FontWeight.bold,
                              color: Colors.white70,
                            ),
                          ),
                          Text(
                            dueDateFormatted,
                            style: GoogleFonts.outfit(
                              fontSize: 12,
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
              const SizedBox(height: 20),

              // 4. Payment Mode Selector (Cash to Agent vs UPI QR)
              Text(
                'Select Payment Mode',
                style: GoogleFonts.outfit(
                  fontSize: 13,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary,
                ),
              ),
              const SizedBox(height: 10),
              Row(
                children: [
                  Expanded(
                    child: _buildPaymentModeOption(
                      title: 'Cash to Agent',
                      icon: Icons.person_pin_rounded,
                      modeKey: 'cash',
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _buildPaymentModeOption(
                      title: 'UPI / Dynamic QR',
                      icon: Icons.qr_code_2_rounded,
                      modeKey: 'qr',
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),

              // 5. Agent Selector
              Text(
                'Collection Agent',
                style: GoogleFonts.outfit(
                  fontSize: 13,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary,
                ),
              ),
              const SizedBox(height: 8),
              if (_isLoadingAgents)
                const Center(
                  child: Padding(
                    padding: EdgeInsets.all(12),
                    child: CircularProgressIndicator(strokeWidth: 2),
                  ),
                )
              else
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF9FAFB),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: AppColors.borderMuted),
                  ),
                  child: DropdownButtonHideUnderline(
                    child: DropdownButton<AgentModel>(
                      value: _selectedAgent,
                      isExpanded: true,
                      icon: const Icon(
                        Icons.keyboard_arrow_down_rounded,
                        color: AppColors.primaryGreen,
                      ),
                      items: _agents.map((agent) {
                        return DropdownMenuItem<AgentModel>(
                          value: agent,
                          child: Row(
                            children: [
                              CircleAvatar(
                                radius: 14,
                                backgroundColor: AppColors.primaryGreen.withAlpha(26),
                                child: Text(
                                  agent.name.isNotEmpty
                                      ? agent.name[0].toUpperCase()
                                      : 'A',
                                  style: GoogleFonts.outfit(
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold,
                                    color: AppColors.primaryGreen,
                                  ),
                                ),
                              ),
                              const SizedBox(width: 10),
                              Expanded(
                                child: Text(
                                  agent.name,
                                  style: GoogleFonts.outfit(
                                    fontSize: 13,
                                    fontWeight: FontWeight.w600,
                                    color: AppColors.textPrimary,
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                              if (agent.phone != null && agent.phone!.isNotEmpty)
                                Text(
                                  agent.phone!,
                                  style: GoogleFonts.outfit(
                                    fontSize: 11,
                                    color: AppColors.textMuted,
                                  ),
                                ),
                            ],
                          ),
                        );
                      }).toList(),
                      onChanged: (AgentModel? newVal) {
                        if (newVal != null) {
                          setState(() {
                            _selectedAgent = newVal;
                          });
                        }
                      },
                    ),
                  ),
                ),
              const SizedBox(height: 20),

              // 6. QR Code Section (if 'qr' selected)
              if (_selectedPaymentMode == 'qr') ...[
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF0FDF4),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: const Color(0xFFBBF7D0)),
                  ),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(
                            Icons.qr_code_scanner_rounded,
                            color: Color(0xFF059669),
                            size: 20,
                          ),
                          const SizedBox(width: 8),
                          Text(
                            'Scan & Pay via any UPI App',
                            style: GoogleFonts.outfit(
                              fontSize: 13,
                              fontWeight: FontWeight.bold,
                              color: const Color(0xFF065F46),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      if (_isLoadingQr)
                        const Padding(
                          padding: EdgeInsets.all(20),
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      else if (_qrCodeUrl != null && _qrCodeUrl!.isNotEmpty)
                        Container(
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: Colors.grey.shade200),
                          ),
                          child: Image.network(
                            _qrCodeUrl!,
                            width: 160,
                            height: 160,
                            fit: BoxFit.contain,
                            errorBuilder: (ctx, err, stack) => Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Icon(
                                  Icons.broken_image_rounded,
                                  size: 40,
                                  color: Colors.grey,
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  'QR Unavailable',
                                  style: GoogleFonts.outfit(fontSize: 11),
                                ),
                              ],
                            ),
                          ),
                        ),
                      const SizedBox(height: 10),
                      if (_adminPhone != null && _adminPhone!.isNotEmpty)
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 8,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(color: Colors.grey.shade300),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                'UPI ID / Number: $_adminPhone',
                                style: GoogleFonts.outfit(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w600,
                                  color: AppColors.textPrimary,
                                ),
                              ),
                              const SizedBox(width: 8),
                              GestureDetector(
                                onTap: () {
                                  Clipboard.setData(
                                    ClipboardData(text: _adminPhone!),
                                  );
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text(
                                        'UPI number copied!',
                                        style: GoogleFonts.outfit(),
                                      ),
                                      duration: const Duration(seconds: 1),
                                      behavior: SnackBarBehavior.floating,
                                    ),
                                  );
                                },
                                child: const Icon(
                                  Icons.copy_rounded,
                                  size: 16,
                                  color: AppColors.primaryGreen,
                                ),
                              ),
                            ],
                          ),
                        ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
              ],

              // 7. Confirm & Submit Button
              SizedBox(
                height: 50,
                child: ElevatedButton(
                  onPressed: _isSubmitting ? null : _submitPayment,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primaryGreen,
                    foregroundColor: Colors.white,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: _isSubmitting
                      ? const SizedBox(
                          width: 22,
                          height: 22,
                          child: CircularProgressIndicator(
                            color: Colors.white,
                            strokeWidth: 2,
                          ),
                        )
                      : Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(Icons.check_circle_rounded, size: 18),
                            const SizedBox(width: 8),
                            Text(
                              'Confirm Payment (${_formatCurrency(amount)})',
                              style: GoogleFonts.outfit(
                                fontSize: 15,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPaymentModeOption({
    required String title,
    required IconData icon,
    required String modeKey,
  }) {
    final isSelected = _selectedPaymentMode == modeKey;

    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedPaymentMode = modeKey;
        });
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
        decoration: BoxDecoration(
          color: isSelected
              ? const Color(0xFFECFDF5)
              : const Color(0xFFF9FAFB),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected
                ? AppColors.primaryGreen
                : AppColors.borderMuted,
            width: isSelected ? 1.5 : 1.0,
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              size: 18,
              color: isSelected
                  ? AppColors.primaryGreen
                  : AppColors.textSecondary,
            ),
            const SizedBox(width: 8),
            Text(
              title,
              style: GoogleFonts.outfit(
                fontSize: 12,
                fontWeight: FontWeight.bold,
                color: isSelected
                    ? AppColors.primaryGreen
                    : AppColors.textSecondary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
