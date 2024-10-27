class ChallengeEntity {
  final String challengeId;
  final String groupId;
  final String exerciseId;
  final String title;
  final int reps;
  final int minutesToComplete;
  final String? extraInstructions;
  final String userId;
  final DateTime createdAt;
  final DateTime endsAt;
  final List<String> completedBy;

  ChallengeEntity({
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
    this.completedBy = const [],
  });

  ChallengeEntity copyWith({
    String? challengeId,
    String? groupId,
    String? exerciseId,
    String? title,
    int? reps,
    int? minutesToComplete,
    String? extraInstructions,
    String? userId,
    DateTime? createdAt,
    DateTime? endsAt,
    List<String>? completedBy,
  }) {
    return ChallengeEntity(
      challengeId: challengeId ?? this.challengeId,
      groupId: groupId ?? this.groupId,
      exerciseId: exerciseId ?? this.exerciseId,
      title: title ?? this.title,
      reps: reps ?? this.reps,
      minutesToComplete: minutesToComplete ?? this.minutesToComplete,
      extraInstructions: extraInstructions ?? this.extraInstructions,
      userId: userId ?? this.userId,
      createdAt: createdAt ?? this.createdAt,
      endsAt: endsAt ?? this.endsAt,
      completedBy: completedBy ?? this.completedBy,
    );
  }
}
