class SubmissionEntity {
  final String submissionId;
  final String challengeId;
  final String userId;
  final String groupId;
  final String videoUrl;
  final String thumbnailUrl;
  final DateTime createdAt;

  SubmissionEntity({
    required this.submissionId,
    required this.challengeId,
    required this.userId,
    required this.groupId,
    required this.videoUrl,
    required this.thumbnailUrl,
    required this.createdAt,
  });
}
