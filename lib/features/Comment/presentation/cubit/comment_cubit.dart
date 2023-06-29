// ignore_for_file: public_member_api_docs, sort_constructors_first

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:tuplive/core/constants/enums.dart';
import 'package:tuplive/features/Comment/domain/entities/comment.dart';
import 'package:tuplive/features/Comment/domain/repositories/comment_repository.dart';

part 'comment_state.dart';

class CommentCubit extends Cubit<CommentState> {
  final CommentRepository _repository;
  CommentCubit(
    this._repository,
  ) : super(const CommentState());

  Future<void> fetchAndSubscribeToComments({required String roomID}) async {
    final result =
        await _repository.fetchAndSubscribeToComments(roomID: roomID);

    result.fold(
      (_) => emit(
        state.copyWith(
          status: StateStatus.error,
        ),
      ),
      (commentsStream) {
        emit(state.copyWith(status: StateStatus.loaded));
        commentsStream.listen((event) {
          emit(
            state.copyWith(
              comments: event,
            ),
          );
        });
      },
    );
  }

  Future<void> unsubscribeToComments({required String roomID}) async {
    await _repository.unsubscribeToCommentSection(roomID: roomID);
    emit(const CommentState());
  }
}
