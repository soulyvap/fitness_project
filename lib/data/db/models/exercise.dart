import 'package:fitness_project/domain/entities/db/exercise.dart';

class ExerciseModel {
  final String exerciseId;
  final String name;
  final String description;
  final String? imageUrl;

  ExerciseModel(
      {required this.exerciseId,
      required this.name,
      required this.description,
      this.imageUrl});

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'exerciseId': exerciseId,
      'name': name,
      'description': description,
      'imageUrl': imageUrl
    };
  }

  factory ExerciseModel.fromMap(Map<String, dynamic> map) {
    return ExerciseModel(
        exerciseId: map['exerciseId'] as String,
        name: map['name'] as String,
        description: map['description'] as String,
        imageUrl: map['imageUrl'] as String?);
  }
}

extension ExerciseXModel on ExerciseModel {
  ExerciseEntity toEntity() {
    return ExerciseEntity(
        exerciseId: exerciseId,
        name: name,
        description: description,
        imageUrl: imageUrl);
  }
}
