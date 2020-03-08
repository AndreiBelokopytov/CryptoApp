import '../data/crypto_data.dart';
import '../dependency_injection.dart';

abstract class CryptoListViewContract {
  void onLoadCryptoComplete(List<Crypto> items);
  void onLoadCryptoError(Object error);
}

class CryptoListPresenter {
  final CryptoListViewContract _view;
  CryptoRepository _repository;

  CryptoListPresenter(this._view) {
    _repository = Injector().cryptoRepository;
  }

  void loadCurrencies() {
    _repository
        .fetchCurrencies()
        .then(_view.onLoadCryptoComplete)
        .catchError(_view.onLoadCryptoError);
  }
}
