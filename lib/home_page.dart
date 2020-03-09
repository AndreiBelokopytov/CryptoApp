import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'bloc/currencies_block.dart';
import 'crypto_list_item.dart';
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
    final children = <Widget>[
      Padding(padding: EdgeInsets.all(10.0), child: CryptoListItem(currency)),
      Divider(height: 5.0),
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: children,
    );
  }
}
