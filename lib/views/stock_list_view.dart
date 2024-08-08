import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../viewmodels/stock_list_viewmodel.dart';

class StockListView extends StatefulWidget {
  const StockListView({super.key});

  @override
  State<StockListView> createState() => _StockListViewState();
}

class _StockListViewState extends State<StockListView> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() => context.read<StockListViewModel>().fetchStocks());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Stock Prices'),
      ),
      body: Consumer<StockListViewModel>(
        builder: (context, viewModel, child) {
          if (viewModel.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (viewModel.error != null) {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(viewModel.error!),
                  backgroundColor: viewModel.error!.startsWith('Network error') ? Colors.red : Colors.orange,
                ),
              );
            });
          }

          if (viewModel.stocks.isEmpty) {
            return const Center(child: Text('No stocks available'));
          }

          return ListView.builder(
            itemCount: viewModel.stocks.length,
            itemBuilder: (context, index) {
              final stock = viewModel.stocks[index];
              return ListTile(
                title: Text(stock.symbol),
                trailing: Text('\$${stock.price.toStringAsFixed(2)}'),
              );
            },
          );
        },
      ),
    );
  }
}
