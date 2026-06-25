import 'dart:convert';
import 'package:crypto/crypto.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../../data/models/trade.dart';

class ExchangeApiService {
  static const _secureStorage = FlutterSecureStorage();
  
  static const String binanceApiKey = 'binance_api_key';
  static const String binanceApiSecret = 'binance_api_secret';
  static const String bybitApiKey = 'bybit_api_key';
  static const String bybitApiSecret = 'bybit_api_secret';

  // Securely save credentials
  static Future<void> saveCredentials({
    required String exchange,
    required String apiKey,
    required String apiSecret,
  }) async {
    if (exchange.toLowerCase() == 'binance') {
      await _secureStorage.write(key: binanceApiKey, value: apiKey);
      await _secureStorage.write(key: binanceApiSecret, value: apiSecret);
    } else {
      await _secureStorage.write(key: bybitApiKey, value: apiKey);
      await _secureStorage.write(key: bybitApiSecret, value: apiSecret);
    }
  }

  // Retrieve credentials
  static Future<Map<String, String?>> getCredentials(String exchange) async {
    if (exchange.toLowerCase() == 'binance') {
      final key = await _secureStorage.read(key: binanceApiKey);
      final secret = await _secureStorage.read(key: binanceApiSecret);
      return {'apiKey': key, 'apiSecret': secret};
    } else {
      final key = await _secureStorage.read(key: bybitApiKey);
      final secret = await _secureStorage.read(key: bybitApiSecret);
      return {'apiKey': key, 'apiSecret': secret};
    }
  }

  // Clear credentials
  static Future<void> clearCredentials(String exchange) async {
    if (exchange.toLowerCase() == 'binance') {
      await _secureStorage.delete(key: binanceApiKey);
      await _secureStorage.delete(key: binanceApiSecret);
    } else {
      await _secureStorage.delete(key: bybitApiKey);
      await _secureStorage.delete(key: bybitApiSecret);
    }
  }

  // Binance HMAC-SHA256 signature
  static String _generateBinanceSignature(String queryString, String apiSecret) {
    final keyBytes = utf8.encode(apiSecret);
    final dataBytes = utf8.encode(queryString);
    final hmac = Hmac(sha256, keyBytes);
    final digest = hmac.convert(dataBytes);
    return digest.toString();
  }

  // Bybit V5 HMAC-SHA256 signature
  static String _generateBybitSignature(String timestamp, String apiKey, String recvWindow, String queryString, String apiSecret) {
    final keyBytes = utf8.encode(apiSecret);
    final paramStr = timestamp + apiKey + recvWindow + queryString;
    final dataBytes = utf8.encode(paramStr);
    final hmac = Hmac(sha256, keyBytes);
    final digest = hmac.convert(dataBytes);
    return digest.toString();
  }

  // Fetch Binance Trades (FIFO matched position representation)
  static Future<List<Trade>> fetchBinanceTrades({
    required String apiKey,
    required String apiSecret,
    String symbol = 'BTCUSDT',
  }) async {
    if (apiKey.toLowerCase().contains('demo') || apiSecret.toLowerCase().contains('demo')) {
      // Return high-fidelity mock trade list for demo keys
      return _generateMockTrades('Binance', symbol);
    }

    final timestamp = DateTime.now().millisecondsSinceEpoch.toString();
    final queryString = 'symbol=$symbol&timestamp=$timestamp&limit=50';
    final signature = _generateBinanceSignature(queryString, apiSecret);
    final url = Uri.parse('https://api.binance.com/api/v3/myTrades?$queryString&signature=$signature');

    final response = await http.get(
      url,
      headers: {
        'X-MBX-APIKEY': apiKey,
      },
    );

    if (response.statusCode != 200) {
      throw Exception('Binance API error: ${response.body}');
    }

    final List<dynamic> jsonList = jsonDecode(response.body);
    return _parseBinanceExecutions(jsonList, symbol);
  }

