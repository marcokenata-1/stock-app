import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:stock_app/BLoC/search_bloc.dart';
import 'package:stock_app/DataLayer/stock_search.dart';
import 'package:stock_app/UI/stock_detail_screen.dart';

import '../BLoC/database_bloc.dart';
import 'main_screen.dart';

class StockSearchScreen extends StatelessWidget {
  final bool isFullScreenDialog;

  const StockSearchScreen({Key? key, this.isFullScreenDialog = false})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final bloc = SearchBloc(context);

    return WillPopScope(
        child: BlocProvider<SearchBloc>(
            create: (context) => bloc,
            child: Scaffold(
                body: Column(
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: TextField(
                    decoration: InputDecoration(
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10.0)),
                        hintText: 'Enter a symbol'),
                    onSubmitted: (query) => bloc.submitQuery(query),
                  ),
                ),
                Expanded(
                  child: _buildResults(bloc),
                )
              ],
            ))),
        onWillPop: () async {
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => const MainScreen()));
          BlocProvider.of<DatabaseBloc>(context).add(DatabaseBack());
          return false;
        });
  }

  Widget _buildResults(SearchBloc bloc) {
    return StreamBuilder<List<StockSearch>>(
      stream: bloc.stream,
      builder: (context, snapshot) {
        final results = snapshot.data;

        if (results == null) {
          return const Center(child: Text("Enter A Symbol"));
        }

        if (results.isEmpty) {
          return const Center(child: Text("No Results"));
        }

        return _buildSearchResults(results);
      },
    );
  }

  Widget _buildSearchResults(List<StockSearch> results) {
    return ListView.separated(
      itemCount: results.length,
      separatorBuilder: (BuildContext context, int index) => const Divider(),
      itemBuilder: (context, index) {
        final stockSearch = results[index];
        return ListTile(
          title: Text(stockSearch.symbol),
          onTap: () {
            // 3

            Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                    builder: (context) =>
                        StockDetailScreen(stockSymbol: stockSearch.symbol)));
          },
        );
      },
    );
  }
}
