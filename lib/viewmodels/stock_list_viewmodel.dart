import 'package:flutter/material.dart';

import '../models/stock.dart';
import '../services/stock_service.dart';

class StockListViewModel extends ChangeNotifier {
  final StockService _stockService;
  List<Stock> _stocks = [];
  bool _isLoading = false;
  String? _error;

  StockListViewModel(this._stockService);

  List<Stock> get stocks => _stocks;

  bool get isLoading => _isLoading;

  String? get error => _error;

  Future<void> fetchStocks() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      _stocks = await _stockService.fetchStocks(['AAPL', 'GOOGL', 'AMZN']);
    } catch (e) {
      _error = 'Failed to fetch stocks: $e';
    }

    _isLoading = false;
    notifyListeners();
  }
}
