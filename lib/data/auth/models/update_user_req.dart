class UpdateUserReq {
  final String userId;
  final String? displayName;
  final String? description;
  final String? image;

  UpdateUserReq(
      {required this.userId, this.displayName, this.description, this.image});

  Map<String, dynamic> toMap() {
    Map<String, dynamic> data = {
      'displayName': displayName,
      'description': description,
      'image': image,
    };

    // Remove entries where the value is null
    data.removeWhere((key, value) => value == null);

    return data;
  }
}
