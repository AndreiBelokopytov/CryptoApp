import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'data/crypto_data.dart';
import 'data/ohlcv_data.dart';

class CryptoPageSummary extends StatelessWidget {
  final Crypto currency;
  final double maxPrice;
  final double minPrice;

  IconData get trendingIcon =>
      currency.percentChange >= 0 ? Icons.arrow_upward : Icons.arrow_downward;
  Color get trendingColor =>
      currency.percentChange >= 0 ? Colors.green : Colors.red;
  double get change => currency.percentChange.abs();

  CryptoPageSummary({@required this.currency, @required List<OHLCV> ohlcvData})
      : minPrice = ohlcvData.reduce((a, b) => a.low > b.low ? a : b).low,
        maxPrice = ohlcvData.reduce((a, b) => a.high > b.high ? a : b).high;

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: EdgeInsets.all(16),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  "\$${currency.price.toStringAsFixed(2)}",
                  style: TextStyle(fontSize: 24),
                ),
                Padding(
                  padding: EdgeInsets.only(top: 8),
                  child: Row(children: <Widget>[
                    Padding(
                      padding: EdgeInsets.only(right: 4),
                      child: Icon(trendingIcon, color: trendingColor, size: 16),
                    ),
                    Text("${change.toStringAsFixed(2)}%",
                        style: TextStyle(fontSize: 16, color: trendingColor))
                  ]),
                )
              ],
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: <Widget>[
                Text("min: \$${minPrice.toStringAsFixed(8)}",
                    style: TextStyle(fontSize: 12)),
                Padding(
                  padding: EdgeInsets.only(top: 8),
                  child: Text("max: \$${maxPrice.toStringAsFixed(8)}",
                    style: TextStyle(fontSize: 12)),
                ),
              ],
            )
          ],
        ));
  }
}
