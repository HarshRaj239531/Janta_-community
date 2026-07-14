import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../../constants/agent_colors.dart';
import '../../widgets/clients/clients_header.dart';
import '../../widgets/clients/clients_search.dart';
import '../../widgets/clients/clients_summary_cards.dart';
import '../../widgets/clients/client_list_card.dart';
import '../../provider/agent_provider.dart';
import 'client_profile_screen.dart';

class ClientsScreen extends StatefulWidget {
  const ClientsScreen({super.key});

  @override
  State<ClientsScreen> createState() => _ClientsScreenState();
}

class _ClientsScreenState extends State<ClientsScreen> {
  String _searchQuery = '';

  void _showAddClientSheet() {
    final formKey = GlobalKey<FormState>();
    final nameController = TextEditingController();
    final phoneController = TextEditingController();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) {
        return Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
            top: 24,
            left: 24,
            right: 24,
          ),
          child: Form(
            key: formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Request New Client',
                      style: GoogleFonts.outfit(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: AgentColors.primaryGreen,
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.close),
                      onPressed: () => Navigator.pop(context),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                
                // Name Input
                Text(
                  'CLIENT FULL NAME',
                  style: GoogleFonts.outfit(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: AgentColors.textSecondary,
                  ),
                ),
                const SizedBox(height: 8),
                TextFormField(
                  controller: nameController,
                  decoration: InputDecoration(
                    hintText: 'e.g. Rajesh Kumar',
                    hintStyle: GoogleFonts.outfit(color: AgentColors.textMuted),
                    filled: true,
                    fillColor: AgentColors.backgroundSoft,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide.none,
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Please enter client name';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                
                // Phone Input
                Text(
                  'CLIENT PHONE NUMBER',
                  style: GoogleFonts.outfit(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: AgentColors.textSecondary,
                  ),
                ),
                const SizedBox(height: 8),
                TextFormField(
                  controller: phoneController,
                  keyboardType: TextInputType.phone,
                  decoration: InputDecoration(
                    hintText: 'e.g. 9876543210',
                    hintStyle: GoogleFonts.outfit(color: AgentColors.textMuted),
                    filled: true,
                    fillColor: AgentColors.backgroundSoft,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide.none,
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Please enter phone number';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 24),
                
                // Submit Button
                ElevatedButton(
                  onPressed: () {
                    if (formKey.currentState!.validate()) {
                      Navigator.pop(context);
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          backgroundColor: AgentColors.successGreen,
                          content: Text(
                            'Client creation request submitted to Admin for approval.',
                            style: GoogleFonts.outfit(color: Colors.white, fontWeight: FontWeight.w600),
                          ),
                        ),
                      );
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AgentColors.primaryGreen,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: Text(
                    'Submit Request to Admin',
                    style: GoogleFonts.outfit(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
                const SizedBox(height: 24),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final agentProvider = Provider.of<AgentProvider>(context);
    final summary = agentProvider.clientsSummary;
    final clients = summary?.recentClients ?? [];

    return Scaffold(
      backgroundColor: AgentColors.backgroundSoft,
      body: SafeArea(
        child: Stack(
          children: [
            RefreshIndicator(
              onRefresh: () async {
                await agentProvider.fetchClients(search: _searchQuery);
              },
              child: SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // 1. Header widget
                    const ClientsHeader(),
                    const SizedBox(height: 16),
  
                    // 2. Search widget
                    ClientsSearch(
                      onChanged: (val) {
                        _searchQuery = val;
                        agentProvider.fetchClients(search: val);
                      },
                    ),
                    const SizedBox(height: 20),
  
                    // 3. Summary Cards widget (uses dynamic state length)
                    ClientsSummaryCards(
                      totalClients: summary?.totalClientsManaged ?? 0,
                      activeLoans: summary?.activeLoans ?? 0,
                    ),
                    const SizedBox(height: 24),

                  // 4. Section Label Row (RECENT CLIENTS / Sort by: Name)
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'RECENT CLIENTS',
                        style: GoogleFonts.outfit(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          color: AgentColors.textSecondary,
                          letterSpacing: 0.5,
                        ),
                      ),
                      Row(
                        children: [
                          Text(
                            'Sort by: ',
                            style: GoogleFonts.outfit(
                              fontSize: 12,
                              color: AgentColors.textMuted,
                            ),
                          ),
                          Text(
                            'Name',
                            style: GoogleFonts.outfit(
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                              color: AgentColors.primaryGreen,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),

                  // 5. Client List Cards
                  agentProvider.isClientsLoading && clients.isEmpty
                      ? const Padding(
                          padding: EdgeInsets.symmetric(vertical: 40.0),
                          child: Center(
                            child: CircularProgressIndicator(color: AgentColors.primaryGreen),
                          ),
                        )
                      : clients.isEmpty
                          ? Padding(
                              padding: const EdgeInsets.symmetric(vertical: 40.0),
                              child: Center(
                                child: Column(
                                  children: [
                                    const Icon(Icons.people_outline_rounded, size: 48, color: AgentColors.textMuted),
                                    const SizedBox(height: 12),
                                    Text(
                                      'No clients found',
                                      style: GoogleFonts.outfit(color: AgentColors.textSecondary, fontWeight: FontWeight.w600),
                                    ),
                                  ],
                                ),
                              ),
                            )
                          : ListView.separated(
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              itemCount: clients.length,
                              separatorBuilder: (context, index) => const SizedBox(height: 12),
                              itemBuilder: (context, index) {
                                final client = clients[index];
                                return ClientListCard(
                                  name: client.name,
                                  id: '#MEM-${client.id}',
                                  status: client.status,
                                  lastCollectionAmount: '₹${client.lastCollectionAmount.toStringAsFixed(0)}',
                                  sparklineData: const [1.0, 1.1, 1.05, 1.2, 1.15, 1.3],
                                  onViewProfile: () {
                                    Navigator.of(context).push(
                                      MaterialPageRoute(
                                        builder: (context) => ClientProfileScreen(
                                          clientName: client.name,
                                          clientId: client.id.toString(),
                                          status: client.status,
                                        ),
                                      ),
                                    );
                                  },
                                );
                              },
                            ),
                  const SizedBox(height: 80), // Extra space to clear the FAB and Bottom bar
                ],
              ),
            ),
          ),
            
            // 6. Floating Action Button (FAB)
            Positioned(
              right: 20,
              bottom: 20,
              child: FloatingActionButton(
                onPressed: _showAddClientSheet,
                backgroundColor: AgentColors.primaryGreen,
                foregroundColor: Colors.white,
                shape: const CircleBorder(),
                elevation: 4,
                child: const Icon(
                  Icons.person_add_alt_1_rounded,
                  size: 24,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
