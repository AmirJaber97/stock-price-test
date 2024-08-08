class Stock {
  final String symbol;
  final double price;

  Stock({required this.symbol, required this.price});

  factory Stock.fromJson(Map<String, dynamic> json) {
    return Stock(
      symbol: json['symbol'],
      price: double.parse(json['price']),
    );
  }
}
