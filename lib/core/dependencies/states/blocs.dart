import 'package:tuplive/core/dependencies/dependencies.dart'
    show serviceLocator;
import 'package:tuplive/features/LiveStream/presentation/bloc/livestream_bloc.dart';

void initializeBlocs() {
  serviceLocator.registerLazySingleton<LiveStreamBloc>(
    () => LiveStreamBloc(serviceLocator()),
  );
}
