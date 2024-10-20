import 'package:fitness_project/domain/entities/db/exercise.dart';
import 'package:flutter/material.dart';

class ExerciseListTile extends StatelessWidget {
  final ExerciseEntity exercise;
  final Widget? trailing;
  final Function()? onTap;
  const ExerciseListTile(
      {super.key, required this.exercise, this.onTap, this.trailing});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          color: Colors.grey,
          image: exercise.imageUrl == null
              ? null
              : DecorationImage(
                  image: NetworkImage(exercise.imageUrl!),
                  fit: BoxFit.cover,
                ),
        ),
      ),
      title: Text(exercise.name),
      onTap: onTap,
      trailing: trailing,
    );
  }
}
