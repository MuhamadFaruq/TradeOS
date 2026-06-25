import 'package:flutter_test/flutter_test.dart';
import 'package:tradeos/core/services/exchange_api_service.dart';

void main() {
  group('ExchangeApiService Tests', () {
    test('Mock trade generation returns valid trade models with MAE/MFE', () {
      final trades = ExchangeApiService.fetchBinanceTrades(
        apiKey: 'demo_key',
        apiSecret: 'demo_secret',
        symbol: 'BTCUSDT',
      );

      expect(trades, completes);
      trades.then((list) {
        expect(list.length, equals(4));
        expect(list.first.pair, equals('BTCUSDT'));
        expect(list.first.mae, isNotNull);
        expect(list.first.mfe, isNotNull);
        expect(list.first.confluences?.join(', '), contains('Binance Auto-Sync'));
      });
    });

    test('Bybit demo trade generation returns valid trades', () {
      final trades = ExchangeApiService.fetchBybitTrades(
        apiKey: 'demo_key',
        apiSecret: 'demo_secret',
        symbol: 'ETH/USDT',
      );

      expect(trades, completes);
      trades.then((list) {
        expect(list.length, equals(4));
        expect(list.first.pair, equals('ETHUSDT'));
        expect(list.first.mae, isNotNull);
        expect(list.first.mfe, isNotNull);
        expect(list.first.confluences?.join(', '), contains('Bybit Auto-Sync'));
      });
    });
  });
}