  // Fetch Bybit Trades
  static Future<List<Trade>> fetchBybitTrades({
    required String apiKey,
    required String apiSecret,
    String symbol = 'BTCUSDT',
  }) async {
    if (apiKey.toLowerCase().contains('demo') || apiSecret.toLowerCase().contains('demo')) {
      // Return high-fidelity mock trade list for demo keys
      return _generateMockTrades('Bybit', symbol);
    }

    final timestamp = DateTime.now().millisecondsSinceEpoch.toString();
    const recvWindow = '5000';
    final queryString = 'category=linear&symbol=$symbol&limit=50';
    final signature = _generateBybitSignature(timestamp, apiKey, recvWindow, queryString, apiSecret);
    final url = Uri.parse('https://api.bybit.com/v5/execution/list?$queryString');

    final response = await http.get(
      url,
      headers: {
        'X-BAPI-API-KEY': apiKey,
        'X-BAPI-TIMESTAMP': timestamp,
        'X-BAPI-SIGN': signature,
        'X-BAPI-RECV-WINDOW': recvWindow,
      },
    );

    if (response.statusCode != 200) {
      throw Exception('Bybit API error: ${response.body}');
    }

    final Map<String, dynamic> jsonResponse = jsonDecode(response.body);
    if (jsonResponse['retCode'] != 0) {
      throw Exception('Bybit API retMessage: ${jsonResponse['retMsg']}');
    }

    final list = jsonResponse['result']?['list'] as List<dynamic>? ?? [];
    return _parseBybitExecutions(list, symbol);
  }

  // Parse raw Binance trade executions into paired Journal Trades
  static List<Trade> _parseBinanceExecutions(List<dynamic> executions, String symbol) {
    // Basic pairing helper: mapping executions into completed buy/sell trades
    final List<Trade> trades = [];
    final List<dynamic> buyExecutions = [];
    final List<dynamic> sellExecutions = [];

    for (var exec in executions) {
      if (exec['isBuyer'] == true) {
        buyExecutions.add(exec);
      } else {
        sellExecutions.add(exec);
      }
    }

    // Match them up simply (1-to-1 matching for illustration of auto-sync)
    final int pairsCount = buyExecutions.length < sellExecutions.length ? buyExecutions.length : sellExecutions.length;
    for (int i = 0; i < pairsCount; i++) {
      final buy = buyExecutions[i];
      final sell = sellExecutions[i];

      final entryPrice = double.parse(buy['price']);
      final exitPrice = double.parse(sell['price']);
      final amount = double.parse(buy['qty']);
      final pnl = (exitPrice - entryPrice) * amount;
      final pnlPercentage = ((exitPrice - entryPrice) / entryPrice) * 100;
      final date = DateTime.fromMillisecondsSinceEpoch(sell['time']);

      trades.add(Trade.create(
        pair: symbol,
        direction: TradeDirection.long,
        entryPrice: entryPrice,
        exitPrice: exitPrice,
        amount: amount,
        pnl: pnl,
        pnlPercentage: pnlPercentage,
        status: pnl >= 0 ? TradeStatus.won : TradeStatus.lost,
        date: date,
        assetClass: AssetClass.cryptoSpot,
        confluences: ['Binance Auto-Sync'],
        notes: 'Automatically synced from Binance execution matching. Trade ID: ${buy['id']}-${sell['id']}',
      ));
    }

    return trades;
  }

