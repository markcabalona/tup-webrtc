// ignore_for_file: public_member_api_docs, sort_constructors_first
part of 'livestream_bloc.dart';

abstract class LiveStreamEvent extends Equatable {
  const LiveStreamEvent();

  @override
  List<Object> get props => [];
}

class CreateRoomEvent extends LiveStreamEvent {
  const CreateRoomEvent();
}

class StopStreamingEvent extends LiveStreamEvent {
  const StopStreamingEvent();
}

class JoinRoom extends LiveStreamEvent {
  final String sdp;
  final String roomID;
  final RTCIceCandidate candidate;
  const JoinRoom({
    required this.sdp,
    required this.roomID,
    required this.candidate,
  });
}

class _UpdateStatus extends LiveStreamEvent {
  final LiveStreamState state;
  const _UpdateStatus({
    required this.state,
  });
}
