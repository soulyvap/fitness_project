import 'package:firebase_auth/firebase_auth.dart';
import 'package:fitness_project/domain/entities/db/group.dart';
import 'package:flutter/material.dart';

class GroupTile extends StatelessWidget {
  final GroupEntity group;
  final Function onTap;
  const GroupTile({super.key, required this.group, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final currentUserId = FirebaseAuth.instance.currentUser?.uid;
    final isMember = group.members.contains(currentUserId);
    final isAllowed = group.allowedUsers.contains(currentUserId);
    final isInvited = isAllowed && !isMember;
    return InkWell(
      onTap: () => onTap(),
      child: SizedBox(
        height: 100,
        width: 100,
        child: Card(
          color: Colors.grey,
          clipBehavior: Clip.hardEdge,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          child: Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color:
                  group.imageUrl == null ? null : Colors.black.withOpacity(0.2),
              image: group.imageUrl != null
                  ? DecorationImage(
                      image: NetworkImage(group.imageUrl!),
                      fit: BoxFit.cover,
                    )
                  : null,
            ),
            child: Stack(
              children: [
                if (group.imageUrl == null)
                  const Center(
                    child: Icon(
                      Icons.fitness_center,
                      size: 40,
                      color: Colors.white,
                    ),
                  ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        const Spacer(),
                        if (isInvited)
                          Card(
                            margin: const EdgeInsets.all(0),
                            color: Theme.of(context).colorScheme.secondary,
                            child: const Padding(
                              padding: EdgeInsets.all(4),
                              child: Padding(
                                padding: EdgeInsets.symmetric(horizontal: 4),
                                child: Text(
                                  "Join?",
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 11,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                          ),
                      ],
                    ),
                    Text(
                      group.name,
                      maxLines: 2,
                      style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 11,
                          height: 1,
                          shadows: [
                            Shadow(
                              color: Colors.black,
                              offset: Offset(1, 1),
                              blurRadius: 2,
                            )
                          ]),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
