import 'package:fitness_project/domain/entities/db/group.dart';
import 'package:flutter/material.dart';

class GroupHeader extends StatelessWidget {
  final GroupEntity group;
  const GroupHeader({super.key, required this.group});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
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
                      label: Text("${group.members.length} members")),
                ],
              )
            ],
          ),
        )
      ],
    );
  }
}
