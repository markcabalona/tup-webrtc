part of 'comment_cubit.dart';

class CommentState extends Equatable {
  final StateStatus status;
  final List<Comment> comments;
  const CommentState({
    this.status = StateStatus.initial,
    this.comments = const [],
  });

  @override
  List<Object> get props => [status, comments];

  CommentState copyWith({
    StateStatus? status,
    List<Comment>? comments,
  }) {
    return CommentState(
      status: status ?? this.status,
      comments: comments ?? this.comments,
    );
  }
}
