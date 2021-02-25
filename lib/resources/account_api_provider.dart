import 'dart:async';
import 'dart:convert';
import 'package:Shrimpy/resources/repository.dart';
import 'package:http/http.dart' show Client;

import '../models/account_model.dart';

class AccountApiProvider {
  Client client = Client();

  Future<List<AccountModel>> fetchAccounts(publicKey, secret) async {
    final headers = Repository()
        .getHeaders('/v1/accounts', publicKey: publicKey, secret: secret);
    final response = await client.get(
      'https://api.shrimpy.io/v1/accounts',
      headers: headers,
    );

    if (response.statusCode < 400) {
      // If the call to the server was successful, parse the JSON
      final List<dynamic> accountList = json.decode(response.body);
      var accounts =
          accountList.map((ticker) => AccountModel.fromJson(ticker)).toList();
      return accounts;
    } else {
      // If that call was not successful, throw an error.
      print(response.statusCode);
      print(response.body.toString());
      throw Exception('Failed to load accounts');
    }
  }
}
