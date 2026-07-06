import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../constants/agent_colors.dart';

class CustomerSelector extends StatelessWidget {
  final String? selectedCustomerName;
  final Function(String name, String id, double outstanding) onCustomerSelected;

  const CustomerSelector({
    super.key,
    required this.selectedCustomerName,
    required this.onCustomerSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AgentColors.borderMuted, width: 1),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(8),
            blurRadius: 10,
            offset: const Offset(0, 4),
          )
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Select Customer',
            style: GoogleFonts.outfit(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: AgentColors.textPrimary,
            ),
          ),
          const SizedBox(height: 12),
          
          // Dropdown/Search Field Box
          GestureDetector(
            onTap: () {
              _showCustomerSearchDialog(context);
            },
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 14.0),
              decoration: BoxDecoration(
                color: AgentColors.backgroundSoft,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                children: [
                  const Icon(
                    Icons.search_rounded,
                    color: AgentColors.textSecondary,
                    size: 20,
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      selectedCustomerName ?? 'Search by name or ID',
                      style: GoogleFonts.outfit(
                        fontSize: 15,
                        color: selectedCustomerName != null
                            ? AgentColors.textPrimary
                            : AgentColors.textMuted,
                        fontWeight: selectedCustomerName != null
                            ? FontWeight.w600
                            : FontWeight.normal,
                      ),
                    ),
                  ),
                  const Icon(
                    Icons.keyboard_arrow_down_rounded,
                    color: AgentColors.textSecondary,
                    size: 20,
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 12),
          
          // Recent customer selection pills
          Row(
            children: [
              _buildRecentPill(
                context,
                name: 'Arjun Mehta',
                id: 'FT-8829',
                outstanding: 14250.0,
              ),
              const SizedBox(width: 8),
              _buildRecentPill(
                context,
                name: 'Priya Sharma',
                id: 'FT-3490',
                outstanding: 8500.0,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildRecentPill(
    BuildContext context, {
    required String name,
    required String id,
    required double outstanding,
  }) {
    final isSelected = selectedCustomerName == name;

    return GestureDetector(
      onTap: () {
        onCustomerSelected(name, id, outstanding);
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? AgentColors.primaryGreen : AgentColors.lavenderSoft,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Text(
          'Recent: $name',
          style: GoogleFonts.outfit(
            fontSize: 12,
            fontWeight: FontWeight.bold,
            color: isSelected ? Colors.white : AgentColors.primaryGreen,
          ),
        ),
      ),
    );
  }

  // Simulated list dialog to search and pick any customer
  void _showCustomerSearchDialog(BuildContext context) {
    final customers = [
      {'name': 'Arjun Mehta', 'id': 'FT-8829', 'outstanding': 14250.0},
      {'name': 'Priya Sharma', 'id': 'FT-3490', 'outstanding': 8500.0},
      {'name': 'Rohan Das', 'id': 'FT-9021', 'outstanding': 25000.0},
      {'name': 'Karan Malhotra', 'id': 'FT-4412', 'outstanding': 11200.0},
      {'name': 'Simran Kaur', 'id': 'FT-1082', 'outstanding': 650.0},
    ];

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          title: Text(
            'Search Customer',
            style: GoogleFonts.outfit(fontWeight: FontWeight.bold, color: AgentColors.primaryGreen),
          ),
          content: SizedBox(
            width: double.maxFinite,
            child: ListView.separated(
              shrinkWrap: true,
              itemCount: customers.length,
              separatorBuilder: (context, index) => const Divider(color: AgentColors.borderMuted),
              itemBuilder: (context, index) {
                final customer = customers[index];
                return ListTile(
                  title: Text(
                    customer['name'] as String,
                    style: GoogleFonts.outfit(fontWeight: FontWeight.w600),
                  ),
                  subtitle: Text(
                    'ID: ${customer['id']} • Outstanding: ₹${(customer['outstanding'] as double).toStringAsFixed(2)}',
                    style: GoogleFonts.outfit(color: AgentColors.textSecondary, fontSize: 13),
                  ),
                  onTap: () {
                    onCustomerSelected(
                      customer['name'] as String,
                      customer['id'] as String,
                      customer['outstanding'] as double,
                    );
                    Navigator.pop(context);
                  },
                );
              },
            ),
          ),
        );
      },
    );
  }
}
