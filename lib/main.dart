import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'bloc/currencies_block.dart';
import 'dependency_injection.dart';
import 'home_page.dart';
import 'providers/bloc_provider.dart';

void main() async {
  await DotEnv().load('.env');
  Injector.configure(Flavor.prod);
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
          primarySwatch: Colors.pink,
          primaryColor: defaultTargetPlatform == TargetPlatform.iOS
              ? Colors.grey[100]
              : null),
      home: BlocProvider(bloc: CurrenciesBlock(), child: HomePage())
    );
  }
}
