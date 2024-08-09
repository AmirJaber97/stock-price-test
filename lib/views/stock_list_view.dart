import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../viewmodels/stock_list_viewmodel.dart';
import '../widgets/stock_chart.dart';

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
              return Card(
                margin: const EdgeInsets.all(8),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        stock.symbol,
                        style: Theme.of(context).textTheme.headlineSmall,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        '\$${stock.price.toStringAsFixed(2)}',
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                      const SizedBox(height: 16),
                      StockChart(stock: stock),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
