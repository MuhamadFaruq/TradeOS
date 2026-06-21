import 'package:csv/csv.dart';
import 'package:intl/intl.dart';
import '../../data/models/trade.dart';

class CsvImportService {
  /// Parses CSV content string and returns a list of [Trade] objects.
  static List<Trade> parseCsv(String csvContent) {
    // Determine the row/column separator automatically (comma, semicolon, tab)
    // We try to detect the separator by checking the first line's occurrence of delimiters.
    String separator = ',';
    final firstLine = csvContent.split('\n').first;
    if (firstLine.contains(';')) {
      separator = ';';
    } else if (firstLine.contains('\t')) {
      separator = '\t';
    }

    final converter = CsvToListConverter(
      fieldDelimiter: separator,
      shouldParseNumbers: true,
    );

    final List<List<dynamic>> rows = converter.convert(csvContent);
    if (rows.isEmpty) return [];

    final headers = rows.first.map((e) => e.toString().trim().toLowerCase()).toList();

    // Map column indices
    int idxDate = _findIndex(headers, ['date', 'time', 'opentime', 'datetime', 'timestamp', 'closetime', 'close time', 'open time']);
    int idxPair = _findIndex(headers, ['pair', 'symbol', 'instrument', 'asset', 'item']);
    int idxDirection = _findIndex(headers, ['direction', 'type', 'action', 'side']);
    int idxEntry = _findIndex(headers, ['entryprice', 'openprice', 'entry', 'open price', 'price']);
    int idxExit = _findIndex(headers, ['exitprice', 'closeprice', 'exit', 'close price']);
    int idxAmount = _findIndex(headers, ['amount', 'size', 'volume', 'lots', 'qty', 'quantity']);
    int idxPnL = _findIndex(headers, ['pnl', 'profit', 'netprofit', 'gain', 'loss']);
    int idxPnLPercent = _findIndex(headers, ['pnl%', 'pnlpercent', 'pnl percentage', 'gain%']);
    int idxStatus = _findIndex(headers, ['status', 'result', 'outcome']);
    int idxStrategy = _findIndex(headers, ['strategy', 'setup', 'playbook']);
    int idxNotes = _findIndex(headers, ['notes', 'comment', 'description']);

    // If we don't have basic fields like Pair/Symbol or Direction or PnL/Profit, we can't parse it
    if (idxPair == -1 || idxDirection == -1) {
      throw const FormatException('Format CSV tidak dikenali. Kolom Pair/Symbol dan Direction/Type wajib ada.');
    }

    final List<Trade> trades = [];

    for (int i = 1; i < rows.length; i++) {
      final row = rows[i];
      if (row.isEmpty || row.every((element) => element == null || element.toString().trim().isEmpty)) {
        continue; // Skip empty rows
      }

      try {
        final pair = _getString(row, idxPair, 'UNKNOWN');
        
        // Parse Direction
        final rawDirection = _getString(row, idxDirection, 'long').toLowerCase();
        final direction = (rawDirection.contains('short') || rawDirection.contains('sell') || rawDirection.contains('s'))
            ? TradeDirection.short
            : TradeDirection.long;

        final entryPrice = _getDouble(row, idxEntry, 0.0);
        final exitPrice = idxExit != -1 ? _getNullableDouble(row, idxExit, null) : null;
        final amount = _getDouble(row, idxAmount, 1.0);
        final pnl = _getDouble(row, idxPnL, 0.0);
        
        double pnlPercentage = 0.0;
        if (idxPnLPercent != -1) {
          pnlPercentage = _getDouble(row, idxPnLPercent, 0.0);
        } else if (entryPrice > 0) {
          // Calculate if not provided
          final priceDiff = (exitPrice ?? entryPrice) - entryPrice;
          if (direction == TradeDirection.long) {
            pnlPercentage = (priceDiff / entryPrice) * 100;
          } else {
            pnlPercentage = (-priceDiff / entryPrice) * 100;
          }
        }

        // Parse Date
        DateTime date = DateTime.now();
        if (idxDate != -1) {
          final rawDate = _getString(row, idxDate, '');
          date = _parseDateTime(rawDate);
        }

        // Parse Status
        TradeStatus status = TradeStatus.open;
        if (idxStatus != -1) {
          final rawStatus = _getString(row, idxStatus, '').toLowerCase();
          if (rawStatus.contains('won') || rawStatus.contains('win') || rawStatus.contains('w')) {
            status = TradeStatus.won;
          } else if (rawStatus.contains('lost') || rawStatus.contains('loss') || rawStatus.contains('l')) {
            status = TradeStatus.lost;
          } else if (rawStatus.contains('breakeven') || rawStatus.contains('be')) {
            status = TradeStatus.breakEven;
          } else if (rawStatus.contains('pending')) {
            status = TradeStatus.pending;
          } else if (rawStatus.contains('open')) {
            status = TradeStatus.open;
          }
        } else {
          // Infer status from P&L
          if (pnl > 0) {
            status = TradeStatus.won;
          } else if (pnl < 0) {
            status = TradeStatus.lost;
          } else if (exitPrice != null) {
            status = TradeStatus.breakEven;
          } else {
            status = TradeStatus.open;
          }
        }

        final strategy = idxStrategy != -1 ? _getNullableString(row, idxStrategy, null) : null;
        final notes = idxNotes != -1 ? _getNullableString(row, idxNotes, null) : null;

        final trade = Trade.create(
          pair: pair,
          direction: direction,
          entryPrice: entryPrice,
          exitPrice: exitPrice,
          amount: amount,
          pnl: pnl,
          pnlPercentage: pnlPercentage,
          status: status,
          date: date,
          strategy: strategy,
          notes: notes,
        );

        trades.add(trade);
      } catch (e) {
        // Skip rows with parsing errors but log them or throw if critical
        print('Skipping row $i due to error: $e');
      }
    }

    return trades;
  }

