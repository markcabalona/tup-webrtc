import 'package:tuplive/core/mixins/api_handler_mixin.dart';
import 'package:tuplive/features/Auth/domain/entities/user.dart';
import 'package:tuplive/features/Comment/domain/entities/comment.dart';

class CommentDatasource with FirestoreHandlerMixin {
  Future<Stream<List<Comment>>> fetchAndSubToComments({
    required String roomID,
  }) async {
    throw UnimplementedError();
  }

  Future<void> unsubscribeToComments({
    required String roomID,
  }) async {
    throw UnimplementedError();
  }

  Future<Comment> createComment({
    required String roomID,
    required User author,
    required String comment,
  }) {
    throw UnimplementedError();
  }
}
