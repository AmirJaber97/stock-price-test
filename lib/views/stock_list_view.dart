import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:stock_app/viewmodels/stock_list_viewmodel.dart';

import '../widgets/stock_chart.dart';

class StockListView extends StatelessWidget {
  const StockListView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Stocks')),
      body: Consumer<StockListViewModel>(
        builder: (context, viewModel, child) {
          if (viewModel.isLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (viewModel.error != null) {
            return Center(child: Text(viewModel.error!));
          } else {
            return ListView.builder(
              itemCount: viewModel.stocks.length,
              itemBuilder: (context, index) {
                final stock = viewModel.stocks[index];
                return Card(
                  margin: const EdgeInsets.all(8),
                  child: Column(
                    children: [
                      ListTile(
                        title: Text(stock.symbol),
                        subtitle: Text('Price: \$${stock.price.toStringAsFixed(2)}'),
                      ),
                      StockChart(stock: stock),
                    ],
                  ),
                );
              },
            );
          }
        },
      ),
    );
  }
}
