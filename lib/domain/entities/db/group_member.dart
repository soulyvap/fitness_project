class GroupMemberEntity {
  final String groupMemberId;
  final String groupeId;
  final String userId;
  final int score;
  final bool isAdmin;
  final DateTime joinedAt;
  final DateTime? leftAt;

  GroupMemberEntity({
    required this.groupMemberId,
    required this.groupeId,
    required this.userId,
    required this.score,
    required this.isAdmin,
    required this.joinedAt,
    this.leftAt,
  });
}
