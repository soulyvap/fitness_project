class GetGroupsByUserReq {
  final String userId;
  final bool onlyActive;

  GetGroupsByUserReq({
    required this.userId,
    this.onlyActive = true,
  });
}
