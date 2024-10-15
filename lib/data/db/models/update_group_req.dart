class UpdateGroupReq {
  final String groupeId;
  final String? name;
  final String? description;
  final String? imageUrl;
  final DateTime? startTime;
  final DateTime? endTime;
  final int? maxSimultaneousChallenges;
  final int? minutesPerChallenge;
  final bool? isPrivate;

  UpdateGroupReq(
      {required this.groupeId,
      this.name,
      this.description,
      this.imageUrl,
      this.startTime,
      this.endTime,
      this.maxSimultaneousChallenges,
      this.minutesPerChallenge,
      this.isPrivate});

  Map<String, dynamic> toMap() {
    Map<String, dynamic> data = {
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

    // Remove entries where the value is null
    data.removeWhere((key, value) => value == null);

    return data;
  }
}
