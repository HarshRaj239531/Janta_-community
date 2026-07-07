import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class CustomBottomNavBar extends StatelessWidget {
  final int selectedIndex;
  final ValueChanged<int> onTabSelected;
  final bool showAllTabs;

  const CustomBottomNavBar({
    super.key,
    required this.selectedIndex,
    required this.onTabSelected,
    required this.showAllTabs,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(
          top: BorderSide(
            color: Colors.grey.shade200,
            width: 1.0,
          ),
        ),
      ),
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: showAllTabs
            ? [
                Expanded(child: _buildNavItem(context, 0, Icons.home_rounded, 'Home')),
                Expanded(child: _buildNavItem(context, 1, Icons.people_alt_rounded, 'Community')),
                Expanded(child: _buildNavItem(context, 2, Icons.local_activity_rounded, 'Lottery')),
                Expanded(child: _buildNavItem(context, 3, Icons.monetization_on_rounded, 'Loan')),
                Expanded(child: _buildNavItem(context, 4, Icons.settings_rounded, 'Settings')),
              ]
            : [
                Expanded(child: _buildNavItem(context, 0, Icons.home_rounded, 'Home')),
                Expanded(child: _buildNavItem(context, 4, Icons.settings_rounded, 'Settings')),
              ],
      ),
    );
  }

  Widget _buildNavItem(BuildContext context, int index, IconData icon, String label) {
    final isActive = selectedIndex == index;
    final theme = Theme.of(context);

    if (isActive) {
      return Center(
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          decoration: BoxDecoration(
            color: theme.colorScheme.primary, // Dark Green pill background
            borderRadius: BorderRadius.circular(20),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                icon,
                color: theme.colorScheme.secondary, // Mint active color
                size: 24,
              ),
              const SizedBox(height: 2),
              Text(
                label,
                maxLines: 1,
                softWrap: false,
                overflow: TextOverflow.visible,
                style: GoogleFonts.outfit(
                  fontSize: 11,
                  fontWeight: FontWeight.bold,
                  color: theme.colorScheme.secondary,
                ),
              ),
            ],
          ),
        ),
      );
    } else {
      return GestureDetector(
        onTap: () => onTabSelected(index),
        behavior: HitTestBehavior.opaque,
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                icon,
                color: theme.colorScheme.onSurfaceVariant, // Muted grey
                size: 24,
              ),
              const SizedBox(height: 4),
              Text(
                label,
                style: GoogleFonts.outfit(
                  fontSize: 10,
                  fontWeight: FontWeight.w500,
                  color: theme.colorScheme.onSurfaceVariant,
                ),
              ),
            ],
          ),
        ),
      );
    }
  }
}
