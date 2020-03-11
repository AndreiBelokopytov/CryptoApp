import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
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
    final state = widget.currenciesState;
    return CustomScrollView(
      controller: _scrollController,
      slivers: <Widget>[
        _getFilter(),
        _getList(),
        if (state is CurrenciesLoaded && state.loading)
          SliverList(
            delegate: SliverChildListDelegate(<Widget>[BottomLoader()]),
          )
      ],
    );
  }

  Widget _getFilter() {
    const spacer = SizedBox(width: 16);

    return SliverAppBar(
      floating: false,
      pinned: false,
      snap: false,
      backgroundColor: Colors.white,
      elevation: 0,
      titleSpacing: 0,
      title: Container(
          height: _chipsHeight,
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
          )),
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
      return SliverFixedExtentList(
        itemExtent: 96,
        delegate: SliverChildBuilderDelegate(
            (context, index) => _getRowWithDivider(index),
            childCount: state.currencies.length),
      );
    } else {
      return SliverFillRemaining(
        hasScrollBody: false,
        child: const Center(
          child: CircularProgressIndicator(),
        ),
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
      const Divider(height: 4),
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
