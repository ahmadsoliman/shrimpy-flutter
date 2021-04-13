import 'package:Shrimpy/models/account_model.dart';
import 'package:Shrimpy/models/balance_model.dart';
import 'package:flutter/material.dart';
import 'package:encrypt/encrypt.dart' as Encrypt;
import 'dart:convert';

import '../services/storage.dart';
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
  final _storage = SecureStorageService();

  final _publicKeyController = TextEditingController();
  final _secretController = TextEditingController();
  final _passwordController = TextEditingController();

  bool _isSecretSaved = false;

  @override
  void initState() {
    super.initState();

    // initStorage();
  }

  @override
  void dispose() {
    accountBloc.dispose();
    balanceBloc.dispose();
    super.dispose();
  }

  initStorage() async {
    String publicKey = await _storage.readValue('publicKey');
    if (publicKey != null && publicKey.length > 0) {
      this._publicKeyController.text = publicKey;
      String encryptedSecret = await _storage.readValue('privateKey');
      if (encryptedSecret != null && encryptedSecret.length > 0) {
        _secretController.text = encryptedSecret;
        _isSecretSaved = true;
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<void>(
        future: initStorage(),
        builder: (BuildContext context, AsyncSnapshot<void> snapshot) {
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
                          if (!_isSecretSaved)
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
                          Center(
                            child: TextField(
                              obscureText: true,
                              controller: _passwordController,
                              decoration: InputDecoration(
                                border: InputBorder.none,
                                hintText: _isSecretSaved
                                    ? 'Password'
                                    : 'New Password',
                              ),
                            ),
                          ),
                          RaisedButton(
                            onPressed: () => this.loadAccounts(snapshot),
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
        });
  }

  Widget wrapWithPaddedContainer(Widget w) {
    return Container(padding: EdgeInsets.all(10), child: w);
  }

  Widget buildList(AsyncSnapshot<List<AccountModel>> snapshot) {
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
                    wrapWithPaddedContainer(
                      Text(
                        item.isRebalancing ? 'Yes' : 'No',
                      ),
                    ),
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
                  ],
                ),
              )
              .toList()),
    );
  }

  loadAccounts(AsyncSnapshot<List<AccountModel>> snapshot) {
    final String publicKey = _publicKeyController.text;
    _storage.writeValue('publicKey', publicKey);
    var secret = '';

    final String password = _passwordController.text;
    final key = Encrypt.Key.fromUtf8(password.padRight(32));
    final iv = Encrypt.IV.fromLength(16);
    final encrypter = Encrypt.Encrypter(Encrypt.AES(key));

    if (_isSecretSaved) {
      final String encryptedSecret = _secretController.text;
      final decrypted = encrypter.decrypt64(encryptedSecret, iv: iv);

      secret = decrypted + '';
    } else {
      secret = _secretController.text;

      final encrypted = encrypter.encrypt(secret, iv: iv);

      _storage.writeValue('privateKey', encrypted.base64);
    }
    accountBloc.fetchAccounts(publicKey, secret);
    balanceBloc.fetchBalances(
      snapshot.data[0].id,
      publicKey,
      secret,
    );
  }
}
