import 'package:fitness_project/domain/entities/db/group.dart';
import 'package:fitness_project/presentation/create_group/pages/create_group.dart';
import 'package:fitness_project/presentation/group/pages/group.dart';
import 'package:fitness_project/presentation/home/widgets/add_group_tile.dart';
import 'package:fitness_project/presentation/home/widgets/group_tile.dart';
import 'package:flutter/material.dart';

class YourGroupsList extends StatelessWidget {
  final List<GroupEntity> groups;
  const YourGroupsList({super.key, required this.groups});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 16),
            child: Row(
              children: [
                const Icon(Icons.group, size: 32),
                const SizedBox(
                  width: 8,
                ),
                Text("Your active groups (${groups.length})",
                    style: const TextStyle(
                        fontSize: 20, fontWeight: FontWeight.bold)),
              ],
            ),
          ),
          const SizedBox(
            height: 16,
          ),
          SizedBox(
            height: 100,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 8),
              itemCount: groups.length + 1,
              itemBuilder: (context, index) {
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 4),
                  child: index == 0
                      ? AddGroupTile(
                          hasGroups: groups.isNotEmpty,
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        const CreateGroupPage()));
                          })
                      : GroupTile(
                          group: groups[index - 1],
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => GroupPage(
                                    groupId: groups[index - 1].groupId),
                              ),
                            );
                          }),
                );
              },
            ),
          )
        ],
      ),
    );
  }
}
