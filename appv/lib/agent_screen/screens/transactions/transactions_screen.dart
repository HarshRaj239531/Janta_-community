import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../constants/agent_colors.dart';
import '../../widgets/transactions/customer_selector.dart';
import '../../widgets/transactions/amount_input.dart';
import '../../widgets/transactions/outstanding_card.dart';
import '../../widgets/transactions/payment_notes.dart';
import '../../widgets/transactions/verification_box.dart';

class TransactionsScreen extends StatefulWidget {
  const TransactionsScreen({super.key});

  @override
  State<TransactionsScreen> createState() => _TransactionsScreenState();
}

class _TransactionsScreenState extends State<TransactionsScreen> {
  // State variables matching the screenshot defaults
  String? _selectedCustomerName = 'Arjun Mehta';
  String _selectedCustomerId = 'FT-8829';
  double _outstandingAmount = 14250.00;

  final _amountController = TextEditingController();
  final _notesController = TextEditingController();

  @override
  void dispose() {
    _amountController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  void _handleCustomerSelected(String name, String id, double outstanding) {
    setState(() {
      _selectedCustomerName = name;
      _selectedCustomerId = id;
      _outstandingAmount = outstanding;
    });
  }

  void _handleIncrementAmount(double increment) {
    double currentVal = double.tryParse(_amountController.text) ?? 0.0;
    setState(() {
      _amountController.text = (currentVal + increment).toStringAsFixed(2);
    });
  }

  void _submitTransaction() {
    if (_selectedCustomerName == null) {
      _showSnackbar('Please select a customer first.', AgentColors.errorAccent);
      return;
    }

    final double enteredAmount = double.tryParse(_amountController.text) ?? 0.0;
    if (enteredAmount <= 0) {
      _showSnackbar('Please enter a valid amount received.', AgentColors.errorAccent);
      return;
    }

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
            'Customer: $_selectedCustomerName\n'
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
  }

  void _resetForm() {
    setState(() {
      _amountController.clear();
      _notesController.clear();
      _selectedCustomerName = 'Arjun Mehta';
      _selectedCustomerId = 'FT-8829';
      _outstandingAmount = 14250.00;
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

  @override
  Widget build(BuildContext context) {
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
                selectedCustomerName: _selectedCustomerName,
                onCustomerSelected: _handleCustomerSelected,
              ),
              const SizedBox(height: 16),

              // 2. Amount Received Widget
              AmountInput(
                controller: _amountController,
                onIncrementPressed: _handleIncrementAmount,
              ),
              const SizedBox(height: 16),

              // 3. Outstanding Card Widget
              OutstandingCard(
                outstandingAmount: _outstandingAmount,
                customerId: _selectedCustomerId,
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
                  onPressed: _submitTransaction,
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
                  child: Row(
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
