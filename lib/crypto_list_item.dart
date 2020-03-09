import 'dart:math';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'data/crypto_data.dart';

class CryptoListItem extends StatelessWidget {
  static const imageSize = 48.0;
  static const colors = [
    Colors.blue,
    Colors.red,
    Colors.green,
    Colors.amber,
    Colors.purple
  ];

  final Crypto currency;

  CryptoListItem(this.currency);

  @override
  Widget build(BuildContext context) {
    final placeholder = ClipOval(
      child: Container(
        color: Color.fromRGBO(242, 242, 242, 1),
        width: imageSize,
        height: imageSize,
      ),
    );

    final errorImage = ClipOval(
      child: Container(
        width: imageSize,
        height: imageSize,
        color: colors[Random().nextInt(colors.length - 1)],
        child: Center(
          child: Text(
            currency.name[0].toUpperCase(),
            style: TextStyle(fontSize: 24, color: Colors.white),
          ),
        ),
      ),
    );

    return ListTile(
      leading: CachedNetworkImage(
        width: imageSize,
        height: imageSize,
        imageUrl:
            "https://s2.coinmarketcap.com/static/img/coins/64x64/${currency.id}.png",
        placeholder: (context, url) => placeholder,
        errorWidget: (context, url, error) => errorImage,
      ),
      title: Text(currency.name, style: TextStyle(fontWeight: FontWeight.bold)),
      subtitle: _getSubtitleText(currency.price, currency.percentChange),
      isThreeLine: true,
    );
  }

  Widget _getSubtitleText(double priceUSD, double percentageChange) {
    var priceTextWidget = TextSpan(
        text: "\$${priceUSD.toStringAsFixed(2)}\n",
        style: TextStyle(color: Colors.black));
    var percentageChangeText =
        "1 hour: ${percentageChange.toStringAsFixed(2)}%";
    TextSpan percentageChangeTextWidget;

    if (percentageChange > 0) {
      percentageChangeTextWidget = TextSpan(
          text: percentageChangeText, style: TextStyle(color: Colors.green));
    } else {
      percentageChangeTextWidget = TextSpan(
          text: percentageChangeText, style: TextStyle(color: Colors.red));
    }

    return RichText(
        text:
            TextSpan(children: [priceTextWidget, percentageChangeTextWidget]));
  }
}
