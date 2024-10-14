class UserEntity {
  final String userId;
  final String displayName;
  final String email;
  final String? image;
  final String description;

  UserEntity(
      {required this.userId,
      required this.displayName,
      required this.email,
      this.image,
      required this.description});
}
