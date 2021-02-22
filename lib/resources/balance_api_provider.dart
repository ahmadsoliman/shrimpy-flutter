import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' show Client;

import '../models/balance_model.dart';

class BalanceApiProvider {
  Client client = Client();

  Future<AccountBalancesModel> fetchAccountBalance(
      int exchangeAccountId) async {
    final response = await client
        .get('https://api.shrimpy.io/v1/accounts/$exchangeAccountId/balance');

    if (response.statusCode < 400) {
      // If the call to the server was successful, parse the JSON
      final dynamic balances = json.decode(response.body);
      return AccountBalancesModel.fromJson(balances);
    } else {
      // If that call was not successful, throw an error.
      throw Exception('Failed to load accounts');
    }
  }
}
