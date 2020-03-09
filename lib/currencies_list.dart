import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'bloc/currencies_bloc.dart';
import 'bottom_loader.dart';
import 'crypto_list_item.dart';

typedef OnLoadNextPage = void Function(int page);
typedef OnToggleFavorite = void Function(int id);

class CurrenciesList extends StatefulWidget {
  final Set<int> favorites;
  final CurrenciesState currenciesState;
  final OnLoadNextPage onLoadNextPage;
  final OnToggleFavorite onToggleFavorite;

  CurrenciesList(
      {@required this.currenciesState,
      @required this.favorites,
      @required this.onLoadNextPage,
      @required this.onToggleFavorite});

  @override
  State createState() => CurrenciesListState();
}

class CurrenciesListState extends State<CurrenciesList> {
  final _scrollController = ScrollController();
  final _scrollThreshold = 200;

  CurrenciesListState();

  @override
  void initState() {
    super.initState();
    widget.onLoadNextPage(1);
    _scrollController.addListener(_onScroll);
  }

  @override
  Widget build(BuildContext context) {
    final state = widget.currenciesState;

    if (state is CurrenciesLoaded) {
      return ListView.builder(
        itemCount: state.allCurrenciesLoaded
            ? state.currencies.length
            : state.currencies.length + 1,
        itemBuilder: (context, index) => index >= state.currencies.length
            ? BottomLoader()
            : _getRowWithDivider(index),
        controller: _scrollController,
      );
    } else {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }
  }

  Widget _getRowWithDivider(int index) {
    final currency =
        (widget.currenciesState as CurrenciesLoaded).currencies[index];
    final favorites = widget.favorites;
    final children = <Widget>[
      Padding(
          padding: EdgeInsets.all(10.0),
          child: CryptoListItem(
            currency: currency,
            favorite: favorites.contains(currency.id),
            onToggleFavorite: widget.onToggleFavorite,
          )),
      const Divider(height: 5.0),
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: children,
    );
  }

  void _onScroll() {
    final state = widget.currenciesState;
    final onLoadNextPage = widget.onLoadNextPage;

    if (state is CurrenciesLoaded) {
      final maxScroll = _scrollController.position.maxScrollExtent;
      final currentScroll = _scrollController.position.pixels;
      if (maxScroll - currentScroll <= _scrollThreshold) {
        onLoadNextPage(state.page + 1);
      }
    }
  }
}
