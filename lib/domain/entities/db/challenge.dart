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

  ChallengeEntity copyWith({
    String? challengeId,
    String? groupId,
    String? exerciseId,
    int? reps,
    int? minutesToComplete,
    String? extraInstructions,
    String? userId,
    DateTime? createdAt,
    DateTime? endsAt,
  }) {
    return ChallengeEntity(
      challengeId: challengeId ?? this.challengeId,
      groupId: groupId ?? this.groupId,
      exerciseId: exerciseId ?? this.exerciseId,
      reps: reps ?? this.reps,
      minutesToComplete: minutesToComplete ?? this.minutesToComplete,
      extraInstructions: extraInstructions ?? this.extraInstructions,
      userId: userId ?? this.userId,
      createdAt: createdAt ?? this.createdAt,
      endsAt: endsAt ?? this.endsAt,
    );
  }
}
