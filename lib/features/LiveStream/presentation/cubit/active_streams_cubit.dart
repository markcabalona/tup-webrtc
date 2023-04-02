import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:tuplive/core/constants/enums.dart';
import 'package:tuplive/features/LiveStream/domain/entities/stream_configs.dart';

part 'active_streams_state.dart';

class ActiveStreamsCubit extends Cubit<ActiveStreamsState> {
  ActiveStreamsCubit() : super(const ActiveStreamsState());

  Future<void> getLiveStreams() async {
    FirebaseFirestore db = FirebaseFirestore.instance;
    CollectionReference roomsRef = db.collection('rooms');
    log('fetching rooms');

    roomsRef.snapshots().forEach(
      (event) {
        emit(state.copyWith(configs: []));
        for (var e in event.docs) {
          if (e.exists) {
            final Map<String, dynamic> offer = e.data() as Map<String, dynamic>;

            emit(
              state.copyWith(
                status: state.status != StateStatus.loaded
                    ? StateStatus.loaded
                    : null,
                configs: [
                  ...state.configs,
                  StreamConfigs.fromMap(
                    offer..addEntries({'roomID': e.id}.entries),
                  )
                ],
              ),
            );
          }
        }
      },
    );
  }
}
