import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:stock_app/DataLayer/stock_search.dart';

import '../DataLayer/alpha_client.dart';

class SearchBloc extends Bloc {
  final _controller = StreamController<List<StockSearch>>();
  final _client = AlphaClient();

  SearchBloc(initialState) : super(initialState);

  Stream<List<StockSearch>> get stream => _controller.stream;

  void submitQuery(String query) async {
    final _result = await _client.searchStock(query);
    _controller.sink.add(_result);
  }
}
