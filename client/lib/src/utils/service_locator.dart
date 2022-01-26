import 'package:client/src/services/api/api.dart';
import 'package:client/src/services/auth/auth.dart';
import 'package:client/src/services/db/local_storage/local_storage.dart';
import 'package:get_it/get_it.dart';

GetIt locator = GetIt.instance;
setupLocator(){
  locator
    // ..registerLazySingleton<LocalStorage>(() => LocalStorage())
    ..registerLazySingleton<ApiService>(() => ApiService())
    ..registerLazySingleton<AuthService>(() => AuthService());
}