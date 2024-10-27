class UpdateChallengeReq {
  final String? challengeId;
  final String? groupId;
  final String? exerciseId;
  final String? title;
  final int? reps;
  final int? minutesToComplete;
  final String? extraInstructions;
  final String? userId;
  final DateTime? createdAt;
  final DateTime? endsAt;
  final List<String>? completedBy;

  UpdateChallengeReq({
    this.challengeId,
    this.groupId,
    this.exerciseId,
    this.title,
    this.reps,
    this.minutesToComplete,
    this.extraInstructions,
    this.userId,
    this.createdAt,
    this.endsAt,
    this.completedBy,
  });

  Map<String, dynamic> toMap() {
    final dataMap = {
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
      'completedBy': completedBy,
    };

    dataMap.removeWhere((key, value) => value == null);

    return dataMap;
  }
}
