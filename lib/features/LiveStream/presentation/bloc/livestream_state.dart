// ignore_for_file: public_member_api_docs, sort_constructors_first
part of 'livestream_bloc.dart';

typedef StreamStateCallback = void Function(MediaStream stream);

abstract class LiveStreamState extends Equatable {
  const LiveStreamState();

  @override
  List<Object> get props => [];
}

class LivestreamInitial extends LiveStreamState {}

class LiveStreamReady extends LiveStreamState {
  final MediaStream stream;
  final RTCVideoRenderer videoRenderer;
  final String roomID;
  final RTCPeerConnection peerConnection;

  const LiveStreamReady({
    required this.stream,
    required this.videoRenderer,
    required this.roomID,
    required this.peerConnection,
  });

  LiveStreamReady copyWith({
    MediaStream? stream,
    RTCVideoRenderer? videoRenderer,
    String? roomID,
    RTCPeerConnection? peerConnection,
  }) {
    return LiveStreamReady(
      stream: stream ?? this.stream,
      videoRenderer: videoRenderer ?? this.videoRenderer,
      roomID: roomID ?? this.roomID,
      peerConnection: peerConnection ?? this.peerConnection,
    );
  }

  @override
  List<Object> get props => [
        ...super.props,
        roomID,
        stream,
        peerConnection,
        videoRenderer,
      ];
}
