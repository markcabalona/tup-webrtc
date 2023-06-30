// ignore_for_file: public_member_api_docs, sort_constructors_first
abstract class Failure {
  final String? message;
  const Failure({
    this.message,
  });
}

class LiveStreamFailure extends Failure {
  const LiveStreamFailure({super.message});
}

class CommentFailure extends Failure {
  const CommentFailure({super.message});
}
