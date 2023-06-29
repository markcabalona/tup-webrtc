// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:equatable/equatable.dart';
import 'package:tuplive/features/Auth/domain/entities/user.dart';

class Comment extends Equatable {
  final User author;
  final String comment;
  final DateTime dateCreated;
  const Comment({
    required this.author,
    required this.comment,
    required this.dateCreated,
  });

  @override
  List<Object> get props => [author, comment, dateCreated];
}
