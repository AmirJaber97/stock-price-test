import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

import '../core/exceptions.dart';
import '../models/stock.dart';

class StockService {
  final Dio _dio;

  StockService(this._dio);

  Future<List<Stock>> fetchStocks(List<String> symbols) async {
    final apiKey = dotenv.env['ALPHA_VANTAGE_API_KEY'];
    List<Stock> stocks = [];

    for (var symbol in symbols) {
      try {
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
          if (data == null || data.isEmpty) {
            throw DataParsingException('No data available for $symbol');
          }
          stocks.add(Stock(
            symbol: data['01. symbol'],
            price: double.parse(data['05. price']),
          ));
        } else {
          throw NetworkException('Failed to load stock data for $symbol');
        }
      } on DioError catch (e) {
        throw NetworkException('Network error for $symbol: ${e.message}');
      } on FormatException catch (e) {
        throw DataParsingException('Error parsing data for $symbol: ${e.message}');
      }
    }

    return stocks;
  }
}
