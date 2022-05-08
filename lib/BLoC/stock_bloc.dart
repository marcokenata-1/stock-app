import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:stock_app/DataLayer/algolia_client.dart';
import 'package:stock_app/DataLayer/alpha_client.dart';
import 'package:stock_app/DataLayer/stock_details.dart';

import '../DataLayer/search_hit.dart';


class StockBloc extends Bloc{
  final _controller = StreamController<StockDetails>();
  final control1 = StreamController<List<SearchHit>>();
  final _client = AlphaClient();
  final algoliaClient = AlgoliaClient();

  StockBloc(initialState) : super(initialState);

  Stream<StockDetails> get stream => _controller.stream;

  Stream<List<SearchHit>> get stream1 => control1.stream;

  void submitQuery (String query) async {
    final _result = await _client.details(query);
    _controller.sink.add(_result);
  }

  // void submitSearch(String query) async {
  //   final _result = await algoliaClient.search(query);
  //   control1.sink.add(_result);
  // }

}