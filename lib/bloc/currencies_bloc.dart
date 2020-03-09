import 'dart:async';
import 'package:rxdart/rxdart.dart';
import '../bloc/bloc.dart';
import '../data/crypto_data.dart';
import '../dependency_injection.dart';

class CurrenciesBloc implements Bloc {
  final CryptoRepository _repository;
  final _currenciesController =
      BehaviorSubject<CurrenciesState>.seeded(CurrenciesUninitialized());

  Stream<CurrenciesState> get currencies => _currenciesController.stream;

  CurrenciesBloc() : _repository = Injector().cryptoRepository;

  Future<void> fetchCurrencies({int page = 1}) async {
    List<Crypto> currencies;
    final lastState = _currenciesController.value;

    if (lastState is CurrenciesLoaded) {
      if (lastState.allCurrenciesLoaded || lastState.loading) {
        return;
      }

      _currenciesController.add(CurrenciesLoaded(
          currencies: lastState.currencies,
          page: lastState.page,
          allCurrenciesLoaded: lastState.allCurrenciesLoaded,
          loading: true));
    }

    try {
      currencies = await _repository.fetchCurrencies(page: page);
    } on FetchDataException catch (e) {
      print(e);
      // TODO: handle exception
    }

    _currenciesController.add(CurrenciesLoaded(currencies: [
      if (lastState is CurrenciesLoaded) ...lastState.currencies,
      ...currencies
    ], page: page, allCurrenciesLoaded: _repository.allCurrenciesLoaded));
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

abstract class CurrenciesState {}

class CurrenciesUninitialized extends CurrenciesState {}

class CurrenciesLoaded extends CurrenciesState {
  final List<Crypto> currencies;
  final int page;
  final bool allCurrenciesLoaded;
  final bool loading;

  CurrenciesLoaded(
      {this.currencies,
      this.page,
      this.allCurrenciesLoaded,
      this.loading = false});
}
