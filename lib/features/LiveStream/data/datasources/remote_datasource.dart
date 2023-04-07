import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:tuplive/core/errors/exceptions.dart';
import 'package:tuplive/core/mixins/api_handler_mixin.dart';
import 'package:tuplive/features/LiveStream/domain/entities/stream_configs.dart';

class RemoteDatesource with FirestoreHandlerMixin {
  Future<void> listenToLiveStreamUpdates({
    required Function(List<StreamConfigs> configs) onLiveStreamsUpdates,
  }) async {
    return firestoreHandler(
      request: () async {
        CollectionReference roomsRef = firestore.collection('rooms');
        roomsRef.snapshots().forEach(
          (event) {
            final configs = event.docs.where((doc) => doc.exists).map(
              (doc) {
                final Map<String, dynamic> offer =
                    doc.data() as Map<String, dynamic>;

                return StreamConfigs.fromMap(
                  offer
                    ..addEntries(
                      {'roomID': doc.id}.entries,
                    ),
                );
              },
            ).toList();

            onLiveStreamsUpdates(configs);
          },
        );
      },
      onFailure: (error) {
        throw AppException(message: error.message);
      },
    );
  }
}
