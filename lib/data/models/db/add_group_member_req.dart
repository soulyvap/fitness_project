import 'package:cloud_firestore/cloud_firestore.dart';

class UpdateGroupMemberReq {
  final String? groupMemberId;
  final String groupId;
  final String? userId;
  final int? score;
  final bool? isAdmin;
  final Timestamp? joinedAt;

  UpdateGroupMemberReq({
    this.groupMemberId,
    required this.groupId,
    this.userId,
    this.score,
    this.isAdmin,
    this.joinedAt,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'groupMemberId': groupMemberId,
      'groupId': groupId,
      'userId': userId,
      'score': score,
      'isAdmin': isAdmin,
      'joinedAt': joinedAt,
    };
  }
}
