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
  DateTime? _lastAutoRefresh;

  @override
  void initState() {
    super.initState();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (mounted) {
        setState(() {});
        _checkAndAutoRefreshNews();
      }
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  void _checkAndAutoRefreshNews() {
    final calendarState = ref.read(economicCalendarProvider);
    final events = calendarState.asData?.value;
    if (events == null || events.isEmpty) return;

    final now = DateTime.now();
    bool needsRefresh = false;

    for (var event in events) {
      if (event.actual == null || event.actual!.isEmpty) {
        final diff = event.date.difference(now);
        // Event releases in next 30 seconds or has released up to 2 minutes ago
        if (diff.inSeconds >= -120 && diff.inSeconds <= 30) {
          needsRefresh = true;
          break;
        }
      }
    }

    if (needsRefresh) {
      // Throttle auto-refresh to at most once every 10 seconds
      if (_lastAutoRefresh == null || now.difference(_lastAutoRefresh!) > const Duration(seconds: 10)) {
        _lastAutoRefresh = now;
        ref.read(economicCalendarRefreshProvider)();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final calendarState = ref.watch(economicCalendarProvider);
    final isRefreshing = ref.watch(calendarRefreshingProvider);

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
            icon: isRefreshing
                ? const SizedBox(
                    width: 18,
                    height: 18,
                    child: CircularProgressIndicator(color: AppColors.primary, strokeWidth: 2),
                  )
                : const Icon(Icons.refresh_rounded),
            onPressed: isRefreshing ? null : () => ref.read(economicCalendarRefreshProvider)(),
          ),
        ],
      ),
      body: Column(
        children: [
          _buildDaySelector(calendarState.asData?.value ?? []),
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

  Widget _buildDaySelector(List<EconomicEvent> events) {
    final now = DateTime.now();
    // Start from 3 days ago to 7 days ahead to show "historical" context
    final startDate = now.subtract(const Duration(days: 3));
    
    return Container(
      height: 90,
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Row(
        children: [
          // Date Picker Trigger
          Padding(
            padding: const EdgeInsets.only(left: 20, right: 8),
            child: GestureDetector(
              onTap: () async {
                final picked = await showDatePicker(
                  context: context,
                  initialDate: _selectedDate,
                  firstDate: DateTime.now().subtract(const Duration(days: 365)),
                  lastDate: DateTime.now().add(const Duration(days: 365)),
                  builder: (context, child) {
                    return Theme(
                      data: Theme.of(context).copyWith(
                        colorScheme: ColorScheme.dark(
                          primary: AppColors.primary,
                          onPrimary: Colors.white,
                          surface: AppColors.surface,
                          onSurface: Colors.white,
                        ),
                      ),
                      child: child!,
                    );
                  },
                );
                if (picked != null) {
                  setState(() => _selectedDate = picked);
                }
              },
              child: Container(
                width: 50,
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.05),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: Colors.white10),
                ),
                child: const Icon(Icons.calendar_month_rounded, color: AppColors.primary),
              ),
            ),
          ),
          
          Expanded(
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.only(right: 20),
              itemCount: 14, // Show 2 weeks of quick selection
              itemBuilder: (context, index) {
                final date = startDate.add(Duration(days: index));
                final bool isSelected = date.year == _selectedDate.year &&
                    date.month == _selectedDate.month &&
                    date.day == _selectedDate.day;
                final bool isToday = date.year == now.year &&
                    date.month == now.month &&
                    date.day == now.day;
                
                final eventsForDate = events.where((e) =>
                    e.date.year == date.year &&
                    e.date.month == date.month &&
                    e.date.day == date.day).toList();

                final hasHigh = eventsForDate.any((e) => e.impact == Impact.high);
                final hasMedium = eventsForDate.any((e) => e.impact == Impact.medium);
                final hasLow = eventsForDate.any((e) => e.impact == Impact.low);
                
                return GestureDetector(
                  onTap: () => setState(() => _selectedDate = date),
                  child: Container(
                    width: 60,
                    margin: const EdgeInsets.only(right: 12),
                    decoration: BoxDecoration(
                      color: isSelected ? AppColors.primary.withValues(alpha: 0.1) : (isToday ? Colors.white.withValues(alpha: 0.05) : Colors.transparent),
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: isSelected ? AppColors.primary : (isToday ? AppColors.primary.withValues(alpha: 0.3) : Colors.white10)),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          DateFormat('E').format(date).toUpperCase(), 
                          style: TextStyle(
                            color: isSelected ? AppColors.primary : AppColors.textTertiary, 
                            fontSize: 10,
                            fontWeight: isToday ? FontWeight.bold : FontWeight.normal,
                          )
                        ),
                        Text(
                          '${date.day}', 
                          style: TextStyle(
                            fontWeight: FontWeight.bold, 
                            fontSize: 18, 
                            color: isSelected ? AppColors.primary : Colors.white
                          )
                        ),
                        const SizedBox(height: 4),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            if (hasHigh) _buildImpactDot(AppColors.danger),
                            if (hasMedium) _buildImpactDot(AppColors.warning),
                            if (hasLow) _buildImpactDot(AppColors.textTertiary),
                          ],
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildImpactDot(Color color) {
    return Container(
      width: 4,
      height: 4,
      margin: const EdgeInsets.symmetric(horizontal: 1),
      decoration: BoxDecoration(
        color: color,
        shape: BoxShape.circle,
      ),
    );
  }

  Widget _buildEventCard(EconomicEvent event) {
    final color = event.impact == Impact.high ? AppColors.danger : (event.impact == Impact.medium ? AppColors.warning : AppColors.textTertiary);
    final timeDiff = event.date.difference(DateTime.now());
    final bool isSoon = timeDiff.inMinutes > 0 && timeDiff.inMinutes < 60;

    return GestureDetector(
      onTap: () => _showEventDetailsBottomSheet(context, event),
      child: GlassCard(
        enableBlur: false,
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
    ),
  );
}

  String _formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, "0");
    String twoDigitMinutes = twoDigits(duration.inMinutes.remainder(60));
    String twoDigitSeconds = twoDigits(duration.inSeconds.remainder(60));
    return "${twoDigits(duration.inHours)}:$twoDigitMinutes:$twoDigitSeconds";
  }

  void _showEventDetailsBottomSheet(BuildContext context, EconomicEvent event) {
    final color = event.impact == Impact.high
        ? AppColors.danger
        : (event.impact == Impact.medium ? AppColors.warning : AppColors.textTertiary);
        
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) {
        return Container(
          decoration: BoxDecoration(
            color: AppColors.background.withValues(alpha: 0.95),
            borderRadius: const BorderRadius.vertical(top: Radius.circular(28)),
            border: Border.all(
              color: AppColors.surface.withValues(alpha: 0.5),
              width: 1.5,
            ),
          ),
          padding: const EdgeInsets.all(28),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: Colors.white24,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              const SizedBox(height: 24),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                    decoration: BoxDecoration(
                      color: color.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: color.withValues(alpha: 0.4)),
                    ),
                    child: Row(
                      children: [
                        Icon(Icons.warning_amber_rounded, color: color, size: 14),
                        const SizedBox(width: 6),
                        Text(
                          '${event.impact.name.toUpperCase()} IMPACT',
                          style: TextStyle(color: color, fontSize: 10, fontWeight: FontWeight.bold, letterSpacing: 1.0),
                        ),
                      ],
                    ),
                  ),
                  Row(
                    children: [
                      const Icon(Icons.public_rounded, color: AppColors.textTertiary, size: 16),
                      const SizedBox(width: 6),
                      Text(
                        '${event.currency} (${event.country})',
                        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 20),
              Text(
                event.title,
                style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, height: 1.3),
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  const Icon(Icons.calendar_month_rounded, color: AppColors.primary, size: 16),
                  const SizedBox(width: 8),
                  Text(
                    DateFormat('EEEE, dd MMMM yyyy - HH:mm').format(event.date),
                    style: const TextStyle(color: AppColors.textSecondary, fontSize: 12),
                  ),
                ],
              ),
              const SizedBox(height: 28),
              Row(
                children: [
                  Expanded(
                    child: _buildMetricDetailCard(
                      'ACTUAL', 
                      event.actual ?? '-', 
                      event.actual != null ? AppColors.success : AppColors.textTertiary,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _buildMetricDetailCard('FORECAST', event.forecast ?? 'N/A', Colors.white),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _buildMetricDetailCard('PREVIOUS', event.previous ?? 'N/A', Colors.white),
                  ),
                ],
              ),
              const SizedBox(height: 28),
              const Text(
                'AI MARKET ADVISORY',
                style: TextStyle(
                  color: AppColors.textTertiary, 
                  fontWeight: FontWeight.bold, 
                  letterSpacing: 1.5, 
                  fontSize: 10,
                ),
              ),
              const SizedBox(height: 12),
              GlassCard(
                enableBlur: false,
                padding: const EdgeInsets.all(16),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Icon(Icons.insights_rounded, color: AppColors.primary, size: 20),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        _generateAdvisoryText(event),
                        style: const TextStyle(color: AppColors.textSecondary, fontSize: 12, height: 1.5),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),
            ],
          ),
        );
      },
    );
  }

  Widget _buildMetricDetailCard(String label, String value, Color valueColor) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 8),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.03),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.white10),
      ),
      child: Column(
        children: [
          Text(label, style: const TextStyle(color: AppColors.textTertiary, fontSize: 10, fontWeight: FontWeight.bold, letterSpacing: 1.0)),
          const SizedBox(height: 8),
          Text(
            value,
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w900, color: valueColor),
          ),
        ],
      ),
    );
  }

  String _generateAdvisoryText(EconomicEvent event) {
    if (event.actual == null) {
      return 'Rilis data ekonomi ini dijadwalkan dalam waktu dekat. Volatilitas tinggi sering terjadi pada instrumen terkait dengan ${event.currency} sesaat sebelum dan sesudah rilis. Disarankan untuk membatasi risiko (SL) Anda.';
    }
    
    try {
      final actualNum = double.parse(event.actual!.replaceAll(RegExp(r'[^0-9.-]'), ''));
      final forecastNum = double.parse(event.forecast!.replaceAll(RegExp(r'[^0-9.-]'), ''));
      
      if (actualNum > forecastNum) {
        return 'Hasil Aktual (${event.actual}) lebih tinggi dibanding Forecast (${event.forecast}). Secara teori makro, rilis ini cenderung memberikan sentimen positif/Bullish bagi mata uang ${event.currency}.';
      } else if (actualNum < forecastNum) {
        return 'Hasil Aktual (${event.actual}) lebih rendah dibanding Forecast (${event.forecast}). Secara teori makro, rilis ini cenderung memberikan sentimen negatif/Bearish bagi mata uang ${event.currency}.';
      }
    } catch (_) {}
    
    return 'Data aktual saat ini dirilis sebesar ${event.actual}. Perhatikan pergerakan harga pada instrumen ${event.currency} untuk mengidentifikasi apakah deviasi data ini direspon secara impulsif oleh pasar.';
  }
}
