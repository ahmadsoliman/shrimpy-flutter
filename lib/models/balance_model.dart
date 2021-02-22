class BalanceModel {
  String _symbol;
  double _nativeValue;
  double _btcValue;
  double _usdValue;

  BalanceModel.fromJson(Map<String, dynamic> parsedJson) {
    _symbol = parsedJson['symbol'];
    _nativeValue = double.parse(parsedJson['nativeValue']);
    _btcValue = double.parse(parsedJson['btcValue']);
    _usdValue = double.parse(parsedJson['usdValue']);
  }

  String get symbol => _symbol;
  double get nativeValue => _nativeValue;
  double get btcValue => _btcValue;
  double get usdValue => _usdValue;
}

class AccountBalancesModel {
  DateTime _retrievedAt;
  List<BalanceModel> _balances;

  AccountBalancesModel.fromJson(Map<String, dynamic> parsedJson) {
    _retrievedAt = DateTime.parse(parsedJson['retrievedAt']);
    _balances = parsedJson['balances']
        .map((item) => BalanceModel.fromJson(item))
        .toList();
  }

  DateTime get retrievedAt => _retrievedAt;

  List<BalanceModel> get balances => _balances;
}
