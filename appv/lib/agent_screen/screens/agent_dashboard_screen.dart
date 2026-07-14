import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../constants/agent_colors.dart';
import '../provider/agent_provider.dart';
import '../widgets/agent_header.dart';
import '../widgets/stats_cards.dart';
import '../widgets/quick_actions.dart';
import '../widgets/recent_activity.dart';

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
        child: RefreshIndicator(
          onRefresh: () async {
            await Provider.of<AgentProvider>(context, listen: false).fetchDashboard();
          },
          child: Consumer<AgentProvider>(
            builder: (context, agentProvider, child) {
              if (agentProvider.isDashboardLoading && agentProvider.dashboard == null) {
                return const Center(child: CircularProgressIndicator(color: AgentColors.primaryGreen));
              }
              if (agentProvider.dashboardError != null && agentProvider.dashboard == null) {
                return SingleChildScrollView(
                  physics: const AlwaysScrollableScrollPhysics(),
                  child: Container(
                    height: MediaQuery.of(context).size.height * 0.7,
                    alignment: Alignment.center,
                    child: Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Text(
                        agentProvider.dashboardError!,
                        textAlign: TextAlign.center,
                        style: const TextStyle(color: Colors.red),
                      ),
                    ),
                  ),
                );
              }
              
              return SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
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
                    
                    const SizedBox(height: 24),
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
