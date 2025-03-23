import 'package:get_it/get_it.dart';
import 'package:uip_tv/provider/api_provider.dart';
import 'package:uip_tv/provider/local_store_provider.dart';
import 'package:uip_tv/provider/operation_provider.dart';

final GetIt getIt = GetIt.instance;

void setupLocator() {
  getIt.registerLazySingleton<ApiDataProvider>(() => ApiDataProvider());
  getIt.registerLazySingleton<LocalStoreProvider>(() => LocalStoreProvider());
  getIt.registerLazySingleton<AuthOperationProvider>(
      () => AuthOperationProvider());
}
