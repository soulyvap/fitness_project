import 'package:firebase_auth/firebase_auth.dart';
import 'package:fitness_project/common/extensions/datetime_extension.dart';
import 'package:fitness_project/common/extensions/int_extension.dart';
import 'package:fitness_project/domain/entities/db/challenge.dart';
import 'package:fitness_project/domain/entities/db/exercise.dart';
import 'package:fitness_project/domain/entities/db/group.dart';
import 'package:fitness_project/domain/entities/db/user.dart';
import 'package:fitness_project/presentation/post_submission/pages/camera.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';

class ChallengeCard extends StatelessWidget {
  final ChallengeEntity challenge;
  final GroupEntity group;
  final ExerciseEntity exercise;
  final UserEntity author;

  const ChallengeCard({
    super.key,
    required this.challenge,
    required this.author,
    required this.group,
    required this.exercise,
  });

  Future<bool> requestCameraPermission() async {
    var status = await Permission.camera.status;
    if (!status.isGranted) {
      await Permission.camera.request();
      return false;
    }
    return true;
  }

  @override
  Widget build(BuildContext context) {
    final completedBy = challenge.completedBy;
    final completedByWithoutAuthor =
        completedBy.where((e) => e != author.userId);
    final currentUserUid = FirebaseAuth.instance.currentUser?.uid;
    final isCompleted = completedBy.contains(currentUserUid);
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
            aspectRatio: 1.2,
            child: Stack(
              children: [
                Container(
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
                      : const Center(
                          child: Icon(Icons.fitness_center, size: 40)),
                ),
                if (isCompleted)
                  Positioned.fill(
                    child: Container(
                      color: Colors.black.withOpacity(0.1),
                      child: const Center(
                        child: Icon(
                          Icons.check_circle,
                          color: Colors.green,
                          size: 160,
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          ),
          ListTile(
            title: Text("${challenge.reps} ${exercise.name}"),
            subtitle: Text("Deadline: ${challenge.endsAt.toDateTimeString()}"),
            trailing: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.check_circle),
                const SizedBox(width: 4),
                Text("${completedByWithoutAuthor.length}",
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                    )),
                const SizedBox(width: 8),
              ],
            ),
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
              if (isCompleted)
                OutlinedButton(
                    onPressed: () {},
                    child: Text("View all posts (${completedBy.length})")),
              const SizedBox(width: 8),
              isCompleted
                  ? ElevatedButton(
                      onPressed: () {}, child: const Text("Watch my post"))
                  : ElevatedButton(
                      onPressed: () async {
                        await requestCameraPermission();
                        if (context.mounted) {
                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) => Camera(
                                  challenge: challenge,
                                  exercise: exercise,
                                  group: group,
                                  author: author)));
                        }
                      },
                      child: const Text("Post an attempt")),
            ]),
          ),
        ],
      ),
    );
  }
}
