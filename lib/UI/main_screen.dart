import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:stock_app/BLoC/auth_bloc.dart';
import 'package:stock_app/BLoC/database_bloc.dart';
import 'package:stock_app/DataLayer/database_repository_impl.dart';
import 'package:stock_app/UI/login_screen.dart';
import 'package:stock_app/UI/stock_search_screen.dart';
import 'package:stock_app/UI/watchlist_tile.dart';

import '../DataLayer/user_symbol.dart';

class MainScreen extends StatelessWidget {
  const MainScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var x = DatabaseBloc(DatabaseRepositoryImpl());
    final user = FirebaseAuth.instance.currentUser;

    return WillPopScope(
        child: BlocProvider<DatabaseBloc>(
          create: (context) => x,
          child: Scaffold(
            body: Column(
              children: <Widget>[
                Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Padding(
                          padding:
                              const EdgeInsets.fromLTRB(30.0, 30.0, 0, 30.0),
                          child: Text('Hi, ${user?.email}')),
                      const Expanded(child: SizedBox()),
                      Container(
                        alignment: Alignment.centerRight,
                        child: Padding(
                            padding: const EdgeInsets.all(5.0),
                            child: IconButton(
                                icon: const Icon(Icons.logout),
                                tooltip: 'Log Out',
                                onPressed: () {
                                  BlocProvider.of<AuthBloc>(context)
                                      .add(SignOutRequested());
                                  Navigator.pushReplacement(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              const LoginScreen()));
                                })),
                      )
                    ]),
                Padding(
                  padding: const EdgeInsets.fromLTRB(10.0, 0, 10.0, 10.0),
                  child: TextField(
                    decoration: InputDecoration(
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10.0)),
                        hintText: 'Enter a symbol'),
                    onTap: () => Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const StockSearchScreen())),
                  ),
                ),
                Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Container(
                        alignment: Alignment.centerLeft,
                        child: const Text(
                          'Watchlist',
                          style: TextStyle(
                              color: Colors.black,
                              fontSize: 30,
                              fontWeight: FontWeight.bold),
                        ))),
                Expanded(
                  child: _buildResults(context),
                )
              ],
            ),
          ),
        ),
        onWillPop: () async {
          SystemNavigator.pop();
          return false;
        });
  }

  Widget _buildResults(BuildContext context) {
    var x = FirebaseAuth.instance.currentUser?.email;
    return BlocBuilder<DatabaseBloc, DatabaseState>(builder: (context, state) {
      if (state is DatabaseInitial) {
        BlocProvider.of<DatabaseBloc>(context).add(DatabaseFetched(x!));
      }

      if (state is DatabaseSuccess) {
        if (state.listOfUserData.isEmpty) {
          return const Center(child: Text("No data"));
        } else {
          return _buildSearchResults(state.listOfUserData);
        }
      }

      return Container();
    });
  }

  Widget _buildSearchResults(List<UserSymbol> list) {
    return Padding(
        padding: const EdgeInsets.fromLTRB(10.0, 0, 10.0, 10.0),
        child: ListView.builder(
          itemCount: list.length,
          itemBuilder: (context, index) {
            final symbol = list[index];
            return WatchlistTile(
              userSymbol: symbol,
            );
          },
        ));
  }
}
