import 'package:Shrimpy/models/account_model.dart';
import 'package:Shrimpy/models/balance_model.dart';
import 'package:flutter/material.dart';
import '../blocs/account_bloc.dart';
import '../blocs/balance_bloc.dart';
import 'app_drawer.dart';

class AccountList extends StatefulWidget {
  static const routeName = '/accounts';
  AccountList();

  @override
  _AccountListState createState() => _AccountListState();
}

class _AccountListState extends State<AccountList> {
  final _publicKeyController = TextEditingController();
  final _secretController = TextEditingController();

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    accountBloc.dispose();
    balanceBloc.dispose();
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
        stream: accountBloc.accounts,
        builder: (context, AsyncSnapshot<List<AccountModel>> snapshot) {
          return Container(
            constraints: BoxConstraints(minHeight: 320),
            padding: EdgeInsets.all(16.0),
            child: Column(
              children: [
                Column(
                  children: [
                    Center(
                      child: TextField(
                        controller: _publicKeyController,
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          hintText: 'Shrimpy.io API Public Key',
                        ),
                      ),
                    ),
                    Center(
                      child: TextField(
                        obscureText: true,
                        controller: _secretController,
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          hintText: 'Shrimpy.io API Private Key',
                        ),
                      ),
                    ),
                    RaisedButton(
                      onPressed: () => this.loadAccounts(
                          _publicKeyController.value.text,
                          _secretController.value.text),
                      child: Text("Load Accounts"),
                    ),
                  ],
                ),
                SizedBox(
                  height: 20,
                ),
                if (snapshot.hasData)
                  buildList(snapshot)
                else if (snapshot.hasError)
                  Center(child: Text(snapshot.error.toString()))
                // else
                //   Center(child: CircularProgressIndicator())
              ],
            ),
          );
        },
      ),
    );
  }

  Widget wrapWithPaddedContainer(Widget w) {
    return Container(padding: EdgeInsets.all(10), child: w);
  }

  Widget buildList(AsyncSnapshot<List<AccountModel>> snapshot) {
    balanceBloc.fetchBalances(
      snapshot.data[0].id,
      _publicKeyController.value.text,
      _secretController.value.text,
    );
    return SingleChildScrollView(
      scrollDirection: Axis.vertical,
      child: Column(
          children: snapshot.data
              .map(
                (item) => Column(
                  children: [
                    wrapWithPaddedContainer(Text(
                      '${item.id} (${item.exchange})',
                    )),
                    StreamBuilder(
                      stream: balanceBloc.accountBalances,
                      builder: (context,
                          AsyncSnapshot<AccountBalancesModel> snapshot) {
                        return Column(
                            children: snapshot.data.balances
                                .map((balance) => Row(
                                      children: [
                                        wrapWithPaddedContainer(Text(
                                          '${balance.symbol} ${balance.nativeValue}',
                                        )),
                                        wrapWithPaddedContainer(Text(
                                          '\$${balance.usdValue.toStringAsFixed(2)}',
                                        )),
                                        wrapWithPaddedContainer(Text(
                                          '${(balance.btcValue * 1000).toStringAsFixed(4)}mBTC',
                                        )),
                                      ],
                                    ))
                                .toList());
                      },
                    ),
                    wrapWithPaddedContainer(
                      Text(
                        item.isRebalancing ? 'Yes' : 'No',
                      ),
                    ),
                  ],
                ),
              )
              .toList()),
    );
  }

  loadAccounts(publicKey, secret) {
    accountBloc.fetchAccounts(publicKey, secret);
  }
}
