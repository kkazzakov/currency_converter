import '../entities/currency_rate.dart';

abstract class CurrencyRepository {
  /// Получение списка курсов валют.
  /// Возвращает Future с List<CurrencyRate>.
  Future<List<CurrencyRate>> getCurrencyRates();
}
