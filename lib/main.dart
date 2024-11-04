import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:currency_converter/data/datasources/currency_local_data_source.dart';
import 'package:currency_converter/data/datasources/currency_remote_data_source.dart';
import 'package:currency_converter/data/models/currency_rate_model.dart';
import 'package:currency_converter/data/repositories/currency_repository_imp.dart';
import 'package:currency_converter/presentation/cubit/currency_cubit.dart';
import 'package:currency_converter/presentation/screens/currency_converter_screen.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:isar/isar.dart';
import 'package:path_provider/path_provider.dart';

import 'domain/usecases/get_currency_rates.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load();
  final directory = await getApplicationDocumentsDirectory();
  runApp(MyApp(
    isar: Isar.openSync([CurrencyRateModelSchema], directory: directory.path),
  ));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key, required this.isar});

  final Isar isar;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Currency Converter',
      home: RepositoryProvider<CurrencyRepositoryImpl>(
        create: (_) {
          return CurrencyRepositoryImpl(
            remoteDataSource: CurrencyRemoteDataSource(Dio()),
            localDataSource: CurrencyLocalDataSource(isar),
            connectivity: Connectivity(),
          );
        },
        child: BlocProvider(
          create: (context) => CurrencyCubit(
            GetCurrencyRates(
              RepositoryProvider.of<CurrencyRepositoryImpl>(context),
            ),
          )..loadCurrencyRates(),
          child: CurrencyConverterScreen(),
        ),
      ),
    );
  }
}
