import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:stock_app/DataLayer/user_symbol.dart';
import 'package:stock_app/UI/stock_detail_screen.dart';

class WatchlistTile extends StatelessWidget {
  final UserSymbol userSymbol;

  const WatchlistTile({Key? key, required this.userSymbol}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
        child: ListTile(
            title: Text(userSymbol.symbol.toString()),
            leading: const Icon(Icons.leaderboard),
            trailing: const Icon(Icons.navigate_next),
            onTap: () {
              Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => StockDetailScreen(
                        stockSymbol: userSymbol.symbol.toString(),
                      )));
            }));
  }
}
