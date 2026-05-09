import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../../core/widgets/core_widgets.dart';

class EconomicCalendarScreen extends StatelessWidget {
  const EconomicCalendarScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text('Economic Calendar', style: TextStyle(fontWeight: FontWeight.bold)),
        actions: [
          IconButton(icon: const Icon(Icons.calendar_month_rounded), onPressed: () {}),
        ],
      ),
      body: Column(
        children: [
          _buildDaySelector(),
          Expanded(
            child: ListView.separated(
              padding: const EdgeInsets.all(20),
              itemCount: 10,
              separatorBuilder: (context, index) => const SizedBox(height: 12),
              itemBuilder: (context, index) {
                return _buildEventCard(index);
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDaySelector() {
    return Container(
      height: 80,
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 20),
        itemCount: 7,
        itemBuilder: (context, index) {
          bool isSelected = index == 0;
          return Container(
            width: 60,
            margin: const EdgeInsets.only(right: 12),
            decoration: BoxDecoration(
              color: isSelected ? AppColors.primary.withValues(alpha: 0.1) : Colors.white.withValues(alpha: 0.02),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: isSelected ? AppColors.primary : Colors.white10),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('MAY', style: TextStyle(color: isSelected ? AppColors.primary : AppColors.textTertiary, fontSize: 10)),
                Text('${8 + index}', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: isSelected ? AppColors.primary : Colors.white)),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildEventCard(int index) {
    final impacts = ['LOW', 'MED', 'HIGH'];
    final impact = impacts[index % 3];
    final color = impact == 'HIGH' ? AppColors.danger : (impact == 'MED' ? AppColors.warning : AppColors.textTertiary);

    return GlassCard(
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          const Column(
            children: [
              Text('13:30', style: TextStyle(fontWeight: FontWeight.bold)),
              SizedBox(height: 4),
              Text('USD', style: TextStyle(color: AppColors.textSecondary, fontSize: 12)),
            ],
          ),
          const SizedBox(width: 20),
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Non-Farm Payrolls (NFP)', style: TextStyle(fontWeight: FontWeight.bold)),
                SizedBox(height: 4),
                Text('Forecast: 180K | Previous: 175K', style: TextStyle(color: AppColors.textTertiary, fontSize: 12)),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(6),
              border: Border.all(color: color.withValues(alpha: 0.5)),
            ),
            child: Text(impact, style: TextStyle(color: color, fontSize: 10, fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );
  }
}
