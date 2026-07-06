import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../constants/agent_colors.dart';
import 'agent_dashboard_screen.dart';
import 'transactions/transactions_screen.dart';
import 'clients/clients_screen.dart';
import 'settings/settings_screen.dart';

class AgentMainScreen extends StatefulWidget {
  const AgentMainScreen({super.key});

  @override
  State<AgentMainScreen> createState() => _AgentMainScreenState();
}

class _AgentMainScreenState extends State<AgentMainScreen> {
  int _currentIndex = 0;

  late final List<Widget> _screens;

  @override
  void initState() {
    super.initState();
    _screens = [
      AgentDashboardScreen(
        onViewTransactions: () {
          setState(() {
            _currentIndex = 1; // Switch to Transactions screen
          });
        },
      ),
      const TransactionsScreen(),
      const ClientsScreen(),
      const SettingsScreen(),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _currentIndex,
        children: _screens,
      ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border(
            top: BorderSide(
              color: AgentColors.borderMuted.withAlpha(120),
              width: 1.5,
            ),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withAlpha(5),
              blurRadius: 10,
              offset: const Offset(0, -4),
            )
          ],
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildNavItem(0, Icons.grid_view_rounded, 'Home'),
                _buildNavItem(1, Icons.receipt_long_rounded, 'Transactions'),
                _buildNavItem(2, Icons.people_outline_rounded, 'Clients'),
                _buildNavItem(3, Icons.settings_outlined, 'Settings'),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildNavItem(int index, IconData icon, String label) {
    final isSelected = _currentIndex == index;

    return GestureDetector(
      onTap: () {
        setState(() {
          _currentIndex = index;
        });
      },
      behavior: HitTestBehavior.opaque,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 250),
        curve: Curves.easeInOut,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? AgentColors.primaryGreen : Colors.transparent,
          borderRadius: BorderRadius.circular(24),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              color: isSelected ? Colors.white : AgentColors.textSecondary,
              size: 24,
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: GoogleFonts.outfit(
                fontSize: 12,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                color: isSelected ? Colors.white : AgentColors.textSecondary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
