class SubmissionCancellationEntity {
  final String cancellationId;
  final String submissionId;
  final String userId;
  final String challengeId;
  final String groupId;
  final String reason;
  final DateTime createdAt;

  SubmissionCancellationEntity({
    required this.cancellationId,
    required this.submissionId,
    required this.userId,
    required this.challengeId,
    required this.groupId,
    required this.reason,
    required this.createdAt,
  });
}
