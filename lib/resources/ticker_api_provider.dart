import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' show Client;

import '../models/ticker_model.dart';

class TickerApiProvider {
  Client client = Client();

  Future<List<TickerModel>> fetchTickerList(String exchange) async {
    final response =
        await client.get('https://api.shrimpy.io/v1/$exchange/ticker');

    if (response.statusCode < 400) {
      // If the call to the server was successful, parse the JSON
      final List<dynamic> tickerList = json.decode(response.body);
      var tickers =
          tickerList.map((ticker) => TickerModel.fromJson(ticker)).toList();
      tickers.sort((t1, t2) => t1.priceUsd > t2.priceUsd ? -1 : 1);
      return tickers;
    } else {
      // If that call was not successful, throw an error.
      throw Exception('Failed to load tickers');
    }
  }
}
