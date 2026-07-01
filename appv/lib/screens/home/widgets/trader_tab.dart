import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../home_screen.dart';

class TraderTab extends StatelessWidget {
  const TraderTab({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // 1. Digital Passbook Balance Card
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

        // 2. Join Trader Community Banner
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
                onPressed: () {
                  HomeScreen.activeTabNotifier.value = 1; // Switch to Community tab
                },
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

        // 3. Material Sales Grid Header
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

        // 4. Paid Installment Ratio Card
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
                          color: Color(0xFFBFDBFE),
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

        // 5. Installment History Header
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

        // Installment History Items
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
    );
  }

  Widget _buildMaterialCard(String title, String price, String imageUrl) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFE5E7EB)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
            child: ClipRRect(
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(16),
                topRight: Radius.circular(16),
              ),
              child: Image.network(
                imageUrl,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) => Container(
                  color: const Color(0xFF0F4C3A),
                  child: const Icon(Icons.broken_image, color: Colors.white, size: 30),
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: GoogleFonts.outfit(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: const Color(0xFF1E293B),
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  price,
                  style: GoogleFonts.outfit(
                    fontSize: 12,
                    color: const Color(0xFF0F4C3A),
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHistoryItem({
    required String title,
    required String date,
    required String amount,
    required String status,
    required bool isSuccess,
    required IconData icon,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
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
              color: isSuccess ? const Color(0xFFF0F5F2) : const Color(0xFFFEF2F2),
              shape: BoxShape.circle,
            ),
            child: Icon(
              icon,
              color: isSuccess ? const Color(0xFF0F4C3A) : const Color(0xFFEF4444),
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
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: GoogleFonts.outfit(
                    fontSize: 13,
                    fontWeight: FontWeight.bold,
                    color: const Color(0xFF1E293B),
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  date,
                  style: GoogleFonts.outfit(
                    fontSize: 10,
                    color: const Color(0xFF9CA3AF),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                amount,
                style: GoogleFonts.outfit(
                  fontSize: 13,
                  fontWeight: FontWeight.bold,
                  color: isSuccess ? const Color(0xFF0F4C3A) : const Color(0xFFEF4444),
                ),
              ),
              const SizedBox(height: 2),
              Text(
                status,
                style: GoogleFonts.outfit(
                  fontSize: 9,
                  fontWeight: FontWeight.bold,
                  color: isSuccess ? const Color(0xFF10B981) : const Color(0xFFFBBF24),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
