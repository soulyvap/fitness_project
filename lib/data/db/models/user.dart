import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fitness_project/domain/entities/db/group.dart';

class GroupModel {
  final String groupeId;
  final String name;
  final String description;
  final String imageUrl;
  final Timestamp startTime;
  final Timestamp endTime;
  final int maxSimultaneousChallenges;
  final int minutesPerChallenge;
  final bool isPrivate;

  GroupModel(
      {required this.groupeId,
      required this.name,
      required this.description,
      required this.imageUrl,
      required this.startTime,
      required this.endTime,
      required this.maxSimultaneousChallenges,
      required this.minutesPerChallenge,
      required this.isPrivate});

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'groupeId': groupeId,
      'name': name,
      'description': description,
      'imageUrl': imageUrl,
      'startTime': startTime,
      'endTime': endTime,
      'maxSimultaneousChallenges': maxSimultaneousChallenges,
      'minutesPerChallenge': minutesPerChallenge,
      'isPrivate': isPrivate,
    };
  }

  factory GroupModel.fromMap(Map<String, dynamic> map) {
    return GroupModel(
        groupeId: map['groupeId'] as String,
        name: map['name'] as String,
        description: map['description'] as String,
        imageUrl: map['imageUrl'] as String,
        startTime: map['startTime'] as Timestamp,
        endTime: map['endTime'] as Timestamp,
        maxSimultaneousChallenges: map['maxSimultaneousChallenges'] as int,
        minutesPerChallenge: map['minutesPerChallenge'] as int,
        isPrivate: map['isPrivate'] as bool);
  }

  String toJson() => json.encode(toMap());

  factory GroupModel.fromJson(String source) =>
      GroupModel.fromMap(json.decode(source) as Map<String, dynamic>);
}

extension GroupXModel on GroupModel {
  GroupEntity toEntity() {
    return GroupEntity(
        groupeId: groupeId,
        name: name,
        description: description,
        imageUrl: imageUrl,
        startTime: startTime.toDate(),
        endTime: endTime.toDate(),
        maxSimultaneousChallenges: maxSimultaneousChallenges,
        minutesPerChallenge: minutesPerChallenge,
        isPrivate: isPrivate);
  }
}
