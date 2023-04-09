import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart' show kIsWeb, defaultTargetPlatform;
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:go_router/go_router.dart';
import 'package:responsive_framework/responsive_framework.dart';
import 'package:tuplive/core/dependencies/dependencies.dart'
    show initializeDependencies, serviceLocator;
import 'package:tuplive/core/theme/cubits/theme_cubit/app_theme_cubit.dart';
import 'package:tuplive/core/theme/theme.dart';
import 'package:tuplive/firebase_options.dart';

Future<void> bootstrap({required String envFilename}) async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  if (kIsWeb || defaultTargetPlatform == TargetPlatform.macOS) {
    // initialiaze the facebook javascript SDK
    await FacebookAuth.instance.webAndDesktopInitialize(
      appId: "1280532475867293",
      cookie: true,
      xfbml: true,
      version: "v16.0",
    );
  }

  await initializeDependencies();

  Animate.defaultCurve = Curves.ease;
  Animate.defaultDuration = 800.ms;
  Animate.restartOnHotReload = true;
  await Future.wait(
    [
      serviceLocator<AppThemeModeCubit>().initializeTheme(),
    ],
  );

  runApp(
    MultiBlocProvider(
      providers: [
        BlocProvider<AppThemeModeCubit>(
          create: (context) => serviceLocator<AppThemeModeCubit>(),
        ),
      ],
      child: const OkadaManilaApp(),
    ),
  );
}

class OkadaManilaApp extends StatelessWidget {
  const OkadaManilaApp({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AppThemeModeCubit, AppThemeModeState>(
      buildWhen: (previous, current) {
        return previous.isDark != current.isDark;
      },
      builder: (context, state) {
        return MaterialApp.router(
          title: 'TUPLive',
          theme: AppTheme.lightTheme,
          darkTheme: AppTheme.darkTheme,
          themeMode: state.isDark ? ThemeMode.dark : ThemeMode.light,
          routerConfig: serviceLocator<GoRouter>(),
          builder: EasyLoading.init(
            builder: (context, child) {
              return ResponsiveWrapper.builder(
                child ?? const SizedBox(),
                breakpoints: [
                  const ResponsiveBreakpoint.autoScale(480, name: MOBILE),
                  const ResponsiveBreakpoint.resize(800, name: TABLET),
                  const ResponsiveBreakpoint.autoScale(1300, name: DESKTOP),
                ],
              );
            },
          ),
        );
      },
    );
  }
}
