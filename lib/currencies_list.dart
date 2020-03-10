import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'bloc/currencies_bloc.dart';
import 'bottom_loader.dart';
import 'crypto_list_item.dart';
import 'data/crypto_data.dart';

typedef OnLoadNextPage = void Function(int page);
typedef OnToggleFavorite = void Function(int id);
typedef OnFilter = void Function(CryptoType type);

class CurrenciesList extends StatefulWidget {
  final Set<int> favorites;
  final CurrenciesState currenciesState;
  final OnLoadNextPage onLoadNextPage;
  final OnToggleFavorite onToggleFavorite;
  final OnFilter onFilter;

  CurrenciesList(
      {@required this.currenciesState,
      @required this.favorites,
      @required this.onLoadNextPage,
      @required this.onToggleFavorite,
      @required this.onFilter});

  @override
  State createState() => CurrenciesListState();
}

class CurrenciesListState extends State<CurrenciesList> {
  static const _scrollThreshold = 200;
  static const _chipsHeight = 52.0;

  final _scrollController = ScrollController();

  CurrenciesListState();

  @override
  void initState() {
    super.initState();
    widget.onLoadNextPage(1);
    _scrollController.addListener(_onScroll);
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        Positioned(
          left: 0,
          right: 0,
          top: 0,
          child: _getFilter(),
        ),
        Positioned.fill(top: _chipsHeight, child: _getList())
      ],
    );
  }

  Widget _getFilter() {
    const spacer = SizedBox(width: 16);
    return Container(
      height: _chipsHeight,
      color: Colors.grey[50],
      child: ListView(
        padding: EdgeInsets.symmetric(horizontal: 16),
        scrollDirection: Axis.horizontal,
        children: <Widget>[
          _getChip(CryptoType.all),
          spacer,
          _getChip(CryptoType.coins),
          spacer,
          _getChip(CryptoType.tokens),
        ],
      ),
    );
  }

  Widget _getChip(CryptoType type) {
    final state = widget.currenciesState;
    String text;
    switch (type) {
      case CryptoType.all:
        text = 'all';
        break;
      case CryptoType.coins:
        text = 'coins';
        break;
      case CryptoType.tokens:
        text = 'tokens';
        break;
    }

    return ChoiceChip(
      label: Text(text),
      selected: type == state.type,
      onSelected: (selected) => _filter(selected, type),
    );
  }

  Widget _getList() {
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
      CryptoListItem(
        currency: currency,
        favorite: favorites.contains(currency.id),
        onToggleFavorite: widget.onToggleFavorite,
      ),
      const Divider(height: 5.0),
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: children,
    );
  }

  _filter(bool selected, CryptoType type) {
    widget.onFilter(type);
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
