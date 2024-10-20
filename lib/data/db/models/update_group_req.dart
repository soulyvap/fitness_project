import 'package:cloud_firestore/cloud_firestore.dart';

class UpdateGroupReq {
  final String? groupId;
  final String? name;
  final String? description;
  final String? imageUrl;
  final Timestamp? startTime;
  final Timestamp? endTime;
  final int? maxSimultaneousChallenges;
  // final int? minutesPerChallenge;
  final bool? isPrivate;
  final List<String>? allowedUsers;
  final List<String>? members;

  UpdateGroupReq(
      {this.groupId,
      this.name,
      this.description,
      this.imageUrl,
      this.startTime,
      this.endTime,
      this.maxSimultaneousChallenges,
      // this.minutesPerChallenge,
      this.isPrivate,
      this.allowedUsers,
      this.members});

  Map<String, dynamic> toMap() {
    Map<String, dynamic> data = {
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
      'members': members
    };

    // Remove entries where the value is null
    data.removeWhere((key, value) => value == null);

    return data;
  }
}
