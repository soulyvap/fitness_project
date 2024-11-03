class UpdateLikeReq {
  final String submissionId;
  final String userId;
  final bool isLiked;

  UpdateLikeReq(
      {required this.submissionId,
      required this.userId,
      required this.isLiked});
}
