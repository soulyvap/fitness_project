import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fitness_project/domain/entities/db/challenge.dart';

class ChallengeModel {
  final String challengeId;
  final String groupId;
  final String exerciseId;
  final String title;
  final int reps;
  final int minutesToComplete;
  final String? extraInstructions;
  final String userId;
  final Timestamp createdAt;
  final Timestamp endsAt;

  ChallengeModel({
    required this.challengeId,
    required this.groupId,
    required this.exerciseId,
    required this.title,
    required this.reps,
    required this.minutesToComplete,
    this.extraInstructions,
    required this.userId,
    required this.createdAt,
    required this.endsAt,
  });

  factory ChallengeModel.fromMap(Map<String, dynamic> map) {
    return ChallengeModel(
      challengeId: map['challengeId'],
      groupId: map['groupId'],
      exerciseId: map['exerciseId'],
      title: map['title'],
      reps: map['reps'],
      minutesToComplete: map['minutesToComplete'],
      extraInstructions: map['extraInstructions'],
      userId: map['userId'],
      createdAt: map['createdAt'],
      endsAt: map['endsAt'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'challengeId': challengeId,
      'groupId': groupId,
      'exerciseId': exerciseId,
      'title': title,
      'reps': reps,
      'minutesToComplete': minutesToComplete,
      'extraInstructions': extraInstructions,
      'userId': userId,
      'createdAt': createdAt,
      'endsAt': endsAt,
    };
  }
}

extension ChallengeModelX on ChallengeModel {
  ChallengeEntity toEntity() {
    return ChallengeEntity(
      challengeId: challengeId,
      groupId: groupId,
      exerciseId: exerciseId,
      title: title,
      reps: reps,
      minutesToComplete: minutesToComplete,
      extraInstructions: extraInstructions,
      userId: userId,
      createdAt: createdAt.toDate(),
      endsAt: endsAt.toDate(),
    );
  }
}
