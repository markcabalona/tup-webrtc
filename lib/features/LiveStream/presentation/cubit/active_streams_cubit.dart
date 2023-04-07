import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:tuplive/core/constants/enums.dart';
import 'package:tuplive/features/LiveStream/domain/entities/stream_configs.dart';
import 'package:tuplive/features/LiveStream/domain/repositories/live_stream_repo.dart';

part 'active_streams_state.dart';

class ActiveStreamsCubit extends Cubit<ActiveStreamsState> {
  final LiveStreamRepo _repo;
  ActiveStreamsCubit(this._repo) : super(const ActiveStreamsState());

  Future<void> getLiveStreams() async {
    _repo.streamLiveStreamsUpdates(
      onLiveStreamsUpdates: (configs) {
        emit(
          state.copyWith(
            status:
                state.status != StateStatus.loaded ? StateStatus.loaded : null,
            configs: configs,
          ),
        );
      },
    );
  }
}
