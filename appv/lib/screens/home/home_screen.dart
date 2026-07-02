import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../widgets/custom_bottom_navbar.dart';
import '../community/community_screen.dart';
import '../lottery/lottery_screen.dart';
import '../loan_details/loan_details_screen.dart';
import 'widgets/trader_tab.dart';
import 'widgets/other_tab.dart';

class HomeScreen extends StatefulWidget {
  static final ValueNotifier<int> activeTabNotifier = ValueNotifier<int>(0);

  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedTabIndex = 0; // 0: Trader, 1: Other
  int _selectedNavIndex = 0; // 0: Home, 1: Community, 2: Lottery, 3: Loan, 4: Settings

  @override
  void initState() {
    super.initState();
    HomeScreen.activeTabNotifier.value = _selectedNavIndex;
    HomeScreen.activeTabNotifier.addListener(_onTabNotification);
  }

  @override
  void dispose() {
    HomeScreen.activeTabNotifier.removeListener(_onTabNotification);
    super.dispose();
  }

  void _onTabNotification() {
    if (mounted) {
      setState(() {
        _selectedNavIndex = HomeScreen.activeTabNotifier.value;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF3F5F8), // Soft off-white layout background
      body: SafeArea(
        child: Column(
          children: [
            // Content area
            Expanded(
              child: _buildNavContent(),
            ),
            // Custom Bottom Navigation Footer
            CustomBottomNavBar(
              selectedIndex: _selectedNavIndex,
              onTabSelected: (index) {
                HomeScreen.activeTabNotifier.value = index;
              },
            ),
          ],
        ),
      ),
    );
  }

  // Returns content based on selected bottom nav index
  Widget _buildNavContent() {
    switch (_selectedNavIndex) {
      case 0:
        return _buildHomeDashboard();
      case 1:
        return CommunityScreen(
          showAppBar: false,
          onTabSelected: (index) {
            setState(() {
              _selectedNavIndex = index;
            });
          },
        );
      case 2:
        return const LotteryScreen();
      case 3:
        return const LoanDetailsScreen();
      case 4:
        return _buildPlaceholderTab('Settings Screen', Icons.settings_rounded);
      default:
        return _buildHomeDashboard();
    }
  }

  // Placeholder views for non-home tabs
  Widget _buildPlaceholderTab(String title, IconData icon) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.75,
      alignment: Alignment.center,
      padding: const EdgeInsets.all(24),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: 80, color: const Color(0xFF0F4C3A)),
          const SizedBox(height: 16),
          Text(
            title,
            style: GoogleFonts.outfit(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: const Color(0xFF111827),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'This page is ready to be populated with contents.',
            textAlign: TextAlign.center,
            style: GoogleFonts.outfit(
              fontSize: 14,
              color: const Color(0xFF6B7280),
            ),
          ),
        ],
      ),
    );
  }

  // Main Home Dashboard implementation (with its own SingleChildScrollView)
  Widget _buildHomeDashboard() {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // 1. Dynamic Header based on Active Tab
            _selectedTabIndex == 0 ? _buildTraderHeader() : _buildOtherHeader(),
            const SizedBox(height: 16),

            // 2. Custom Slider Tab Switcher (Trader vs Other)
            _buildTabSwitcher(),
            const SizedBox(height: 16),

            // 3. Dynamic Tab Content
            _selectedTabIndex == 0 ? const TraderTab() : const OtherTab(),
          ],
        ),
      ),
    );
  }

  // Trader Tab Header layout
  Widget _buildTraderHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: Image.network(
                'https://images.unsplash.com/photo-1472099645785-5658abf4ff4e?w=150',
                width: 40,
                height: 40,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return Container(
                    width: 40,
                    height: 40,
                    color: const Color(0xFF0F4C3A),
                    alignment: Alignment.center,
                    child: const Icon(Icons.person, color: Colors.white, size: 20),
                  );
                },
                loadingBuilder: (context, child, loadingProgress) {
                  if (loadingProgress == null) return child;
                  return Container(
                    width: 40,
                    height: 40,
                    color: Colors.grey.shade100,
                  );
                },
              ),
            ),
            const SizedBox(width: 12),
            Text(
              'Alexander Vanguard',
              style: GoogleFonts.outfit(
                fontSize: 15,
                fontWeight: FontWeight.w600,
                color: const Color(0xFF111827),
              ),
            ),
          ],
        ),
        IconButton(
          icon: const Icon(
            Icons.notifications_none_rounded,
            color: Color(0xFF111827),
            size: 24,
          ),
          onPressed: () {},
        ),
      ],
    );
  }

  // Other Tab Header layout
  Widget _buildOtherHeader() {
    final theme = Theme.of(context);
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          'Janta Trader',
          style: GoogleFonts.outfit(
            fontSize: 24,
            fontWeight: FontWeight.w800,
            color: theme.colorScheme.primary, // Navy Blue
            letterSpacing: -1.0,
          ),
        ),
        Row(
          children: [
            IconButton(
              icon: const Icon(
                Icons.notifications_none_rounded,
                color: Color(0xFF111827),
                size: 24,
              ),
              onPressed: () {},
            ),
            ClipRRect(
              borderRadius: BorderRadius.circular(18),
              child: Image.network(
                'https://images.unsplash.com/photo-1472099645785-5658abf4ff4e?w=150',
                width: 36,
                height: 36,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return Container(
                    width: 36,
                    height: 36,
                    color: const Color(0xFF0F4C3A),
                    alignment: Alignment.center,
                    child: const Icon(Icons.person, color: Colors.white, size: 18),
                  );
                },
                loadingBuilder: (context, child, loadingProgress) {
                  if (loadingProgress == null) return child;
                  return Container(
                    width: 36,
                    height: 36,
                    color: Colors.grey.shade100,
                  );
                },
              ),
            ),
          ],
        ),
      ],
    );
  }

  // Custom Slider Tab Switcher Widget
  Widget _buildTabSwitcher() {
    return Container(
      height: 48,
      decoration: BoxDecoration(
        color: const Color(0xFFE5E7EB),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Expanded(
            child: GestureDetector(
              onTap: () {
                setState(() {
                  _selectedTabIndex = 0;
                });
              },
              child: Container(
                margin: const EdgeInsets.all(4),
                decoration: BoxDecoration(
                  color: _selectedTabIndex == 0
                      ? const Color(0xFF0F4C3A)
                      : Colors.transparent,
                  borderRadius: BorderRadius.circular(10),
                ),
                alignment: Alignment.center,
                child: Text(
                  'Trader',
                  style: GoogleFonts.outfit(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                    color: _selectedTabIndex == 0
                        ? Colors.white
                        : const Color(0xFF374151),
                  ),
                ),
              ),
            ),
          ),
          Expanded(
            child: GestureDetector(
              onTap: () {
                setState(() {
                  _selectedTabIndex = 1;
                });
              },
              child: Container(
                margin: const EdgeInsets.all(4),
                decoration: BoxDecoration(
                  color: _selectedTabIndex == 1
                      ? const Color(0xFF0F4C3A)
                      : Colors.transparent,
                  borderRadius: BorderRadius.circular(10),
                ),
                alignment: Alignment.center,
                child: Text(
                  'Other',
                  style: GoogleFonts.outfit(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                    color: _selectedTabIndex == 1
                        ? Colors.white
                        : const Color(0xFF374151),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
