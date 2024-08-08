import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:provider/provider.dart';

import 'services/stock_service.dart';
import 'viewmodels/stock_list_viewmodel.dart';
import 'views/stock_list_view.dart';

Future<void> main() async {
  await dotenv.load(fileName: ".env");
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        Provider<StockService>(
          create: (_) => StockService(Dio()),
        ),
        ChangeNotifierProxyProvider<StockService, StockListViewModel>(
          create: (_) => StockListViewModel(StockService(Dio())),
          update: (_, stockService, __) => StockListViewModel(stockService),
        ),
      ],
      child: MaterialApp(
        title: 'Stock Price App',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: const StockListView(),
      ),
    );
  }
}
