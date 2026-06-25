import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../../core/theme/app_colors.dart';
import '../../core/widgets/core_widgets.dart';
import '../../data/models/trade.dart';
import '../../data/providers/trade_provider.dart';
import 'trade_detail_screen.dart';
import 'dart:convert';
import 'dart:io' show File;
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:file_picker/file_picker.dart';
import '../../core/services/csv_import_service.dart';
import 'exchange_sync_screen.dart';

class JournalListScreen extends ConsumerStatefulWidget {
  const JournalListScreen({super.key});

  @override
  ConsumerState<JournalListScreen> createState() => _JournalListScreenState();
}

class _JournalListScreenState extends ConsumerState<JournalListScreen> {
  String _selectedFilter = 'All';
  final List<String> _filters = ['All', 'Won', 'Lost', 'Open'];
  String _selectedAssetFilter = 'All';
  final List<String> _assetFilters = ['All', 'Spot', 'Futures', 'Forex'];
  final _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _importCSV(BuildContext context) async {
    try {
      final result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['csv'],
      );

      if (result == null || result.files.isEmpty) return;

      if (!context.mounted) return;

      // Show a loading dialog
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => const Center(
          child: CircularProgressIndicator(color: AppColors.primary),
        ),
      );

      String csvContent = '';
      final fileObj = result.files.single;
      
      if (kIsWeb) {
        final bytes = fileObj.bytes;
        if (bytes != null) {
          csvContent = utf8.decode(bytes);
        }
      } else {
        final path = fileObj.path;
        if (path != null) {
          final file = File(path);
          csvContent = await file.readAsString();
        } else {
          final bytes = fileObj.bytes;
          if (bytes != null) {
            csvContent = utf8.decode(bytes);
          }
        }
      }

