class GroupEntity {
  final String groupId;
  final String name;
  final String description;
  final String? imageUrl;
  final DateTime startTime;
  final DateTime endTime;
  final int maxSimultaneousChallenges;
  // final int minutesPerChallenge;
  final bool isPrivate;
  final List<String> allowedUsers;
  final List<String> members;

  GroupEntity(
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
      required this.members});
}
