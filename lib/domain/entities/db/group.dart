class GroupEntity {
  final String groupeId;
  final String name;
  final String description;
  final String imageUrl;
  final DateTime startTime;
  final DateTime endTime;
  final int maxSimultaneousChallenges;
  final int minutesPerChallenge;
  final bool isPrivate;

  GroupEntity({
    required this.groupeId,
    required this.name,
    required this.description,
    required this.imageUrl,
    required this.startTime,
    required this.endTime,
    required this.maxSimultaneousChallenges,
    required this.minutesPerChallenge,
    required this.isPrivate,
  });
}
