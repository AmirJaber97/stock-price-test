import 'dart:math';

import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../models/stock.dart';

class StockChart extends StatelessWidget {
  final Stock stock;

  const StockChart({super.key, required this.stock});

  @override
  Widget build(BuildContext context) {
    final sortedData = List<FlSpot>.from(stock.historicalData)..sort((a, b) => a.x.compareTo(b.x));

    final minX = sortedData.first.x;
    final maxX = sortedData.last.x;
    final minY = sortedData.map((e) => e.y).reduce(min);
    final maxY = sortedData.map((e) => e.y).reduce(max);

    return AspectRatio(
      aspectRatio: 1.70,
      child: Padding(
        padding: const EdgeInsets.only(right: 18, left: 12, top: 24, bottom: 12),
        child: LineChart(
          LineChartData(
            gridData: const FlGridData(show: false),
            titlesData: FlTitlesData(
              show: true,
              rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
              topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
              bottomTitles: AxisTitles(
                sideTitles: SideTitles(
                  showTitles: true,
                  reservedSize: 30,
                  interval: (maxX - minX) / 5,
                  getTitlesWidget: (value, meta) {
                    final date = DateTime.fromMillisecondsSinceEpoch(value.toInt());
                    return SideTitleWidget(
                      axisSide: meta.axisSide,
                      space: 8.0,
                      child: Text(DateFormat('MMM').format(date),
                          style: TextStyle(color: Colors.grey[600], fontWeight: FontWeight.bold, fontSize: 12)),
                    );
                  },
                ),
              ),
              leftTitles: AxisTitles(
                sideTitles: SideTitles(
                  showTitles: true,
                  interval: (maxY - minY) / 4,
                  reservedSize: 42,
                  getTitlesWidget: (value, meta) {
                    return SideTitleWidget(
                      axisSide: meta.axisSide,
                      space: 8.0,
                      child: Text('\$${value.toInt()}',
                          style: TextStyle(color: Colors.grey[600], fontWeight: FontWeight.bold, fontSize: 12)),
                    );
                  },
                ),
              ),
            ),
            borderData: FlBorderData(show: true, border: Border.all(color: const Color(0xff37434d), width: 1)),
            lineBarsData: [
              LineChartBarData(
                spots: sortedData,
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
      ),
    );
  }
}
