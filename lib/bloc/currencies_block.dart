import 'dart:async';
import '../bloc/bloc.dart';
import '../data/crypto_data.dart';
import '../dependency_injection.dart';

class CurrenciesBlock implements Bloc {
  final CryptoRepository _repository;
  final _currenciesController = StreamController<CurrenciesState>();

  Stream<CurrenciesState> get currencies => _currenciesController.stream;

  CurrenciesBlock(): _repository = Injector().cryptoRepository;

  void fetchCurrencies() async {
    _currenciesController.add(CurrenciesLoading());
    final currencies = await _repository.fetchCurrencies();
    _currenciesController.add(CurrenciesLoaded(currencies));
  }

  @override
  void init() {
    fetchCurrencies();
  }

  @override
  void dispose() {
    _currenciesController.close();
  }
}

abstract class CurrenciesState {
}

class CurrenciesUninitialized extends CurrenciesState {}

class CurrenciesLoading extends CurrenciesState {}

class CurrenciesLoaded extends CurrenciesState {
  List<Crypto> currencies;

  CurrenciesLoaded(this.currencies);
}

