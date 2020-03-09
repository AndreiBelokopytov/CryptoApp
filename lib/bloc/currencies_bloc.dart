import 'dart:async';
import 'package:rxdart/rxdart.dart';
import '../bloc/bloc.dart';
import '../data/crypto_data.dart';
import '../dependency_injection.dart';

class CurrenciesBloc implements Bloc {
  final CryptoRepository _repository;
  final _currenciesController =
      BehaviorSubject<CurrenciesState>.seeded(CurrenciesUninitialized());
  final _pageController = StreamController<int>();

  Stream<CurrenciesState> get state => _currenciesController.stream;
  Sink<int> get page => _pageController.sink;

  CurrenciesBloc() : _repository = Injector().cryptoRepository;

  @override
  void init() {
    _pageController.stream.listen((page) => {
      _fetchCurrencies(page)
    });
  }

  @override
  void dispose() {
    _currenciesController.close();
    _pageController.close();
  }
  
  Future<void> _fetchCurrencies(int page) async {
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
