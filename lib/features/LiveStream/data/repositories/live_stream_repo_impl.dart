import 'package:dartz/dartz.dart';
import 'package:tuplive/core/errors/failure.dart';
import 'package:tuplive/core/mixins/repository_handler_mixin.dart';
import 'package:tuplive/features/LiveStream/data/datasources/remote_datasource.dart';
import 'package:tuplive/features/LiveStream/domain/entities/stream_configs.dart';
import 'package:tuplive/features/LiveStream/domain/repositories/live_stream_repo.dart';

class LiveStreamRepoImpl with RepositoryHandlerMixin implements LiveStreamRepo {
  final RemoteDatesource _datasource;
  const LiveStreamRepoImpl(this._datasource);

  @override
  Future<Either<Failure, void>> streamLiveStreamsUpdates({
    required Function(List<StreamConfigs> configs) onLiveStreamsUpdates,
  }) async {
    return this(
      request: () => _datasource.listenToLiveStreamUpdates(
        onLiveStreamsUpdates: onLiveStreamsUpdates,
      ),
      onFailure: (message) {
        return LiveStreamFailure(message: message);
      },
    );
  }
}
