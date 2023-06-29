// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:dartz/dartz.dart';
import 'package:tuplive/core/errors/failure.dart';
import 'package:tuplive/core/mixins/repository_handler_mixin.dart';
import 'package:tuplive/features/Auth/domain/entities/user.dart';
import 'package:tuplive/features/Comment/data/datasources/comment_datasource.dart';
import 'package:tuplive/features/Comment/domain/entities/comment.dart';
import 'package:tuplive/features/Comment/domain/repositories/comment_repository.dart';

class CommentRepositoryImpl
    with RepositoryHandlerMixin
    implements CommentRepository {
  final CommentDatasource datasource;
  CommentRepositoryImpl({
    required this.datasource,
  });

  @override
  Future<Either<CommentFailure, Comment>> createComment({
    required User author,
    required String roomID,
    required String comment,
  }) {
    return this(
      request: () {
        return datasource.createComment(
          roomID: roomID,
          author: author,
          comment: comment,
        );
      },
      onFailure: (message) {
        return CommentFailure(message: message);
      },
    );
  }

  @override
  Future<Either<CommentFailure, Stream<List<Comment>>>>
      fetchAndSubscribeToComments({
    required String roomID,
  }) {
    return this(
      request: () {
        return datasource.fetchAndSubToComments(roomID: roomID);
      },
      onFailure: (message) {
        return CommentFailure(message: message);
      },
    );
  }

  @override
  Future<void> unsubscribeToCommentSection({
    required String roomID,
  }) {
    return this(
      request: () {
        return datasource.unsubscribeToComments(roomID: roomID);
      },
      onFailure: (message) {
        return CommentFailure(message: message);
      },
    );
  }
}
