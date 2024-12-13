class SubmissionEntity {
  final String submissionId;
  final String challengeId;
  final String userId;
  final String groupId;
  final String videoUrl;
  final String thumbnailUrl;
  final DateTime createdAt;
  final List<String> likedBy;
  final int commentCount;
  final List<String> seenBy;
  final DateTime? cancelledAt;
  final String? cancellationReason;
  final String? cancelledBy;

  SubmissionEntity({
    required this.submissionId,
    required this.challengeId,
    required this.userId,
    required this.groupId,
    required this.videoUrl,
    required this.thumbnailUrl,
    required this.createdAt,
    required this.likedBy,
    required this.commentCount,
    required this.seenBy,
    this.cancelledAt,
    this.cancellationReason,
    this.cancelledBy,
  });

  SubmissionEntity copyWith(
      {String? submissionId,
      String? challengeId,
      String? userId,
      String? groupId,
      String? videoUrl,
      String? thumbnailUrl,
      DateTime? createdAt,
      List<String>? likedBy,
      int? commentCount,
      List<String>? seenBy,
      DateTime? cancelledAt,
      String? cancellationReason,
      String? cancelledBy}) {
    return SubmissionEntity(
      submissionId: submissionId ?? this.submissionId,
      challengeId: challengeId ?? this.challengeId,
      userId: userId ?? this.userId,
      groupId: groupId ?? this.groupId,
      videoUrl: videoUrl ?? this.videoUrl,
      thumbnailUrl: thumbnailUrl ?? this.thumbnailUrl,
      createdAt: createdAt ?? this.createdAt,
      likedBy: likedBy ?? this.likedBy,
      commentCount: commentCount ?? this.commentCount,
      seenBy: seenBy ?? this.seenBy,
      cancelledAt: cancelledAt ?? this.cancelledAt,
      cancellationReason: cancellationReason ?? this.cancellationReason,
      cancelledBy: cancelledBy ?? this.cancelledBy,
    );
  }
}
