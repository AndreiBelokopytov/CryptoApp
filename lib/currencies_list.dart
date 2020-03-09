import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttercrypto/bottom_loader.dart';
import 'bloc/currencies_bloc.dart';
import 'crypto_list_item.dart';
import 'data/crypto_data.dart';

typedef OnLoadNextPage = void Function({int page});

class CurrenciesList extends StatefulWidget {
  final CurrenciesState currenciesState;
  final OnLoadNextPage onLoadNextPage;

  CurrenciesList({this.currenciesState, this.onLoadNextPage});

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
            : _getRowWithDivider(state.currencies[index]),
        controller: _scrollController,
      );
    } else {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }
  }

  Widget _getRowWithDivider(Crypto currency) {
    final children = <Widget>[
      Padding(padding: EdgeInsets.all(10.0), child: CryptoListItem(currency)),
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
        onLoadNextPage(page: state.page + 1);
      }
    }
  }
}
