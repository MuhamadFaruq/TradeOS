import 'dart:io';
import 'package:csv/csv.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:share_plus/share_plus.dart';
import '../../data/models/trade.dart';
import '../../data/models/user_profile.dart';

class ExportService {
  static final DateFormat _dateFormat = DateFormat('yyyy-MM-dd HH:mm');

  // Export trades to CSV file and return the file path
  static Future<String> exportToCsv(List<Trade> trades) async {
    final List<List<dynamic>> rows = [
      [
        'ID',
        'Date',
        'Pair/Symbol',
        'Direction',
        'Asset Class',
        'Entry Price',
        'Exit Price',
        'Amount',
        'PnL',
        'PnL %',
        'Leverage',
        'Commission',
        'Swap',
        'Status',
        'Strategy',
        'Notes',
        'Emotion',
        'Session',
        'Confidence',
        'Rule Broken',
        'Broken Rule Name',
        'MAE',
        'MFE',
        'Stop Loss',
        'Take Profit',
        'Risk Reward Ratio'
      ]
    ];

    for (final trade in trades) {
      rows.add([
        trade.id,
        _dateFormat.format(trade.date),
        trade.pair,
        trade.direction.name,
        trade.assetClass.name,
        trade.entryPrice,
        trade.exitPrice ?? '',
        trade.amount,
        trade.pnl,
        trade.pnlPercentage,
        trade.leverage,
        trade.commission,
        trade.swap,
        trade.status.name,
        trade.confluences?.join(', ') ?? '',
        trade.notes ?? '',
        trade.emotion ?? '',
        trade.session ?? '',
        trade.confidence ?? '',
        trade.wasRuleBroken ? 'Yes' : 'No',
        trade.brokenRule ?? '',
        trade.mae ?? '',
        trade.mfe ?? '',
        trade.stopLossPrice ?? '',
        trade.takeProfitPrice ?? '',
        trade.plannedRRR ?? '',
      ]);
    }

    final csvContent = const ListToCsvConverter().convert(rows);
    final directory = await getTemporaryDirectory();
    final file = File('${directory.path}/tradeos_export_${DateTime.now().millisecondsSinceEpoch}.csv');
    await file.writeAsString(csvContent);
    return file.path;
  }

