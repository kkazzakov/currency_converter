part of 'currency_cubit.dart';

abstract class CurrencyState extends Equatable {
  const CurrencyState();

  @override
  List<Object?> get props => [];
}

class CurrencyInitial extends CurrencyState {}

class CurrencyLoading extends CurrencyState {}

class CurrencyLoaded extends CurrencyState {
  final List<CurrencyRate> currencyRates;

  CurrencyLoaded(this.currencyRates);

  @override
  List<Object?> get props => [currencyRates];
}
// Состояние успешной загрузки, содержит список курсов валют

class CurrencyError extends CurrencyState {
  final String message;

  CurrencyError(this.message);

  @override
  List<Object?> get props => [message];
}