  // Parse Bybit executions (V5 API)
  static List<Trade> _parseBybitExecutions(List<dynamic> list, String symbol) {
    final List<Trade> trades = [];
    // Filter executions for closed trade records (e.g. ExecType = Trade)
    final buyExecutions = list.where((exec) => exec['side'] == 'Buy').toList();
    final sellExecutions = list.where((exec) => exec['side'] == 'Sell').toList();

    final int pairsCount = buyExecutions.length < sellExecutions.length ? buyExecutions.length : sellExecutions.length;
    for (int i = 0; i < pairsCount; i++) {
      final buy = buyExecutions[i];
      final sell = sellExecutions[i];

      final entryPrice = double.parse(buy['execPrice'] ?? '0.0');
      final exitPrice = double.parse(sell['execPrice'] ?? '0.0');
      final amount = double.parse(buy['execQty'] ?? '0.0');
      
      final pnl = (exitPrice - entryPrice) * amount;
      final pnlPercentage = entryPrice > 0 ? ((exitPrice - entryPrice) / entryPrice) * 100 : 0.0;
      final date = DateTime.fromMillisecondsSinceEpoch(int.tryParse(sell['execTime'] ?? '0') ?? DateTime.now().millisecondsSinceEpoch);

      trades.add(Trade.create(
        pair: symbol,
        direction: TradeDirection.long,
        entryPrice: entryPrice,
        exitPrice: exitPrice,
        amount: amount,
        pnl: pnl,
        pnlPercentage: pnlPercentage,
        status: pnl >= 0 ? TradeStatus.won : TradeStatus.lost,
        date: date,
        assetClass: AssetClass.cryptoFutures,
        confluences: ['Bybit Auto-Sync'],
        notes: 'Automatically synced from Bybit execution list. Execution ID: ${buy['execId']}-${sell['execId']}',
      ));
    }
    return trades;
  }

  // Generate premium mock trades when demo keys are provided
  static List<Trade> _generateMockTrades(String exchange, String symbol) {
    final String cleanSymbol = symbol.toUpperCase().replaceAll('/', '');
    final List<Trade> list = [];
    final now = DateTime.now();

    final mockData = [
      {
        'entry': 67500.0,
        'exit': 68250.0,
        'amount': 0.15,
        'hoursAgo': 2,
        'dir': TradeDirection.long,
        'strat': 'Bull Flag Breakout',
        'mae': 67320.0,
        'mfe': 68400.0,
      },
      {
        'entry': 68400.0,
        'exit': 67900.0,
        'amount': 0.10,
        'hoursAgo': 6,
        'dir': TradeDirection.short,
        'strat': 'Resistance Rejection',
        'mae': 68550.0,
        'mfe': 67700.0,
      },
      {
        'entry': 67100.0,
        'exit': 66800.0,
        'amount': 0.20,
        'hoursAgo': 12,
        'dir': TradeDirection.long,
        'strat': 'Support Bounce',
        'mae': 66700.0,
        'mfe': 67250.0,
      },
      {
        'entry': 66500.0,
        'exit': 67300.0,
        'amount': 0.12,
        'hoursAgo': 24,
        'dir': TradeDirection.long,
        'strat': 'EMA Golden Cross',
        'mae': 66420.0,
        'mfe': 67500.0,
      }
    ];

    for (var i = 0; i < mockData.length; i++) {
      final entry = mockData[i]['entry'] as double;
      final exit = mockData[i]['exit'] as double;
      final amount = mockData[i]['amount'] as double;
      final hoursAgo = mockData[i]['hoursAgo'] as int;
      final direction = mockData[i]['dir'] as TradeDirection;
      final strategy = mockData[i]['strat'] as String;
      final mae = mockData[i]['mae'] as double;
      final mfe = mockData[i]['mfe'] as double;

      final isLong = direction == TradeDirection.long;
      final multiplier = isLong ? 1 : -1;
      final pnl = (exit - entry) * amount * multiplier;
      final pnlPercentage = ((exit - entry) / entry) * 100 * multiplier;

      list.add(Trade.create(
        pair: cleanSymbol,
        direction: direction,
        entryPrice: entry,
        exitPrice: exit,
        amount: amount,
        pnl: pnl,
        pnlPercentage: pnlPercentage,
        status: pnl >= 0 ? TradeStatus.won : TradeStatus.lost,
        date: now.subtract(Duration(hours: hoursAgo)),
        assetClass: AssetClass.cryptoFutures,
        confluences: ['$exchange Auto-Sync', strategy],
        notes: 'Synced from $exchange ($strategy). Fully simulated from API signature protocol.',
        mae: mae,
        mfe: mfe,
      ));
    }

    return list;
  }
}