  // Export trades to a premium PDF report and return the file path
  static Future<String> exportToPdf(List<Trade> trades, UserProfile? profile) async {
    final pdf = pw.Document();

    // Calculate metrics
    final totalTrades = trades.length;
    final closedTrades = trades.where((t) => t.status == TradeStatus.won || t.status == TradeStatus.lost).toList();
    final winTrades = closedTrades.where((t) => t.status == TradeStatus.won).toList();
    final winRate = closedTrades.isEmpty ? 0.0 : (winTrades.length / closedTrades.length) * 100;
    
    final grossProfit = trades.where((t) => t.pnl > 0).fold(0.0, (sum, t) => sum + t.pnl);
    final grossLoss = trades.where((t) => t.pnl < 0).fold(0.0, (sum, t) => sum + t.pnl.abs());
    final profitFactor = grossLoss == 0 ? (grossProfit > 0 ? 999.0 : 1.0) : grossProfit / grossLoss;
    
    final totalPnL = trades.fold(0.0, (sum, t) => sum + t.pnl);
    final averagePnL = trades.isEmpty ? 0.0 : totalPnL / trades.length;

    pdf.addPage(
      pw.MultiPage(
        pageFormat: PdfPageFormat.a4,
        margin: const pw.EdgeInsets.all(32),
        build: (pw.Context context) {
          return [
            // Header
            pw.Row(
              mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
              children: [
                pw.Column(
                  crossAxisAlignment: pw.CrossAxisAlignment.start,
                  children: [
                    pw.Text('TRADEOS JOURNAL REPORT', style: pw.TextStyle(fontSize: 22, fontWeight: pw.FontWeight.bold, color: PdfColors.indigo900)),
                    pw.Text('Professional Trading Analytics & Performance', style: const pw.TextStyle(fontSize: 10, color: PdfColors.grey600)),
                  ],
                ),
                pw.Column(
                  crossAxisAlignment: pw.CrossAxisAlignment.end,
                  children: [
                    pw.Text('Generated: ${DateFormat('yyyy-MM-dd').format(DateTime.now())}', style: const pw.TextStyle(fontSize: 10, color: PdfColors.grey700)),
                    pw.Text('Trader: ${profile?.name ?? 'Alex Trader'}', style: pw.TextStyle(fontSize: 10, fontWeight: pw.FontWeight.bold)),
                  ],
                ),
              ],
            ),
            pw.SizedBox(height: 10),
            pw.Divider(color: PdfColors.indigo900, thickness: 1.5),
            pw.SizedBox(height: 15),

            // Performance Cards Grid
            pw.Row(
              children: [
                _buildMetricCard('Total Trades', '$totalTrades', PdfColors.indigo50),
                pw.SizedBox(width: 10),
                _buildMetricCard('Win Rate', '${winRate.toStringAsFixed(1)}%', winRate >= 50 ? PdfColors.green50 : PdfColors.red50),
                pw.SizedBox(width: 10),
                _buildMetricCard('Profit Factor', profitFactor.toStringAsFixed(2), profitFactor >= 1.5 ? PdfColors.green50 : PdfColors.indigo50),
                pw.SizedBox(width: 10),
                _buildMetricCard('Net P&L', '\$${totalPnL.toStringAsFixed(2)}', totalPnL >= 0 ? PdfColors.green50 : PdfColors.red50),
              ],
            ),
            pw.SizedBox(height: 20),

            // Detailed Analytics Row
            pw.Row(
              mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
              children: [
                pw.Expanded(
                  child: pw.Column(
                    crossAxisAlignment: pw.CrossAxisAlignment.start,
                    children: [
                      pw.Text('Overview Metrics', style: pw.TextStyle(fontSize: 12, fontWeight: pw.FontWeight.bold, color: PdfColors.indigo900)),
                      pw.SizedBox(height: 5),
                      _buildRowDetail('Starting Balance:', '\$${(profile?.initialBalance ?? 0.0).toStringAsFixed(2)}'),
                      _buildRowDetail('Average Trade P&L:', '\$${averagePnL.toStringAsFixed(2)}'),
                      _buildRowDetail('Gross Profit:', '\$${grossProfit.toStringAsFixed(2)}'),
                      _buildRowDetail('Gross Loss:', '-\$${grossLoss.toStringAsFixed(2)}'),
                    ],
                  ),
                ),
                pw.SizedBox(width: 30),
                pw.Expanded(
                  child: pw.Column(
                    crossAxisAlignment: pw.CrossAxisAlignment.start,
                    children: [
                      pw.Text('Risk Management', style: pw.TextStyle(fontSize: 12, fontWeight: pw.FontWeight.bold, color: PdfColors.indigo900)),
                      pw.SizedBox(height: 5),
                      _buildRowDetail('Rule Discipline Rate:', '${trades.isEmpty ? 100 : (((trades.length - trades.where((t) => t.wasRuleBroken).length) / trades.length) * 100).toStringAsFixed(1)}%'),
                      _buildRowDetail('Rule Breaches:', '${trades.where((t) => t.wasRuleBroken).length} times'),
                      _buildRowDetail('Forex Trades:', '${trades.where((t) => t.assetClass == AssetClass.forex).length}'),
                      _buildRowDetail('Crypto Trades:', '${trades.where((t) => t.assetClass != AssetClass.forex).length}'),
                    ],
                  ),
                ),
              ],
            ),
            pw.SizedBox(height: 25),

            // Transaction Table Title
            pw.Text('Recent Trades (Max 20)', style: pw.TextStyle(fontSize: 12, fontWeight: pw.FontWeight.bold, color: PdfColors.indigo900)),
            pw.SizedBox(height: 5),

            // Table of Trades
            pw.Table(
              border: pw.TableBorder.all(color: PdfColors.grey300, width: 0.5),
              columnWidths: {
                0: const pw.FlexColumnWidth(2),   // Date
                1: const pw.FlexColumnWidth(1.5), // Pair
                2: const pw.FlexColumnWidth(1.2), // Action
                3: const pw.FlexColumnWidth(1.5), // Entry
                4: const pw.FlexColumnWidth(1.5), // Exit
                5: const pw.FlexColumnWidth(1.8), // PnL ($)
                6: const pw.FlexColumnWidth(1.5), // MAE/MFE
              },
              children: [
                // Table Header
                pw.TableRow(
                  decoration: const pw.BoxDecoration(color: PdfColors.indigo900),
                  children: [
                    _buildTableHeaderText('Date'),
                    _buildTableHeaderText('Symbol'),
                    _buildTableHeaderText('Type'),
                    _buildTableHeaderText('Entry'),
                    _buildTableHeaderText('Exit'),
                    _buildTableHeaderText('P&L'),
                    _buildTableHeaderText('MAE/MFE'),
                  ],
                ),
                // Table Rows
                ...trades.take(20).map((trade) {
                  final sign = trade.pnl >= 0 ? '+' : '';
                  final color = trade.pnl >= 0 ? PdfColors.green900 : PdfColors.red900;
                  final maeStr = trade.mae != null ? trade.mae!.toStringAsFixed(2) : '-';
                  final mfeStr = trade.mfe != null ? trade.mfe!.toStringAsFixed(2) : '-';

                  return pw.TableRow(
                    children: [
                      _buildTableCellText(DateFormat('MM-dd HH:mm').format(trade.date)),
                      _buildTableCellText(trade.pair),
                      _buildTableCellText(trade.direction.name.toUpperCase()),
                      _buildTableCellText('\$${trade.entryPrice.toStringAsFixed(2)}'),
                      _buildTableCellText(trade.exitPrice != null ? '\$${trade.exitPrice!.toStringAsFixed(2)}' : '-'),
                      _buildTableCellText('$sign\$${trade.pnl.toStringAsFixed(2)}', color: color, fontWeight: pw.FontWeight.bold),
                      _buildTableCellText('$maeStr / $mfeStr'),
                    ],
                  );
                }),
              ],
            ),
          ];
        },
      ),
    );

    final directory = await getTemporaryDirectory();
    final file = File('${directory.path}/tradeos_report_${DateTime.now().millisecondsSinceEpoch}.pdf');
    await file.writeAsBytes(await pdf.save());
    return file.path;
  }

