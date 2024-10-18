import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fitness_project/domain/entities/db/group_member.dart';

class GroupMemberModel {
  final String groupMemberId;
  final String groupeId;
  final String userId;
  final int score;
  final bool isAdmin;
  final Timestamp joinedAt;
  final Timestamp? leftAt;

  GroupMemberModel({
    required this.groupMemberId,
    required this.groupeId,
    required this.userId,
    required this.score,
    required this.isAdmin,
    required this.joinedAt,
    this.leftAt,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'groupMemberId': groupMemberId,
      'groupeId': groupeId,
      'userId': userId,
      'score': score,
      'isAdmin': isAdmin,
      'joinedAt': joinedAt,
      'leftAt': leftAt,
    };
  }

  factory GroupMemberModel.fromMap(Map<String, dynamic> map) {
    return GroupMemberModel(
      groupMemberId: map['groupMemberId'] as String,
      groupeId: map['groupeId'] as String,
      userId: map['userId'] as String,
      score: map['score'] as int,
      isAdmin: map['isAdmin'] as bool,
      joinedAt: map['joinedAt'],
      leftAt: map['leftAt'],
    );
  }

  String toJson() => json.encode(toMap());

  factory GroupMemberModel.fromJson(String source) =>
      GroupMemberModel.fromMap(json.decode(source) as Map<String, dynamic>);
}

extension GroupMemberXModel on GroupMemberModel {
  GroupMemberEntity toEntity() {
    return GroupMemberEntity(
      groupMemberId: groupMemberId,
      groupeId: groupeId,
      userId: userId,
      score: score,
      isAdmin: isAdmin,
      joinedAt: joinedAt.toDate(),
      leftAt: leftAt?.toDate(),
    );
  }
}
