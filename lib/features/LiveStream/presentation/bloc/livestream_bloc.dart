import 'dart:async';
import 'dart:convert';
import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_webrtc/flutter_webrtc.dart';
import 'package:get_it/get_it.dart';

part 'livestream_event.dart';
part 'livestream_state.dart';

class LiveStreamBloc extends Bloc<LiveStreamEvent, LiveStreamState> {
  LiveStreamBloc() : super(LivestreamInitial()) {
    on<CreateRoomEvent>(_createRoom);
    on<StopStreamingEvent>(
      (event, emit) async {
        if (state is LiveStreamReady) {
          await _stopStreaming(event, emit, (state as LiveStreamReady));
        }
        emit(LivestreamInitial());
      },
    );
    on<JoinRoom>(_joinRoom);

    on<_UpdateStatus>(
      (event, emit) {
        emit(event.state);
      },
    );
  }
}

FutureOr<void> _createRoom(
  CreateRoomEvent event,
  Emitter<LiveStreamState> emit,
) async {
  final peerConnection = await _createPC();

  registerPeerConnectionListeners(
    peerConnection,
  );

  MediaStream localStream = await Helper.openCamera({
    'audio': true,
    'video': {
      'facingMode': 'user',
    }
  });

  await peerConnection.addStream(localStream);
  localStream.getTracks().forEach((element) async {
    await peerConnection.addTrack(element, localStream);
  });

  RTCSessionDescription offer = await peerConnection.createOffer();

  await peerConnection.setLocalDescription(offer);

  FirebaseFirestore db = FirebaseFirestore.instance;
  DocumentReference roomRef = db.collection('rooms').doc();

  Map<String, dynamic> roomWithOffer = {
    'offer': offer.toMap(),
  };

  await roomRef.set(
    roomWithOffer,
  );
  peerConnection.onIceCandidate = (candidate) async {
    final iceCands = roomRef.collection('callerCandidates');
    await iceCands.add(candidate.toMap());
  };

  roomRef.snapshots().listen((event) {
    final answer = event.data();
    if (answer is Map && (answer)['answer'] != null) {
      peerConnection.setRemoteDescription(
        RTCSessionDescription(answer['answer']['sdp'], 'answer'),
      );
    }
  });

  roomRef.collection('viewerCandidates').snapshots().listen((event) {
    for (var change in event.docChanges) {
      if (change.type == DocumentChangeType.added) {
        final map = change.doc.data() as Map<String, dynamic>;
        final iceCand = RTCIceCandidate(
          map['candidate'],
          map['sdpMid'],
          map['sdpMLineIndex'],
        );
        peerConnection.addCandidate(iceCand);
      }
    }
  });

  final renderer = RTCVideoRenderer();
  await renderer.initialize();

  renderer.srcObject = localStream;

  emit(
    LiveStreamReady(
      peerConnection: peerConnection,
      videoRenderer: renderer,
      roomID: roomRef.id,
      stream: localStream,
    ),
  );
}

FutureOr<void> _stopStreaming(
  StopStreamingEvent event,
  Emitter<LiveStreamState> emit,
  LiveStreamReady state,
) async {
  List<MediaStreamTrack> tracks = state.videoRenderer.srcObject!.getTracks();
  for (var track in tracks) {
    track.stop();
  }

  state.peerConnection.close();

  var db = FirebaseFirestore.instance;
  var roomRef = db.collection('rooms').doc(state.roomID);

  await roomRef.delete();

  state.stream.dispose();
}

void registerPeerConnectionListeners(
  RTCPeerConnection peerConnection, {
  void Function(MediaStream stream)? onAddStream,
}) {
  peerConnection.onIceGatheringState = (RTCIceGatheringState state) {
    log('ICE gathering state changed: $state');
  };

  peerConnection.onConnectionState = (RTCPeerConnectionState state) {
    log('Connection state change: $state');
  };

  peerConnection.onSignalingState = (RTCSignalingState state) {
    log('Signaling state change: $state');
  };

  peerConnection.onIceCandidate = (e) {
    if (e.candidate != null) {
      log(
          name: 'ice candidate',
          json.encode({
            'candidate': e.candidate.toString(),
            'sdpMid': e.sdpMid.toString(),
            'sdpMlineIndex': e.sdpMLineIndex,
          }));
    }
  };

  peerConnection.onAddStream = onAddStream;
}

FutureOr<void> _joinRoom(
  JoinRoom event,
  Emitter<LiveStreamState> emit,
) async {
  final peerConnection = await _createPC();
  final renderer = RTCVideoRenderer();
  await renderer.initialize();

  renderer.srcObject = await createLocalMediaStream('key');

  registerPeerConnectionListeners(
    peerConnection,
    onAddStream: (stream) async {
      log('message');
      renderer.srcObject = stream;
      print("Add remote stream");

      GetIt.instance<LiveStreamBloc>().add(
        _UpdateStatus(
          state: LiveStreamReady(
            stream: stream,
            videoRenderer: renderer,
            roomID: event.roomID,
            peerConnection: peerConnection,
          ),
        ),
      );
    },
  );
  peerConnection.onTrack = (RTCTrackEvent event) {
    log('track edent');
    event.streams[0].getTracks().forEach((track) {
      final state = GetIt.instance<LiveStreamBloc>().state;
      if (state is LiveStreamReady) {
        state.stream.addTrack(track);
      }
    });
  };

  final db = FirebaseFirestore.instance;
  final roomRef = db.collection('rooms').doc(event.roomID);

  peerConnection.onIceCandidate = (candidate) async {
    final iceCands = roomRef.collection('viewerCandidates');
    await iceCands.add(candidate.toMap());
  };

  final room = await roomRef.get();

  await db.runTransaction((transaction) async {
    final double count = room.data()?['viewers_count'] ?? 0;
    roomRef.update({'viewers_count': count + 1});
  });

  peerConnection.setRemoteDescription(
    RTCSessionDescription(event.sdp, 'offer'),
  );

  final answer = await peerConnection.createAnswer();
  await peerConnection.setLocalDescription(answer);
  roomRef.update({'answer': answer.toMap()});

  roomRef.collection('callerCandidates').snapshots().listen((event) {
    for (var change in event.docChanges) {
      if (change.type == DocumentChangeType.added) {
        final map = change.doc.data() as Map<String, dynamic>;
        final iceCand = RTCIceCandidate(
          map['candidate'],
          map['sdpMid'],
          map['sdpMLineIndex'],
        );
        peerConnection.addCandidate(iceCand);
      }
    }
  });
}

Future<RTCPeerConnection> _createPC() async {
  return await createPeerConnection({
    "iceServers": [
      {
        "urls": "stun:relay.metered.ca:80",
      },
      {
        "urls": "turn:relay.metered.ca:80",
        "username": "914f9f688d315f61a8a49fb0",
        "credential": "1ebQ26Y2VjMMzAnk",
      },
      {
        "urls": "turn:relay.metered.ca:443",
        "username": "914f9f688d315f61a8a49fb0",
        "credential": "1ebQ26Y2VjMMzAnk",
      },
      {
        "urls": "turn:relay.metered.ca:443?transport=tcp",
        "username": "914f9f688d315f61a8a49fb0",
        "credential": "1ebQ26Y2VjMMzAnk",
      },
    ],
  });
}
