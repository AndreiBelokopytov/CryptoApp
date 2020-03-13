import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:rxdart/rxdart.dart';
import 'bloc/currencies_bloc.dart';
import 'bloc/favorites_bloc.dart';
import 'currencies_list.dart';
import 'service_locator.dart';

class HomePage extends StatefulWidget {

  @override
  State createState() => HomePageState();
}

class HomePageState extends State<HomePage> {
  final CurrenciesBloc currenciesBloc = sl<CurrenciesBloc>();
  final FavoritesBloc favoritesBloc = sl<FavoritesBloc>();

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<HomePageStreamSnapshot>(
        stream: CombineLatestStream.combine2(
            currenciesBloc.state,
            favoritesBloc.favorites,
            (currenciesState, favorites) => HomePageStreamSnapshot(
                currenciesState: currenciesState, favorites: favorites)),
        builder: (context, snapshot) {
          return Scaffold(
              backgroundColor: Colors.white,
              appBar: AppBar(
                title: Text("Crypto App"),
                elevation:
                    defaultTargetPlatform == TargetPlatform.iOS ? 0.0 : 5.0,
              ),
              body: snapshot.hasData
                  ? CurrenciesList(
                      currenciesState: snapshot.data.currenciesState,
                      favorites: snapshot.data.favorites,
                      onLoadNextPage: (page) => currenciesBloc.page.add(page),
                      onToggleFavorite: (id) =>
                          favoritesBloc.favoriteItem.add(id),
                      onFilter: (type) => currenciesBloc.type.add(type),
                    )
                  : null);
        });
  }

  @override
  void initState() {
    super.initState();
    currenciesBloc.init();
    favoritesBloc.init();
  }

  @override
  void dispose() {
    currenciesBloc.dispose();
    favoritesBloc.dispose();
    super.dispose();
  }
}

class HomePageStreamSnapshot {
  final CurrenciesState currenciesState;
  final Set<int> favorites;

  HomePageStreamSnapshot(
      {@required this.currenciesState, @required this.favorites});
}
