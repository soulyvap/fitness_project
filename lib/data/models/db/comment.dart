import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fitness_project/domain/usecases/db/comment.dart';

class CommentModel {
  final String commentId;
  final String submissionId;
  final String userId;
  final String comment;
  final Timestamp createdAt;

  CommentModel({
    required this.commentId,
    required this.submissionId,
    required this.userId,
    required this.comment,
    required this.createdAt,
  });

  factory CommentModel.fromMap(Map<String, dynamic> map) {
    return CommentModel(
      commentId: map['commentId'],
      submissionId: map['submissionId'],
      userId: map['userId'],
      comment: map['comment'],
      createdAt: map['createdAt'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'commentId': commentId,
      'submissionId': submissionId,
      'userId': userId,
      'comment': comment,
      'createdAt': createdAt,
    };
  }
}

extension CommentModelX on CommentModel {
  CommentEntity toEntity() {
    return CommentEntity(
      commentId: commentId,
      submissionId: submissionId,
      userId: userId,
      comment: comment,
      createdAt: createdAt.toDate(),
    );
  }
}
