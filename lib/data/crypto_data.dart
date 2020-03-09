import 'dart:async';

class Crypto {
  String name;
  double price;
  double percentChange;
  String symbol;

  Crypto({this.name, this.price, this.percentChange, this.symbol});

  Crypto.fromJSON(Map<String, dynamic> map)
      : name = map['name'],
        price = map['quote']['USD']['price'],
        percentChange = map['quote']['USD']['percent_change_1h'],
        symbol = map['symbol'];
}

abstract class CryptoRepository {
  bool get allCurrenciesLoaded;
  Future<List<Crypto>> fetchCurrencies({int page});
}

class FetchDataException implements Exception {
  final String _message;

  FetchDataException([this._message]);

  @override
  String toString() {
    if (_message == null) return 'Exception';
    return 'Exception: $_message';
  }
}
