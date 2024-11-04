import 'package:connectivity_plus/connectivity_plus.dart';

import '../../domain/entities/currency_rate.dart';
import '../../domain/repositories/currency_repository.dart';
import '../datasources/currency_local_data_source.dart';
import '../datasources/currency_remote_data_source.dart';

class CurrencyRepositoryImpl implements CurrencyRepository {
  final CurrencyRemoteDataSource remoteDataSource;
  final CurrencyLocalDataSource localDataSource;
  final Connectivity connectivity;

  CurrencyRepositoryImpl({
    required this.remoteDataSource,
    required this.localDataSource,
    required this.connectivity,
  });

  @override
  Future<List<CurrencyRate>> getCurrencyRates() async {
    if (!(await connectivity.checkConnectivity()).contains(ConnectivityResult.none)) {
      try {
        final remoteRates = await remoteDataSource.fetchCurrencyRates();
        await localDataSource.cacheRates(remoteRates);
        return remoteRates.map((rateModel) => rateModel.toEntity()).toList();
      } catch (e) {
        // В случае ошибки попробуем вернуть кэшированные данные
        return await _getCachedRates();
      }
    } else {
      // При отсутствии сети возвращаем кэшированные данные
      return await _getCachedRates();
    }
  }

  Future<List<CurrencyRate>> _getCachedRates() async {
    final cachedRates = await localDataSource.getCachedRates();
    return cachedRates.map((rateModel) => rateModel.toEntity()).toList();
  }
}
