import 'package:rxdart/rxdart.dart';

import '../resources/repository.dart';
import '../models/account_model.dart';

class AccountBloc {
  final _repository = Repository();
  final _accountsFetcher = PublishSubject<List<AccountModel>>();

  Observable<List<AccountModel>> get accounts => _accountsFetcher.stream;

  fetchAccounts(String publicKey, String secret) async {
    List<AccountModel> accounts =
        await _repository.fetchAccounts(publicKey, secret);
    _accountsFetcher.sink.add(accounts);
  }

  dispose() {
    _accountsFetcher.close();
  }
}
