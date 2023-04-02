import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:tuplive/core/constants/routes_enum.dart';
import 'package:tuplive/core/dependencies/dependencies.dart'
    show serviceLocator;
import 'package:tuplive/core/presentation/pages/main_page.dart';
import 'package:tuplive/core/theme/cubits/main_navbar/main_navbar_cubit.dart';
import 'package:tuplive/features/LiveStream/presentation/pages/live_stream_page.dart';
import 'package:tuplive/features/LiveStream/presentation/pages/stream_list_page.dart';

void init() {
  serviceLocator.registerLazySingleton<RouteBase>(
    instanceName: 'home-routes',
    () => ShellRoute(
      pageBuilder: (context, state, child) => NoTransitionPage(child: child),
      routes: [
        GoRoute(
            path: Routes.home.path,
            name: Routes.home.name,
            pageBuilder: (context, state) => const NoTransitionPage(
                  child: MainScaffold(
                    body: Center(
                      child: StreamListPage(),
                    ),
                  ),
                ),
            routes: [
              GoRoute(
                path: Routes.liveStream.dynamicSubpath,
                name: Routes.liveStream.subname(Routes.home.name),
                pageBuilder: (context, state) => NoTransitionPage(
                  child: MainScaffold(
                    appBar: AppBar(),
                    body: const LiveStreamPage(),
                  ),
                ),
              ),
            ]),
      ],
    ),
  );

  serviceLocator.registerLazySingleton<MainNavbarCubit>(
    () => MainNavbarCubit(),
  );
}
