import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'crypto_data.dart';

class ProdCryptoRepository implements CryptoRepository {
  static const cryptoUrl = "https://pro-api.coinmarketcap.com/v1/cryptocurrency/listings/latest?limit=50";

  @override
  Future<List<Crypto>> fetchCurrencies() async {
    final headers = {
      'X-CMC_PRO_API_KEY': DotEnv().env['COIN_MARKET_API_KEY']
    };
    final response = await http.get(cryptoUrl, headers: headers);
    final responseBody = jsonDecode(response.body);
    final statusCode = response.statusCode;
    if (statusCode != 200 || responseBody == null) {
      throw FetchDataException(
          'An error ocurred : [Status Code : $statusCode]');
    }

    return (responseBody['data'] as List<dynamic>)
      .map((c) => Crypto.fromJSON(c)).toList();
  }
}
