import 'package:flutter/material.dart';

class ScoreEntity {
  final String scoreId;
  final String challengeId;
  final String? submissionId;
  final String groupId;
  final String userId;
  final int points;
  final ScoreType type;

  ScoreEntity({
    required this.scoreId,
    required this.challengeId,
    required this.userId,
    required this.points,
    required this.type,
    required this.groupId,
    this.submissionId,
  });
}

enum ScoreType {
  challengeCreation(
      value: 15,
      description: 'Challenge creation',
      icon: Icon(Icons.add_circle, color: Colors.green)),
  challengeParticipation(
      value: 10,
      description: 'Challenge completion',
      icon: Icon(Icons.check_circle, color: Colors.green)),
  challengeEarlyParticipation1(
      value: 10,
      description: '1st place bonus',
      icon: Icon(Icons.emoji_events, color: Colors.yellow)),
  challengeEarlyParticipation2(
      value: 8,
      description: '2nd place bonus',
      icon: Icon(Icons.emoji_events, color: Colors.grey)),
  challengeEarlyParticipation3(
      value: 6,
      description: '3rd place bonus',
      icon: Icon(Icons.emoji_events, color: Colors.brown)),
  challengeEarlyParticipation4(
      value: 4,
      description: '4th place bonus',
      icon: Icon(Icons.emoji_events, color: Colors.blue)),
  challengeEarlyParticipation5(
      value: 2,
      description: '5th place bonus',
      icon: Icon(Icons.emoji_events, color: Colors.red)),
  challengeParticipationStreak(
      value: 5,
      description: 'Streak bonus',
      icon: Icon(Icons.emoji_events, color: Colors.green)),
  challengeParticipationAll(
      value: 20,
      description: 'Participation in all challenges',
      icon: Icon(Icons.checklist, color: Colors.green)),
  ;

  const ScoreType(
      {required this.value, required this.description, required this.icon});

  final int value;
  final String description;
  final Widget icon;

  String get name {
    return toString().split('.').last;
  }

  static ScoreType fromName(String name) {
    return ScoreType.values.firstWhere((element) => element.name == name);
  }

  static ScoreType? earlyParticipation(int place) {
    switch (place) {
      case 1:
        return challengeEarlyParticipation1;
      case 2:
        return challengeEarlyParticipation2;
      case 3:
        return challengeEarlyParticipation3;
      case 4:
        return challengeEarlyParticipation4;
      case 5:
        return challengeEarlyParticipation5;
      default:
        return null;
    }
  }
}
