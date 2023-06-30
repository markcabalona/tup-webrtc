import 'package:tuplive/features/Auth/domain/entities/user.dart';
import 'package:tuplive/features/Comment/domain/entities/comment.dart';

class CommentModel extends Comment {
  const CommentModel({
    required super.author,
    required super.comment,
    required super.dateCreated,
  });

  factory CommentModel.fromJson(Map<String, dynamic> map) => CommentModel(
        author: User.fromFirebase(map['author']),
        comment: map['comment'],
        dateCreated: DateTime.parse(map['date_created']),
      );
}
