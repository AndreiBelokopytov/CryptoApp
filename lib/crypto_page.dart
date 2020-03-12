import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'data/crypto_data.dart';

class CryptoPage extends StatelessWidget {
  final Crypto currency;
  IconData get trendingIcon =>
      currency.percentChange >= 0 ? Icons.arrow_upward : Icons.arrow_downward;
  Color get trendingColor =>
      currency.percentChange >= 0 ? Colors.green : Colors.red;
  double get change => currency.percentChange.abs();

  CryptoPage(this.currency);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text("${currency.name} (${currency.symbol})"),
          ],
        ),
        actions: <Widget>[
          IconButton(
            icon: const Icon(
              Icons.star_border,
              color: Colors.white,
            ),
            tooltip: "Add to favorites",
          )
        ],
        elevation: defaultTargetPlatform == TargetPlatform.iOS ? 0.0 : 5.0,
      ),
      body: Container(
        padding: EdgeInsets.all(16),
        child: Column(
          children: <Widget>[
            Row(
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
                          child: Icon(trendingIcon,
                              color: trendingColor, size: 16),
                        ),
                        Text("${change.toStringAsFixed(2)}%",
                            style:
                                TextStyle(fontSize: 16, color: trendingColor))
                      ]),
                    )
                  ],
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
