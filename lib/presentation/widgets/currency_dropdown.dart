import 'package:flutter/material.dart';

class CurrencyDropdown extends StatelessWidget {
  final List<String> currencies;
  final String? value;
  final ValueChanged<String?> onChanged;

  const CurrencyDropdown({
    super.key,
    required this.currencies,
    this.value,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return DropdownButton<String>(
      value: value,
      onChanged: onChanged,
      items: currencies.map((currency) {
        return DropdownMenuItem<String>(
          value: currency,
          child: Text(currency),
        );
      }).toList(),
    );
  }
}
