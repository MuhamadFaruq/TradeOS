import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../../data/models/trade.dart';

class GeminiService {
  static const String _apiKeyPrefsKey = 'gemini_api_key';
  static const String _reportPrefsKey = 'gemini_latest_report';

  static Future<String?> getApiKey() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_apiKeyPrefsKey);
  }

  static Future<void> saveApiKey(String apiKey) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_apiKeyPrefsKey, apiKey);
  }

  static Future<void> removeApiKey() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_apiKeyPrefsKey);
    await prefs.remove(_reportPrefsKey);
  }

  static Future<String?> getLatestReport() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_reportPrefsKey);
  }

  static Future<void> saveLatestReport(String report) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_reportPrefsKey, report);
  }

  static Future<String> generateWeeklyReport({
    required List<Trade> trades,
    required double winRate,
    required double totalPnL,
    required double pf,
    required double disciplineRate,
    required double mistakeCosts,
  }) async {
    final apiKey = await getApiKey();
    if (apiKey == null || apiKey.isEmpty) {
      throw Exception('API Key Gemini belum dikonfigurasi.');
    }

    final totalTrades = trades.length;
    
    // Top strategies & emotions
    final Map<String, int> strategies = {};
    final Map<String, int> emotions = {};
    final Map<String, int> brokenRules = {};
    final Map<String, List<double>> emotionPnLs = {};
    
    for (var t in trades) {
      if (t.confluences != null && t.confluences!.isNotEmpty) {
        final strategyStr = t.confluences!.join(', ');
        strategies[strategyStr] = (strategies[strategyStr] ?? 0) + 1;
      }
      if (t.emotion != null && t.emotion!.isNotEmpty) {
        emotions[t.emotion!] = (emotions[t.emotion!] ?? 0) + 1;
        emotionPnLs.putIfAbsent(t.emotion!, () => []).add(t.pnl);
      }
      if (t.wasRuleBroken && t.brokenRule != null && t.brokenRule!.isNotEmpty) {
        brokenRules[t.brokenRule!] = (brokenRules[t.brokenRule!] ?? 0) + 1;
      }
    }

    final topStrategy = strategies.isNotEmpty 
        ? strategies.entries.reduce((a, b) => a.value > b.value ? a : b).key 
        : 'None';
        
    final topEmotion = emotions.isNotEmpty 
        ? emotions.entries.reduce((a, b) => a.value > b.value ? a : b).key 
        : 'None';

    final sortedBrokenRules = brokenRules.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));
    final brokenRulesSummary = sortedBrokenRules.isNotEmpty
        ? sortedBrokenRules.map((e) => '${e.key} (${e.value}x)').join(', ')
        : 'Tidak ada pelanggaran aturan tercatat';

    final disciplinedTrades = trades.where((t) => !t.wasRuleBroken).toList();
    final undisciplinedTrades = trades.where((t) => t.wasRuleBroken).toList();
    
    final disciplinedWins = disciplinedTrades.where((t) => t.pnl > 0).length;
    final disciplinedWinRate = disciplinedTrades.isNotEmpty 
        ? (disciplinedWins / disciplinedTrades.length) * 100 
        : 0.0;
        
    final undisciplinedWins = undisciplinedTrades.where((t) => t.pnl > 0).length;
    final undisciplinedWinRate = undisciplinedTrades.isNotEmpty 
        ? (undisciplinedWins / undisciplinedTrades.length) * 100 
        : 0.0;

    final List<String> emotionImpacts = [];
    emotionPnLs.forEach((emotion, pnls) {
      final avgPnL = pnls.reduce((a, b) => a + b) / pnls.length;
      emotionImpacts.add('$emotion (Rata-rata PnL: \$${avgPnL.toStringAsFixed(2)})');
    });
    final emotionImpactsSummary = emotionImpacts.isNotEmpty
        ? emotionImpacts.join(', ')
        : 'Tidak ada data emosi tercatat';

    final prompt = """
Anda adalah AI Trading Coach & Psikolog Trading profesional. Tugas Anda adalah melakukan analisis mendalam mengenai performa, kondisi psikologis, dan korelasi pola trading trader berdasarkan data berikut:

=== DATA TRANSAKSI UTAMA ===
- Total Trades: $totalTrades
- Win Rate: ${winRate.toStringAsFixed(1)}%
- Total Net P&L: \$${totalPnL.toStringAsFixed(2)}
- Profit Factor: ${pf.isInfinite ? 'Infinity' : pf.toStringAsFixed(2)}
- Tingkat Kedisiplinan (Discipline Rate): ${disciplineRate.toStringAsFixed(1)}%
- Biaya Kesalahan (Mistake Costs): \$${mistakeCosts.toStringAsFixed(2)} (Kerugian akibat melanggar rencana trading)

=== ANALISIS POLA & KORELASI ===
- Pelanggaran Aturan Terbanyak: $brokenRulesSummary
- Bandingkan Hasil Disiplin vs. Melanggar Aturan:
  * Trade Disiplin (Sesuai Rencana): ${disciplinedTrades.length} trade, Win Rate: ${disciplinedWinRate.toStringAsFixed(1)}%
  * Trade Melanggar Aturan (Mistake): ${undisciplinedTrades.length} trade, Win Rate: ${undisciplinedWinRate.toStringAsFixed(1)}%
- Dampak Emosi Terhadap Keuntungan (PnL):
  * Rata-rata hasil berdasarkan emosi: $emotionImpactsSummary
- Strategi Utama: $topStrategy

=== TUGAS ANDA ===
Berikan evaluasi psikologis, taktis, dan korelasi pola trading yang dinamis, tajam, dan terstruktur. Tulis laporan Anda dalam Bahasa Indonesia dengan format markdown yang indah:
1. **Analisis Performa & Korelasi Pola**: Bandingkan secara spesifik kinerja saat trader disiplin vs melanggar rencana trading. Tunjukkan secara gamblang seberapa merugikan kesalahan (seperti $brokenRulesSummary) bagi pertumbuhan akun mereka.
2. **Analisis Dampak Emosional**: Jelaskan korelasi antara emosi dominan ($topEmotion) dan hasil keuntungan/kerugian rata-rata yang diperoleh.
3. **Kondisi Psikologis & Perilaku**: Evaluasi tingkat kedisiplinan ($disciplineRate%) dan identifikasi kebiasaan buruk yang berulang.
4. **3 Action Plan Konkret**: Langkah strategis spesifik yang harus dilakukan minggu depan untuk memitigasi emosi negatif dan mengeliminasi pola kesalahan utama ($brokenRulesSummary).

Harap berikan respons yang ringkas, bernada profesional namun memotivasi, dan mudah dipahami oleh trader. Jangan memberikan disclaimer umum tentang risiko trading.
""";

    final url = Uri.parse('https://generativelanguage.googleapis.com/v1beta/models/gemini-1.5-flash:generateContent?key=$apiKey');
    
    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: json.encode({
        'contents': [
          {
            'parts': [
              {'text': prompt}
            ]
          }
        ]
      }),
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = json.decode(response.body);
      final String text = data['candidates'][0]['content']['parts'][0]['text'];
      await saveLatestReport(text);
      return text;
    } else {
      try {
        final Map<String, dynamic> errData = json.decode(response.body);
        final errMsg = errData['error']?['message'] ?? 'Status code: ${response.statusCode}';
        throw Exception('Gagal menghubungi Gemini API: $errMsg');
      } catch (_) {
        throw Exception('Gagal menghubungi Gemini API. Kode status: ${response.statusCode}');
      }
    }
  }

  static Future<String> generateMockReport({
    required List<Trade> trades,
    required double winRate,
    required double totalPnL,
    required double pf,
    required double disciplineRate,
    required double mistakeCosts,
  }) async {
    final totalTrades = trades.length;
    
    // Fallback if no trades are in Isar DB yet
    if (totalTrades == 0) {
      return """
# 📘 Laporan AI Trading Coach (MODE DEMO)

*Evaluasi ini dihasilkan dalam mode demo untuk mensimulasikan analisis psikologis AI.*

---

## 1. Analisis Performa & Korelasi Pola
Saat ini belum ada transaksi tercatat di database jurnal TradeOS Anda. Untuk melihat analisis yang disesuaikan secara dinamis, cobalah mencatat beberapa transaksi kustom atau mengimpor riwayat CSV Anda.
* **Tingkat Kemenangan (Win Rate)**: 0.0% (Simulasi)
* **Tingkat Kedisiplinan**: 100% (Simulasi)

## 2. Analisis Dampak Emosional
* **Emosi Terbanyak**: Tenang (*Calm*) - 0 trade.
* AI Coach menyarankan agar Anda mulai memantau emosi Anda saat memicu posisi.

## 3. Evaluasi Perilaku & Sikap
* Mulailah mencatat jurnal dengan disiplin untuk mengenali bias kognitif dan perilaku trading Anda.

## 4. 3 Rencana Tindakan Minggu Depan
1. **Catat 5 Transaksi**: Buat jurnal setidaknya 5 transaksi minggu ini dengan detail emosi, strategi, dan tangkapan layar.
2. **Tentukan Aturan Disiplin**: Tetapkan kriteria entry/exit yang jelas sebelum menyalakan terminal.
3. **Analisis di Akhir Pekan**: Buka kembali menu AI Coach untuk mendapatkan analisis perilaku yang sesungguhnya.
""";
    }

    final Map<String, int> strategies = {};
    final Map<String, int> emotions = {};
    final Map<String, int> brokenRules = {};
    
    for (var t in trades) {
      if (t.confluences != null && t.confluences!.isNotEmpty) {
        final strategyStr = t.confluences!.join(', ');
        strategies[strategyStr] = (strategies[strategyStr] ?? 0) + 1;
      }
      if (t.emotion != null && t.emotion!.isNotEmpty) {
        emotions[t.emotion!] = (emotions[t.emotion!] ?? 0) + 1;
      }
      if (t.wasRuleBroken && t.brokenRule != null && t.brokenRule!.isNotEmpty) {
        brokenRules[t.brokenRule!] = (brokenRules[t.brokenRule!] ?? 0) + 1;
      }
    }

    final topStrategy = strategies.isNotEmpty 
        ? strategies.entries.reduce((a, b) => a.value > b.value ? a : b).key 
        : 'None';
        
    final topEmotion = emotions.isNotEmpty 
        ? emotions.entries.reduce((a, b) => a.value > b.value ? a : b).key 
        : 'None';

    final topBrokenRule = brokenRules.isNotEmpty
        ? brokenRules.entries.reduce((a, b) => a.value > b.value ? a : b).key
        : 'Tidak ada pelanggaran aturan tercatat';

    return """
# 📘 Laporan AI Trading Coach (MODE DEMO)

*Evaluasi ini dihasilkan dalam mode demo untuk mensimulasikan analisis psikologis AI.*

---

## 1. Analisis Performa & Korelasi Pola
Berdasarkan data kueri lokal Anda, Anda memiliki **$totalTrades transaksi** tercatat dengan **Win Rate ${winRate.toStringAsFixed(1)}%**.
* **Dampak Kedisiplinan**: Tingkat kedisiplinan Anda saat ini adalah **${disciplineRate.toStringAsFixed(1)}%**.
* Ketika Anda disiplin mematuhi rencana, hasil transaksi Anda jauh lebih konsisten dan terjaga.
* Namun, pelanggaran rencana trading (seperti *$topBrokenRule*) telah merugikan portofolio Anda sebesar **\$${mistakeCosts.toStringAsFixed(2)}** (Mistake Costs). Ini adalah kebocoran saldo yang krusial dan harus segera dihentikan.

## 2. Analisis Dampak Emosional
* Emosi dominan yang tercatat menunjukkan adanya kecenderungan emosi **$topEmotion** saat memasuki pasar.
* Kerugian rata-rata dari trade yang didasari emosi tidak tenang jauh lebih tinggi dibanding trade yang tenang dengan strategi **$topStrategy**.

## 3. Evaluasi Perilaku & Sikap
* **Discipline Score: ${(disciplineRate / 10).toStringAsFixed(1)}/10**. Skor ini menunjukkan bahwa Anda memiliki kebiasaan baik dalam menyusun rencana, namun terkadang rentan terdistraksi oleh riak kecil pergerakan harga intra-day.
* Kebiasaan buruk yang terdeteksi: Memindahkan Stop Loss (SL) lebih jauh ketika harga mendekatinya, atau masuk posisi terlalu cepat sebelum setup strategi **$topStrategy** terkonfirmasi sepenuhnya.

## 4. 3 Rencana Tindakan Minggu Depan
1. **Aturan 2 Menit**: Sebelum membuka posisi, ambil nafas dalam-dalam selama 2 menit untuk menstabilkan detak jantung dan mematikan emosi negatif.
2. **Kunci Ukuran Lot**: Batasi ukuran lot maksimum hingga 50% dari biasanya untuk 5 trade berikutnya sampai tingkat kedisiplinan Anda kembali menyentuh 80%.
3. **Log & Lock**: Segera setelah mencatat transaksi di TradeOS, tutup grafik Anda untuk menghindari *over-trading* atau balas dendam (*revenge trading*).
""";
  }
}
