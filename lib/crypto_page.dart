import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'data/crypto_data.dart';
import 'service_locator.dart';

class CryptoPage extends StatefulWidget {
  final Crypto currency;

  CryptoPage(this.currency);

  @override
  State createState() => CryptoPageState();
}

class CryptoPageState extends State<CryptoPage> {
  final FavoritesBloc favoritesBloc = sl<FavoritesBloc>();

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: favoritesBloc.favorites,
      builder: (context, snapshot) {
        final isFavorite = snapshot.data.contains(widget.currency.id);
        return Scaffold(
          appBar: AppBar(
            title: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text("${widget.currency.name} (${widget.currency.symbol})"),
              ],
            ),
            actions: <Widget>[
              IconButton(
                icon: Icon(
                  isFavorite ? Icons.star : Icons.star_border,
                  color: Colors.white,
                ),
                tooltip: "Add to favorites",
                onPressed: () =>
                    favoritesBloc.favoriteItem.add(widget.currency.id),
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
                    CryptoPageSummary(widget.currency),
                  ],
                )
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  void initState() {
    favoritesBloc.init();
  }

  @override
  void dispose() {
    favoritesBloc.dispose();
  }
}
