class BalanceModel {
  String _symbol;
  double _nativeValue;
  double _btcValue;
  double _usdValue;

  BalanceModel.fromJson(Map<String, dynamic> parsedJson) {
    _symbol = parsedJson['symbol'];
    _nativeValue = double.parse(parsedJson['nativeValue'].toString());
    _btcValue = parsedJson['btcValue'];
    _usdValue = parsedJson['usdValue'];
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
    _balances = [];
    parsedJson['balances'] ??
        [].forEach((item) => _balances.add(BalanceModel.fromJson(item)));
  }

  DateTime get retrievedAt => _retrievedAt;

  List<BalanceModel> get balances => _balances;
}
