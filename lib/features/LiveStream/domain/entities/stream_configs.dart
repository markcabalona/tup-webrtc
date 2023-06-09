// ignore_for_file: public_member_api_docs, sort_constructors_first

import 'package:equatable/equatable.dart';
import 'package:flutter_webrtc/flutter_webrtc.dart';
import 'package:tuplive/features/Auth/domain/entities/user.dart';

class StreamConfigs extends Equatable {
  final String roomID;
  final String sdp;
  final User user;
  final RTCIceCandidate candidate;
  final int viewersCount;
  const StreamConfigs({
    required this.roomID,
    required this.sdp,
    required this.user,
    required this.candidate,
    required this.viewersCount,
  });
  @override
  List<Object?> get props => [
        roomID,
        sdp,
        viewersCount,
        user,
        candidate,
      ];

  factory StreamConfigs.fromMap(Map<String, dynamic> map) {
    return StreamConfigs(
      roomID: map['roomID'] as String,
      sdp: map['offer']['sdp'] as String,
      user: User.fromFirebase(map['user']),
      viewersCount: map['viewers_count'] ?? 0,
      candidate: RTCIceCandidate(
        map['candidate'],
        map['sdpMid'],
        map['sdpMLineIndex'],
      ),
    );
  }
}
