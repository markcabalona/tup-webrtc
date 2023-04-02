// ignore_for_file: public_member_api_docs, sort_constructors_first

import 'package:equatable/equatable.dart';
import 'package:flutter_webrtc/flutter_webrtc.dart';

class StreamConfigs extends Equatable {
  final String roomID;
  final String sdp;
  final RTCIceCandidate candidate;
  const StreamConfigs({
    required this.roomID,
    required this.sdp,
    required this.candidate,
  });
  @override
  List<Object?> get props => [roomID, sdp];

  factory StreamConfigs.fromMap(Map<String, dynamic> map) {
    return StreamConfigs(
      roomID: map['roomID'] as String,
      sdp: map['offer']['sdp'] as String,
      candidate: RTCIceCandidate(
        map['candidate'],
        map['sdpMid'],
        map['sdpMLineIndex'],
      ),
    );
  }
}
