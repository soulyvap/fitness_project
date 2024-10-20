class ChallengeEntity {
  final String challengeId;
  final String groupId;
  final String exerciseId;
  final int reps;
  final int minutesToComplete;
  final String? extraInstructions;
  final String userId;
  final DateTime createdAt;
  final DateTime endsAt;

  ChallengeEntity({
    required this.challengeId,
    required this.groupId,
    required this.exerciseId,
    required this.reps,
    required this.minutesToComplete,
    this.extraInstructions,
    required this.userId,
    required this.createdAt,
    required this.endsAt,
  });
}
