import 'package:dartz/dartz.dart';
import 'package:tuplive/core/errors/failure.dart';
import 'package:tuplive/features/LiveStream/domain/entities/stream_configs.dart';

abstract class LiveStreamRepo {
  Future<Either<Failure, void>> streamLiveStreamsUpdates({
    required Function(List<StreamConfigs> configs) onLiveStreamsUpdates,
  });
}
