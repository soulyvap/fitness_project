class UpdateUserReq {
  final String userId;
  final String? email;
  final String? displayName;
  final String? description;
  final String? image;

  UpdateUserReq(
      {required this.userId,
      this.email,
      this.displayName,
      this.description,
      this.image});

  Map<String, dynamic> toMap() {
    Map<String, dynamic> data = {
      'userId': userId,
      'email': email,
      'displayName': displayName,
      'description': description,
      'image': image,
    };

    // Remove entries where the value is null
    data.removeWhere((key, value) => value == null);

    return data;
  }
}
