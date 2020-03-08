import 'data/crypto_data.dart';
import 'data/crypto_data_mock.dart';
import 'data/crypto_data_prod.dart';

enum Flavor { mock, prod }

//DI
class Injector {
  static final Injector _singleton = Injector._internal();
  static Flavor _flavor;

  static void configure(Flavor flavor) {
    _flavor = flavor;
  }

  factory Injector() {
    return _singleton;
  }

  Injector._internal();

  CryptoRepository get cryptoRepository {
    switch (_flavor) {
      case Flavor.mock:
        return MockCryptoRepository();
      default:
        return ProdCryptoRepository();
    }
  }
}
