class GetChallengesByGroupsReq {
  final List<String> groupIds;
  final bool onlyActive;
  GetChallengesByGroupsReq({required this.groupIds, this.onlyActive = true});
}
