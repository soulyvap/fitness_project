import 'package:cloud_firestore/cloud_firestore.dart';

class UpdateSubmissionReq {
  final String? submissionId;
  final String? challengeId;
  final String? userId;
  final String? groupId;
  final String? videoUrl;
  final String? thumbnailUrl;
  final Timestamp? createdAt;

  UpdateSubmissionReq({
    this.submissionId,
    this.challengeId,
    this.userId,
    this.groupId,
    this.videoUrl,
    this.thumbnailUrl,
    this.createdAt,
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
    };

    dataMap.removeWhere((key, value) => value == null);

    return dataMap;
  }
}
