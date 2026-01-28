import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:get_it/get_it.dart';
import '../../features/products/data/datasources/product_remote_datasource.dart';
import '../../features/products/data/repositories/product_repository_impl.dart';
import '../../features/products/domain/repositories/product_repository.dart';
import '../../features/products/domain/usecases/get_all_products.dart';
import '../../features/products/presentation/bloc/products_bloc.dart';
import '../network/dio_client.dart';
import '../network/network_info.dart';
import '../theme/theme_cubit.dart';

/// Service Locator instance
/// GetIt is a simple service locator for Dart and Flutter
final sl = GetIt.instance;

/// Initialize all dependencies
/// This should be called once when the app starts
Future<void> initializeDependencies() async {
  //! Features - Products

  // BLoC
  // Registered as factory - new instance every time
  sl.registerFactory(
    () => ProductsBloc(
      getAllProducts: sl(),
    ),
  );

  // Use Cases
  sl.registerLazySingleton(() => GetAllProducts(sl()));

  // Repository
  sl.registerLazySingleton<ProductRepository>(
    () => ProductRepositoryImpl(
      remoteDataSource: sl(),
      networkInfo: sl(),
    ),
  );

  // Data Sources
  sl.registerLazySingleton<ProductRemoteDataSource>(
    () => ProductRemoteDataSourceImpl(
      dioClient: sl(),
    ),
  );

  //! Core

  // Theme Cubit - singleton so theme persists
  sl.registerLazySingleton(() => ThemeCubit());

  // Network Info
  sl.registerLazySingleton<NetworkInfo>(
    () => NetworkInfoImpl(sl()),
  );

  // Dio Client - singleton for the entire app
  sl.registerLazySingleton(() => DioClient());

  //! External Dependencies

  // Connectivity
  sl.registerLazySingleton(() => Connectivity());
}
