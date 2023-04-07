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

final List<RTCPeerConnection> peerConnections = [];

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

  peerConnections.add(peerConnection);

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

  Map<String, dynamic> roomWithOffer = {'offer': offer.toMap()};
  await roomRef.set(roomWithOffer);

  peerConnection.onIceCandidate = (candidate) async {
    final iceCands = roomRef.collection('callerCandidates');
    await iceCands.add(candidate.toMap());
  };

  roomRef.collection('answers').snapshots().listen((snapshots) async {
    for (var change in snapshots.docChanges) {
      if (change.type == DocumentChangeType.added) {
        final answer = change.doc.data();
        if (answer?['answer'] != null) {
          for (var element in peerConnections) {
            if ((await element.getRemoteDescription()) == null) {
              element.setRemoteDescription(
                RTCSessionDescription(answer!['answer']['sdp'], 'answer'),
              );
              break;
            }
          }

          // create new peer connection
          final newPC = await _createPC();
          peerConnections.add(newPC);
          registerPeerConnectionListeners(
            newPC,
          );
          newPC.addStream(localStream);
          RTCSessionDescription offer = await newPC.createOffer();
          await newPC.setLocalDescription(offer);

          Map<String, dynamic> roomWithOffer = {'offer': offer.toMap()};
          await roomRef.update(roomWithOffer);

          newPC.onIceCandidate = (candidate) async {
            for (var element
                in (await roomRef.collection('callerCandidates').get()).docs) {
              element.reference.update(candidate.toMap());
            }
          };
        }
      }
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
        for (var element in peerConnections) {
          element.addCandidate(iceCand);
        }
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

  if (event.isStreamer) {
    var db = FirebaseFirestore.instance;
    var roomRef = db.collection('rooms').doc(state.roomID);
    for (var element in (await roomRef.collection('answers').get()).docs) {
      element.reference.delete();
    }
    for (var element
        in (await roomRef.collection('callerCandidates').get()).docs) {
      element.reference.delete();
    }
    for (var element
        in (await roomRef.collection('viewerCandidates').get()).docs) {
      element.reference.delete();
    }

    await roomRef.delete();

    state.stream.dispose();
  }
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
    if (state == RTCPeerConnectionState.RTCPeerConnectionStateFailed) {
      peerConnection.restartIce();
    }
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
  final peerConnection =
      await _createPC(optional: {"iceTransportPolicy": "relay"});
  final renderer = RTCVideoRenderer();
  await renderer.initialize();

  renderer.srcObject = await createLocalMediaStream('key');

  registerPeerConnectionListeners(
    peerConnection,
    onAddStream: (stream) async {
      renderer.srcObject = stream;

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

  roomRef.collection('answers').add({'answer': answer.toMap()});

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

Future<RTCPeerConnection> _createPC({Map<String, dynamic>? optional}) async {
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
    // if (optional != null) ...optional
  });
}
