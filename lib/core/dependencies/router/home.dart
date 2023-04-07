import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:tuplive/core/constants/grid.dart';
import 'package:tuplive/core/constants/routes_enum.dart';
import 'package:tuplive/core/dependencies/dependencies.dart'
    show serviceLocator;
import 'package:tuplive/core/presentation/pages/main_page.dart';
import 'package:tuplive/core/presentation/widgets/spacers.dart';
import 'package:tuplive/core/theme/cubits/main_navbar/main_navbar_cubit.dart';
import 'package:tuplive/features/LiveStream/presentation/pages/live_stream_page.dart';
import 'package:tuplive/features/LiveStream/presentation/pages/stream_list_page.dart';
import 'package:url_launcher/url_launcher.dart';

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
                  appBar: AppBar(
                    actions: [
                      if (!state.params.containsValue('stream'))
                        TextButton(
                          onPressed: () {
                            final url =
                                Uri.parse('https://m.me/markcabalona.8');

                            canLaunchUrl(url).then((value) {
                              if (value) {
                                launchUrl(
                                  url,
                                  mode: LaunchMode.externalApplication,
                                );
                              } else {
                                // TODO: Show Error message
                                launchUrl(
                                  Uri.parse('https://m.me'),
                                  mode: LaunchMode.externalApplication,
                                );
                              }
                            });
                          },
                          child: Padding(
                            padding: const EdgeInsets.all(AppGrid.small),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: const [
                                Text('Message Streamer'),
                                HorizontalSpacers.small,
                                Icon(Icons.message_outlined),
                              ],
                            ),
                          ),
                        ),
                    ],
                  ),
                  body: LiveStreamPage(
                    isStreamer: state.params.containsValue('stream'),
                  ),
                ),
              ),
            ),
          ],
        ),
      ],
    ),
  );

  serviceLocator.registerLazySingleton<MainNavbarCubit>(
    () => MainNavbarCubit(),
  );
}
