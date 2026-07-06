import 'package:flutter/material.dart';
import '../constants/agent_colors.dart';
import '../widgets/agent_header.dart';
import '../widgets/stats_cards.dart';
import '../widgets/quick_actions.dart';
import '../widgets/recent_activity.dart';
import '../widgets/performance_banner.dart';

class AgentDashboardScreen extends StatelessWidget {
  final VoidCallback onViewTransactions;

  const AgentDashboardScreen({
    super.key,
    required this.onViewTransactions,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AgentColors.backgroundSoft,
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Header section
              const AgentHeader(),
              
              // Stats cards section
              const StatsCards(),
              
              // Quick Actions section
              QuickActions(onViewTransactions: onViewTransactions),
              
              // Recent Activity section
              RecentActivity(onViewAll: onViewTransactions),
              
              // Performance Banner section
              const PerformanceBanner(),
              
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }
}
