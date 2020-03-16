import 'dart:math';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart' show DateFormat;
import 'data/ohlcv_data.dart';

class CandlestickChart extends StatelessWidget {
  static const EdgeInsets padding = EdgeInsets.fromLTRB(20, 40, 0, 20);
  static int ticksCountMax = 6;

  final double width;
  final double height;
  final List<OHLCV> data;
  final int ticksCount;
  final DateFormat xAxisFormat;

  CandlestickChart(
      {@required this.width,
      @required this.height,
      @required this.data,
      @required this.xAxisFormat,
      int ticksCount})
      : ticksCount = (ticksCount ?? ticksCountMax) < ticksCountMax
            ? ticksCount + 1
            : ticksCountMax + 1 {
    data.sort((a, b) =>
        a.date.millisecondsSinceEpoch - b.date.millisecondsSinceEpoch);
  }

  @override
  Widget build(BuildContext context) {
    var xLabels = _getXLabels();
    var candles = _getCandles();

    return CustomPaint(
      isComplex: true,
      size: Size(width, height),
      painter: CandlestickChartPainter(candles: candles, xLabels: xLabels),
    );
  }

  List<ChartLabel> _getXLabels() {
    var xLabels = <ChartLabel>[];
    var min = data[0].date.millisecondsSinceEpoch;
    var max = data[data.length - 1].date.millisecondsSinceEpoch;
    var takeEvery = (data.length / ticksCount).ceilToDouble();
    for (var i = 0; i <= data.length; i++) {
      if (i % takeEvery == 0) {
        var date = DateTime.fromMicrosecondsSinceEpoch(
            lerpDouble(min, max, i / ticksCount).round(),
            isUtc: true);
        xLabels.add(ChartLabel(
            position: _lerpX(i / data.length), text: xAxisFormat.format(date)));
      }
    }
    return xLabels;
  }

  List<ChartCandle> _getCandles() {
    var candles = <ChartCandle>[];
    var candleWidth = width / data.length;
    var maxPrice = data.reduce((a, b) => a.high > b.high ? a : b).high;
    var minPrice = data.reduce((a, b) => a.low < b.low ? a : b).low;
    var priceDiff = maxPrice - minPrice;
    for (var i = 0; i < data.length; i++) {
      var left = _lerpX(i / data.length) - candleWidth / 2;
      var candleHeight =
          (data[i].open - data[i].close).abs() / priceDiff * height;
      var top =
          _lerpY(1 - (max(data[i].open, data[i].close) - minPrice) / priceDiff);
      var high = _lerpY(1 - (data[i].high - minPrice) / priceDiff);
      var low = _lerpY(1 - (data[i].low - minPrice) / priceDiff);
      var candle = ChartCandle(
          left: left,
          top: top,
          width: candleWidth,
          height: candleHeight.ceilToDouble(),
          low: low,
          high: high,
          isWhite: data[i].open > data[i].close);
      candles.add(candle);
    }
    return candles;
  }

  double _lerpX(double x) {
    return lerpDouble(padding.left ?? 0, width - padding.right ?? 0, x);
  }

  double _lerpY(double y) {
    return lerpDouble(padding.top ?? 0, height - padding.bottom ?? 0, y);
  }
}

class CandlestickChartPainter extends CustomPainter {
  static const dashWidth = 5.0;
  static const candlePadding = 0.4;
  static const labelOffsetTop = 7.0;
  static const labelOffsetLeft = 5.0;
  static const labelMaxLength = 30.0;

  final List<ChartLabel> xLabels;
  final List<ChartCandle> candles;

  CandlestickChartPainter({@required this.candles, @required this.xLabels});

  @override
  void paint(Canvas canvas, Size size) {
    var borderPaint = Paint()..color = Colors.grey[600];
    var gridVerticalPaint = Paint()..color = Colors.grey[400];
    var whiteCandlePaint = Paint()..color = Colors.green;
    var blackCandlePaint = Paint()..color = Colors.red;
    var labelStyle = TextStyle(fontSize: 12, color: Colors.grey[600]);

    // top border
    canvas.drawLine(
        Offset(0, size.height), Offset(size.width, size.height), borderPaint);
    // bottom border
    canvas.drawLine(Offset(0, 0), Offset(size.width, 0), borderPaint);

    // X axis labels
    for (var label in xLabels) {
      var textPainter = TextPainter(
          text: TextSpan(text: label.text, style: labelStyle),
          textDirection: TextDirection.ltr)
        ..layout(maxWidth: labelMaxLength);

      textPainter.paint(
          canvas, Offset(label.position + labelOffsetLeft, labelOffsetTop));

      for (var i = 0; i < size.height / dashWidth; i++) {
        if (i % 2 == 0) {
          canvas.drawLine(Offset(label.position, dashWidth * i),
              Offset(label.position, dashWidth * (i + 1)), gridVerticalPaint);
        }
      }
    }

    // candles
    for (var candle in candles) {
      var middleX = candle.left + candle.width / 2;
      var candlePaint = candle.isWhite ? whiteCandlePaint : blackCandlePaint;
      candlePaint.strokeWidth = 1;
      canvas.drawRect(
          Rect.fromLTWH(candle.left + candle.width * candlePadding / 2,
              candle.top, candle.width * (1 - candlePadding), candle.height),
          candlePaint);
      canvas.drawLine(Offset(middleX, candle.low), Offset(middleX, candle.high),
          candlePaint);
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}

class ChartCandle {
  final double left;
  final double top;
  final double width;
  final double height;
  final double low;
  final double high;
  final bool isWhite;

  ChartCandle(
      {@required this.left,
      @required this.top,
      @required this.width,
      @required this.height,
      @required this.low,
      @required this.high,
      @required this.isWhite});
}

class ChartLabel {
  final double position;
  final String text;

  ChartLabel({@required this.position, @required this.text});
}
