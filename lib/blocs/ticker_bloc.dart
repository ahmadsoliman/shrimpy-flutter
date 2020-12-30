import 'package:rxdart/rxdart.dart';

import '../resources/repository.dart';
import '../models/ticker_model.dart';

class _TickerBloc {
  final _repository = Repository();
  final _tickersFetcher = PublishSubject<List<TickerModel>>();

  Observable<List<TickerModel>> get allTickers => _tickersFetcher.stream;

  fetchAllTickers() async {
    List<TickerModel> tickers = await _repository.fetchAllTickers();
    _tickersFetcher.sink.add(tickers);
  }

  dispose() {
    _tickersFetcher.close();
  }
}

final bloc = _TickerBloc();
