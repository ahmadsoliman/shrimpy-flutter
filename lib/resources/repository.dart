import 'dart:async';

import '../models/exchange_model.dart';
import '../models/ticker_model.dart';
import '../models/account_model.dart';
import '../models/balance_model.dart';

import './auth_provider.dart';
import './ticker_api_provider.dart';
import './account_api_provider.dart';
import './balance_api_provider.dart';

class Repository {
  final authProvider = AuthProvider();
  final tickersApiProvider = TickerApiProvider();
  final accountsApiProvider = AccountApiProvider();
  final balancesApiProvider = BalanceApiProvider();

  setKeys(publicKey, secret) => authProvider.setKeys(publicKey, secret);

  getHeaders(url, {method = 'GET', publicKey, secret}) => authProvider
      .getHeaders(url, method: method, publicKey: publicKey, secret: secret);

  Future<List<TickerModel>> fetchAllTickers() =>
      tickersApiProvider.fetchTickerList(Exchange.BINANCE);

  Future<List<AccountModel>> fetchAccounts(String publicKey, String secret) =>
      accountsApiProvider.fetchAccounts(publicKey, secret);

  Future<AccountBalancesModel> fetchAccountBalances(
          accountId, String publicKey, String secret) =>
      balancesApiProvider.fetchAccountBalance(accountId, publicKey, secret);
}
