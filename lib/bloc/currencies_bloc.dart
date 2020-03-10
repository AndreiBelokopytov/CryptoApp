import 'dart:async';
import 'package:meta/meta.dart';
import 'package:rxdart/rxdart.dart';
import '../bloc/bloc.dart';
import '../data/crypto_data.dart';
import '../dependency_injection.dart';

class CurrenciesBloc implements Bloc {
  static const _defaultType = CryptoType.all;

  final CryptoRepository _repository;
  final _currenciesController = BehaviorSubject<CurrenciesState>.seeded(
      CurrenciesUninitialized(_defaultType));
  final _pageController = StreamController<int>();
  final _typeController = StreamController<CryptoType>();

  Stream<CurrenciesState> get state => _currenciesController.stream;
  Sink<int> get page => _pageController.sink;
  Sink<CryptoType> get type => _typeController.sink;

  CurrenciesBloc() : _repository = Injector().cryptoRepository;

  @override
  void init() {
    _pageController.stream.listen(_fetchPagedData);
    _typeController.stream.listen(_refreshCurrencies);
  }

  @override
  void dispose() {
    _currenciesController.close();
    _pageController.close();
    _typeController.close();
  }

  Future<void> _fetchPagedData([int page = 1]) async {
    List<Crypto> currencies;
    final lastState = _currenciesController.value;

    if (lastState is CurrenciesLoaded) {
      if (lastState.allCurrenciesLoaded || lastState.loading) {
        return;
      }

      _currenciesController.add(CurrenciesLoaded(
          currencies: lastState.currencies,
          page: lastState.page,
          type: lastState.type,
          allCurrenciesLoaded: lastState.allCurrenciesLoaded,
          loading: true));
    }

    try {
      currencies =
          await _repository.fetchCurrencies(page: page, type: lastState.type);
    } on FetchDataException catch (e) {
      print(e);
      // TODO: handle exception
    }

    _currenciesController.add(CurrenciesLoaded(
        currencies: [
          if (lastState is CurrenciesLoaded) ...lastState.currencies,
          ...currencies
        ],
        page: page,
        type: lastState.type,
        allCurrenciesLoaded: _repository.allCurrenciesLoaded));
  }

  Future<void> _refreshCurrencies(CryptoType type) async {
    List<Crypto> currencies;

    _currenciesController.add(CurrenciesUninitialized(type));

    try {
      currencies = await _repository.fetchCurrencies(type: type);
    } on FetchDataException catch (e) {
      print(e);
      //TODO: handle exception
    }

    _currenciesController.add(CurrenciesLoaded(
        currencies: currencies,
        page: 1,
        allCurrenciesLoaded: _repository.allCurrenciesLoaded,
        type: type
    ));
  }
}

abstract class CurrenciesState {
  final CryptoType type;

  CurrenciesState(this.type);
}

class CurrenciesUninitialized extends CurrenciesState {
  CurrenciesUninitialized(CryptoType type) : super(type);
}

class CurrenciesLoaded extends CurrenciesState {
  final List<Crypto> currencies;
  final int page;
  final bool allCurrenciesLoaded;
  final bool loading;

  CurrenciesLoaded(
      {@required this.currencies,
      @required this.page,
      @required this.allCurrenciesLoaded,
      @required CryptoType type,
      this.loading = false})
      : super(type);
}

class CurrenciesBlocCriteria {
  int page;
  CryptoType type;

  CurrenciesBlocCriteria({@required this.page, @required this.type});
}
