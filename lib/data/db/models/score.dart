import 'package:fitness_project/domain/entities/db/score.dart';

class ScoreModel {
  final String scoreId;
  final String challengeId;
  final String? submissionId;
  final String groupId;
  final String userId;
  final int points;
  final String type;

  ScoreModel({
    required this.scoreId,
    required this.challengeId,
    required this.userId,
    required this.points,
    required this.type,
    required this.groupId,
    this.submissionId,
  });

  Map<String, dynamic> toMap() {
    final dataMap = {
      'scoreId': scoreId,
      'challengeId': challengeId,
      'submissionId': submissionId,
      'groupId': groupId,
      'userId': userId,
      'points': points,
      'type': type,
    };
    return dataMap;
  }

  factory ScoreModel.fromMap(Map<String, dynamic> map) {
    return ScoreModel(
      scoreId: map['scoreId'],
      challengeId: map['challengeId'],
      submissionId: map['submissionId'],
      groupId: map['groupId'],
      userId: map['userId'],
      points: map['points'],
      type: map['type'],
    );
  }
}

extension ScoreXModel on ScoreModel {
  ScoreEntity toEntity() {
    return ScoreEntity(
      scoreId: scoreId,
      challengeId: challengeId,
      submissionId: submissionId,
      groupId: groupId,
      userId: userId,
      points: points,
      type: ScoreType.fromName(type),
    );
  }
}
