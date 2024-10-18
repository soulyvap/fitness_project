import 'package:cloud_firestore/cloud_firestore.dart';

class AddGroupMemberReq {
  final String groupId;
  final String userId;
  final int score = 0;
  final bool isAdmin;
  final Timestamp joinedAt = Timestamp.now();

  AddGroupMemberReq({
    required this.groupId,
    required this.userId,
    required this.isAdmin,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'groupeId': groupId,
      'userId': userId,
      'score': score,
      'isAdmin': isAdmin,
      'joinedAt': joinedAt,
    };
  }
}
