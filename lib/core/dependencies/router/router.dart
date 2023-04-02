// ignore_for_file: public_member_api_docs, sort_constructors_first

import 'package:go_router/go_router.dart';
import 'package:tuplive/core/constants/routes_enum.dart';

import '../dependencies.dart' show serviceLocator;
import 'home.dart' as home;

/// Registers a GoRouter Singleton
void init() {
  home.init();
  serviceLocator.registerLazySingleton<GoRouter>(
    () => GoRouter(
      initialLocation: Routes.home.path,
      routes: [
        serviceLocator<RouteBase>(instanceName: 'home-routes'),
      ],
    ),
  );
}
