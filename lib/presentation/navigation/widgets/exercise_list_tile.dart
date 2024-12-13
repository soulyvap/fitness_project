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
    bool noUrl = exercise.imageUrl == null || exercise.imageUrl!.isEmpty;
    return ListTile(
      contentPadding: const EdgeInsets.only(left: 4, right: 16),
      dense: true,
      leading: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          color: Colors.grey,
          image: noUrl
              ? null
              : DecorationImage(
                  image: NetworkImage(exercise.imageUrl!),
                  fit: BoxFit.cover,
                ),
        ),
        child: noUrl
            ? const Icon(
                Icons.fitness_center,
                size: 24,
                color: Colors.white,
              )
            : null,
      ),
      title: Text(exercise.name),
      onTap: onTap,
      trailing: trailing,
    );
  }
}
