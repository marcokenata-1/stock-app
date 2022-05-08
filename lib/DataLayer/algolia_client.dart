import 'package:flutter/services.dart';
import 'package:stock_app/DataLayer/search_hit.dart';

class AlgoliaClient {
  static const platform = MethodChannel('com.algolia/api');

  Future<dynamic> search(String query) async {
    try {
      var response =
          await platform.invokeMethod('search', ['dev_STOCKAPP', query]);
      print(response.toString());
      final results = response['hits']
          .map<SearchHit>((json) => SearchHit.fromJson(json))
          .toList(growable: false);
      return results;
    } on PlatformException catch (_) {
      return null;
    }
  }
}
