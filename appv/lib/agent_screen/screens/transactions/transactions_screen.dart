import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../../constants/agent_colors.dart';
import '../../widgets/transactions/customer_selector.dart';
import '../../widgets/transactions/amount_input.dart';
import '../../widgets/transactions/outstanding_card.dart';
import '../../widgets/transactions/payment_notes.dart';
import '../../widgets/transactions/verification_box.dart';
import '../../provider/agent_provider.dart';
import '../../models/agent_search_member_model.dart';

class TransactionsScreen extends StatefulWidget {
  const TransactionsScreen({super.key});

  @override
  State<TransactionsScreen> createState() => _TransactionsScreenState();
}

class _TransactionsScreenState extends State<TransactionsScreen> {
  AgentSearchMemberModel? _selectedMember;
  
  // Selected single installment to pay
  String? _collectionType; // 'committee' or 'loan'
  int? _selectedInstallmentId;
  double _outstandingAmount = 0.0;
  String _selectedInstallmentLabel = 'Select Pending Installment';

  final _amountController = TextEditingController();
  final _notesController = TextEditingController();

  @override
  void dispose() {
    _amountController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  void _handleMemberSelected(AgentSearchMemberModel member) {
    setState(() {
      _selectedMember = member;
      
      // Calculate overall outstanding
      double totalOutstanding = 0.0;
      for (var inst in member.installments) {
        totalOutstanding += inst.amount;
      }
      for (var loan in member.loans) {
        for (var emi in loan.installments) {
          totalOutstanding += emi.amountToPay;
        }
      }
      _outstandingAmount = totalOutstanding;

      // Reset selection details
      _collectionType = null;
      _selectedInstallmentId = null;
      _selectedInstallmentLabel = 'Select Pending Installment';
      _amountController.clear();
    });
  }

  void _handleIncrementAmount(double increment) {
    double currentVal = double.tryParse(_amountController.text) ?? 0.0;
    setState(() {
      _amountController.text = (currentVal + increment).toStringAsFixed(2);
    });
  }

  Future<void> _submitTransaction() async {
    if (_selectedMember == null) {
      _showSnackbar('Please select a customer first.', AgentColors.errorAccent);
      return;
    }

    if (_collectionType == null || _selectedInstallmentId == null) {
      _showSnackbar('Please select a specific pending installment to collect.', AgentColors.errorAccent);
      return;
    }

    final double enteredAmount = double.tryParse(_amountController.text) ?? 0.0;
    if (enteredAmount <= 0) {
      _showSnackbar('Please enter a valid amount received.', AgentColors.errorAccent);
      return;
    }

    final agentProvider = Provider.of<AgentProvider>(context, listen: false);

    // Call submit collection API
    final success = await agentProvider.submitCollection(
      type: _collectionType!,
      installmentId: _selectedInstallmentId!,
      amount: enteredAmount,
      notes: _notesController.text,
    );

    if (!mounted) return;

    if (success) {
      // Refresh dashboard statistics
      agentProvider.fetchDashboard();
      
      // Success dialog
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
            title: Row(
              children: [
                const Icon(Icons.check_circle_outline_rounded, color: AgentColors.successGreen, size: 28),
                const SizedBox(width: 8),
                Text(
                  'Success',
                  style: GoogleFonts.outfit(fontWeight: FontWeight.bold, color: AgentColors.primaryGreen),
                ),
              ],
            ),
            content: Text(
              'Transaction submitted successfully for Admin approval.\n\n'
              'Customer: ${_selectedMember!.name}\n'
              'Installment: $_selectedInstallmentLabel\n'
              'Amount: ₹${enteredAmount.toStringAsFixed(2)}\n'
              'Notes: ${_notesController.text.isEmpty ? "None" : _notesController.text}',
              style: GoogleFonts.outfit(fontSize: 15),
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                  _resetForm();
                },
                child: Text(
                  'OK',
                  style: GoogleFonts.outfit(fontWeight: FontWeight.bold, color: AgentColors.primaryGreen),
                ),
              ),
            ],
          );
        },
      );
    } else {
      _showSnackbar(agentProvider.submitError ?? 'Submission failed. Please try again.', AgentColors.errorAccent);
    }
  }

  void _resetForm() {
    setState(() {
      _amountController.clear();
      _notesController.clear();
      _selectedMember = null;
      _collectionType = null;
      _selectedInstallmentId = null;
      _outstandingAmount = 0.0;
      _selectedInstallmentLabel = 'Select Pending Installment';
    });
  }

  void _showSnackbar(String msg, Color color) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: color,
        content: Text(
          msg,
          style: GoogleFonts.outfit(color: Colors.white, fontWeight: FontWeight.w600),
        ),
      ),
    );
  }

  void _showInstallmentPicker() {
    if (_selectedMember == null) {
      _showSnackbar('Please select a customer first.', AgentColors.errorAccent);
      return;
    }

    final List<Map<String, dynamic>> items = [];

    // Add committee installments
    for (var inst in _selectedMember!.installments) {
      items.add({
        'type': 'committee',
        'id': inst.id,
        'amount': inst.amount,
        'label': '${inst.committeeName} - Installment #${inst.installmentNumber} (₹${inst.amount.toStringAsFixed(0)})',
      });
    }

    // Add loan installments
    for (var loan in _selectedMember!.loans) {
      for (var emi in loan.installments) {
        items.add({
          'type': 'loan',
          'id': emi.id,
          'amount': emi.amountToPay,
          'label': 'Loan #${loan.id} - EMI #${emi.installmentNumber} (₹${emi.amountToPay.toStringAsFixed(0)})',
        });
      }
    }

    if (items.isEmpty) {
      _showSnackbar('No pending installments found for this customer.', AgentColors.textSecondary);
      return;
    }

    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) {
        return Container(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                'Select Installment to Collect',
                style: GoogleFonts.outfit(fontSize: 18, fontWeight: FontWeight.bold, color: AgentColors.primaryGreen),
              ),
              const SizedBox(height: 16),
              Expanded(
                child: ListView.separated(
                  itemCount: items.length,
                  separatorBuilder: (context, index) => const Divider(color: AgentColors.borderMuted),
                  itemBuilder: (context, index) {
                    final item = items[index];
                    return ListTile(
                      title: Text(item['label'] as String, style: GoogleFonts.outfit(fontWeight: FontWeight.w600)),
                      trailing: const Icon(Icons.chevron_right, color: AgentColors.primaryGreen),
                      onTap: () {
                        setState(() {
                          _collectionType = item['type'] as String;
                          _selectedInstallmentId = item['id'] as int;
                          _selectedInstallmentLabel = item['label'] as String;
                          _amountController.text = (item['amount'] as double).toStringAsFixed(2);
                        });
                        Navigator.pop(context);
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final agentProvider = Provider.of<AgentProvider>(context);

    return Scaffold(
      backgroundColor: AgentColors.backgroundSoft,
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // 1. Customer Selector Widget
              CustomerSelector(
                selectedMember: _selectedMember,
                onMemberSelected: _handleMemberSelected,
              ),
              const SizedBox(height: 16),

              // Specific Installment Selector Trigger
              if (_selectedMember != null) ...[
                GestureDetector(
                  onTap: _showInstallmentPicker,
                  child: Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: AgentColors.borderMuted, width: 1),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withAlpha(5),
                          blurRadius: 10,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Text(
                            _selectedInstallmentLabel,
                            style: GoogleFonts.outfit(
                              fontSize: 15,
                              fontWeight: _selectedInstallmentId != null ? FontWeight.w600 : FontWeight.normal,
                              color: _selectedInstallmentId != null ? AgentColors.textPrimary : AgentColors.textMuted,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        const Icon(Icons.arrow_drop_down, color: AgentColors.primaryGreen),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 16),
              ],

              // 2. Amount Received Widget
              AmountInput(
                controller: _amountController,
                onIncrementPressed: _handleIncrementAmount,
              ),
              const SizedBox(height: 16),

              // 3. Outstanding Card Widget
              OutstandingCard(
                outstandingAmount: _outstandingAmount,
                customerId: _selectedMember != null ? '#MEM-${_selectedMember!.id}' : 'None selected',
              ),
              const SizedBox(height: 16),

              // 4. Payment Notes Widget
              PaymentNotes(
                controller: _notesController,
              ),
              const SizedBox(height: 16),

              // 5. Counting physical cash alert box
              const VerificationBox(),
              const SizedBox(height: 24),

              // 6. Submit Button Container
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: agentProvider.isSubmitting ? null : _submitTransaction,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AgentColors.primaryGreen,
                    foregroundColor: Colors.white,
                    elevation: 4,
                    shadowColor: AgentColors.primaryDark.withAlpha(50),
                    padding: const EdgeInsets.symmetric(vertical: 18),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                  child: agentProvider.isSubmitting
                      ? const SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2),
                        )
                      : Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(
                              Icons.send_rounded,
                              color: Colors.white,
                              size: 20,
                            ),
                            const SizedBox(width: 8),
                            Text(
                              'Submit to Admin for Approval',
                              style: GoogleFonts.outfit(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                ),
              ),
              const SizedBox(height: 12),

              // 7. Footer subtext
              Text(
                'Transactions recorded are subject to reconciliation.',
                textAlign: TextAlign.center,
                style: GoogleFonts.outfit(
                  fontSize: 12,
                  color: AgentColors.textSecondary,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }
}
