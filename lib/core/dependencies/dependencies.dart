import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get_it/get_it.dart';
import 'package:tuplive/core/configs/environment_configs.dart';
import 'package:tuplive/core/dependencies/states/states.dart';

import 'router/router.dart' as router show init;

final serviceLocator = GetIt.instance;

/// ## Registers app dependencies
///
/// - Singletons
/// ```
/// GetIt.instance<FlutterSecureStorage>() // FlutterSecureStorage()
/// GetIt.instance<EnvironmentConfigs>() // EnvironmentConfigs()
/// GetIt.instance<Dio>() // Dio()
/// You can also use `serviceLocator` instead of `GetIt.instance`
Future<void> initializeDependencies() async {
  registerSecureStorage();
  registerEnvConfigs();
  registerDioClient();

  initializeStates();

  router.init();
}

/// Registers a Flutter Secure Storage singleton
void registerSecureStorage() {
  serviceLocator.registerLazySingleton<FlutterSecureStorage>(
    () => const FlutterSecureStorage(
      aOptions: AndroidOptions(
        encryptedSharedPreferences: true,
      ),
      iOptions: IOSOptions.defaultOptions,
      webOptions: WebOptions.defaultOptions,
    ),
  );
}

/// Registers an EnvironmentConfig singleton
void registerEnvConfigs() {
  serviceLocator.registerLazySingleton<EnvironmentConfig>(
    () => EnvironmentConfig(),
  );
}

/// Registers a Dio singleton
void registerDioClient() {
  serviceLocator.registerLazySingleton<Dio>(
    () => Dio(
        // BaseOptions(
        //   baseUrl: serviceLocator<EnvironmentConfig>().apihost,
        // ),
        ),
  );
}
