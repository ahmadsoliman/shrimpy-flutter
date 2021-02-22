import 'dart:async';

import '../models/exchange_model.dart';
import '../models/ticker_model.dart';
import '../models/account_model.dart';
import '../models/balance_model.dart';

import './ticker_api_provider.dart';
import './account_api_provider.dart';
import './balance_api_provider.dart';

class Repository {
  final tickersApiProvider = TickerApiProvider();
  final accountsApiProvider = AccountApiProvider();
  final balancesApiProvider = BalanceApiProvider();

  Future<List<TickerModel>> fetchAllTickers() =>
      tickersApiProvider.fetchTickerList(Exchange.BINANCE);

  Future<List<AccountModel>> fetchAccounts() =>
      accountsApiProvider.fetchAccounts();

  Future<AccountBalancesModel> fetchAccountBalances(accountId) =>
      balancesApiProvider.fetchAccountBalance(accountId);
}
