import 'dart:math';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'bloc/currencies_block.dart';
import 'data/crypto_data.dart';
import 'providers/bloc_provider.dart';

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<CurrenciesState>(
        initialData: CurrenciesLoading(),
        stream: BlocProvider.of<CurrenciesBlock>(context).currencies,
        builder: (context, snapshot) {
          return Scaffold(
              appBar: AppBar(
                title: Text("Crypto App"),
                elevation:
                    defaultTargetPlatform == TargetPlatform.iOS ? 0.0 : 5.0,
              ),
              body: _getBody(snapshot));
        });
  }

  Widget _getBody(AsyncSnapshot<CurrenciesState> snapshot) {
    if (snapshot.data is CurrenciesLoading) {
      return Center(
        child: CircularProgressIndicator(),
      );
    }
    if (snapshot.data is CurrenciesLoaded) {
      final currencies = (snapshot.data as CurrenciesLoaded).currencies;
      return ListView.builder(
        itemCount: currencies.length,
        itemBuilder: (context, index) => _getRowWithDivider(currencies[index]),
      );
    }
  }

  Widget _getRowWithDivider(Crypto currency) {
    var children = <Widget>[
      Padding(padding: EdgeInsets.all(10.0), child: _getListItemUi(currency)),
      Divider(height: 5.0),
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: children,
    );
  }

  ListTile _getListItemUi(Crypto currency) {
    const imageSize = 48.0;

    final colors = [
      Colors.blue,
      Colors.red,
      Colors.green,
      Colors.amber,
      Colors.purple
    ];

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
            style: TextStyle(
              fontSize: 24,
              color: Colors.white
            ),
          ),
        ),
      ),
    );

    return ListTile(
      leading: CachedNetworkImage(
        width: imageSize,
        height: imageSize,
        imageUrl:
            "https://cdn.jsdelivr.net/gh/atomiclabs/cryptocurrency-icons@9867bdb19da14e63ffbe63805298fa60bf255cdd/32@2x/color/${currency.symbol?.toLowerCase()}@2x.png",
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
