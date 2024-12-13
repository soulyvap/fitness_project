import 'package:flutter/material.dart';

class ScoreEntity {
  final String scoreId;
  final String challengeId;
  final String? submissionId;
  final String groupId;
  final String userId;
  final int points;
  final ScoreType type;
  final DateTime createdAt;

  ScoreEntity({
    required this.scoreId,
    required this.challengeId,
    required this.userId,
    required this.points,
    required this.type,
    required this.groupId,
    this.submissionId,
    required this.createdAt,
  });
}

enum ScoreType {
  challengeCreation(
      value: 15,
      title: 'Challenge creation',
      icon: Icon(Icons.add_circle, color: Colors.orange)),
  challengeParticipation(
      value: 10,
      title: 'Challenge completion',
      icon: Icon(Icons.check_circle, color: Colors.green)),
  challengeEarlyParticipation1(
      value: 10,
      title: '1st place bonus',
      icon: Icon(Icons.emoji_events, color: Colors.yellowAccent)),
  challengeEarlyParticipation2(
      value: 8,
      title: '2nd place bonus',
      icon: Icon(Icons.emoji_events, color: Colors.grey)),
  challengeEarlyParticipation3(
      value: 6,
      title: '3rd place bonus',
      icon: Icon(Icons.emoji_events, color: Colors.brown)),
  challengeEarlyParticipation4(
      value: 4,
      title: '4th place bonus',
      icon: Icon(Icons.emoji_events, color: Colors.black)),
  challengeEarlyParticipation5(
      value: 2,
      title: '5th place bonus',
      icon: Icon(Icons.emoji_events, color: Colors.black)),
  challengeParticipationStreak(
      value: 5,
      title: 'Streak bonus',
      icon: Icon(Icons.star, color: Colors.blue)),
  challengeParticipationAll(
      value: 20,
      title: 'Participation in all challenges',
      icon: Icon(Icons.checklist, color: Colors.green)),
  ;

  const ScoreType(
      {required this.value, required this.title, required this.icon});

  final int value;
  final String title;
  final Widget icon;

  String get name {
    return toString().split('.').last;
  }

  static ScoreType fromName(String name) {
    return ScoreType.values.firstWhere((element) => element.name == name);
  }

  String get explanation {
    switch (this) {
      case challengeCreation:
        return 'Everytime you initiate a challenge';
      case challengeParticipation:
        return 'Everytime you submit a valid attempt';
      case challengeParticipationStreak:
        return 'If you have completed the most recently ended challenge';
      case challengeParticipationAll:
        return 'When the group expires and if you have submitted a valid attempt for every challenge';

      case ScoreType.challengeEarlyParticipation1:
        return 'If you are the first to complete the challenge';
      default:
        return '';
    }
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
