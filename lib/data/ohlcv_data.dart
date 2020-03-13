import 'package:flutter/foundation.dart';

class OHLCV {
  final double open;
  final double high;
  final double low;
  final double close;
  final double volume;
  final DateTime date;

  OHLCV(
      {@required this.open,
      @required this.high,
      @required this.low,
      @required this.volume,
      @required this.close,
      @required int date})
      : date = DateTime.fromMillisecondsSinceEpoch(date, isUtc: true);
}

abstract class OHLCVRepository {
  Future<List<OHLCV>> fetchOHLCV();
}
