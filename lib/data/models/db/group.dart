import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fitness_project/domain/entities/db/group.dart';

class GroupModel {
  final String groupId;
  final String name;
  final String description;
  final String? imageUrl;
  final Timestamp startTime;
  final Timestamp endTime;
  final int maxSimultaneousChallenges;
  // final int minutesPerChallenge;
  final bool isPrivate;
  final List<String> allowedUsers;
  final List<String> members;
  final List<String> admins;

  GroupModel(
      {required this.groupId,
      required this.name,
      required this.description,
      this.imageUrl,
      required this.startTime,
      required this.endTime,
      required this.maxSimultaneousChallenges,
      // required this.minutesPerChallenge,
      required this.isPrivate,
      required this.allowedUsers,
      required this.members,
      required this.admins});

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'groupId': groupId,
      'name': name,
      'description': description,
      'imageUrl': imageUrl,
      'startTime': startTime,
      'endTime': endTime,
      'maxSimultaneousChallenges': maxSimultaneousChallenges,
      // 'minutesPerChallenge': minutesPerChallenge,
      'isPrivate': isPrivate,
      'allowedUsers': allowedUsers,
      'members': members,
      'admins': admins
    };
  }

  factory GroupModel.fromMap(Map<String, dynamic> map) {
    return GroupModel(
        groupId: map['groupId'] as String,
        name: map['name'] as String,
        description: map['description'] as String,
        imageUrl: map['imageUrl'] as String?,
        startTime: map['startTime'] as Timestamp,
        endTime: map['endTime'] as Timestamp,
        maxSimultaneousChallenges: map['maxSimultaneousChallenges'] as int,
        // minutesPerChallenge: map['minutesPerChallenge'] as int,
        isPrivate: map['isPrivate'] as bool,
        allowedUsers: (map['allowedUsers'] as List<dynamic>)
            .map((e) => e as String)
            .toList(),
        members:
            (map['members'] as List<dynamic>).map((e) => e as String).toList(),
        admins:
            (map['admins'] as List<dynamic>).map((e) => e as String).toList());
  }

  String toJson() => json.encode(toMap());

  factory GroupModel.fromJson(String source) =>
      GroupModel.fromMap(json.decode(source) as Map<String, dynamic>);
}

extension GroupXModel on GroupModel {
  GroupEntity toEntity() {
    return GroupEntity(
        groupId: groupId,
        name: name,
        description: description,
        imageUrl: imageUrl,
        startTime: startTime.toDate(),
        endTime: endTime.toDate(),
        maxSimultaneousChallenges: maxSimultaneousChallenges,
        // minutesPerChallenge: minutesPerChallenge,
        isPrivate: isPrivate,
        allowedUsers: allowedUsers,
        members: members,
        admins: admins);
  }
}
