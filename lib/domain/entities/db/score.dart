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
  challengeCreation(value: 15, description: 'Challenge creation'),
  challengeParticipation(value: 10, description: 'Challenge participation'),
  challengeEarlyParticipation1(value: 10, description: '1st place bonus'),
  challengeEarlyParticipation2(value: 8, description: '2nd place bonus'),
  challengeEarlyParticipation3(value: 6, description: '3rd place bonus'),
  challengeEarlyParticipation4(value: 4, description: '4th place bonus'),
  challengeEarlyParticipation5(value: 2, description: '5th place bonus'),
  challengeParticipationStreak(value: 5, description: 'Streak bonus'),
  challengeParticipationAll(
      value: 20, description: 'Participation in all challenges'),
  ;

  const ScoreType({required this.value, required this.description});

  final int value;
  final String description;

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
