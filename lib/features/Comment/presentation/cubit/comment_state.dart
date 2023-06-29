// ignore_for_file: public_member_api_docs, sort_constructors_first
part of 'comment_cubit.dart';

class CommentState extends Equatable {
  final List<Comment> comments;
  const CommentState({
    this.comments = const [],
  });

  @override
  List<Object> get props => [comments];
}
