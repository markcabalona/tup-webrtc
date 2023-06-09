import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:tuplive/core/dependencies/dependencies.dart'
    show serviceLocator;
import 'package:tuplive/core/theme/cubits/theme_cubit/app_theme_cubit.dart';
import 'package:tuplive/features/Auth/presentation/cubit/auth_cubit.dart';
import 'package:tuplive/features/Comment/data/datasources/comment_datasource.dart';
import 'package:tuplive/features/Comment/data/repositories/comment_repository_impl.dart';
import 'package:tuplive/features/Comment/presentation/cubit/comment_cubit.dart';
import 'package:tuplive/features/LiveStream/presentation/cubit/active_streams_cubit.dart';

void initializeCubits() {
  serviceLocator.registerLazySingleton<AppThemeModeCubit>(
    () => AppThemeModeCubit(
      storage: serviceLocator<FlutterSecureStorage>(),
    ),
  );

  serviceLocator.registerLazySingleton<ActiveStreamsCubit>(
    () => ActiveStreamsCubit(serviceLocator())..getLiveStreams(),
  );

  serviceLocator.registerLazySingleton<AuthCubit>(
    () => AuthCubit(),
  );

  serviceLocator.registerFactory<CommentCubit>(
    () => CommentCubit(
      CommentRepositoryImpl(
        datasource: CommentDatasource(),
      ),
    ),
  );
}
