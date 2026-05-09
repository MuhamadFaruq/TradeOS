import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/theme/app_colors.dart';
import '../../core/widgets/core_widgets.dart';
import '../../data/models/trade.dart';
import '../../data/providers/trade_provider.dart';
import 'analytics_dashboard.dart';
import 'journal_list_screen.dart';
import 'add_trade_screen.dart';
import 'trade_detail_screen.dart';
import 'profile_screen.dart';
import 'notification_screen.dart';
import 'risk_management_screen.dart';
import 'strategy_library_screen.dart';
import 'economic_calendar_screen.dart';
import 'ai_insights_screen.dart';
import 'community_screen.dart';
import 'goals_screen.dart';
import 'weekly_review_screen.dart';
import 'trade_replay_screen.dart';

class _HomeContent extends ConsumerWidget {
  const _HomeContent();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final trades = ref.watch(tradeProvider);
    final notifier = ref.read(tradeProvider.notifier);
    
    return CustomScrollView(
      slivers: [
        _buildAppBar(context),
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildPortfolioCard(context, notifier.totalPnL, trades.isNotEmpty),
                const SizedBox(height: 30),
                _buildActionGrid(context),
                const SizedBox(height: 30),
                _buildSecondaryActionGrid(context),
                const SizedBox(height: 30),
                _buildStatsRow(context, notifier.winRate, notifier.profitFactor),
                const SizedBox(height: 30),
                _buildSectionHeader(context, 'Recent Trades', () {
                  // Navigator.push(context, MaterialPageRoute(builder: (context) => const JournalListScreen()));
                }),
                const SizedBox(height: 16),
                _buildTradesList(context, trades),
                const SizedBox(height: 100), // Space for FAB
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildAppBar(BuildContext context) {
    return SliverAppBar(
      backgroundColor: AppColors.background,
      elevation: 0,
      pinned: true,
      centerTitle: false,
      title: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: AppColors.primary.withValues(alpha: 0.1),
            ),
            child: const Icon(Icons.auto_graph_rounded, color: AppColors.primary, size: 20),
          ),
          const SizedBox(width: 12),
          Text(
            'TradeOS',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.w900,
              letterSpacing: 1.2,
            ),
          ),
        ],
      ),
      actions: [
        IconButton(
          onPressed: () {
            Navigator.push(context, MaterialPageRoute(builder: (context) => const NotificationScreen()));
          },
          icon: const Icon(Icons.notifications_none_rounded, color: AppColors.textSecondary),
        ),
        const Padding(
          padding: EdgeInsets.only(right: 20, left: 8),
          child: CircleAvatar(
            radius: 18,
            backgroundColor: AppColors.surface,
            child: Icon(Icons.person_outline_rounded, color: AppColors.textPrimary, size: 20),
          ),
        ),
      ],
    );
  }

  Widget _buildPortfolioCard(BuildContext context, double totalPnL, bool hasTrades) {
    // If no trades, everything should be zero to satisfy "empty" requirement
    final double currentBalance = hasTrades ? (10000.00 + totalPnL) : 0.00;

    return GlassCard(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Portfolio Balance', style: Theme.of(context).textTheme.bodyMedium),
              if (hasTrades)
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: (totalPnL >= 0 ? AppColors.success : AppColors.danger).withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    totalPnL >= 0 ? '+\$${totalPnL.toStringAsFixed(2)}' : '-\$${totalPnL.abs().toStringAsFixed(2)}',
                    style: TextStyle(
                      color: totalPnL >= 0 ? AppColors.success : AppColors.danger,
                      fontWeight: FontWeight.bold,
                      fontSize: 12,
                    ),
                  ),
                ),
            ],
          ),
          const SizedBox(height: 12),
          Text('\$${currentBalance.toStringAsFixed(2)}', style: Theme.of(context).textTheme.displayLarge),
          const SizedBox(height: 24),
          // Placeholder for Chart
          Container(
            height: 100,
            width: double.infinity,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [AppColors.primary.withValues(alpha: 0.2), Colors.transparent],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
            child: CustomPaint(
              painter: ChartPainter(isFlat: totalPnL == 0),
            ),
          ),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: ['1M', '3M', '6M', '1Y', 'ALL'].map((e) {
              bool isSelected = e == '1M';
              return Text(
                e,
                style: TextStyle(
                  color: isSelected ? AppColors.primary : AppColors.textTertiary,
                  fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildStatsRow(BuildContext context, double winRate, double profitFactor) {
    // Simulated drawdown for now, or could be calculated
    final double drawdown = winRate > 0 ? 1.5 : 0.0;

    return Row(
      children: [
        Expanded(
          child: _buildStatItem(context, 'Win Rate', '${winRate.toStringAsFixed(1)}%', AppColors.success),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: _buildStatItem(context, 'Profit Factor', profitFactor.toStringAsFixed(2), AppColors.primary),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: _buildStatItem(context, 'Drawdown', '${drawdown.toStringAsFixed(1)}%', AppColors.danger),
        ),
      ],
    );
  }

  Widget _buildStatItem(BuildContext context, String label, String value, Color color) {
    return GlassCard(
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 12),
      child: Column(
        children: [
          Text(label, style: Theme.of(context).textTheme.labelSmall),
          const SizedBox(height: 8),
          Text(
            value,
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
              color: color,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(BuildContext context, String title, VoidCallback onSeeAll) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(title, style: Theme.of(context).textTheme.titleLarge),
        TextButton(
          onPressed: onSeeAll,
          child: const Text('See All', style: TextStyle(color: AppColors.primary)),
        ),
      ],
    );
  }

  Widget _buildTradesList(BuildContext context, List<Trade> trades) {
    if (trades.isEmpty) {
      return const Center(
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 40),
          child: Text('No trades logged yet.', style: TextStyle(color: AppColors.textTertiary)),
        ),
      );
    }

    final recentTrades = trades.take(5).toList();

    return ListView.separated(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: recentTrades.length,
      separatorBuilder: (context, index) => const SizedBox(height: 12),
      itemBuilder: (context, index) {
        final trade = recentTrades[index];
        return GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => TradeDetailScreen(trade: trade),
              ),
            );
          },
          child: GlassCard(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: (trade.status == TradeStatus.won ? AppColors.success : AppColors.danger).withValues(alpha: 0.1),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    trade.direction == TradeDirection.long ? Icons.arrow_outward_rounded : Icons.south_west_rounded,
                    color: trade.status == TradeStatus.won ? AppColors.success : AppColors.danger,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(trade.pair, style: Theme.of(context).textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.bold)),
                      Text(
                        '${trade.direction.name.toUpperCase()} • ${trade.strategy ?? "No Strategy"}',
                        style: Theme.of(context).textTheme.labelSmall,
                      ),
                    ],
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      '${trade.pnl >= 0 ? '+' : ''}\$${trade.pnl.toStringAsFixed(0)}',
                      style: TextStyle(
                        color: trade.pnl >= 0 ? AppColors.success : AppColors.danger,
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    Text(
                      '${trade.pnlPercentage.toStringAsFixed(2)}%',
                      style: Theme.of(context).textTheme.labelSmall,
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildActionGrid(BuildContext context) {
    return Row(
      children: [
        _ActionItem(
          icon: Icons.shield_rounded,
          label: 'Risk',
          onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const RiskManagementScreen())),
        ),
        const SizedBox(width: 12),
        _ActionItem(
          icon: Icons.menu_book_rounded,
          label: 'Playbook',
          onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const StrategyLibraryScreen())),
        ),
        const SizedBox(width: 12),
        _ActionItem(
          icon: Icons.calendar_today_rounded,
          label: 'Calendar',
          onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const EconomicCalendarScreen())),
        ),
        const SizedBox(width: 12),
        _ActionItem(
          icon: Icons.auto_awesome_rounded,
          label: 'AI Coach',
          onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const AIInsightsScreen())),
        ),
      ],
    );
  }

  Widget _buildSecondaryActionGrid(BuildContext context) {
    return Row(
      children: [
        _ActionItem(
          icon: Icons.history_rounded,
          label: 'Replay',
          onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const TradeReplayScreen())),
        ),
        const SizedBox(width: 12),
        _ActionItem(
          icon: Icons.emoji_events_rounded,
          label: 'Goals',
          onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const GoalsScreen())),
        ),
        const SizedBox(width: 12),
        _ActionItem(
          icon: Icons.summarize_rounded,
          label: 'Review',
          onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const WeeklyReviewScreen())),
        ),
        const SizedBox(width: 12),
        _ActionItem(
          icon: Icons.mic_rounded,
          label: 'Voice',
          onTap: () {},
        ),
      ],
    );
  }
}

