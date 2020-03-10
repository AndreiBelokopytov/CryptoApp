import 'dart:async';

class Crypto {
  int id;
  String name;
  double price;
  double percentChange;
  String symbol;

  Crypto({this.name, this.price, this.percentChange, this.symbol});

  Crypto.fromJSON(Map<String, dynamic> map)
      : id = map['id'],
        name = map['name'],
        // https://stackoverflow.com/questions/26417782/in-dart-is-there-a-quick-way-to-convert-int-to-double
        price = map['quote']['USD']['price'] + .0,
        percentChange = map['quote']['USD']['percent_change_1h'] + .0,
        symbol = map['symbol'];
}

abstract class CryptoRepository {
  bool get allCurrenciesLoaded;
  Future<List<Crypto>> fetchCurrencies({int page, CryptoType type});
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

enum CryptoType { all, coins, tokens }
