import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:tuplive/features/Comment/domain/entities/comment.dart';

part 'comment_state.dart';

class CommentCubit extends Cubit<CommentState> {
  CommentCubit() : super(const CommentState());
}
