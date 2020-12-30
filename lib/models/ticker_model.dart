class TickerModel {
  String _name;
  String _symbol;
  double _priceUsd;
  double _priceBtc;
  double _percentChange24hUsd;
  DateTime _lastUpdated;

  TickerModel.fromJson(Map<String, dynamic> parsedJson) {
    _name = parsedJson['name'];
    _symbol = parsedJson['symbol'];
    _priceUsd = double.parse(parsedJson['priceUsd']);
    _priceBtc = double.parse(parsedJson['priceBtc']);
    _percentChange24hUsd = double.parse(parsedJson['percentChange24hUsd']);
    _lastUpdated = DateTime.parse(parsedJson['lastUpdated']);
  }

  String get name => _name;

  String get symbol => _symbol;

  double get priceUsd => _priceUsd;

  double get priceBtc => _priceBtc;

  double get percentChange24hUsd => _percentChange24hUsd;

  DateTime get lastUpdated => _lastUpdated;
}
