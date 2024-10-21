import 'package:fitness_project/common/extensions/datetime_extension.dart';
import 'package:fitness_project/domain/entities/db/challenge.dart';
import 'package:fitness_project/domain/entities/db/exercise.dart';
import 'package:fitness_project/domain/entities/db/group.dart';
import 'package:fitness_project/domain/entities/db/user.dart';
import 'package:fitness_project/presentation/create_group/pages/settings_form.dart';
import 'package:flutter/material.dart';

class ChallengeCard extends StatelessWidget {
  final ChallengeEntity challenge;
  final GroupEntity group;
  final ExerciseEntity exercise;
  final UserEntity author;
  const ChallengeCard(
      {super.key,
      required this.challenge,
      required this.author,
      required this.group,
      required this.exercise});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Column(
        children: [
          ListTile(
            leading: CircleAvatar(
              radius: 30,
              backgroundColor: Colors.grey,
              backgroundImage:
                  author.image == null ? null : NetworkImage(author.image!),
              child: author.image == null
                  ? Center(
                      child: Text(
                        author.displayName[0].toUpperCase(),
                        style: const TextStyle(fontSize: 24),
                      ),
                    )
                  : null,
            ),
            title: Text(author.displayName),
            subtitle: Text(group.name),
          ),
          AspectRatio(
            aspectRatio: 1,
            child: Container(
              width: double.infinity,
              decoration: BoxDecoration(
                color: Colors.grey,
                image: exercise.imageUrl == null
                    ? null
                    : DecorationImage(
                        image: NetworkImage(exercise.imageUrl!),
                        fit: BoxFit.cover,
                      ),
              ),
              child: exercise.imageUrl != null
                  ? null
                  : const Center(child: Icon(Icons.fitness_center, size: 40)),
            ),
          ),
          ListTile(
            title: Text("${challenge.reps} ${exercise.name}"),
            subtitle: Text("Deadline: ${challenge.endsAt.toDateTimeString()}"),
          ),
          Container(
            padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
            width: double.infinity,
            child: challenge.extraInstructions == null
                ? null
                : Text(
                    "\"${challenge.extraInstructions}\"",
                    style: const TextStyle(fontStyle: FontStyle.italic),
                  ),
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(mainAxisAlignment: MainAxisAlignment.end, children: [
              OutlinedButton(
                  onPressed: () {}, child: const Text("View posts (2)")),
              const SizedBox(width: 8),
              ElevatedButton(
                  onPressed: () {}, child: const Text("Post an attempt"))
            ]),
          ),
        ],
      ),
    );
  }
}
