import 'dart:async';
import 'dart:math';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:stock_app/BLoC/database_bloc.dart';
import 'package:stock_app/DataLayer/database_repository_impl.dart';
import 'package:stock_app/DataLayer/user_symbol.dart';
import 'package:stock_app/UI/main_screen.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

import '../BLoC/stock_bloc.dart';
import '../DataLayer/stock_details.dart';
import '../DataLayer/weekly_data_price.dart';

class StockDetailScreen extends StatelessWidget {
  final String stockSymbol;

  const StockDetailScreen({Key? key, required this.stockSymbol})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    var stockBloc = StockBloc(context);
    var x = FirebaseAuth.instance.currentUser?.email;
    var databaseBloc = DatabaseBloc(DatabaseRepositoryImpl());
    stockBloc.submitQuery(stockSymbol);
    // stockBloc.submitSearch('$stockSymbol news');
    return WillPopScope(
        child: MultiBlocProvider(
          providers: [
            BlocProvider<StockBloc>(create: (context) => stockBloc),
            BlocProvider<DatabaseBloc>(create: (context) => databaseBloc),
          ],
          child: Scaffold(
            body: Column(
              children: [Expanded(child: _buildResults(stockBloc, context))],
            ),
          ),
        ),
        onWillPop: () async {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const MainScreen())
          );
          BlocProvider.of<DatabaseBloc>(context).add(DatabaseBack());
          return false;
        });
  }

  Widget _buildResults(StockBloc bloc, BuildContext context) {
    return StreamBuilder<StockDetails>(
      stream: bloc.stream,
      builder: (context, snapshot) {
        final results = snapshot.data;

        if (results == null) {
          return const Center(child: Text("No data"));
        }

        return _buildSearchResults(results, bloc, context);
      },
    );
  }

  Widget _buildSearchResults(
      StockDetails results, StockBloc bloc, BuildContext context) {
    List<WeeklyDataPrice> price = [];
    double y = -999999;
    double x = 9999999;
    String lastUpdate = results.lastRefreshed;
    results.weeklyPrice.forEach((key, value) {
      if (double.parse(value['2. high']) > y) {
        y = double.parse(value['2. high']);
      }

      if (double.parse(value['3. low']) < x) {
        x = double.parse(value['3. low']);
      }

      price.add(WeeklyDataPrice(
          DateTime.parse(key),
          double.parse(value['1. open']),
          double.parse(value['2. high']),
          double.parse(value['3. low']),
          double.parse(value['4. close']),
          double.parse(value['5. volume'])));
    });

    price = List.from(price.reversed);
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(15.0),
        child: SingleChildScrollView(
          reverse: true,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                results.symbol,
                style:
                    const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(
                height: 20,
              ),
              SfCartesianChart(
                legend: Legend(isVisible: false),
                trackballBehavior: TrackballBehavior(
                    enable: true, activationMode: ActivationMode.singleTap),
                series: <CandleSeries>[
                  CandleSeries<WeeklyDataPrice, DateTime>(
                      dataSource:
                          price.sublist(price.length - 30, price.length),
                      xValueMapper: (WeeklyDataPrice sales, _) => sales.x,
                      lowValueMapper: (WeeklyDataPrice sales, _) => sales.low,
                      highValueMapper: (WeeklyDataPrice sales, _) => sales.high,
                      openValueMapper: (WeeklyDataPrice sales, _) => sales.open,
                      closeValueMapper: (WeeklyDataPrice sales, _) =>
                          sales.close)
                ],
                primaryXAxis: DateTimeAxis(
                    dateFormat: DateFormat.MMMd(),
                    majorGridLines: const MajorGridLines(width: 2)),
                primaryYAxis: NumericAxis(
                    minimum: x,
                    maximum: y,
                    interval: 10,
                    numberFormat:
                        NumberFormat.simpleCurrency(decimalDigits: 2)),
              ),
              Container(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'Last Update : $lastUpdate',
                    style: const TextStyle(color: Colors.black, fontSize: 10),
                  )),
              const SizedBox(
                height: 15,
              ),
              Container(
                  alignment: Alignment.centerLeft,
                  child: const Text(
                    'Overview',
                    style: TextStyle(
                        color: Colors.black,
                        fontSize: 30,
                        fontWeight: FontWeight.bold),
                  )),
              Padding(
                padding: const EdgeInsets.all(5.0),
                child: Table(
                  border: TableBorder.symmetric(),
                  columnWidths: const {
                    0: FlexColumnWidth(),
                    1: FlexColumnWidth(),
                  },
                  defaultVerticalAlignment: TableCellVerticalAlignment.middle,
                  children: [
                    TableRow(children: <Widget>[
                      TableCell(
                        verticalAlignment: TableCellVerticalAlignment.middle,
                        child: Container(
                            height: 32,
                            width: 32,
                            alignment: Alignment.centerLeft,
                            child: const Padding(
                                padding: EdgeInsets.all(5.0),
                                child: Text("OPEN"))),
                      ),
                      TableCell(
                        verticalAlignment: TableCellVerticalAlignment.middle,
                        child: Container(
                            height: 32,
                            width: 32,
                            alignment: Alignment.centerRight,
                            child: Padding(
                                padding: const EdgeInsets.all(5.0),
                                child: Text(price.last.open.toString()))),
                      )
                    ]),
                    TableRow(children: <Widget>[
                      TableCell(
                        verticalAlignment: TableCellVerticalAlignment.middle,
                        child: Container(
                            height: 32,
                            width: 32,
                            color: Colors.grey,
                            alignment: Alignment.centerLeft,
                            child: const Padding(
                                padding: EdgeInsets.all(5.0),
                                child: Text("HIGH"))),
                      ),
                      TableCell(
                        verticalAlignment: TableCellVerticalAlignment.middle,
                        child: Container(
                            height: 32,
                            width: 32,
                            color: Colors.grey,
                            alignment: Alignment.centerRight,
                            child: Padding(
                                padding: const EdgeInsets.all(5.0),
                                child: Text(price.last.high.toString()))),
                      ),
                    ]),
                    TableRow(children: <Widget>[
                      TableCell(
                        verticalAlignment: TableCellVerticalAlignment.middle,
                        child: Container(
                            height: 32,
                            width: 32,
                            color: Colors.white,
                            alignment: Alignment.centerLeft,
                            child: const Padding(
                                padding: EdgeInsets.all(5.0),
                                child: Text("LOW"))),
                      ),
                      TableCell(
                        verticalAlignment: TableCellVerticalAlignment.middle,
                        child: Container(
                            height: 32,
                            width: 32,
                            color: Colors.white,
                            alignment: Alignment.centerRight,
                            child: Padding(
                                padding: const EdgeInsets.all(5.0),
                                child: Text(price.last.low.toString()))),
                      ),
                    ]),
                    TableRow(children: <Widget>[
                      TableCell(
                        verticalAlignment: TableCellVerticalAlignment.middle,
                        child: Container(
                            height: 32,
                            width: 32,
                            color: Colors.grey,
                            alignment: Alignment.centerLeft,
                            child: const Padding(
                                padding: EdgeInsets.all(5.0),
                                child: Text("VOLUME"))),
                      ),
                      TableCell(
                        verticalAlignment: TableCellVerticalAlignment.middle,
                        child: Container(
                            height: 32,
                            width: 32,
                            color: Colors.grey,
                            alignment: Alignment.centerRight,
                            child: Padding(
                                padding: const EdgeInsets.all(5.0),
                                child: Text(price.last.volume.toString()))),
                      ),
                    ]),
                  ],
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              Container(
                  alignment: Alignment.centerLeft,
                  child: const Text(
                    'News',
                    style: TextStyle(
                        color: Colors.black,
                        fontSize: 30,
                        fontWeight: FontWeight.bold),
                  )),
              const SizedBox(
                height: 10,
              ),
              // StreamBuilder(
              //   stream: bloc.stream1,
              //   builder: (context, snapshot) {
              //     final results = snapshot.data;
              //     return const Center(child: Text("No data"));
              //   },
              // ),
            ],
          ),
        ),
      ),
      floatingActionButton: _buildWatchlistButton(context, stockSymbol),
    );
  }

  Widget _buildWatchlistButton(BuildContext context, String symbol) {
    return BlocBuilder<DatabaseBloc, DatabaseState>(builder: (context, state) {
      var x = FirebaseAuth.instance.currentUser?.email;
      var generate = generateRandomString(10);
      UserSymbol add = UserSymbol(uid: generate, email: x!, symbol: symbol);
      print(state.toString());
      if (state is DatabaseInitial) {
        BlocProvider.of<DatabaseBloc>(context).add(DatabaseFetched(x));
      }

      if (state is DatabaseSuccess) {
        if (state.listOfUserData.isEmpty) {
          return FloatingActionButton(
            onPressed: () {
              DatabaseRepositoryImpl().saveUserData(add);
              Navigator.pushReplacement(context,
                  MaterialPageRoute(builder: (context) => const MainScreen()));
              ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Added to watchlist')));
            },
            child: const Icon(Icons.add),
          );
        }

        for (var element in state.listOfUserData) {
          if (element.symbol == symbol) {
            return FloatingActionButton(
              onPressed: () {
                BlocProvider.of<DatabaseBloc>(context)
                    .add(DatabaseRemoveEvent(x, symbol));
                Timer(Duration(milliseconds: 500), () {
                  ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Removed from watchlist')));
                  Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const MainScreen()));
                });
              },
              child: const Icon(Icons.delete),
            );
          } else {
            return FloatingActionButton(
              onPressed: () {
                BlocProvider.of<DatabaseBloc>(context)
                    .add(DatabaseAddEvent(add));
                ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Added to watchlist')));
                Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const MainScreen()));
              },
              child: const Icon(Icons.add),
            );
          }
        }
      }

      return Container();
    });
  }

  String generateRandomString(int length) {
    final _random = Random();
    const _availableChars =
        'AaBbCcDdEeFfGgHhIiJjKkLlMmNnOoPpQqRrSsTtUuVvWwXxYyZz1234567890';
    final randomString = List.generate(length,
            (index) => _availableChars[_random.nextInt(_availableChars.length)])
        .join();

    return randomString;
  }
}
