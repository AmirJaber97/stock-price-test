import 'package:fl_chart/fl_chart.dart';

class Stock {
  final String symbol;
  final double price;
  final List<FlSpot> historicalData;

  Stock({required this.symbol, required this.price, required this.historicalData});

  factory Stock.fromJson(Map<String, dynamic> json) {
    final timeSeries = json['Time Series (Daily)'] as Map<String, dynamic>;
    final List<FlSpot> historicalData = timeSeries.entries.map((entry) {
      final date = DateTime.parse(entry.key);
      final closePrice = double.parse(entry.value['4. close']);
      return FlSpot(date.millisecondsSinceEpoch.toDouble(), closePrice);
    }).toList();

    historicalData.sort((a, b) => a.x.compareTo(b.x));

    return Stock(
      symbol: json['Meta Data']['2. Symbol'],
      price: double.parse(timeSeries.values.first['4. close']),
      historicalData: historicalData,
    );
  }
}
