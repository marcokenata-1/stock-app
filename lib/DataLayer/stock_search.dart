class StockSearch {
  final String symbol;
  final String name;

  StockSearch.fromJson(Map json)
      : symbol = json['1. symbol'],
        name = json['2. name'];
}
