import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

import '../models/stock.dart';

class StockService {
  final Dio _dio;

  StockService(this._dio);

  Future<List<Stock>> fetchStocks(List<String> symbols) async {
    final apiKey = dotenv.env['ALPHA_VANTAGE_API_KEY'];
    List<Stock> stocks = [];

    for (var symbol in symbols) {
      final response = await _dio.get(
        'https://www.alphavantage.co/query',
        queryParameters: {
          'function': 'GLOBAL_QUOTE',
          'symbol': symbol,
          'apikey': apiKey,
        },
      );

      if (response.statusCode == 200) {
        final data = response.data['Global Quote'];
        stocks.add(Stock(
          symbol: data['01. symbol'],
          price: double.parse(data['05. price']),
        ));
      } else {
        throw Exception('Failed to load stock data');
      }
    }

    return stocks;
  }
}