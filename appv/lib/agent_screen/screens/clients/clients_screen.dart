import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../constants/agent_colors.dart';
import '../../widgets/clients/clients_header.dart';
import '../../widgets/clients/clients_search.dart';
import '../../widgets/clients/clients_summary_cards.dart';
import '../../widgets/clients/client_list_card.dart';
import 'client_profile_screen.dart';

class ClientsScreen extends StatefulWidget {
  const ClientsScreen({super.key});

  @override
  State<ClientsScreen> createState() => _ClientsScreenState();
}

class _ClientsScreenState extends State<ClientsScreen> {
  String _searchQuery = '';

  // Initial mockup dataset matching the screen layout exactly
  final List<Map<String, dynamic>> _allClients = [
    {
      'name': 'Arjun Mehta',
      'id': '#88219',
      'status': 'Active',
      'lastCollection': '₹12,000',
      'trend': [1.0, 1.2, 1.1, 1.4, 1.3, 1.4, 1.5],
    },
    {
      'name': 'Sara Khan',
      'id': '#88224',
      'status': 'Pending KYC',
      'lastCollection': '₹4,500',
      'trend': [1.0, 1.05, 1.0, 0.98, 1.02, 1.0, 1.03],
    },
    {
      'name': 'Rohan Verma',
      'id': '#88301',
      'status': 'Overdue',
      'lastCollection': '₹0',
      'trend': [2.5, 2.0, 1.8, 1.2, 0.8, 0.3, 0.0],
    },
    {
      'name': 'Priya Nair',
      'id': '#88342',
      'status': 'Active',
      'lastCollection': '₹28,500',
      'trend': [0.5, 1.0, 1.2, 1.8, 2.2, 2.5, 3.0],
    },
  ];

  void _showAddClientSheet() {
    final formKey = GlobalKey<FormState>();
    final nameController = TextEditingController();
    final idController = TextEditingController();

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
                      'Add New Client',
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
                
                // ID Input
                Text(
                  'CLIENT ID',
                  style: GoogleFonts.outfit(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: AgentColors.textSecondary,
                  ),
                ),
                const SizedBox(height: 8),
                TextFormField(
                  controller: idController,
                  decoration: InputDecoration(
                    hintText: 'e.g. #88401',
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
                      return 'Please enter client ID';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 24),
                
                // Submit Button
                ElevatedButton(
                  onPressed: () {
                    if (formKey.currentState!.validate()) {
                      setState(() {
                        _allClients.add({
                          'name': nameController.text.trim(),
                          'id': idController.text.trim().startsWith('#')
                              ? idController.text.trim()
                              : '#${idController.text.trim()}',
                          'status': 'Active',
                          'lastCollection': '₹0',
                          'trend': [1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0],
                        });
                      });
                      Navigator.pop(context);
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          backgroundColor: AgentColors.successGreen,
                          content: Text(
                            'Client ${nameController.text} added successfully.',
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
                    'Create Client Account',
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
    // Filter logic
    final filteredClients = _allClients.where((client) {
      final name = client['name'].toString().toLowerCase();
      final id = client['id'].toString().toLowerCase();
      final query = _searchQuery.toLowerCase();
      return name.contains(query) || id.contains(query);
    }).toList();

    return Scaffold(
      backgroundColor: AgentColors.backgroundSoft,
      body: SafeArea(
        child: Stack(
          children: [
            SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
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
                      setState(() {
                        _searchQuery = val;
                      });
                    },
                  ),
                  const SizedBox(height: 20),

                  // 3. Summary Cards widget (uses dynamic state length)
                  ClientsSummaryCards(
                    totalClients: _allClients.length + 138, // Offset to match 142 total managed
                    activeLoans: _allClients.where((c) => c['status'] == 'Active').length + 84, // Offset to match 86 active
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
                  filteredClients.isEmpty
                      ? Padding(
                          padding: const EdgeInsets.symmetric(vertical: 40.0),
                          child: Center(
                            child: Column(
                              children: [
                                const Icon(Icons.people_outline_rounded, size: 48, color: AgentColors.textMuted),
                                const SizedBox(height: 12),
                                Text(
                                  'No clients matched your search',
                                  style: GoogleFonts.outfit(color: AgentColors.textSecondary, fontWeight: FontWeight.w600),
                                ),
                              ],
                            ),
                          ),
                        )
                      : ListView.separated(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: filteredClients.length,
                          separatorBuilder: (context, index) => const SizedBox(height: 12),
                          itemBuilder: (context, index) {
                            final client = filteredClients[index];
                            return ClientListCard(
                              name: client['name'] as String,
                              id: client['id'] as String,
                              status: client['status'] as String,
                              lastCollectionAmount: client['lastCollection'] as String,
                              sparklineData: List<double>.from(client['trend'] as List),
                              onViewProfile: () {
                                Navigator.of(context).push(
                                  MaterialPageRoute(
                                    builder: (context) => ClientProfileScreen(
                                      clientName: client['name'] as String,
                                      clientId: client['id'] as String,
                                      status: client['status'] as String,
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
