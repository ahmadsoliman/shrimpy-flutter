import 'package:flutter/material.dart';
import '../models/ticker_model.dart';
import '../blocs/ticker_bloc.dart';
import './app_drawer.dart';

class TickerList extends StatefulWidget {
  static const routeName = '/tickers';
  TickerList();

  @override
  _TickerListState createState() => _TickerListState();
}

class _TickerListState extends State<TickerList> {
  @override
  void initState() {
    super.initState();
    bloc.fetchAllTickers();
  }

  @override
  void dispose() {
    bloc.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('All Tickers'),
      ),
      drawer: AppDrawer(),
      body: StreamBuilder(
        stream: bloc.allTickers,
        builder: (context, AsyncSnapshot<List<TickerModel>> snapshot) {
          if (snapshot.hasData) {
            return buildList(snapshot);
          } else if (snapshot.hasError) {
            return Center(child: Text(snapshot.error.toString()));
          }
          return Center(child: CircularProgressIndicator());
        },
      ),
    );
  }

  Widget wrapWithPaddedContainer(Widget w) {
    return Container(padding: EdgeInsets.all(10), child: w);
  }

  Widget buildList(AsyncSnapshot<List<TickerModel>> snapshot) {
    return SingleChildScrollView(
      scrollDirection: Axis.vertical,
      child: Table(
        border: TableBorder.all(),
        columnWidths: {
          0: FixedColumnWidth(170),
          1: FixedColumnWidth(100),
          2: FlexColumnWidth(),
        },
        children: [
          TableRow(
            children: [
              wrapWithPaddedContainer(Text(
                "Coin",
                textScaleFactor: 1.7,
              )),
              wrapWithPaddedContainer(Text("Price \$", textScaleFactor: 1.7)),
              wrapWithPaddedContainer(Text("Price Btc", textScaleFactor: 1.7)),
            ],
          ),
          ...snapshot.data
              .map(
                (item) => TableRow(
                  children: [
                    wrapWithPaddedContainer(Text(
                      '${item.name} (${item.symbol})',
                    )),
                    wrapWithPaddedContainer(Text(
                      '\$${item.priceUsd.toStringAsFixed(2)}',
                    )),
                    wrapWithPaddedContainer(Text(
                      '${(item.priceBtc * 1000).toStringAsFixed(4)}mBTC',
                    )),
                  ],
                ),
              )
              .toList()
        ],
      ),
    );
  }
}
