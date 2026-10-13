import 'dart:async';
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
  Timer? _debounceTimer;

  @override
  void dispose() {
    _debounceTimer?.cancel();
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
                      widget.selectedMember != null
                          ? '${widget.selectedMember!.name} (#MEM-${widget.selectedMember!.id})'
                          : 'Search by name, phone or ID...',
                      style: GoogleFonts.outfit(
                        fontSize: 15,
                        color: widget.selectedMember != null
                            ? AgentColors.textPrimary
                            : AgentColors.textMuted,
                        fontWeight: widget.selectedMember != null
                            ? FontWeight.w600
                            : FontWeight.normal,
                      ),
                      overflow: TextOverflow.ellipsis,
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
              backgroundColor: Colors.white,
              surfaceTintColor: Colors.white,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
              titlePadding: const EdgeInsets.fromLTRB(20, 20, 16, 12),
              contentPadding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
              title: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: AgentColors.primaryGreen.withAlpha(25),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: const Icon(Icons.person_search_rounded, color: AgentColors.primaryGreen, size: 22),
                      ),
                      const SizedBox(width: 12),
                      Text(
                        'Search Customer',
                        style: GoogleFonts.outfit(
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                          color: AgentColors.textPrimary,
                        ),
                      ),
                    ],
                  ),
                  IconButton(
                    icon: const Icon(Icons.close_rounded, color: AgentColors.textSecondary, size: 22),
                    onPressed: () => Navigator.pop(context),
                  ),
                ],
              ),
              content: SizedBox(
                width: double.maxFinite,
                height: 460, // Fixed height to prevent unconstrained layout inside AlertDialog
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextField(
                      controller: _searchController,
                      autofocus: true,
                      textInputAction: TextInputAction.search,
                      style: GoogleFonts.outfit(fontSize: 15, color: AgentColors.textPrimary),
                      decoration: InputDecoration(
                        hintText: 'Type name, phone or ID...',
                        hintStyle: GoogleFonts.outfit(color: AgentColors.textMuted, fontSize: 14),
                        prefixIcon: const Icon(Icons.search_rounded, color: AgentColors.primaryGreen, size: 22),
                        suffixIcon: _searchController.text.isNotEmpty
                            ? IconButton(
                                icon: const Icon(Icons.clear_rounded, size: 18, color: AgentColors.textSecondary),
                                onPressed: () {
                                  _searchController.clear();
                                  _debounceTimer?.cancel();
                                  agentProvider.clearSearchResults();
                                  setStateDialog(() {});
                                },
                              )
                            : null,
                        filled: true,
                        fillColor: AgentColors.backgroundSoft,
                        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(14),
                          borderSide: BorderSide(color: AgentColors.borderMuted),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(14),
                          borderSide: BorderSide(color: AgentColors.borderMuted),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(14),
                          borderSide: const BorderSide(color: AgentColors.primaryGreen, width: 1.5),
                        ),
                      ),
                      onChanged: (val) {
                        setStateDialog(() {});
                        _debounceTimer?.cancel();
                        _debounceTimer = Timer(const Duration(milliseconds: 300), () {
                          agentProvider.searchMembers(val);
                        });
                      },
                      onSubmitted: (val) {
                        _debounceTimer?.cancel();
                        agentProvider.searchMembers(val);
                      },
                    ),
                    const SizedBox(height: 16),
                    Expanded(
                      child: Consumer<AgentProvider>(
                        builder: (context, provider, child) {
                          if (provider.isSearchLoading) {
                            return const Center(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  CircularProgressIndicator(color: AgentColors.primaryGreen, strokeWidth: 2.5),
                                  SizedBox(height: 12),
                                  Text('Searching customers...', style: TextStyle(color: AgentColors.textSecondary, fontSize: 13)),
                                ],
                              ),
                            );
                          }

                          if (provider.searchError != null) {
                            return Center(
                              child: Padding(
                                padding: const EdgeInsets.all(16.0),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    const Icon(Icons.error_outline_rounded, color: Colors.redAccent, size: 36),
                                    const SizedBox(height: 8),
                                    Text(
                                      provider.searchError!,
                                      style: GoogleFonts.outfit(color: Colors.redAccent, fontSize: 13),
                                      textAlign: TextAlign.center,
                                    ),
                                    const SizedBox(height: 12),
                                    TextButton(
                                      onPressed: () => provider.searchMembers(_searchController.text),
                                      child: const Text('Retry', style: TextStyle(color: AgentColors.primaryGreen)),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          }

                          // When text is empty, show clean instruction
                          if (_searchController.text.trim().isEmpty) {
                            return Center(
                              child: Padding(
                                padding: const EdgeInsets.all(20.0),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Container(
                                      padding: const EdgeInsets.all(16),
                                      decoration: BoxDecoration(
                                        color: AgentColors.backgroundSoft,
                                        shape: BoxShape.circle,
                                      ),
                                      child: const Icon(Icons.manage_search_rounded, size: 40, color: AgentColors.primaryGreen),
                                    ),
                                    const SizedBox(height: 14),
                                    Text(
                                      'Find Any Customer',
                                      style: GoogleFonts.outfit(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16,
                                        color: AgentColors.textPrimary,
                                      ),
                                    ),
                                    const SizedBox(height: 6),
                                    Text(
                                      'Type customer mobile number, Customer ID (e.g. 4 or #MEM-4), or name to search.',
                                      textAlign: TextAlign.center,
                                      style: GoogleFonts.outfit(
                                        color: AgentColors.textSecondary,
                                        fontSize: 13,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          }

                          final results = provider.searchResults;
                          if (results.isEmpty) {
                            return Center(
                              child: Padding(
                                padding: const EdgeInsets.all(20.0),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    const Icon(Icons.search_off_rounded, size: 44, color: AgentColors.textMuted),
                                    const SizedBox(height: 12),
                                    Text(
                                      'No customers found',
                                      style: GoogleFonts.outfit(
                                        fontWeight: FontWeight.w600,
                                        fontSize: 15,
                                        color: AgentColors.textPrimary,
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      'No match for "${_searchController.text.trim()}". Try searching with mobile number or ID.',
                                      textAlign: TextAlign.center,
                                      style: GoogleFonts.outfit(
                                        color: AgentColors.textSecondary,
                                        fontSize: 12,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          }

                          return ListView.separated(
                            itemCount: results.length,
                            separatorBuilder: (context, index) => const Divider(color: AgentColors.borderMuted, height: 1),
                            itemBuilder: (context, index) {
                              final customer = results[index];
                              final hasPhone = customer.phone != null && customer.phone!.isNotEmpty;
                              return InkWell(
                                borderRadius: BorderRadius.circular(12),
                                onTap: () {
                                  widget.onMemberSelected(customer);
                                  Navigator.pop(context);
                                },
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 8.0),
                                  child: Row(
                                    children: [
                                      // Customer Avatar
                                      CircleAvatar(
                                        radius: 20,
                                        backgroundColor: AgentColors.primaryGreen.withAlpha(30),
                                        child: Text(
                                          customer.name.isNotEmpty ? customer.name[0].toUpperCase() : 'C',
                                          style: GoogleFonts.outfit(
                                            color: AgentColors.primaryGreen,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 16,
                                          ),
                                        ),
                                      ),
                                      const SizedBox(width: 12),
                                      // Customer Details
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              customer.name,
                                              style: GoogleFonts.outfit(
                                                fontWeight: FontWeight.w600,
                                                fontSize: 14.5,
                                                color: AgentColors.textPrimary,
                                              ),
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                            const SizedBox(height: 3),
                                            Row(
                                              children: [
                                                // ID Badge
                                                Container(
                                                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                                  decoration: BoxDecoration(
                                                    color: AgentColors.backgroundSoft,
                                                    borderRadius: BorderRadius.circular(6),
                                                    border: Border.all(color: AgentColors.borderMuted, width: 0.8),
                                                  ),
                                                  child: Text(
                                                    '#MEM-${customer.id}',
                                                    style: GoogleFonts.outfit(
                                                      fontSize: 11,
                                                      fontWeight: FontWeight.w600,
                                                      color: AgentColors.primaryGreen,
                                                    ),
                                                  ),
                                                ),
                                                const SizedBox(width: 8),
                                                // Phone Number
                                                if (hasPhone) ...[
                                                  const Icon(Icons.phone_outlined, size: 12, color: AgentColors.textSecondary),
                                                  const SizedBox(width: 3),
                                                  Flexible(
                                                    child: Text(
                                                      customer.phone!,
                                                      style: GoogleFonts.outfit(
                                                        color: AgentColors.textSecondary,
                                                        fontSize: 12,
                                                      ),
                                                      overflow: TextOverflow.ellipsis,
                                                    ),
                                                  ),
                                                ],
                                              ],
                                            ),
                                          ],
                                        ),
                                      ),
                                      const Icon(
                                        Icons.chevron_right_rounded,
                                        color: AgentColors.textMuted,
                                        size: 20,
                                      ),
                                    ],
                                  ),
                                ),
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

