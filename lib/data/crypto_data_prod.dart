import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'crypto_data.dart';

class ProdCryptoRepository implements CryptoRepository {
  static const cryptoUrl =
      "https://pro-api.coinmarketcap.com/v1/cryptocurrency/listings/latest";
  static const pageSize = 20;

  bool _allCurrenciesLoaded = false;

  @override
  bool get allCurrenciesLoaded => _allCurrenciesLoaded;

  @override
  Future<List<Crypto>> fetchCurrencies(
      {int page = 1, CryptoType type = CryptoType.all}) async {
    final headers = {'X-CMC_PRO_API_KEY': DotEnv().env['COIN_MARKET_API_KEY']};
    String cryptoType;
    switch (type) {
      case CryptoType.coins:
        cryptoType = "coins";
        break;
      case CryptoType.tokens:
        cryptoType = "tokens";
        break;
      case CryptoType.all:
        {
          cryptoType = "all";
        }
    }
    final url = Uri.https(
        "pro-api.coinmarketcap.com", "/v1/cryptocurrency/listings/latest", {
      "limit": pageSize.toString(),
      "start": (pageSize * (page - 1) + 1).toString(),
      "cryptocurrency_type": cryptoType
    });
    final response = await http.get(url.toString(), headers: headers);
    final responseBody = jsonDecode(response.body);
    final statusCode = response.statusCode;

    if (statusCode != 200 || responseBody == null) {
      throw FetchDataException(
          'An error ocurred : [Status Code : $statusCode]');
    }

    final body = (responseBody['data'] as List<dynamic>);

    if (body.length < pageSize) {
      _allCurrenciesLoaded = true;
    }

    return body.map((c) => Crypto.fromJSON(c)).toList();
  }
}
