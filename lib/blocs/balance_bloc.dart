import 'package:rxdart/rxdart.dart';

import '../resources/repository.dart';
import '../models/balance_model.dart';

class BalanceBloc {
  final _repository = Repository();
  final _balancesFetcher = Map<int, PublishSubject<AccountBalancesModel>>();

  Observable<AccountBalancesModel> accountBalances(int accountId) =>
      _balancesFetcher[accountId] != null
          ? _balancesFetcher[accountId].stream
          : Observable.empty();

  fetchBalances(accountId, String publicKey, String secret) async {
    AccountBalancesModel balances =
        await _repository.fetchAccountBalances(accountId, publicKey, secret);
    if (!_balancesFetcher.containsKey(accountId)) {
      _balancesFetcher[accountId] = PublishSubject<AccountBalancesModel>();
    }
    _balancesFetcher[accountId].sink.add(balances);
  }

  dispose() {
    _balancesFetcher.forEach((key, value) {
      value.sink.close();
    });
  }
}
