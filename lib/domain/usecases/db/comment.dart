class CommentEntity {
  final String commentId;
  final String submissionId;
  final String userId;
  final String comment;
  final DateTime createdAt;

  CommentEntity({
    required this.commentId,
    required this.submissionId,
    required this.userId,
    required this.comment,
    required this.createdAt,
  });
}
