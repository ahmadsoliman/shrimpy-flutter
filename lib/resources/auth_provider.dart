import 'dart:convert';
import 'dart:math';
import 'package:crypto/crypto.dart';
import 'package:flutter/foundation.dart';

class AuthProvider with ChangeNotifier {
  String _publicKey = '';
  String _secret = '';

  setKeys(publicKey, secret) {
    _publicKey = publicKey;
    _secret = secret;
  }

  _getSignature(int nonce, String url, String method, {secret}) {
    var prehashString = url + method + nonce.toString();
    var prehashStringBytes = utf8.encode(prehashString);

    final key = base64.decode(secret ?? _secret);

    var hmacSha256 = new Hmac(sha256, key); // HMAC-SHA256
    var digest = hmacSha256.convert(prehashStringBytes);

    return base64.encode(digest.bytes);
  }

  Map<String, String> getHeaders(url, {method = 'GET', publicKey, secret}) {
    final nonce =
        DateTime.now().millisecondsSinceEpoch - Random().nextInt(10000);
    return {
      'SHRIMPY-API-KEY': publicKey ?? _publicKey,
      'SHRIMPY-API-NONCE': nonce.toString(),
      'SHRIMPY-API-SIGNATURE': _getSignature(nonce, url, method, secret: secret)
    };
  }
}
