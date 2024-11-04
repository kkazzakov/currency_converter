import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../cubit/currency_cubit.dart';
import '../widgets/currency_dropdown.dart';
import '../widgets/loading_indicator.dart';

class CurrencyConverterScreen extends StatefulWidget {
  @override
  _CurrencyConverterScreenState createState() => _CurrencyConverterScreenState();
}

class _CurrencyConverterScreenState extends State<CurrencyConverterScreen> {
  String _fromCurrency = 'USD'; // Исходная валюта
  String _toCurrency = 'EUR';   // Целевая валюта

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Currency Converter"),
      ),
      body: BlocBuilder<CurrencyCubit, CurrencyState>(
        builder: (context, state) {
          final cubit = context.read<CurrencyCubit>();
          if (state is CurrencyLoading) {
            return const LoadingIndicator();
          } else if (state is CurrencyLoaded) {
            return Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'You send',
                    style: TextStyle(fontSize: 18),
                  ),
                  SizedBox(height: 8),
                  Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: cubit.fromController,
                          keyboardType: TextInputType.number,
                          onChanged: (value) {
                            cubit.convertCurrency(_fromCurrency, _toCurrency);
                          },
                        ),
                      ),
                      SizedBox(width: 16),
                      CurrencyDropdown(
                        currencies: state.currencyRates.map((e) => e.currency).toList(),
                        value: _fromCurrency,
                        onChanged: (value) {
                          setState(() => _fromCurrency = value!);
                          cubit.convertCurrency(_fromCurrency, _toCurrency);
                        },
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  const Text(
                    'They get',
                    style: TextStyle(fontSize: 18),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: cubit.toController,
                          readOnly: true,
                        ),
                      ),
                      const SizedBox(width: 16),
                      CurrencyDropdown(
                        currencies: state.currencyRates.map((e) => e.currency).toList(),
                        value: _toCurrency,
                        onChanged: (value) {
                          setState(() => _toCurrency = value!);
                          cubit.convertCurrency(_fromCurrency, _toCurrency);
                        },
                      ),
                    ],
                  ),
                ],
              ),
            );
          } else if (state is CurrencyError) {
            return Center(child: Text(state.message));
          }
          return Center(child: Text("Enter an amount to convert."));
        },
      ),
    );
  }
}
