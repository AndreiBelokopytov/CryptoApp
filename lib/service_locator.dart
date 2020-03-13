import 'package:get_it/get_it.dart';
import 'bloc/currencies_bloc.dart';
import 'bloc/favorites_bloc.dart';
import 'data/crypto_data.dart';
import 'data/crypto_data_prod.dart';
import 'data/favorites_data.dart';
import 'data/favorites_data_mock.dart';

GetIt sl = GetIt.instance;

abstract class ServiceLocator {
  static void setup() {
    sl.registerSingleton<CryptoRepository>(ProdCryptoRepository());
    sl.registerSingleton<FavoritesRepository>(MockFavoritesRepository());
    sl.registerFactory<CurrenciesBloc>(
        () => CurrenciesBloc(sl<CryptoRepository>()));
    sl.registerFactory<FavoritesBloc>(
        () => FavoritesBloc(sl<FavoritesRepository>()));
  }
}
