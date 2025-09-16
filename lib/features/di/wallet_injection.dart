import 'package:get_it/get_it.dart';
import '../data/wallet/datasources/wallet_datasource.dart';
import '../data/wallet/repositories/wallet_repository_impl.dart';
import '../domain/wallet/repositories/wallet_repository.dart';
import '../domain/wallet/usecases/get_wallet_balance_usecase.dart';
import '../domain/wallet/usecases/get_wallet_history_usecase.dart';
import '../presentation/wallet/controller/wallet_provider.dart';
import '../../core/network/network_info.dart';
import '../../core/api/api_provider.dart';

final sl = GetIt.instance;

Future<void> initWalletDependencies() async {
  // Provider
  sl.registerFactory(() => WalletProvider(
        getWalletBalanceUseCase: sl(),
        getWalletHistoryUseCase: sl(),
      ));

  // Use cases
  sl.registerLazySingleton(() => GetWalletBalanceUseCase(sl()));
  sl.registerLazySingleton(() => GetWalletHistoryUseCase(sl()));

  // Repository
  sl.registerLazySingleton<WalletRepository>(() => WalletRepositoryImpl(
        dataSource: sl(),
        networkInfo: sl(),
      ));

  // Data sources
  sl.registerLazySingleton<WalletDataSource>(() => WalletDataSourceImpl(
        sl<ApiProvider>(),
      ));
} 