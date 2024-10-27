class AddScoreReq {
  final String challengeId;
  final String? submissionId;
  final String groupId;
  final String userId;
  final int points;
  final String type;

  AddScoreReq({
    required this.challengeId,
    required this.userId,
    required this.points,
    required this.type,
    required this.groupId,
    this.submissionId,
  });

  Map<String, dynamic> toMap() {
    final dataMap = {
      'challengeId': challengeId,
      'submissionId': submissionId,
      'groupId': groupId,
      'userId': userId,
      'points': points,
      'type': type,
    };

    dataMap.removeWhere((key, value) => value == null);

    return dataMap;
  }
}
