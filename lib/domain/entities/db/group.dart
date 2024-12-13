class GroupEntity {
  final String groupId;
  final String name;
  final String description;
  final String? imageUrl;
  final DateTime startTime;
  final DateTime endTime;
  // final int maxSimultaneousChallenges;
  // final int minutesPerChallenge;
  final bool isPrivate;
  final List<String> allowedUsers;
  final List<String> members;
  final List<String> admins;

  GroupEntity(
      {required this.groupId,
      required this.name,
      required this.description,
      this.imageUrl,
      required this.startTime,
      required this.endTime,
      // required this.maxSimultaneousChallenges,
      // required this.minutesPerChallenge,
      required this.isPrivate,
      required this.allowedUsers,
      required this.members,
      required this.admins});

  GroupEntity copyWith({
    String? groupId,
    String? name,
    String? description,
    String? imageUrl,
    DateTime? startTime,
    DateTime? endTime,
    // int? maxSimultaneousChallenges,
    // int? minutesPerChallenge,
    bool? isPrivate,
    List<String>? allowedUsers,
    List<String>? members,
    List<String>? admins,
  }) {
    return GroupEntity(
      groupId: groupId ?? this.groupId,
      name: name ?? this.name,
      description: description ?? this.description,
      imageUrl: imageUrl ?? this.imageUrl,
      startTime: startTime ?? this.startTime,
      endTime: endTime ?? this.endTime,
      // maxSimultaneousChallenges:
      // maxSimultaneousChallenges ?? this.maxSimultaneousChallenges,
      // minutesPerChallenge: minutesPerChallenge ?? this.minutesPerChallenge,
      isPrivate: isPrivate ?? this.isPrivate,
      allowedUsers: allowedUsers ?? this.allowedUsers,
      members: members ?? this.members,
      admins: admins ?? this.admins,
    );
  }
}
