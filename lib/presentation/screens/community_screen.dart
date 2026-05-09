import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../../core/widgets/core_widgets.dart';

class CommunityScreen extends StatelessWidget {
  const CommunityScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          title: const Text('Community', style: TextStyle(fontWeight: FontWeight.bold)),
          bottom: const TabBar(
            tabs: [
              Tab(text: 'Feed'),
              Tab(text: 'Mentors'),
              Tab(text: 'Leaders'),
            ],
            indicatorColor: AppColors.primary,
            labelColor: AppColors.primary,
            unselectedLabelColor: AppColors.textTertiary,
          ),
        ),
        body: TabBarView(
          children: [
            _buildJournalFeed(),
            _buildMentorReview(),
            _buildLeaderboard(),
          ],
        ),
      ),
    );
  }

  Widget _buildJournalFeed() {
    return ListView.separated(
      padding: const EdgeInsets.all(20),
      itemCount: 5,
      separatorBuilder: (context, index) => const SizedBox(height: 20),
      itemBuilder: (context, index) {
        return GlassCard(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  const CircleAvatar(backgroundColor: AppColors.surface, child: Text('JD')),
                  const SizedBox(width: 12),
                  const Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('John Doe', style: TextStyle(fontWeight: FontWeight.bold)),
                      Text('2 hours ago', style: TextStyle(color: AppColors.textTertiary, fontSize: 10)),
                    ],
                  ),
                  const Spacer(),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(color: AppColors.success.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(4)),
                    child: const Text('LONG BTC', style: TextStyle(color: AppColors.success, fontWeight: FontWeight.bold, fontSize: 10)),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              const Text(
                'Caught the H4 breakout! Confluence: RSI divergence + Volume spike.',
                style: TextStyle(fontSize: 13, height: 1.4),
              ),
              const SizedBox(height: 16),
              Container(
                height: 150,
                width: double.infinity,
                decoration: BoxDecoration(borderRadius: BorderRadius.circular(12), color: AppColors.surface),
                child: const Icon(Icons.show_chart_rounded, color: Colors.white10, size: 40),
              ),
              const SizedBox(height: 16),
              const Row(
                children: [
                  Icon(Icons.favorite_border_rounded, size: 18, color: AppColors.textTertiary),
                  SizedBox(width: 4),
                  Text('24', style: TextStyle(color: AppColors.textTertiary, fontSize: 12)),
                  SizedBox(width: 20),
                  Icon(Icons.comment_outlined, size: 18, color: AppColors.textTertiary),
                  SizedBox(width: 4),
                  Text('8', style: TextStyle(color: AppColors.textTertiary, fontSize: 12)),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildMentorReview() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.verified_user_rounded, color: AppColors.primary, size: 64),
          const SizedBox(height: 24),
          const Text('Get Professional Review', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
          const SizedBox(height: 12),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 40),
            child: Text(
              'Submit your journal to top-tier prop firm traders for a detailed performance review.',
              textAlign: TextAlign.center,
              style: TextStyle(color: AppColors.textSecondary),
            ),
          ),
          const SizedBox(height: 32),
          GlowingButton(text: 'FIND A MENTOR', onPressed: () {}),
        ],
      ),
    );
  }

  Widget _buildLeaderboard() {
    return ListView.builder(
      padding: const EdgeInsets.all(20),
      itemCount: 10,
      itemBuilder: (context, index) {
        return Padding(
          padding: const EdgeInsets.only(bottom: 12),
          child: GlassCard(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
            child: Row(
              children: [
                Text('${index + 1}', style: const TextStyle(fontWeight: FontWeight.bold, color: AppColors.primary)),
                const SizedBox(width: 20),
                const CircleAvatar(radius: 16, backgroundColor: AppColors.surface),
                const SizedBox(width: 16),
                const Expanded(child: Text('Trader_X', style: TextStyle(fontWeight: FontWeight.bold))),
                const Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text('89.4', style: TextStyle(color: AppColors.success, fontWeight: FontWeight.bold)),
                    Text('Consistency Score', style: TextStyle(fontSize: 8, color: AppColors.textTertiary)),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
