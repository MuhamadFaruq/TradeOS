import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../../core/theme/app_colors.dart';
import '../../core/widgets/core_widgets.dart';
import '../../data/models/economic_event.dart';
import '../../data/providers/economic_calendar_provider.dart';

class EconomicCalendarScreen extends ConsumerStatefulWidget {
  const EconomicCalendarScreen({super.key});

  @override
  ConsumerState<EconomicCalendarScreen> createState() => _EconomicCalendarScreenState();
}

class _EconomicCalendarScreenState extends ConsumerState<EconomicCalendarScreen> {
  late Timer _timer;
  bool _onlyHighImpact = false;
  DateTime _selectedDate = DateTime.now();

  @override
  void initState() {
    super.initState();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (mounted) setState(() {});
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final calendarState = ref.watch(economicCalendarProvider);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Economic Calendar', style: TextStyle(fontWeight: FontWeight.bold)),
            Text(
              'Local Time: GMT ${DateTime.now().timeZoneOffset.inHours >= 0 ? '+' : ''}${DateTime.now().timeZoneOffset.inHours}:00',
              style: const TextStyle(fontSize: 10, color: AppColors.textTertiary),
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: Icon(
              _onlyHighImpact ? Icons.filter_alt_rounded : Icons.filter_alt_outlined,
              color: _onlyHighImpact ? AppColors.danger : AppColors.textSecondary,
            ),
            onPressed: () => setState(() => _onlyHighImpact = !_onlyHighImpact),
          ),
          IconButton(
            icon: const Icon(Icons.refresh_rounded),
            onPressed: () => ref.read(economicCalendarRefreshProvider)(),
          ),
        ],
      ),
      body: Column(
        children: [
          _buildDaySelector(),
          Expanded(
            child: calendarState.when(
              data: (events) {
                final filteredEvents = events.where((e) {
                  final sameDay = e.date.year == _selectedDate.year &&
                      e.date.month == _selectedDate.month &&
                      e.date.day == _selectedDate.day;
                  
                  if (!sameDay) return false;
                  if (_onlyHighImpact && e.impact != Impact.high) return false;
                  return true;
                }).toList();
                
                if (filteredEvents.isEmpty) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.event_busy_rounded, size: 48, color: AppColors.textTertiary.withValues(alpha: 0.3)),
                        const SizedBox(height: 16),
                        const Text('No Events Scheduled', style: TextStyle(color: AppColors.textTertiary)),
                      ],
                    ),
                  );
                }

                return ListView.separated(
                  padding: const EdgeInsets.all(20),
                  itemCount: filteredEvents.length,
                  separatorBuilder: (context, index) => const SizedBox(height: 12),
                  itemBuilder: (context, index) {
                    return _buildEventCard(filteredEvents[index]);
                  },
                );
              },
              loading: () => const Center(child: CircularProgressIndicator(color: AppColors.primary)),
              error: (err, _) => Center(child: Text('Error: $err', style: const TextStyle(color: AppColors.danger))),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDaySelector() {
    final now = DateTime.now();
    return Container(
      height: 80,
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 20),
        itemCount: 7,
        itemBuilder: (context, index) {
          final date = now.add(Duration(days: index));
          final bool isSelected = date.year == _selectedDate.year &&
              date.month == _selectedDate.month &&
              date.day == _selectedDate.day;
          
          return GestureDetector(
            onTap: () => setState(() => _selectedDate = date),
            child: Container(
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
                  Text(DateFormat('MMM').format(date).toUpperCase(), style: TextStyle(color: isSelected ? AppColors.primary : AppColors.textTertiary, fontSize: 10)),
                  Text('${date.day}', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: isSelected ? AppColors.primary : Colors.white)),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildEventCard(EconomicEvent event) {
    final color = event.impact == Impact.high ? AppColors.danger : (event.impact == Impact.medium ? AppColors.warning : AppColors.textTertiary);
    final timeDiff = event.date.difference(DateTime.now());
    final bool isSoon = timeDiff.inMinutes > 0 && timeDiff.inMinutes < 60;

    return GlassCard(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          Row(
            children: [
              Column(
                children: [
                  Text(DateFormat('HH:mm').format(event.date), style: const TextStyle(fontWeight: FontWeight.bold)),
                  const SizedBox(height: 4),
                  Text(event.currency, style: const TextStyle(color: AppColors.textSecondary, fontSize: 12)),
                ],
              ),
              const SizedBox(width: 20),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(event.title, style: const TextStyle(fontWeight: FontWeight.bold)),
                    const SizedBox(height: 4),
                    Text(
                      'Actual: ${event.actual ?? "-"} | Forecast: ${event.forecast ?? "N/A"} | Previous: ${event.previous ?? "N/A"}',
                      style: const TextStyle(color: AppColors.textTertiary, fontSize: 10),
                    ),
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
                child: Text(
                  event.impact.name.toUpperCase(),
                  style: TextStyle(color: color, fontSize: 10, fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),
          if (timeDiff.inSeconds > 0) ...[
            const SizedBox(height: 12),
            const Divider(color: Colors.white10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Icon(
                      Icons.timer_outlined,
                      size: 14,
                      color: isSoon ? AppColors.danger : AppColors.textTertiary,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      'RELEASING IN',
                      style: TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                        color: isSoon ? AppColors.danger : AppColors.textTertiary,
                        letterSpacing: 1.2,
                      ),
                    ),
                  ],
                ),
                Text(
                  _formatDuration(timeDiff),
                  style: TextStyle(
                    color: isSoon ? AppColors.danger : AppColors.primary,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'monospace',
                  ),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }

  String _formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, "0");
    String twoDigitMinutes = twoDigits(duration.inMinutes.remainder(60));
    String twoDigitSeconds = twoDigits(duration.inSeconds.remainder(60));
    return "${twoDigits(duration.inHours)}:$twoDigitMinutes:$twoDigitSeconds";
  }
}
