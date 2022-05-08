import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:stock_app/DataLayer/stock_details.dart';
import 'package:stock_app/DataLayer/stock_search.dart';
import 'package:stock_app/DataLayer/weekly_data_price.dart';

class AlphaClient {
  final _host = 'www.alphavantage.co';
  final _apiKey = 'G7RHMAV7F4PF3AA0';
  Map<String, dynamic> priceMap = {};
  Map<String, WeeklyDataPrice> priceWeekly = {};

  Future<Map> request({required Map<String, String> parameters}) async {
    final uri = Uri.https(_host, 'query', parameters);
    print(uri);
    final results = await http.get(uri);
    final jsonObject = json.decode(results.body);
    return jsonObject;
  }

  Future<List<StockSearch>> searchStock(String query) async {
    final results = await request(parameters: {
      'function': 'SYMBOL_SEARCH',
      'keywords': query,
      'apikey': _apiKey
    });

    final matches = results['bestMatches']
        .map<StockSearch>((json) => StockSearch.fromJson(json))
        .toList(growable: false);

    return matches;
  }

  Future<StockDetails> details(String query) async {
    final results = await request(parameters: {
      'function': 'TIME_SERIES_DAILY',
      'symbol': query,
      'apikey': _apiKey
    });

    priceMap = results['Time Series (Daily)'];

    final stockDetails = StockDetails.fromJson(results);

    return stockDetails;
  }
}
