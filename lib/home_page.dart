import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'bloc/currencies_bloc.dart';
import 'currencies_list.dart';
import 'providers/bloc_provider.dart';

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final bloc = BlocProvider.of<CurrenciesBloc>(context);

    return StreamBuilder<CurrenciesState>(
        stream: bloc.state,
        builder: (context, snapshot) {
          return Scaffold(
              appBar: AppBar(
                title: Text("Crypto App"),
                elevation:
                    defaultTargetPlatform == TargetPlatform.iOS ? 0.0 : 5.0,
              ),
              body: CurrenciesList(
                  currenciesState: snapshot.data,
                  onLoadNextPage: (page) => bloc.page.add(page)));
        });
  }
}
