import 'package:flutter/material.dart';
import '../models/ticker_model.dart';
import '../blocs/ticker_bloc.dart';

class TickerList extends StatefulWidget {
  TickerList() {}

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

  Widget buildList(AsyncSnapshot<List<TickerModel>> snapshot) {
    return GridView.builder(
        itemCount: snapshot.data.length,
        gridDelegate:
            SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 1),
        itemBuilder: (BuildContext context, int index) {
          return SizedBox(
            height: 10,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Text(
                  '${snapshot.data[index].name} (${snapshot.data[index].symbol})',
                ),
                Text(
                  '\$${snapshot.data[index].priceUsd.toStringAsFixed(2)}',
                ),
                Text(
                  '${(snapshot.data[index].priceBtc * 1000).toStringAsFixed(4)}mBTC',
                ),
              ],
            ),
          );
        });
  }
}
