import 'package:flutter/material.dart';

import './ui/ticker_list.dart';
import './ui/account_list.dart';

void main() {
  runApp(App());
}

class App extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData.light(),
      home: Scaffold(
        body: TickerList(),
      ),
      routes: {
        TickerList.routeName: (ctx) => TickerList(),
        AccountList.routeName: (ctx) => AccountList()
      },
    );
  }
}
