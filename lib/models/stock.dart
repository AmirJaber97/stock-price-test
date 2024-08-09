import 'package:fl_chart/fl_chart.dart';

class Stock {
  final String symbol;
  final double price;
  final List<FlSpot> historicalData;

  Stock({required this.symbol, required this.price, required this.historicalData});

  factory Stock.fromJson(Map<String, dynamic> json) {
    List<FlSpot> historicalData = [];
    if (json['Time Series (Daily)'] != null) {
      json['Time Series (Daily)'].forEach((key, value) {
        historicalData.add(FlSpot(
          DateTime.parse(key).millisecondsSinceEpoch.toDouble(),
          double.parse(value['4. close']),
        ));
      });
    }
    return Stock(
      symbol: json['Meta Data']['2. Symbol'],
      price: double.parse(json['Time Series (Daily)'].values.first['4. close']),
      historicalData: historicalData,
    );
  }
}
