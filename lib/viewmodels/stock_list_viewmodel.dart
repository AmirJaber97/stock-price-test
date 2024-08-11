import 'package:flutter/material.dart';

import '../core/exceptions.dart';
import '../models/stock.dart';
import '../services/stock_service.dart';

class StockListViewModel extends ChangeNotifier {
  final StockService _stockService;
  List<Stock> _stocks = [];
  bool _isLoading = false;
  String? _error;

  StockListViewModel(this._stockService) {
    fetchStocks();
  }

  List<Stock> get stocks => _stocks;

  bool get isLoading => _isLoading;

  String? get error => _error;

  Future<void> fetchStocks() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      _stocks = await _stockService.fetchStocks(['AMZN']);
    } on NetworkException catch (e) {
      _error = 'Network error: ${e.message}';
    } on DataParsingException catch (e) {
      _error = 'Data error: ${e.message}';
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
