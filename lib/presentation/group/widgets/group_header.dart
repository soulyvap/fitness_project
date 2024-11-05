import 'package:firebase_auth/firebase_auth.dart';
import 'package:fitness_project/domain/entities/db/group.dart';
import 'package:flutter/material.dart';

class GroupHeader extends StatelessWidget {
  final GroupEntity group;
  const GroupHeader({super.key, required this.group});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Card(
          color: Colors.grey,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          child: Container(
            width: 120,
            height: 120,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              image: group.imageUrl != null
                  ? DecorationImage(
                      image: NetworkImage(group.imageUrl!),
                      fit: BoxFit.cover,
                    )
                  : null,
            ),
            child: group.imageUrl == null
                ? const Center(
                    child: Icon(
                      Icons.fitness_center,
                      size: 40,
                      color: Colors.white,
                    ),
                  )
                : null,
          ),
        ),
        const SizedBox(
          width: 16,
        ),
        SizedBox(
          height: 120,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Text(
                group.name,
                style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.black),
              ),
              Text(
                group.description,
                style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.normal,
                    color: Colors.black),
              ),
              const Spacer(),
              Row(
                children: [
                  OutlinedButton.icon(
                      onPressed: () {},
                      icon: const Icon(Icons.people),
                      label: Text(
                          "${group.members.length} member${group.members.length > 1 ? "s" : ""}")),
                  if (FirebaseAuth.instance.currentUser?.uid != null &&
                      !group.members
                          .contains(FirebaseAuth.instance.currentUser?.uid))
                    ElevatedButton(onPressed: () {}, child: const Text("Join")),
                ],
              )
            ],
          ),
        )
      ],
    );
  }
}
