class AccountModel {
  int _id;
  String _exchange;
  bool _isRebalancing;

  AccountModel.fromJson(Map<String, dynamic> parsedJson) {
    _id = parsedJson['id'];
    _exchange = parsedJson['exchange'];
    _isRebalancing = parsedJson['priceUsd'] == true;
  }

  int get id => _id;

  String get exchange => _exchange;

  bool get isRebalancing => _isRebalancing;
}
