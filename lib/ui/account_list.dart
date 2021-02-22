import 'package:Shrimpy/models/account_model.dart';
import 'package:flutter/material.dart';
import '../blocs/account_bloc.dart';
import 'app_drawer.dart';

class AccountList extends StatefulWidget {
  static const routeName = '/accounts';
  AccountList();

  @override
  _AccountListState createState() => _AccountListState();
}

class _AccountListState extends State<AccountList> {
  @override
  void initState() {
    super.initState();
    bloc.fetchAccounts();
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
        title: Text('Accounts'),
      ),
      drawer: AppDrawer(),
      body: StreamBuilder(
        stream: bloc.accounts,
        builder: (context, AsyncSnapshot<List<AccountModel>> snapshot) {
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

  Widget buildList(AsyncSnapshot<List<AccountModel>> snapshot) {
    return SingleChildScrollView(
      scrollDirection: Axis.vertical,
      child: Table(
        border: TableBorder.all(),
        children: [
          TableRow(
            children: [
              wrapWithPaddedContainer(Text(
                "AccountId (Exchange)",
                textScaleFactor: 1.7,
              )),
              wrapWithPaddedContainer(
                  Text("Is Rebalancing", textScaleFactor: 1.7)),
            ],
          ),
          ...snapshot.data
              .map(
                (item) => TableRow(
                  children: [
                    wrapWithPaddedContainer(Text(
                      '${item.id} (${item.exchange})',
                    )),
                    wrapWithPaddedContainer(Text(
                      item.isRebalancing ? 'Yes' : 'No',
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
