class ExerciseEntity {
  final String exerciseId;
  final String name;
  final String description;
  final String? imageUrl;

  ExerciseEntity(
      {required this.exerciseId,
      required this.name,
      required this.description,
      this.imageUrl});
}
