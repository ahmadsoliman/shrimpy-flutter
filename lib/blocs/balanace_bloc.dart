import 'package:rxdart/rxdart.dart';

import '../resources/repository.dart';
import '../models/balance_model.dart';

class _BalanceBloc {
  final _repository = Repository();
  final _balancesFetcher = PublishSubject<AccountBalancesModel>();

  Observable<AccountBalancesModel> get accountBalances =>
      _balancesFetcher.stream;

  fetchAllTickers(accountId) async {
    AccountBalancesModel balances =
        await _repository.fetchAccountBalances(accountId);
    _balancesFetcher.sink.add(balances);
  }

  dispose() {
    _balancesFetcher.close();
  }
}

final bloc = _BalanceBloc();