  static int _findIndex(List<String> headers, List<String> synonyms) {
    for (var synonym in synonyms) {
      final index = headers.indexWhere((h) {
        final cleanH = h.replaceAll(RegExp(r'[^a-z0-9%]'), '');
        final cleanS = synonym.replaceAll(RegExp(r'[^a-z0-9%]'), '');
        return cleanH == cleanS || cleanH.contains(cleanS);
      });
      if (index != -1) return index;
    }
    return -1;
  }

  static String _getString(List<dynamic> row, int index, String defaultValue) {
    if (index < 0 || index >= row.length || row[index] == null) return defaultValue;
    return row[index].toString().trim();
  }

  static String? _getNullableString(List<dynamic> row, int index, String? defaultValue) {
    if (index < 0 || index >= row.length || row[index] == null) return defaultValue;
    final val = row[index].toString().trim();
    return val.isEmpty ? defaultValue : val;
  }

  static double _getDouble(List<dynamic> row, int index, double defaultValue) {
    if (index < 0 || index >= row.length || row[index] == null) return defaultValue;
    final val = row[index];
    if (val is num) return val.toDouble();
    final cleanStr = val.toString().replaceAll(RegExp(r'[^0-9.-]'), '');
    return double.tryParse(cleanStr) ?? defaultValue;
  }

  static double? _getNullableDouble(List<dynamic> row, int index, double? defaultValue) {
    if (index < 0 || index >= row.length || row[index] == null) return defaultValue;
    final val = row[index];
    if (val is num) return val.toDouble();
    final cleanStr = val.toString().replaceAll(RegExp(r'[^0-9.-]'), '');
    final parsed = double.tryParse(cleanStr);
    return parsed ?? defaultValue;
  }

  static DateTime _parseDateTime(String rawDate) {
    if (rawDate.isEmpty) return DateTime.now();

    // Remove any surrounding spaces or quotes
    final cleanStr = rawDate.trim().replaceAll('"', '').replaceAll("'", "");

    // Try standard ISO parsing (yyyy-MM-dd HH:mm:ss etc.)
    final parsed = DateTime.tryParse(cleanStr);
    if (parsed != null) return parsed;

    // Clean up formats like 2026.06.21 11:25:20
    final standardizedStr = cleanStr
        .replaceAll('.', '-')
        .replaceAll('/', '-');
    final standardParsed = DateTime.tryParse(standardizedStr);
    if (standardParsed != null) return standardParsed;

    // Try custom formats
    try {
      // e.g. dd-MM-yyyy HH:mm:ss or MM-dd-yyyy HH:mm:ss
      final List<String> formats = [
        'dd-MM-yyyy HH:mm:ss',
        'dd-MM-yyyy HH:mm',
        'dd-MM-yyyy',
        'yyyy-MM-dd HH:mm:ss',
        'yyyy-MM-dd HH:mm',
        'MM-dd-yyyy HH:mm:ss',
        'MM-dd-yyyy',
      ];
      
      for (var format in formats) {
        try {
          return DateFormat(format).parse(standardizedStr);
        } catch (_) {}
      }
    } catch (_) {}

    return DateTime.now();
  }
}
