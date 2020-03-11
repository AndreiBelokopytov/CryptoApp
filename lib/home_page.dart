import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:rxdart/rxdart.dart';
import 'bloc/currencies_bloc.dart';
import 'bloc/favorites_bloc.dart';
import 'currencies_list.dart';
import 'providers/bloc_provider.dart';

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final currenciesBloc = BlocProvider.of<CurrenciesBloc>(context);
    final favoritesBloc = BlocProvider.of<FavoritesBloc>(context);

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
}

class HomePageStreamSnapshot {
  final CurrenciesState currenciesState;
  final Set<int> favorites;

  HomePageStreamSnapshot(
      {@required this.currenciesState, @required this.favorites});
}
