import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../../widgets/custom_bottom_navbar.dart';
import '../../widgets/animated_background.dart';
import '../../provider/dashboard_provider.dart';
import '../../provider/material_provider.dart';
import '../../models/material_model.dart';
import '../community/community_screen.dart';
import '../lottery/lottery_screen.dart';
import '../loan_details/loan_details_screen.dart';
import '../settings/settings_screen.dart';
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
  bool _showAllTabs = false; // Initial mode: Only Home & Settings visible in footer

  @override
  void initState() {
    super.initState();
    HomeScreen.activeTabNotifier.value = _selectedNavIndex;
    HomeScreen.activeTabNotifier.addListener(_onTabNotification);

    // Fetch dashboard and material sales data on init
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<DashboardProvider>(context, listen: false).fetchDashboard();
      Provider.of<MaterialProvider>(context, listen: false).fetchMaterialsAndStocks();
    });
  }

  @override
  void dispose() {
    HomeScreen.activeTabNotifier.removeListener(_onTabNotification);
    super.dispose();
  }

  void _onTabNotification() {
    if (mounted) {
      final newIndex = HomeScreen.activeTabNotifier.value;
      setState(() {
        _selectedNavIndex = newIndex;
        // If programmatically switched to Community (1), Lottery (2), or Loan (3), auto-unlock footer
        if (newIndex == 1 || newIndex == 2 || newIndex == 3) {
          _showAllTabs = true;
          _selectedTabIndex = 1;
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: AnimatedBackground(
        child: SafeArea(
          child: Column(
            children: [
              // Content area
              Expanded(
                child: _buildNavContent(),
              ),
              // Custom Bottom Navigation Footer
              CustomBottomNavBar(
                selectedIndex: _selectedNavIndex,
                showAllTabs: _showAllTabs,
                onTabSelected: (index) {
                  HomeScreen.activeTabNotifier.value = index;
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Returns content based on selected bottom nav index with smooth transitions
  Widget _buildNavContent() {
    Widget child;
    switch (_selectedNavIndex) {
      case 0:
        child = _buildHomeDashboard();
        break;
      case 1:
        child = CommunityScreen(
          showAppBar: false,
          onTabSelected: (index) {
            setState(() {
              _selectedNavIndex = index;
            });
          },
        );
        break;
      case 2:
        child = const LotteryScreen();
        break;
      case 3:
        child = const LoanDetailsScreen();
        break;
      case 4:
        child = const SettingsScreen();
        break;
      default:
        child = _buildHomeDashboard();
    }

    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 250),
      switchInCurve: Curves.easeOutCubic,
      switchOutCurve: Curves.easeInCubic,
      transitionBuilder: (Widget child, Animation<double> animation) {
        return FadeTransition(
          opacity: animation,
          child: SlideTransition(
            position: Tween<Offset>(
              begin: const Offset(0.03, 0.0),
              end: Offset.zero,
            ).animate(animation),
            child: child,
          ),
        );
      },
      child: KeyedSubtree(
        key: ValueKey<int>(_selectedNavIndex),
        child: child,
      ),
    );
  }

  // Main Home Dashboard switcher
  Widget _buildHomeDashboard() {
    if (!_showAllTabs) {
      return _buildMaterialSalesDashboard();
    }

    return Consumer<DashboardProvider>(
      builder: (context, dashboardProvider, child) {
        return SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // 1. Dynamic Header based on Active Tab
                _selectedTabIndex == 0
                    ? _buildTraderHeader(dashboardProvider)
                    : _buildOtherHeader(dashboardProvider),
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
      },
    );
  }

  // Trader Tab Header layout — uses real data from dashboard
  Widget _buildTraderHeader(DashboardProvider dp) {
    final userName = dp.userInfo?.name ?? 'User';
    final userPhoto = dp.userInfo?.photo;

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: userPhoto != null && userPhoto.isNotEmpty
                  ? Image.network(
                      userPhoto,
                      width: 40,
                      height: 40,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return _buildAvatarFallback(40, userName);
                      },
                    )
                  : _buildAvatarFallback(40, userName),
            ),
            const SizedBox(width: 12),
            Text(
              userName,
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
  Widget _buildOtherHeader(DashboardProvider dp) {
    final userName = dp.userInfo?.name;
    final userPhoto = dp.userInfo?.photo;

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          'Janta Trader',
          style: GoogleFonts.outfit(
            fontSize: 24,
            fontWeight: FontWeight.w800,
            color: const Color(0xFF0F4C3A), // Dark Green
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
              child: userPhoto != null && userPhoto.isNotEmpty
                  ? Image.network(
                      userPhoto,
                      width: 36,
                      height: 36,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return _buildAvatarFallback(36, userName ?? 'U');
                      },
                    )
                  : _buildAvatarFallback(36, userName ?? 'U'),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildAvatarFallback(double size, String name) {
    return Container(
      width: size,
      height: size,
      decoration: const BoxDecoration(
        color: Color(0xFF0F4C3A),
        shape: BoxShape.circle,
      ),
      alignment: Alignment.center,
      child: Text(
        name.isNotEmpty ? name[0].toUpperCase() : 'U',
        style: GoogleFonts.outfit(
          color: Colors.white,
          fontWeight: FontWeight.bold,
          fontSize: size * 0.4,
        ),
      ),
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
                  _showAllTabs = false; // Collapse to simple mode
                  _selectedNavIndex = 0;
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

  // New Simple Dashboard with Material Sales & Recent stock fetched dynamically from backend
  Widget _buildMaterialSalesDashboard() {
    return Consumer<MaterialProvider>(
      builder: (context, mp, child) {
        if (mp.isLoading && mp.materials.isEmpty) {
          return const Center(
            child: Padding(
              padding: EdgeInsets.all(40),
              child: CircularProgressIndicator(),
            ),
          );
        }

        final error = mp.error;
        final materials = mp.materials;
        final stocks = mp.stocks;

        return SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Subtle sync failure banner instead of a blocking page
                if (error != null)
                  Container(
                    margin: const EdgeInsets.only(bottom: 12),
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    decoration: BoxDecoration(
                      color: const Color(0xFFFEF2F2),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: const Color(0xFFFCA5A5)),
                    ),
                    child: Row(
                      children: [
                        const Icon(Icons.error_outline, color: Color(0xFFEF4444), size: 18),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            'Offline / Sync failed: $error',
                            style: GoogleFonts.outfit(color: const Color(0xFF991B1B), fontSize: 12),
                          ),
                        ),
                        IconButton(
                          icon: const Icon(Icons.refresh_rounded, size: 18, color: Color(0xFF991B1B)),
                          padding: EdgeInsets.zero,
                          constraints: const BoxConstraints(),
                          onPressed: () => mp.fetchMaterialsAndStocks(),
                        ),
                      ],
                    ),
                  ),

                // Center dark green Trader badge
                Center(
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 48, vertical: 10),
                    decoration: BoxDecoration(
                      color: const Color(0xFF0F4C3A), // Dark Green
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      'Trader',
                      style: GoogleFonts.outfit(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 24),

                // Material Sales title
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Material Sales',
                      style: GoogleFonts.outfit(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: const Color(0xFF1F2937),
                      ),
                    ),
                    Text(
                      'See all',
                      style: GoogleFonts.outfit(
                        fontSize: 12,
                        color: Colors.grey,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),

                // Material Cards Grid (dynamically loaded from backend)
                if (materials.isEmpty)
                  Container(
                    padding: const EdgeInsets.all(24),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: Colors.grey.shade200),
                    ),
                    child: Center(
                      child: Text(
                        'No materials available',
                        style: GoogleFonts.outfit(color: Colors.grey, fontSize: 14),
                      ),
                    ),
                  )
                else
                  _buildMaterialsGrid(materials),
                const SizedBox(height: 24),

                // Recent stock header
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Recent stock',
                      style: GoogleFonts.outfit(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                        color: const Color(0xFF1F2937),
                      ),
                    ),
                    const Icon(Icons.tune_rounded, size: 20, color: Colors.grey),
                  ],
                ),
                const SizedBox(height: 12),

                // Recent stock Container card list (dynamically loaded from backend)
                if (stocks.isEmpty)
                  Container(
                    padding: const EdgeInsets.all(24),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: Colors.grey.shade200),
                    ),
                    child: Center(
                      child: Text(
                        'No recent stock activities',
                        style: GoogleFonts.outfit(color: Colors.grey, fontSize: 14),
                      ),
                    ),
                  )
                else
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: Colors.grey.shade200),
                    ),
                    child: Column(
                      children: List.generate(stocks.length, (index) {
                        final txn = stocks[index];
                        final isLast = index == stocks.length - 1;
                        final dateStr = txn.createdAt != null
                            ? _formatStockDate(txn.createdAt!)
                            : 'N/A';
                        return Column(
                          children: [
                            _buildStockItem(
                              txn.title,
                              dateStr,
                              '${txn.isCredit ? '+ ' : '- '}₹ ${txn.amount.toStringAsFixed(0)}',
                              txn.status.toUpperCase(),
                              txn.isSuccess,
                            ),
                            if (!isLast) const Divider(height: 1),
                          ],
                        );
                      }),
                    ),
                  ),
                const SizedBox(height: 24),

                // Other Button
                ElevatedButton(
                  onPressed: () {
                    setState(() {
                      _showAllTabs = true;
                      _selectedTabIndex = 1; // Default inside dashboard to 'Other' tab
                    });
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFE5E7EB), // Light grey
                    foregroundColor: Colors.black87,
                    elevation: 0,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: Text(
                    'Other',
                    style: GoogleFonts.outfit(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(height: 16),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildMaterialsGrid(List<MaterialModel> list) {
    // Render materials in Rows of 2 columns
    final List<Widget> rows = [];
    for (int i = 0; i < list.length; i += 2) {
      final item1 = list[i];
      final item2 = (i + 1 < list.length) ? list[i + 1] : null;

      rows.add(
        Row(
          children: [
            Expanded(
              child: _buildMaterialCard(
                item1.name,
                '₹ ${item1.price.toStringAsFixed(0)} / ${item1.unit}',
                item1.imageUrl ?? 'https://images.unsplash.com/photo-1589939705384-5185137a7f0f?q=80&w=200&auto=format&fit=crop',
              ),
            ),
            const SizedBox(width: 12),
            if (item2 != null)
              Expanded(
                child: _buildMaterialCard(
                  item2.name,
                  '₹ ${item2.price.toStringAsFixed(0)} / ${item2.unit}',
                  item2.imageUrl ?? 'https://images.unsplash.com/photo-1541888946425-d81bb19240f5?q=80&w=200&auto=format&fit=crop',
                ),
              )
            else
              const Expanded(child: SizedBox()),
          ],
        ),
      );

      if (i + 2 < list.length) {
        rows.add(const SizedBox(height: 12));
      }
    }

    return Column(children: rows);
  }

  Widget _buildMaterialCard(String name, String price, String imageUrl) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          ClipRRect(
            borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
            child: Image.network(
              imageUrl,
              height: 90,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) {
                return Container(
                  height: 90,
                  color: Colors.grey.shade100,
                  child: const Icon(Icons.image, color: Colors.grey),
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: GoogleFonts.outfit(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: const Color(0xFF0F4C3A),
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  price,
                  style: GoogleFonts.outfit(
                    fontSize: 11,
                    color: Colors.grey,
                  ),
                ),
                const SizedBox(height: 8),
                SizedBox(
                  width: double.infinity,
                  child: OutlinedButton(
                    onPressed: () {},
                    style: OutlinedButton.styleFrom(
                      foregroundColor: const Color(0xFF0F4C3A),
                      side: const BorderSide(color: Color(0xFF0F4C3A)),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 4),
                    ),
                    child: Text(
                      '+ Add',
                      style: GoogleFonts.outfit(fontSize: 12, fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStockItem(String title, String subtitle, String amount, String status, bool isSuccess) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12.0),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: isSuccess ? const Color(0xFFECFDF5) : const Color(0xFFEFF6FF),
              shape: BoxShape.circle,
            ),
            child: Icon(
              isSuccess ? Icons.assignment_turned_in_outlined : Icons.history_rounded,
              color: isSuccess ? const Color(0xFF059669) : const Color(0xFF3B82F6),
              size: 20,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: GoogleFonts.outfit(
                    fontSize: 13,
                    fontWeight: FontWeight.bold,
                    color: const Color(0xFF1F2937),
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  subtitle,
                  style: GoogleFonts.outfit(
                    fontSize: 10,
                    color: Colors.grey,
                  ),
                ),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                amount,
                style: GoogleFonts.outfit(
                  fontSize: 13,
                  fontWeight: FontWeight.bold,
                  color: isSuccess ? const Color(0xFF059669) : const Color(0xFF1F2937),
                ),
              ),
              const SizedBox(height: 2),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: BoxDecoration(
                  color: isSuccess ? const Color(0xFFD1FAE5) : const Color(0xFFDBEAFE),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Text(
                  status,
                  style: GoogleFonts.outfit(
                    fontSize: 8,
                    fontWeight: FontWeight.bold,
                    color: isSuccess ? const Color(0xFF065F46) : const Color(0xFF1E40AF),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  String _formatStockDate(String dateStr) {
    try {
      final date = DateTime.parse(dateStr);
      return DateFormat('dd MMM, yyyy • HH:mm').format(date);
    } catch (_) {
      return dateStr;
    }
  }
}
