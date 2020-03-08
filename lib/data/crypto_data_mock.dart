import 'dart:async';
import 'crypto_data.dart';

class MockCryptoRepository implements CryptoRepository {
  @override
  Future<List<Crypto>> fetchCurrencies() {
    return Future.value(currencies);
  }
}

List<Crypto> currencies= [
  Crypto(name: "Bitcoin", price: "800.60", percentChange: "-0.7"),
  Crypto(name: "Ethereum", price: "650.30", percentChange: "0.85"),
  Crypto(name: "Ripple", price: "300.00", percentChange: "-0.25"),
];