import 'package:tuplive/core/dependencies/dependencies.dart'
    show serviceLocator;
import 'package:tuplive/features/LiveStream/data/datasources/remote_datasource.dart';
import 'package:tuplive/features/LiveStream/data/repositories/live_stream_repo_impl.dart';
import 'package:tuplive/features/LiveStream/domain/repositories/live_stream_repo.dart';

void initializeRepositories() {
  serviceLocator.registerLazySingleton<LiveStreamRepo>(
    () => LiveStreamRepoImpl(RemoteDatesource()),
  );
}
