import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../widgets/custom_bottom_navbar.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedTabIndex = 0; // 0: Trader, 1: Other
  int _selectedNavIndex = 0; // 0: Home, 1: Community, 2: Lottery, 3: Loan, 4: Settings

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF3F5F8), // Soft off-white layout background
      body: SafeArea(
        child: Column(
          children: [
            // Scrollable Content
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    _buildNavContent(),
                  ],
                ),
              ),
            ),
            // Custom Bottom Navigation Footer
            CustomBottomNavBar(
              selectedIndex: _selectedNavIndex,
              onTabSelected: (index) {
                setState(() {
                  _selectedNavIndex = index;
                });
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
        return _buildPlaceholderTab('Community Screen', Icons.people_alt_rounded);
      case 2:
        return _buildPlaceholderTab('Lottery Screen', Icons.local_activity_rounded);
      case 3:
        return _buildPlaceholderTab('Loan Screen', Icons.monetization_on_rounded);
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

  // Main Home Dashboard implementation
  Widget _buildHomeDashboard() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // 1. Profile Top Bar
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  const CircleAvatar(
                    radius: 20,
                    backgroundImage: NetworkImage(
                      'https://images.unsplash.com/photo-1472099645785-5658abf4ff4e?w=150',
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
          ),
          const SizedBox(height: 16),

          // 2. Custom Slider Tab Switcher (Trader vs Other)
          Container(
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
          ),
          const SizedBox(height: 16),

          // 3. Digital Passbook Balance Card
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [
                  Color(0xFF0F4C3A),
                  Color(0xFF0A3427),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Digital Passbook balance',
                  style: GoogleFonts.outfit(
                    fontSize: 13,
                    color: Colors.white70,
                  ),
                ),
                const SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      '₹1,42,850.00',
                      style: GoogleFonts.outfit(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Colors.white.withAlpha(26),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: const Icon(
                        Icons.import_contacts_rounded,
                        color: Colors.white,
                        size: 20,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Text(
                  'Last Update : Today, 10:30 AM',
                  style: GoogleFonts.outfit(
                    fontSize: 11,
                    color: Colors.white60,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),

          // 4. Join Trader Community Banner
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: const Color(0xFFE5E7EB)),
            ),
            child: Column(
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: const BoxDecoration(
                    color: Color(0xFFF0F5F2),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.people_alt_rounded,
                    color: Color(0xFF0F4C3A),
                    size: 24,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Join the trader community',
                  style: GoogleFonts.outfit(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: const Color(0xFF0F4C3A),
                  ),
                ),
                const SizedBox(height: 12),
                ElevatedButton(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF0F4C3A),
                    elevation: 0,
                    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: Text(
                    'Join Community',
                    style: GoogleFonts.outfit(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),

          // 5. Material Sales Grid
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Material Sales',
                style: GoogleFonts.outfit(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: const Color(0xFF111827),
                ),
              ),
              TextButton(
                onPressed: () {},
                child: Text(
                  'See all',
                  style: GoogleFonts.outfit(
                    color: const Color(0xFF6B7280),
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),

          // Grid View
          GridView.count(
            crossAxisCount: 2,
            crossAxisSpacing: 12,
            mainAxisSpacing: 12,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            childAspectRatio: 0.85,
            children: [
              _buildMaterialCard(
                'Cement',
                '₹385/kg',
                'https://images.unsplash.com/photo-1589939705384-5185137a7f0f?w=300',
              ),
              _buildMaterialCard(
                'Concrete',
                '₹4500/m³',
                'https://images.unsplash.com/photo-1541888946425-d81bb19240f5?w=300',
              ),
              _buildMaterialCard(
                'Bricks',
                '₹ 7 / per brick',
                'https://images.unsplash.com/photo-1584622650111-993a426fbf0a?w=300',
              ),
              _buildMaterialCard(
                'Steel',
                '₹85/gm',
                'https://images.unsplash.com/photo-1504917595217-d4dc5ebe6122?w=300',
              ),
            ],
          ),
          const SizedBox(height: 24),

          // 6. Paid Installment Ratio Card
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: const Color(0xFFE5E7EB)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  'Paid Installment Ratio',
                  style: GoogleFonts.outfit(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: const Color(0xFF111827),
                  ),
                ),
                const SizedBox(height: 24),
                // Circular Ratio Diagram
                Center(
                  child: SizedBox(
                    width: 140,
                    height: 140,
                    child: Stack(
                      children: [
                        Center(
                          child: SizedBox(
                            width: 130,
                            height: 130,
                            child: CircularProgressIndicator(
                              value: 0.72,
                              strokeWidth: 12,
                              backgroundColor: const Color(0xFFE5E7EB),
                              valueColor: const AlwaysStoppedAnimation<Color>(
                                Color(0xFF0F4C3A),
                              ),
                            ),
                          ),
                        ),
                        Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                '72%',
                                style: GoogleFonts.outfit(
                                  fontSize: 26,
                                  fontWeight: FontWeight.bold,
                                  color: const Color(0xFF0F4C3A),
                                ),
                              ),
                              Text(
                                'Paid',
                                style: GoogleFonts.outfit(
                                  fontSize: 12,
                                  color: const Color(0xFF6B7280),
                                ),
                              ),
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 24),
                // Legend
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Row(
                      children: [
                        Container(
                          width: 8,
                          height: 8,
                          decoration: const BoxDecoration(
                            shape: BoxShape.circle,
                            color: Color(0xFF0F4C3A),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          'Paid\n₹ 8.5L',
                          style: GoogleFonts.outfit(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            color: const Color(0xFF374151),
                          ),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        Container(
                          width: 8,
                          height: 8,
                          decoration: const BoxDecoration(
                            shape: BoxShape.circle,
                            color: Color(0xFFBFDBFE), // Soft light blue/grey
                          ),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          'Pending\n₹ 3.2L',
                          style: GoogleFonts.outfit(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            color: const Color(0xFF374151),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),

          // 7. కిష్ట ఇతిహాస (Installment History)
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'किश्त इतिहास (Installment History)',
                style: GoogleFonts.outfit(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: const Color(0xFF111827),
                ),
              ),
              IconButton(
                icon: const Icon(Icons.tune_rounded, size: 20),
                onPressed: () {},
              ),
            ],
          ),
          const SizedBox(height: 8),

          // History List
          _buildHistoryItem(
            title: 'Cement Bulk Order #827',
            date: '24 Oct, 2023 • 14:20',
            amount: '+ ₹ 24,500',
            status: 'SUCCESS',
            isSuccess: true,
            icon: Icons.store_rounded,
          ),
          _buildHistoryItem(
            title: 'Concrete Mixture Installment',
            date: '22 Oct, 2023 • 09:15',
            amount: '+ ₹ 18,200',
            status: 'SUCCESS',
            isSuccess: true,
            icon: Icons.local_shipping_rounded,
          ),
          _buildHistoryItem(
            title: 'Steel Rebar Purchase',
            date: '20 Oct, 2023 • 18:45',
            amount: '₹ 42,000',
            status: 'PENDING',
            isSuccess: false,
            icon: Icons.architecture_rounded,
          ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }

  // Material Sales Grid item card helper
  Widget _buildMaterialCard(String title, String price, String imageUrl) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFE5E7EB)),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(11),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              child: Image.network(
                imageUrl,
                fit: BoxFit.cover,
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: GoogleFonts.outfit(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: const Color(0xFF111827),
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    price,
                    style: GoogleFonts.outfit(
                      fontSize: 11,
                      color: const Color(0xFF6B7280),
                    ),
                  ),
                  const SizedBox(height: 8),
                  SizedBox(
                    width: double.infinity,
                    height: 32,
                    child: OutlinedButton(
                      onPressed: () {},
                      style: OutlinedButton.styleFrom(
                        side: const BorderSide(color: Color(0xFF0F4C3A)),
                        padding: EdgeInsets.zero,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(6),
                        ),
                      ),
                      child: Text(
                        '+ Add',
                        style: GoogleFonts.outfit(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          color: const Color(0xFF0F4C3A),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Installment History list item helper
  Widget _buildHistoryItem({
    required String title,
    required String date,
    required String amount,
    required String status,
    required bool isSuccess,
    required IconData icon,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFE5E7EB)),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: isSuccess ? const Color(0xFFF0F5F2) : const Color(0xFFF3F4F6),
              shape: BoxShape.circle,
            ),
            child: Icon(
              icon,
              color: isSuccess ? const Color(0xFF0F4C3A) : const Color(0xFF6B7280),
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
                    color: const Color(0xFF111827),
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  date,
                  style: GoogleFonts.outfit(
                    fontSize: 11,
                    color: const Color(0xFF6B7280),
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
                  color: isSuccess ? const Color(0xFF0F4C3A) : const Color(0xFF111827),
                ),
              ),
              const SizedBox(height: 4),
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
}
