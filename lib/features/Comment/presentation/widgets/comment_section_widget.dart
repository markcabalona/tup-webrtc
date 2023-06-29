// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tuplive/core/dependencies/dependencies.dart';
import 'package:tuplive/core/utils/datetime_extension.dart';
import 'package:tuplive/features/Comment/presentation/cubit/comment_cubit.dart';
import 'package:tuplive/features/Comment/presentation/widgets/comment_field.dart';

class CommentSectionWidget extends StatelessWidget {
  final String roomID;
  const CommentSectionWidget({
    Key? key,
    required this.roomID,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => serviceLocator<CommentCubit>()
        ..fetchAndSubscribeToComments(
          roomID: roomID,
        ),
      child: BlocBuilder<CommentCubit, CommentState>(
        builder: (context, state) {
          return Column(
            children: [
              ...state.comments.map(
                (e) => Text(
                  "${e.dateCreated.toFormattedTime()} ${e.author.name}: ${e.comment}",
                ),
              ),
              CommentField(
                onSubmit: (comment) {
                  BlocProvider.of<CommentCubit>(context).createComment(
                    roomID: roomID,
                    comment: comment,
                  );
                },
              )
            ],
          );
        },
      ),
    );
  }
}
