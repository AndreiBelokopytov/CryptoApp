import 'package:get_it/get_it.dart';
import 'bloc/currencies_bloc.dart';
import 'bloc/favorites_bloc.dart';
import 'data/crypto_data.dart';
import 'data/crypto_data_prod.dart';

GetIt sl = GetIt.instance;

abstract class ServiceLocator {
  static void setup() {
    sl.registerFactory<CryptoRepository>(() => ProdCryptoRepository());
    sl.registerFactory<CurrenciesBloc>(
        () => CurrenciesBloc(sl<CryptoRepository>()));
    sl.registerFactory<FavoritesBloc>(() => FavoritesBloc());
  }
}
