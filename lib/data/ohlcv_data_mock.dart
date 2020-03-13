import 'ohlcv_data.dart';

class MockOHLCVRepository implements OHLCVRepository {
  @override
  Future<List<OHLCV>> fetchOHLCV() {
    return Future.value(ohlcv);
  }
}

List<OHLCV> ohlcv = [
  OHLCV(
      date: 1546300800000,
      high: 0.01232199,
      low: 0.012105,
      open: 0.01227412,
      close: 0.01224702,
      volume: 11.47474031),
  OHLCV(
      date: 1546315200000,
      high: 0.01235758,
      low: 0.01218015,
      open: 0.01225446,
      close: 0.01223056,
      volume: 6.96543437),
  OHLCV(
      date: 1546329600000,
      high: 0.01234246,
      low: 0.01217325,
      open: 0.012231,
      close: 0.01228311,
      volume: 7.10957659),
  OHLCV(
      date: 1546344000000,
      high: 0.01237977,
      low: 0.0122487,
      open: 0.01229189,
      close: 0.0122911,
      volume: 9.1454552),
  OHLCV(
      date: 1546358400000,
      high: 0.01245827,
      low: 0.01225163,
      open: 0.01228001,
      close: 0.01245827,
      volume: 20.97501172),
  OHLCV(
      date: 1546372800000,
      high: 0.01264831,
      low: 0.01239196,
      open: 0.01242936,
      close: 0.01249544,
      volume: 29.14045482),
  OHLCV(
      date: 1546387200000,
      high: 0.01259999,
      low: 0.01243199,
      open: 0.01249549,
      close: 0.01247901,
      volume: 10.03136424),
  OHLCV(
      date: 1546401600000,
      high: 0.01278436,
      low: 0.01247901,
      open: 0.01247901,
      close: 0.01275239,
      volume: 19.83723467),
  OHLCV(
      date: 1546416000000,
      high: 0.01286514,
      low: 0.01257456,
      open: 0.01275239,
      close: 0.01276012,
      volume: 60.39925402),
  OHLCV(
      date: 1546430400000,
      high: 0.01317618,
      low: 0.01269283,
      open: 0.01276022,
      close: 0.013,
      volume: 99.55834375),
  OHLCV(
      date: 1546444800000,
      high: 0.01392092,
      low: 0.01299499,
      open: 0.01299499,
      close: 0.01357587,
      volume: 159.00918413),
  OHLCV(
    date: 1546459200000,
    high: 0.0138,
    low: 0.0131613,
    open: 0.01357594,
    close: 0.01329,
    volume: 62.60722674,
  )
];
