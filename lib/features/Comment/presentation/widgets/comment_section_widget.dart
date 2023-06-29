// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tuplive/core/constants/grid.dart';
import 'package:tuplive/core/dependencies/dependencies.dart';
import 'package:tuplive/core/presentation/widgets/profile_pic_widget.dart';
import 'package:tuplive/core/presentation/widgets/spacers.dart';
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
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: AppGrid.x2Small),
        child: BlocBuilder<CommentCubit, CommentState>(
          builder: (context, state) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ...state.comments.map(
                  (e) => Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          ProfilePicWidget(
                            radius: 25,
                            imageUrl: e.author.profileImgUrl,
                          ),
                          HorizontalSpacers.x2Small,
                          Text(
                            e.author.name,
                          ),
                          const Spacer(),
                          Text(
                            "${e.dateCreated.toFormattedTime(format: 'hh:mm:ss')} ${e.dateCreated.hour > 11 ? 'PM' : 'AM'}",
                          )
                        ],
                      ),
                      Padding(
                        padding:
                            const EdgeInsets.only(left: 25 + AppGrid.x2Small),
                        child: Text(e.comment),
                      ),
                      VerticalSpacers.small,
                    ],
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
      ),
    );
  }
}
