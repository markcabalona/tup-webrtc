import 'package:tuplive/core/errors/exceptions.dart';
import 'package:tuplive/core/mixins/api_handler_mixin.dart';
import 'package:tuplive/features/Auth/domain/entities/user.dart';
import 'package:tuplive/features/Comment/data/models/comment_model.dart';
import 'package:tuplive/features/Comment/domain/entities/comment.dart';

class CommentDatasource with FirestoreHandlerMixin {
  Future<Stream<List<Comment>>> fetchAndSubToComments({
    required String roomID,
  }) async {
    return firestoreHandler(
      request: () async {
        final commentCollection =
            firestore.collection('rooms').doc(roomID).collection('comments');
        final commentSnapshots = commentCollection.snapshots();
        return commentSnapshots.map(
          (snap) => snap.docs
              .map(
                (doc) => CommentModel.fromJson(
                  doc.data(),
                ),
              )
              .toList()
            ..sort((a, b) =>
                a.dateCreated.millisecondsSinceEpoch -
                b.dateCreated.millisecondsSinceEpoch),
        );
      },
      onFailure: (error) {
        throw AppException(message: error.message);
      },
    );
  }

  Future<Comment> createComment({
    required String roomID,
    required User author,
    required String comment,
  }) {
    return firestoreHandler(
      request: () async {
        final commentCollection =
            firestore.collection('rooms').doc(roomID).collection('comments');

        final dateCreated = DateTime.now();

        commentCollection.add({
          'author': author.toMap(),
          'comment': comment,
          'date_created': dateCreated.toIso8601String(),
        });

        return Comment(
          author: author,
          comment: comment,
          dateCreated: dateCreated,
        );
      },
      onFailure: (error) {
        throw AppException(message: error.message);
      },
    );
  }
}
