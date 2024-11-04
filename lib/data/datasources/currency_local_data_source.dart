import 'package:isar/isar.dart';

import '../models/currency_rate_model.dart';

class CurrencyLocalDataSource {
  final Isar isar;

  CurrencyLocalDataSource(this.isar);

  // Сохранение курсов валют в локальное хранилище
  Future<void> cacheRates(List<CurrencyRateModel> rates) async {
    await isar.writeTxn(() async {
      await isar.currencyRateModels.putAll(rates);
    });
  }

  // Получение закэшированных курсов валют из локального хранилища
  Future<List<CurrencyRateModel>> getCachedRates() async {
    return await isar!.currencyRateModels.where().findAll();
  }
}
