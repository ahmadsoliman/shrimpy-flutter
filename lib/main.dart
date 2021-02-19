import 'package:flutter/material.dart';

import './ui/ticker_list.dart';

void main() {
  runApp(App());
}

class App extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData.light(),
      title: "Shrimpy",
      home: Scaffold(
        body: TickerList(),
      ),
    );
  }
}
