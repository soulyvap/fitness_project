import 'package:cloud_firestore/cloud_firestore.dart';

class UpdateCommentReq {
  final String? commentId;
  final String submissionId;
  final String? userId;
  final String? comment;
  final Timestamp? createdAt;

  UpdateCommentReq({
    this.commentId,
    required this.submissionId,
    this.userId,
    this.comment,
    this.createdAt,
  });

  Map<String, dynamic> toMap() {
    Map<String, dynamic> dataMap = {
      'commentId': commentId,
      'submissionId': submissionId,
      'userId': userId,
      'comment': comment,
      'createdAt': createdAt,
    };

    dataMap.removeWhere((key, value) => value == null);
    return dataMap;
  }
}
