import 'package:rxdart/rxdart.dart';

import '../resources/repository.dart';
import '../models/account_model.dart';

class _AccountBloc {
  final _repository = Repository();
  final _accountsFetcher = PublishSubject<List<AccountModel>>();

  Observable<List<AccountModel>> get accounts => _accountsFetcher.stream;

  fetchAccounts() async {
    List<AccountModel> accounts = await _repository.fetchAccounts();
    _accountsFetcher.sink.add(accounts);
  }

  dispose() {
    _accountsFetcher.close();
  }
}

final bloc = _AccountBloc();
