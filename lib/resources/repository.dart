import 'dart:async';

import '../models/exchange_model.dart';
import '../models/ticker_model.dart';
import './ticker_api_provider.dart';

class Repository {
  final tickersApiProvider = TickerApiProvider();

  Future<List<TickerModel>> fetchAllTickers() =>
      tickersApiProvider.fetchTickerList(Exchange.BINANCE);
}
