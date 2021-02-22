import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' show Client;
import 'package:crypto/crypto.dart';

import '../models/account_model.dart';

class AccountApiProvider {
  Client client = Client();

  getSignature(nonce) {
    const secret = '[Secret]';
    const pathname = '/v1/accounts';

    const method = 'GET';
    var prehashString = pathname + method + nonce.toString();
    var prehashStringBytes = utf8.encode(prehashString);

    final key = base64.decode(secret);

    var hmacSha256 = new Hmac(sha256, key); // HMAC-SHA256
    var digest = hmacSha256.convert(prehashStringBytes);

    return base64.encode(digest.bytes);
  }

  Future<List<AccountModel>> fetchAccounts() async {
    final nonce = DateTime.now().millisecondsSinceEpoch;
    final response =
        await client.get('https://api.shrimpy.io/v1/accounts', headers: {
      'SHRIMPY-API-KEY':
          'b43dc9428371c333d6cdc522e2c184a6103269f5dea87cc5382292d76f0d3fce',
      'SHRIMPY-API-NONCE': nonce.toString(),
      'SHRIMPY-API-SIGNATURE': getSignature(nonce)
    });

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
