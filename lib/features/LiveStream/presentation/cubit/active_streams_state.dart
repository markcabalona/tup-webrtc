// ignore_for_file: public_member_api_docs, sort_constructors_first
part of 'active_streams_cubit.dart';

class ActiveStreamsState extends Equatable {
  final List<StreamConfigs> configs;
  final StateStatus status;
  const ActiveStreamsState({
    this.configs = const [],
    this.status = StateStatus.initial,
  });

  @override
  List<Object> get props => [configs, status];

  ActiveStreamsState copyWith({
    List<StreamConfigs>? configs,
    StateStatus? status,
  }) {
    return ActiveStreamsState(
      configs: configs ?? this.configs,
      status: status ?? this.status,
    );
  }
}