class _ActionItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  const _ActionItem({required this.icon, required this.label, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: GlassCard(
          padding: const EdgeInsets.symmetric(vertical: 16),
          child: Column(
            children: [
              Icon(icon, color: AppColors.primary, size: 24),
              const SizedBox(height: 8),
              Text(label, style: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold)),
            ],
          ),
        ),
      ),
    );
  }
}

class HomeDashboard extends ConsumerStatefulWidget {
  const HomeDashboard({super.key});

  @override
  ConsumerState<HomeDashboard> createState() => _HomeDashboardState();
}

class _HomeDashboardState extends ConsumerState<HomeDashboard> {
  int _selectedIndex = 0;

  final List<Widget> _pages = [
    const _HomeContent(),
    const JournalListScreen(),
    const AnalyticsDashboard(),
    const CommunityScreen(),
    const ProfileScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      body: _pages[_selectedIndex],
      floatingActionButton: _selectedIndex == 0 ? _buildFAB() : null,
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: _buildBottomNav(),
    );
  }

  Widget _buildFAB() {
    return Container(
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withValues(alpha: 0.4),
            blurRadius: 20,
            spreadRadius: 2,
          ),
        ],
      ),
      child: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const AddTradeScreen()),
          );
        },
        backgroundColor: AppColors.primary,
        elevation: 0,
        child: const Icon(Icons.add_rounded, color: Colors.black, size: 32),
      ),
    );
  }

  Widget _buildBottomNav() {
    return ClipRect(
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
        child: Container(
          color: AppColors.background.withValues(alpha: 0.8),
          child: BottomNavigationBar(
            currentIndex: _selectedIndex,
            onTap: (index) => setState(() => _selectedIndex = index),
            backgroundColor: Colors.transparent,
            elevation: 0,
            type: BottomNavigationBarType.fixed,
            selectedItemColor: AppColors.primary,
            unselectedItemColor: AppColors.textTertiary,
            selectedLabelStyle: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold),
            unselectedLabelStyle: const TextStyle(fontSize: 10),
            items: const [
              BottomNavigationBarItem(icon: Icon(Icons.grid_view_rounded), label: 'Home'),
              BottomNavigationBarItem(icon: Icon(Icons.book_rounded), label: 'Journal'),
              BottomNavigationBarItem(icon: Icon(Icons.insights_rounded), label: 'Analytics'),
              BottomNavigationBarItem(icon: Icon(Icons.group_rounded), label: 'Community'),
              BottomNavigationBarItem(icon: Icon(Icons.person_rounded), label: 'Profile'),
            ],
          ),
        ),
      ),
    );
  }
}

class ChartPainter extends CustomPainter {
  final bool isFlat;
  ChartPainter({this.isFlat = false});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = AppColors.primary
      ..strokeWidth = 3
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    final path = Path();
    if (isFlat) {
      path.moveTo(0, size.height * 0.5);
      path.lineTo(size.width, size.height * 0.5);
    } else {
      path.moveTo(0, size.height * 0.8);
      path.quadraticBezierTo(size.width * 0.2, size.height * 0.2, size.width * 0.4, size.height * 0.6);
      path.quadraticBezierTo(size.width * 0.6, size.height * 0.9, size.width * 0.8, size.height * 0.3);
      path.lineTo(size.width, size.height * 0.1);
    }

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
