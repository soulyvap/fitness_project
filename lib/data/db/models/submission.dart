import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fitness_project/domain/entities/db/submission.dart';

class SubmissionModel {
  final String submissionId;
  final String challengeId;
  final String userId;
  final String groupId;
  final String videoUrl;
  final String thumbnailUrl;
  final Timestamp createdAt;

  SubmissionModel({
    required this.submissionId,
    required this.challengeId,
    required this.userId,
    required this.videoUrl,
    required this.thumbnailUrl,
    required this.createdAt,
    required this.groupId,
  });

  factory SubmissionModel.fromMap(Map<String, dynamic> map) {
    return SubmissionModel(
      submissionId: map['submissionId'],
      challengeId: map['challengeId'],
      userId: map['userId'],
      videoUrl: map['videoUrl'],
      thumbnailUrl: map['thumbnailUrl'],
      createdAt: map['createdAt'],
      groupId: map['groupId'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'submissionId': submissionId,
      'challengeId': challengeId,
      'userId': userId,
      'videoUrl': videoUrl,
      'thumbnailUrl': thumbnailUrl,
      'createdAt': createdAt,
      'groupId': groupId,
    };
  }
}

extension SubmissionXModel on SubmissionModel {
  SubmissionEntity toEntity() {
    return SubmissionEntity(
      submissionId: submissionId,
      challengeId: challengeId,
      userId: userId,
      videoUrl: videoUrl,
      thumbnailUrl: thumbnailUrl,
      createdAt: createdAt.toDate(),
      groupId: groupId,
    );
  }
}
