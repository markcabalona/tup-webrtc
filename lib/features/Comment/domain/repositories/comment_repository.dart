import 'package:dartz/dartz.dart';
import 'package:tuplive/core/errors/failure.dart';
import 'package:tuplive/features/Auth/domain/entities/user.dart';
import 'package:tuplive/features/Comment/domain/entities/comment.dart';

abstract class CommentRepository {
  Future<Either<CommentFailure, Stream<List<Comment>>>>
      fetchAndSubscribeToComments({
    required String roomID,
  });

  Future<Either<CommentFailure, Comment>> createComment({
    required User author,
    required String comment,
  });
}
