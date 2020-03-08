import 'dart:async';

class Crypto {
  String name;
  String price;
  String percentChange;
  String symbol;

  Crypto({this.name, this.price, this.percentChange, this.symbol});

  Crypto.fromJSON(Map<String, dynamic> map)
      : name = map['name'],
        price = map['price_usd'],
        percentChange = map['percent_change_1h'],
        symbol = map['symbol'];
}

abstract class CryptoRepository {
  Future<List<Crypto>> fetchCurrencies();
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
