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
  final List<String> likedBy;
  final int commentCount;
  final List<String> seenBy;
  final Timestamp? cancelledAt;
  final String? cancellationReason;
  final String? cancelledBy;

  SubmissionModel({
    required this.submissionId,
    required this.challengeId,
    required this.userId,
    required this.videoUrl,
    required this.thumbnailUrl,
    required this.createdAt,
    required this.groupId,
    required this.likedBy,
    required this.commentCount,
    required this.seenBy,
    this.cancelledAt,
    this.cancellationReason,
    this.cancelledBy,
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
      likedBy: map['likedBy'] == null
          ? []
          : (map['likedBy'] as List).map((e) => e.toString()).toList(),
      commentCount: map['commentCount'] ?? 0,
      seenBy: map['seenBy'] == null
          ? []
          : (map['seenBy'] as List).map((e) => e.toString()).toList(),
      cancelledAt: map['cancelledAt'],
      cancellationReason: map['cancellationReason'],
      cancelledBy: map['cancelledBy'],
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
      'likedBy': likedBy,
      'commentCount': commentCount,
      'seenBy': seenBy,
      'cancelledAt': cancelledAt,
      'cancellationReason': cancellationReason,
      'cancelledBy': cancelledBy,
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
      likedBy: likedBy,
      commentCount: commentCount,
      seenBy: seenBy,
      cancelledAt: cancelledAt?.toDate(),
      cancellationReason: cancellationReason,
      cancelledBy: cancelledBy,
    );
  }
}
