import 'package:isar/isar.dart';

import '../../domain/entities/currency_rate.dart';

part 'currency_rate_model.g.dart';


@Collection()
class CurrencyRateModel {
  Id id = Isar.autoIncrement;     // Поле для автоинкремента в базе данных
  late String currency;           // Код валюты, например, "USD"
  late double rate;               // Курс валюты

  CurrencyRateModel({
    required this.currency,
    required this.rate,
  });

  // Преобразование из модели в сущность (Entity)
  CurrencyRate toEntity() {
    return CurrencyRate(
      currency: currency,
      rate: rate,
    );
  }

  // Фабричный метод для создания модели из JSON ответа API
  factory CurrencyRateModel.fromJson(Map<String, dynamic> json) {
    return CurrencyRateModel(
      currency: json['currency'],
      rate: json['rate'],
    );
  }

  // Преобразование модели в JSON для хранения в базе данных (если необходимо)
  Map<String, dynamic> toJson() {
    return {
      'currency': currency,
      'rate': rate,
    };
  }
}
