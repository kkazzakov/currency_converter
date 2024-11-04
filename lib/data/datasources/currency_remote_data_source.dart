import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

import '../models/currency_rate_model.dart';

class CurrencyRemoteDataSource {
  final Dio dio;

  CurrencyRemoteDataSource(this.dio) {
    dio.options.baseUrl = 'https://api.exchangeratesapi.io/v1/';
  }

  Future<List<CurrencyRateModel>> fetchCurrencyRates() async {
    try {
      final apiKey = dotenv.env['API_KEY'];

      final response = await dio.get('latest', queryParameters: {
        'access_key': apiKey,
      });

      if (response.statusCode == 200) {
        final data = response.data['rates'] as Map<String, dynamic>;
        final rates = data.entries
            .map((entry) => CurrencyRateModel(
                  currency: entry.key,
                  rate: (entry.value as num).toDouble(),
                ))
            .toList();
        return rates;
      } else {
        throw Exception('Failed to load currency rates');
      }
    } catch (e) {
      throw Exception('Error fetching currency rates: $e');
    }
  }
}
