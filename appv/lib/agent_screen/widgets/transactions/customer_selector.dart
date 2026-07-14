import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../../constants/agent_colors.dart';
import '../../provider/agent_provider.dart';
import '../../models/agent_search_member_model.dart';

class CustomerSelector extends StatefulWidget {
  final AgentSearchMemberModel? selectedMember;
  final Function(AgentSearchMemberModel member) onMemberSelected;

  const CustomerSelector({
    super.key,
    required this.selectedMember,
    required this.onMemberSelected,
  });

  @override
  State<CustomerSelector> createState() => _CustomerSelectorState();
}

class _CustomerSelectorState extends State<CustomerSelector> {
  final TextEditingController _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

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
                      widget.selectedMember?.name ?? 'Search by name or ID',
                      style: GoogleFonts.outfit(
                        fontSize: 15,
                        color: widget.selectedMember != null
                            ? AgentColors.textPrimary
                            : AgentColors.textMuted,
                        fontWeight: widget.selectedMember != null
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
        ],
      ),
    );
  }

  void _showCustomerSearchDialog(BuildContext context) {
    final agentProvider = Provider.of<AgentProvider>(context, listen: false);
    agentProvider.clearSearchResults();
    _searchController.clear();

    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setStateDialog) {
            return AlertDialog(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
              title: Text(
                'Search Customer',
                style: GoogleFonts.outfit(fontWeight: FontWeight.bold, color: AgentColors.primaryGreen),
              ),
              content: SizedBox(
                width: double.maxFinite,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextField(
                      controller: _searchController,
                      decoration: InputDecoration(
                        hintText: 'Type name, phone or ID...',
                        prefixIcon: const Icon(Icons.search, color: AgentColors.primaryGreen),
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                      ),
                      onChanged: (val) {
                        agentProvider.searchMembers(val);
                      },
                    ),
                    const SizedBox(height: 16),
                    Expanded(
                      child: Consumer<AgentProvider>(
                        builder: (context, provider, child) {
                          if (provider.isSearchLoading) {
                            return const Center(child: CircularProgressIndicator(color: AgentColors.primaryGreen));
                          }
                          if (provider.searchError != null) {
                            return Center(
                              child: Text(
                                provider.searchError!,
                                style: const TextStyle(color: Colors.red),
                                textAlign: TextAlign.center,
                              ),
                            );
                          }
                          final results = provider.searchResults;
                          if (results.isEmpty && _searchController.text.isNotEmpty) {
                            return Center(child: Text('No customers found', style: GoogleFonts.outfit(color: AgentColors.textSecondary)));
                          }
                          return ListView.separated(
                            itemCount: results.length,
                            separatorBuilder: (context, index) => const Divider(color: AgentColors.borderMuted),
                            itemBuilder: (context, index) {
                              final customer = results[index];
                              return ListTile(
                                title: Text(
                                  customer.name,
                                  style: GoogleFonts.outfit(fontWeight: FontWeight.w600),
                                ),
                                subtitle: Text(
                                  'ID: #MEM-${customer.id} • Phone: ${customer.phone ?? "N/A"}',
                                  style: GoogleFonts.outfit(color: AgentColors.textSecondary, fontSize: 13),
                                ),
                                onTap: () {
                                  widget.onMemberSelected(customer);
                                  Navigator.pop(context);
                                },
                              );
                            },
                          );
                        },
                      ),
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
}
