import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import '../../domain/entities/currency_rate.dart';
import '../../domain/usecases/get_currency_rates.dart';

part 'currency_state.dart';

class CurrencyCubit extends Cubit<CurrencyState> {
  final GetCurrencyRates getCurrencyRates;

  final TextEditingController fromController = TextEditingController();
  final TextEditingController toController = TextEditingController();

  CurrencyCubit(this.getCurrencyRates) : super(CurrencyInitial());

  Future<void> loadCurrencyRates() async {
    emit(CurrencyLoading());
    try {
      final currencyRates = await getCurrencyRates.execute();
      emit(CurrencyLoaded(currencyRates));
    } catch (error) {
      emit(CurrencyError("Failed to load currency rates"));
    }
  }

  void convertCurrency(String fromCurrency, String toCurrency) {
    if (state is CurrencyLoaded) {
      final fromAmount = double.tryParse(fromController.text) ?? 0.0;
      final rates = (state as CurrencyLoaded).currencyRates;
      final fromRate = rates.firstWhere((rate) => rate.currency == fromCurrency).rate;
      final toRate = rates.firstWhere((rate) => rate.currency == toCurrency).rate;
      final convertedAmount = (fromAmount / fromRate) * toRate;
      toController.text = convertedAmount.toString();
    }
  }

  @override
  Future<void> close() {
    fromController.dispose();
    toController.dispose();
    return super.close();
  }
}
