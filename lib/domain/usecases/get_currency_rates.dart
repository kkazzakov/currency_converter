import '../entities/currency_rate.dart';
import '../repositories/currency_repository.dart';

class GetCurrencyRates {
  final CurrencyRepository repository;

  GetCurrencyRates(this.repository);

  Future<List<CurrencyRate>> execute() async {
    return await repository.getCurrencyRates();
  }
}
