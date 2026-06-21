class TradingViewMapper {
  /// Maps various pair/asset names to standard TradingView symbols.
  /// E.g. "EURUSD" -> "FX:EURUSD", "BTCUSD" -> "BINANCE:BTCUSDT", "AAPL" -> "NASDAQ:AAPL"
  static String mapPairToTvSymbol(String pair) {
    final clean = pair.toUpperCase().replaceAll(RegExp(r'[^A-Z0-9]'), '');
    if (clean.isEmpty) return 'FX:EURUSD'; // Default fallback

    // 1. Cryptocurrencies
    if (clean.startsWith('BTC') || clean == 'BTC') {
      return 'BINANCE:BTCUSDT';
    }
    if (clean.startsWith('ETH') || clean == 'ETH') {
      return 'BINANCE:ETHUSDT';
    }
    if (clean.startsWith('SOL') || clean == 'SOL') {
      return 'BINANCE:SOLUSDT';
    }
    if (clean.startsWith('XRP') || clean == 'XRP') {
      return 'BINANCE:XRPUSDT';
    }

    // 2. Commodities (Gold, Silver, Oil)
    if (clean.contains('GOLD') || clean.contains('XAU')) {
      return 'OANDA:XAUUSD';
    }
    if (clean.contains('SILVER') || clean.contains('XAG')) {
      return 'OANDA:XAGUSD';
    }
    if (clean.contains('WTI') || clean.contains('USOIL') || clean.contains('OIL')) {
      return 'OANDA:WTICOUSD';
    }

    // 3. Common Stock Tickers
    final stocks = {
      'AAPL': 'NASDAQ:AAPL',
      'TSLA': 'NASDAQ:TSLA',
      'MSFT': 'NASDAQ:MSFT',
      'NVDA': 'NASDAQ:NVDA',
      'AMZN': 'NASDAQ:AMZN',
      'GOOG': 'NASDAQ:GOOGL',
      'META': 'NASDAQ:META',
      'NFLX': 'NASDAQ:NFLX',
      'AMD': 'NASDAQ:AMD',
      'BABA': 'NYSE:BABA',
    };
    if (stocks.containsKey(clean)) {
      return stocks[clean]!;
    }

    // 4. Forex Pairs
    final forexPairs = [
      'EURUSD', 'GBPUSD', 'AUDUSD', 'NZDUSD', 'USDCAD', 'USDCHF', 'USDJPY',
      'EURGBP', 'EURJPY', 'GBPJPY', 'AUDJPY', 'CHFJPY', 'CADJPY', 'NZDJPY',
      'GBPAUD', 'GBPCAD', 'GBPNZD', 'EURAUD', 'EURCAD', 'EURNZD',
    ];
    
    // Check if the pair is a direct 6-letter match or part of it
    for (var fx in forexPairs) {
      if (clean == fx || clean.contains(fx)) {
        return 'FX:$fx';
      }
    }

    // If it's a 6-letter currency pair but not in list, fallback to FX:
    if (clean.length == 6) {
      return 'FX:$clean';
    }

    // Default fallback: Try FX, if not, return as is (let the user search it)
    return 'FX:$clean';
  }
}
