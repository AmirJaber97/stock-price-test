import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../models/stock.dart';

class StockChart extends StatelessWidget {
  final Stock stock;

  const StockChart({super.key, required this.stock});

  List<FlSpot> _getMonthlyData() {
    final Map<int, FlSpot> monthlyData = {};
    for (var spot in stock.historicalData) {
      final date = DateTime.fromMillisecondsSinceEpoch(spot.x.toInt());
      final monthKey = DateTime(date.year, date.month).millisecondsSinceEpoch;
      if (!monthlyData.containsKey(monthKey) || spot.x < monthlyData[monthKey]!.x) {
        monthlyData[monthKey] = spot;
      }
    }
    return monthlyData.values.toList()..sort((a, b) => a.x.compareTo(b.x));
  }

  @override
  Widget build(BuildContext context) {
    final monthlyData = _getMonthlyData();
    final minY = stock.historicalData.map((e) => e.y).reduce((a, b) => a < b ? a : b);
    final maxY = stock.historicalData.map((e) => e.y).reduce((a, b) => a > b ? a : b);
    final yInterval = (maxY - minY) / 5;

    debugPrint('Monthly data points: ${monthlyData.length}');
    for (var spot in monthlyData) {
      debugPrint(
          'Date: ${DateFormat('yyyy-MM-dd').format(DateTime.fromMillisecondsSinceEpoch(spot.x.toInt()))}, Price: ${spot.y}');
    }

    return SizedBox(
      height: 300,
      child: LineChart(
        LineChartData(
          gridData: FlGridData(
            show: true,
            drawVerticalLine: true,
            getDrawingHorizontalLine: (value) => FlLine(color: Colors.grey[300], strokeWidth: 1),
            getDrawingVerticalLine: (value) => FlLine(color: Colors.grey[300], strokeWidth: 1),
          ),
          titlesData: FlTitlesData(
            bottomTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                reservedSize: 30,
                interval: (monthlyData.last.x - monthlyData.first.x) / (monthlyData.length - 1),
                getTitlesWidget: (value, meta) {
                  final date = DateTime.fromMillisecondsSinceEpoch(value.toInt());
                  debugPrint('Creating label for date: ${DateFormat('yyyy-MM-dd').format(date)}');
                  return SideTitleWidget(
                    axisSide: meta.axisSide,
                    space: 10,
                    child: Text(
                      DateFormat('MMM').format(date),
                      style: TextStyle(color: Colors.grey[600], fontWeight: FontWeight.bold, fontSize: 10),
                    ),
                  );
                },
              ),
            ),
            leftTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                reservedSize: 40,
                interval: yInterval,
                getTitlesWidget: (value, meta) {
                  return SideTitleWidget(
                    axisSide: meta.axisSide,
                    child: Text('\$${value.toStringAsFixed(2)}',
                        style: TextStyle(color: Colors.grey[600], fontWeight: FontWeight.bold, fontSize: 10)),
                  );
                },
              ),
            ),
            rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
            topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
          ),
          borderData: FlBorderData(show: true, border: Border.all(color: const Color(0xff37434d), width: 1)),
          minX: monthlyData.first.x,
          maxX: monthlyData.last.x,
          minY: minY,
          maxY: maxY,
          lineBarsData: [
            LineChartBarData(
              spots: stock.historicalData,
              isCurved: true,
              color: Colors.blue,
              barWidth: 2,
              isStrokeCapRound: true,
              dotData: const FlDotData(show: false),
              belowBarData: BarAreaData(show: true, color: Colors.blue.withOpacity(0.1)),
            ),
          ],
          lineTouchData: LineTouchData(
            touchTooltipData: LineTouchTooltipData(
              getTooltipItems: (touchedSpots) {
                return touchedSpots.map((LineBarSpot touchedSpot) {
                  final date = DateTime.fromMillisecondsSinceEpoch(touchedSpot.x.toInt());
                  return LineTooltipItem(
                    '${DateFormat('MMM dd, yyyy').format(date)}\n\$${touchedSpot.y.toStringAsFixed(2)}',
                    const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                  );
                }).toList();
              },
            ),
          ),
        ),
      ),
    );
  }
}
