import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'community_details_screen.dart';

class CommunityScreen extends StatefulWidget {
  final bool showAppBar;
  final ValueChanged<int>? onTabSelected;

  const CommunityScreen({
    super.key,
    this.showAppBar = false,
    this.onTabSelected,
  });

  @override
  State<CommunityScreen> createState() => _CommunityScreenState();
}

class _CommunityScreenState extends State<CommunityScreen> {
  int _activeFilterIndex = 0; // 0: All, 1: Trending

  void _joinCommunity({
    required String name,
    required String plan,
    required String goal,
    required String returnRate,
  }) async {
    final selectedIndex = await Navigator.push<int>(
      context,
      MaterialPageRoute(
        builder: (context) => CommunityDetailsScreen(
          name: name,
          plan: plan,
          goal: goal,
          returnRate: returnRate,
          groupId: name == 'Elite Investors Group'
              ? '#EIG-2024'
              : name == 'Infrastructure Collective'
                  ? '#INC-2024'
                  : '#URB-2024',
          category: name == 'Elite Investors Group'
              ? 'Premium Finance'
              : name == 'Infrastructure Collective'
                  ? 'Industrial Dev'
                  : 'Real Estate',
        ),
      ),
    );

    if (selectedIndex != null && mounted) {
      if (widget.onTabSelected != null) {
        widget.onTabSelected!(selectedIndex);
      } else {
        Navigator.pop(context, selectedIndex);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final body = SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Header Row: Title & All/Trending filter pills
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Available\nCommunities',
                style: GoogleFonts.outfit(
                  fontSize: 26,
                  fontWeight: FontWeight.w800,
                  color: const Color(0xFF0F4C3A),
                  height: 1.15,
                ),
              ),
              // Filter Switcher
              Container(
                decoration: BoxDecoration(
                  color: const Color(0xFFE5E7EB),
                  borderRadius: BorderRadius.circular(20),
                ),
                padding: const EdgeInsets.all(2),
                child: Row(
                  children: [
                    _buildFilterPill(0, 'All'),
                    _buildFilterPill(1, 'Trending'),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),

          // Community List Cards
          _buildCommunityCard(
            name: 'Elite Investors Group',
            imageUrl: 'https://images.unsplash.com/photo-1545324418-cc1a3fa10c00?w=150',
            plan: 'Monthly ₹10,000',
            goal: '₹50 Lakhs',
            returnRate: '14% p.a.',
          ),
          const SizedBox(height: 16),
          _buildCommunityCard(
            name: 'Infrastructure Collective',
            imageUrl: 'https://images.unsplash.com/photo-1581094288338-2314dddb7ecc?w=150',
            plan: 'Daily ₹500',
            goal: '₹25 Lakhs',
            returnRate: '12% p.a.',
          ),
          const SizedBox(height: 16),
          _buildCommunityCard(
            name: 'Urban Developers',
            imageUrl: 'https://images.unsplash.com/photo-1486406146926-c627a92ad1ab?w=150',
            plan: 'Monthly ₹7,500',
            goal: '₹40 Lakhs',
            returnRate: '13.5% p.a.',
          ),
          const SizedBox(height: 16),
        ],
      ),
    );

    if (widget.showAppBar) {
      return Scaffold(
        backgroundColor: const Color(0xFFF3F5F8),
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_ios_new_rounded, color: Color(0xFF111827)),
            onPressed: () => Navigator.pop(context),
          ),
        ),
        body: body,
      );
    } else {
      return Container(
        color: const Color(0xFFF3F5F8),
        child: body,
      );
    }
  }

  // Filter Pill Button builder
  Widget _buildFilterPill(int index, String label) {
    final isActive = _activeFilterIndex == index;
    return GestureDetector(
      onTap: () {
        setState(() {
          _activeFilterIndex = index;
        });
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: isActive ? const Color(0xFF0F4C3A) : Colors.transparent,
          borderRadius: BorderRadius.circular(18),
        ),
        child: Text(
          label,
          style: GoogleFonts.outfit(
            fontSize: 12,
            fontWeight: FontWeight.bold,
            color: isActive ? Colors.white : const Color(0xFF6B7280),
          ),
        ),
      ),
    );
  }

  // Community list card item builder
  Widget _buildCommunityCard({
    required String name,
    required String imageUrl,
    required String plan,
    required String goal,
    required String returnRate,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xFFE5E7EB)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(6),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Title Section
          Row(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: SizedBox(
                  width: 50,
                  height: 50,
                  child: Image.network(
                    imageUrl,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return Container(
                        color: const Color(0xFF0F4C3A),
                        alignment: Alignment.center,
                        child: const Icon(
                          Icons.people_alt_rounded,
                          color: Colors.white,
                          size: 24,
                        ),
                      );
                    },
                    loadingBuilder: (context, child, loadingProgress) {
                      if (loadingProgress == null) return child;
                      return Container(
                        color: const Color(0xFFF3F4F6),
                        alignment: Alignment.center,
                        child: const SizedBox(
                          width: 16,
                          height: 16,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF0F4C3A)),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Text(
                  name,
                  style: GoogleFonts.outfit(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: const Color(0xFF0F4C3A),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),

          // Details Block (Lavender/blue-grey background container)
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: const Color(0xFFF3F5FC), // Muted details background
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _buildDetailItem('PLAN', plan, false),
                    _buildDetailItem('GOAL', goal, false),
                  ],
                ),
                const SizedBox(height: 12),
                const Divider(color: Color(0xFFE5E7EB), height: 1),
                const SizedBox(height: 12),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    _buildDetailItem('PROJECTED RETURN', returnRate, true),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),

          // Join Community Button
          SizedBox(
            height: 48,
            child: ElevatedButton(
              onPressed: () => _joinCommunity(
                name: name,
                plan: plan,
                goal: goal,
                returnRate: returnRate,
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF0F4C3A),
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
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
          ),
        ],
      ),
    );
  }

  // Helper builder for detail key-value items
  Widget _buildDetailItem(String key, String value, bool isReturn) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          key,
          style: GoogleFonts.outfit(
            fontSize: 9,
            fontWeight: FontWeight.bold,
            color: const Color(0xFF9CA3AF),
            letterSpacing: 0.5,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: GoogleFonts.outfit(
            fontSize: 14,
            fontWeight: FontWeight.bold,
            color: isReturn ? const Color(0xFF10B981) : const Color(0xFF1F2937),
          ),
        ),
      ],
    );
  }
}
