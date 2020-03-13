import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'home_page.dart';
import 'service_locator.dart';

void main() async {
  await DotEnv().load('.env');
  ServiceLocator.setup();
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
        home: HomePage());
  }
}
