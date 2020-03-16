import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart' show DateFormat;
import 'package:rxdart/rxdart.dart';
import 'bloc/favorites_bloc.dart';
import 'bloc/ohlcv_bloc.dart';
import 'candlestick_chart.dart';
import 'crypto_page_summary.dart';
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
  final OHLCVBloc ohlcvBloc = sl<OHLCVBloc>();

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<CryptoPageSnapshot>(
      stream: CombineLatestStream.combine2(
          favoritesBloc.favorites,
          ohlcvBloc.state,
          (favorites, ohlcvState) => CryptoPageSnapshot(favorites, ohlcvState)),
      builder: (context, snapshot) {
        final favorites = snapshot.data?.favorites ?? <int>{};
        final ohlcvState = snapshot.data?.ohlcvState;
        final isFavorite = favorites.contains(widget.currency.id);
        return Scaffold(
          backgroundColor: Colors.white,
          appBar: AppBar(
            title: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text("${widget.currency.name} (${widget.currency.symbol})"),
              ],
            ),
            actions: <Widget>[
              if (snapshot.hasData)
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
          body: snapshot.hasData
              ? Container(
                  child: Column(
                    children: <Widget>[
                      CryptoPageSummary(widget.currency),
                      if (ohlcvState is OHLCVStateLoaded)
                        Padding(
                          padding: EdgeInsets.only(top: 24),
                          child: CandlestickChart(
                            width: MediaQuery.of(context).size.width,
                            height: 320,
                            data: ohlcvState.ohlcvData,
                            xAxisFormat: DateFormat.Hm(),
                            ticksCount: 6,
                          ),
                        )
                    ],
                  ),
                )
              : null,
        );
      },
    );
  }

  @override
  void initState() {
    super.initState();
    favoritesBloc.init();
    ohlcvBloc.init();
  }

  @override
  void dispose() {
    favoritesBloc.dispose();
    ohlcvBloc.dispose();
    super.dispose();
  }
}

class CryptoPageSnapshot {
  final Set<int> favorites;
  final OHLCVState ohlcvState;

  CryptoPageSnapshot(this.favorites, this.ohlcvState);
}
