import 'package:flutter/material.dart';
import './ticker_list.dart';
import './account_list.dart';

class AppDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: <Widget>[
          AppBar(
            title: Text('Shrimpy.io'),
            automaticallyImplyLeading: false,
          ),
          Divider(),
          ListTile(
            leading: Icon(Icons.book),
            title: Text('All Tickers'),
            onTap: () {
              Navigator.of(context).pushReplacementNamed(TickerList.routeName);
            },
          ),
          Divider(),
          ListTile(
            leading: Icon(Icons.shop),
            title: Text('Dashboard'),
            onTap: () {
              Navigator.of(context).pushReplacementNamed(AccountList.routeName);
            },
          ),
          Divider(),
        ],
      ),
    );
  }
}
