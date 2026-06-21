import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';
import '../../core/theme/app_colors.dart';
import '../../core/services/tradingview_mapper.dart';

class TradingViewChartScreen extends StatefulWidget {
  final String? initialPair;

  const TradingViewChartScreen({super.key, this.initialPair});

  @override
  State<TradingViewChartScreen> createState() => _TradingViewChartScreenState();
}

class _TradingViewChartScreenState extends State<TradingViewChartScreen> {
  late final WebViewController _controller;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();

    final symbol = TradingViewMapper.mapPairToTvSymbol(widget.initialPair ?? 'EURUSD');

    final htmlContent = """
<!DOCTYPE html>
<html>
<head>
  <meta name="viewport" content="width=device-width, initial-scale=1.0, maximum-scale=1.0, user-scalable=no">
  <style>
    body, html {
      margin: 0;
      padding: 0;
      width: 100%;
      height: 100%;
      background-color: #020617;
    }
    .tradingview-widget-container {
      width: 100%;
      height: 100%;
    }
  </style>
</head>
<body>
  <div class="tradingview-widget-container">
    <div id="tradingview_chart" style="width: 100%; height: 100%;"></div>
    <script type="text/javascript" src="https://s3.tradingview.com/tv.js"></script>
    <script type="text/javascript">
    const localTimezone = Intl.DateTimeFormat().resolvedOptions().timeZone || "Etc/UTC";
    new TradingView.widget(
    {
      "autosize": true,
      "symbol": "$symbol",
      "interval": "60",
      "timezone": localTimezone,
      "theme": "dark",
      "style": "1",
      "locale": "en",
      "enable_publishing": false,
      "hide_side_toolbar": false,
      "allow_symbol_change": true,
      "container_id": "tradingview_chart",
      "enabled_features": ["countdown"]
    }
    );
    </script>
  </div>
</body>
</html>
""";

    _controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setBackgroundColor(AppColors.background)
      ..setNavigationDelegate(
        NavigationDelegate(
          onPageStarted: (String url) {
            setState(() {
              _isLoading = true;
            });
          },
          onPageFinished: (String url) {
            setState(() {
              _isLoading = false;
            });
          },
        ),
      )
      ..loadHtmlString(htmlContent);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text(
          widget.initialPair != null ? 'TradingView: ${widget.initialPair}' : 'TradingView Live Market',
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
        ),
      ),
      body: Stack(
        children: [
          WebViewWidget(controller: _controller),
          if (_isLoading)
            const Center(
              child: CircularProgressIndicator(color: AppColors.primary),
            ),
        ],
      ),
    );
  }
}
