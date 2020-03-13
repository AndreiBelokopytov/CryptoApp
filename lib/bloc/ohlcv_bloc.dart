import 'dart:async';
import 'package:rxdart/rxdart.dart';
import '../data/ohlcv_data.dart';
import 'bloc.dart';

class OHLCVBloc extends Bloc {
  final OHLCVRepository ohlcvRepository;
  final _ohlcvController =
      BehaviorSubject<OHLCVState>.seeded(OHLCVStateUninitialized());

  Stream<OHLCVState> get state => _ohlcvController.stream;

  OHLCVBloc(this.ohlcvRepository);

  @override
  void dispose() {
    _ohlcvController.close();
  }

  @override
  void init() {
    _fetchOHLCV();
  }

  Future<void> _fetchOHLCV() async {
    _ohlcvController.add(OHLCVStateUninitialized());
    try {
      final ohlcvData = await ohlcvRepository.fetchOHLCV();
      _ohlcvController.add(OHLCVStateLoaded(ohlcvData));
    } on Exception catch (e) {
      print(e);
      //TODO: handle exception
    }
  }
}

abstract class OHLCVState {}

class OHLCVStateUninitialized extends OHLCVState {}

class OHLCVStateLoaded extends OHLCVState {
  final List<OHLCV> ohlcvData;

  OHLCVStateLoaded(this.ohlcvData);
}
