import 'package:cloud_firestore/cloud_firestore.dart';

class UpdateSubmissionReq {
  final String? submissionId;
  final String? challengeId;
  final String? userId;
  final String? groupId;
  final String? videoUrl;
  final String? thumbnailUrl;
  final Timestamp? createdAt;
  final List<String>? likedBy;
  final int? commentCount;
  final List<String>? seenBy;

  UpdateSubmissionReq({
    this.submissionId,
    this.challengeId,
    this.userId,
    this.groupId,
    this.videoUrl,
    this.thumbnailUrl,
    this.createdAt,
    this.likedBy,
    this.commentCount,
    this.seenBy,
  });

  Map<String, dynamic> toMap() {
    final dataMap = {
      'submissionId': submissionId,
      'challengeId': challengeId,
      'userId': userId,
      'groupId': groupId,
      'videoUrl': videoUrl,
      'thumbnailUrl': thumbnailUrl,
      'createdAt': createdAt,
      'likedBy': likedBy,
      'commentCount': commentCount,
      'seenBy': seenBy,
    };

    dataMap.removeWhere((key, value) => value == null);

    return dataMap;
  }
}