      if (csvContent.isEmpty) {
        if (context.mounted) {
          Navigator.pop(context); // Close loading dialog
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('File CSV kosong atau tidak terbaca.')),
          );
        }
        return;
      }

      final parsedTrades = CsvImportService.parseCsv(csvContent);

      if (context.mounted) {
        Navigator.pop(context); // Close loading dialog
      }

      if (parsedTrades.isEmpty) {
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Tidak ada data trade valid yang dapat diimpor.')),
          );
        }
        return;
      }

      if (!context.mounted) return;

      // Calculate statistics for preview
      final total = parsedTrades.length;
      final longs = parsedTrades.where((t) => t.direction == TradeDirection.long).length;
      final shorts = parsedTrades.where((t) => t.direction == TradeDirection.short).length;
      final wins = parsedTrades.where((t) => t.status == TradeStatus.won).length;
      final losses = parsedTrades.where((t) => t.status == TradeStatus.lost).length;
      final totalPnl = parsedTrades.fold(0.0, (sum, t) => sum + t.pnl);

      // Get unique pairs
      final pairs = parsedTrades.map((t) => t.pair).toSet().join(', ');

      // Show summary bottom sheet
      showModalBottomSheet(
        context: context,
        backgroundColor: AppColors.surface,
        isScrollControlled: true,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        ),
        builder: (context) => Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Ringkasan Impor CSV',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              const Text(
                'Tinjau data berikut sebelum menyimpan ke database lokal.',
                style: TextStyle(color: AppColors.textSecondary, fontSize: 13),
              ),
              const SizedBox(height: 24),
              GlassCard(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    _buildSummaryRow('Total Transaksi', '$total Trades'),
                    const Divider(color: Colors.white10),
                    _buildSummaryRow('Long / Short', '$longs L / $shorts S'),
                    const Divider(color: Colors.white10),
                    _buildSummaryRow('Win / Loss', '$wins W / $losses L'),
                    const Divider(color: Colors.white10),
                    _buildSummaryRow(
                      'Estimasi Total P&L',
                      '${totalPnl >= 0 ? '+' : ''}\$${totalPnl.toStringAsFixed(2)}',
                      valueColor: totalPnl >= 0 ? AppColors.success : AppColors.danger,
                    ),
                    const Divider(color: Colors.white10),
                    _buildSummaryRow('Daftar Pair', pairs, isTruncated: true),
                  ],
                ),
              ),
              const SizedBox(height: 32),
              Row(
                children: [
                  Expanded(
                    child: TextButton(
                      onPressed: () => Navigator.pop(context),
                      style: TextButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                      ),
                      child: const Text('BATAL', style: TextStyle(color: AppColors.textSecondary)),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: GlowingButton(
                      text: 'IMPOR DATA',
                      onPressed: () async {
                        Navigator.pop(context); // Close bottom sheet
                        // Add trades in batch
                        await ref.read(tradeProvider.notifier).addTrades(parsedTrades);
                        if (context.mounted) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text('Berhasil mengimpor $total data transaksi!'),
                              backgroundColor: AppColors.success,
                            ),
                          );
                        }
                      },
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
            ],
          ),
        ),
      );
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Terjadi kesalahan saat memproses file CSV: $e')),
        );
      }
    }
  }

  Widget _buildSummaryRow(String label, String value, {Color? valueColor, bool isTruncated = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(color: AppColors.textSecondary, fontSize: 13)),
          const SizedBox(width: 24),
          Expanded(
            child: Text(
              value,
              textAlign: TextAlign.end,
              overflow: isTruncated ? TextOverflow.ellipsis : TextOverflow.visible,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 14,
                color: valueColor ?? Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final trades = ref.watch(tradeProvider);
    
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          _buildSliverAppBar(),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
              child: Column(
                children: [
                  _buildSearchBar(),
                  const SizedBox(height: 20),
                  _buildFilterChips(),
                ],
              ),
            ),
          ),
          SliverPadding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            sliver: _buildTradesList(trades),
          ),
          const SliverToBoxAdapter(child: SizedBox(height: 100)),
        ],
      ),
    );
  }

  Widget _buildSliverAppBar() {
    return SliverAppBar(
      backgroundColor: AppColors.background,
      floating: true,
      title: const Text('Trading Journal', style: TextStyle(fontWeight: FontWeight.bold)),
      actions: [
        IconButton(
          icon: const Icon(Icons.sync_rounded, color: AppColors.primary),
          tooltip: 'API Auto-Sync',
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const ExchangeSyncScreen()),
            );
          },
        ),
        IconButton(
          icon: const Icon(Icons.file_upload_rounded, color: AppColors.primary),
          tooltip: 'Import CSV',
          onPressed: () => _importCSV(context),
        ),
        IconButton(
          icon: const Icon(Icons.filter_list_rounded, color: AppColors.primary),
          onPressed: () {
            showModalBottomSheet(
              context: context,
              backgroundColor: AppColors.surface,
              shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(24))),
              builder: (context) => StatefulBuilder(
                builder: (context, setSheetState) {
                  return Container(
                    padding: const EdgeInsets.all(24),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('Filter Options', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                        const SizedBox(height: 20),
                        const Text('Status', style: TextStyle(color: AppColors.textSecondary, fontSize: 12)),
                        const SizedBox(height: 12),
                        Wrap(
                          spacing: 8,
                          children: _filters.map((filter) {
                            bool isSelected = _selectedFilter == filter;
                            return ChoiceChip(
                              label: Text(filter),
                              selected: isSelected,
                              onSelected: (selected) {
                                if (selected) {
                                  setSheetState(() => _selectedFilter = filter);
                                  setState(() => _selectedFilter = filter);
                                }
                              },
                              backgroundColor: Colors.white.withValues(alpha: 0.05),
                              selectedColor: AppColors.primary.withValues(alpha: 0.2),
                            );
                          }).toList(),
                        ),
                        const SizedBox(height: 20),
                        const Text('Asset Class', style: TextStyle(color: AppColors.textSecondary, fontSize: 12)),
                        const SizedBox(height: 12),
                        Wrap(
                          spacing: 8,
                          children: _assetFilters.map((filter) {
                            bool isSelected = _selectedAssetFilter == filter;
                            return ChoiceChip(
                              label: Text(filter),
                              selected: isSelected,
                              onSelected: (selected) {
                                if (selected) {
                                  setSheetState(() => _selectedAssetFilter = filter);
                                  setState(() => _selectedAssetFilter = filter);
                                }
                              },
                              backgroundColor: Colors.white.withValues(alpha: 0.05),
                              selectedColor: AppColors.primary.withValues(alpha: 0.2),
                            );
                          }).toList(),
                        ),
                        const SizedBox(height: 32),
                        GlowingButton(
                          text: 'APPLY FILTERS',
                          onPressed: () => Navigator.pop(context),
                        ),
                        const SizedBox(height: 8),
                      ],
                    ),
                  );
                }
              ),
            );
          },
        ),
      ],
    );
  }

  Widget _buildSearchBar() {
    return GlassCard(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      child: TextField(
        controller: _searchController,
        onChanged: (v) => setState(() {}),
        decoration: const InputDecoration(
          hintText: 'Search trades, pairs, strategies...',
          border: InputBorder.none,
          icon: Icon(Icons.search_rounded, color: AppColors.textTertiary),
        ),
      ),
    );
  }

  Widget _buildFilterChips() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: _filters.map((filter) {
          bool isSelected = _selectedFilter == filter;
          return Padding(
            padding: const EdgeInsets.only(right: 12),
            child: ChoiceChip(
              label: Text(filter),
              selected: isSelected,
              onSelected: (selected) {
                if (selected) setState(() => _selectedFilter = filter);
              },
              backgroundColor: Colors.white.withValues(alpha: 0.05),
              selectedColor: AppColors.primary.withValues(alpha: 0.2),
              labelStyle: TextStyle(
                color: isSelected ? AppColors.primary : AppColors.textSecondary,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
                side: BorderSide(color: isSelected ? AppColors.primary : Colors.white10),
              ),
              showCheckmark: false,
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildTradesList(List<Trade> allTrades) {
    final query = _searchController.text.toLowerCase();
    
    final filteredTrades = allTrades.where((trade) {
      // Status Filter
      if (_selectedFilter != 'All') {
        if (_selectedFilter == 'Won' && trade.status != TradeStatus.won) return false;
        if (_selectedFilter == 'Lost' && trade.status != TradeStatus.lost) return false;
        if (_selectedFilter == 'Open' && trade.status != TradeStatus.open) return false;
      }
      
      // Asset Class Filter
      if (_selectedAssetFilter != 'All') {
        if (_selectedAssetFilter == 'Spot' && trade.assetClass != AssetClass.cryptoSpot) return false;
        if (_selectedAssetFilter == 'Futures' && trade.assetClass != AssetClass.cryptoFutures) return false;
        if (_selectedAssetFilter == 'Forex' && trade.assetClass != AssetClass.forex) return false;
      }
      
      // Search Filter
      if (query.isNotEmpty) {
        final matchesPair = trade.pair.toLowerCase().contains(query);
        final matchesStrategy = (trade.confluences?.join(', ') ?? '').toLowerCase().contains(query);
        if (!matchesPair && !matchesStrategy) return false;
      }
      
      return true;
    }).toList();

    if (filteredTrades.isEmpty) {
      return const SliverFillRemaining(
        hasScrollBody: false,
        child: Center(
          child: Text('No trades found.', style: TextStyle(color: AppColors.textTertiary)),
        ),
      );
    }

    return SliverList(
      delegate: SliverChildBuilderDelegate(
        (context, index) {
          final trade = filteredTrades[index];
          return Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => TradeDetailScreen(trade: trade)),
                );
              },
              child: Dismissible(
                key: Key(trade.id.toString()),
                direction: DismissDirection.endToStart,
                background: Container(
                  alignment: Alignment.centerRight,
                  padding: const EdgeInsets.only(right: 20),
                  decoration: BoxDecoration(
                    color: AppColors.danger.withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: const Icon(Icons.delete_outline_rounded, color: AppColors.danger),
                ),
                onDismissed: (_) {
                  ref.read(tradeProvider.notifier).deleteTrade(trade.id);
                },
                child: GlassCard(
                  enableBlur: false,
                  padding: const EdgeInsets.all(16),
                  child: Row(
                    children: [
                      _buildTradeStatusIndicator(trade),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              trade.pair,
                              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              '${trade.assetClass == AssetClass.forex ? 'FOREX' : (trade.assetClass == AssetClass.cryptoFutures ? 'FUTURES' : 'SPOT')} • ${trade.direction.name.toUpperCase()} • ${trade.confluences?.join(', ') ?? "No Confluences"}',
                              style: const TextStyle(color: AppColors.textTertiary, fontSize: 11),
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
                          const SizedBox(height: 4),
                          Text(
                            DateFormat('MMM dd, yyyy').format(trade.date),
                            style: const TextStyle(color: AppColors.textTertiary, fontSize: 10),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
        childCount: filteredTrades.length,
      ),
    );
  }

  Widget _buildTradeStatusIndicator(Trade trade) {
    bool isWon = trade.status == TradeStatus.won;
    Color color = isWon ? AppColors.success : AppColors.danger;
    
    return Container(
      width: 48,
      height: 48,
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withValues(alpha: 0.3)),
      ),
      child: Icon(
        trade.direction == TradeDirection.long ? Icons.arrow_outward_rounded : Icons.south_west_rounded,
        color: color,
      ),
    );
  }
}