  // Helper metric card
  static pw.Widget _buildMetricCard(String label, String value, PdfColor bgColor) {
    return pw.Expanded(
      child: pw.Container(
        padding: const pw.EdgeInsets.symmetric(vertical: 10, horizontal: 8),
        decoration: pw.BoxDecoration(
          color: bgColor,
          borderRadius: const pw.BorderRadius.all(pw.Radius.circular(6)),
          border: pw.Border.all(color: PdfColors.grey300, width: 0.5),
        ),
        child: pw.Column(
          crossAxisAlignment: pw.CrossAxisAlignment.start,
          children: [
            pw.Text(label, style: const pw.TextStyle(fontSize: 8, color: PdfColors.grey700)),
            pw.SizedBox(height: 4),
            pw.Text(value, style: pw.TextStyle(fontSize: 14, fontWeight: pw.FontWeight.bold, color: PdfColors.indigo900)),
          ],
        ),
      ),
    );
  }

  // Helper row details
  static pw.Widget _buildRowDetail(String label, String value) {
    return pw.Padding(
      padding: const pw.EdgeInsets.symmetric(vertical: 2.0),
      child: pw.Row(
        mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
        children: [
          pw.Text(label, style: const pw.TextStyle(fontSize: 9, color: PdfColors.grey700)),
          pw.Text(value, style: pw.TextStyle(fontSize: 9, fontWeight: pw.FontWeight.bold, color: PdfColors.grey900)),
        ],
      ),
    );
  }

  // Helper table cells
  static pw.Widget _buildTableHeaderText(String text) {
    return pw.Padding(
      padding: const pw.EdgeInsets.all(6),
      child: pw.Text(
        text,
        style: pw.TextStyle(color: PdfColors.white, fontSize: 8, fontWeight: pw.FontWeight.bold),
        textAlign: pw.TextAlign.center,
      ),
    );
  }

  static pw.Widget _buildTableCellText(String text, {PdfColor color = PdfColors.grey900, pw.FontWeight? fontWeight}) {
    return pw.Padding(
      padding: const pw.EdgeInsets.all(6),
      child: pw.Text(
        text,
        style: pw.TextStyle(fontSize: 8, color: color, fontWeight: fontWeight),
        textAlign: pw.TextAlign.center,
      ),
    );
  }

  // Share exported file
  static Future<void> shareFile(String filePath, String subject) async {
    final xFile = XFile(filePath);
    await Share.shareXFiles([xFile], subject: subject);
  }
}
